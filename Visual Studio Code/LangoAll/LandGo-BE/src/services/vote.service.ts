import { Types } from 'mongoose';
import { Vote, Post, User } from '../models';
import { VoteCastResult, NotificationType, PostStatus } from '../types';
import { create as createNotification } from './notification.service';
import { AppError } from '../utils/AppError';

export const castVote = async (
  userId: Types.ObjectId,
  postId: string,
  voteValue: 1 | -1
): Promise<VoteCastResult> => {
  const post = await Post.findById(postId).select('author status');
  if (!post) throw new AppError('Post not found', 404);
  if (post.status !== PostStatus.Active) throw new AppError('Cannot vote on this post', 400);

  const authorId = post.author as Types.ObjectId;
  const existing = await Vote.findOne({ user: userId, post: postId });

  // ── C: Toggle off ─────────────────────────────────────────────────────────
  if (existing && existing.value === voteValue) {
    await existing.deleteOne();
    const update = voteValue === 1
      ? { $inc: { upvoteCount: -1, score: -1 } }
      : { $inc: { downvoteCount: -1, score: 1 } };
    await Post.findByIdAndUpdate(postId, update);
    await User.findByIdAndUpdate(authorId, { $inc: { totalScoreReceived: -voteValue } });
    return { action: 'removed', value: null };
  }

  // ── B: Change vote ────────────────────────────────────────────────────────
  if (existing) {
    const oldValue = existing.value as 1 | -1;
    existing.value = voteValue;
    await existing.save();
    const update = oldValue === 1
      ? { $inc: { upvoteCount: -1, downvoteCount: 1, score: -2 } }
      : { $inc: { upvoteCount: 1, downvoteCount: -1, score: 2 } };
    await Post.findByIdAndUpdate(postId, update);
    await User.findByIdAndUpdate(authorId, { $inc: { totalScoreReceived: voteValue - oldValue } });
    return { action: 'changed', value: voteValue };
  }

  // ── A: New vote ───────────────────────────────────────────────────────────
  await Vote.create({ user: userId, post: postId, value: voteValue });
  const update = voteValue === 1
    ? { $inc: { upvoteCount: 1, score: 1 } }
    : { $inc: { downvoteCount: 1, score: -1 } };
  await Post.findByIdAndUpdate(postId, update);
  await User.findByIdAndUpdate(authorId, { $inc: { totalScoreReceived: voteValue } });

  if (voteValue === 1 && authorId.toString() !== userId.toString()) {
    await createNotification({
      userId:      authorId,
      type:        NotificationType.VoteReceived,
      referenceId: post._id,
      message:     'Someone upvoted your listing.',
    });
  }

  return { action: 'created', value: voteValue };
};

export const repairPostVoteCounts = async (postId: string): Promise<{ upvoteCount: number; downvoteCount: number; score: number }> => {
  const postObjectId = new Types.ObjectId(postId);
  const result = await Vote.aggregate([
    { $match: { post: postObjectId } },
    {
      $group: {
        _id: null,
        upvoteCount:   { $sum: { $cond: [{ $eq: ['$value',  1] }, 1, 0] } },
        downvoteCount: { $sum: { $cond: [{ $eq: ['$value', -1] }, 1, 0] } },
      },
    },
  ]);
  const counts = result[0] ?? { upvoteCount: 0, downvoteCount: 0 };
  const score  = counts.upvoteCount - counts.downvoteCount;
  await Post.findByIdAndUpdate(postId, { $set: { ...counts, score } });
  return { ...counts, score };
};
