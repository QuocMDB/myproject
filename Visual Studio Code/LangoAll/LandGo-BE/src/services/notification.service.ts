import { Types } from 'mongoose';
import { Notification } from '../models';
import { CreateNotificationInput, PaginatedResult, INotification } from '../types';

export const create = async (input: CreateNotificationInput): Promise<void> => {
    try {
        await Notification.create({
            user: input.userId,
            type: input.type,
            referenceId: input.referenceId,
            message: input.message,
        });
    } catch (err) {
        // Non-critical — never break the main request flow
        console.error('Failed to create notification:', (err as Error).message);
    }
};

export const getNotifications = async (
    userId: Types.ObjectId,
    query: { page?: string; limit?: string }
): Promise<PaginatedResult<INotification> & { unreadCount: number }> => {
    const page = Number(query.page ?? 1);
    const limit = Number(query.limit ?? 20);
    const skip = (page - 1) * limit;

    const [data, total, unreadCount] = await Promise.all([
        Notification.find({ user: userId }).sort({ createdAt: -1 }).skip(skip).limit(limit).lean(),
        Notification.countDocuments({ user: userId }),
        Notification.countDocuments({ user: userId, isRead: false }),
    ]);

    return { data: data as unknown as INotification[], total, page, limit, pages: Math.ceil(total / limit), unreadCount };
};

export const markAllRead = async (userId: Types.ObjectId): Promise<void> => {
    await Notification.updateMany({ user: userId, isRead: false }, { $set: { isRead: true } });
};

export const markOneRead = async (notificationId: string, userId: Types.ObjectId): Promise<void> => {
    await Notification.findOneAndUpdate({ _id: notificationId, user: userId }, { isRead: true });
};