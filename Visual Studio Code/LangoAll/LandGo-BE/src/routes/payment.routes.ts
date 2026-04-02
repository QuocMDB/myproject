import { Router } from 'express';
import * as paymentController from '../controllers/payment.controller';
import { authenticate, requireModerator, requireVerifiedPhone } from '../middlewares/auth.middleware';

const router = Router();

router.post('/sepay/initiate', authenticate, requireVerifiedPhone, paymentController.createSepayPayment);
router.post('/sepay-webhook', paymentController.sepayWebhook);
router.post('/', authenticate, requireVerifiedPhone, paymentController.createPayment);
router.get('/', authenticate, requireModerator, paymentController.getPayments);
router.get('/:id', authenticate, paymentController.getPayment);
router.patch('/:id/review', authenticate, requireModerator, paymentController.reviewPayment);

export default router;
