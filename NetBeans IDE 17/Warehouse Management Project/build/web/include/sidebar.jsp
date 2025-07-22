<%-- 
Document   : sidebar
Created on : [Date]
Author     : [Your name]
Description: Reusable sidebar compon<div class="sidebar">
    <h2>Warehouse Manager</h2>
    <a href="${pageContext.request.contextPath}/categoriesforward.jsp" class="nav-item">Thông tin vật tư</a>
    <a href="${pageContext.request.contextPath}/RequestForward.jsp" class="nav-item">Giao dịch</a>
    <a href="${pageContext.request.contextPath}/profile" class="nav-item">Thông tin cá nhân</a>
    <a href="${pageContext.request.contextPath}/Admin.jsp" class="nav-item">Trang chủ (Chỉ Admin)</a>
    <a href="${pageContext.request.contextPath}/inventory-statistics" class="nav-item">Thống kê kho hàng</a>
    <a href="${pageContext.request.contextPath}/StatisticSupplierEvaluation.jsp" class="nav-item">Thống kê nhà cung cấp</a>
</div>tracted from Dashboard.jsp
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="model.Users" session="true" %>

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
    .nav-item.active {
        background: #c2e9fb;
        color: #1567c1;
        font-weight: bold;
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

<div class="sidebar">
    <h2>Warehouse Manager</h2>
    <a href="${pageContext.request.contextPath}/categoriesforward.jsp" class="nav-item">Thông tin vật tư</a>
    <a href="${pageContext.request.contextPath}/RequestForward.jsp" class="nav-item">Giao dịch</a>
    <a href="${pageContext.request.contextPath}/profile" class="nav-item">Thông tin cá nhân</a>
    <a href="${pageContext.request.contextPath}/Admin.jsp" class="nav-item">Trang chủ (Chỉ Admin)</a>
    <a href="${pageContext.request.contextPath}/StatisticSupplierEvaluation.jsp" class="nav-item">Thống kê</a>
</div>