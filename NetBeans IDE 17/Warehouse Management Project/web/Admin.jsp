<%-- 
    Document   : Dashboard
    Created on : May 19, 2025, 9:38:23 PM
    Author     : phucn
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="model.Users" session="true" %> 
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

<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Admin Dashboard - Warehouse Manager</title>
        <style>
            body {
                font-family: 'Segoe UI', 'Roboto', 'Helvetica Neue', Arial, sans-serif;
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
            .notification {
                color: #5a7da0;
                font-size: 1.1rem;
            }
            @media (max-width: 900px) {
                .container {
                    flex-direction: column;
                }
                .sidebar {
                    width: 100%;
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
                    <h1 class="header-title">Admin Dashboard</h1>
                    <div class="header-user">
                        <span class="user-name"><%= user.getFullname()%></span>
                        <a href="logout" class="logout-btn">Đăng xuất</a>
                    </div>
                </div>
                <div class="dashboard-content">
                    <h2 class="page-title">Admin Dashboard</h2>
                    <p class="notification">Trang admin đã sẵn sàng hoạt động</p>
                </div>
            </div>
        </div>
    </body>
</html>