import { Request, Response, NextFunction } from 'express';
import * as notificationService from '../services/notification.service';

export const getNotifications = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
  try {
    const result = await notificationService.getNotifications(req.user!._id, req.query as never);
    res.json({ success: true, data: result.data, unreadCount: result.unreadCount, pagination: { page: result.page, limit: result.limit, total: result.total } });
  } catch (err) { next(err); }
};

export const markAllRead = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
  try {
    await notificationService.markAllRead(req.user!._id);
    res.json({ success: true, message: 'All notifications marked as read' });
  } catch (err) { next(err); }
};

export const markOneRead = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
  try {
    await notificationService.markOneRead(req.params.id, req.user!._id);
    res.json({ success: true });
  } catch (err) { next(err); }
};