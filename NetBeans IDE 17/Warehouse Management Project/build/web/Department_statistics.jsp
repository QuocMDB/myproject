<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>
<%@page import="model.Users"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDate"%>
<%
    Users user = (Users) session.getAttribute("user");
    if (user == null || !"Admin".equals(user.getRoleName()) && !"Nhân viên kho".equals(user.getRoleName())) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Date formatter for LocalDateTime
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
    request.setAttribute("dateFormatter", formatter);
%>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Thống kê phòng ban</title>
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
            }

            .layout-container {
                display: flex;
                min-height: 100vh;
            }

            .main-content {
                flex: 1;
                padding: 20px;
            }

            .header {
                background: white;
                padding: 20px;
                margin-bottom: 20px;
                border-radius: 5px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .page-title {
                color: #333;
                font-size: 24px;
            }

            .header-user {
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .logout-btn {
                background: red;
                color: white;
                padding: 8px 16px;
                border-radius: 4px;
                text-decoration: none;
                font-size: 14px;
            }

            .nav-buttons {
                margin-bottom: 20px;
            }

            .btn {
                padding: 10px 20px;
                border-radius: 4px;
                text-decoration: none;
                margin-right: 10px;
                display: inline-block;
                border: none;
                cursor: pointer;
                font-size: 14px;
            }

            .btn-info {
                background: #17a2b8;
                color: white;
            }

            .btn-excel {
                background: #107c41;
                color: white;
                float: right;
            }

            /* Stats Cards */
            .stats-container {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
                gap: 20px;
                margin-bottom: 30px;
            }

            .stat-card {
                background: white;
                padding: 30px;
                border-radius: 10px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
                text-align: center;
                transition: transform 0.2s;
            }

            .stat-card:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 8px rgba(0,0,0,0.15);
            }

            .stat-card h3 {
                font-size: 14px;
                color: #666;
                margin-bottom: 15px;
                font-weight: normal;
            }

            .stat-card .value {
                font-size: 48px;
                font-weight: bold;
                margin-bottom: 10px;
            }

            .stat-card .sub-text {
                font-size: 12px;
                color: #999;
            }

            .stat-card.primary {
                border-top: 4px solid #007bff;
            }
            .stat-card.primary .value {
                color: #007bff;
            }
            .stat-card.success {
                border-top: 4px solid #28a745;
            }
            .stat-card.success .value {
                color: #28a745;
            }
            .stat-card.warning {
                border-top: 4px solid #ffc107;
            }
            .stat-card.warning .value {
                color: #ffc107;
            }
            .stat-card.danger {
                border-top: 4px solid #dc3545;
            }
            .stat-card.danger .value {
                color: #dc3545;
            }

            /* Date info */
            .date-info {
                text-align: right;
                font-size: 12px;
                color: #666;
                margin-bottom: 10px;
            }

            /* Top departments table */
            .table-container {
                background: white;
                padding: 20px;
                border-radius: 10px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
                margin-bottom: 20px;
            }

            .table-container h3 {
                margin-bottom: 20px;
                color: #333;
                font-size: 18px;
            }

            .table-note {
                font-size: 12px;
                color: #666;
                font-style: italic;
                margin-bottom: 15px;
            }

            table {
                width: 100%;
                border-collapse: collapse;
            }

            th, td {
                padding: 12px 15px;
                text-align: left;
                border-bottom: 1px solid #eee;
            }

            th {
                font-weight: bold;
                color: #555;
                font-size: 14px;
                background: #f8f9fa;
            }

            td {
                font-size: 14px;
            }

            tr:hover {
                background: #f8f9fa;
            }

            /* Ranking column */
            .ranking {
                font-weight: bold;
                color: #666;
                text-align: center;
                width: 60px;
            }

            .ranking.top1 {
                color: #FFD700;
                font-size: 20px;
            }

            .ranking.top2 {
                color: #C0C0C0;
                font-size: 18px;
            }

            .ranking.top3 {
                color: #CD7F32;
                font-size: 18px;
            }

            .dept-badge {
                display: inline-block;
                padding: 4px 8px;
                background: #e9ecef;
                color: #495057;
                border-radius: 3px;
                font-size: 12px;
                margin-left: 8px;
            }

            .no-manager {
                color: #dc3545;
            }

            /* Employee count bar */
            .employee-bar {
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .bar-container {
                flex: 1;
                height: 20px;
                background: #e9ecef;
                border-radius: 10px;
                overflow: hidden;
                max-width: 200px;
            }

            .bar-fill {
                height: 100%;
                background: linear-gradient(90deg, #28a745, #20c997);
                transition: width 0.3s ease;
            }

            /* Recent activities */
            .recent-container {
                background: white;
                padding: 20px;
                border-radius: 10px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
                margin-bottom: 20px;
            }

            .recent-container h3 {
                margin-bottom: 20px;
                color: #333;
                font-size: 18px;
            }

            .recent-list {
                list-style: none;
            }

            .recent-item {
                padding: 15px 0;
                border-bottom: 1px solid #eee;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .recent-item:last-child {
                border-bottom: none;
            }

            .recent-date {
                font-size: 12px;
                color: #999;
            }
            
            .activity-badge {
                display: inline-block;
                padding: 3px 10px;
                border-radius: 12px;
                font-size: 11px;
                margin-left: 10px;
            }
            
            .activity-badge.create {
                background: #d4edda;
                color: #155724;
            }
            
            .activity-badge.update {
                background: #cce5ff;
                color: #004085;
            }

            /* Tooltip */
            .info-icon {
                display: inline-block;
                width: 16px;
                height: 16px;
                background: #6c757d;
                color: white;
                border-radius: 50%;
                text-align: center;
                line-height: 16px;
                font-size: 10px;
                margin-left: 5px;
                cursor: help;
            }
        </style>
    </head>
    <body>
        <div class="layout-container">
            <jsp:include page="/include/sidebar.jsp" />
            <div class="main-content">
                <!-- Header -->
                <div class="header">
                    <h1 class="page-title">Thống kê phòng ban</h1>
                    <div class="header-user">
                        <span><%= user.getFullname()%></span>
                        <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Đăng xuất</a>
                    </div>
                </div>

                <!-- Navigation -->
                <div class="nav-buttons">
                    <a href="${pageContext.request.contextPath}/department/list" class="btn btn-info">← Quay lại</a>
                </div>

                <!-- Date info -->
                <div class="date-info">
                    Cập nhật: <%= new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(new java.util.Date()) %>
                </div>

                <!-- Stats Cards -->
                <div class="stats-container">
                    <div class="stat-card primary">
                        <h3>Tổng số phòng ban</h3>
                        <div class="value">
                            <c:choose>
                                <c:when test="${not empty overview.totalDepartments}">${overview.totalDepartments}</c:when>
                                <c:otherwise>0</c:otherwise>
                            </c:choose>
                        </div>
                        <div class="sub-text">
                            Tất cả phòng ban trong hệ thống
                        </div>
                    </div>
                    <div class="stat-card success">
                        <h3>Phòng ban hoạt động</h3>
                        <div class="value">
                            <c:choose>
                                <c:when test="${not empty overview.activeDepartments}">${overview.activeDepartments}</c:when>
                                <c:otherwise>0</c:otherwise>
                            </c:choose>
                        </div>
                        <div class="sub-text">
                            <c:if test="${not empty overview.activePercentage}">
                                <fmt:formatNumber value="${overview.activePercentage}" maxFractionDigits="0"/>% tổng phòng ban
                            </c:if>
                        </div>
                    </div>
                    <div class="stat-card warning">
                        <h3>Chưa có trưởng phòng</h3>
                        <div class="value">
                            <c:choose>
                                <c:when test="${not empty overview.departmentsWithoutManager}">${overview.departmentsWithoutManager}</c:when>
                                <c:otherwise>0</c:otherwise>
                            </c:choose>
                        </div>
                        <div class="sub-text">
                            Cần phân công quản lý
                        </div>
                    </div>
                </div>

                <!-- Top Departments by Employee Count -->
                <div class="table-container">
                    <h3>Phòng ban có nhiều nhân viên nhất</h3>
                    <button class="btn btn-excel" onclick="window.location.href='${pageContext.request.contextPath}/department/statistics/export'">📊 Xuất Excel</button>
                    
                    <table>
                        <thead>
                            <tr>
                                <th style="text-align: center;">Hạng</th>
                                <th>Phòng ban</th>
                                <th>Trưởng phòng</th>
                                <th>Số nhân viên</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:set var="maxEmployees" value="${topDepartments[0].employeeCount}" />
                            <c:forEach var="dept" items="${topDepartments}" varStatus="status">
                                <tr>
                                    <td class="ranking ${status.index == 0 ? 'top1' : (status.index == 1 ? 'top2' : (status.index == 2 ? 'top3' : ''))}">
                                        <c:choose>
                                            <c:when test="${status.index == 0}">1</c:when>
                                            <c:when test="${status.index == 1}">2</c:when>
                                            <c:when test="${status.index == 2}">3</c:when>
                                            <c:otherwise>${status.index + 1}</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <strong>${dept.deptName}</strong>
                                        <span class="dept-badge">${dept.deptCode}</span>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty dept.managerName}">
                                                ${dept.managerName}
                                            </c:when>
                                            <c:otherwise>
                                                <span class="no-manager">Chưa có</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div class="employee-bar">
                                            <strong>${dept.employeeCount}</strong> người
                                            <c:if test="${dept.activeEmployeeCount > 0}">
                                            </c:if>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty topDepartments}">
                                <tr>
                                    <td colspan="4" style="text-align: center; color: #999;">
                                        Không có dữ liệu
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>

                <!-- Recent Activities -->
                <div class="recent-container">
                    <h3>Hoạt động gần đây</h3>
                    <ul class="recent-list">
                        <c:forEach items="${recentActivities}" var="activity">
                            <li class="recent-item">
                                <div>
                                    <strong>${activity.deptName}</strong>
                                    <span class="dept-badge">${activity.deptCode}</span>
                                    <span class="activity-badge ${activity.activityType}">
                                        <c:choose>
                                            <c:when test="${activity.activityType == 'create'}">
                                                Tạo mới
                                            </c:when>
                                            <c:otherwise>
                                                Cập nhật
                                            </c:otherwise>
                                        </c:choose>
                                    </span>
                                    <c:if test="${not empty activity.updatedBy}">
                                        <span style="font-size: 12px; color: #666;">
                                            bởi ${activity.updatedBy}
                                        </span>
                                    </c:if>
                                </div>
                                <div class="recent-date">
                                    ${activity.updateDate}
                                </div>
                            </li>
                        </c:forEach>
                        <c:if test="${empty recentActivities}">
                            <li class="recent-item">
                                <span style="color: #999;">Chưa có hoạt động nào gần đây</span>
                            </li>
                        </c:if>
                    </ul>
                </div>

            </div>
        </div>
    </body>
</html>