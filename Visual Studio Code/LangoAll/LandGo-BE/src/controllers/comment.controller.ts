import { Request, Response, NextFunction } from 'express';
import * as commentService from '../services/comment.service';

export const getComments = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
  try {
    const result = await commentService.getComments(req.params.postId, req.query as never);
    res.json({ success: true, data: result.data, pagination: { page: result.page, limit: result.limit, total: result.total } });
  } catch (err) { next(err); }
};

export const createComment = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
  try {
    const comment = await commentService.createComment({ postId: req.params.postId, ...req.body }, req.user!);
    res.status(201).json({ success: true, data: comment });
  } catch (err) { next(err); }
};

export const deleteComment = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
  try {
    await commentService.deleteComment(req.params.id, req.user!);
    res.json({ success: true, message: 'Comment deleted' });
  } catch (err) { next(err); }
};