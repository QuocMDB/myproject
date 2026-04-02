import { User } from "../models";
import { validateLocation } from "../utils/helper";

export const updateProfile = async (userId: string, body: any) => {
  const { name, addressDetail } = body;
  const { district, province, ward } = await validateLocation(
    body.provinceId,
    body.districtId,
    body.wardId,
  );

  const user = await User.findByIdAndUpdate(
    userId,
    {
      province,
      district,
      ward,
      addressDetail,
      name,
    },
    { new: true },
  )
    .populate("province", "name")
    .populate("district", "name")
    .populate("ward", "name");

  return user;
};

export const getUsers = async (page: number = 1, limit: number = 10) => {
  const skip = (page - 1) * limit;

  const [users, total] = await Promise.all([
    User.find()
      .select("-password -refreshToken")
      .populate("province", "name")
      .populate("district", "name")
      .populate("ward", "name")
      .sort({ createdAt: -1 })
      .skip(skip)
      .limit(limit),

    User.countDocuments(),
  ]);

  return {
    users,
    pagination: {
      total,
      page,
      limit,
      totalPages: Math.ceil(total / limit),
    },
  };
};

export const deleteUser = async (userId: string) => {
  const user = await User.findByIdAndUpdate(
    userId,
    { deletedAt: new Date() },
    { new: true },
  );

  return user;
};

export const updateUserByAdmin = async (userId: string, body: any) => {
  const { name, email, phone, role } = body;

  const user = await User.findByIdAndUpdate(
    userId,
    {
      name,
      email,
      phone,
      role,
    },
    { new: true },
  ).select("-password -refreshToken");

  return user;
};
