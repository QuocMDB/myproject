<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

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

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản lý phòng ban</title>
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
                max-width: 1400px;
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
                vertical-align: top;
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

            .badge-warning {
                background: #ffc107;
                color: #212529;
            }

            .text-muted {
                color: #6c757d;
                font-style: italic;
            }

            /* Action Buttons */
            .action-buttons {
                display: flex;
                gap: 8px;
                flex-wrap: wrap;
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

            /* Contact info styles */
            .contact-info {
                font-size: 13px;
                color: #555;
            }

            .contact-info i {
                margin-right: 5px;
                color: #007bff;
            }

            .department-info {
                margin-bottom: 8px;
            }

            .manager-info {
                font-weight: 500;
                color: #28a745;
            }

            .employee-count {
                font-weight: bold;
                color: #17a2b8;
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

            /* Modal for employee list */
            .modal {
                display: none;
                position: fixed;
                z-index: 1000;
                left: 0;
                top: 0;
                width: 100%;
                height: 100%;
                background-color: rgba(0,0,0,0.5);
            }

            .modal-content {
                background-color: white;
                margin: 15% auto;
                padding: 20px;
                border-radius: 8px;
                width: 80%;
                max-width: 800px;
                max-height: 70vh;
                overflow-y: auto;
            }

            .modal-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 20px;
                padding-bottom: 10px;
                border-bottom: 1px solid #eee;
            }

            .close {
                color: #aaa;
                font-size: 28px;
                font-weight: bold;
                cursor: pointer;
            }

            .close:hover {
                color: black;
            }

            /* Employee list in modal */
            .employee-list {
                list-style: none;
                padding: 0;
            }

            .employee-item {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 10px;
                border-bottom: 1px solid #eee;
            }

            .employee-item:last-child {
                border-bottom: none;
            }

            .employee-info {
                flex: 1;
            }

            .employee-name {
                font-weight: bold;
                margin-bottom: 5px;
            }

            .employee-details {
                font-size: 12px;
                color: #666;
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
                    <h1 class="page-title">Quản lý phòng ban</h1>
                    <div class="header-user">
                        <label class="label">Xin chào, <%= user.getFullname()%></label>
                        <a href="${pageContext.request.contextPath}/login.jsp" class="logout-btn">Đăng xuất</a>
                    </div>
                </div>

                <!-- Navigation Buttons -->
                <div class="nav-buttons">
                    <a href="/ProjectWarehouse/categoriesforward.jsp" class="btn btn-info">← Quay lại</a>
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
                        <a href="${pageContext.request.contextPath}/department/create" class="btn btn-primary">+ Thêm phòng ban</a>
                        <a href="${pageContext.request.contextPath}/department/statistics" class="btn btn-info">📊 Thống kê phòng ban</a>
                    </div>
                </div>

                <!-- Filter Section -->
                <div class="filter-section">
                    <h3 style="margin-bottom: 15px; color: #333;">Bộ lọc</h3>
                    <form id="filterForm" method="get" action="${pageContext.request.contextPath}/department/list">
                        <div class="filter-row">
                            <div class="filter-item">
                                <label>Tìm kiếm:</label>
                                <input type="text" name="search" value="${searchKeyword}" 
                                       placeholder="Nhập tên hoặc mã phòng ban..." class="filter-input">
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
                                <label>Có trưởng phòng:</label>
                                <select name="hasManager" class="filter-select">
                                    <option value="">Tất cả</option>
                                    <option value="1" ${hasManager == '1' ? 'selected' : ''}>Có trưởng phòng</option>
                                    <option value="0" ${hasManager == '0' ? 'selected' : ''}>Chưa có trưởng phòng</option>
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
                        <c:when test="${not empty departments}">
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>
                                            <a href="?sortField=id&sortDir=${sortField eq 'id' ? reverseSortDir : 'asc'}&search=${searchKeyword}&status=${status}&hasManager=${hasManager}">
                                                ID 
                                                <c:if test="${sortField eq 'id'}">
                                                    <span class="sort-icon">${sortDir eq 'asc' ? '↑' : '↓'}</span>
                                                </c:if>
                                            </a>
                                        </th>
                                        <th>
                                            <a href="?sortField=dept_code&sortDir=${sortField eq 'dept_code' ? reverseSortDir : 'asc'}&search=${searchKeyword}&status=${status}&hasManager=${hasManager}">
                                                Mã phòng ban 
                                                <c:if test="${sortField eq 'dept_code'}">
                                                    <span class="sort-icon">${sortDir eq 'asc' ? '↑' : '↓'}</span>
                                                </c:if>
                                            </a>
                                        </th>
                                        <th>
                                            <a href="?sortField=dept_name&sortDir=${sortField eq 'dept_name' ? reverseSortDir : 'asc'}&search=${searchKeyword}&status=${status}&hasManager=${hasManager}">
                                                Tên phòng ban 
                                                <c:if test="${sortField eq 'dept_name'}">
                                                    <span class="sort-icon">${sortDir eq 'asc' ? '↑' : '↓'}</span>
                                                </c:if>
                                            </a>
                                        </th>
                                        <th>Trưởng phòng</th>
                                        <th>Thông tin liên hệ</th>
                                        <th>Số nhân viên</th>
                                        <th>
                                            <a href="?sortField=active_flag&sortDir=${sortField eq 'active_flag' ? reverseSortDir : 'asc'}&search=${searchKeyword}&status=${status}&hasManager=${hasManager}">
                                                Trạng thái 
                                                <c:if test="${sortField eq 'active_flag'}">
                                                    <span class="sort-icon">${sortDir eq 'asc' ? '↑' : '↓'}</span>
                                                </c:if>
                                            </a>
                                        </th>
                                        <th>
                                            <a href="?sortField=create_date&sortDir=${sortField eq 'create_date' ? reverseSortDir : 'asc'}&search=${searchKeyword}&status=${status}&hasManager=${hasManager}">
                                                Ngày tạo 
                                                <c:if test="${sortField eq 'create_date'}">
                                                    <span class="sort-icon">${sortDir eq 'asc' ? '↑' : '↓'}</span>
                                                </c:if>
                                            </a>
                                        </th>
                                        <th>Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="department" items="${departments}">
                                        <tr>
                                            <td>#${department.id}</td>
                                            <td>
                                                <span class="badge badge-info">${department.deptCode}</span>
                                            </td>
                                            <td>
                                                <div class="department-info">
                                                    <strong>${department.deptName}</strong>
                                                </div>
                                                <c:if test="${not empty department.description}">
                                                    <div class="text-muted" style="font-size: 12px; margin-top: 5px;">
                                                        ${department.description}
                                                    </div>
                                                </c:if>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty department.managerName}">
                                                        <div class="manager-info">${department.managerName}</div>
                                                        <c:if test="${not empty department.managerEmail}">
                                                            <div class="contact-info">
                                                                📧 ${department.managerEmail}
                                                            </div>
                                                        </c:if>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge badge-warning">Chưa có trưởng phòng</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:if test="${not empty department.phone}">
                                                    <div class="contact-info">
                                                        📞 ${department.phone}
                                                    </div>
                                                </c:if>
                                                <c:if test="${not empty department.email}">
                                                    <div class="contact-info">
                                                        📧 ${department.email}
                                                    </div>
                                                </c:if>
                                                <c:if test="${empty department.phone && empty department.email}">
                                                    <span class="text-muted">--</span>
                                                </c:if>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${department.employeeCount > 0}">
                                                        <span class="employee-count">${department.employeeCount} người</span>
                                                        <br>
                                                        <!-- ĐÃ SỬA: Lưu tên phòng ban vào data attribute -->
                                                        <button type="button" class="btn btn-info btn-sm" 
                                                                data-department-id="${department.id}"
                                                                data-department-name="${fn:escapeXml(department.deptName)}"
                                                                onclick="showEmployeeList(this)" 
                                                                title="Xem danh sách nhân viên">
                                                            👥 Xem DS
                                                        </button>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted">0 người</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <span class="badge ${department.activeFlag ? 'badge-success' : 'badge-secondary'}" 
                                                      id="status-${department.id}">
                                                    ${department.activeFlag ? 'Hoạt động' : 'Không hoạt động'}
                                                </span>
                                            </td>
                                            <td>
                                                <div class="date-time">
                                                    <c:choose>
                                                        <c:when test="${not empty department.createDate}">
                                                            ${department.createDate.format(dateTimeFormatter)}
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-muted">--</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                                <c:if test="${not empty department.createdByName}">
                                                    <div class="text-muted" style="font-size: 11px;">
                                                        Bởi: ${department.createdByName}
                                                    </div>
                                                </c:if>
                                            </td>
                                            <td>
                                                <div class="action-buttons">
                                                    <a href="${pageContext.request.contextPath}/department/edit?id=${department.id}" 
                                                       class="btn btn-warning btn-sm" title="Chỉnh sửa">
                                                        Sửa
                                                    </a>
                                                    <button type="button" 
                                                            class="btn ${department.activeFlag ? 'btn-danger' : 'btn-success'} btn-sm" 
                                                            id="toggle-${department.id}"
                                                            onclick="toggleDepartmentStatus(${department.id})" 
                                                            title="${department.activeFlag ? 'Vô hiệu hóa' : 'Kích hoạt'}">
                                                        ${department.activeFlag ? 'Vô hiệu hóa' : 'Kích hoạt'}
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
                                <h3>Không có phòng ban nào</h3>
                                <c:choose>
                                    <c:when test="${not empty searchKeyword or not empty status or not empty hasManager}">
                                        <p>Không tìm thấy phòng ban nào với bộ lọc hiện tại</p>
                                        <a href="${pageContext.request.contextPath}/department/list" class="btn btn-info">← Xem tất cả phòng ban</a>
                                    </c:when>
                                    <c:otherwise>
                                        <p>Hãy thêm phòng ban đầu tiên của bạn</p>
                                        <a href="${pageContext.request.contextPath}/department/create" class="btn btn-primary">+ Thêm phòng ban</a>
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
                            <!-- Previous page -->
                            <c:if test="${currentPage > 1}">
                                <li class="page-item">
                                    <a class="page-link" href="?page=${currentPage-1}&search=${searchKeyword}&status=${status}&hasManager=${hasManager}&sortField=${sortField}&sortDir=${sortDir}">Trước</a>
                                </li>
                            </c:if>

                            <!-- Page numbers -->
                            <c:forEach begin="${startPage}" end="${endPage}" var="i">
                                <li class="page-item ${i eq currentPage ? 'active' : ''}">
                                    <a class="page-link" href="?page=${i}&search=${searchKeyword}&status=${status}&hasManager=${hasManager}&sortField=${sortField}&sortDir=${sortDir}">${i}</a>
                                </li>
                            </c:forEach>

                            <!-- Next page -->
                            <c:if test="${currentPage < totalPages}">
                                <li class="page-item">
                                    <a class="page-link" href="?page=${currentPage+1}&search=${searchKeyword}&status=${status}&hasManager=${hasManager}&sortField=${sortField}&sortDir=${sortDir}">Sau</a>
                                </li>
                            </c:if>
                        </ul>
                    </div>
                </c:if>
            </div>
        </div>

        <!-- Modal xem danh sách nhân viên -->
        <div id="employeeModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h2 id="modalTitle">Danh sách nhân viên</h2>
                    <span class="close" onclick="closeEmployeeModal()">&times;</span>
                </div>
                <div id="employeeListContent">
                    <!-- Danh sách nhân viên sẽ được load vào đây -->
                </div>
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

            // Toggle department status function
            function toggleDepartmentStatus(departmentId) {
                const statusBadge = document.getElementById('status-' + departmentId);
                const toggleBtn = document.getElementById('toggle-' + departmentId);
                const currentStatus = statusBadge.textContent.trim();

                const departmentName = findDepartmentNameById(departmentId);

                let confirmMessage;
                if (currentStatus === 'Hoạt động') {
                    confirmMessage = `Bạn có chắc chắn muốn VÔ HIỆU HÓA phòng ban`;
                } else {
                    confirmMessage = `Bạn có chắc chắn muốn KÍCH HOẠT phòng ban`;
                }

                if (!confirm(confirmMessage)) {
                    return;
                }

                addLoadingEffect(toggleBtn);

                fetch('${pageContext.request.contextPath}/department/toggle-status?id=' + departmentId, {
                    method: 'GET'
                })
                        .then(response => response.json())
                        .then(data => {
                            if (data.success) {
                                statusBadge.textContent = data.newStatus;
                                statusBadge.className = 'badge ' + data.statusClass;

                                toggleBtn.textContent = data.buttonText;
                                toggleBtn.className = 'btn ' + data.buttonClass + ' btn-sm';
                                toggleBtn.title = data.newStatus === 'Hoạt động' ? 'Vô hiệu hóa' : 'Kích hoạt';

                                showSuccessMessage(data.newStatus === 'Hoạt động' ?
                                        `Đã kích hoạt phòng ban thành công!` :
                                        `Đã vô hiệu hóa phòng ban thành công!`
                                        );
                            } else {
                                showErrorMessage(data.message || 'Có lỗi xảy ra khi thay đổi trạng thái phòng ban.');
                            }
                        })
                        .catch(error => {
                            console.error('Error:', error);
                            showErrorMessage('Có lỗi xảy ra khi kết nối đến server. Vui lòng thử lại.');
                        })
                        .finally(() => {
                            removeLoadingEffect(toggleBtn);
                        });
            }

            // ĐÃ SỬA: Show employee list modal - lấy data từ button element
            function showEmployeeList(button) {
                const departmentId = button.getAttribute('data-department-id');
                const departmentName = button.getAttribute('data-department-name');
                
                console.log('Department ID:', departmentId);
                console.log('Department Name:', departmentName);
                
                document.getElementById('modalTitle').textContent = 'Danh sách nhân viên - ' + departmentName;
                document.getElementById('employeeListContent').innerHTML = '<div style="text-align: center; padding: 20px;">Đang tải...</div>';
                document.getElementById('employeeModal').style.display = 'block';

                fetch('${pageContext.request.contextPath}/department/employees?id=' + departmentId)
                        .then(response => {
                            console.log('Response status:', response.status);
                            if (!response.ok) {
                                throw new Error('Network response was not ok');
                            }
                            return response.json();
                        })
                        .then(data => {
                            console.log('Data received:', data);
                            if (data.success && data.employees && data.employees.length > 0) {
                                let html = '<ul class="employee-list">';
                                data.employees.forEach(emp => {
                                    html += `
                                        <li class="employee-item">
                                            <div class="employee-info">
                                                <div class="employee-name">\${emp.fullname || 'N/A'}</div>
                                                <div class="employee-details">
                                                    📧 \${emp.email || 'N/A'} | 📞 \${emp.phone || 'N/A'} | 
                                                    Chức vụ: \${emp.roles || 'N/A'} | 
                                                    Trạng thái: <span class="badge \${emp.active ? 'badge-success' : 'badge-secondary'}">\${emp.active ? 'Hoạt động' : 'Không hoạt động'}</span>
                                                </div>
                                            </div>
                                        </li>
                                    `;
                                });
                                html += '</ul>';
                                document.getElementById('employeeListContent').innerHTML = html;
                            } else {
                                document.getElementById('employeeListContent').innerHTML = '<div style="text-align: center; padding: 20px; color: #666;">Phòng ban này chưa có nhân viên nào.</div>';
                            }
                        })
                        .catch(error => {
                            console.error('Error:', error);
                            document.getElementById('employeeListContent').innerHTML = '<div style="text-align: center; padding: 20px; color: red;">Có lỗi xảy ra khi tải danh sách nhân viên.</div>';
                        });
            }

            // Close employee modal
            function closeEmployeeModal() {
                document.getElementById('employeeModal').style.display = 'none';
            }

            // Close modal when clicking outside
            window.onclick = function (event) {
                const modal = document.getElementById('employeeModal');
                if (event.target == modal) {
                    modal.style.display = 'none';
                }
            }

            // Utility functions
            function findDepartmentNameById(departmentId) {
                const rows = document.querySelectorAll('.table tbody tr');
                for (let row of rows) {
                    const id = row.cells[0].textContent.replace('#', '');
                    if (id === departmentId.toString()) {
                        return row.cells[2].querySelector('strong').textContent.trim();
                    }
                }
                return 'Phòng ban #' + departmentId;
            }

            function showSuccessMessage(message) {
                showNotification(message, 'success');
            }

            function showErrorMessage(message) {
                showNotification(message, 'danger');
            }

            function showNotification(message, type) {
                const notificationId = 'notification-' + Date.now();
                const alertHtml = `
                    <div id="\${notificationId}" class="alert alert-\${type}" style="position: fixed; top: 20px; right: 20px; z-index: 9999; min-width: 300px; max-width: 500px;">
                        \${message}
                        <button type="button" class="alert-close" onclick="document.getElementById('\${notificationId}').remove()">&times;</button>
                    </div>
                `;
                document.body.insertAdjacentHTML('beforeend', alertHtml);
                setTimeout(() => {
                    const notification = document.getElementById(notificationId);
                    if (notification)
                        notification.remove();
                }, 3000);
            }

            function addLoadingEffect(button) {
                button.disabled = true;
                button.style.opacity = '0.6';
                button.textContent = '⏳ Đang xử lý...';
            }

            function removeLoadingEffect(button) {
                button.disabled = false;
                button.style.opacity = '1';
            }

            function resetFilter() {
                window.location.href = '${pageContext.request.contextPath}/department/list';
            }
        </script>
    </body>
</html>