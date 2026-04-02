import { Router } from "express";
import authRoutes from "./auth.routes";
import postRoutes from "./post.routes";
import commentRoutes from "./comment.routes";
import reportRoutes from "./report.routes";
import paymentRoutes from "./payment.routes";
import notificationRoutes from "./notification.routes";
import locationRoutes from "./location.routes";
import userRoutes from "./user.routes";

const router = Router();

router.use("/auth", authRoutes);
router.use("/posts", postRoutes);
router.use("/comments", commentRoutes);
router.use("/reports", reportRoutes);
router.use("/payments", paymentRoutes);
router.use("/notifications", notificationRoutes);
router.use("/locations", locationRoutes);
router.use("/users", userRoutes);

export default router;
