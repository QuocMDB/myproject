import { Router } from 'express';
import * as reportController from '../controllers/report.controller';
import { authenticate, requireModerator } from '../middlewares/auth.middleware';

const router = Router();

router.post('/', authenticate, reportController.createReport);
router.get('/', authenticate, requireModerator, reportController.getReports);
router.patch('/:id', authenticate, requireModerator, reportController.handleReport);

export default router;