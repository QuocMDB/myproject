import { Router } from "express";
import * as authController from "../controllers/auth.controller";
import { authenticate } from "../middlewares/auth.middleware";
import { asyncHandler } from "../middlewares/asyncHandler";

const router = Router();

router.post("/register", asyncHandler(authController.register));
router.post("/verify-email-otp", asyncHandler(authController.verifyEmailOtp));
router.post("/verify-phone",asyncHandler(authController.verifyPhone) );
router.post("/resend-otp", asyncHandler(authController.resendOtp));
router.post("/login", asyncHandler(authController.login));
router.post("/refresh-token", asyncHandler(authController.refreshToken));
router.post("/logout", asyncHandler(authController.logout));
router.post("/forgot-password", asyncHandler(authController.forgotPassword));
router.post(
	"/reset-password-otp",
	asyncHandler(authController.resetPasswordWithOtp)
);
router.get("/me", authenticate, asyncHandler(authController.getMe));

export default router;
