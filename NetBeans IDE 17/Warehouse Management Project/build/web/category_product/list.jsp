<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1
    response.setHeader("Pragma", "no-cache"); // HTTP 1.0
    response.setDateHeader("Expires", 0); // Proxies
%>
<%@page import="model.Users"%>
<%
    Users user = (Users) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<%-- Tính toán reverseSortDir --%>
<c:set var="reverseSortDir" value="${sortDir eq 'asc' ? 'desc' : 'asc'}" />

<%-- Tính toán phân trang hiển thị --%>
<c:set var="startPage" value="${currentPage - 2 > 0 ? currentPage - 2 : 1}" />
<c:set var="endPage" value="${startPage + 4 < totalPages ? startPage + 4 : totalPages}" />
<c:if test="${endPage - startPage < 4 && totalPages > 5}">
    <c:set var="startPage" value="${endPage - 4 > 0 ? endPage - 4 : 1}" />
</c:if>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Danh sách danh mục sản phẩm</title>
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: Arial, sans-serif;
                background: #f5f5f5;
                color: #333;
                line-height: 1.6;
                padding: 20px;
            }

            .container {
                max-width: 1200px;
                margin: 0 auto;
                background: white;
                padding: 30px;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            }

            .page-header {
                text-align: center;
                margin-bottom: 30px;
                padding-bottom: 20px;
                border-bottom: 2px solid #eee;
            }

            /* Navigation Buttons */
            .nav-buttons {
                display: flex;
                gap: 15px;
                margin-bottom: 25px;
            }

            /* Alert Styles */
            .alert {
                padding: 15px;
                border-radius: 5px;
                margin-bottom: 20px;
            }

            .alert-success {
                background: #d4edda;
                color: #155724;
                border: 1px solid #c3e6cb;
            }

            .alert-danger {
                background: #f8d7da;
                color: #721c24;
                border: 1px solid #f1aeb5;
            }

            .alert-close {
                float: right;
                background: none;
                border: none;
                font-size: 20px;
                cursor: pointer;
            }

            /* Toolbar */
            .toolbar {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 25px;
                gap: 15px;
            }

            .search-form {
                display: flex;
                gap: 10px;
            }

            .form-input, .form-select {
                padding: 10px;
                border: 1px solid #ddd;
                border-radius: 4px;
                font-size: 14px;
            }

            .form-input {
                width: 250px;
            }

            .form-select {
                width: 200px;
            }

            .btn {
                padding: 10px 20px;
                border: none;
                border-radius: 4px;
                font-size: 14px;
                cursor: pointer;
                text-decoration: none;
                display: inline-block;
            }

            .btn-primary {
                background: #007bff;
                color: white;
            }

            .btn-secondary {
                background: #6c757d;
                color: white;
            }

            .btn-warning {
                background: #ffc107;
                color: #212529;
            }

            .btn-danger {
                background: #dc3545;
                color: white;
            }

            .btn-info {
                background: #17a2b8;
                color: white;
            }

            .btn-success {
                background: #28a745;
                color: white;
            }

            .btn:hover {
                opacity: 0.9;
            }

            .btn-sm {
                padding: 8px 15px;
                font-size: 13px;
            }

            /* Filter Panel */
            .filter-panel {
                background: #f8f9fa;
                padding: 15px;
                border-radius: 5px;
                margin-bottom: 20px;
                border: 1px solid #dee2e6;
            }

            .filter-row {
                display: flex;
                gap: 15px;
                align-items: end;
                flex-wrap: wrap;
            }

            .filter-group {
                display: flex;
                flex-direction: column;
                gap: 5px;
            }

            .filter-group label {
                font-weight: 500;
                color: #555;
                font-size: 14px;
            }

            /* Table Styles */
            .table-container {
                border: 1px solid #ddd;
                border-radius: 5px;
                overflow: hidden;
            }

            .table {
                width: 100%;
                border-collapse: collapse;
            }

            .table th {
                background: #f8f9fa;
                padding: 15px;
                text-align: left;
                font-weight: bold;
                border-bottom: 2px solid #dee2e6;
                position: relative;
                white-space: nowrap;
            }

            .table th a {
                color: #333;
                text-decoration: none;
                display: block;
                width: 100%;
                height: 100%;
            }

            .sort-icon {
                font-size: 12px;
                margin-left: 5px;
            }

            .table td {
                padding: 12px 15px;
                border-bottom: 1px solid #dee2e6;
            }

            .table tbody tr:hover {
                background: #f5f5f5;
            }

            /* Badge Styles */
            .badge {
                padding: 5px 10px;
                border-radius: 15px;
                font-size: 12px;
                font-weight: bold;
            }

            .badge-success {
                background: #28a745;
                color: white;
            }

            .badge-secondary {
                background: #6c757d;
                color: white;
            }

            .badge-info {
                background: #17a2b8;
                color: white;
            }

            .badge-primary {
                background: #007bff;
                color: white;
            }

            .text-muted {
                color: #6c757d;
                font-style: italic;
            }

            /* Action Buttons */
            .action-buttons {
                display: flex;
                gap: 8px;
            }

            /* Pagination */
            .pagination-container {
                text-align: center;
                margin-top: 25px;
            }

            .pagination {
                display: inline-flex;
                list-style: none;
                gap: 5px;
            }

            .page-link {
                display: block;
                padding: 8px 12px;
                color: #007bff;
                text-decoration: none;
                border: 1px solid #dee2e6;
                border-radius: 4px;
            }

            .page-link:hover {
                background: #e9ecef;
            }

            .page-item.active .page-link {
                background: #007bff;
                color: white;
                border-color: #007bff;
            }

            /* Empty State */
            .empty-state {
                text-align: center;
                padding: 50px;
                color: #6c757d;
            }

            /* Info Panel */
            .info-panel {
                background: #f8f9fa;
                padding: 15px;
                border-radius: 5px;
                margin-bottom: 20px;
                border-left: 4px solid #007bff;
            }

            /* Date time styles */
            .date-time {
                font-size: 12px;
                color: #666;
            }

            /* Responsive */
            @media (max-width: 1200px) {
                .table-container {
                    overflow-x: auto;
                }
            }

            @media (max-width: 768px) {
                .container {
                    padding: 15px;
                }

                .toolbar {
                    flex-direction: column;
                    align-items: stretch;
                }

                .nav-buttons {
                    flex-direction: column;
                }

                .action-buttons {
                    flex-direction: column;
                }

                .search-form {
                    flex-direction: column;
                }

                .form-input {
                    width: 100%;
                }

                .table th, .table td {
                    padding: 8px;
                    font-size: 12px;
                }

                .filter-row {
                    flex-direction: column;
                }

                .filter-group {
                    width: 100%;
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
                justify-content: center;
                gap: 20px;
            }
            .label {
                color: #888;
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
            /* Filter Section Styles */
            .filter-section {
                background: white;
                padding: 20px;
                margin-bottom: 20px;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                border: 1px solid #e9ecef;
            }

            .filter-row {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
                gap: 15px;
                align-items: end;
            }

            .filter-item {
                display: flex;
                flex-direction: column;
            }

            .filter-item label {
                margin-bottom: 5px;
                font-weight: 500;
                color: #555;
                font-size: 14px;
            }

            .filter-input,
            .filter-select {
                padding: 8px 12px;
                border: 1px solid #ddd;
                border-radius: 4px;
                font-size: 14px;
                transition: border-color 0.3s;
            }

            .filter-input:focus,
            .filter-select:focus {
                outline: none;
                border-color: #007bff;
            }

            .filter-actions {
                display: flex;
                gap: 10px;
                align-items: flex-end;
            }

            .filter-actions button {
                flex: 1;
            }

            /* Responsive cho filter */
            @media (max-width: 768px) {
                .filter-row {
                    grid-template-columns: 1fr;
                }

                .filter-actions {
                    margin-top: 10px;
                }
            }
        </style>
    </head>
    <body>
        <div class="layout-container">
            <jsp:include page="/include/sidebar.jsp" />
            <div class="main-content">
                <div class="header">
                    <h1 class="page-title">Quản lý danh mục loại sản phẩm</h1>
                    <div class="header-user">
                        <label class="label">Xin chào, <%= user.getFullname()%></label>
                        <a href="${pageContext.request.contextPath}/login.jsp" class="logout-btn">Đăng xuất</a>
                    </div>
                </div>

                <!-- Navigation Buttons -->
                <div class="nav-buttons">
                    <a href="/ProjectWarehouse/categoriesforward.jsp" class="btn btn-info">← Quay lại trang trước</a>
                </div>

                <!-- Thông báo -->
                <c:if test="${not empty successMessage}">
                    <div class="alert alert-success">
                        ${successMessage}
                        <button type="button" class="alert-close" onclick="this.parentElement.style.display = 'none'">&times;</button>
                    </div>
                </c:if>

                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger">
                        ${errorMessage}
                        <button type="button" class="alert-close" onclick="this.parentElement.style.display = 'none'">&times;</button>
                    </div>
                </c:if>

                <!-- Thanh công cụ -->
                <div class="toolbar">
                    <div style="display: flex; gap: 10px;">
                        <a href="${pageContext.request.contextPath}/category/create" class="btn btn-primary">+ Thêm danh mục</a>
                        <a href="${pageContext.request.contextPath}/category/statistics" class="btn btn-primary">Thống kê danh mục loại sản phẩm</a> 
                    </div>
                </div>

                <!-- Filter Section -->
                <div class="filter-section">
                    <h3 style="margin-bottom: 15px; color: #333;">Bộ lọc</h3>
                    <form id="filterForm" method="get" action="${pageContext.request.contextPath}/category/list">
                        <div class="filter-row">
                            <div class="filter-item">
                                <label>Tìm kiếm:</label>
                                <input type="text" name="search" value="${searchKeyword}" 
                                       placeholder="Nhập tên danh mục..." class="filter-input">
                            </div>
                            <div class="filter-item">
                                <label>Trạng thái:</label>
                                <select name="status" class="filter-select">
                                    <option value="">Tất cả</option>
                                    <option value="1" ${status == '1' ? 'selected' : ''}>Hoạt động</option>
                                    <option value="0" ${status == '0' ? 'selected' : ''}>Không hoạt động</option>
                                </select>
                            </div>
                            <div class="filter-item">
                                <label>Danh mục cha:</label>
                                <select name="parentId" class="filter-select">
                                    <option value="">Tất cả</option>
                                    <option value="-1" ${parentId == -1 ? 'selected' : ''}>Danh mục gốc</option>
                                    <c:forEach var="root" items="${rootCategories}">
                                        <option value="${root.id}" ${parentId == root.id ? 'selected' : ''}>
                                            ${root.name}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="filter-actions">
                                <button type="submit" class="btn btn-primary">Lọc</button>
                                <button type="button" class="btn btn-secondary" onclick="resetFilter()">Đặt lại</button>
                            </div>
                        </div>
                    </form>
                </div>

                <!-- Bảng danh sách -->
                <div class="table-container">
                    <c:choose>
                        <c:when test="${not empty categories}">
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>
                                            <a href="?sortField=id&sortDir=${sortField eq 'id' ? reverseSortDir : 'asc'}&search=${searchKeyword}&status=${status}&parentId=${parentId}">
                                                ID 
                                                <c:if test="${sortField eq 'id'}">
                                                    <span class="sort-icon">${sortDir eq 'asc' ? '↑' : '↓'}</span>
                                                </c:if>
                                            </a>
                                        </th>
                                        <th>
                                            <a href="?sortField=name&sortDir=${sortField eq 'name' ? reverseSortDir : 'asc'}&search=${searchKeyword}&status=${status}&parentId=${parentId}">
                                                Tên danh mục 
                                                <c:if test="${sortField eq 'name'}">
                                                    <span class="sort-icon">${sortDir eq 'asc' ? '↑' : '↓'}</span>
                                                </c:if>
                                            </a>
                                        </th>
                                        <th>
                                            <a href="?sortField=parent_name&sortDir=${sortField eq 'parent_name' ? reverseSortDir : 'asc'}&search=${searchKeyword}&status=${status}&parentId=${parentId}">
                                                Danh mục cha 
                                                <c:if test="${sortField eq 'parent_name'}">
                                                    <span class="sort-icon">${sortDir eq 'asc' ? '↑' : '↓'}</span>
                                                </c:if>
                                            </a>
                                        </th>
                                        <th>
                                            <a href="?sortField=active_flag&sortDir=${sortField eq 'active_flag' ? reverseSortDir : 'asc'}&search=${searchKeyword}&status=${status}&parentId=${parentId}">
                                                Trạng thái 
                                                <c:if test="${sortField eq 'active_flag'}">
                                                    <span class="sort-icon">${sortDir eq 'asc' ? '↑' : '↓'}</span>
                                                </c:if>
                                            </a>
                                        </th>
                                        <th>
                                            <a href="?sortField=create_date&sortDir=${sortField eq 'create_date' ? reverseSortDir : 'asc'}&search=${searchKeyword}&status=${status}&parentId=${parentId}">
                                                Ngày tạo 
                                                <c:if test="${sortField eq 'create_date'}">
                                                    <span class="sort-icon">${sortDir eq 'asc' ? '↑' : '↓'}</span>
                                                </c:if>
                                            </a>
                                        </th>
                                        <th>
                                            <a href="?sortField=update_date&sortDir=${sortField eq 'update_date' ? reverseSortDir : 'asc'}&search=${searchKeyword}&status=${status}&parentId=${parentId}">
                                                Ngày cập nhật 
                                                <c:if test="${sortField eq 'update_date'}">
                                                    <span class="sort-icon">${sortDir eq 'asc' ? '↑' : '↓'}</span>
                                                </c:if>
                                            </a>
                                        </th>
                                        <th>Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="category" items="${categories}">
                                        <tr>
                                            <td>#${category.id}</td>
                                            <td>
                                                <strong>${category.name}</strong>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty category.parentName}">
                                                        <span class="badge badge-info">${category.parentName}</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge badge-primary">Danh mục gốc</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <span class="badge ${category.activeFlag ? 'badge-success' : 'badge-secondary'}" 
                                                      id="status-${category.id}">
                                                    ${category.activeFlag ? 'Hoạt động' : 'Không hoạt động'}
                                                </span>
                                            </td>
                                            <td>
                                                <div class="date-time">
                                                    <c:choose>
                                                        <c:when test="${not empty category.createdAt}">
                                                            ${dateTimeFormatter.format(category.createdAt)}
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-muted">--</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="date-time">
                                                    <c:choose>
                                                        <c:when test="${not empty category.updatedAt}">
                                                            ${dateTimeFormatter.format(category.updatedAt)}
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-muted">--</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="action-buttons">
                                                    <a href="${pageContext.request.contextPath}/category/edit?id=${category.id}" 
                                                       class="btn btn-warning btn-sm" title="Chỉnh sửa">
                                                        Sửa
                                                    </a>
                                                    <button type="button" 
                                                            class="btn ${category.activeFlag ? 'btn-danger' : 'btn-success'} btn-sm" 
                                                            id="toggle-${category.id}"
                                                            onclick="toggleCategoryStatus(${category.id})" 
                                                            title="${category.activeFlag ? 'Vô hiệu hóa' : 'Kích hoạt'}">
                                                        ${category.activeFlag ? 'vô hiệu hóa' : 'kích hoạt'}
                                                    </button>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-state">
                                <h3>Không có danh mục nào</h3>
                                <c:choose>
                                    <c:when test="${not empty searchKeyword or not empty status or not empty parentId}">
                                        <p>Không tìm thấy danh mục nào với bộ lọc hiện tại</p>
                                        <a href="${pageContext.request.contextPath}/category/list" class="btn btn-info">← Xem tất cả danh mục</a>
                                    </c:when>
                                    <c:otherwise>
                                        <p>Hãy thêm danh mục đầu tiên của bạn</p>
                                        <a href="${pageContext.request.contextPath}/category/create" class="btn btn-primary">+ Thêm danh mục</a>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Phân trang -->
                <c:if test="${totalPages > 1}">
                    <div class="pagination-container">
                        <ul class="pagination">
                            <!-- First page -->
                            <c:if test="${currentPage > 1}">
                                <li class="page-item">
                                    <a class="page-link" href="?page=${currentPage-1}&search=${searchKeyword}&status=${status}&parentId=${parentId}&sortField=${sortField}&sortDir=${sortDir}">Trước</a>
                                </li>
                            </c:if>

                            <!-- Page numbers -->
                            <c:forEach begin="${startPage}" end="${endPage}" var="i">
                                <li class="page-item ${i eq currentPage ? 'active' : ''}">
                                    <a class="page-link" href="?page=${i}&search=${searchKeyword}&status=${status}&parentId=${parentId}&sortField=${sortField}&sortDir=${sortDir}">${i}</a>
                                </li>
                            </c:forEach>

                            <!-- Next page -->
                            <c:if test="${currentPage < totalPages}">
                                <li class="page-item">
                                    <a class="page-link" href="?page=${currentPage+1}&search=${searchKeyword}&status=${status}&parentId=${parentId}&sortField=${sortField}&sortDir=${sortDir}">Sau</a>
                                </li>
                            </c:if>
                        </ul>
                    </div>
                </c:if>
            </div>
        </div>

        <script>
            // Auto hide alerts after 5 seconds
            document.addEventListener('DOMContentLoaded', function () {
                const alerts = document.querySelectorAll('.alert');
                alerts.forEach(function (alert) {
                    setTimeout(function () {
                        alert.style.display = 'none';
                    }, 5000);
                });
            });

            // Toggle category status function với CONFIRM
            function toggleCategoryStatus(categoryId) {
                // Lấy thông tin hiện tại
                const statusBadge = document.getElementById('status-' + categoryId);
                const toggleBtn = document.getElementById('toggle-' + categoryId);
                const currentStatus = statusBadge.textContent.trim();

                // Lấy tên danh mục từ bảng
                const categoryName = findCategoryNameById(categoryId);

                // Tạo message confirm dựa trên trạng thái hiện tại
                let confirmMessage;
                if (currentStatus === 'Hoạt động') {
                    confirmMessage = `Bạn có chắc chắn muốn VÔ HIỆU HÓA danh mục`;
                } else {
                    confirmMessage = `Bạn có chắc chắn muốn KÍCH HOẠT danh mục`;
                }

                // Hiển thị confirm dialog
                if (!confirm(confirmMessage)) {
                    return; // Người dùng hủy bỏ
                }

                // Thêm loading effect
                addLoadingEffect(toggleBtn);
                const originalBtnText = toggleBtn.textContent;

                fetch('${pageContext.request.contextPath}/category/toggle-status?id=' + categoryId, {
                    method: 'GET'
                })
                        .then(response => response.json())
                        .then(data => {
                            if (data.success) {
                                // Update status badge của danh mục hiện tại
                                statusBadge.textContent = data.newStatus;
                                statusBadge.className = 'badge ' + data.statusClass;

                                // Update toggle button
                                toggleBtn.textContent = data.buttonText;
                                toggleBtn.className = 'btn ' + data.buttonClass + ' btn-sm';
                                toggleBtn.title = data.newStatus === 'Hoạt động' ? 'Vô hiệu hóa' : 'Kích hoạt';

                                // Hiển thị thông báo thành công
                                showSuccessMessage(data.newStatus === 'Hoạt động' ?
                                        `Đã kích hoạt danh mục "${categoryName}" thành công!` :
                                        `Đã vô hiệu hóa danh mục "${categoryName}" thành công!`
                                        );

                                // Nếu vô hiệu hóa và có danh mục con, cập nhật tất cả danh mục con
                                if (data.childrenDeactivated === true && data.newStatus === 'Không hoạt động') {
                                    updateChildCategoriesStatus(categoryId, false);
                                    showInfoMessage(`Đã tự động vô hiệu hóa các danh mục con liên quan.`);
                                }
                            } else {
                                // Hiển thị lỗi
                                console.error('Failed to toggle status:', data.message);
                                showErrorMessage(data.message || 'Có lỗi xảy ra khi thay đổi trạng thái danh mục.');

                                // Nếu lỗi do danh mục cha inactive, hiển thị tooltip
                                if (data.message && data.message.includes('danh mục cha')) {
                                    showTooltip(toggleBtn, data.message);
                                }
                            }
                        })
                        .catch(error => {
                            console.error('Error:', error);
                            showErrorMessage('Có lỗi xảy ra khi kết nối đến server. Vui lòng thử lại.');
                        })
                        .finally(() => {
                            // Remove loading effect
                            removeLoadingEffect(toggleBtn);
                        });
            }

            // Hàm hiển thị thông báo thành công
            function showSuccessMessage(message) {
                showNotification(message, 'success', 'fas fa-check-circle');
            }

            // Hàm hiển thị thông báo lỗi
            function showErrorMessage(message) {
                showNotification(message, 'danger', 'fas fa-exclamation-circle');
            }

            // Hàm hiển thị thông báo thông tin
            function showInfoMessage(message) {
                showNotification(message, 'info', 'fas fa-info-circle');
            }

            // Hàm chung để hiển thị thông báo
            function showNotification(message, type, icon) {
                // Tạo unique ID cho notification
                const notificationId = 'notification-' + Date.now();

                const alertHtml = `
          <div id="${notificationId}" class="alert alert-${type} alert-dismissible fade show" role="alert" style="position: fixed; top: 20px; right: 20px; z-index: 9999; min-width: 300px; max-width: 500px;">
              <i class="${icon} me-2"></i>
            ${message}
              <button type="button" class="btn-close" data-bs-dismiss="alert" onclick="document.getElementById('${notificationId}').remove()"></button>
          </div>
      `;

                // Thêm vào body
                document.body.insertAdjacentHTML('beforeend', alertHtml);

                // Tự động ẩn sau một khoảng thời gian
                const autoHideTime = type === 'danger' ? 5000 : 3000;
                setTimeout(() => {
                    const notification = document.getElementById(notificationId);
                    if (notification) {
                        notification.remove();
                    }
                }, autoHideTime);
            }

            // Hàm cập nhật trạng thái của tất cả danh mục con trên UI
            function updateChildCategoriesStatus(parentId, isActive) {
                // Tìm tất cả các row trong table
                const rows = document.querySelectorAll('.table tbody tr');

                rows.forEach(row => {
                    // Lấy cell chứa danh mục cha
                    const parentCell = row.cells[2]; // Cột thứ 3 là danh mục cha
                    const parentBadge = parentCell.querySelector('.badge-info');

                    if (parentBadge) {
                        // Lấy tên danh mục cha từ badge
                        const parentName = parentBadge.textContent.trim();

                        // Tìm tên của danh mục hiện tại
                        const currentCategoryName = findCategoryNameById(parentId);

                        // Nếu danh mục này có cha là danh mục đang được toggle
                        if (parentName === currentCategoryName) {
                            // Lấy ID của danh mục con từ cột đầu tiên
                            const childId = row.cells[0].textContent.replace('#', '');

                            // Cập nhật status badge
                            const childStatusBadge = document.getElementById('status-' + childId);
                            if (childStatusBadge) {
                                childStatusBadge.textContent = isActive ? 'Hoạt động' : 'Không hoạt động';
                                childStatusBadge.className = isActive ? 'badge badge-success' : 'badge badge-secondary';
                            }

                            // Cập nhật toggle button
                            const childToggleBtn = document.getElementById('toggle-' + childId);
                            if (childToggleBtn) {
                                childToggleBtn.textContent = isActive ? 'vô hiệu hóa' : 'kích hoạt';  // ← SỬA LẠI
                                childToggleBtn.className = isActive ? 'btn btn-danger btn-sm' : 'btn btn-success btn-sm';
                                childToggleBtn.title = isActive ? 'Vô hiệu hóa' : 'Kích hoạt';
                            }


                            // Đệ quy: cập nhật con của con
                            updateChildCategoriesStatus(childId, isActive);
                        }
                    }
                });
            }

            // Hàm tìm tên danh mục theo ID
            function findCategoryNameById(categoryId) {
                const rows = document.querySelectorAll('.table tbody tr');
                for (let row of rows) {
                    const id = row.cells[0].textContent.replace('#', '');
                    if (id === categoryId.toString()) {
                        return row.cells[1].querySelector('strong').textContent.trim();
                    }
                }
                return 'Danh mục #' + categoryId; // Fallback nếu không tìm thấy
            }

            // Hiển thị tooltip thông báo lỗi
            function showTooltip(element, message) {
                // Tạo tooltip element
                const tooltip = document.createElement('div');
                tooltip.className = 'custom-tooltip';
                tooltip.textContent = message;
                tooltip.style.cssText = `
          position: absolute;
          background: #dc3545;
          color: white;
          padding: 8px 12px;
          border-radius: 4px;
          font-size: 12px;
          z-index: 1000;
          max-width: 250px;
          box-shadow: 0 2px 5px rgba(0,0,0,0.2);
      `;

                // Thêm vào body
                document.body.appendChild(tooltip);

                // Định vị tooltip
                const rect = element.getBoundingClientRect();
                tooltip.style.top = (rect.top - tooltip.offsetHeight - 5) + 'px';
                tooltip.style.left = (rect.left + rect.width / 2 - tooltip.offsetWidth / 2) + 'px';

                // Tự động ẩn sau 3 giây
                setTimeout(() => {
                    tooltip.remove();
                }, 3000);
            }

            // Thêm hiệu ứng loading khi toggle
            function addLoadingEffect(button) {
                button.disabled = true;
                button.style.opacity = '0.6';
                button.style.cursor = 'wait';
                button.textContent = '⏳';
            }

            function removeLoadingEffect(button) {
                button.disabled = false;
                button.style.opacity = '1';
                button.style.cursor = 'pointer';
            }

            // Reset filter function
            function resetFilter() {
                window.location.href = '${pageContext.request.contextPath}/category/list';
            }
        </script>
    </body>
</html>