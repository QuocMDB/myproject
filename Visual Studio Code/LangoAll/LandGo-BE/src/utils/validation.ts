import z from "zod";
import parsePhoneNumberFromString from "libphonenumber-js";

const PASSWORD_REGEX = /^(?=.*[A-Za-z])(?=.*\d).{6,}$/;

const normalizePhoneVN = (value: string): string | null => {
    const parsed = parsePhoneNumberFromString(value.trim(), "VN");
    if (!parsed || !parsed.isValid() || parsed.country !== "VN") return null;
    return `0${parsed.nationalNumber}`;
};
const OTP_REGEX = /^\d{6}$/;


export const RegisterInputSchema = z
    .object({
        phone: z
            .string()
            .trim()
            .refine((v) => normalizePhoneVN(v), {
                message: "Phone number is invalid in Vietnam format",
            })
            .transform((v) => normalizePhoneVN(v) as string),

        email: z
            .email('Please enter a valid email address')
            .trim()
            .toLowerCase(),

        password: z
            .string()
            .trim()
            .regex(
                PASSWORD_REGEX,
                "Password must be at least 6 characters long and include both letters and numbers"
            ),

        confirmPassword: z.string().trim(),

        name: z.string().trim().min(2).max(100),

        provinceCode: z.string().regex(/^\d+$/),
        provinceName: z.string().trim(),

        districtCode: z.string().regex(/^\d+$/),
        districtName: z.string().trim(),

        wardCode: z.string().regex(/^\d+$/),
        wardName: z.string().trim(),

        addressDetail: z.string().trim().optional(),
    })
    .refine((data) => data.password === data.confirmPassword, {
        message: "Passwords do not match",
        path: ["confirmPassword"],
    }).strict();


export const ResetPasswordWithOtpSchema = z
    .object({
        email: z
            .email('Please enter a valid email address')
            .nonempty("Please enter your email")
            .trim()
            .toLowerCase(),

        otp: z
            .string()
            .nonempty("Please enter the OTP")
            .trim()
            .regex(OTP_REGEX, "OTP must be 6 digits"),

        password: z
            .string()
            .nonempty("Please enter a new password")
            .trim()
            .regex(
                PASSWORD_REGEX,
                "Password must be at least 6 characters long and include both letters and numbers"
            ),

        confirmPassword: z.string().trim(),
    })
    .refine((data) => data.password === data.confirmPassword, {
        message: "Passwords do not match",
        path: ["confirmPassword"],
    })
    .strict();


export const VerifyPhoneSchema = z.object({
    phone: z
        .string()
        .trim()
        .refine((v) => normalizePhoneVN(v), {
            message: "Phone number is invalid in Vietnam format",
        })
        .transform((v) => normalizePhoneVN(v) as string),

    otp: z
        .string()
        .trim()
        .regex(OTP_REGEX, "OTP must be 6 digits"),
}).strict();


export const ResendOtpSchema = z.object({
    phone: z
        .string()
        .trim()
        .refine((v) => normalizePhoneVN(v), {
            message: "Phone number is invalid in Vietnam format",
        })
        .transform((v) => normalizePhoneVN(v) as string),
}).strict();


export const LoginSchema = z.object({
    phone: z
        .string()
        .trim()
        .refine((v) => normalizePhoneVN(v), {
            message: "Phone number is invalid in Vietnam format",
        })
        .transform((v) => normalizePhoneVN(v) as string),

    password: z.string().trim(),
}).strict();


export const ForgotPasswordSchema = z.object({
    email: z
        .email('Please enter a valid email address')
        .trim()
        .toLowerCase()

}).strict();


export const VerifyEmailOtpSchema = z.object({
    email: z
        .email('Please enter a valid email address')
        .trim()
        .toLowerCase(),

    otp: z
        .string()
        .trim()
        .regex(OTP_REGEX, "OTP must be 6 digits"),
}).strict();