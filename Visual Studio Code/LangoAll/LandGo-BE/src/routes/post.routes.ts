import { Router } from "express";
import * as postController from "../controllers/post.controller";
import * as voteController from "../controllers/vote.controller";
import * as commentController from "../controllers/comment.controller";
import {
  authenticate,
  optionalAuth,
  requireModerator,
  requireVerifiedPhone,
} from "../middlewares/auth.middleware";
import { upload } from "../middlewares/upload.middleware";

const router = Router();

router.get("/", optionalAuth, postController.getPosts);
router.get("/pinned", postController.getPinnedPosts);
router.get("/my", authenticate, postController.getMyPosts);
router.get(
  "/stats",
  authenticate,
  requireModerator,
  postController.getPostStats,
);
router.get("/:slug", optionalAuth, postController.getPostBySlug);
router.post(
  "/",
  authenticate,
  requireVerifiedPhone,
  upload.fields([
    { name: "images", maxCount: 10 },
    { name: "redBookImages", maxCount: 5 },
  ]),
  postController.createPost,
);
router.patch(
  "/:id",
  authenticate,
  upload.fields([
    { name: "images", maxCount: 10 },
    { name: "redBookImages", maxCount: 5 },
  ]),
  postController.updatePost,
);
router.delete("/:id", authenticate, postController.deletePost);

// Moderator
router.patch(
  "/:id/review",
  authenticate,
  requireModerator,
  postController.reviewPost,
);

// Nested resources
router.post("/:postId/vote", authenticate, voteController.vote);
router.get("/:postId/comments", commentController.getComments);
router.post("/:postId/comments", authenticate, commentController.createComment);

export default router;
