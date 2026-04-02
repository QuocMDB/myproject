import { Router } from "express";
import * as userController from "../controllers/user.controller";
import { authenticate, requireModerator } from "../middlewares/auth.middleware";
import { asyncHandler } from "../middlewares/asyncHandler";

const router = Router();

router.get(
  "/",
  authenticate,
  requireModerator,
  asyncHandler(userController.getUsers),
);

router.patch(
  "/:id/profile",
  authenticate,
  asyncHandler(userController.updateProfile),
);

router.delete(
  "/:id",
  authenticate,
  requireModerator,
  asyncHandler(userController.deleteUser),
);

router.patch(
  "/:id",
  authenticate,
  requireModerator,
  asyncHandler(userController.updateUser),
);

export default router;
