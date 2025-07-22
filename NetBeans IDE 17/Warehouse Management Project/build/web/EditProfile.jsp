<%-- 
    Document   : EditProfile
    Created on : 7 thg 6, 2025, 16:56:05
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
    <title>Chỉnh sửa thông tin cá nhân</title>
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
        form {
            width: 100%;
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
        input, select {
            width: 98%;
            padding: 8px 10px;
            border-radius: 5px;
            border: 1px solid #d4d8e2;
            font-size: 1rem;
            background: #f8fafd;
        }
        .btn-row {
            text-align: center;
            margin-top: 14px;
        }
        .save-btn {
            display: inline-block;
            background: #3498db;
            color: #fff;
            padding: 10px 34px;
            border-radius: 5px;
            font-weight: bold;
            border: none;
            font-size: 1rem;
            margin-top: 10px;
            cursor: pointer;
            transition: background 0.18s;
        }
        .save-btn:hover {
            background: #217dbb;
        }
        .cancel-link {
            display: inline-block;
            margin-left: 12px;
            background: #e7e7e7;
            color: #555;
            padding: 10px 20px;
            border-radius: 5px;
            font-weight: bold;
            text-decoration: none;
            font-size: 1rem;
            transition: background 0.18s;
        }
        .cancel-link:hover {
            background: #d3d3d3;
            color: #222;
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
        .form-error {
            color: #e74c3c;
            text-align: center;
            margin-bottom: 8px;
            font-size: 1rem;
        }
        .success-message {
            color: #27ae60;
            text-align: center;
            margin-bottom: 8px;
            font-size: 1rem;
        }
    </style>
</head>
<body>
    <div class="layout-container">
        <jsp:include page="/include/sidebar.jsp" />
        <div class="main-content">
            <div class="custom-header">
                <div class="header-left">
                    <h1 class="header-title">Chỉnh sửa thông tin cá nhân</h1>
                </div>
                <div class="header-right">
                    <span class="admin-name">${user.fullname}</span>
                    <a href="logout" class="logout-btn">Đăng xuất</a>
                </div>
            </div>
            <div class="profile-container">
                <h2>Edit Profile</h2>
                <c:if test="${not empty error}">
                    <div class="form-error">${error}</div>
                </c:if>
                <c:if test="${not empty success}">
                    <div class="success-message">${success}</div>
                </c:if>
                <form action="editprofile" method="post">
                    <table>
                        <tr>
                            <td class="label">Username:</td>
                            <td><input type="text" name="username" value="${user.username}" readonly /></td>
                        </tr>
                        <tr>
                            <td class="label">Họ và tên:</td>
                            <td><input type="text" name="fullname" value="${user.fullname}" required /></td>
                        </tr>
                        <tr>
                            <td class="label">Email:</td>
                            <td><input type="email" name="email" value="${user.email}" required 
                                pattern="^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"
                                title="Email phải đúng định dạng: example@domain.com"
                            /></td>
                        </tr>
                        <tr>
                            <td class="label">SĐT:</td>
                            <td><input type="text" name="phone" value="${user.phone}" 
                                pattern="^[0-9]{9,12}$" title="Số điện thoại không hợp lệ" /></td>
                        </tr>
                        <tr>
                            <td class="label">Ngày sinh:</td>
                            <td><input type="date" name="dob" value="${user.dob}" required /></td>
                        </tr>
                    </table>
                    <div class="btn-row">
                        <button type="submit" class="save-btn">Lưu thay đổi</button>
                        <a href="profile" class="cancel-link">Huỷ</a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</body>
</html>

