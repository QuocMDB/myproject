<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ page import="model.Users" session="true" %>
<!DOCTYPE html>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>
<%@page import="model.Users"%>
<%
    Users user = (Users) session.getAttribute("user");
    if (user == null || !"Admin".equals(user.getRoleName()) && !"Nhân viên kho".equals(user.getRoleName())) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi Tiết Sản Phẩm - ${product.name} - Warehouse Manager</title>
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

        .layout-container {
            display: flex;
            min-height: 100vh;
        }

        .main-content {
            flex: 1;
            padding: 20px;
            background: #f5f5f5;
        }

        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            border-radius: 15px;
            margin-bottom: 30px;
            box-shadow: 0 8px 32px rgba(0,0,0,0.1);
        }

        .header h1 {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 10px;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
            color: black;
        }

        .header p {
            font-size: 1.1rem;
            opacity: 0.9;
            color: black;
        }

        .back-link {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            color: #667eea;
            text-decoration: none;
            font-weight: 600;
            margin-bottom: 20px;
            transition: color 0.3s ease;
        }

        .back-link:hover {
            color: #764ba2;
        }

        .product-detail-container {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 30px;
            margin-bottom: 30px;
        }

        .detail-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
            overflow: hidden;
        }

        .card-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            font-size: 1.3rem;
            font-weight: 600;
        }

        .card-content {
            padding: 25px;
        }

        .info-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 20px;
        }

        .info-group {
            margin-bottom: 20px;
        }

        .info-label {
            font-weight: 600;
            color: #555;
            margin-bottom: 8px;
            font-size: 0.9rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .info-value {
            font-size: 1.1rem;
            color: #333;
            padding: 12px;
            background: #f8f9fa;
            border-radius: 8px;
            border-left: 4px solid #667eea;
        }

        .info-value.highlight {
            background: #e3f2fd;
            border-left-color: #2196f3;
            font-weight: 600;
        }

        .info-value.warning {
            background: #fff3e0;
            border-left-color: #ff9800;
            color: #e65100;
            font-weight: 600;
        }

        .info-value.danger {
            background: #ffebee;
            border-left-color: #f44336;
            color: #c62828;
            font-weight: 600;
        }

        .info-value.success {
            background: #e8f5e8;
            border-left-color: #4caf50;
            color: #2e7d32;
            font-weight: 600;
        }

        .status-badge {
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 0.9rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .status-active {
            background: #d4edda;
            color: #155724;
        }

        .status-inactive {
            background: #fff3cd;
            color: #856404;
        }

        .status-deleted {
            background: #f8d7da;
            color: #721c24;
        }

        .description-section {
            margin-top: 30px;
            padding-top: 30px;
            border-top: 2px solid #eee;
        }

        .description-content {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
            font-style: italic;
            color: #666;
            line-height: 1.8;
        }

        .stock-overview {
            display: grid;
            gap: 20px;
        }

        .stock-card {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
            border-left: 5px solid;
            text-align: center;
        }

        .stock-card.normal {
            border-left-color: #28a745;
        }

        .stock-card.low {
            border-left-color: #ffc107;
        }

        .stock-card.critical {
            border-left-color: #dc3545;
        }

        .stock-number {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 10px;
        }

        .stock-label {
            font-size: 1rem;
            color: #666;
            font-weight: 500;
        }

        .action-buttons {
            display: flex;
            gap: 15px;
            margin-top: 30px;
            padding-top: 30px;
            border-top: 2px solid #eee;
        }

        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s ease;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.4);
        }

        .btn-secondary {
            background: #6c757d;
            color: white;
        }

        .btn-secondary:hover {
            background: #545b62;
            transform: translateY(-2px);
        }

        .btn-warning {
            background: #ffc107;
            color: #333;
        }

        .btn-warning:hover {
            background: #e0a800;
            transform: translateY(-2px);
        }

        .no-data {
            text-align: center;
            padding: 40px;
            color: #666;
            font-style: italic;
        }

        .error-message {
            background: #f8d7da;
            color: #721c24;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            border: 1px solid #f5c6cb;
        }

        .success-message {
            background: #d4edda;
            color: #155724;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            border: 1px solid #c3e6cb;
        }

        .product-code {
            font-family: 'Courier New', monospace;
            background: #e9ecef;
            padding: 8px 12px;
            border-radius: 5px;
            font-size: 1.1rem;
            font-weight: bold;
            letter-spacing: 1px;
        }

        .category-badge {
            background: #e3f2fd;
            color: #1976d2;
            padding: 6px 12px;
            border-radius: 15px;
            font-size: 0.9rem;
            font-weight: 500;
        }

        .unit-display {
            background: #f3e5f5;
            color: #7b1fa2;
            padding: 6px 12px;
            border-radius: 15px;
            font-size: 0.9rem;
            font-weight: 500;
        }

        @media (max-width: 768px) {
            .product-detail-container {
                grid-template-columns: 1fr;
            }

            .info-grid {
                grid-template-columns: 1fr;
            }

            .action-buttons {
                flex-direction: column;
            }

            .header h1 {
                font-size: 2rem;
            }
        }

        .metadata-section {
            margin-top: 20px;
            padding-top: 20px;
            border-top: 1px solid #eee;
        }

        .metadata-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 0;
            border-bottom: 1px solid #f0f0f0;
        }

        .metadata-item:last-child {
            border-bottom: none;
        }

        .metadata-label {
            font-weight: 600;
            color: #666;
            font-size: 0.9rem;
        }

        .metadata-value {
            color: #333;
            font-size: 0.9rem;
        }
    </style>
</head>
<body>
    <div class="layout-container">
        <jsp:include page="include/sidebar.jsp" />

        <div class="main-content">
            <a href="product-list" class="back-link">
                ← Quay lại danh sách sản phẩm
            </a>

            <div class="header">
                <h1>📦 Chi Tiết Sản Phẩm</h1>
                <p>Thông tin chi tiết về sản phẩm trong hệ thống kho</p>
            </div>

            <c:if test="${not empty param.error}">
                <div class="error-message">
                    ${param.error}
                </div>
            </c:if>

            <c:if test="${not empty param.success}">
                <div class="success-message">
                    ${param.success}
                </div>
            </c:if>

            <c:choose>
                <c:when test="${product != null}">
                    <div class="product-detail-container">
                        <!-- Main Product Information -->
                        <div class="detail-card">
                            <div class="card-header">
                                📋 Thông Tin Sản Phẩm
                            </div>
                            <div class="card-content">
                                <div class="info-grid">
                                    <div class="info-group">
                                        <div class="info-label">Mã Sản Phẩm</div>
                                        <div class="info-value highlight">
                                            <span class="product-code">${product.code}</span>
                                        </div>
                                    </div>
                                    <div class="info-group">
                                        <div class="info-label">Trạng Thái</div>
                                        <div class="info-value">
                                            <c:choose>
                                                <c:when test="${product.status == 'active' || product.status == 'Hoạt động'}">
                                                    <span class="status-badge status-active">Hoạt động</span>
                                                </c:when>
                                                <c:when test="${product.status == 'inactive' || product.status == 'Ngưng hoạt động'}">
                                                    <span class="status-badge status-inactive">Ngưng hoạt động</span>
                                                </c:when>
                                                <c:when test="${product.status == 'deleted'}">
                                                    <span class="status-badge status-deleted">Đã xóa</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="status-badge status-inactive">${product.status}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>

                                <div class="info-group">
                                    <div class="info-label">Tên Sản Phẩm</div>
                                    <div class="info-value highlight">
                                        ${product.name}
                                    </div>
                                </div>

                                <div class="info-grid">
                                    <div class="info-group">
                                        <div class="info-label">Danh Mục</div>
                                        <div class="info-value">
                                            <c:choose>
                                                <c:when test="${category != null}">
                                                    <span class="category-badge">${category.name}</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span style="color: #999; font-style: italic;">Chưa phân loại</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                    <div class="info-group">
                                        <div class="info-label">Đơn Vị Tính</div>
                                        <div class="info-value">
                                            <c:choose>
                                                <c:when test="${unit != null}">
                                                    <span class="unit-display">${unit.name} (${unit.symbol})</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span style="color: #999; font-style: italic;">Chưa xác định</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>

                                <c:if test="${supplier != null}">
                                    <div class="info-group">
                                        <div class="info-label">Nhà Cung Cấp</div>
                                        <div class="info-value">
                                            ${supplier.name}
                                            <c:if test="${not empty supplier.contactEmail}">
                                                <br><small style="color: #666;">📧 ${supplier.contactEmail}</small>
                                            </c:if>
                                            <c:if test="${not empty supplier.contactPhone}">
                                                <br><small style="color: #666;">📞 ${supplier.contactPhone}</small>
                                            </c:if>
                                        </div>
                                    </div>
                                </c:if>

                                <c:if test="${product.expirationDate != null}">
                                    <div class="info-group">
                                        <div class="info-label">Ngày Hết Hạn</div>
                                        <div class="info-value warning">
                                            <fmt:formatDate value="${product.expirationDate}" pattern="dd/MM/yyyy" />
                                        </div>
                                    </div>
                                </c:if>

                                <c:if test="${not empty product.description}">
                                    <div class="description-section">
                                        <div class="info-label">Mô Tả Sản Phẩm</div>
                                        <div class="description-content">
                                            ${product.description}
                                        </div>
                                    </div>
                                </c:if>

                                <!-- Metadata Section -->
                                <div class="metadata-section">
                                    <div class="info-label" style="margin-bottom: 15px;">Thông Tin Bổ Sung</div>
                                    <div class="metadata-item">
                                        <span class="metadata-label">ID Sản Phẩm:</span>
                                        <span class="metadata-value">#${product.id}</span>
                                    </div>
                                    <c:if test="${product.createdDate != null}">
                                        <div class="metadata-item">
                                            <span class="metadata-label">Ngày Tạo:</span>
                                            <span class="metadata-value">
                                                <fmt:formatDate value="${product.createdDate}" pattern="dd/MM/yyyy HH:mm" />
                                            </span>
                                        </div>
                                    </c:if>
                                    <c:if test="${product.updatedDate != null}">
                                        <div class="metadata-item">
                                            <span class="metadata-label">Cập Nhật Lần Cuối:</span>
                                            <span class="metadata-value">
                                                <fmt:formatDate value="${product.updatedDate}" pattern="dd/MM/yyyy HH:mm" />
                                            </span>
                                        </div>
                                    </c:if>
                                </div>

                                <!-- Action Buttons -->
                                <div class="action-buttons">
                                    <c:choose>
                                        <c:when test="${product.status == 'deleted'}">
                                            <a href="recover-product?id=${product.id}" class="btn btn-warning">
                                                ♻️ Khôi Phục Sản Phẩm
                                            </a>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="update-product?id=${product.id}" class="btn btn-primary">
                                                ✏️ Chỉnh Sửa
                                            </a>
                                        </c:otherwise>
                                    </c:choose>
                                    <a href="product-list" class="btn btn-secondary">
                                        📋 Quay Lại Danh Sách
                                    </a>
                                </div>
                            </div>
                        </div>

                        <!-- Stock Information -->
                        <div class="detail-card">
                            <div class="card-header">
                                📊 Thông Tin Kho
                            </div>
                            <div class="card-content">
                                <div class="stock-overview">
                                    <div class="stock-card ${isLowStock ? 'critical' : 'normal'}">
                                        <div class="stock-number">
                                            <fmt:formatNumber value="${product.stockQuantity}" type="number" maxFractionDigits="2" />
                                        </div>
                                        <div class="stock-label">Số Lượng Hiện Tại</div>
                                    </div>

                                    <c:if test="${product.minStockThreshold != null && product.minStockThreshold > 0}">
                                        <div class="stock-card low">
                                            <div class="stock-number">
                                                <fmt:formatNumber value="${product.minStockThreshold}" type="number" maxFractionDigits="2" />
                                            </div>
                                            <div class="stock-label">Ngưỡng Tối Thiểu</div>
                                        </div>
                                    </c:if>

                                    <c:if test="${isLowStock}">
                                        <div class="info-group">
                                            <div class="info-value danger">
                                                ⚠️ CẢNH BÁO: Sản phẩm sắp hết hàng!
                                                <br><small>Cần nhập thêm hàng để duy trì hoạt động kinh doanh.</small>
                                            </div>
                                        </div>
                                    </c:if>

                                    <c:if test="${not isLowStock && product.stockQuantity > 0}">
                                        <div class="info-group">
                                            <div class="info-value success">
                                                ✅ Tồn kho ổn định
                                                <br><small>Số lượng hiện tại đủ để đáp ứng nhu cầu.</small>
                                            </div>
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="detail-card">
                        <div class="card-content">
                            <div class="no-data">
                                <h3>❌ Không tìm thấy sản phẩm</h3>
                                <p>Sản phẩm không tồn tại hoặc đã bị xóa khỏi hệ thống.</p>
                                <a href="product-list" class="btn btn-primary" style="margin-top: 20px;">
                                    📋 Quay Lại Danh Sách
                                </a>
                            </div>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <script>
        // Add some interactive effects
        document.querySelectorAll('.info-value').forEach(element => {
            element.addEventListener('mouseenter', function() {
                this.style.transform = 'translateY(-2px)';
                this.style.boxShadow = '0 4px 12px rgba(0,0,0,0.1)';
            });
            
            element.addEventListener('mouseleave', function() {
                this.style.transform = 'translateY(0)';
                this.style.boxShadow = 'none';
            });
        });

        // Print functionality
        function printProductDetails() {
            window.print();
        }

        // Add print styles
        const printStyles = `
            @media print {
                .sidebar, .back-link, .action-buttons { display: none !important; }
                .main-content { margin: 0 !important; padding: 20px !important; }
                .detail-card { break-inside: avoid; }
                .header { background: #333 !important; -webkit-print-color-adjust: exact; }
            }
        `;
        
        const styleSheet = document.createElement("style");
        styleSheet.innerText = printStyles;
        document.head.appendChild(styleSheet);
    </script>
</body>
</html>
