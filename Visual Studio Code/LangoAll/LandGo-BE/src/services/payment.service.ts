import { Types } from "mongoose";
import { Payment, Post } from "../models";
import { create as createNotification } from "./notification.service";
import {
  IPayment,
  CreatePaymentInput,
  ReviewPaymentInput,
  PaginatedResult,
  NotificationType,
  PaymentStatus,
  PostStatus,
  CreateSepayPaymentInput,
} from "../types";
import { AppError } from "../utils/AppError";
import { config } from "../config";

const PIN_PRICES: Record<number, Record<string, number>> = {
  1: { week: 2000, month: 3000, year: 4000 },
  2: { week: 3000, month: 4000, year: 5000 },
};

const getPinPrice = (pinLevel: number, durationType: string) => {
  const amount = PIN_PRICES[pinLevel]?.[durationType];
  if (!amount) throw new AppError("Invalid pinLevel or durationType", 400);
  return amount;
};

export const createPayment = async (
  input: CreatePaymentInput,
  userId: Types.ObjectId,
): Promise<IPayment> => {
  const post = await Post.findById(input.postId).select("author status");
  if (!post) throw new AppError("Post not found", 404);
  if (post.author.toString() !== userId.toString())
    throw new AppError("Not your post", 403);
  if (post.status !== PostStatus.Active)
    throw new AppError("Post must be active", 400);

  if (!input.transferImage)
    throw new AppError("Transfer proof image is required", 400);

  const amount = getPinPrice(input.pinLevel, input.durationType);

  return Payment.create({
    user: userId,
    post: input.postId,
    pinLevel: input.pinLevel,
    durationType: input.durationType,
    amount,
    transferImage: input.transferImage,
  });
};

const buildSepayQrUrl = (amount: number, transactionCode: string) => {
  const params = new URLSearchParams({
    acc: config.sepayAccount ?? "",
    bank: config.sepayBank ?? "",
    amount: amount.toString(),
    des: transactionCode,
  });

  return `${config.sepayBaseQrUrl}?${params.toString()}`;
};

export const createSepayPayment = async (
  input: CreateSepayPaymentInput,
  userId: Types.ObjectId,
): Promise<IPayment> => {
  const post = await Post.findById(input.postId).select("author status");
  if (!post) throw new AppError("Post not found", 404);
  if (post.author.toString() !== userId.toString())
    throw new AppError("Not your post", 403);
  if (post.status !== PostStatus.Active)
    throw new AppError("Post must be active", 400);

  if (!config.sepayAccount || !config.sepayBank || !config.sepayApiToken) {
    throw new AppError("Sepay configuration missing", 500);
  }

  const amount = getPinPrice(input.pinLevel, input.durationType);
  const transactionCode = `PIN${input.postId}${Date.now()}`;
  const qrImageUrl = buildSepayQrUrl(amount, transactionCode);

  return Payment.create({
    user: userId,
    post: input.postId,
    pinLevel: input.pinLevel,
    durationType: input.durationType,
    amount,
    method: "sepay_qr",
    transactionCode,
    qrImageUrl,
  });
};

export const getPayments = async (query: {
  status?: string;
  page?: string;
  limit?: string;
}): Promise<PaginatedResult<IPayment>> => {
  const status = query.status ?? "pending";
  const page = Number(query.page ?? 1);
  const limit = Number(query.limit ?? 20);
  const skip = (page - 1) * limit;

  const [data, total] = await Promise.all([
    Payment.find({ status })
      .sort({ createdAt: -1 })
      .skip(skip)
      .limit(limit)
      .populate("user", "name phone")
      .populate("post", "title slug")
      .lean(),
    Payment.countDocuments({ status }),
  ]);

  return {
    data: data as unknown as IPayment[],
    total,
    page,
    limit,
    pages: Math.ceil(total / limit),
  };
};

export const getPaymentById = async (
  paymentId: string,
  userId: Types.ObjectId,
): Promise<IPayment> => {
  const payment = await Payment.findById(paymentId).populate(
    "post",
    "title slug",
  );
  if (!payment) throw new AppError("Payment not found", 404);
  if (payment.user.toString() !== userId.toString())
    throw new AppError("Not your payment", 403);
  return payment as unknown as IPayment;
};

const applyPinForPayment = async (
  payment: IPayment,
  moderatorId?: Types.ObjectId,
) => {
  const pinExpiresAt = new Date();
  pinExpiresAt.setDate(pinExpiresAt.getDate() + payment.durationDays);

  await Post.findByIdAndUpdate(payment.post, {
    isPinned: true,
    pinLevel: payment.pinLevel,
    pinExpiredAt: pinExpiresAt,
  });

  await createNotification({
    userId: payment.user as Types.ObjectId,
    type: NotificationType.PaymentApproved,
    referenceId: payment._id,
    message: `Your pin payment was approved. Listing pinned until ${pinExpiresAt.toLocaleDateString()}.`,
  });

  payment.status = PaymentStatus.Paid;
  payment.approvedBy = moderatorId ?? null;
  payment.approvedAt = new Date();
  payment.pinExpiresAt = pinExpiresAt;

  await payment.save();
};

export const reviewPayment = async (
  paymentId: string,
  input: ReviewPaymentInput,
  moderatorId: Types.ObjectId,
): Promise<IPayment> => {
  const payment = await Payment.findById(paymentId);
  if (!payment) throw new AppError("Payment not found", 404);

  if (input.action === "approve") {
    await applyPinForPayment(payment, moderatorId);
  } else if (input.action === "reject") {
    payment.status = PaymentStatus.Rejected;
    payment.rejectionReason =
      input.rejectionReason ?? "Payment could not be verified";
  } else {
    throw new AppError("Invalid action", 400);
  }

  if (payment.status !== PaymentStatus.Paid) await payment.save();
  return payment;
};

type SepayWebhookPayload = {
  des?: string;
  description?: string;
  amount?: number;
  status?: string;
};

export const handleSepayWebhook = async (
  payload: SepayWebhookPayload,
): Promise<void> => {
  const rawDescription = payload.des || payload.description;
  if (!rawDescription) throw new AppError("Missing transaction code", 400);

  const match = rawDescription.match(/PIN[a-f0-9]+/i);
  const transactionCode = match?.[0];

  if (!transactionCode) throw new AppError("Transaction PIN not found", 400);

  const payment = await Payment.findOne({
    transactionCode,
    method: "sepay_qr",
  });
  if (!payment) throw new AppError("Payment not found", 404);

  if (payment.status === PaymentStatus.Paid) return;

  await applyPinForPayment(payment as unknown as IPayment);
};
