/**
 * schemas.ts
 * ─────────────────────────────────────────────────────────────────────────────
 * All Mongoose schema definitions in one file.
 * Models are registered in models/index.ts.
 * ─────────────────────────────────────────────────────────────────────────────
 */

import mongoose, { Schema } from "mongoose";
import bcrypt from "bcryptjs";
import { parsePhoneNumberFromString } from "libphonenumber-js";
import {
  IUser,
  IPost,
  IVote,
  IComment,
  IReport,
  IPayment,
  INotification,
  UserRole,
  PropertyType,
  PostStatus,
  ReportTargetType,
  ReportStatus,
  PaymentDurationType,
  PaymentStatus,
  NotificationType,
  IProvince,
  IDistrict,
  IWard,
} from "../types";

// ══════════════════════════════════════════════════════════════════════════════
// USER SCHEMA
// ══════════════════════════════════════════════════════════════════════════════

const normalizePhoneVN = (value: string): string => {
  const parsed = parsePhoneNumberFromString(value?.trim() ?? "", "VN");
  if (!parsed || !parsed.isValid() || parsed.country !== "VN") return value;
  return `0${parsed.nationalNumber}`;
};

const isStrictValidVietnamPhone = (value: string): boolean => {
  const parsed = parsePhoneNumberFromString(value?.trim() ?? "", "VN");
  return !!parsed && parsed.isValid() && parsed.country === "VN";
};

export const userSchema = new Schema<IUser>(
  {
    phone: {
      type: String,
      required: [true, "Phone number is required"],
      unique: true,
      trim: true,
      set: normalizePhoneVN,
      validate: {
        validator: (value: string) => isStrictValidVietnamPhone(value),
        message: "Invalid Vietnamese phone number format",
      },
    },
    email: {
      type: String,
      unique: true,
      sparse: true,
      lowercase: true,
      trim: true,
      match: [/^\S+@\S+\.\S+$/, "Invalid email format"],
    },
    password: {
      type: String,
      required: [true, "Password is required"],
      minlength: 6,
      select: false,
    },
    name: {
      type: String,
      required: [true, "Name is required"],
      trim: true,
      maxlength: 100,
    },
    avatar: { type: String, default: null },
    role: {
      type: String,
      enum: Object.values(UserRole),
      default: UserRole.User,
    },
    description: { type: String, required: true, maxlength: 10000 },

    isPhoneVerified: { type: Boolean, default: false },
    isEmailVerified: { type: Boolean, default: false },
    isBanned: { type: Boolean, default: false },
    totalScoreReceived: { type: Number, default: 0 },

    phoneOtp: { type: String, select: false },
    phoneOtpExpires: { type: Date, select: false },
    emailVerifyToken: { type: String, select: false },
    emailVerifyExpires: { type: Date, select: false },
    passwordResetToken: { type: String, select: false },
    passwordResetExpires: { type: Date, select: false },
    refreshToken: { type: String, select: false },

    province: { type: Schema.Types.ObjectId, ref: "Province", required: true },
    district: { type: Schema.Types.ObjectId, ref: "District", required: true },
    ward: { type: Schema.Types.ObjectId, ref: "Ward", required: true },
    addressDetail: { type: String, trim: true, maxlength: 500 },

    deletedAt: { type: Date, default: null },
  },
  {
    timestamps: true,
    toJSON: { virtuals: true },
    toObject: { virtuals: true },
  },
);

userSchema.index({ phone: 1 }, { unique: true });
userSchema.index({ email: 1 }, { unique: true, sparse: true });
userSchema.index({ deletedAt: 1 });
userSchema.index({ role: 1 });
userSchema.index({ totalScoreReceived: -1 });

userSchema.pre("save", async function (next) {
  if (!this.isModified("password")) return next();
  this.password = await bcrypt.hash(this.password, 12);
  next();
});

userSchema.methods.comparePassword = async function (
  candidate: string,
): Promise<boolean> {
  return bcrypt.compare(candidate, this.password as string);
};

userSchema.pre(
  /^find/,
  function (this: mongoose.Query<unknown, unknown>, next) {
    if (!this.getOptions().includeSoftDeleted) this.where({ deletedAt: null });
    next();
  },
);

userSchema.virtual("isDeleted").get(function (this: IUser) {
  return this.deletedAt !== null;
});

// ══════════════════════════════════════════════════════════════════════════════
// POST SCHEMA
// ══════════════════════════════════════════════════════════════════════════════

export const postSchema = new Schema<IPost>(
  {
    title: { type: String, required: true, trim: true, maxlength: 200 },
    slug: { type: String, unique: true, lowercase: true, trim: true },
    description: { type: String, required: true, maxlength: 10000 },
    province: { type: Schema.Types.ObjectId, ref: "Province", required: true },
    district: { type: Schema.Types.ObjectId, ref: "District", required: true },
    ward: { type: Schema.Types.ObjectId, ref: "Ward", required: true },
    addressDetail: { type: String, trim: true, maxlength: 500 },

    area: { type: Number, required: true, min: 0 },
    price: { type: Number, required: true, min: 0 },
    lat: { type: Number, required: true },
    lng: { type: Number, required: true },
    frontage: { type: Number },
    entryWidth: { type: Number },
    direction: { type: String, trim: true, maxlength: 50 },
    floorNumber: { type: Number },
    numberOfBedrooms: { type: Number, required: true, min: 0 },
    numberOfBathrooms: { type: Number, required: true, min: 0 },
    propertyType: {
      type: String,
      enum: Object.values(PropertyType),
      required: true,
    },
    legalStatus: { type: String,  trim: true, maxlength: 200 },
    isNegotiable: { type: Boolean, default: false },

    images: { type: [String], default: [] },
    redBookImages: {
      type: [String],
      validate: {
        validator: (v: string[]) => v && v.length >= 1,
        message: "At least 1 red book image is required",
      },
    },

        author: { type: Schema.Types.ObjectId, ref: 'User', required: true },
        status: { type: String, enum: Object.values(PostStatus), default: PostStatus.Active },
    rejectionReason: { type: String, default: null },
    approvedBy: { type: Schema.Types.ObjectId, ref: "User", default: null },
    approvedAt: { type: Date, default: null },

    upvoteCount: { type: Number, default: 0, min: 0 },
    downvoteCount: { type: Number, default: 0, min: 0 },
    score: { type: Number, default: 0 },
    commentCount: { type: Number, default: 0, min: 0 },
    viewCount: { type: Number, default: 0, min: 0 },

    isPinned: { type: Boolean, default: false },
    pinLevel: { type: Number, enum: [1, 2], default: null },
    pinExpiredAt: { type: Date, default: null },

    deletedAt: { type: Date, default: null },
  },
  {
    timestamps: true,
    toJSON: { virtuals: true },
    toObject: { virtuals: true },
  },
);

postSchema.index({ slug: 1 }, { unique: true });
postSchema.index({ province: 1, district: 1 });
postSchema.index({ price: 1 });
postSchema.index({ score: -1 });
postSchema.index({ createdAt: -1 });
postSchema.index({ status: 1 });
postSchema.index({ author: 1 });
postSchema.index({ deletedAt: 1 });
postSchema.index({ pinExpiredAt: 1 }, { sparse: true });
postSchema.index(
  { isPinned: -1, pinLevel: -1, score: -1, createdAt: -1 },
  { name: "idx_homepage_feed" },
);
postSchema.index(
  { title: "text", description: "text" },
  { name: "idx_text_search", weights: { title: 10, description: 5 } },
);
postSchema.index({ province: 1, propertyType: 1, price: 1, score: -1 });

postSchema.pre(
  /^find/,
  function (this: mongoose.Query<unknown, unknown>, next) {
    if (!this.getOptions().includeSoftDeleted) this.where({ deletedAt: null });
    next();
  },
);

postSchema.virtual("isExpiredPin").get(function (this: IPost) {
  if (!this.isPinned || !this.pinExpiredAt) return false;
  return new Date() > this.pinExpiredAt;
});

// ══════════════════════════════════════════════════════════════════════════════
// VOTE SCHEMA
// ══════════════════════════════════════════════════════════════════════════════

export const voteSchema = new Schema<IVote>(
  {
    user: { type: Schema.Types.ObjectId, ref: "User", required: true },
    post: { type: Schema.Types.ObjectId, ref: "Post", required: true },
    value: { type: Number, enum: [1, -1], required: true },
  },
  { timestamps: true },
);

voteSchema.index(
  { user: 1, post: 1 },
  { unique: true, name: "idx_user_post_vote" },
);
voteSchema.index({ post: 1 });
voteSchema.index({ user: 1 });

// ══════════════════════════════════════════════════════════════════════════════
// COMMENT SCHEMA
// ══════════════════════════════════════════════════════════════════════════════

export const commentSchema = new Schema<IComment>(
  {
    post: { type: Schema.Types.ObjectId, ref: "Post", required: true },
    user: { type: Schema.Types.ObjectId, ref: "User", required: true },
    content: {
      type: String,
      required: [true, "Content is required"],
      trim: true,
      maxlength: 2000,
    },
    parentComment: {
      type: Schema.Types.ObjectId,
      ref: "Comment",
      default: null,
    },
    deletedAt: { type: Date, default: null },
  },
  {
    timestamps: true,
    toJSON: { virtuals: true },
    toObject: { virtuals: true },
  },
);

commentSchema.index({ post: 1, createdAt: -1 });
commentSchema.index({ post: 1, parentComment: 1 });
commentSchema.index({ user: 1 });
commentSchema.index({ deletedAt: 1 });

commentSchema.pre(
  /^find/,
  function (this: mongoose.Query<unknown, unknown>, next) {
    if (!this.getOptions().includeSoftDeleted) this.where({ deletedAt: null });
    next();
  },
);

commentSchema.post("save", async function (this: IComment) {
  if (!this.isNew) return;
  await mongoose
    .model("Post")
    .findByIdAndUpdate(this.post, { $inc: { commentCount: 1 } });
});

// ══════════════════════════════════════════════════════════════════════════════
// REPORT SCHEMA
// ══════════════════════════════════════════════════════════════════════════════

export const reportSchema = new Schema<IReport>(
  {
    reporter: { type: Schema.Types.ObjectId, ref: "User", required: true },
    targetType: {
      type: String,
      enum: Object.values(ReportTargetType),
      required: true,
    },
    targetPost: { type: Schema.Types.ObjectId, ref: "Post", default: null },
    targetUser: { type: Schema.Types.ObjectId, ref: "User", default: null },
    reason: {
      type: String,
      required: [true, "Reason is required"],
      trim: true,
      maxlength: 1000,
    },
    status: {
      type: String,
      enum: Object.values(ReportStatus),
      default: ReportStatus.Pending,
    },
    handledBy: { type: Schema.Types.ObjectId, ref: "User", default: null },
    handledAt: { type: Date, default: null },
    moderatorNote: { type: String, default: null, maxlength: 1000 },
  },
  { timestamps: true },
);

reportSchema.index({ status: 1, createdAt: -1 });
reportSchema.index({ reporter: 1 });
reportSchema.index({ targetPost: 1 }, { sparse: true });
reportSchema.index({ targetUser: 1 }, { sparse: true });

reportSchema.pre("save", function (this: IReport, next) {
  if (this.targetType === ReportTargetType.Post && !this.targetPost)
    return next(new Error("targetPost is required when targetType is post"));
  if (this.targetType === ReportTargetType.User && !this.targetUser)
    return next(new Error("targetUser is required when targetType is user"));
  next();
});

// ══════════════════════════════════════════════════════════════════════════════
// PAYMENT SCHEMA
// ══════════════════════════════════════════════════════════════════════════════

const DURATION_DAYS: Record<PaymentDurationType, number> = {
  [PaymentDurationType.Week]: 7,
  [PaymentDurationType.Month]: 30,
  [PaymentDurationType.Year]: 365,
};

export const paymentSchema = new Schema<IPayment>(
  {
    user: { type: Schema.Types.ObjectId, ref: "User", required: true },
    post: { type: Schema.Types.ObjectId, ref: "Post", required: true },
    pinLevel: { type: Number, enum: [1, 2], required: true },
    durationType: {
      type: String,
      enum: Object.values(PaymentDurationType),
      required: true,
    },
    durationDays: { type: Number },
    amount: { type: Number, required: true, min: 0 },
    method: {
      type: String,
      enum: ["manual_transfer", "sepay_qr"],
      default: "manual_transfer",
    },
    transferImage: {
      type: String,
      required: false,
      default: null,
    },
    transactionCode: { type: String, default: null, unique: true, sparse: true },
    qrImageUrl: { type: String, default: null },
    status: {
      type: String,
      enum: Object.values(PaymentStatus),
      default: PaymentStatus.Pending,
    },
    approvedBy: { type: Schema.Types.ObjectId, ref: "User", default: null },
    approvedAt: { type: Date, default: null },
    rejectionReason: { type: String, default: null },
    pinExpiresAt: { type: Date, default: null },
  },
  { timestamps: true },
);

paymentSchema.index({ status: 1, createdAt: -1 });
paymentSchema.index({ user: 1 });
paymentSchema.index({ post: 1 });

paymentSchema.pre("save", function (this: IPayment, next) {
  if (this.isNew) this.durationDays = DURATION_DAYS[this.durationType];
  next();
});

// ══════════════════════════════════════════════════════════════════════════════
// NOTIFICATION SCHEMA
// ══════════════════════════════════════════════════════════════════════════════

export const notificationSchema = new Schema<INotification>(
  {
    user: { type: Schema.Types.ObjectId, ref: "User", required: true },
    type: {
      type: String,
      enum: Object.values(NotificationType),
      required: true,
    },
    referenceId: { type: Schema.Types.ObjectId, required: true },
    message: { type: String, required: true, maxlength: 500 },
    isRead: { type: Boolean, default: false },
  },
  { timestamps: true },
);

notificationSchema.index({ user: 1, isRead: 1, createdAt: -1 });
notificationSchema.index({ user: 1, createdAt: -1 });
notificationSchema.index(
  { createdAt: 1 },
  { expireAfterSeconds: 60 * 60 * 24 * 90 },
);

// ══════════════════════════════════════════════════════════════════════════════
// LOCATION SCHEMA
// ══════════════════════════════════════════════════════════════════════════════
export const provinceSchema = new Schema<IProvince>({
  name: { type: String, required: true, unique: true },
  code: { type: String, required: true, unique: true },
});

export const districtSchema = new Schema<IDistrict>({
  code: { type: String, required: true },
  name: { type: String, required: true },
  province: { type: Schema.Types.ObjectId, ref: "Province", required: true },
});

export const wardSchema = new Schema<IWard>({
  code: { type: String, required: true },
  name: { type: String, required: true },
  province: { type: Schema.Types.ObjectId, ref: "Province", required: true },
  district: { type: Schema.Types.ObjectId, ref: "District", required: true },
});

districtSchema.index({ province: 1, code: 1 }, { unique: true });
districtSchema.index({ province: 1, name: 1 }, { unique: true });
wardSchema.index({ district: 1, code: 1 }, { unique: true });
wardSchema.index({ province: 1, district: 1, name: 1 }, { unique: true });
