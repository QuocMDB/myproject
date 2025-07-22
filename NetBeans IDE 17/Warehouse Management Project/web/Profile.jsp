<%-- 
    Document   : profile
    Created on : 7 thg 6, 2025, 15:42:05
    Author     : phucn
--%>

<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="model.Users" %>
<%
    Users user = (Users) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <title>Thông tin cá nhân</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                background: #f6f6f8;
                padding: 30px;
            }

            .custom-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                background: #fff;
                border-radius: 0 0 7px 7px;
                padding: 20px 34px 16px 34px;
                box-shadow: 0 1px 5px rgba(0,0,0,0.07);
                margin-bottom: 28px;
            }
            .header-left {
                display: flex;
                align-items: center;
                gap: 32px;
            }
            .header-title {
                font-size: 1.8rem;
                color: #1567c1;
                margin: 0;
                display: flex;
                align-items: center;
            }
            .dashboard-title {
                font-size: 2.1rem;
                color: #206ed8;
                font-weight: 700;
            }
            .header-right {
                display: flex;
                align-items: center;
                gap: 20px;
            }
            .admin-name {
                font-size: 1.13rem;
                color: #1b466a;
                margin-right: 8px;
            }
            .logout-btn {
                background: #ff0202;
                color: #fff;
                border: none;
                padding: 8px 24px;
                border-radius: 7px;
                font-weight: 600;
                font-size: 1rem;
                text-decoration: none;
                transition: background 0.15s;
            }
            .logout-btn:hover {
                background: #c70000;
            }


            .profile-container {
                background: #fff;
                border-radius: 8px;
                max-width: 460px;
                margin: 36px auto;
                box-shadow: 0 2px 10px rgba(0,0,0,0.08);
                padding: 38px 34px 22px 34px;
            }
            h2 {
                text-align: center;
                margin-bottom: 24px;
            }
            table {
                width: 100%;
            }
            td {
                padding: 10px 6px;
                font-size: 1.06rem;
            }
            td.label {
                font-weight: bold;
                color: #3498db;
                width: 34%;
            }
            .edit-link, .pw-link {
                display: inline-block;
                margin: 22px 7px 0 0;
                text-decoration: none;
                color: #fff;
                background: #3498db;
                padding: 9px 22px;
                border-radius: 5px;
                font-weight: bold;
                transition: background 0.18s;
            }
            .pw-link {
                background: #e74c3c;
            }
            .edit-link:hover {
                background: #217dbb;
            }
            .logout-link:hover {
                background: #c0392b;
            }
            .btn-row {
                text-align: center;
                margin-top: 14px;
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
                <div class="custom-header">
                    <div class="header-left">
                        <h1 class="header-title">Thông tin cá nhân</h1>
                    </div>
                    <div class="header-right">
                        <span class="admin-name">${user.fullname}</span>
                        <a href="logout" class="logout-btn">Đăng xuất</a>
                    </div>
                </div>

                <div class="profile-container">
                    <h2>My Profile</h2>
                    <table>
                        <tr><td class="label">Username:</td><td>${user.username}</td></tr>
                        <tr><td class="label">Họ và tên:</td><td>${user.fullname}</td></tr>
                        <tr><td class="label">Email:</td><td>${user.email}</td></tr>
                        <tr><td class="label">SĐT:</td><td>${user.phone}</td></tr>
                        <tr><td class="label">Ngày sinh:</td><td>
                                <c:choose>
                                    <c:when test="${not empty user.dob}">${user.dob}</c:when>
                                    <c:otherwise>-</c:otherwise>
                                </c:choose>
                            </td></tr>
                        <tr><td class="label">Phòng ban:</td><td>${user.deptName != null ? user.deptName : 'Chưa có'}</td></tr>
                        <tr><td class="label">Chức vụ:</td><td>${user.roleName}</td></tr>
                        <tr><td class="label">Trạng thái:</td>
                            <td>
                                <c:choose>
                                    <c:when test="${user.activeFlag == 1}">Hoạt động</c:when>
                                    <c:otherwise>Không hoạt động</c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </table>
                    <div class="btn-row">
                        <a href="editprofile" class="edit-link">cập nhật thông tin</a>
                        <a href="forgot.jsp" class="pw-link">Yêu cầu đổi mật khẩu</a>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>