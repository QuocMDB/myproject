export const config = {
  jwtSecret: process.env.JWT_SECRET!,
  jwtExpiresIn: process.env.JWT_EXPIRES_IN ?? "10m",
  jwtRefreshSecret: process.env.JWT_REFRESH_SECRET ?? process.env.JWT_SECRET!,
  jwtRefreshExpiresIn: process.env.JWT_REFRESH_EXPIRES_IN ?? "7d",
  passwordResetOtpExpiresMinutes: Number(
    process.env.PASSWORD_RESET_OTP_EXPIRES_MINUTES ?? "1"
  ),
  passwordResetOtpResendCooldownSeconds: Number(
    process.env.PASSWORD_RESET_OTP_RESEND_COOLDOWN_SECONDS ?? "60"
  ),
  emailVerifyOtpExpiresMinutes: Number(
    process.env.EMAIL_VERIFY_OTP_EXPIRES_MINUTES ?? "1"
  ),
  emailVerifyOtpResendCooldownSeconds: Number(
    process.env.EMAIL_VERIFY_OTP_RESEND_COOLDOWN_SECONDS ?? "60"
  ),
  smtpHost: process.env.SMTP_HOST,
  smtpPort: process.env.SMTP_PORT ? Number(process.env.SMTP_PORT) : undefined,
  smtpSecure: process.env.SMTP_SECURE === "true",
  smtpUser: process.env.SMTP_USER,
  smtpPass: process.env.SMTP_PASS,
  mailFrom: process.env.MAIL_FROM,
  sepayApiToken: process.env.SEPAY_API_TOKEN,
  sepayAccount: process.env.SEPAY_ACCOUNT,
  sepayBank: process.env.SEPAY_BANK,
  sepayBaseQrUrl: process.env.SEPAY_BASE_QR_URL ?? "https://qr.sepay.vn/img",
};
