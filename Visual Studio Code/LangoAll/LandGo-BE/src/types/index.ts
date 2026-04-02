import { Types, Document } from "mongoose";

// ══════════════════════════════════════════════════════════════════════════════
// ENUMS
// ══════════════════════════════════════════════════════════════════════════════

export enum UserRole {
  User = "user",
  Moderator = "moderator",
}

export enum PropertyType {
  Apartment = "apartment",
  House = "house",
  Land = "land",
  Villa = "villa",
}

export enum PostStatus {
  Pending = "pending",
  Approved = "approved",
  Rejected = "rejected",
  Sold = "sold",
  Expired = "expired",
  Active = "active",
  Inactive = "inactive",
}

export enum ReportTargetType {
  Post = "post",
  User = "user",
}

export enum ReportStatus {
  Pending = "pending",
  Reviewing = "reviewing",
  Resolved = "resolved",
  Rejected = "rejected",
}

export enum PaymentDurationType {
  Week = "week",
  Month = "month",
  Year = "year",
}

export enum PaymentStatus {
  Pending = "pending",
  Paid = "paid",
  Rejected = "rejected",
}
export type PaymentMethod = "manual_transfer" | "sepay_qr";

export enum NotificationType {
  Comment = "comment",
  PostApproved = "post_approved",
  PostRejected = "post_rejected",
  PaymentApproved = "payment_approved",
  VoteReceived = "vote_received",
}

// ══════════════════════════════════════════════════════════════════════════════
// DOCUMENT INTERFACES  (what Mongoose returns)
// ══════════════════════════════════════════════════════════════════════════════

export interface IUser extends Document {
  _id: Types.ObjectId;
  phone: string;
  email?: string | null;
  password: string;
  name: string;
  avatar: string | null;
  role: UserRole;
  isPhoneVerified: boolean;
  isEmailVerified: boolean;
  isBanned: boolean;
  totalScoreReceived: number;
  phoneOtp?: string;
  phoneOtpExpires?: Date;
  emailVerifyToken?: string;
  emailVerifyExpires?: Date;
  passwordResetToken?: string;
  passwordResetExpires?: Date;
  refreshToken?: string;
  deletedAt: Date | null;
  createdAt: Date;
  updatedAt: Date;
  province?: Types.ObjectId;
  district?: Types.ObjectId;
  ward?: Types.ObjectId;
  addressDetail?: String;
  description?: String;
  // Instance method
  comparePassword(candidate: string): Promise<boolean>;
}

export interface IPost extends Document {
  _id: Types.ObjectId;
  title: string;
  slug: string;
  description: string;
  price: number;
  area: number;
  province: Types.ObjectId;
  district: Types.ObjectId;
  ward: Types.ObjectId;
  addressDetail?: string;
  lat: number;
  lng: number;
  frontage?: number;
  entryWidth?: number;
  direction?: string;
  floorNumber?: number;
  numberOfBedrooms: number;
  numberOfBathrooms: number;
  propertyType: PropertyType;
  legalStatus: string;
  isNegotiable: boolean;
  images: string[];
  redBookImages: string[];
  author: Types.ObjectId | IUser;
  status: PostStatus;
  rejectionReason: string | null;
  approvedBy: Types.ObjectId | IUser | null;
  approvedAt: Date | null;
  upvoteCount: number;
  downvoteCount: number;
  score: number;
  commentCount: number;
  viewCount: number;
  isPinned: boolean;
  pinLevel: 1 | 2 | null;
  pinExpiredAt: Date | null;
  deletedAt: Date | null;
  createdAt: Date;
  updatedAt: Date;
}

export interface IVote extends Document {
  _id: Types.ObjectId;
  user: Types.ObjectId | IUser;
  post: Types.ObjectId | IPost;
  value: 1 | -1;
  createdAt: Date;
  updatedAt: Date;
}

export interface IComment extends Document {
  _id: Types.ObjectId;
  post: Types.ObjectId | IPost;
  user: Types.ObjectId | IUser;
  content: string;
  parentComment: Types.ObjectId | IComment | null;
  deletedAt: Date | null;
  createdAt: Date;
  updatedAt: Date;
}

export interface IReport extends Document {
  _id: Types.ObjectId;
  reporter: Types.ObjectId | IUser;
  targetType: ReportTargetType;
  targetPost: Types.ObjectId | IPost | null;
  targetUser: Types.ObjectId | IUser | null;
  reason: string;
  status: ReportStatus;
  handledBy: Types.ObjectId | IUser | null;
  handledAt: Date | null;
  moderatorNote: string | null;
  createdAt: Date;
  updatedAt: Date;
}

export interface IPayment extends Document {
  _id: Types.ObjectId;
  user: Types.ObjectId | IUser;
  post: Types.ObjectId | IPost;
  pinLevel: 1 | 2;
  durationType: PaymentDurationType;
  durationDays: number;
  amount: number;
  method: PaymentMethod;
  transferImage?: string | null;
  transactionCode?: string | null;
  qrImageUrl?: string | null;
  status: PaymentStatus;
  approvedBy: Types.ObjectId | IUser | null;
  approvedAt: Date | null;
  rejectionReason: string | null;
  pinExpiresAt: Date | null;
  createdAt: Date;
  updatedAt: Date;
}

export interface INotification extends Document {
  _id: Types.ObjectId;
  user: Types.ObjectId | IUser;
  type: NotificationType;
  referenceId: Types.ObjectId;
  message: string;
  isRead: boolean;
  createdAt: Date;
  updatedAt: Date;
}
export interface IProvince extends Document {
  name: string;
  code: string;
}

export interface IDistrict extends Document {
  code: string;
  name: string;
  province: Types.ObjectId;
}

export interface IWard extends Document {
  code: string;
  name: string;
  district: Types.ObjectId;
  province: Types.ObjectId;
}
// ══════════════════════════════════════════════════════════════════════════════
// SERVICE INPUT / RETURN TYPES
// ══════════════════════════════════════════════════════════════════════════════

export interface RegisterInput {
  phone: string;
  email: string;
  password: string;
  confirmPassword: string;
  name: string;
  provinceCode: string;
  provinceName: string;
  districtCode: string;
  districtName: string;
  wardCode: string;
  wardName: string;
  addressDetail?: string;
}

export interface VerifyEmailOtpInput {
  email: string;
  otp: string;
}

export interface LoginInput {
  phone: string;
  password: string;
}

export interface VerifyPhoneInput {
  phone: string;
  otp: string;
}

export interface ResendOtpInput {
  phone: string;
}

export interface ForgotPasswordInput {
  email: string;
}

export interface ResetPasswordWithOtpInput {
  email: string;
  otp: string;
  password: string;
  confirmPassword: string;
}

export interface AuthTokenPayload {
  token: string;
  user: {
    id: string;
    name: string;
    email: string | null;
    phone: string;
    role: UserRole;
    avatar: string | null;
  };
}

export interface LoginPayload {
  accessToken: string;
  refreshToken: string;
  user: {
    id: string;
    name: string;
    email: string | null;
    phone: string;
    role: UserRole;
    avatar: string | null;
  };
}

export interface GetPostsQuery {
  page?: string;
  limit?: string;
  status?: string;
  includeInactive?: string;
  province?: string;
  district?: string;
  ward?: string;
  addressDetail?: string;
  propertyType?: PropertyType;
  minPrice?: string;
  maxPrice?: string;
  minArea?: string;
  maxArea?: string;
  search?: string;
  sortBy?: "feed" | "newest" | "price_asc" | "price_desc";
}

export interface CreatePostInput {
  title: string;
  description: string;
  price: number;
  area: number;
  province: string;
  district: string;
  ward: string;
  addressDetail?: string;
  lat: number;
  lng: number;
  frontage?: number;
  entryWidth?: number;
  direction?: string;
  floorNumber?: number;
  numberOfBedrooms: number;
  numberOfBathrooms: number;
  propertyType: PropertyType;
  isNegotiable?: boolean;
  images?: string[];
  redBookImages: string[];
}

export interface UpdatePostInput extends Partial<CreatePostInput> {
  existingImages?: string[];
  existingRedBookImages?: string[];
}

export interface ReviewPostInput {
  action: "approve" | "reject";
  rejectionReason?: string;
}

export interface CreateCommentInput {
  postId: string;
  content: string;
  parentComment?: string;
}

export interface CreateReportInput {
  targetType: ReportTargetType;
  targetPost?: string;
  targetUser?: string;
  reason: string;
}

export interface HandleReportInput {
  action: "reviewing" | "resolved" | "rejected";
  moderatorNote?: string;
}

export interface CreatePaymentInput {
  postId: string;
  pinLevel: 1 | 2;
  durationType: PaymentDurationType;
  transferImage: string;
}

export interface CreateSepayPaymentInput {
  postId: string;
  pinLevel: 1 | 2;
  durationType: PaymentDurationType;
}

export interface ReviewPaymentInput {
  action: "approve" | "reject";
  rejectionReason?: string;
}

export interface CreateNotificationInput {
  userId: Types.ObjectId;
  type: NotificationType;
  referenceId: Types.ObjectId;
  message: string;
}

export interface PaginatedResult<T> {
  data: T[];
  total: number;
  page: number;
  limit: number;
  pages: number;
}

export interface VoteCastResult {
  action: "created" | "changed" | "removed";
  value: 1 | -1 | null;
}

// ══════════════════════════════════════════════════════════════════════════════
// EXPRESS AUGMENTATION  (add typed user to Request)
// ══════════════════════════════════════════════════════════════════════════════

declare global {
  namespace Express {
    interface Request {
      user?: IUser;
    }
  }
}
