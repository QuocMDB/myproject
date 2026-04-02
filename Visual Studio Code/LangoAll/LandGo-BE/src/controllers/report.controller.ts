import { Request, Response, NextFunction } from 'express';
import * as reportService from '../services/report.service';

export const createReport = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
  try {
    const report = await reportService.createReport(req.body, req.user!._id);
    res.status(201).json({ success: true, data: report });
  } catch (err) { next(err); }
};

export const getReports = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
  try {
    const result = await reportService.getReports(req.query as never);
    res.json({ success: true, data: result.data, pagination: { page: result.page, limit: result.limit, total: result.total } });
  } catch (err) { next(err); }
};

export const handleReport = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
  try {
    const report = await reportService.handleReport(req.params.id, req.body, req.user!._id);
    res.json({ success: true, data: report });
  } catch (err) { next(err); }
};