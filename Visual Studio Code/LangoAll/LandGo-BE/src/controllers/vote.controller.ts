import { Request, Response, NextFunction } from 'express';
import * as voteService from '../services/vote.service';

export const vote = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
  try {
    const value = Number(req.body.value) as 1 | -1;
    if (![1, -1].includes(value)) {
      res.status(400).json({ success: false, message: 'Vote value must be 1 or -1' });
      return;
    }
    const result = await voteService.castVote(req.user!._id, req.params.postId, value);
    res.json({ success: true, data: result });
  } catch (err) { next(err); }
};