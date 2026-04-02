import { Router } from "express";
import * as locationController from "../controllers/location.controller";
import { asyncHandler } from "../middlewares/asyncHandler";

const router = Router();

router.get("/provinces", asyncHandler(locationController.getProvinces));
router.get(
  "/provinces/:provinceId/districts",
  asyncHandler(locationController.getDistrictsByProvince)
);
router.get(
  "/districts/:districtId/wards",
  asyncHandler(locationController.getWardsByDistrict)
);

export default router;
