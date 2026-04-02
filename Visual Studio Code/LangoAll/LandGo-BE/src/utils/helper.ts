import { Types } from "mongoose";
import slugify from "slugify";
import { v4 as uuidv4 } from "uuid";
import { District, Province, Ward } from "../models";
import { AppError } from "./AppError";

/**
 * Generates a URL-safe, Vietnamese-aware, unique slug.
 * Format: {vi-slugified-title-max-60-chars}-{8-char-uuid-suffix}
 * Example: "can-ho-2-phong-ngu-quan-7-a1b2c3d4"
 */
export const generateSlug = (title: string): string => {
  const base = slugify(title, {
    lower: true,
    strict: true,
    locale: "vi",
    trim: true,
  });

  const truncated = base.substring(0, 60).replace(/-+$/, "");
  const suffix = uuidv4().replace(/-/g, "").substring(0, 8);

  return `${truncated}-${suffix}`;
};

export const validateLocation = async (
  provinceId: Types.ObjectId,
  districtId: Types.ObjectId,
  wardId: Types.ObjectId
) => {
  const province = await Province.findById(provinceId).select("name");
  if (!province) throw new AppError("Province not found", 400);

  const district = await District.findOne({
    _id: districtId,
    province: provinceId,
  }).select("name");

  if (!district)
    throw new AppError("District does not belong to province", 400);

  const ward = await Ward.findOne({
    _id: wardId,
    district: districtId,
    province: provinceId,
  }).select("name");

  if (!ward) throw new AppError("Ward does not belong to district", 400);

  return { province, district, ward };
};
