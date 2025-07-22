<%-- 
    Document   : UserManager
    Created on : 27 thg 5, 2025, 14:39:06
    Author     : phucn
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page import="model.Users" session="true" %> 
<!DOCTYPE html>

<%@page import="model.Users"%>
<%
    Users user = (Users) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<%
response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1
response.setHeader("Pragma", "no-cache"); // HTTP 1.0
response.setDateHeader("Expires", 0); // Proxies
%>

<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản lý người dùng - Hệ thống kho</title>
        <style>
            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: #f0f4f8;
                color: #222;
                margin: 0;
                padding: 0;
            }
            .container {
                display: flex;
                min-height: 100vh;
            }
            .sidebar {
                position: fixed;
                top: 0;
                left: 0;
                width: 250px;
                height: 100vh;
                background: #e6f0fa;
                padding: 20px 0;
                border-right: 1px solid #d6e0ef;
                z-index: 100;
            }
            .sidebar h2 {
                font-size: 1.4rem;
                color: #1567c1;
                text-align: center;
                margin-bottom: 20px;
            }
            .nav-item {
                display: block;
                padding: 10px 20px;
                color: #214463;
                text-decoration: none;
                font-size: 1rem;
            }
            .nav-item:hover {
                background: #c2e9fb;
                color: #1567c1;
            }
            .main-content {
                margin-left: 250px;
                flex: 1;
                padding: 20px;
            }
            .header {
                background: #fff;
                padding: 15px;
                border-bottom: 1px solid #d6e0ef;
                margin-bottom: 20px;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }
            .header-title {
                font-size: 1.8rem;
                color: #1567c1;
                margin: 0;
                display: flex;
                align-items: center;
            }
            .header-user {
                display: flex;
                align-items: center;
            }
            .user-name {
                font-size: 1rem;
                color: #214463;
                margin-right: 15px;
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
            .dashboard-content {
                background: #fff;
                padding: 20px;
                border: 1px solid #d6e0ef;
                border-radius: 8px;
            }
            .page-title {
                font-size: 1.6rem;
                color: #222e45;
                margin-bottom: 10px;
            }
            .btn {
                padding: 10px 20px;
                border: none;
                border-radius: 5px;
                text-decoration: none;
                font-size: 14px;
                font-weight: 500;
                display: inline-flex;
                align-items: center;
                gap: 8px;
                transition: all 0.2s ease;
                cursor: pointer;
                background: #3a8dde;
                color: #fff;
            }
            .btn:hover {
                background: #1567c1;
            }
            .filter-section {
                background: #fff;
                border: 1px solid #d6e0ef;
                border-radius: 8px;
                padding: 20px;
                margin-bottom: 20px;
            }
            .filter-title {
                font-size: 1.2rem;
                color: #1567c1;
                margin-bottom: 15px;
            }
            .filter-bar {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                gap: 15px;
                align-items: end;
            }
            .filter-group {
                display: flex;
                flex-direction: column;
                gap: 5px;
            }
            .filter-label {
                font-size: 0.9rem;
                color: #5a7da0;
            }
            .filter-bar select, .filter-bar input[type="text"] {
                padding: 10px;
                border: 2px solid #e1e5e9;
                border-radius: 4px;
                font-size: 14px;
                width: 95%;
            }
            .filter-bar select:focus, .filter-bar input[type="text"]:focus {
                outline: none;
                border-color: #3a8dde;
            }
            .search-btn {
                background: #3a8dde;
                color: #fff;
                padding: 10px;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                font-size: 14px;
                font-weight: 500;
                height: 100%;
                width: 95%;
            }

            .search-btn:hover {
                background: #1567c1;
            }
            .table-container {
                background: #fff;
                border: 1px solid #d6e0ef;
                border-radius: 8px;
                margin-bottom: 20px;
            }
            .table-header {
                padding: 15px;
                border-bottom: 1px solid #d6e0ef;
            }
            .table-title {
                font-size: 1.3rem;
                color: #222e45;
            }
            table {
                width: 100%;
                border-collapse: collapse;
            }
            table th, table td {
                padding: 12px;
                text-align: left;
                border-bottom: 1px solid #eee;
            }
            table th {
                background: #e6f0fa;
                color: #214463;
            }
            .status-badge {
                padding: 6px 12px;
                border-radius: 20px;
                font-size: 0.8rem;
                font-weight: 600;
            }
            .status-active {
                background: #d4edda;
                color: #155724;
            }
            .status-inactive {
                background: #f8d7da;
                color: #721c24;
            }
            .action-btn {
                background: #3a8dde;
                color: #fff;
                padding: 8px 16px;
                border: none;
                border-radius: 4px;
                text-decoration: none;
            }
            .action-btn:hover {
                background: #1567c1;
            }
            .pagination-container {
                background: #fff;
                border: 1px solid #d6e0ef;
                border-radius: 8px;
                padding: 15px;
                display: flex;
                justify-content: space-between;
            }
            .pagination a, .pagination button {
                padding: 8px 12px;
                text-decoration: none;
                border: 2px solid #e1e5e9;
                color: #3a8dde;
                border-radius: 4px;
            }
            .pagination a:hover, .pagination button:hover {
                background: #e6f0fa;
            }
            .pagination .active {
                background: #3a8dde;
                color: #fff;
            }
            .empty-state {
                text-align: center;
                padding: 40px;
                color: #5a7da0;
            }
            @media (max-width: 900px) {
                .container {
                    flex-direction: column;
                }
                .sidebar {
                    width: 100%;
                }
                .filter-bar {
                    grid-template-columns: 1fr;
                }
            }
            .loading {
                display: inline-block;
                width: 20px;
                height: 20px;
                border: 3px solid #f3f3f3;
                border-top: 3px solid #3a8dde;
                border-radius: 50%;
                animation: spin 1s linear infinite;
            }
            @keyframes spin {
                0% {
                    transform: rotate(0deg);
                }
                100% {
                    transform: rotate(360deg);
                }
            }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="sidebar">
                <h2>Warehouse Manager</h2>
                <a href="usermanager" class="nav-item">Quản lý người dùng</a>
                <a href="role-permission" class="nav-item">Phân quyền người dùng</a>
                <a href="categoriesforward.jsp" class="nav-item">Thông tin vật tư</a>
                <a href="passwordrequest" class="nav-item">Reset mật khẩu</a>
                <a href="ApproveListForward.jsp" class="nav-item">Đơn từ</a>
                <a href="RequestForward.jsp" class="nav-item">Giao dịch</a>
                <a href="StatisticSupplierEvaluation.jsp" class="nav-item">Thống kê</a>
            </div>
            <div class="main-content">
                <div class="header">
                    <h1 class="header-title">Quản lý người dùng</h1>
                    <div class="header-user">
                        <span class="user-name"><%= user.getFullname()%></span>
                        <a href="logout" class="logout-btn">Đăng xuất</a>
                    </div>
                </div>
                <div class="dashboard-content">
                    <div class="page-header">
                        <div class="header-actions">
                            <a href="Admin.jsp" class="btn">Quay lại</a>
                            <a href="adduser" class="btn"> + Thêm người dùng</a>
                        </div>
                    </div>
                    <div class="filter-section">
                        <h3 class="filter-title">Tìm kiếm</h3>
                        <form action="usermanager" method="get">
                            <div class="filter-bar">
                                <div class="filter-group">
                                    <label class="filter-label">Vai trò</label>
                                    <select id="role" name="role">
                                        <option value="all" selected>Tất cả vai trò</option>
                                        <option value="2">Nhân viên kho</option>
                                        <option value="3">Nhân viên công ty</option>
                                        <option value="4">Giám đốc công ty</option>
                                    </select>
                                </div>
                                <div class="filter-group">
                                    <label class="filter-label">Trạng thái</label>
                                    <select name="status">
                                        <option value="">Tất cả trạng thái</option>
                                        <option value="active">Đang hoạt động</option>
                                        <option value="inactive">Không hoạt động</option>
                                    </select>
                                </div>
                                <div class="filter-group">
                                    <label class="filter-label">Phòng ban</label>
                                    <select name="departmentId">
                                        <option value="">Tất cả phòng ban</option>
                                        <c:forEach var="dept" items="${departments}">
                                            <option value="${dept.id}" <c:if test="${param.departmentId == dept.id}">selected</c:if>>
                                                ${dept.deptName}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <div class="filter-group">
                                    <label class="filter-label">Từ khóa</label>
                                    <input type="text" name="keyword" placeholder="Tìm theo tên đăng nhập, họ tên...">
                                </div>
                                <div class="filter-group">
                                    <button type="submit" class="search-btn">Tìm kiếm</button>
                                </div>
                            </div>
                            <input type="hidden" name="page" value="usermanager" />
                        </form>
                    </div>
                    <div class="table-container">

                        <c:choose>
                            <c:when test="${not empty userList}">
                                <table>
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Tên đăng nhập</th>
                                            <th>Họ và tên</th>
                                            <th>Phòng ban</th>
                                            <th>Vai trò</th>
                                            <th>Trạng thái</th>
                                            <th>Ngày tạo</th>
                                            <th>Thao tác</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="user" items="${userList}">
                                            <tr>
                                                <td><strong>#${user.id}</strong></td>
                                                <td><strong>${user.username}</strong></td>
                                                <td>${user.fullname}</td>
                                                <td>${user.deptName}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${user.roleName == 'Warehouse Staff'}">
                                                            Nhân viên kho
                                                        </c:when>
                                                        <c:when test="${user.roleName == 'Company Employee'}">
                                                            Nhân viên công ty
                                                        </c:when>
                                                        <c:when test="${user.roleName == 'Company Director'}">
                                                            Giám đốc công ty
                                                        </c:when>
                                                        <c:otherwise>
                                                            ${user.roleName}
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${user.activeFlag == 1}">
                                                            <span class="status-badge status-active">Hoạt động</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="status-badge status-inactive">Không hoạt động</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <fmt:formatDate value="${user.createDate}" pattern="dd/MM/yyyy" />
                                                </td>
                                                <td>
                                                    <a href="edituser?id=${user.id}" class="action-btn">Chỉnh sửa</a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state">
                                    <h3 class="empty-state-title">Không tìm thấy người dùng</h3>
                                    <p class="empty-state-text">Hãy thử điều chỉnh tiêu chí tìm kiếm hoặc thêm người dùng mới.</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <c:if test="${totalPages > 1}">
                        <center>
                        <div class="pagination">
                            <c:if test="${currentPage > 1}">
                                <a href="usermanager?page=${currentPage - 1}&role=${param.role}&status=${param.status}&departmentId=${param.departmentId}&keyword=${param.keyword}">Trước</a>
                            </c:if>
                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <c:choose>
                                    <c:when test="${i == currentPage}">
                                        <button class="active">${i}</button>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="usermanager?page=${i}&role=${param.role}&status=${param.status}&departmentId=${param.departmentId}&keyword=${param.keyword}">${i}</a>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>
                            <c:if test="${currentPage < totalPages}">
                                <a href="usermanager?page=${currentPage + 1}&role=${param.role}&status=${param.status}&departmentId=${param.departmentId}&keyword=${param.keyword}">Sau</a>
                            </c:if>
                        </div>
                        </center>
                    </c:if>
                </div>
            </div>
        </div>
    </body>
</html>