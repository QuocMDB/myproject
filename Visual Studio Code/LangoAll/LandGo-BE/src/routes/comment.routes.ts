import { Router } from 'express';
import * as commentController from '../controllers/comment.controller';
import { authenticate } from '../middlewares/auth.middleware';

const router = Router();

router.delete('/:id', authenticate, commentController.deleteComment);

export default router;