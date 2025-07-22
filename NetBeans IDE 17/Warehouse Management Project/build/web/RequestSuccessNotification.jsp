<%--
    Document   : RequestSuccessNotification
    Created on : May 23, 2025, 7:21:00 PM
    Author     : Grok
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thông Báo Gửi Yêu Cầu Thành Công</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        body {
            background-color: #f0f2f5;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            padding: 20px;
        }

        .container {
            background: #fff;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
            text-align: center;
            max-width: 500px;
            width: 100%;
        }

        h1 {
            color: #333;
            font-size: 24px;
            margin-bottom: 20px;
        }

        .checkmark {
            width: 80px;
            height: 80px;
            margin: 0 auto 20px;
            position: relative;
        }

        .checkmark__circle {
            stroke: #28a745;
            stroke-width: 2;
            stroke-miterlimit: 10;
            fill: none;
            animation: stroke 0.6s cubic-bezier(0.65, 0, 0.45, 1) forwards;
        }

        .checkmark__check {
            transform-origin: 50% 50%;
            stroke: #28a745;
            stroke-width: 2;
            stroke-linecap: round;
            stroke-linejoin: round;
            animation: stroke 0.3s cubic-bezier(0.65, 0, 0.45, 1) 0.3s forwards;
        }

        @keyframes stroke {
            100% {
                stroke-dashoffset: 0;
            }
        }

        @keyframes scale {
            0%, 100% {
                transform: none;
            }
            50% {
                transform: scale3d(1.1, 1.1, 1);
            }
        }

        .checkmark {
            animation: scale 0.3s ease-in-out 0.9s both;
        }

        p {
            color: #555;
            font-size: 16px;
            margin-bottom: 30px;
        }

        .button-group {
            display: flex;
            justify-content: center;
            gap: 15px;
        }

        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 8px;
            font-size: 14px;
            cursor: pointer;
            transition: background 0.3s, transform 0.2s;
            text-decoration: none;
            color: #fff;
        }

        .btn-home {
            background: #007bff;
        }

        .btn-home:hover {
            background: #0056b3;
            transform: translateY(-2px);
        }

        .btn-continue {
            background: #28a745;
        }

        .btn-continue:hover {
            background: #218838;
            transform: translateY(-2px);
        }

        @media (max-width: 768px) {
            .container {
                padding: 20px;
            }

            .button-group {
                flex-direction: column;
                gap: 10px;
            }

            .btn {
                width: 100%;
                padding: 12px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <svg class="checkmark" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 52 52">
            <circle class="checkmark__circle" cx="26" cy="26" r="25" stroke-dasharray="166" stroke-dashoffset="166"/>
            <path class="checkmark__check" fill="none" d="M14.1 27.2l7.1 7.2 16.7-16.8" stroke-dasharray="48" stroke-dashoffset="48"/>
        </svg>
        <h1>Gửi Yêu Cầu Thành Công!</h1>
        <p>Yêu cầu của bạn đã được gửi. Chúng tôi sẽ xử lý trong thời gian sớm nhất.</p>
        <div class="button-group">
            <a href="Admin.jsp" class="btn btn-home">Quay Về Trang Chủ</a>
            <a href="loadingrequest" class="btn btn-continue">Tiếp Tục Điền Form</a>
        </div>
    </div>
</body>
</html>