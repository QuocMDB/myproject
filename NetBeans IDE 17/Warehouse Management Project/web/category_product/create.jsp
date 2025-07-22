<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

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
        <title>Thêm danh mục sản phẩm</title>
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
                background: #28a745;
                color: white;
                border-bottom: 2px solid #1e7e34;
            }

            .card-body {
                padding: 30px;
            }

            /* Navigation Buttons */
            .nav-buttons {
                display: flex;
                gap: 15px;
                margin-bottom: 25px;
            }

            /* Alert Styles */
            .alert {
                padding: 15px;
                border-radius: 5px;
                margin-bottom: 20px;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .alert-danger {
                background: #f8d7da;
                color: #721c24;
                border: 1px solid #f1aeb5;
            }

            .alert-success {
                background: #d4edda;
                color: #155724;
                border: 1px solid #c3e6cb;
            }

            .alert-close {
                margin-left: auto;
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
                border-color: #28a745;
                box-shadow: 0 0 0 2px rgba(40,167,69,0.25);
            }

            .text-danger {
                color: #dc3545;
            }

            .text-muted {
                color: #6c757d;
                font-size: 12px;
                margin-top: 5px;
            }

            /* Checkbox Styles */
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
                background: #28a745;
                color: white;
            }

            .btn-secondary {
                background: #6c757d;
                color: white;
            }

            .btn:hover {
                opacity: 0.9;
            }

            .button-group {
                display: flex;
                justify-content: flex-end;
                gap: 15px;
                margin-top: 30px;
            }

            /* Info Section */
            .info-section {
                background: #e8f5e8;
                padding: 20px;
                border-radius: 5px;
                margin-bottom: 20px;
                border-left: 4px solid #28a745;
            }

            .info-title {
                font-weight: bold;
                margin-bottom: 10px;
                color: #155724;
            }

            .info-list {
                list-style: none;
                padding: 0;
            }

            .info-list li {
                padding: 5px 0;
                color: #155724;
            }

            .info-list li:before {
                content: "✓ ";
                color: #28a745;
                font-weight: bold;
            }

            /* Form validation styles */
            .form-control.error {
                border-color: #dc3545;
                box-shadow: 0 0 0 2px rgba(220,53,69,0.25);
            }

            .form-control.success {
                border-color: #28a745;
                box-shadow: 0 0 0 2px rgba(40,167,69,0.25);
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

            .category-level-3 {
                padding-left: 60px;
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

                <div class="card">
                    <div class="card-header">
                        Thêm danh mục sản phẩm mới
                    </div>
                    <div class="card-body">
                        <!-- Thông báo lỗi -->
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger">
                                <span>⚠️</span>
                                ${error}
                                <button type="button" class="alert-close" onclick="this.parentElement.style.display = 'none'">&times;</button>
                            </div>
                        </c:if>

                        <!-- Thông báo thành công -->
                        <c:if test="${not empty success}">
                            <div class="alert alert-success">
                                <span>✅</span>
                                ${success}
                                <button type="button" class="alert-close" onclick="this.parentElement.style.display = 'none'">&times;</button>
                            </div>
                        </c:if>

                        <form method="post" action="${pageContext.request.contextPath}/category/create" id="categoryForm">
                            <div class="form-group">
                                <label for="name" class="form-label">Tên danh mục sản phẩm <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" id="name" name="name" 
                                       value="${param.name}" required maxlength="255" 
                                       placeholder="Nhập tên danh mục sản phẩm...">
                                <div class="text-muted">Tên danh mục phải duy nhất và không được trùng lặp</div>
                            </div>

<div class="form-group">
    <label for="parentId" class="form-label">Danh mục cha</label>
    <select class="form-select" id="parentId" name="parentId">
        <option value="">-- Chọn danh mục (không bắt buộc) --</option>
        <c:forEach var="category" items="${allCategories}">
            <option value="${category.id}" 
                    ${param.parentId eq category.id ? 'selected' : ''}
                    class="${empty category.parentId ? 'category-level-0' : 'category-level-1'}">
                <c:choose>
                    <c:when test="${empty category.parentId}">
                        ${category.name}
                    </c:when>
                    <c:otherwise>
                        └─ ${category.name}  <!-- Thêm khoảng trắng sau └─ -->
                    </c:otherwise>
                </c:choose>
            </option>
        </c:forEach>
    </select>
    <div class="text-muted">Chọn danh mục cha để tạo cấu trúc phân cấp</div>
</div>

                            <div class="form-group">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" id="activeFlag" 
                                           name="activeFlag" value="1" ${param.activeFlag eq '1' ? 'checked' : 'checked'}>
                                    <label class="form-check-label" for="activeFlag">
                                        ✓ Kích hoạt danh mục ngay sau khi tạo
                                    </label>
                                </div>
                            </div>

                            <div class="button-group">
                                <a href="${pageContext.request.contextPath}/category/list" 
                                   class="btn btn-secondary">← Hủy</a>
                                <button type="submit" class="btn btn-primary">Thêm danh mục sản phẩm</button>
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
            document.getElementById('categoryForm').addEventListener('submit', function (e) {
                const nameInput = document.getElementById('name');
                const name = nameInput.value.trim();

                // Reset styles
                nameInput.classList.remove('error', 'success');

                if (!name) {
                    e.preventDefault();
                    nameInput.classList.add('error');
                    alert('⚠️ Vui lòng nhập tên danh mục!');
                    nameInput.focus();
                    return;
                }

                if (name.length > 255) {
                    e.preventDefault();
                    nameInput.classList.add('error');
                    alert('⚠️ Tên danh mục không được vượt quá 255 ký tự!');
                    nameInput.focus();
                    return;
                }

                nameInput.classList.add('success');
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