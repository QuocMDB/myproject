import jwt from "jsonwebtoken";
import { parsePhoneNumberFromString } from "libphonenumber-js";
import { District, Province, User, Ward } from "../models";
import {
  RegisterInput,
  LoginInput,
  LoginPayload,
  VerifyPhoneInput,
  VerifyEmailOtpInput,
  ResendOtpInput,
  AuthTokenPayload,
  ForgotPasswordInput,
  ResetPasswordWithOtpInput,
} from "../types";
import { AppError } from "../utils/AppError";
import { config } from "../config";
import {
  sendEmailVerificationOtpEmail,
  sendPasswordResetOtpEmail,
} from "../utils/mailer";

const PASSWORD_RESET_OTP_EXPIRES_MS =
  config.passwordResetOtpExpiresMinutes * 60 * 1000;
const PASSWORD_RESET_OTP_RESEND_COOLDOWN_MS =
  config.passwordResetOtpResendCooldownSeconds * 1000;
const EMAIL_VERIFY_OTP_EXPIRES_MS = config.emailVerifyOtpExpiresMinutes * 60 * 1000;

const signToken = (userId: string): string => {
  return jwt.sign({ id: userId }, config.jwtSecret, {
    expiresIn: config.jwtExpiresIn as jwt.SignOptions["expiresIn"],
  });
};

const signRefreshToken = (userId: string): string => {
  return jwt.sign({ id: userId }, config.jwtRefreshSecret, {
    expiresIn: config.jwtRefreshExpiresIn as jwt.SignOptions["expiresIn"],
  });
};

const generateOtp = (): string =>
  Math.floor(100000 + Math.random() * 900000).toString();

export const register = async (
  input: RegisterInput
): Promise<{ userId: string; emailOtpExpiresInSeconds: number }> => {
  const {
    phone,
    email,
    password,
    name,
    provinceCode,
    provinceName,
    districtCode,
    districtName,
    wardCode,
    wardName,
    addressDetail,
  } = input;

  const existingByPhone = await User.findOne({ phone });
  const existingByEmail = await User.findOne({ email });

  if (existingByPhone?.isPhoneVerified) {
    throw new AppError(
      "This phone number is already registered",
      409,
      "PHONE_ALREADY_EXISTS"
    );
  }

  if (existingByEmail?.isEmailVerified) {
    throw new AppError(
      "This email is already registered",
      409,
      "EMAIL_ALREADY_EXISTS"
    );
  }

  if (
    existingByPhone &&
    existingByEmail &&
    existingByPhone._id.toString() !== existingByEmail._id.toString()
  ) {
    throw new AppError(
      "Registration information belongs to two different accounts. Please use different information.",
      409,
      "ACCOUNT_CONFLICT"
    );
  }

  let province = await Province.findOne({
    $or: [{ code: provinceCode }, { name: provinceName }],
  });

  if (province) {
    province.code = provinceCode;
    province.name = provinceName;
    await province.save();
  } else {
    province = await Province.create({
      code: provinceCode,
      name: provinceName,
    });
  }

  let district = await District.findOne({
    province: province._id,
    $or: [{ code: districtCode }, { name: districtName }],
  });

  if (district) {
    district.code = districtCode;
    district.name = districtName;
    district.province = province._id;
    await district.save();
  } else {
    district = await District.create({
      province: province._id,
      code: districtCode,
      name: districtName,
    });
  }

  let ward = await Ward.findOne({
    province: province._id,
    district: district._id,
    $or: [{ code: wardCode }, { name: wardName }],
  });

  if (ward) {
    ward.code = wardCode;
    ward.name = wardName;
    ward.province = province._id;
    ward.district = district._id;
    await ward.save();
  } else {
    ward = await Ward.create({
      province: province._id,
      district: district._id,
      code: wardCode,
      name: wardName,
    });
  }

  const emailVerifyToken = generateOtp();
  const emailVerifyExpires = new Date(Date.now() + EMAIL_VERIFY_OTP_EXPIRES_MS);

  const reusableUser = existingByPhone ?? existingByEmail;

  let user;

  if (reusableUser) {
    reusableUser.phone = phone;
    reusableUser.email = email;
    reusableUser.password = password;
    reusableUser.name = name;
    reusableUser.province = province._id;
    reusableUser.district = district._id;
    reusableUser.ward = ward._id;
    reusableUser.addressDetail = addressDetail || undefined;
    reusableUser.description = reusableUser.description || "New user";
    reusableUser.isEmailVerified = false;
    reusableUser.isPhoneVerified = false;
    reusableUser.emailVerifyToken = emailVerifyToken;
    reusableUser.emailVerifyExpires = emailVerifyExpires;
    reusableUser.refreshToken = undefined;

    await reusableUser.save();
    user = reusableUser;
  } else {
    user = await User.create({
      phone,
      email,
      password,
      name,
      isPhoneVerified: false,
      isEmailVerified: false,
      description: "New user",
      province: province._id,
      district: district._id,
      ward: ward._id,
      addressDetail: addressDetail || undefined,
      emailVerifyToken,
      emailVerifyExpires,
    });
  }

  await sendEmailVerificationOtpEmail(
    email,
    user.emailVerifyToken as string,
    config.emailVerifyOtpExpiresMinutes,
    user.name
  );

  return {
    userId: user._id.toString(),
    emailOtpExpiresInSeconds: config.emailVerifyOtpExpiresMinutes * 60,
  };
};

export const verifyEmailOtp = async (
  input: VerifyEmailOtpInput
): Promise<void> => {
  const { email, otp } = input;

  const user = await User.findOne({ email }).select(
    "+emailVerifyToken +emailVerifyExpires"
  );

  if (!user) {
    throw new AppError("No account found with this email", 404, "EMAIL_NOT_FOUND");
  }

  if (user.isEmailVerified) {
    throw new AppError("Email has already been verified", 400, "EMAIL_ALREADY_VERIFIED");
  }

  if (!user.emailVerifyToken || user.emailVerifyToken !== otp) {
    throw new AppError("Invalid OTP", 400, "OTP_INVALID");
  }

  if (!user.emailVerifyExpires || new Date() > user.emailVerifyExpires) {
    throw new AppError("OTP has expired", 400, "OTP_EXPIRED");
  }

  user.isEmailVerified = true;
  user.isPhoneVerified = true;
  user.emailVerifyToken = undefined;
  user.emailVerifyExpires = undefined;

  await user.save();
};

export const verifyPhone = async (
  input: VerifyPhoneInput
): Promise<AuthTokenPayload> => {
  const { phone, otp } = input;

  const user = await User.findOne({ phone }).select(
    "+phoneOtp +phoneOtpExpires"
  );

  if (!user) {
    throw new AppError("No user found with this phone number", 404, "PHONE_NOT_FOUND");
  }

  if (user.isPhoneVerified) {
    throw new AppError("Phone number has already been verified", 400, "PHONE_ALREADY_VERIFIED");
  }

  if (
    user.phoneOtp !== otp ||
    !user.phoneOtpExpires ||
    new Date() > user.phoneOtpExpires
  ) {
    throw new AppError("Invalid OTP or OTP has expired", 400, "OTP_INVALID_OR_EXPIRED");
  }

  user.isPhoneVerified = true;
  user.phoneOtp = undefined;
  user.phoneOtpExpires = undefined;

  await user.save();

  return {
    token: signToken(user._id.toString()),
    user: {
      id: user._id.toString(),
      name: user.name,
      email: user.email ?? null,
      phone: user.phone,
      role: user.role,
      avatar: user.avatar,
    },
  };
};

export const resendOtp = async (input: ResendOtpInput): Promise<void> => {
  const { phone } = input;

  const user = await User.findOne({ phone }).select("+phoneOtpExpires");

  if (!user) {
    throw new AppError("No user found with this phone number", 404, "PHONE_NOT_FOUND");
  }

  if (
    user.phoneOtpExpires &&
    new Date() < new Date(user.phoneOtpExpires.getTime() - 4 * 60 * 1000)
  ) {
    throw new AppError("Please wait before requesting a new OTP", 429, "OTP_RESEND_TOO_SOON");
  }

  const otp = generateOtp();

  user.phoneOtp = otp;
  user.phoneOtpExpires = new Date(Date.now() + 5 * 60 * 1000);

  await user.save();

  console.log(`[DEV] Resent OTP for ${phone}: ${otp}`);
};

export const login = async (input: LoginInput): Promise<LoginPayload> => {
  const { phone, password } = input;

  const user = await User.findOne({ phone }).select("+password");

  if (!user || !(await user.comparePassword(password))) {
    throw new AppError("Phone number or password is incorrect", 401, "INVALID_CREDENTIALS");
  }

  if (user.isBanned) {
    throw new AppError("Account has been banned", 403, "ACCOUNT_BANNED");
  }

  if (!user.isEmailVerified) {
    throw new AppError("Email has not been verified", 403, "EMAIL_NOT_VERIFIED");
  }

  if (!user.isPhoneVerified) {
    throw new AppError("Phone number has not been verified", 403, "PHONE_NOT_VERIFIED");
  }

  const accessToken = signToken(user._id.toString());
  const refreshToken = signRefreshToken(user._id.toString());

  user.refreshToken = refreshToken;
  await user.save();

  return {
    accessToken,
    refreshToken,
    user: {
      id: user._id.toString(),
      name: user.name,
      email: user.email ?? null,
      phone: user.phone,
      role: user.role,
      avatar: user.avatar,
    },
  };
};

export const refreshAccessToken = async (
  token: string
): Promise<{ accessToken: string }> => {
  let decoded: jwt.JwtPayload;

  try {
    decoded = jwt.verify(token, config.jwtRefreshSecret) as jwt.JwtPayload;
  } catch {
    throw new AppError("Refresh token is invalid or has expired", 401, "REFRESH_TOKEN_INVALID");
  }

  const userId = decoded.id as string | undefined;
  if (!userId) throw new AppError("Refresh token is invalid", 401, "REFRESH_TOKEN_INVALID");

  const user = await User.findById(userId).select("+refreshToken");
  if (!user) throw new AppError("No user found with this ID", 401, "USER_NOT_FOUND");
  if (!user.refreshToken || user.refreshToken !== token) {
    throw new AppError("Refresh token is not recognized by the system", 401, "REFRESH_TOKEN_MISMATCH");
  }

  return { accessToken: signToken(user._id.toString()) };
};

export const logout = async (token: string): Promise<void> => {
  const user = await User.findOne({ refreshToken: token }).select("+refreshToken");

  if (!user) {
    throw new AppError("Refresh token is invalid", 400, "REFRESH_TOKEN_INVALID");
  }

  user.refreshToken = undefined;
  await user.save();
};

export const forgotPassword = async (
  input: ForgotPasswordInput
): Promise<{ expiresInSeconds: number }> => {
  const { email } = input;

  const user = await User.findOne({ email }).select("+passwordResetExpires");

  if (!user) {
    throw new AppError("Email has not been registered in the system", 404, "EMAIL_NOT_FOUND");
  }

  if (user.passwordResetExpires) {
    const previousIssuedAt = new Date(
      user.passwordResetExpires.getTime() - PASSWORD_RESET_OTP_EXPIRES_MS
    );

    if (Date.now() - previousIssuedAt.getTime() < PASSWORD_RESET_OTP_RESEND_COOLDOWN_MS) {
      throw new AppError("Please wait before requesting a new OTP", 429, "OTP_RESEND_TOO_SOON");
    }
  }

  const otp = generateOtp();

  user.passwordResetToken = otp;
  user.passwordResetExpires = new Date(Date.now() + PASSWORD_RESET_OTP_EXPIRES_MS);

  await user.save();

  await sendPasswordResetOtpEmail(email, otp, user.name);

  return {
    expiresInSeconds: config.passwordResetOtpExpiresMinutes * 60,
  };
};

export const resetPasswordWithOtp = async (
  input: ResetPasswordWithOtpInput
): Promise<void> => {
  const { email, otp, password } = input;

  const user = await User.findOne({ email }).select(
    "+passwordResetToken +passwordResetExpires"
  );

  if (!user) {
    throw new AppError("No user found with this email", 404, "EMAIL_NOT_FOUND");
  }

  if (!user.passwordResetToken || user.passwordResetToken !== otp) {
    throw new AppError("Invalid OTP", 400, "OTP_INVALID");
  }

  if (!user.passwordResetExpires || new Date() > user.passwordResetExpires) {
    throw new AppError("OTP has expired", 400, "OTP_EXPIRED");
  }

  user.password = password;
  user.passwordResetToken = undefined;
  user.passwordResetExpires = undefined;
  user.refreshToken = undefined;

  await user.save();
};
