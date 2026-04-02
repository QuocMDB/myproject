import { Request, Response, NextFunction } from "express";
import * as locationService from "../services/location.service";

export const getProvinces = async (
  req: Request,
  res: Response,
  next: NextFunction
): Promise<void> => {
  const result = await locationService.getProvinces(req.query as never);
  res.json({
    success: true,
    data: result.data,
    pagination: {
      page: result.page,
      limit: result.limit,
      total: result.total,
    },
  });
};

export const getDistrictsByProvince = async (
  req: Request,
  res: Response,
  next: NextFunction
): Promise<void> => {
  const result = await locationService.getDistrictsByProvince(
    req.params.provinceId,
    req.query as never
  );

  res.json({
    success: true,
    data: result.data,
    pagination: {
      page: result.page,
      limit: result.limit,
      total: result.total,
    },
  });
};

export const getWardsByDistrict = async (
  req: Request,
  res: Response,
  next: NextFunction
): Promise<void> => {
  const result = await locationService.getWardsByDistrict(
    req.params.districtId,
    req.query as never
  );

  res.json({
    success: true,
    data: result.data,
    pagination: {
      page: result.page,
      limit: result.limit,
      total: result.total,
    },
  });
};
