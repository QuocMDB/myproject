<%--
  Document   : ExportRequestSuccessNotification
  Created on : June 11, 2025, 3:43:00 PM
  Author     : Monica
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Thông Báo Tạo Đơn Xuất Kho Thành Công</title>
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
          max-width: 600px;
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
          stroke: #dc3545;
          stroke-width: 2;
          stroke-miterlimit: 10;
          fill: none;
          animation: stroke 0.6s cubic-bezier(0.65, 0, 0.45, 1) forwards;
      }

      .checkmark__check {
          transform-origin: 50% 50%;
          stroke: #dc3545;
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

      .success-info {
          background-color: #f8f9fa;
          border: 1px solid #dee2e6;
          border-radius: 8px;
          padding: 20px;
          margin: 20px 0;
          text-align: left;
      }

      .success-info h3 {
          color: #dc3545;
          font-size: 18px;
          margin-bottom: 15px;
          text-align: center;
      }

      .info-row {
          display: flex;
          justify-content: space-between;
          margin-bottom: 10px;
          padding: 8px 0;
          border-bottom: 1px solid #e9ecef;
      }

      .info-row:last-child {
          border-bottom: none;
      }

      .info-label {
          font-weight: 600;
          color: #495057;
          min-width: 120px;
      }

      .info-value {
          color: #6c757d;
          text-align: right;
          flex: 1;
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
          flex-wrap: wrap;
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
          min-width: 150px;
      }

      .btn-home {
          background: #6c757d;
      }

      .btn-home:hover {
          background: #5a6268;
          transform: translateY(-2px);
      }

      .btn-continue {
          background: #dc3545;
      }

      .btn-continue:hover {
          background: #c82333;
          transform: translateY(-2px);
      }

      .btn-view {
          background: #007bff;
      }

      .btn-view:hover {
          background: #0056b3;
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

          .info-row {
              flex-direction: column;
              gap: 5px;
          }

          .info-value {
              text-align: left;
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
      <h1>Tạo Đơn Xuất Kho Thành Công!</h1>
      <p>Đơn yêu cầu xuất kho của bạn đã được tạo thành công. Hệ thống sẽ xử lý yêu cầu trong thời gian sớm nhất.</p>
      
      <div class="success-info">
          <h3>Thông Tin Đơn Xuất Kho</h3>
          <div class="info-row">
              <span class="info-label">Mã đơn:</span>
              <span class="info-value">${requestScope.exportRequestId}</span>
          </div>
          <div class="info-row">
              <span class="info-label">Người yêu cầu:</span>
              <span class="info-value">${sessionScope.currentUser}</span>
          </div>
          <div class="info-row">
              <span class="info-label">Ngày tạo:</span>
              <span class="info-value">${requestScope.requestDate}</span>
          </div>
          <div class="info-row">
              <span class="info-label">Bộ phận:</span>
              <span class="info-value">${requestScope.department}</span>
          </div>
          <div class="info-row">
              <span class="info-label">Người nhận:</span>
              <span class="info-value">${requestScope.recipientName}</span>
          </div>
          <div class="info-row">
              <span class="info-label">Trạng thái:</span>
              <span class="info-value">Chờ xử lý</span>
          </div>
      </div>
      
      <div class="button-group">
          <a href="Admin.jsp" class="btn btn-home">Quay Về Trang Chủ</a>
          <a href="exportRequest" class="btn btn-continue">Tạo Đơn Mới</a>
          <a href="viewExportRequests" class="btn btn-view">Xem Danh Sách Đơn</a>
      </div>
  </div>
</body>
</html>