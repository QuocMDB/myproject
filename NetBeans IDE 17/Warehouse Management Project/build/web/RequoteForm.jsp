<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Đơn Báo Giá</title>
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
  <style>
      /* Reset CSS */
      * {
          margin: 0;
          padding: 0;
          box-sizing: border-box;
          font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      }

      body {
          background-color: #f8f9fa;
          min-height: 100vh;
          color: #333;
          padding: 20px;
      }

      /* Container chính - một khối duy nhất */
      .container {
          background: white;
          padding: 40px;
          border-radius: 8px;
          box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
          max-width: 1200px;
          margin: 0 auto;
      }

      /* Header - Tên đơn ở giữa trên cùng */
      .header-section {
          text-align: center;
          margin-bottom: 30px;
          padding-bottom: 20px;
          border-bottom: 2px solid #e9ecef;
      }

      h1 {
          color: #2c3e50;
          font-size: 28px;
          font-weight: 600;
          margin-bottom: 8px;
      }

      .subtitle {
          color: #6c757d;
          font-size: 14px;
      }

      /* Thông tin đơn hàng - style nổi bật như form kia */
      .order-info-section {
          display: flex;
          justify-content: center;
          margin-bottom: 25px;
      }

      .order-info-card {
          background: #fbfbfb;
          padding: 15px 20px;
          border-radius: 6px;
          border: 1px solid #e9ecef;
          display: grid;
          grid-template-columns: 1fr 1fr;
          gap: 20px;
          max-width: 450px;
          width: 100%;
      }

      .order-info-card .form-group {
          margin-bottom: 0;
      }

      .order-info-card label {
          font-size: 13px;
          color: #6c757d;
          font-weight: 500;
          margin-bottom: 4px;
      }

      .order-info-card input, .order-info-card textarea {
          padding: 8px 10px;
          font-size: 13px;
          border: 1px solid #dee2e6;
          border-radius: 4px;
      }

      .order-info-card input[readonly], .order-info-card textarea[readonly] {
          background-color: #f8f9fa;
          color: #495057;
          font-weight: 500;
          cursor: not-allowed;
      }

      /* Section headers */
      .section-header {
          display: flex;
          align-items: center;
          justify-content: center;
          gap: 10px;
          margin: 30px 0 20px 0;
          padding-bottom: 8px;
          border-bottom: 1px solid #dee2e6;
      }

      .section-header i {
          color: #4a90e2;
          font-size: 18px;
      }

      .section-header h3 {
          color: #2c3e50;
          font-size: 18px;
          font-weight: 600;
      }

      /* Form elements */
      .form-group {
          margin-bottom: 20px;
      }

      label {
          display: block;
          font-size: 14px;
          color: #495057;
          margin-bottom: 6px;
          font-weight: 500;
      }

      label i {
          color: #4a90e2;
          margin-right: 5px;
          width: 16px;
      }

      input, select, textarea {
          width: 100%;
          padding: 12px;
          border: 1px solid #ced4da;
          border-radius: 6px;
          font-size: 14px;
          transition: border-color 0.2s ease;
          background: white;
      }

      input:focus, select:focus, textarea:focus {
          outline: none;
          border-color: #4a90e2;
          box-shadow: 0 0 0 2px rgba(74, 144, 226, 0.1);
      }

      input[readonly], textarea[readonly] {
          background-color: #f8f9fa;
          color: #6c757d;
          cursor: not-allowed;
      }

      /* Layout thông tin - tất cả ở giữa */
      .centered-info {
          max-width: 800px;
          margin: 0 auto;
          display: grid;
          grid-template-columns: 1fr;
          gap: 20px;
          margin-bottom: 25px;
      }

      .centered-info-row {
          display: grid;
          grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
          gap: 20px;
      }

      /* Bảng sản phẩm */
      .items-section {
          background: #fafafa;
          padding: 20px;
          border-radius: 8px;
          border: 1px solid #e9ecef;
          margin: 20px 0;
      }

      .items-table table {
          width: 100%;
          border-collapse: collapse;
          margin: 15px 0;
          background: white;
          border-radius: 6px;
          overflow: hidden;
          box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
      }

      .items-table th {
          background: #4a90e2;
          color: white;
          padding: 12px 8px;
          text-align: center;
          font-weight: 600;
          font-size: 13px;
      }

      .items-table td {
          padding: 10px 8px;
          text-align: center;
          border-bottom: 1px solid #e9ecef;
          background: white;
      }

      .items-table tr:hover td {
          background: #f8f9ff;
      }

      /* Cố định width cho các cột - code trước tên */
      .items-table table th:nth-child(1), .items-table table td:nth-child(1) { width: 60px; }
      .items-table table th:nth-child(2), .items-table table td:nth-child(2) { width: 100px; }
      .items-table table th:nth-child(3), .items-table table td:nth-child(3) { width: 300px; }
      .items-table table th:nth-child(4), .items-table table td:nth-child(4) { width: 100px; }
      .items-table table th:nth-child(5), .items-table table td:nth-child(5) { width: 120px; }
      .items-table table th:nth-child(6), .items-table table td:nth-child(6) { width: 120px; }
      .items-table table th:nth-child(7), .items-table table td:nth-child(7) { width: 120px; }
      .items-table table th:nth-child(8), .items-table table td:nth-child(8) { width: auto; }

      .items-table textarea, .items-table input, .items-table select {
          border: 1px solid #dee2e6;
          border-radius: 4px;
          padding: 6px 8px;
          font-size: 13px;
      }

      .items-table textarea:focus, .items-table input:focus, .items-table select:focus {
          border-color: #4a90e2;
          box-shadow: 0 0 0 1px rgba(74, 144, 226, 0.1);
      }

      /* Style cho input readonly trong bảng items */
      .items-table input[readonly], .items-table textarea[readonly] {
          background-color: #f8f9fa !important;
          border: none !important;
          color: #6c757d;
          cursor: not-allowed;
      }

      /* Buttons */
      .btn {
          padding: 12px 24px;
          border: none;
          border-radius: 6px;
          font-size: 14px;
          font-weight: 500;
          cursor: pointer;
          transition: all 0.2s ease;
          text-decoration: none;
          display: inline-flex;
          align-items: center;
          gap: 8px;
      }

      .btn-primary {
          background: #4a90e2;
          color: white;
      }

      .btn-primary:hover {
          background: #357abd;
          transform: translateY(-1px);
      }

      .btn-success {
          background: #28a745;
          color: white;
      }

      .btn-success:hover {
          background: #218838;
          transform: translateY(-1px);
      }

      .btn-secondary {
          background: #6c757d;
          color: white;
      }

      .btn-secondary:hover {
          background: #5a6268;
          transform: translateY(-1px);
      }

      .button-container {
          display: flex;
          justify-content: center;
          align-items: center;
          gap: 15px;
          margin-top: 30px;
          padding-top: 20px;
          border-top: 1px solid #dee2e6;
      }

      /* Required field indicator */
      .required {
          color: #dc3545;
          margin-left: 2px;
      }

      /* Alert styles */
      .alert {
          padding: 12px 16px;
          border-radius: 6px;
          margin-bottom: 20px;
          border: 1px solid transparent;
      }

      .alert-info {
          background-color: #d1ecf1;
          border-color: #bee5eb;
          color: #0c5460;
      }

      /* Responsive */
      @media (max-width: 768px) {
          body {
              padding: 10px;
          }

          .container {
              padding: 20px;
          }

          .order-info-card {
              grid-template-columns: 1fr;
              gap: 15px;
              max-width: none;
          }

          .centered-info-row {
              grid-template-columns: 1fr;
          }

          h1 {
              font-size: 24px;
          }

          .button-container {
              flex-direction: column;
          }

          .button-container .btn {
              width: 100%;
              justify-content: center;
          }
      }

      @media (max-width: 600px) {
          .order-info-section {
              justify-content: stretch;
          }

          .order-info-card {
              max-width: 100%;
          }
      }

      /* Table responsive */
      @media (max-width: 1024px) {
          .items-table {
              overflow-x: auto;
          }
          
          .items-table table {
              min-width: 900px;
          }
      }

      /* Focus states */
      .form-group:focus-within label {
          color: #4a90e2;
      }
  </style>
</head>
<body>
  <div class="container">
      <!-- Header - Tên đơn ở giữa trên cùng -->
      <div class="header-section">
          <h1>Đơn Báo Giá Sản Phẩm</h1>
          <p class="subtitle">Vui lòng điền đầy đủ thông tin để tạo báo giá</p>
      </div>

      <!-- Form gửi báo giá đến servlet submitpurchaseorder -->
      <form id="myForm" action="submitpurchaseorder" method="post">
          <!-- Hidden field chứa ID của request gốc -->
          <input type="hidden" name="originalRequestId" value="${requestId}">

          <!-- Thông tin đơn hàng - style nổi bật -->
          <div class="order-info-section">
              <div class="order-info-card">
                  <div class="form-group">
                      <label>ID Báo giá <span class="required">*</span></label>
                      <textarea rows="1" name="quote_id" style="resize: none; overflow: hidden;" readonly>${requestId}</textarea>
                  </div>

                  <div class="form-group">
                      <label>Ngày tạo báo giá <span class="required">*</span></label>
                      <input type="date" name="quote_date" required>
                  </div>
              </div>
          </div>

          <!-- Thông tin người tạo báo giá -->
          <div class="section-header">
              <i class="fas fa-user"></i>
              <h3>Thông Tin Người Tạo Báo Giá</h3>
          </div>

          <div class="centered-info">
              <div class="centered-info-row">
                  <div class="form-group">
                      <label>Người tạo đơn <span class="required">*</span></label>
                      <input type="text" value="${sessionScope.currentUser}" readonly> 
                  </div>
                  <div class="form-group">
                      <label>Mục đích mua hàng <span class="required">*</span></label>
                      <textarea rows="1" name="quote_note" style="resize: none; overflow: hidden;" readonly>${reason}</textarea>
                  </div>
              </div>
          </div>

          <!-- Thông tin nhà cung cấp -->
          <div class="section-header">
              <i class="fas fa-building"></i>
              <h3>Thông Tin Nhà Cung Cấp</h3>
          </div>

          <div class="centered-info">
              <div class="centered-info-row">
                  <div class="form-group">
                      <label>Nhà cung cấp <span class="required">*</span></label>
                      <select name="supplier_name" onchange="handleSupplierChange(this)" required>
                          <option value="" disabled selected>-- Chọn nhà cung cấp --</option>
                          <c:forEach var="sn" items="${supplier_list}">
                              <option value="${sn.name}">
                                  ${sn.name}
                              </option>
                          </c:forEach>
                      </select>
                  </div>
                  <div class="form-group">
                      <label>Điện thoại <span class="required">*</span></label>
                      <textarea rows="1" name="supplier_phone" style="resize: none; overflow: hidden;" oninput="autoResize(this)" readonly></textarea>
                  </div>
              </div>

              <div class="centered-info-row">
                  <div class="form-group">
                      <label>Địa chỉ <span class="required">*</span></label>
                      <textarea rows="1" name="supplier_address" style="resize: none; overflow: hidden;" oninput="autoResize(this)" readonly></textarea>
                  </div>
                  <div class="form-group">
                      <label>Email <span class="required">*</span></label>
                      <textarea rows="1" name="supplier_email" style="resize: none; overflow: hidden;" oninput="autoResize(this)" readonly></textarea>
                  </div>
              </div>
          </div>

          <!-- Danh sách sản phẩm -->
          <div class="section-header">
              <i class="fas fa-boxes"></i>
              <h3>Chi Tiết Mặt Hàng Và Báo Giá</h3>
          </div>

          <div class="items-section">
              <div class="alert alert-info">
                  <i class="fas fa-info-circle"></i>
                  Vui lòng nhập giá cho từng sản phẩm để hoàn thành báo giá
              </div>

              <div class="items-table">
                  <table>
                      <thead>
                          <tr>
                              <th>STT</th>
                              <th>Code</th>
                              <th>Tên mặt hàng</th>
                              <th>Đơn vị</th>
                              <th>Số lượng</th>
                              <th>Giá trên 1 đơn vị</th>
                              <th>Thành tiền</th>
                              <th>Ghi chú</th>
                          </tr>
                      </thead>
                      <tbody id="itemsTableBody">
                          <!-- JSTL c:choose để kiểm tra có items hay không -->
                          <c:choose>
                              <c:when test="${not empty items}">
                                  <!-- Lặp qua danh sách items từ request gốc -->
                                  <c:forEach var="item" items="${items}" varStatus="loop">
                                      <tr>
                                          <td>
                                              <!-- STT tự động từ loop.count -->
                                              <textarea name="stt" rows="1" readonly 
                                                        style="text-align: center; resize: none; overflow: hidden;">${loop.count}</textarea>
                                          </td>
                                          <td>
                                              <!-- Mã sản phẩm từ item, readonly -->
                                              <textarea name="product_code" rows="1" readonly 
                                                        style="text-align: center; resize: none; overflow: hidden;">${item.productCode}</textarea>
                                          </td>
                                          <td>
                                              <!-- Tên sản phẩm từ item, readonly -->
                                              <textarea name="product_name" rows="1" readonly 
                                                        style="resize: none; overflow: hidden;" 
                                                        oninput="autoResize(this)">${item.productName}</textarea>
                                          </td>
                                          <td>
                                              <!-- Đơn vị từ item, readonly -->
                                              <textarea name="unit" rows="1" readonly 
                                                        style="text-align: center; resize: none; overflow: hidden;">${item.unit}</textarea>
                                          </td>
                                          <td>
                                              <!-- Số lượng từ item, readonly -->
                                              <textarea name="quantity" rows="1" readonly 
                                                        style="text-align: center; resize: none; overflow: hidden;">${item.quantity}</textarea>
                                          </td>
                                          <td>
                                              <!-- Input giá - có thể chỉnh sửa, required -->
                                              <textarea name="pricePerUnit" rows="1" 
                                                        class="price-input"
                                                        placeholder="Nhập giá" 
                                                        required 
                                                        oninput="validatePrice(this); calculateTotal(this); autoResize(this)"
                                                        onblur="formatPrice(this)"
                                                        onkeypress="return isNumberKey(event)"
                                                        style="text-align: center; resize: none; overflow: hidden;"></textarea>
                                          </td>
                                          <td>
                                              <!-- Thành tiền tự động tính, readonly -->
                                              <textarea name="totalPrice" rows="1" readonly 
                                                        style="text-align: center; resize: none; overflow: hidden;"></textarea>
                                          </td>
                                          <td>
                                              <!-- Ghi chú có thể chỉnh sửa -->
                                              <textarea name="quote_item_note" rows="1" 
                                                        style="resize: none; overflow: hidden;" 
                                                        oninput="autoResize(this)" 
                                                        placeholder="Ghi chú báo giá">${item.note}</textarea>
                                          </td>
                                      </tr>
                                  </c:forEach>
                              </c:when>
                          </c:choose>
                      </tbody>
                  </table>
              </div>

              <!-- Tổng kết báo giá -->
              <div class="form-group">
                  <label>Tổng kết báo giá <span class="required">*</span></label>
                  <textarea rows="4" name="quote_summary" style="resize: vertical;" required placeholder="Nhập tổng kết về báo giá này..."></textarea>
              </div>
          </div>

          <!-- Buttons -->
          <div class="button-container">
              <button type="submit" class="btn btn-success">
                  <i class="fas fa-paper-plane"></i> Gửi Báo Giá
              </button>
              <a href="listpurchaseorder" class="btn btn-secondary">
                  <i class="fas fa-arrow-left"></i> Quay Lại
              </a>
          </div>
      </form>
  </div>

  <script>
      function autoResize(textarea) {
          textarea.style.height = 'auto';
          textarea.style.height = Math.min(textarea.scrollHeight, 100) + 'px';
      }

      function calculateTotal(input) {
          const row = input.closest('tr');
          const quantityElement = row.querySelector('input[name="quantity"], textarea[name="quantity"]');
          const priceElement = row.querySelector('input[name="pricePerUnit"], textarea[name="pricePerUnit"]');
          const totalPriceElement = row.querySelector('input[name="totalPrice"], textarea[name="totalPrice"]');
          
          if (quantityElement && priceElement && totalPriceElement) {
              const quantity = parseFloat(quantityElement.value.replace(/,/g, '').replace(',', '.')) || 0;
              const pricePerUnit = parseFloat(priceElement.value.replace(/,/g, '').replace(',', '.')) || 0;
              const totalPrice = quantity * pricePerUnit;
              
              totalPriceElement.value = totalPrice.toLocaleString('vi-VN', {
                  minimumFractionDigits: 0,
                  maximumFractionDigits: 2
              });
          }
      }

      function isNumberKey(evt) {
          var charCode = (evt.which) ? evt.which : evt.keyCode;
          var inputValue = evt.target.value;
          
          if ([8, 9, 27, 13, 37, 38, 39, 40, 46].indexOf(charCode) !== -1) {
              return true;
          }

          if (charCode == 46) {
              if (inputValue.indexOf('.') !== -1) {
                  return false;
              }
              return true;
          }

          if (charCode == 44) {
              if (inputValue.indexOf(',') !== -1 || inputValue.indexOf('.') !== -1) {
                  return false;
              }
              return true;
          }

          if (charCode < 48 || charCode > 57) {
              return false;
          }

          return true;
      }

      function validatePrice(textarea) {
          let value = textarea.value;
          if (value.includes(',')) {
              value = value.replace(',', '.');
              textarea.value = value;
          }

          const parts = value.split('.');
          if (parts.length > 2) {
              textarea.value = parts[0] + '.' + parts[1];
          } else if (parts.length === 2 && parts[1].length > 2) {
              textarea.value = parts[0] + '.' + parts[1].substring(0, 2);
          }
      }

      // Format giá theo định dạng Việt Nam khi blur
      function formatPrice(textarea) {
          let value = textarea.value.trim();
          if (value === '') return;
          
          value = value.replace(/,/g, '').replace(',', '.');
          const numValue = parseFloat(value);
          
          if (!isNaN(numValue) && numValue >= 0 && numValue <= Number.MAX_SAFE_INTEGER) {
              textarea.value = numValue.toLocaleString('vi-VN', {
                  minimumFractionDigits: 0,
                  maximumFractionDigits: 2
              });
          } else if (numValue > Number.MAX_SAFE_INTEGER) {
              alert('Giá trị quá lớn! Vui lòng nhập số nhỏ hơn.');
              textarea.value = '';
          }
      }

      // Dữ liệu supplier từ server (sẽ được render từ JSTL)
      const supplierData = {
          <c:forEach var="supplier" items="${supplier_list}" varStatus="status">
          "${supplier.name}": {
              address: "${supplier.address}",
              phone: "${supplier.phone}",
              email: "${supplier.email}"
          }<c:if test="${!status.last}">,</c:if>
          </c:forEach>
      };

      // Hàm xử lý khi thay đổi supplier
      function handleSupplierChange(selectElement) {
          const selectedSupplier = selectElement.value;
          
          // Lấy các element cần điền thông tin
          const addressField = document.querySelector('textarea[name="supplier_address"]');
          const phoneField = document.querySelector('textarea[name="supplier_phone"]');
          const emailField = document.querySelector('textarea[name="supplier_email"]');
          
          if (selectedSupplier && supplierData[selectedSupplier]) {
              // Điền thông tin tự động
              const supplier = supplierData[selectedSupplier];
              addressField.value = supplier.address || '';
              phoneField.value = supplier.phone || '';
              emailField.value = supplier.email || '';
              
              // Auto resize các textarea
              autoResize(addressField);
              autoResize(phoneField);
              autoResize(emailField);
          } else {
              // Xóa thông tin nếu không chọn supplier
              addressField.value = '';
              phoneField.value = '';
              emailField.value = '';
              autoResize(addressField);
              autoResize(phoneField);
              autoResize(emailField);
          }
      }

      // Gắn event listener khi trang load
      document.addEventListener('DOMContentLoaded', function() {
          const supplierSelect = document.querySelector('select[name="supplier_name"]');
          if (supplierSelect) {
              supplierSelect.addEventListener('change', function() {
                  handleSupplierChange(this);
              });
          }

          // Form validation
          document.querySelector('form').addEventListener('submit', function(e) {
              const requiredFields = this.querySelectorAll('[required]');
              let isValid = true;

              requiredFields.forEach(field => {
                  if (!field.value.trim()) {
                      isValid = false;
                      field.style.borderColor = '#dc3545';
                  } else {
                      field.style.borderColor = '#28a745';
                  }
              });

              if (!isValid) {
                  e.preventDefault();
                  alert('Vui lòng điền đầy đủ thông tin bắt buộc!');
              }
          });
      });
  </script>
</body>
</html>