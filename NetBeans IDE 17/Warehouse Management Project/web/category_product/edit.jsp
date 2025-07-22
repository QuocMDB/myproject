<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>
<%@page import="model.Users"%>
<%
    Users user = (Users) session.getAttribute("user");
    if (user == null || !"Admin".equals(user.getRoleName()) && !"Nhân viên kho".equals(user.getRoleName())) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Chỉnh sửa danh mục sản phẩm</title>
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
                max-width: 800px;
                margin: 0 auto;
            }

            .card {
                background: white;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                margin-bottom: 20px;
                overflow: hidden;
            }

            .card-header {
                padding: 20px;
                font-size: 1.5rem;
                font-weight: bold;
                border-bottom: 2px solid #eee;
            }

            .card-header-warning {
                background: #ffc107;
                color: #212529;
            }

            .card-header-info {
                background: #17a2b8;
                color: white;
            }

            .card-body {
                padding: 30px;
            }

            /* Alert Styles */
            .alert {
                padding: 15px;
                border-radius: 5px;
                margin-bottom: 20px;
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

            /* Form Styles */
            .form-group {
                margin-bottom: 25px;
            }

            .form-label {
                display: block;
                margin-bottom: 8px;
                font-weight: bold;
                font-size: 14px;
            }

            .form-control, .form-select {
                width: 100%;
                padding: 12px;
                border: 1px solid #ddd;
                border-radius: 4px;
                font-size: 14px;
                background: white;
            }

            .form-control:focus, .form-select:focus {
                outline: none;
                border-color: #ffc107;
                box-shadow: 0 0 0 2px rgba(255,193,7,0.25);
            }

            .text-muted {
                color: #6c757d;
                font-size: 12px;
                margin-top: 5px;
            }

            .text-danger {
                color: #dc3545;
            }

            .text-success {
                color: #28a745;
            }

            /* Radio Group */
            .radio-group {
                margin-top: 10px;
            }

            .radio-item {
                display: flex;
                align-items: center;
                margin-bottom: 10px;
                padding: 10px;
                border: 1px solid #eee;
                border-radius: 4px;
                cursor: pointer;
            }

            .radio-item:hover {
                background: #f8f9fa;
            }

            .radio-input {
                margin-right: 10px;
            }

            /* Button Styles */
            .btn {
                padding: 12px 24px;
                border: none;
                border-radius: 4px;
                font-size: 14px;
                cursor: pointer;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                gap: 8px;
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

            .btn:hover {
                opacity: 0.9;
            }

            .button-group {
                display: flex;
                justify-content: space-between;
                margin-top: 30px;
                gap: 15px;
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

            .form-check {
                display: flex;
                align-items: center;
                gap: 10px;
                padding: 15px;
                border: 1px solid #eee;
                border-radius: 4px;
                cursor: pointer;
            }

            .form-check:hover {
                background: #f8f9fa;
            }

            .form-check-input {
                width: 18px;
                height: 18px;
                cursor: pointer;
            }

            .form-check-label {
                cursor: pointer;
                font-weight: 500;
            }

            /* Info Section */
            .info-section {
                background: #f8f9fa;
                padding: 20px;
                border-radius: 5px;
                margin-bottom: 20px;
                border-left: 4px solid #17a2b8;
            }

            .info-item {
                display: flex;
                justify-content: space-between;
                margin-bottom: 10px;
                padding-bottom: 10px;
                border-bottom: 1px solid #e9ecef;
            }

            .info-item:last-child {
                border-bottom: none;
                margin-bottom: 0;
            }

            .info-label {
                font-weight: bold;
                color: #666;
            }

            .note {
                background: #f8f9fa;
                padding: 15px;
                border-radius: 5px;
                border-left: 4px solid #17a2b8;
                margin-top: 20px;
            }

            /* Navigation Buttons */
            .nav-buttons {
                display: flex;
                gap: 15px;
                margin-bottom: 25px;
            }

            /* Category hierarchy styles */
            .category-level-0 {
                font-weight: bold;
            }

            .category-level-1 {
                padding-left: 20px;
            }

            .category-level-2 {
                padding-left: 40px;
            }

            /* Header */
            .header {
                text-align: center;
                margin-bottom: 30px;
            }

            .header-user {
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 20px;
                margin-top: 10px;
            }

            .logout-btn {
                background: #dc3545;
                color: white;
                padding: 8px 16px;
                border-radius: 4px;
                text-decoration: none;
            }

            .logout-btn:hover {
                background: #c82333;
            }

            /* Responsive */
            @media (max-width: 768px) {
                .container {
                    padding: 10px;
                }

                .card-body {
                    padding: 20px;
                }

                .button-group {
                    flex-direction: column;
                }

                .nav-buttons {
                    flex-direction: column;
                }

                .info-item {
                    flex-direction: column;
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
        </style>
    </head>
    <body>
        <div class="layout-container">
            <jsp:include page="/include/sidebar.jsp" />
            <div class="main-content">
                <!-- Header -->
                <div class="header">
                    <h1>Quản lý danh mục sản phẩm</h1>
                    <div class="header-user">
                        <span>Xin chào, <%= user.getFullname() %></span>
                        <a href="logout" class="logout-btn">Đăng xuất</a>
                    </div>
                </div>


                <!-- Form chỉnh sửa -->
                <div class="card">
                    <div class="card-header card-header-warning">
                        Chỉnh sửa danh mục sản phẩm
                    </div>
                    <div class="card-body">
                        <c:if test="${error != null}">
                            <div class="alert alert-danger">
                                ${error}
                                <button type="button" class="alert-close" onclick="this.parentElement.style.display = 'none'">&times;</button>
                            </div>
                        </c:if>

                        <form action="${pageContext.request.contextPath}/category/edit" method="post" id="editForm">
                            <input type="hidden" name="id" value="${category.id}">

                            <div class="form-group">
                                <label for="name" class="form-label">Tên danh mục sản phẩm <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" id="name" name="name" 
                                       value="${category.name}" required maxlength="255"
                                       placeholder="Nhập tên danh mục sản phẩm...">
                                <div class="text-muted">Tên danh mục phải duy nhất và không được trùng lặp</div>
                            </div>

                            <div class="form-group">
    <label for="parentId" class="form-label">Danh mục cha</label>
    <c:choose>
        <c:when test="${canSelectParent}">
            <!-- Cho phép chọn danh mục cha -->
            <select class="form-select" id="parentId" name="parentId">
                <option value="">-- Không có danh mục cha --</option>
                <c:forEach items="${parentCategories}" var="cat">
                    <option value="${cat.id}" 
                            ${category.parentId == cat.id ? 'selected' : ''}
                            class="${empty cat.parentId ? 'category-level-0' : 'category-level-1'}">
                        <c:choose>
                            <c:when test="${empty cat.parentId}">
                                ${cat.name}
                            </c:when>
                            <c:otherwise>
                                └─ ${cat.name}
                            </c:otherwise>
                        </c:choose>
                    </option>
                </c:forEach>
            </select>
            <div class="text-muted">Chọn danh mục cha để tạo cấu trúc phân cấp</div>
        </c:when>
        <c:otherwise>
            <!-- Không cho phép chọn vì đã có danh mục con -->
            <input type="hidden" name="parentId" value="${category.parentId}">
            <select class="form-select" disabled>
                <option>
                    <c:choose>
                        <c:when test="${empty category.parentId}">
                            -- Không có danh mục cha --
                        </c:when>
                        <c:otherwise>
                            ${category.parentName}
                        </c:otherwise>
                    </c:choose>
                </option>
            </select>
            <div class="text-danger">
                <i class="fas fa-info-circle"></i>
                Không thể thay đổi danh mục cha vì danh mục này đã có danh mục con
            </div>
        </c:otherwise>
    </c:choose>
</div>

                            <div class="form-group">
                                <label class="form-label">Trạng thái</label>
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" id="activeFlag" 
                                           name="activeFlag" value="1" ${category.activeFlag ? 'checked' : ''}>
                                    <label class="form-check-label" for="activeFlag">
                                        ✓ Kích hoạt danh mục
                                    </label>
                                </div>
                            </div>

                            <div class="button-group">
                                <a href="${pageContext.request.contextPath}/category/list" class="btn btn-secondary">
                                    ← Hủy
                                </a>
                                <button type="submit" class="btn btn-warning">
                                    💾 Cập nhật thay đổi
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>                  
        </div>

        <script>
            // Xử lý đóng alert
            document.addEventListener('DOMContentLoaded', function () {
                const closeButtons = document.querySelectorAll('.alert-close');
                closeButtons.forEach(function (button) {
                    button.addEventListener('click', function () {
                        this.parentElement.style.display = 'none';
                    });
                });

                // Auto hide alerts after 5 seconds
                const alerts = document.querySelectorAll('.alert');
                alerts.forEach(function (alert) {
                    setTimeout(function () {
                        alert.style.display = 'none';
                    }, 5000);
                });
            });

            // Form validation
            document.getElementById('editForm').addEventListener('submit', function (e) {
                const nameInput = document.getElementById('name');
                const name = nameInput.value.trim();

                if (!name) {
                    e.preventDefault();
                    alert('⚠️ Vui lòng nhập tên danh mục!');
                    nameInput.focus();
                    return;
                }

                if (name.length > 255) {
                    e.preventDefault();
                    alert('⚠️ Tên danh mục không được vượt quá 255 ký tự!');
                    nameInput.focus();
                    return;
                }
            });

            // Real-time validation
            document.getElementById('name').addEventListener('input', function () {
                const value = this.value.trim();
                this.classList.remove('error', 'success');

                if (value && value.length <= 255) {
                    this.classList.add('success');
                } else if (value.length > 255) {
                    this.classList.add('error');
                }
            });
        </script>
    </body>
</html>