import { Request, Response, NextFunction } from "express";
import * as postService from "../services/post.service";

export const getPosts = async (
  req: Request,
  res: Response,
  next: NextFunction,
): Promise<void> => {
  try {
    const result = await postService.getPosts(req.query as never, req.user);
    res.json({
      success: true,
      data: result.data,
      pagination: {
        page: result.page,
        limit: result.limit,
        total: result.total,
        pages: result.pages,
      },
    });
  } catch (err) {
    next(err);
  }
};

export const getPostBySlug = async (
  req: Request,
  res: Response,
  next: NextFunction,
): Promise<void> => {
  try {
    const data = await postService.getPostBySlug(
      req.params.slug,
      req.user?._id,
    );
    res.json({ success: true, data });
  } catch (err) {
    next(err);
  }
};

export const createPost = async (
  req: Request,
  res: Response,
  next: NextFunction,
): Promise<void> => {
  try {
    const files = req.files as {
      images?: Express.Multer.File[];
      redBookImages?: Express.Multer.File[];
    };

    const post = await postService.createPost(req.body, req.user!._id, files);
    res.status(201).json({ success: true, data: post });
  } catch (err) {
    next(err);
  }
};

export const updatePost = async (
  req: Request,
  res: Response,
  next: NextFunction,
): Promise<void> => {
  try {
    const files = req.files as {
      images?: Express.Multer.File[];
      redBookImages?: Express.Multer.File[];
    };

    const post = await postService.updatePost(
      req.params.id,
      req.body,
      req.user!,
      files,
    );
    res.json({ success: true, data: post });
  } catch (err) {
    next(err);
  }
};

export const deletePost = async (
  req: Request,
  res: Response,
  next: NextFunction,
): Promise<void> => {
  try {
    await postService.deletePost(req.params.id, req.user!);
    res.json({ success: true, message: "Post set to inactive" });
  } catch (err) {
    next(err);
  }
};

export const reviewPost = async (
  req: Request,
  res: Response,
  next: NextFunction,
): Promise<void> => {
  try {
    const post = await postService.reviewPost(
      req.params.id,
      req.body,
      req.user!._id,
    );
    res.json({ success: true, data: post });
  } catch (err) {
    next(err);
  }
};

export const getMyPosts = async (
  req: Request,
  res: Response,
  next: NextFunction,
): Promise<void> => {
  try {
    const result = await postService.getMyPosts(
      req.user!._id,
      req.query as never,
    );
    res.json({
      success: true,
      data: result.data,
      pagination: {
        page: result.page,
        limit: result.limit,
        total: result.total,
        pages: result.pages,
      },
    });
  } catch (err) {
    next(err);
  }
};

export const getPinnedPosts = async (
  req: Request,
  res: Response,
  next: NextFunction,
): Promise<void> => {
  try {
    const data = await postService.getPinnedPosts();
    res.json({ success: true, data });
  } catch (err) {
    next(err);
  }
};

export const getPostStats = async (
  _req: Request,
  res: Response,
  next: NextFunction,
): Promise<void> => {
  try {
    const data = await postService.getPostStats();
    res.json({ success: true, data });
  } catch (err) {
    next(err);
  }
};
