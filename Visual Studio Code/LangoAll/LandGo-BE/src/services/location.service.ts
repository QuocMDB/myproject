import { Types } from "mongoose";
import { PaginatedResult } from "../types";
import { District, Province, Ward } from "../models";

export const getProvinces = async (query: {
  page?: string;
  limit?: string;
}): Promise<PaginatedResult<any>> => {
  const page = Number(query.page ?? 1);
  const limit = Number(query.limit ?? 50);
  const skip = (page - 1) * limit;

  const [data, total] = await Promise.all([
    Province.find().sort({ name: 1 }).skip(skip).limit(limit).lean(),
    Province.countDocuments(),
  ]);

  return {
    data,
    total,
    page,
    limit,
    pages: Math.ceil(total / limit),
  };
};

export const getDistrictsByProvince = async (
  provinceId: string,
  query: { page?: string; limit?: string }
): Promise<PaginatedResult<any>> => {
  const page = Number(query.page ?? 1);
  const limit = Number(query.limit ?? 50);
  const skip = (page - 1) * limit;

  const filter = { province: provinceId };

  const [data, total] = await Promise.all([
    District.find(filter).sort({ name: 1 }).skip(skip).limit(limit).lean(),
    District.countDocuments(filter),
  ]);

  return {
    data,
    total,
    page,
    limit,
    pages: Math.ceil(total / limit),
  };
};

export const getWardsByDistrict = async (
  districtId: string,
  query: { page?: string; limit?: string }
): Promise<PaginatedResult<any>> => {
  const page = Number(query.page ?? 1);
  const limit = Number(query.limit ?? 50);
  const skip = (page - 1) * limit;

  const filter = { district: districtId };

  const [data, total] = await Promise.all([
    Ward.find(filter).sort({ name: 1 }).skip(skip).limit(limit).lean(),
    Ward.countDocuments(filter),
  ]);

  return {
    data,
    total,
    page,
    limit,
    pages: Math.ceil(total / limit),
  };
};
