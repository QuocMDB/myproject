<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Đơn Yêu Cầu Mua Hàng</title>
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

            /* Thông tin đơn hàng - style nhẹ nhàng hơn */
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

            .order-info-card input {
                padding: 8px 10px;
                font-size: 13px;
                border: 1px solid #dee2e6;
                border-radius: 4px;
            }

            .order-info-card input[readonly] {
                background-color: #f8f9fa;
                color: #495057;
                font-weight: 500;
                cursor: not-allowed;
            }

            /* Section headers */
            .section-header {
                display: flex;
                align-items: center;
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

            input[readonly] {
                background-color: #f8f9fa;
                color: #6c757d;
                cursor: not-allowed;
            }

            /* Layout thông tin người dùng */
            .user-info {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
                gap: 20px;
                margin-bottom: 25px;
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

            /* Cố định width cho các cột - đổi thứ tự code trước tên */
            .items-table table th:nth-child(1), .items-table table td:nth-child(1) {
                width: 60px;
            }
            .items-table table th:nth-child(2), .items-table table td:nth-child(2) {
                width: 100px;
            }
            .items-table table th:nth-child(3), .items-table table td:nth-child(3) {
                width: 300px;
            }
            .items-table table th:nth-child(4), .items-table table td:nth-child(4) {
                width: 100px;
            }
            .items-table table th:nth-child(5), .items-table table td:nth-child(5) {
                width: 120px;
            }
            .items-table table th:nth-child(6), .items-table table td:nth-child(6) {
                width: auto;
            }

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

            .btn-danger {
                background: #dc3545;
                color: white;
            }

            .btn-danger:hover {
                background: #c82333;
                transform: translateY(-1px);
            }

            .btn-info {
                background: #17a2b8;
                color: white;
            }

            .btn-info:hover {
                background: #138496;
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

            /* Style cho nút thêm/xóa - nhỏ và sát nhau */
            .btn-sm {
                padding: 8px 16px;
                font-size: 13px;
                border-radius: 5px;
                gap: 6px;
            }

            .table-buttons {
                display: flex;
                justify-content: center;
                align-items: center;
                gap: 8px;
                margin: 12px 0;
            }

            .table-buttons .btn {
                min-width: 120px;
            }

            /* Nút bổ sung sản phẩm - ở dưới bảng */
            .supplement-button {
                display: flex;
                justify-content: center;
                margin: 20px 0 15px 0;
                padding-top: 15px;
                border-top: 1px solid #e9ecef;
            }

            .supplement-button .btn {
                background: #17a2b8;
                color: white;
                padding: 10px 20px;
                font-size: 14px;
                border-radius: 6px;
                min-width: 200px;
                justify-content: center;
            }

            .supplement-button .btn:hover {
                background: #138496;
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

                .user-info {
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

                /* Table buttons vẫn nằm ngang trên mobile */
                .table-buttons {
                    gap: 6px;
                }

                .table-buttons .btn {
                    min-width: 110px;
                    font-size: 12px;
                    padding: 7px 12px;
                }

                /* Nút bổ sung responsive */
                .supplement-button .btn {
                    min-width: 180px;
                    font-size: 13px;
                    padding: 9px 18px;
                }
            }
        </style>
    </head>
    <body>
        <div class="container">
            <!-- Header - Tên đơn ở giữa trên cùng -->
            <div class="header-section">
                <h1>Đơn Yêu Cầu Mua Hàng</h1>
                <p class="subtitle">Vui lòng điền đầy đủ thông tin để tạo yêu cầu mua hàng</p>
            </div>

            <!-- Form chính -->
            <form action="loadingrequest" method="post">
                <!-- Thông tin đơn hàng - style nhẹ nhàng -->
                <div class="order-info-section">
                    <div class="order-info-card">
                        <div class="form-group">
                            <label>Mã đơn yêu cầu <span class="required">*</span></label>
                            <input type="text" name="request_id" value="${requestScope.nextID}" readonly>
                        </div>

                        <div class="form-group">
                            <label>Ngày yêu cầu <span class="required">*</span></label>
                            <input type="date" name="day_request" readonly>
                        </div>
                    </div>
                </div>

                <!-- Thông tin người dùng -->
                <div class="section-header">
                    <i class="fas fa-user"></i>
                    <h3>Thông Tin Người Yêu Cầu</h3>
                </div>

                <div class="user-info">
                    <div class="form-group">
                        <label>Người dùng <span class="required">*</span></label>
                        <input type="text" value="${sessionScope.currentUser}" readonly>
                    </div>

                    <div class="form-group">
                        <label>Vai trò <span class="required">*</span></label>
                        <!-- Thay select thành input readonly -->
                        <input type="text" name="role" value="${sessionScope.currentUserDepartment}" readonly>
                    </div>
                </div>

                <!-- Danh sách sản phẩm -->
                <div class="section-header">
                    <i class="fas fa-boxes"></i>
                    <h3>Danh Sách Sản Phẩm</h3>
                </div>

                <div class="items-section">
                    <div class="alert alert-info">
                        <i class="fas fa-info-circle"></i>
                        Vui lòng chọn sản phẩm và nhập đầy đủ thông tin cho từng mặt hàng
                    </div>

                    <!-- Buttons thêm/xóa hàng - nhỏ và sát nhau -->
                    <div class="table-buttons">
                        <button type="button" class="btn btn-success btn-sm" onclick="addRow()">
                            <i class="fas fa-plus"></i> Thêm
                        </button>
                        <button type="button" class="btn btn-danger btn-sm" onclick="removeLastRow()">
                            <i class="fas fa-minus"></i> Xóa
                        </button>
                    </div>

                    <div class="items-table">
                        <table>
                            <thead>
                                <tr>
                                    <th>STT</th>
                                    <th>Mã SP</th>
                                    <th>Tên mặt hàng</th>
                                    <th>Đơn vị</th>
                                    <th>Số lượng</th>
                                    <th>Ghi chú</th>
                                </tr>
                            </thead>
                            <tbody id="itemsTableBody">
                                <tr>
                                    <td><textarea name="stt" rows="1" style="resize: none; text-align: center;" oninput="autoResize(this)">1</textarea></td>

                                    <td><input type="text" name="product_code" readonly style="width: 100%; text-align: center;" /></td>

                                    <td>
                                        <select name="product_name" onchange="updateProductInfo(this)" style="width: 100%;">
                                            <option value="" disabled selected>-- Chọn sản phẩm --</option>
                                            <c:forEach var="p" items="${products_list}">
                                                <option value="${p.name}" data-code="${p.code}" data-unit-symbol="${p.unitSymbol}">
                                                    ${p.name}
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </td>

                                    <td>
                                        <!-- Thay select bằng input readonly -->
                                        <input type="text" name="unit" readonly style="width: 100%; text-align: center;" />
                                        <!-- Thêm input hidden để lưu giá trị thực sự gửi đi -->
                                        <input type="hidden" name="unit_value" />
                                    </td>

                                    <td>
                                        <textarea name="quantity" rows="1" 
                                                  class="quantity-input"
                                                  style="resize: none; text-align: center;" 
                                                  oninput="validateQuantity(this); autoResize(this)"
                                                  onblur="formatQuantity(this)"
                                                  onkeypress="return isNumberKey(event)"
                                                  placeholder="0"></textarea>
                                    </td>

                                    <td><textarea name="note" rows="1" style="resize: none;" oninput="autoResize(this)" placeholder="Ghi chú..."></textarea></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>

                    <!-- Nút bổ sung sản phẩm - ở dưới bảng trong container -->
                    <div class="supplement-button">
                        <button type="button" class="btn btn-info" onclick="openSupplementModal()">
                            <i class="fas fa-plus-circle"></i> Bổ sung sản phẩm
                        </button>
                    </div>

                    <!-- Lý do chi tiết -->
                    <div class="form-group">
                        <label>Lý do chi tiết <span class="required">*</span></label>
                        <textarea rows="4" name="reason" style="resize: vertical;" required placeholder="Mô tả chi tiết lý do cần mua hàng..."></textarea>
                    </div>
                </div>

                <!-- Buttons -->
                <div class="button-container">
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-paper-plane"></i> Gửi Yêu Cầu
                    </button>
                    <a href="Admin.jsp" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i> Quay Lại
                    </a>
                </div>
            </form>
        </div>

        <script>
            // Set ngày hiện tại cho input date và làm readonly
            document.addEventListener('DOMContentLoaded', function () {
                const dateInput = document.querySelector('input[name="day_request"]');
                const today = new Date().toISOString().split('T')[0];
                dateInput.value = today;
            });

            // Tự động resize textarea theo nội dung
            function autoResize(textarea) {
                textarea.style.height = 'auto';
                textarea.style.height = textarea.scrollHeight + 'px';
            }

            // Validation input số lượng
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

            function validateQuantity(textarea) {
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

            function formatQuantity(textarea) {
                let value = textarea.value.trim();
                if (value === '')
                    return;

                value = value.replace(',', '.');
                const numValue = parseFloat(value);

                if (!isNaN(numValue) && numValue >= 0 && numValue <= Number.MAX_SAFE_INTEGER) {
                    textarea.value = numValue.toLocaleString('vi-VN', {
                        minimumFractionDigits: 0,
                        maximumFractionDigits: 2
                    });
                } else if (numValue > Number.MAX_SAFE_INTEGER) {
                    alert('Số lượng quá lớn! Vui lòng nhập số nhỏ hơn.');
                    textarea.value = '';
                }
            }

            // Thêm hàng mới
            function addRow() {
                const tbody = document.getElementById('itemsTableBody');
                const currentRows = tbody.querySelectorAll('tr').length;
                const nextSTT = currentRows + 1;

                const firstRow = tbody.querySelector('tr');
                const newRow = firstRow.cloneNode(true);

                const sttTextarea = newRow.querySelector('textarea[name="stt"]');
                sttTextarea.value = nextSTT;

                const codeInput = newRow.querySelector('input[name="product_code"]');
                codeInput.value = '';

                const productSelect = newRow.querySelector('select[name="product_name"]');
                productSelect.selectedIndex = 0;

                const unitInput = newRow.querySelector('input[name="unit"]');
                unitInput.value = '';

                const unitValueInput = newRow.querySelector('input[name="unit_value"]');
                unitValueInput.value = '';

                const quantityTextarea = newRow.querySelector('textarea[name="quantity"]');
                quantityTextarea.value = '';

                const noteTextarea = newRow.querySelector('textarea[name="note"]');
                noteTextarea.value = '';

                // Đảm bảo các event handlers vẫn hoạt động
                const newProductSelect = newRow.querySelector('select[name="product_name"]');
                newProductSelect.onchange = function () {
                    updateProductInfo(this);
                };

                const newQuantityTextarea = newRow.querySelector('textarea[name="quantity"]');
                newQuantityTextarea.oninput = function () {
                    validateQuantity(this);
                    autoResize(this);
                };
                newQuantityTextarea.onblur = function () {
                    formatQuantity(this);
                };
                newQuantityTextarea.onkeypress = function (event) {
                    return isNumberKey(event);
                };

                const newSttTextarea = newRow.querySelector('textarea[name="stt"]');
                newSttTextarea.oninput = function () {
                    autoResize(this);
                };

                const newNoteTextarea = newRow.querySelector('textarea[name="note"]');
                newNoteTextarea.oninput = function () {
                    autoResize(this);
                };

                tbody.appendChild(newRow);
            }

            // Xóa hàng cuối
            function removeLastRow() {
                const tbody = document.getElementById('itemsTableBody');
                const rows = tbody.querySelectorAll('tr');

                if (rows.length > 1) {
                    tbody.removeChild(rows[rows.length - 1]);
                } else {
                    alert('Phải có ít nhất một sản phẩm trong đơn hàng!');
                }
            }

            // Mở modal bổ sung sản phẩm
            function openSupplementModal() {
                window.location.href = '${pageContext.request.contextPath}/add-product-request';
            }

            // Tự động fill code sản phẩm và unit symbol
            function updateProductInfo(selectElement) {
                const selectedOption = selectElement.options[selectElement.selectedIndex];
                const code = selectedOption.getAttribute("data-code");
                const unitSymbol = selectedOption.getAttribute("data-unit-symbol");

                const row = selectElement.closest("tr");

                // Điền mã sản phẩm
                const codeInput = row.querySelector("input[name='product_code']");
                codeInput.value = code || '';

                // Điền đơn vị hiển thị và giá trị
                const unitInput = row.querySelector("input[name='unit']");
                const unitValueInput = row.querySelector("input[name='unit_value']");

                if (unitSymbol) {
                    unitInput.value = unitSymbol;
                    // Tìm đơn vị tương ứng từ danh sách đơn vị
            <c:forEach var="u" items="${unit_list}">
                if ("${u.symbol}" === unitSymbol) {
                    unitValueInput.value = "${u.name}";
                    }
            </c:forEach>
                } else {
                    unitInput.value = '';
                    unitValueInput.value = '';
                }
            }

            // Form validation
            document.querySelector('form').addEventListener('submit', function (e) {
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
        </script>
    </body>
</html>