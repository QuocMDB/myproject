import { Request, Response, NextFunction } from "express";
import * as authService from "../services/auth.service";

export const register = async (
  req: Request,
  res: Response,
  next: NextFunction
): Promise<void> => {
  const data = await authService.register(req.body);
  res.status(201).json({
    success: true,
    message: "Registration successful. Please verify your email with the OTP.",
    data,
  });
};

export const verifyEmailOtp = async (
  req: Request,
  res: Response,
  next: NextFunction
): Promise<void> => {
  await authService.verifyEmailOtp(req.body);
  res.json({ success: true, message: "Email verification successful" });
};

export const verifyPhone = async (
  req: Request,
  res: Response,
  next: NextFunction
): Promise<void> => {
  const data = await authService.verifyPhone(req.body);
  res.json({ success: true, message: "Phone verification successful", data });
};

export const resendOtp = async (
  req: Request,
  res: Response,
  next: NextFunction
): Promise<void> => {
  await authService.resendOtp(req.body);
  res.json({ success: true, message: "OTP resent successfully" });
};

export const login = async (
  req: Request,
  res: Response,
  next: NextFunction
): Promise<void> => {
  const data = await authService.login(req.body);

  res.cookie("refreshToken", data.refreshToken, {
    httpOnly: true,
    sameSite: "lax",
    secure: process.env.NODE_ENV === "production",
    maxAge: 7 * 24 * 60 * 60 * 1000,
  });

  res.json({
    success: true,
    message: "Login successful",
    data: {
      accessToken: data.accessToken,
      user: data.user,
    },
  });
};

export const refreshToken = async (
  req: Request,
  res: Response
): Promise<void> => {
  const refreshToken = req.body?.refreshToken || req.cookies?.refreshToken;

  if (!refreshToken) {
    res.status(401).json({ success: false, message: "Refresh token not found" });
    return;
  }

  const data = await authService.refreshAccessToken(refreshToken);
  res.json({ success: true, data });
};

export const logout = async (req: Request, res: Response): Promise<void> => {
  const refreshToken = req.body?.refreshToken || req.cookies?.refreshToken;

  if (!refreshToken) {
    res.status(400).json({ success: false, message: "Refresh token not found" });
    return;
  }

  await authService.logout(refreshToken);

  res.clearCookie("refreshToken", {
    httpOnly: true,
    sameSite: "lax",
    secure: process.env.NODE_ENV === "production",
  });

  res.json({ success: true, message: "Logout successful" });
};

export const forgotPassword = async (req: Request, res: Response): Promise<void> => {
  const data = await authService.forgotPassword(req.body);
  res.json({
    success: true,
    message: "If the email exists, the password reset OTP has been sent.",
    data,
  });
};

export const resetPasswordWithOtp = async (
  req: Request,
  res: Response
): Promise<void> => {
  await authService.resetPasswordWithOtp(req.body);
  res.json({ success: true, message: "Password reset successful" });
};

export const getMe = async (req: Request, res: Response): Promise<void> => {
  res.json({ success: true, data: req.user });
};
