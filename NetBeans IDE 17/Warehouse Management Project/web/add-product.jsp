<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ page import="model.Users" session="true" %>
<!DOCTYPE html>

<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thêm Sản Phẩm Mới - Warehouse Manager</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f5f7fa;
            color: #333;
            line-height: 1.6;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }

        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            border-radius: 10px;
            margin-bottom: 30px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        .header h1 {
            font-size: 2.5rem;
            margin-bottom: 10px;
            font-weight: 300;
            color: black;
        }

        .header p {
            font-size: 1.1rem;
            opacity: 0.9;
            color: black;
        }

        .nav-buttons {
            display: flex;
            gap: 15px;
            margin-bottom: 25px;
            flex-wrap: wrap;
        }

        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
        }

        .btn-primary {
            background: #667eea;
            color: white;
        }

        .btn-primary:hover {
            background: #5a67d8;
            text-decoration: none;
            color: white;
        }

        .btn-secondary {
            background: #6c757d;
            color: white;
        }

        .btn-secondary:hover {
            background: #5a6268;
            text-decoration: none;
            color: white;
        }

        .btn-success {
            background: #28a745;
            color: white;
        }

        .btn-success:hover {
            background: #218838;
        }

        .form-container {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin-bottom: 25px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group.full-width {
            grid-column: 1 / -1;
        }

        .form-label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #495057;
        }

        .form-label.required::after {
            content: " *";
            color: #dc3545;
        }

        .form-control {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e1e5e9;
            border-radius: 5px;
            font-size: 14px;
            transition: border-color 0.3s ease;
            font-family: inherit;
        }

        .form-control:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        .form-control.error {
            border-color: #dc3545;
        }

        textarea.form-control {
            min-height: 100px;
            resize: vertical;
        }

        .error-message {
            background: #f8d7da;
            color: #721c24;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
            border: 1px solid #f5c6cb;
        }

        .success-message {
            background: #d4edda;
            color: #155724;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
            border: 1px solid #c3e6cb;
        }

        .form-help {
            font-size: 12px;
            color: #6c757d;
            margin-top: 5px;
        }

        .required-note {
            color: #dc3545;
            font-size: 14px;
            margin-bottom: 20px;
        }

        .section-title {
            font-size: 1.2rem;
            font-weight: 600;
            color: #495057;
            margin: 30px 0 15px 0;
            padding-bottom: 10px;
            border-bottom: 2px solid #e9ecef;
        }

        .file-upload-area {
            border: 2px dashed #dee2e6;
            border-radius: 5px;
            padding: 20px;
            text-align: center;
            background: #f8f9fa;
            transition: all 0.3s ease;
        }

        .file-upload-area:hover {
            border-color: #667eea;
            background: #f0f0ff;
        }

        .image-preview {
            max-width: 200px;
            max-height: 200px;
            border-radius: 5px;
            margin-top: 10px;
            display: none;
        }

        @media (max-width: 768px) {
            .form-grid {
                grid-template-columns: 1fr;
            }
            
            .nav-buttons {
                flex-direction: column;
            }
            
            .container {
                padding: 10px;
            }
        }
        .layout-container {
                display: flex;
                min-height: 100vh;
            }

            .main-content {
                flex: 1;
                padding: 20px;
                background: #f5f5f5;
            }
    </style>
</head>
<body>
    <div class="layout-container">
            <jsp:include page="/include/sidebar.jsp" />
            <div class="main-content">
        <div class="header">
            <h1>➕ Thêm Sản Phẩm Mới</h1>
            <p>Nhập thông tin chi tiết để thêm sản phẩm vào hệ thống kho</p>
        </div>        <div class="nav-buttons">
            <a href="product-list" class="btn btn-primary">← Quay lại Danh Sách</a>
        </div>

        <!-- Error/Success Messages -->
        <c:if test="${not empty error}">
            <div class="error-message">
                <strong>❌ Lỗi:</strong> ${error}
            </div>
        </c:if>

        <c:if test="${not empty success}">
            <div class="success-message">
                <strong>✅ Thành công:</strong> ${success}
            </div>
        </c:if>

        <div class="form-container">
            <form method="post" action="add-product" enctype="application/x-www-form-urlencoded">
                <div class="required-note">
                    Các trường có dấu <span style="color: #dc3545;">*</span> là bắt buộc
                </div>

                <!-- Basic Information -->
                <div class="section-title">📝 Thông Tin Cơ Bản</div>
                <div class="form-grid">
                    <div class="form-group">
                        <label class="form-label required" for="name">Tên Sản Phẩm</label>
                        <input type="text" id="name" name="name" class="form-control" 
                               value="${formData.name[0]}" maxlength="100" required>
                        <div class="form-help">Tối đa 100 ký tự</div>
                    </div>

                    <div class="form-group">
                        <label class="form-label required" for="code">Mã Sản Phẩm</label>
                        <input type="text" id="code" name="code" class="form-control" 
                               value="${formData.code[0]}" maxlength="50" required>
                        <div class="form-help">Mã duy nhất, tối đa 50 ký tự (sẽ được chuyển thành chữ hoa)</div>
                    </div>

                    <div class="form-group">
                        <label class="form-label required" for="categoryId">Danh Mục</label>
                        <select id="categoryId" name="categoryId" class="form-control" required>
                            <option value="">-- Chọn danh mục --</option>
                            <c:forEach var="category" items="${categories}">
                                <option value="${category.id}" 
                                        ${formData.categoryId[0] == category.id ? 'selected' : ''}>
                                    ${category.name}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-group">
                        <label class="form-label required" for="unitId">Đơn Vị Tính</label>
                        <select id="unitId" name="unitId" class="form-control" required>
                            <option value="">-- Chọn đơn vị --</option>
                            <c:forEach var="unit" items="${units}">
                                <option value="${unit.id}" 
                                        ${formData.unitId[0] == unit.id ? 'selected' : ''}>
                                    ${unit.name} (${unit.symbol})
                                </option>
                            </c:forEach>
                        </select>
                    </div>



                    <div class="form-group">
                        <label class="form-label required" for="status">Trạng Thái</label>
                        <select id="status" name="status" class="form-control" required>
                            <option value="">-- Chọn trạng thái --</option>
                            <option value="active" ${formData.status[0] == 'active' ? 'selected' : ''}>Hoạt động</option>
                            <option value="inactive" ${formData.status[0] == 'inactive' ? 'selected' : ''}>Ngưng hoạt động</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="stockQuantity">Số Lượng Tồn Kho</label>
                        <input type="number" id="stockQuantity" name="stockQuantity" class="form-control" 
                               value="${formData.stockQuantity[0]}" min="0" step="0.01" placeholder="0">
                        <div class="form-help">Số lượng hiện có trong kho (tùy chọn)</div>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="minStockThreshold">Ngưỡng Cảnh Báo Tồn Kho</label>
                        <input type="number" id="minStockThreshold" name="minStockThreshold" class="form-control" 
                               value="${formData.minStockThreshold[0]}" min="0" step="0.01" placeholder="10">
                        <div class="form-help">Số lượng tối thiểu để cảnh báo sắp hết hàng (mặc định: 10)</div>
                    </div>
                </div>
                
                <!-- Additional Information -->
                <div class="section-title">📦 Thông Tin Bổ Sung</div>
                <div class="form-grid">
                    <div class="form-group">
                        <label class="form-label" for="supplierId">Nhà Cung Cấp</label>
                        <select id="supplierId" name="supplierId" class="form-control">
                            <option value="">-- Chọn nhà cung cấp --</option>                            <c:forEach var="supplier" items="${suppliers}">
                                <option value="${supplier.supplierID}" 
                                        ${formData.supplierId[0] == supplier.supplierID ? 'selected' : ''}>
                                    ${supplier.name}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="expirationDate">Ngày Hết Hạn</label>
                        <input type="date" id="expirationDate" name="expirationDate" class="form-control" 
                               value="${formData.expirationDate[0]}">
                        <div class="form-help">Để trống nếu sản phẩm không có hạn sử dụng</div>
                    </div>

                    <!-- Description and Notes moved inside the form-grid with full-width -->
                    <div class="form-group full-width">
                        <label class="form-label" for="description">Mô Tả Sản Phẩm</label>
                        <textarea id="description" name="description" class="form-control" 
                                  rows="4" placeholder="Nhập mô tả chi tiết về sản phẩm...">${formData.description[0]}</textarea>
                    </div>

                    <div class="form-group full-width">
                        <label class="form-label" for="additionalNotes">Ghi Chú Bổ Sung</label>
                        <textarea id="additionalNotes" name="additionalNotes" class="form-control" 
                                  rows="3" placeholder="Ghi chú thêm về sản phẩm...">${formData.additionalNotes[0]}</textarea>
                        <div class="form-help">Thông tin bổ sung, lưu ý đặc biệt về sản phẩm</div>
                    </div>
                </div>

                <!-- Submit Buttons -->
                <div style="text-align: center; margin-top: 30px;">
                    <button type="submit" class="btn btn-success" style="padding: 15px 30px; font-size: 16px;">
                        ✅ Thêm Sản Phẩm
                    </button>
                    <a href="product-list" class="btn btn-secondary" style="padding: 15px 30px; font-size: 16px; margin-left: 15px;">
                        ❌ Hủy Bỏ
                    </a>
                </div>
            </form>
        </div>
    </div>
    </div>

    <script>
        // Auto-uppercase product code
        document.getElementById('code').addEventListener('input', function() {
            this.value = this.value.toUpperCase();
        });
        // Form validation
        document.querySelector('form').addEventListener('submit', function(e) {
            const requiredFields = document.querySelectorAll('[required]');
            let isValid = true;

            requiredFields.forEach(field => {
                if (!field.value.trim()) {
                    field.classList.add('error');
                    isValid = false;
                } else {
                    field.classList.remove('error');
                }
            });

            if (!isValid) {
                e.preventDefault();
                alert('Vui lòng điền đầy đủ các trường bắt buộc.');
            }
        });

        // Remove error styling on input
        document.querySelectorAll('.form-control').forEach(field => {
            field.addEventListener('input', function() {
                this.classList.remove('error');
            });
        });
    </script>
</body>
</html>