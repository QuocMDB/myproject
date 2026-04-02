import { Types } from 'mongoose';
import { Comment, Post } from '../models';
import { create as createNotification } from './notification.service';
import { IUser, IComment, CreateCommentInput, PaginatedResult, NotificationType, PostStatus } from '../types';
import { AppError } from '../utils/AppError';

export const getComments = async (
    postId: string,
    query: { page?: string; limit?: string }
): Promise<PaginatedResult<IComment & { replies: IComment[] }>> => {
    const page = Number(query.page ?? 1);
    const limit = Number(query.limit ?? 20);
    const skip = (page - 1) * limit;

    const [topLevel, total] = await Promise.all([
        Comment.find({ post: postId, parentComment: null })
            .sort({ createdAt: -1 }).skip(skip).limit(limit)
            .populate('user', 'name avatar').lean(),
        Comment.countDocuments({ post: postId, parentComment: null }),
    ]);

    const ids = topLevel.map((c) => c._id);
    const replies = await Comment.find({ parentComment: { $in: ids } })
        .sort({ createdAt: 1 }).populate('user', 'name avatar').lean();

    const repliesMap: Record<string, IComment[]> = {};
    replies.forEach((r) => {
        const key = r.parentComment!.toString();
        (repliesMap[key] ??= []).push(r as unknown as IComment);
    });

    const data = topLevel.map((c) => ({
        ...c,
        replies: repliesMap[c._id.toString()] ?? [],
    })) as unknown as (IComment & { replies: IComment[] })[];

    return { data, total, page, limit, pages: Math.ceil(total / limit) };
};

export const createComment = async (
    input: CreateCommentInput,
    user: IUser
): Promise<IComment> => {
    const post = await Post.findById(input.postId).select('status author');
    if (!post || post.status !== PostStatus.Active)
        throw new AppError('Post not found or inactive', 404);

    if (input.parentComment) {
        const parent = await Comment.findOne({ _id: input.parentComment, post: input.postId });
        if (!parent) throw new AppError('Parent comment not found', 400);
        if (parent.parentComment) throw new AppError('Cannot reply to a reply', 400);
    }

    const comment = await Comment.create({
        post: input.postId,
        user: user._id,
        content: input.content,
        parentComment: input.parentComment ?? null,
    });
    await comment.populate('user', 'name avatar');

    const authorId = post.author as Types.ObjectId;
    if (authorId.toString() !== user._id.toString()) {
        await createNotification({
            userId: authorId,
            type: NotificationType.Comment,
            referenceId: comment._id,
            message: `${user.name} commented on your listing.`,
        });
    }

    return comment;
};

export const deleteComment = async (commentId: string, requestingUser: IUser): Promise<void> => {
    const comment = await Comment.findById(commentId);
    if (!comment) throw new AppError('Comment not found', 404);
    if (comment.user.toString() !== requestingUser._id.toString() && requestingUser.role !== 'moderator')
        throw new AppError('Not authorized', 403);

    comment.deletedAt = new Date();
    await comment.save();
    await Post.findByIdAndUpdate(comment.post, { $inc: { commentCount: -1 } });
};
