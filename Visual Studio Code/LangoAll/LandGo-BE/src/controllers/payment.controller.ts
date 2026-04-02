import { Request, Response, NextFunction } from 'express';
import * as paymentService from '../services/payment.service';
import { config } from '../config';

export const createPayment = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
  try {
    const payment = await paymentService.createPayment(req.body, req.user!._id);
    res.status(201).json({ success: true, data: payment });
  } catch (err) { next(err); }
};

export const getPayments = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
  try {
    const result = await paymentService.getPayments(req.query as never);
    res.json({ success: true, data: result.data, pagination: { page: result.page, limit: result.limit, total: result.total } });
  } catch (err) { next(err); }
};

export const getPayment = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
  try {
    const payment = await paymentService.getPaymentById(req.params.id, req.user!._id);
    res.json({ success: true, data: payment });
  } catch (err) { next(err); }
};

export const reviewPayment = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
  try {
    const payment = await paymentService.reviewPayment(req.params.id, req.body, req.user!._id);
    res.json({ success: true, data: payment });
  } catch (err) { next(err); }
};

export const createSepayPayment = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
  try {
    const payment = await paymentService.createSepayPayment(req.body, req.user!._id);
    res.status(201).json({ success: true, data: payment });
  } catch (err) { next(err); }
};

export const sepayWebhook = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
  try {
    await paymentService.handleSepayWebhook(req.body);
    res.json({ success: true });
  } catch (err) { next(err); } 
};
