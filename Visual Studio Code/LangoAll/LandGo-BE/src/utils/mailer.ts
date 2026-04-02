import nodemailer from "nodemailer";
import { config } from "../config";

const hasSmtpConfig =
  Boolean(config.smtpHost) &&
  Boolean(config.smtpPort) &&
  Boolean(config.smtpUser) &&
  Boolean(config.smtpPass) &&
  Boolean(config.mailFrom);

const transporter = hasSmtpConfig
  ? nodemailer.createTransport({
      host: config.smtpHost,
      port: config.smtpPort,
      secure: config.smtpSecure,
      auth: {
        user: config.smtpUser,
        pass: config.smtpPass,
      },
    })
  : null;

export const sendPasswordResetOtpEmail = async (
  email: string,
  otp: string,
  name?: string
): Promise<void> => {
  if (!transporter || !config.mailFrom) {
    console.log(`[DEV] Password reset OTP for ${email}: ${otp}`);
    return;
  }

  await transporter.sendMail({
    from: config.mailFrom,
    to: email,
    subject: "LandGo - Mã OTP đặt lại mật khẩu",
    html: `
      <div style="font-family: Arial, sans-serif; line-height: 1.5; color: #111827;">
        <h2>Đặt lại mật khẩu LandGo</h2>
        <p>Xin chào ${name ?? "bạn"},</p>
        <p>Mã OTP 6 số để đặt lại mật khẩu của bạn là:</p>
        <p style="font-size: 28px; font-weight: 700; letter-spacing: 4px; margin: 16px 0;">${otp}</p>
        <p>Mã có hiệu lực trong 10 phút.</p>
        <p>Nếu bạn không yêu cầu đặt lại mật khẩu, vui lòng bỏ qua email này.</p>
      </div>
    `,
  });
};

export const sendEmailVerificationOtpEmail = async (
  email: string,
  otp: string,
  expiresMinutes: number,
  name?: string
): Promise<void> => {
  if (!transporter || !config.mailFrom) {
    console.log(`[DEV] Email verify OTP for ${email}: ${otp}`);
    return;
  }

  await transporter.sendMail({
    from: config.mailFrom,
    to: email,
    subject: "LandGo - Mã OTP xác thực email",
    html: `
      <div style="font-family: Arial, sans-serif; line-height: 1.5; color: #111827;">
        <h2>Xác thực email tài khoản LandGo</h2>
        <p>Xin chào ${name ?? "bạn"},</p>
        <p>Mã OTP 6 số để xác thực email của bạn là:</p>
        <p style="font-size: 28px; font-weight: 700; letter-spacing: 4px; margin: 16px 0;">${otp}</p>
        <p>Mã có hiệu lực trong ${expiresMinutes} phút.</p>
        <p>Nếu bạn không thực hiện đăng ký, vui lòng bỏ qua email này.</p>
      </div>
    `,
  });
};
