<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>

<%@page import="model.Users"%>
<%
    Users user = (Users) session.getAttribute("user");
    if (user == null || (!"Admin".equals(user.getRoleName()) && !"Nhân viên kho".equals(user.getRoleName()))) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết phòng ban - ${department.deptName}</title>
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
            border: none;
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

        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .detail-header {
            text-align: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid #eee;
        }

        .detail-header h2 {
            color: #333;
            font-size: 1.8rem;
            margin-bottom: 10px;
        }

        .status-badge {
            display: inline-block;
            padding: 5px 15px;
            border-radius: 15px;
            font-size: 14px;
            font-weight: bold;
        }

        .status-active {
            background: #28a745;
            color: white;
        }

        .status-inactive {
            background: #6c757d;
            color: white;
        }

        .nav-buttons {
            display: flex;
            gap: 15px;
            margin-bottom: 25px;
        }

        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            font-size: 14px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s;
        }

        .btn-info {
            background: #17a2b8;
            color: white;
        }

        .btn-warning {
            background: #ffc107;
            color: #212529;
        }

        .btn-primary {
            background: #007bff;
            color: white;
        }

        .btn:hover {
            opacity: 0.9;
            transform: translateY(-1px);
        }

        .detail-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
            margin-bottom: 30px;
        }

        .detail-section {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            border-left: 4px solid #007bff;
        }

        .detail-section h3 {
            color: #333;
            margin-bottom: 15px;
            font-size: 1.3rem;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .detail-item {
            margin-bottom: 12px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .detail-label {
            font-weight: bold;
            color: #555;
            min-width: 120px;
        }

        .detail-value {
            color: #333;
            flex: 1;
            text-align: right;
        }

        .full-width {
            grid-column: 1 / -1;
        }

        .employee-section {
            margin-top: 30px;
        }

        .employee-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }

        .employee-table th,
        .employee-table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }

        .employee-table th {
            background: #f8f9fa;
            font-weight: bold;
            color: #555;
        }

        .employee-table tbody tr:hover {
            background: #f5f5f5;
        }

        .employee-status {
            padding: 3px 8px;
            border-radius: 10px;
            font-size: 12px;
            font-weight: bold;
        }

        .employee-active {
            background: #d4edda;
            color: #155724;
        }

        .employee-inactive {
            background: #f8d7da;
            color: #721c24;
        }

        .empty-state {
            text-align: center;
            padding: 40px;
            color: #666;
        }

        .manager-info {
            background: #e8f5e8;
            padding: 15px;
            border-radius: 5px;
            border-left: 4px solid #28a745;
        }

        .contact-info {
            background: #e3f2fd;
            padding: 15px;
            border-radius: 5px;
            border-left: 4px solid #2196f3;
        }

        .audit-info {
            background: #fff3cd;
            padding: 15px;
            border-radius: 5px;
            border-left: 4px solid #ffc107;
            font-size: 14px;
            color: #856404;
        }

        .description-box {
            background: white;
            padding: 15px;
            border-radius: 5px;
            border: 1px solid #ddd;
            min-height: 80px;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            text-align: center;
        }

        .stat-number {
            font-size: 2rem;
            font-weight: bold;
            color: #007bff;
        }

        .stat-label {
            color: #666;
            margin-top: 5px;
        }

        @media (max-width: 768px) {
            .container {
                margin: 10px;
                padding: 20px;
            }

            .detail-grid {
                grid-template-columns: 1fr;
            }

            .nav-buttons {
                flex-direction: column;
            }

            .stats-grid {
                grid-template-columns: 1fr;
            }

            .employee-table {
                font-size: 12px;
            }

            .employee-table th,
            .employee-table td {
                padding: 8px;
            }
        }
    </style>
</head>
<body>
    <div class="layout-container">
        <jsp:include page="/include/sidebar.jsp" />
        <div class="main-content">
            <div class="header">
                <h1 class="page-title">Chi tiết phòng ban</h1>
                <div class="header-user">
                    <label class="label">Xin chào, <%= user.getFullname()%></label>
                    <a href="${pageContext.request.contextPath}/login.jsp" class="logout-btn">Đăng xuất</a>
                </div>
            </div>

            <div class="container">
                <div class="detail-header">
                    <h2>📁 ${department.deptName}</h2>
                    <p>Mã phòng ban: <strong>${department.deptCode}</strong></p>
                    <span class="status-badge ${department.activeFlag ? 'status-active' : 'status-inactive'}">
                        ${department.activeFlag ? 'Đang hoạt động' : 'Không hoạt động'}
                    </span>
                </div>

                <!-- Navigation Buttons -->
                <div class="nav-buttons">
                    <a href="${pageContext.request.contextPath}/department/list" class="btn btn-info">← Quay lại danh sách</a>
                    <a href="${pageContext.request.contextPath}/department/edit?id=${department.id}" class="btn btn-warning">✏️ Chỉnh sửa</a>
                </div>

                <!-- Statistics Cards -->
                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-number">${department.employeeCount}</div>
                        <div class="stat-label">Nhân viên</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-number">${department.managerId != null ? '1' : '0'}</div>
                        <div class="stat-label">Trưởng phòng</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-number">
                            <fmt:formatDate value="${department.createDate}" pattern="dd/MM/yyyy"/>
                        </div>
                        <div class="stat-label">Ngày thành lập</div>
                    </div>
                </div>

                <!-- Detail Information -->
                <div class="detail-grid">
                    <!-- Basic Information -->
                    <div class="detail-section">
                        <h3>📋 Thông tin cơ bản</h3>
                        <div class="detail-item">
                            <span class="detail-label">ID:</span>
                            <span class="detail-value">#${department.id}</span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label">Mã phòng ban:</span>
                            <span class="detail-value">${department.deptCode}</span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label">Tên phòng ban:</span>
                            <span class="detail-value">${department.deptName}</span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label">Trạng thái:</span>
                            <span class="detail-value">
                                <span class="status-badge ${department.activeFlag ? 'status-active' : 'status-inactive'}">
                                    ${department.activeFlag ? 'Hoạt động' : 'Không hoạt động'}
                                </span>
                            </span>
                        </div>
                    </div>

                    <!-- Manager Information -->
                    <div class="detail-section">
                        <h3>👤 Thông tin trưởng phòng</h3>
                        <c:choose>
                            <c:when test="${not empty department.managerName}">
                                <div class="manager-info">
                                    <div class="detail-item">
                                        <span class="detail-label">Họ tên:</span>
                                        <span class="detail-value">${department.managerName}</span>
                                    </div>
                                    <c:if test="${not empty department.managerEmail}">
                                        <div class="detail-item">
                                            <span class="detail-label">Email:</span>
                                            <span class="detail-value">${department.managerEmail}</span>
                                        </div>
                                    </c:if>
                                    <c:if test="${not empty department.managerPhone}">
                                        <div class="detail-item">
                                            <span class="detail-label">Điện thoại:</span>
                                            <span class="detail-value">${department.managerPhone}</span>
                                        </div>
                                    </c:if>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state">
                                    <p>🚫 Chưa có trưởng phòng</p>
                                    <a href="${pageContext.request.contextPath}/department/edit?id=${department.id}" class="btn btn-primary">
                                        Gán trưởng phòng
                                    </a>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- Contact Information -->
                    <div class="detail-section">
                        <h3>📞 Thông tin liên hệ</h3>
                        <c:choose>
                            <c:when test="${not empty department.phone || not empty department.email}">
                                <div class="contact-info">
                                    <c:if test="${not empty department.phone}">
                                        <div class="detail-item">
                                            <span class="detail-label">Điện thoại:</span>
                                            <span class="detail-value">
                                                <a href="tel:${department.phone}">${department.phone}</a>
                                            </span>
                                        </div>
                                    </c:if>
                                    <c:if test="${not empty department.email}">
                                        <div class="detail-item">
                                            <span class="detail-label">Email:</span>
                                            <span class="detail-value">
                                                <a href="mailto:${department.email}">${department.email}</a>
                                            </span>
                                        </div>
                                    </c:if>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state">
                                    <p>📵 Chưa có thông tin liên hệ</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- Audit Information -->
                    <div class="detail-section">
                        <h3>📋 Thông tin kiểm toán</h3>
                        <div class="audit-info">
                            <div class="detail-item">
                                <span class="detail-label">Tạo bởi:</span>
                                <span class="detail-value">${department.createdByName}</span>
                            </div>
                            <div class="detail-item">
                                <span class="detail-label">Ngày tạo:</span>
                                <span class="detail-value">
                                    <fmt:formatDate value="${department.createDate}" pattern="dd/MM/yyyy HH:mm:ss"/>
                                </span>
                            </div>
                            <c:if test="${not empty department.updatedByName}">
                                <div class="detail-item">
                                    <span class="detail-label">Cập nhật bởi:</span>
                                    <span class="detail-value">${department.updatedByName}</span>
                                </div>
                                <div class="detail-item">
                                    <span class="detail-label">Ngày cập nhật:</span>
                                    <span class="detail-value">
                                        <fmt:formatDate value="${department.updateDate}" pattern="dd/MM/yyyy HH:mm:ss"/>
                                    </span>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>

                <!-- Description -->
                <c:if test="${not empty department.description}">
                    <div class="detail-section full-width">
                        <h3>📝 Mô tả</h3>
                        <div class="description-box">
                            ${department.description}
                        </div>
                    </div>
                </c:if>

                <!-- Employee List -->
                <div class="employee-section">
                    <div class="detail-section full-width">
                        <h3>👥 Danh sách nhân viên (${department.employeeCount} người)</h3>
                        
                        <c:choose>
                            <c:when test="${not empty employees}">
                                <table class="employee-table">
                                    <thead>
                                        <tr>
                                            <th>STT</th>
                                            <th>Họ tên</th>
                                            <th>Username</th>
                                            <th>Email</th>
                                            <th>Điện thoại</th>
                                            <th>Chức vụ</th>
                                            <th>Trạng thái</th>
                                            <th>Ngày vào</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="employee" items="${employees}" varStatus="status">
                                            <tr>
                                                <td>${status.index + 1}</td>
                                                <td><strong>${employee.fullname}</strong></td>
                                                <td>${employee.username}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty employee.email}">
                                                            <a href="mailto:${employee.email}">${employee.email}</a>
                                                        </c:when>
                                                        <c:otherwise>--</c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty employee.phone}">
                                                            <a href="tel:${employee.phone}">${employee.phone}</a>
                                                        </c:when>
                                                        <c:otherwise>--</c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty employee.roles}">
                                                            ${employee.roles}
                                                        </c:when>
                                                        <c:otherwise>--</c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <span class="employee-status ${employee.active ? 'employee-active' : 'employee-inactive'}">
                                                        ${employee.active ? 'Hoạt động' : 'Không hoạt động'}
                                                    </span>
                                                </td>
                                                <td>
                                                    <c:if test="${not empty employee.joinDate}">
                                                        <fmt:formatDate value="${employee.joinDate}" pattern="dd/MM/yyyy"/>
                                                    </c:if>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state">
                                    <h4>👥 Chưa có nhân viên nào</h4>
                                    <p>Phòng ban này chưa có nhân viên được phân công.</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            