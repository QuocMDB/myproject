# LandGo
🧠 DOMAIN KNOWLEDGE CỦA HỆ THỐNG

Hệ thống của bạn hiện encode những kiến thức sau:

1️⃣ Đây KHÔNG phải full marketplace

Bạn đang xây:

Real Estate Listing Platform + Reputation Layer

Không có:

Escrow

Transaction tracking

Chat

→ Giao dịch xảy ra ngoài hệ thống (qua điện thoại).

Domain assumption:
VN real estate thường giao dịch offline.

2️⃣ Phone-First Identity Model

Primary identity = phone.

Điều này encode:

Thị trường VN tin số điện thoại hơn email

Giao dịch bất động sản là high-trust domain

Người mua muốn gọi trực tiếp

3️⃣ Legal Verification Layer

Bắt buộc redBookImages.

Domain knowledge:

Pháp lý là yếu tố sống còn

Marketplace BĐS không thể giống Shopee

Giảm scam

4️⃣ Reputation Engine

Score của bài → tổng score người bán.

Domain assumption:

Trust không dựa vào số năm dùng
Mà dựa vào phản hồi cộng đồng.

Đây là social proof model.

5️⃣ Moderated Marketplace

Post phải:
pending → approved

Domain knowledge:

User-generated listing cần kiểm duyệt
Đặc biệt với tài sản giá trị cao.

6️⃣ Monetization Model

Pin system = Visibility monetization.

Không thu phí giao dịch.
Không thu commission.

Đây là:
Listing revenue model (giống Chợ Tốt).

7️⃣ Read-heavy Architecture

Bạn đang optimize cho:

Homepage sorting

Filter nhanh

Score sort

Pin sort

Domain assumption:
Read >> Write

Marketplace luôn read-heavy.

8️⃣ External Media Storage

Image không lưu DB.

Domain knowledge:

MongoDB không nên lưu binary lớn

CDN + object storage mới đúng production

## Sepay VietQR (sandbox)

- Webhook: cấu hình tới `/api/v1/payments/sepay-webhook`
- Env: `SEPAY_API_TOKEN`, `SEPAY_ACCOUNT`, `SEPAY_BANK`, (tùy chọn) `SEPAY_BASE_QR_URL` mặc định `https://qr.sepay.vn/img`
- Luồng: FE chọn tin VIP → tạo tin → gọi `/payments/sepay/initiate` lấy QR → người dùng quét → webhook xác nhận `paid` và ghim tin
