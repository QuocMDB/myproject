import { Types } from 'mongoose';
import { Report } from '../models';
import { IReport, CreateReportInput, HandleReportInput, PaginatedResult, ReportTargetType } from '../types';
import { AppError } from '../utils/AppError';

export const createReport = async (
    input: CreateReportInput,
    reporterId: Types.ObjectId
): Promise<IReport> => {
    if (input.targetType === ReportTargetType.User && input.targetUser === reporterId.toString())
        throw new AppError('Cannot report yourself', 400);

    return Report.create({
        reporter: reporterId,
        targetType: input.targetType,
        targetPost: input.targetType === ReportTargetType.Post ? input.targetPost : null,
        targetUser: input.targetType === ReportTargetType.User ? input.targetUser : null,
        reason: input.reason,
    });
};

export const getReports = async (
    query: { status?: string; page?: string; limit?: string }
): Promise<PaginatedResult<IReport>> => {
    const status = query.status ?? 'pending';
    const page = Number(query.page ?? 1);
    const limit = Number(query.limit ?? 20);
    const skip = (page - 1) * limit;

    const [data, total] = await Promise.all([
        Report.find({ status })
            .sort({ createdAt: -1 }).skip(skip).limit(limit)
            .populate('reporter', 'name phone')
            .populate('targetPost', 'title slug')
            .populate('targetUser', 'name phone')
            .populate('handledBy', 'name')
            .lean(),
        Report.countDocuments({ status }),
    ]);

    return { data: data as unknown as IReport[], total, page, limit, pages: Math.ceil(total / limit) };
};

export const handleReport = async (
    reportId: string,
    input: HandleReportInput,
    moderatorId: Types.ObjectId
): Promise<IReport> => {
    const valid = ['reviewing', 'resolved', 'rejected'] as const;
    if (!valid.includes(input.action)) throw new AppError('Invalid action', 400);

    const report = await Report.findByIdAndUpdate(
        reportId,
        { status: input.action, handledBy: moderatorId, handledAt: new Date(), moderatorNote: input.moderatorNote },
        { new: true }
    );
    if (!report) throw new AppError('Report not found', 404);
    return report;
};