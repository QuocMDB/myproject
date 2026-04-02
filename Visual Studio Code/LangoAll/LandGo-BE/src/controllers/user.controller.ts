import { Request, Response, NextFunction } from "express";
import * as userService from "../services/user.service";

export const updateProfile = async (
  req: Request,
  res: Response,
  next: NextFunction,
): Promise<void> => {
  await userService.updateProfile(req.body, req.user!._id);
  res.status(201).json({ success: true });
};

export const getUsers = async (req: Request, res: Response): Promise<void> => {
  const page = Number(req.query.page) || 1;
  const limit = Number(req.query.limit) || 10;

  const data = await userService.getUsers(page, limit);

  res.status(200).json({
    success: true,
    ...data,
  });
};

export const deleteUser = async (
  req: Request,
  res: Response,
): Promise<void> => {
  const { id } = req.params;

  await userService.deleteUser(id);

  res.status(200).json({
    success: true,
  });
};

export const updateUser = async (
  req: Request,
  res: Response,
): Promise<void> => {
  const { id } = req.params;

  const user = await userService.updateUserByAdmin(id, req.body);

  res.status(200).json({
    success: true,
    user,
  });
};
