<%-- 
    Document   : EditUser
    Created on : 23 thg 5, 2025, 16:24:57
    Author     : phucn
--%>

<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@page import="model.Users"%>

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
        <title>Sửa đổi thông tin người dùng</title>
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
                max-width: 900px;
                margin: auto;
                background: white;
                padding: 5px 32px 15px 32px;
                border-radius: 8px;
                box-shadow: 0 6px 32px rgba(21,103,193,0.07), 0 1.5px 8px rgba(35,58,88,0.09);
            }
            .form-simple {
                max-width: 700px;
                margin: 40px auto;
                background: #fff;
                border-radius: 14px;
                box-shadow: 0 6px 32px rgba(21,103,193,0.10);
                padding: 30px 32px 18px 32px;
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 18px 26px;
            }
            .form-simple-title {
                grid-column: 1 / -1;
                font-size: 1.32rem;
                color: #1567c1;
                text-align: center;
                font-weight: 700;
                margin-bottom: 12px;
            }
            .form-simple-label {
                margin-bottom: 6px;
                font-weight: 500;
                color: #2d3c54;
            }
            .form-simple-input, .form-simple-select {
                width: 100%;
                padding: 10px 12px;
                border-radius: 6px;
                border: 1.1px solid #d3d9e7;
                background: #f8fafc;
                font-size: 1rem;
                outline: none;
                transition: border .16s;
            }
            .form-simple-input:focus, .form-simple-select:focus {
                border: 1.5px solid #2196f3;
                background: #fff;
            }
            .btn-submit {
                margin-top: 28px;
                width: 100%;
                padding: 10px;
                background-color: #3498db;
                border: none;
                border-radius: 5px;
                color: white;
                font-size: 1.18rem;
                cursor: pointer;
                font-weight: bold;
                grid-column: 1 / -1;
            }
            .btn-submit:hover {
                background-color: #2980b9;
            }
            .back-link {
                display: block;
                margin-top: 0;
                margin-bottom: 6px;
                text-align: center;
                color: #3498db;
                text-decoration: none;
                font-size: 1.04rem;
            }
            .back-link:hover {
                text-decoration: underline;
            }

            .success-message {
                color: #09a548;
                font-size: 1.08rem;
                margin-bottom: 13px;
                text-align: center;
                font-weight: 500;
            }
            .error-message {
                color: #e74c3c;
                font-size: 1.08rem;
                margin-bottom: 13px;
                text-align: center;
                font-weight: 500;
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
                    <h1 class="header-title">Admin Dashboard</h1>
                    <div class="header-user">
                        <span class="user-name"><%= user.getFullname()%></span>
                        <a href="logout" class="logout-btn">Đăng xuất</a>
                    </div>
                </div>


                <div class="form-container">
                    <div class="form-simple-title">Sửa đổi thông tin người dùng</div>
                    <c:if test="${not empty error}">
                        <div class="error-message">${error}</div>
                    </c:if>
                    <c:if test="${not empty message}">
                        <div class="success-message">${message}</div>
                        <c:remove var="message" scope="session"/>
                    </c:if>

                    <form action="edituser" method="post" class="form-simple">
                        <input type="hidden" name="id" value="${editUser.id}"/>
                        <div>
                            <label class="form-simple-label" for="username">Username:</label>
                            <input type="text" id="username" name="username" class="form-simple-input" value="${editUser.username}" required>
                        </div>
                        <div>
                            <label class="form-simple-label" for="password">Mật khẩu:</label>
                            <input type="password" id="password" name="password" 
                                   class="form-simple-input" 
                                   pattern="^[a-zA-Z0-9]{7,}$" 
                                   placeholder="Để trống nếu không đổi mật khẩu">
                        </div>
                        <div>
                            <label class="form-simple-label" for="fullname">Họ và Tên:</label>
                            <input type="text" id="fullname" name="fullname" class="form-simple-input" value="${editUser.fullname}" required>
                        </div>
                        <div>
                            <label class="form-simple-label" for="email">Email:</label>
                            <input type="email" id="email" name="email" class="form-simple-input" value="${editUser.email}" required
                                   pattern="^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"
                                   title="Email phải đúng định dạng: example@domain.com">
                        </div>
                        <div>
                            <label class="form-simple-label" for="phone">SĐT:</label>
                            <input type="text" id="phone" name="phone" class="form-simple-input" value="${editUser.phone}" required
                                   pattern="^[0]+[0-9]{8,11}$"
                                   title="Số điện thoại không hợp lệ">
                        </div>
                        <div>
                            <label class="form-simple-label" for="dob">Ngày sinh:</label>
                            <input type="date" id="dob" name="dob" class="form-simple-input" value="${editUser.dob}" required>
                        </div>
                        <div>
                            <label class="form-simple-label" for="departmentId">Phòng ban:</label>
                            <select id="departmentId" name="departmentId" class="form-simple-select" required>
                                <c:forEach var="dept" items="${departments}">
                                    <option value="${dept.id}" 
                                            <c:if test="${editUser.departmentId == dept.id}">selected</c:if>>
                                        ${dept.deptName}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div>
                            <label class="form-simple-label" for="role">Vai trò:</label>
                            <select id="role" name="role" class="form-simple-select" required>
                                <option value="2" <c:if test="${editUser.roleName eq 'Nhân viên kho'}">selected</c:if>>Nhân viên kho</option>
                                <option value="3" <c:if test="${editUser.roleName eq 'Nhân viên công ty'}">selected</c:if>>Nhân viên công ty</option>
                                <option value="4" <c:if test="${editUser.roleName eq 'Giám đốc'}">selected</c:if>>Giám đốc</option>
                                </select>
                            </div>
                            <div>
                                <label class="form-simple-label" for="activeFlag">Trạng thái:</label>
                                <select id="activeFlag" name="activeFlag" class="form-simple-select" required>
                                    <option value="1" <c:if test="${editUser.activeFlag == 1}">selected</c:if>>Hoạt động</option>
                                <option value="0" <c:if test="${editUser.activeFlag == 0}">selected</c:if>>Không hoạt động</option>
                            </select>
                        </div>
                        <button type="submit" class="btn-submit">Cập nhật thông tin</button>
                    </form>
                    <a href="usermanager" class="back-link">Quay lại danh sách người dùng</a>
                </div>
            </div>
        </div>

    </body>
</html>
