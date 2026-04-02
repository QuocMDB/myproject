import { Request, Response, NextFunction } from "express";
import jwt from "jsonwebtoken";
import { User } from "../models";
import { config } from "../config";

interface JwtPayload {
  id: string;
}

export const authenticate = async (
  req: Request,
  res: Response,
  next: NextFunction
): Promise<void> => {
  try {
    const authHeader = req.headers.authorization;
    if (!authHeader?.startsWith("Bearer ")) {
      res.status(401).json({ success: false, message: "Access Token not found" });
      return;
    }

    const token = authHeader.split(" ")[1];
    const decoded = jwt.verify(
      token,
      config.jwtSecret
    ) as JwtPayload;

    const user = await User.findById(decoded.id).select("+isBanned");
    if (!user) {
      res.status(401).json({ success: false, message: "User not found" });
      return;
    }
    if (user.isBanned) {
      res.status(403).json({ success: false, message: "Account has been banned" });
      return;
    }

    req.user = user;
    next();
  } catch (err) {
    const isExpired = (err as Error).name === "TokenExpiredError";
    res
      .status(401)
      .json({
        success: false,
        message: isExpired ? "Access token has expired" : "Access token is invalid",
      });
  }
};

export const requireModerator = (
  req: Request,
  res: Response,
  next: NextFunction
): void => {
  if (req.user?.role !== "moderator") {
    res
      .status(403)
      .json({ success: false, message: "Moderator privileges required" });
    return;
  }
  next();
};

export const requireVerifiedPhone = (
  req: Request,
  res: Response,
  next: NextFunction
): void => {
  if (!req.user?.isPhoneVerified) {
    res
      .status(403)
      .json({ success: false, message: "Phone verification required" });
    return;
  }
  next();
};

export const optionalAuth = async (
  req: Request,
  _res: Response,
  next: NextFunction
): Promise<void> => {
  try {
    const authHeader = req.headers.authorization;
    if (authHeader?.startsWith("Bearer ")) {
      const decoded = jwt.verify(
        authHeader.split(" ")[1],
        config.jwtSecret
      ) as JwtPayload;
      const user = await User.findById(decoded.id);
      if (user && !user.isBanned) req.user = user;
    }
  } catch {
    // ignore — optional auth never blocks the request
  }
  next();
};
