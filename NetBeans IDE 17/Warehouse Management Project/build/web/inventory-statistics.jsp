<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ page import="model.Users" session="true" %>
<%
    Users user = (Users) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>
<%@page import="model.Users"%>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thống Kê Kho Hàng - Warehouse Manager</title>
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
            border-radius: 10px;
            margin-bottom: 30px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            text-align: center;
        }

        .page-title {
            color: white;
            font-size: 2.5rem;
            margin-bottom: 10px;
            font-weight: 300;
        }

        .header p {
            font-size: 1.1rem;
            opacity: 0.9;
        }

        .header-user {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 15px;
            margin-top: 15px;
        }

        .label {
            color: #fff;
            opacity: 0.9;
        }

        .logout-btn {
            background: rgba(255, 255, 255, 0.2);
            color: #fff;
            border: 1px solid rgba(255, 255, 255, 0.3);
            padding: 8px 16px;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
            transition: all 0.3s ease;
        }

        .logout-btn:hover {
            background: rgba(255, 255, 255, 0.3);
            text-decoration: none;
            color: #fff;
        }

        .back-btn {
            display: inline-block;
            background: #28a745;
            color: white;
            padding: 12px 24px;
            text-decoration: none;
            border-radius: 5px;
            margin-bottom: 20px;
            transition: background 0.3s ease;
            font-weight: 500;
        }

        .back-btn:hover {
            background: #218838;
            text-decoration: none;
            color: white;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 25px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: white;
            padding: 25px;
            border-radius: 15px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            border-left: 5px solid #667eea;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 15px rgba(0, 0, 0, 0.15);
        }

        .stat-card.danger {
            border-left-color: #dc3545;
        }

        .stat-card.warning {
            border-left-color: #ffc107;
        }

        .stat-card.success {
            border-left-color: #28a745;
        }

        .stat-card.info {
            border-left-color: #17a2b8;
        }

        .stat-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
        }

        .stat-title {
            font-size: 1.1rem;
            font-weight: 600;
            color: #495057;
        }

        .stat-icon {
            font-size: 2rem;
            opacity: 0.7;
        }

        .stat-number {
            font-size: 2.5rem;
            font-weight: bold;
            margin-bottom: 10px;
        }

        .stat-card.danger .stat-number { color: #dc3545; }
        .stat-card.warning .stat-number { color: #ffc107; }
        .stat-card.success .stat-number { color: #28a745; }
        .stat-card.info .stat-number { color: #17a2b8; }
        .stat-card .stat-number { color: #667eea; }

        .stat-description {
            color: #6c757d;
            font-size: 0.9rem;
            line-height: 1.4;
        }

        .chart-container {
            background: white;
            padding: 25px;
            border-radius: 15px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
        }

        .chart-title {
            font-size: 1.3rem;
            font-weight: 600;
            color: #495057;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .table-container {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
        }

        .table {
            width: 100%;
            border-collapse: collapse;
        }

        .table th {
            background: #f8f9fa;
            padding: 15px;
            text-align: left;
            font-weight: 600;
            color: #495057;
            border-bottom: 2px solid #dee2e6;
        }

        .table td {
            padding: 15px;
            border-bottom: 1px solid #dee2e6;
            vertical-align: middle;
        }

        .table tbody tr:hover {
            background: #f8f9fa;
        }

        .badge {
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 11px;
            font-weight: 500;
            text-transform: uppercase;
        }

        .badge-success {
            background: #d4edda;
            color: #155724;
        }

        .badge-warning {
            background: #fff3cd;
            color: #856404;
        }

        .badge-danger {
            background: #f8d7da;
            color: #721c24;
        }

        .badge-info {
            background: #d1ecf1;
            color: #0c5460;
        }

        .progress-bar {
            width: 100%;
            height: 8px;
            background: #e9ecef;
            border-radius: 4px;
            overflow: hidden;
            margin-top: 5px;
        }

        .progress-fill {
            height: 100%;
            background: linear-gradient(90deg, #28a745, #20c997);
            transition: width 0.3s ease;
        }

        .progress-fill.warning {
            background: linear-gradient(90deg, #ffc107, #fd7e14);
        }

        .progress-fill.danger {
            background: linear-gradient(90deg, #dc3545, #e74c3c);
        }

        .filter-controls {
            background: white;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 25px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .filter-row {
            display: flex;
            gap: 15px;
            align-items: center;
            flex-wrap: wrap;
        }

        .filter-item select,
        .filter-item input {
            padding: 10px 15px;
            border: 2px solid #e1e5e9;
            border-radius: 5px;
            font-size: 14px;
            background: white;
        }

        .btn {
            padding: 10px 20px;
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
        }

        .low-stock-alert {
            background: linear-gradient(135deg, #ff6b6b, #ee5a24);
            color: white;
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .alert-icon {
            font-size: 1.5rem;
        }

        .quick-actions {
            display: flex;
            gap: 15px;
            margin-bottom: 30px;
            flex-wrap: wrap;
        }

        .action-btn {
            background: white;
            border: 2px solid #667eea;
            color: #667eea;
            padding: 12px 20px;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .action-btn:hover {
            background: #667eea;
            color: white;
            text-decoration: none;
        }

        @media (max-width: 768px) {
            .stats-grid {
                grid-template-columns: 1fr;
            }
            
            .filter-row {
                flex-direction: column;
                align-items: stretch;
            }
            
            .quick-actions {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
    <div class="layout-container">
        <jsp:include page="/include/sidebar.jsp" />
        
        <div class="main-content">
            <div class="header">
                <h1 class="page-title">📊 Thống Kê Kho Hàng</h1>
                <p>Tổng quan và phân tích chi tiết về tình trạng kho hàng</p>
                <div class="header-user">
                    <label class="label">Chào mừng, <%= user.getFullname()%></label>
                    <a href="logout" class="logout-btn">Đăng xuất</a>
                </div>
            </div>

            <!-- Navigation -->
            <div style="margin-bottom: 20px;">
                <a href="product-list" class="back-btn">← Quay lại Danh sách sản phẩm</a>
            </div>

            <!-- Low Stock Alert -->
            <c:if test="${lowStockCount > 0}">
                <div class="low-stock-alert">
                    <span class="alert-icon">⚠️</span>
                    <div>
                        <strong>Cảnh báo hàng tồn kho thấp!</strong><br>
                        Có ${lowStockCount} sản phẩm đang có số lượng tồn kho thấp và cần được bổ sung.
                    </div>
                </div>
            </c:if>

            <!-- Quick Actions -->
            <div class="quick-actions">
                <a href="product-list" class="action-btn">
                    📦 Xem danh sách sản phẩm
                </a>
                <a href="add-product" class="action-btn">
                    ➕ Thêm sản phẩm mới
                </a>
                <a href="ExportRequest.jsp" class="action-btn">
                    📤 Tạo yêu cầu xuất kho
                </a>
                <a href="ListRequestImport.jsp" class="action-btn">
                    📥 Yêu cầu nhập kho
                </a>
            </div>

            <!-- Filter Controls -->
            <div class="filter-controls">
                <form method="get" action="inventory-statistics">
                    <div class="filter-row">
                        <div class="filter-item">
                            <label>Khoảng thời gian:</label>
                            <select name="period">
                                <option value="today" ${period == 'today' ? 'selected' : ''}>Hôm nay</option>
                                <option value="week" ${period == 'week' ? 'selected' : ''}>7 ngày qua</option>
                                <option value="month" ${period == 'month' ? 'selected' : ''}>30 ngày qua</option>
                                <option value="quarter" ${period == 'quarter' ? 'selected' : ''}>3 tháng qua</option>
                                <option value="year" ${period == 'year' ? 'selected' : ''}>1 năm qua</option>
                            </select>
                        </div>
                        <div class="filter-item">
                            <label>Danh mục:</label>
                            <select name="categoryId">
                                <option value="">Tất cả danh mục</option>
                                <c:forEach var="category" items="${categories}">
                                    <option value="${category.id}" ${categoryId == category.id ? 'selected' : ''}>${category.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <button type="submit" class="btn btn-primary">Áp dụng bộ lọc</button>
                    </div>
                </form>
            </div>

            <!-- Main Statistics Grid -->
            <div class="stats-grid">
                <!-- Total Products -->
                <div class="stat-card">
                    <div class="stat-header">
                        <span class="stat-title">Tổng Số Sản Phẩm</span>
                        <span class="stat-icon">📦</span>
                    </div>
                    <div class="stat-number">${totalProducts}</div>
                    <div class="stat-description">
                        Tổng số loại sản phẩm trong kho
                        <div class="progress-bar">
                            <div class="progress-fill" style="width: 100%"></div>
                        </div>
                    </div>
                </div>

                <!-- Low Stock Products -->
                <div class="stat-card danger">
                    <div class="stat-header">
                        <span class="stat-title">Sắp Hết Hàng</span>
                        <span class="stat-icon">⚠️</span>
                    </div>
                    <div class="stat-number">${lowStockCount}</div>
                    <div class="stat-description">
                        Sản phẩm có số lượng tồn kho thấp
                        <div class="progress-bar">
                            <div class="progress-fill danger" style="width: ${(lowStockCount * 100.0 / totalProducts)}%"></div>
                        </div>
                    </div>
                </div>

                <!-- Near Expiration -->
                <div class="stat-card warning">
                    <div class="stat-header">
                        <span class="stat-title">Sắp Hết Hạn</span>
                        <span class="stat-icon">⏰</span>
                    </div>
                    <div class="stat-number">${nearExpirationCount}</div>
                    <div class="stat-description">
                        Sản phẩm sắp hết hạn sử dụng
                        <div class="progress-bar">
                            <div class="progress-fill warning" style="width: ${(nearExpirationCount * 100.0 / totalProducts)}%"></div>
                        </div>
                    </div>
                </div>

                <!-- Active Products -->
                <div class="stat-card success">
                    <div class="stat-header">
                        <span class="stat-title">Sản Phẩm Hoạt Động</span>
                        <span class="stat-icon">✅</span>
                    </div>
                    <div class="stat-number">${activeProductsCount}</div>
                    <div class="stat-description">
                        Sản phẩm đang được bán
                        <div class="progress-bar">
                            <div class="progress-fill success" style="width: ${(activeProductsCount * 100.0 / totalProducts)}%"></div>
                        </div>
                    </div>
                </div>

                <!-- Inactive Products -->
                <div class="stat-card warning">
                    <div class="stat-header">
                        <span class="stat-title">Sản Phẩm Ngưng Bán</span>
                        <span class="stat-icon">⏸️</span>
                    </div>
                    <div class="stat-number">${inactiveProductsCount}</div>
                    <div class="stat-description">
                        Sản phẩm tạm ngưng kinh doanh
                        <div class="progress-bar">
                            <div class="progress-fill warning" style="width: ${(inactiveProductsCount * 100.0 / totalProducts)}%"></div>
                        </div>
                    </div>
                </div>

                <!-- Recent Transactions -->
                <div class="stat-card info">
                    <div class="stat-header">
                        <span class="stat-title">Giao Dịch Gần Đây</span>
                        <span class="stat-icon">📈</span>
                    </div>
                    <div class="stat-number">${recentTransactionsCount}</div>
                    <div class="stat-description">
                        Số giao dịch trong ${period == 'today' ? 'hôm nay' : 
                                           period == 'week' ? '7 ngày qua' : 
                                           period == 'month' ? '30 ngày qua' : 
                                           period == 'quarter' ? '3 tháng qua' : '1 năm qua'}
                    </div>
                </div>

                <!-- Total Categories -->
                <div class="stat-card info">
                    <div class="stat-header">
                        <span class="stat-title">Danh Mục Sản Phẩm</span>
                        <span class="stat-icon">🏷️</span>
                    </div>
                    <div class="stat-number">${totalCategories}</div>
                    <div class="stat-description">
                        Tổng số danh mục sản phẩm
                    </div>
                </div>
            </div>

            <!-- Top Low Stock Products -->
            <div class="table-container">
                <div class="chart-title">
                    ⚠️ Top Sản Phẩm Sắp Hết Hàng
                </div>
                <c:choose>
                    <c:when test="${empty lowStockProducts}">
                        <div style="text-align: center; padding: 40px; color: #6c757d;">
                            <div style="font-size: 3rem; margin-bottom: 15px;">✅</div>
                            <h4>Tuyệt vời! Không có sản phẩm nào sắp hết hàng</h4>
                            <p>Tất cả sản phẩm đều có lượng tồn kho đầy đủ.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Mã sản phẩm</th>
                                    <th>Tên sản phẩm</th>
                                    <th>Danh mục</th>
                                    <th>Số lượng tồn</th>
                                    <th>Ngưỡng tối thiểu</th>
                                    <th>Trạng thái</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="product" items="${lowStockProducts}">
                                    <tr>
                                        <td><strong>${product.code}</strong></td>
                                        <td>${product.name}</td>
                                        <td>${product.categoryName}</td>
                                        <td>
                                            <strong style="color: #dc3545;">
                                                <fmt:formatNumber value="${product.stockQuantity}" type="number" maxFractionDigits="2" />
                                                ${product.unitName}
                                            </strong>
                                        </td>
                                        <td>
                                            <fmt:formatNumber value="${product.minStockThreshold}" type="number" maxFractionDigits="2" />
                                            ${product.unitName}
                                        </td>
                                        <td>
                                            <span class="badge badge-danger">Sắp hết hàng</span>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Category Statistics -->
            <div class="table-container">
                <div class="chart-title">
                    📊 Thống Kê Theo Danh Mục
                </div>
                <c:choose>
                    <c:when test="${empty categoryStats}">
                        <div style="text-align: center; padding: 40px; color: #6c757d;">
                            <div style="font-size: 3rem; margin-bottom: 15px;">📊</div>
                            <h4>Chưa có dữ liệu thống kê</h4>
                            <p>Dữ liệu thống kê theo danh mục sẽ xuất hiện khi có sản phẩm.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Danh mục</th>
                                    <th>Số sản phẩm</th>
                                    <th>Tổng tồn kho</th>
                                    <th>Sản phẩm sắp hết</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="stat" items="${categoryStats}">
                                    <tr>
                                        <td><strong>${stat.categoryName}</strong></td>
                                        <td>${stat.productCount}</td>
                                        <td>
                                            <fmt:formatNumber value="${stat.totalStock}" type="number" maxFractionDigits="2" />
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${stat.lowStockCount > 0}">
                                                    <span class="badge badge-danger">${stat.lowStockCount}</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-success">0</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Recent Activity -->
            <div class="table-container">
                <div class="chart-title">
                    📈 Hoạt Động Gần Đây
                </div>
                <c:choose>
                    <c:when test="${empty recentActivities}">
                        <div style="text-align: center; padding: 40px; color: #6c757d;">
                            <div style="font-size: 3rem; margin-bottom: 15px;">📈</div>
                            <h4>Chưa có hoạt động nào</h4>
                            <p>Các hoạt động nhập/xuất kho gần đây sẽ hiển thị ở đây.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Thời gian</th>
                                    <th>Loại hoạt động</th>
                                    <th>Sản phẩm</th>
                                    <th>Số lượng</th>
                                    <th>Người thực hiện</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="activity" items="${recentActivities}">
                                    <tr>
                                        <td>
                                            <fmt:formatDate value="${activity.date}" pattern="dd/MM/yyyy HH:mm" />
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${activity.type == 'Import'}">
                                                    <span class="badge badge-success">Nhập kho</span>
                                                </c:when>
                                                <c:when test="${activity.type == 'Export'}">
                                                    <span class="badge badge-info">Xuất kho</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-warning">${activity.description}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>${activity.productName}</td>
                                        <td>
                                            <fmt:formatNumber value="${activity.quantity}" type="number" maxFractionDigits="2" />
                                        </td>
                                        <td>${activity.userName}</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <script>
        // Auto refresh statistics every 5 minutes
        setTimeout(function() {
            window.location.reload();
        }, 300000);

        // Add smooth scroll for navigation
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                e.preventDefault();
                document.querySelector(this.getAttribute('href')).scrollIntoView({
                    behavior: 'smooth'
                });
            });
        });
    </script>
</body>
</html>
