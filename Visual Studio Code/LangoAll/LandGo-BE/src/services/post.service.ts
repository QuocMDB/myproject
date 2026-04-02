import { Types } from "mongoose";
import { Post, Vote } from "../models";
import { create as createNotification } from "./notification.service";
import {
  IUser,
  IPost,
  GetPostsQuery,
  CreatePostInput,
  UpdatePostInput,
  ReviewPostInput,
  PaginatedResult,
  NotificationType,
  PostStatus,
} from "../types";
import { AppError } from "../utils/AppError";
import { generateSlug } from "../utils/helper";
import { uploadMultipleImages } from "./upload.service";

const SORT_OPTIONS: Record<string, Record<string, 1 | -1>> = {
  feed: { isPinned: -1, pinLevel: -1, score: -1, createdAt: -1 },
  newest: { createdAt: -1 },
  price_asc: { price: 1 },
  price_desc: { price: -1 },
};

export const getPosts = async (
  query: GetPostsQuery,
  requestingUser?: IUser,
): Promise<PaginatedResult<IPost>> => {
  const {
    page = "1",
    limit = "20",
    status,
    includeInactive = "false",
    province,
    district,
    ward,
    addressDetail,
    propertyType,
    minPrice,
    maxPrice,
    minArea,
    maxArea,
    search,
    sortBy = "feed",
  } = query;

  const filter: Record<string, unknown> = { status: PostStatus.Active };
  const isModerator = requestingUser?.role === "moderator";
  const shouldIncludeInactive =
    includeInactive === "true" || includeInactive === "1";
  const normalizedStatus =
    status && Object.values(PostStatus).includes(status as PostStatus)
      ? (status as PostStatus)
      : null;

  if (normalizedStatus) {
    filter.status = isModerator ? normalizedStatus : PostStatus.Active;
  } else if (!(isModerator && shouldIncludeInactive)) {
    filter.status = PostStatus.Active;
  }

  if (province) filter.province = province;
  if (district) filter.district = district;
  if (ward) filter.ward = ward;
  if (propertyType) filter.propertyType = propertyType;
  if (minPrice || maxPrice) {
    filter.price = {
      ...(minPrice ? { $gte: Number(minPrice) } : {}),
      ...(maxPrice ? { $lte: Number(maxPrice) } : {}),
    };
  }
  if (minArea || maxArea) {
    filter.area = {
      ...(minArea ? { $gte: Number(minArea) } : {}),
      ...(maxArea ? { $lte: Number(maxArea) } : {}),
    };
  }

  if (addressDetail) {
    filter.$or = [
      { addressDetail: { $regex: addressDetail, $options: "i" } },
      { title: { $regex: addressDetail, $options: "i" } },
      { description: { $regex: addressDetail, $options: "i" } },
    ];
  }

  const pageNum = Number(page);
  const limitNum = Number(limit);
  const skip = (pageNum - 1) * limitNum;
  const sort = SORT_OPTIONS[sortBy] ?? SORT_OPTIONS.feed;

  const [data, total] = await Promise.all([
    Post.find(filter)
      .sort(sort)
      .skip(skip)
      .limit(limitNum)
      .populate("author", "name avatar phone totalScoreReceived")
      .lean(),
    Post.countDocuments(filter),
  ]);

  return {
    data: data as unknown as IPost[],
    total,
    page: pageNum,
    limit: limitNum,
    pages: Math.ceil(total / limitNum),
  };
};

export const getPinnedPosts = async (): Promise<IPost[]> => {
  return Post.find({
    status: PostStatus.Active,
    pinLevel: { $in: [1, 2] },
  })
    .sort({ pinLevel: -1, score: -1, createdAt: -1 })
    .limit(20)
    .populate("author", "name avatar phone totalScoreReceived")
    .lean() as unknown as IPost[];
};

export const getPostBySlug = async (
  slug: string,
  userId?: Types.ObjectId,
): Promise<IPost & { userVote: 1 | -1 | null }> => {
  const post = await Post.findOneAndUpdate(
    { slug, status: PostStatus.Active },
    { $inc: { viewCount: 1 } },
    { new: true },
  )
    .populate("author", "name avatar phone totalScoreReceived createdAt")
    .populate("province", "name")
    .populate("district", "name")
    .populate("ward", "name");

  if (!post) throw new AppError("Post not found", 404);

  let userVote: 1 | -1 | null = null;
  if (userId) {
    const vote = await Vote.findOne({ user: userId, post: post._id });
    userVote = (vote?.value ?? null) as 1 | -1 | null;
  }

  return { ...post.toObject(), userVote } as unknown as IPost & {
    userVote: 1 | -1 | null;
  };
};

export const createPost = async (
  body: CreatePostInput,
  authorId: Types.ObjectId,
  files?: {
    images?: Express.Multer.File[];
    redBookImages?: Express.Multer.File[];
  },
): Promise<IPost> => {
  let imageUrls: string[] = [];
  let redBookUrls: string[] = [];

  if (files?.images?.length) {
    imageUrls = await uploadMultipleImages(files.images, "posts/images");
  }

  if (files?.redBookImages?.length) {
    redBookUrls = await uploadMultipleImages(
      files.redBookImages,
      "posts/red-books",
    );
  }

  const slug = generateSlug(body.title);
  return Post.create({
    ...body,
    slug,
    author: authorId,
    status: PostStatus.Active,
    images: imageUrls,
    redBookImages: redBookUrls,
  });
};

const parseStringArrayField = (value: unknown): string[] | undefined => {
  if (!value) return undefined;
  if (Array.isArray(value)) {
    return value.map((v) => String(v));
  }
  if (typeof value === "string") {
    try {
      const parsed = JSON.parse(value);
      if (Array.isArray(parsed)) {
        return parsed.map((v) => String(v));
      }
    } catch {
      // Not JSON, fall through
    }
    return [value];
  }
  return undefined;
};

export const updatePost = async (
  postId: string,
  body: UpdatePostInput,
  requestingUser: IUser,
  files?: {
    images?: Express.Multer.File[];
    redBookImages?: Express.Multer.File[];
  },
): Promise<IPost | null> => {
  const post = await Post.findById(postId);
  if (!post) throw new AppError("Post not found", 404);

  const isOwner = post.author.toString() === requestingUser._id.toString();
  const isModerator = requestingUser.role === "moderator";
  if (!isOwner && !isModerator) throw new AppError("Not authorized", 403);

  const updateBody = { ...body } as Record<string, unknown>;
  delete updateBody.slug;
  delete updateBody.author;
  delete updateBody.status;

  const existingImages =
    parseStringArrayField(
      (body as unknown as { existingImages?: string[]; images?: string[] })
        .existingImages ??
        (body as unknown as { existingImages?: string[]; images?: string[] })
          .images,
    ) ?? post.images;

  const existingRedBookImages =
    parseStringArrayField(
      (
        body as unknown as {
          existingRedBookImages?: string[];
          redBookImages?: string[];
        }
      ).existingRedBookImages ??
        (
          body as unknown as {
            existingRedBookImages?: string[];
            redBookImages?: string[];
          }
        ).redBookImages,
    ) ?? post.redBookImages;

  let finalImages = existingImages;
  let finalRedBookImages = existingRedBookImages;

  if (files?.images?.length) {
    const newImages = await uploadMultipleImages(files.images, "posts/images");
    finalImages = [...existingImages, ...newImages];
  }

  if (files?.redBookImages?.length) {
    const newRedBooks = await uploadMultipleImages(
      files.redBookImages,
      "posts/red-books",
    );
    finalRedBookImages = [...existingRedBookImages, ...newRedBooks];
  }

  updateBody.images = finalImages;
  updateBody.redBookImages = finalRedBookImages;

  delete (updateBody as { existingImages?: unknown }).existingImages;
  delete (updateBody as { existingRedBookImages?: unknown })
    .existingRedBookImages;

  return Post.findByIdAndUpdate(postId, updateBody, {
    new: true,
    runValidators: true,
  });
};

export const deletePost = async (
  postId: string,
  requestingUser: IUser,
): Promise<void> => {
  const post = await Post.findById(postId);
  if (!post) throw new AppError("Post not found", 404);
  if (
    post.author.toString() !== requestingUser._id.toString() &&
    requestingUser.role !== "moderator"
  )
    throw new AppError("Not authorized", 403);
  post.status = PostStatus.Inactive;
  post.isPinned = false;
  post.pinLevel = null;
  post.pinExpiredAt = null;
  await post.save();
};

export const reviewPost = async (
  postId: string,
  input: ReviewPostInput,
  moderatorId: Types.ObjectId,
): Promise<IPost> => {
  const post = await Post.findById(postId);
  if (!post) throw new AppError("Post not found", 404);

  if (input.action === "approve") {
    post.status = PostStatus.Active;
    post.approvedBy = moderatorId;
    post.approvedAt = new Date();
    post.rejectionReason = null;
  } else if (input.action === "reject") {
    post.status = PostStatus.Inactive;
    post.rejectionReason = input.rejectionReason ?? "Deactivated by moderator";
  } else {
    throw new AppError("Invalid action", 400);
  }

  await post.save();

  await createNotification({
    userId: post.author as Types.ObjectId,
    type:
      input.action === "approve"
        ? NotificationType.PostApproved
        : NotificationType.PostRejected,
    referenceId: post._id,
    message:
      input.action === "approve"
        ? "Your listing is now active."
        : `Your listing was deactivated: ${input.rejectionReason ?? "No reason provided"}`,
  });

  return post;
};

export const getMyPosts = async (
  authorId: Types.ObjectId,
  query: { status?: string; page?: string; limit?: string },
): Promise<PaginatedResult<IPost>> => {
  const pageNum = Number(query.page ?? 1);
  const limitNum = Number(query.limit ?? 10);
  const skip = (pageNum - 1) * limitNum;

  const filter: Record<string, unknown> = { author: authorId };
  if (query.status) filter.status = query.status;

  const [data, total] = await Promise.all([
    Post.find(filter).sort({ createdAt: -1 }).skip(skip).limit(limitNum).lean(),
    Post.countDocuments(filter),
  ]);

  return {
    data: data as unknown as IPost[],
    total,
    page: pageNum,
    limit: limitNum,
    pages: Math.ceil(total / limitNum),
  };
};

type StatusCountRow = {
  _id: string | null;
  count: number;
};

type SummaryRow = {
  _id: null;
  totalViews: number;
  totalComments: number;
  pinnedPosts: number;
  totalScore: number;
};

type PropertyTypeRow = {
  _id: string | null;
  count: number;
};

const buildLast7Days = (dailyMap: Map<string, number>) => {
  const output: Array<{ date: string; label: string; count: number }> = [];
  const baseDate = new Date();
  baseDate.setHours(0, 0, 0, 0);
  const dateKeyFormatter = new Intl.DateTimeFormat("en-CA", {
    timeZone: "Asia/Ho_Chi_Minh",
    year: "numeric",
    month: "2-digit",
    day: "2-digit",
  });
  const labelFormatter = new Intl.DateTimeFormat("vi-VN", {
    timeZone: "Asia/Ho_Chi_Minh",
    day: "2-digit",
    month: "2-digit",
  });

  for (let i = 6; i >= 0; i -= 1) {
    const d = new Date(baseDate);
    d.setDate(baseDate.getDate() - i);

    const date = dateKeyFormatter.format(d);
    const label = labelFormatter.format(d);

    output.push({
      date,
      label,
      count: dailyMap.get(date) ?? 0,
    });
  }

  return output;
};

export const getPostStats = async () => {
  const now = new Date();
  const startDate = new Date(now);
  startDate.setHours(0, 0, 0, 0);
  startDate.setDate(startDate.getDate() - 6);

  const [statusRows, summaryRows, propertyRows, dailyRows, topViewedPosts] =
    await Promise.all([
      Post.aggregate<StatusCountRow>([
        { $match: { deletedAt: null } },
        { $group: { _id: "$status", count: { $sum: 1 } } },
      ]),
      Post.aggregate<SummaryRow>([
        { $match: { deletedAt: null } },
        {
          $group: {
            _id: null,
            totalViews: { $sum: "$viewCount" },
            totalComments: { $sum: "$commentCount" },
            pinnedPosts: {
              $sum: {
                $cond: [{ $eq: ["$isPinned", true] }, 1, 0],
              },
            },
            totalScore: { $sum: "$score" },
          },
        },
      ]),
      Post.aggregate<PropertyTypeRow>([
        { $match: { deletedAt: null } },
        { $group: { _id: "$propertyType", count: { $sum: 1 } } },
        { $sort: { count: -1 } },
      ]),
      Post.aggregate<{ _id: string; count: number }>([
        {
          $match: {
            deletedAt: null,
            createdAt: { $gte: startDate, $lte: now },
          },
        },
        {
          $group: {
            _id: {
              $dateToString: {
                date: "$createdAt",
                format: "%Y-%m-%d",
                timezone: "Asia/Ho_Chi_Minh",
              },
            },
            count: { $sum: 1 },
          },
        },
        { $sort: { _id: 1 } },
      ]),
      Post.find({ deletedAt: null, status: PostStatus.Active })
        .select("title slug status viewCount score createdAt propertyType")
        .sort({ viewCount: -1, score: -1, createdAt: -1 })
        .limit(6)
        .lean(),
    ]);

  const byStatus = {
    active: 0,
    inactive: 0,
  };

  for (const row of statusRows) {
    if (row._id === PostStatus.Active) byStatus.active += row.count;
    else byStatus.inactive += row.count;
  }

  const totalAllPosts = byStatus.active + byStatus.inactive;

  const summary = summaryRows[0] ?? {
    totalViews: 0,
    totalComments: 0,
    pinnedPosts: 0,
    totalScore: 0,
  };

  const totalPropertyPosts = propertyRows.reduce(
    (sum, row) => sum + row.count,
    0,
  );

  const propertyTypeDistribution = propertyRows.map((row) => ({
    propertyType: row._id ?? "unknown",
    count: row.count,
    percent:
      totalPropertyPosts === 0
        ? 0
        : Math.round((row.count / totalPropertyPosts) * 100),
  }));

  const dailyMap = new Map(dailyRows.map((row) => [row._id, row.count]));

  return {
    overview: {
      totalPosts: byStatus.active,
      totalAllPosts,
      totalViews: summary.totalViews,
      totalComments: summary.totalComments,
      pinnedPosts: summary.pinnedPosts,
      totalScore: summary.totalScore,
      activeRate:
        totalAllPosts === 0
          ? 0
          : Math.round((byStatus.active / totalAllPosts) * 100),
    },
    byStatus,
    propertyTypeDistribution,
    last7Days: buildLast7Days(dailyMap),
    topViewedPosts,
  };
};
