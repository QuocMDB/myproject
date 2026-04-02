import mongoose from 'mongoose';
import {
  userSchema, postSchema, voteSchema,
  commentSchema, reportSchema, paymentSchema, notificationSchema,
  provinceSchema,
  districtSchema,
  wardSchema,
} from './schema';
import {
  IUser, IPost, IVote, IComment, IReport, IPayment, INotification,
  IProvince,
  IDistrict,
  IWard,
} from '../types';

export const User = mongoose.model<IUser>('User', userSchema);
export const Post = mongoose.model<IPost>('Post', postSchema);
export const Vote = mongoose.model<IVote>('Vote', voteSchema);
export const Comment = mongoose.model<IComment>('Comment', commentSchema);
export const Report = mongoose.model<IReport>('Report', reportSchema);
export const Payment = mongoose.model<IPayment>('Payment', paymentSchema);
export const Notification = mongoose.model<INotification>('Notification', notificationSchema);
export const Province = mongoose.model<IProvince>("Province", provinceSchema);
export const District = mongoose.model<IDistrict>("District", districtSchema);
export const Ward = mongoose.model<IWard>("Ward", wardSchema);