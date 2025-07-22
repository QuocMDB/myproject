<%-- 
    Document   : AddUser
    Created on : 22 thg 5, 2025, 22:38:49
    Author     : phucn
--%>

<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@page import="model.Users"%>
<%@page import="model.Department"%>

<!DOCTYPE html>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1
    response.setHeader("Pragma", "no-cache"); // HTTP 1.0
    response.setDateHeader("Expires", 0); // Proxies
%>

<%
    Users user = (Users) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<html>
    <head>
        <title>Thêm người dùng mới</title>
        <style>
            body {
                font-family: 'Segoe UI', 'Roboto', 'Helvetica Neue', Arial, sans-serif;
                background-color: #f4f4f9;
                padding: 0;
                margin: 0;
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
                padding: 20px;
                flex: 1;
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
            .form-container {
                max-width: 600px;
                margin: auto;
                background: white;
                padding: 5px 32px 15px 32px;
                border: 1px solid #d6e0ef;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.10);
            }
            h2 {
                text-align: center;
                margin-bottom: 30px;
                font-size: 2rem;
            }
            table {
                width: 100%;
                border-collapse: separate;
                border-spacing: 0 10px;
            }
            td.label {
                width: 32%;
                font-weight: bold;
                text-align: right;
                padding-right: 16px;
                vertical-align: middle;
            }
            td.input {
                width: 68%;
            }
            input[type="text"], input[type="password"], input[type="email"], input[type="date"], select {
                width: 100%;
                padding: 10px 12px;
                border-radius: 4px;
                border: 1px solid #ccc;
                font-size: 1rem;
                box-sizing: border-box;
            }
            .row-flex {
                display: flex;
                gap: 18px;
            }
            .row-flex > div {
                flex: 1;
            }
            .btn-submit {
                margin-top: 28px;
                width: 100%;
                padding: 14px;
                background-color: #3498db;
                border: none;
                border-radius: 5px;
                color: white;
                font-size: 1.18rem;
                cursor: pointer;
                font-weight: bold;
            }
            .btn-submit:hover {
                background-color: #2980b9;
            }
            .back-link {
                display: block;
                margin-top: 17px;
                text-align: center;
                color: #3498db;
                text-decoration: none;
                font-size: 1.04rem;
            }
            .back-link:hover {
                text-decoration: underline;
            }
            .success-message {
                color: green;
                margin-bottom: 15px;
                text-align: center;
            }
            .error-message {
                color: red;
                margin-bottom: 15px;
                text-align: center;
            }
            .success-message {
                color: green;
                margin-bottom: 15px;
                text-align: center;
            }
            .error-message {
                color: red;
                margin-bottom: 15px;
                text-align: center;
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
                <div class="form-container">
                    <h2>Thêm người dùng</h2>
                    <c:if test="${not empty error}">
                        <div class="error-message">${error}</div>
                    </c:if>
                    <c:if test="${not empty message}">
                        <div class="success-message">${message}</div>
                        <c:remove var="message" scope="session"/>
                    </c:if>

                    <form action="adduser" method="post">
                        <table>
                            <tr>
                                <td class="label"><label for="username">Username:</label></td>
                                <td class="input"><input type="text" id="username" name="username" required></td>
                            </tr>
                            <tr>
                                <td class="label"><label for="password">Mật khẩu:</label></td>
                                <td class="input"><input type="password" id="password" name="password" required
                                                         title="Nhập mật khẩu"
                                                         pattern="^[a-zA-Z0-9]{7,}$"
                                                         title="Mật khẩu không hợp lệ">
                                </td>
                            </tr>
                            <tr>
                                <td class="label"><label for="fullname">Họ và Tên:</label></td>
                                <td class="input"><input type="text" id="fullname" name="fullname" required
                                                         title="Nhập Họ và Tên"></td>
                            </tr>
                            <tr>
                                <td class="label"><label for="email">Email:</label></td>
                                <td class="input"><input type="email" id="email" name="email" required
                                                         title="Nhập Email"
                                                         pattern="^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"
                                                         title="Email phải đúng định dạng: example@domain.com">
                                </td>
                            </tr>
                            <tr>
                                <td class="label"><label for="phone">SĐT:</label></td>
                                <td class="input"><input type="text" id="phone" name="phone"
                                                         required title="Nhập số điện thoại" 
                                                         pattern="^[0]+[0-9]{8,11}$"
                                                         title="Số điện thoại không hợp lệ">
                                </td>
                            </tr>
                            <tr>
                                <td class="label"><label for="dob">Sinh nhật:</label></td>
                                <td class="input"><input type="date" id="dob" name="dob" required title="Điền ngày sinh"></td>
                            </tr>
                            <tr>
                                <td class="label"><label for="department">Phòng ban:</label></td>
                                <td class="input">
                                    <div class="row-flex">
                                        <select name="departmentId">
                                            <option value="">-- Chọn phòng ban --</option>
                                            <c:forEach var="dept" items="${departments}">
                                                <option value="${dept.id}">
                                                    ${dept.deptCode} - ${dept.deptName}
                                                </option>
                                            </c:forEach>
                                        </select>


                                    </div>
                            </tr>
                            <tr>
                                <td class="label"><label for="role">Chức vụ:</label></td>
                                <td class="input">
                                    <div class="row-flex">
                                        <div>
                                            <select id="role" name="role" required title="Chọn chức vụ">
                                                <option value="">-- Chọn chức vụ --</option>
                                                <option value="2">Nhân viên kho</option>
                                                <option value="3">Nhân viên công ty</option>
                                                <option value="4">Giám đốc</option>
                                            </select>
                                        </div>
                                        <div>
                                            <select id="activeFlag" name="activeFlag" required title="Chọn trạng thái">
                                                <option value="1" selected>Hoạt động</option>
                                                <option value="0">Không hoạt động</option>
                                            </select>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                        </table>
                        <button type="submit" class="btn-submit">Thêm</button>
                    </form>
                    <a href="usermanager" class="back-link">Quay lại danh sách người dùng</a>
                </div>

            </div>

    </body>
</html>