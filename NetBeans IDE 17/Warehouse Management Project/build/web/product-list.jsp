<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!-- Product List Page: Displays, searches, sorts, and manages products -->
<%@ page import="model.Users" session="true" %>
<!DOCTYPE html>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1
    response.setHeader("Pragma", "no-cache"); // HTTP 1.0
    response.setDateHeader("Expires", 0); // Proxies
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
    <title>Danh Sách Sản Phẩm - Warehouse Manager</title>
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
            max-width: 1400px;
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

        .add-product-btn {
            display: inline-block;
            background: #667eea;
            color: white;
            padding: 12px 24px;
            text-decoration: none;
            border-radius: 5px;
            margin-bottom: 20px;
            transition: all 0.3s ease;
            font-weight: 600;
            box-shadow: 0 2px 4px rgba(102, 126, 234, 0.2);
        }

        .add-product-btn:hover {
            background: #5a6fd8;
            text-decoration: none;
            color: white;
            transform: translateY(-1px);
            box-shadow: 0 4px 8px rgba(102, 126, 234, 0.3);
        }

        .controls {
            background: white;
            padding: 25px;
            border-radius: 10px;
            margin-bottom: 25px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .controls-row {
            display: flex;
            gap: 20px;
            align-items: center;
            flex-wrap: wrap;
        }

        .search-box {
            flex: 1;
            min-width: 250px;
        }

        .search-box input {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e1e5e9;
            border-radius: 5px;
            font-size: 14px;
            transition: border-color 0.3s ease;
        }

        .search-box input:focus {
            outline: none;
            border-color: #667eea;
        }

        .page-size-box select,
        .sort-box select {
            padding: 12px 15px;
            border: 2px solid #e1e5e9;
            border-radius: 5px;
            font-size: 14px;
            background: white;
            cursor: pointer;
        }

        .btn {
            padding: 12px 20px;
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

        .stats {
            display: flex;
            gap: 20px;
            margin-bottom: 25px;
            flex-wrap: wrap;
        }

        .stat-card {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            flex: 1;
            min-width: 200px;
            text-align: center;
        }

        .stat-number {
            font-size: 2rem;
            font-weight: bold;
            margin-bottom: 5px;
        }

        .stat-total .stat-number { color: #667eea; }
        .stat-low .stat-number { color: #dc3545; }
        .stat-expiring .stat-number { color: #ffc107; }

        .stat-label {
            color: #666;
            font-size: 0.9rem;
        }

        .table-container {
            background: white;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .table {
            width: 100%;
            border-collapse: collapse;
        }

        .table th {
            background: #f8f9fa;
            padding: 15px 12px;
            text-align: left;
            font-weight: 600;
            color: #495057;
            border-bottom: 2px solid #dee2e6;
            position: relative;
        }

        .table th.sortable {
            cursor: pointer;
            user-select: none;
        }

        .table th.sortable:hover {
            background: #e9ecef;
        }

        .table th .sort-icon {
            margin-left: 5px;
            font-size: 12px;
            color: #adb5bd;
        }

        .table th.sort-asc .sort-icon::after {
            content: '▲';
            color: #667eea;
        }

        .table th.sort-desc .sort-icon::after {
            content: '▼';
            color: #667eea;
        }

        .table td {
            padding: 15px 12px;
            border-bottom: 1px solid #dee2e6;
            vertical-align: middle;
        }

        .table tbody tr:hover {
            background: #f8f9fa;
        }

        /* Product Detail Links */
        .table td a {
            transition: all 0.3s ease;
            border-radius: 4px;
            padding: 4px 8px;
            margin: -4px -8px;
        }

        .table td a:hover {
            background: rgba(102, 126, 234, 0.1);
            text-decoration: none !important;
            transform: translateY(-1px);
            box-shadow: 0 2px 8px rgba(102, 126, 234, 0.2);
        }

        .table td a[href*="product-detail"] {
            font-weight: 600;
            cursor: pointer;
        }

        .table td a[href*="product-detail"]:hover {
            color: #5a6fd8 !important;
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

        .highlight-low-stock {
            background: rgba(220, 53, 69, 0.1) !important;
        }

        .highlight-expiring {
            background: rgba(255, 193, 7, 0.1) !important;
        }

        .pagination {
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 25px;
            gap: 10px;
        }

        .pagination-btn {
            padding: 8px 12px;
            border: 1px solid #dee2e6;
            background: white;
            color: #495057;
            text-decoration: none;
            border-radius: 4px;
            transition: all 0.3s ease;
        }

        .pagination-btn:hover {
            background: #e9ecef;
            text-decoration: none;
            color: #495057;
        }

        .pagination-btn.active {
            background: #667eea;
            color: white;
            border-color: #667eea;
        }

        .pagination-btn.disabled {
            background: #f8f9fa;
            color: #adb5bd;
            cursor: not-allowed;
        }

        .pagination-info {
            margin: 0 15px;
            color: #666;
            font-size: 14px;
        }

        .no-data {
            text-align: center;
            padding: 50px;
            color: #666;
        }

        .no-data i {
            font-size: 48px;
            margin-bottom: 15px;
            color: #dee2e6;
        }

        .btn-edit {
            display: inline-block;
            background: #28a745;
            color: white;
            padding: 8px 16px;
            border-radius: 4px;
            text-decoration: none;
            font-size: 13px;
            font-weight: 500;
            transition: all 0.3s ease;
            box-shadow: 0 2px 4px rgba(40, 167, 69, 0.2);
        }

        .btn-edit:hover {
            background: #218838;
            color: white;
            text-decoration: none;
            transform: translateY(-1px);
            box-shadow: 0 4px 8px rgba(40, 167, 69, 0.3);
        }

        @media (max-width: 768px) {
            .controls-row {
                flex-direction: column;
                align-items: stretch;
            }

            .stats {
                flex-direction: column;
            }

            .table-container {
                overflow-x: auto;
            }

            .table {
                min-width: 800px;
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
            
            .header {
                text-align: center;
                margin-bottom: 30px;
            }
            .header-user {
                display: flex;
                align-items: center;
            }
            .label {
                color: black;
                width: 120px;
            }
            .logout-btn {
                background: red;
                color: #fff;
                border: #007BFF;
                padding: 8px 16px;
                border-radius: 4px;
                cursor: pointer;
                text-decoration: none;
            }
            .logout-btn:hover {
                background: orange;
            }
            .page-title {
                color: #3f51b5;
                font-size: 2rem;
                margin-bottom: 10px;
            }
    </style>
</head>
<body>

     <div class="layout-container">
            <jsp:include page="/include/sidebar.jsp" />
            <div class="main-content">
        
                <div class="header">
                    <h1 class="page-title">📦 Danh Sách Sản Phẩm</h1>
                    <p>Quản lý và theo dõi tồn kho sản phẩm</p>
                    <div class="header-user">
                        <label class="label"><%= user.getFullname()%></label>
                        <a href="logout" class="logout-btn">Đăng xuất</a>
                    </div>
                </div>

        <div style="margin-bottom: 20px; display: flex; gap: 15px; align-items: center;">
            <a href="categoriesforward.jsp" class="back-btn">← Quay lại Trang trước</a>
            <a href="add-product" class="add-product-btn">➕ Thêm Sản Phẩm Mới</a>
            <a href="deleted-products" class="add-product-btn" style="background: #ffc107; color: #333;">🗑️ Sản Phẩm Đã Xóa</a>
            <a href="inventory-statistics" class="add-product-btn" style="background: #17a2b8; color: white;">📊 Thống Kê Kho Hàng</a>
        </div>        <!-- Success Message -->
        <c:if test="${not empty param.success}">
            <div style="background: #d4edda; color: #155724; padding: 15px; border-radius: 5px; margin: 20px 0; border: 1px solid #c3e6cb;">
                <strong>✅ Thành công:</strong> ${param.success}
            </div>
        </c:if>
        
        <!-- Error Message -->
        <c:if test="${not empty param.error}">
            <div style="background: #f8d7da; color: #721c24; padding: 15px; border-radius: 5px; margin: 20px 0; border: 1px solid #f5c6cb;">
                <strong>❌ Lỗi:</strong> ${param.error}
            </div>
        </c:if>

        <!-- Controls -->
        <div class="controls">
            <form method="get" action="product-list">
                <div class="controls-row">
                    <div class="search-box">
                        <input type="text" name="search" value="${search}" 
                               placeholder="Tìm kiếm theo tên, mã sản phẩm hoặc danh mục...">
                    </div>
                    
                    <div class="page-size-box">
                        <select name="pageSize" onchange="this.form.submit()">
                            <option value="10" ${pageSize == 10 ? 'selected' : ''}>10 sản phẩm</option>
                            <option value="25" ${pageSize == 25 ? 'selected' : ''}>25 sản phẩm</option>
                            <option value="50" ${pageSize == 50 ? 'selected' : ''}>50 sản phẩm</option>
                        </select>
                    </div>
                    
                    <button type="submit" class="btn btn-primary">Tìm kiếm</button>
                </div>
                
                <!-- Hidden fields to maintain current page -->
                <input type="hidden" name="page" value="${currentPage}">
            </form>
        </div>

        <!-- Products Table -->
        <div class="table-container">
            <c:choose>
                <c:when test="${empty products}">
                    <div class="no-data">
                        <i>📦</i>
                        <h3>Không tìm thấy sản phẩm nào</h3>
                        <p>Thử thay đổi từ khóa tìm kiếm hoặc bộ lọc</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <table class="table">
                        <thead>
                            <tr>
                                <th class="sortable" onclick="sortTable('code')">
                                    Mã sản phẩm
                                    <span class="sort-icon ${sortBy == 'code' ? (sortOrder == 'asc' ? 'sort-asc' : 'sort-desc') : ''}"></span>
                                </th>
                                <th class="sortable" onclick="sortTable('name')">
                                    Tên sản phẩm
                                    <span class="sort-icon ${sortBy == 'name' ? (sortOrder == 'asc' ? 'sort-asc' : 'sort-desc') : ''}"></span>
                                </th>
                                <th class="sortable" onclick="sortTable('category')">
                                    Danh mục
                                    <span class="sort-icon ${sortBy == 'category' ? (sortOrder == 'asc' ? 'sort-asc' : 'sort-desc') : ''}"></span>
                                </th>

                                <th class="sortable" onclick="sortTable('stock')">
                                    Số lượng tồn
                                    <span class="sort-icon ${sortBy == 'stock' ? (sortOrder == 'asc' ? 'sort-asc' : 'sort-desc') : ''}"></span>
                                </th>                                <th>Đơn vị</th>
                                <th>Trạng thái</th>
                                <th>Cảnh báo</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="product" items="${products}">
                                <tr class="${product.lowStock ? 'highlight-low-stock' : ''} ${product.nearExpiration ? 'highlight-expiring' : ''}">
                                    <td>
                                        <strong>
                                            <a href="product-detail?id=${product.id}" style="color: #667eea; text-decoration: none; font-weight: bold;">
                                                ${product.code}
                                            </a>
                                        </strong>
                                    </td>
                                    <td>
                                        <a href="product-detail?id=${product.id}" style="color: #333; text-decoration: none; font-weight: 500;">
                                            ${product.name}
                                        </a>
                                    </td>
                                    <td>${product.categoryName != null ? product.categoryName : 'Chưa phân loại'}</td>

                                    <td>
                                        <strong>
                                            <fmt:formatNumber value="${product.stockQuantity}" type="number" maxFractionDigits="2" />
                                        </strong>
                                        <c:if test="${product.minStockThreshold != null && product.minStockThreshold > 0}">
                                            <br><small style="color: #666;">Ngưỡng: <fmt:formatNumber value="${product.minStockThreshold}" type="number" maxFractionDigits="2" /></small>
                                        </c:if>
                                    </td>
                                    <td>${product.unitSymbol != null ? product.unitSymbol : product.unitName}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${product.status == 'active' || product.status == 'Hoạt động'}">
                                                <span class="badge badge-success">Hoạt động</span>
                                            </c:when>
                                            <c:when test="${product.status == 'inactive' || product.status == 'Ngưng hoạt động'}">
                                                <span class="badge badge-warning">Ngưng hoạt động</span>
                                            </c:when>
                                            <c:when test="${product.status == 'deleted'}">
                                                <span class="badge badge-danger">Đã xóa</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-warning">${product.status}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>                                    <td>
                                        <c:if test="${product.lowStock}">
                                            <span class="badge badge-danger">
                                                Sắp hết hàng
                                                <c:if test="${product.minStockThreshold != null && product.minStockThreshold > 0}">
                                                    (≤${product.minStockThreshold})
                                                </c:if>
                                            </span>
                                        </c:if>
                                        <c:if test="${product.nearExpiration}">
                                            <span class="badge badge-warning">Sắp hết hạn</span>
                                        </c:if>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${product.status == 'deleted'}">
                                                <a href="recover-product?id=${product.id}" class="btn-edit" style="background: #ffc107; color: #333;" title="Khôi phục sản phẩm">
                                                    ♻️ Khôi phục
                                                </a>
                                            </c:when>
                                            <c:otherwise>
                                                <a href="update-product?id=${product.id}" class="btn-edit" title="Chỉnh sửa sản phẩm">
                                                    ✏️ Sửa
                                                </a>
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

        <!-- Pagination -->
        <c:if test="${totalPages > 1}">
            <div class="pagination">
                <c:if test="${currentPage > 0}">
                    <a href="?page=0&pageSize=${pageSize}&search=${search}&sortBy=${sortBy}&sortOrder=${sortOrder}" 
                       class="pagination-btn">Đầu</a>
                    <a href="?page=${currentPage - 1}&pageSize=${pageSize}&search=${search}&sortBy=${sortBy}&sortOrder=${sortOrder}" 
                       class="pagination-btn">Trước</a>
                </c:if>

                <c:choose>
                    <c:when test="${totalPages <= 7}">
                        <c:forEach begin="0" end="${totalPages - 1}" var="i">
                            <a href="?page=${i}&pageSize=${pageSize}&search=${search}&sortBy=${sortBy}&sortOrder=${sortOrder}" 
                               class="pagination-btn ${i == currentPage ? 'active' : ''}">${i + 1}</a>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <c:choose>
                            <c:when test="${currentPage < 3}">
                                <c:forEach begin="0" end="4" var="i">
                                    <a href="?page=${i}&pageSize=${pageSize}&search=${search}&sortBy=${sortBy}&sortOrder=${sortOrder}" 
                                       class="pagination-btn ${i == currentPage ? 'active' : ''}">${i + 1}</a>
                                </c:forEach>
                                <span class="pagination-info">...</span>
                                <a href="?page=${totalPages - 1}&pageSize=${pageSize}&search=${search}&sortBy=${sortBy}&sortOrder=${sortOrder}" 
                                   class="pagination-btn">${totalPages}</a>
                            </c:when>
                            <c:when test="${currentPage > totalPages - 4}">
                                <a href="?page=0&pageSize=${pageSize}&search=${search}&sortBy=${sortBy}&sortOrder=${sortOrder}" 
                                   class="pagination-btn">1</a>
                                <span class="pagination-info">...</span>
                                <c:forEach begin="${totalPages - 5}" end="${totalPages - 1}" var="i">
                                    <a href="?page=${i}&pageSize=${pageSize}&search=${search}&sortBy=${sortBy}&sortOrder=${sortOrder}" 
                                       class="pagination-btn ${i == currentPage ? 'active' : ''}">${i + 1}</a>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <a href="?page=0&pageSize=${pageSize}&search=${search}&sortBy=${sortBy}&sortOrder=${sortOrder}" 
                                   class="pagination-btn">1</a>
                                <span class="pagination-info">...</span>
                                <c:forEach begin="${currentPage - 1}" end="${currentPage + 1}" var="i">
                                    <a href="?page=${i}&pageSize=${pageSize}&search=${search}&sortBy=${sortBy}&sortOrder=${sortOrder}" 
                                       class="pagination-btn ${i == currentPage ? 'active' : ''}">${i + 1}</a>
                                </c:forEach>
                                <span class="pagination-info">...</span>
                                <a href="?page=${totalPages - 1}&pageSize=${pageSize}&search=${search}&sortBy=${sortBy}&sortOrder=${sortOrder}" 
                                   class="pagination-btn">${totalPages}</a>
                            </c:otherwise>
                        </c:choose>
                    </c:otherwise>
                </c:choose>

                <div class="pagination-info">
                    Trang ${currentPage + 1} / ${totalPages} (${totalProducts} sản phẩm)
                </div>

                <c:if test="${currentPage < totalPages - 1}">
                    <a href="?page=${currentPage + 1}&pageSize=${pageSize}&search=${search}&sortBy=${sortBy}&sortOrder=${sortOrder}" 
                       class="pagination-btn">Tiếp</a>
                    <a href="?page=${totalPages - 1}&pageSize=${pageSize}&search=${search}&sortBy=${sortBy}&sortOrder=${sortOrder}" 
                       class="pagination-btn">Cuối</a>
                </c:if>
            </div>
        </c:if>
    </div>
                </div>
                

    <script>
        function sortTable(column) {
            const urlParams = new URLSearchParams(window.location.search);
            const currentSort = urlParams.get('sortBy');
            const currentOrder = urlParams.get('sortOrder');
            
            let newOrder = 'asc';
            if (currentSort === column && currentOrder === 'asc') {
                newOrder = 'desc';
            }
            
            urlParams.set('sortBy', column);
            urlParams.set('sortOrder', newOrder);
            urlParams.set('page', '0'); // Reset to first page when sorting
            
            window.location.search = urlParams.toString();
        }

        // Auto-submit search after typing with debounce
        let searchTimeout;
        document.querySelector('input[name="search"]').addEventListener('input', function() {
            clearTimeout(searchTimeout);
            searchTimeout = setTimeout(() => {
                const form = this.closest('form');
                const pageInput = form.querySelector('input[name="page"]');
                pageInput.value = '0'; // Reset to first page when searching
                form.submit();
            }, 500);
        });
    </script>
</body>
</html>
