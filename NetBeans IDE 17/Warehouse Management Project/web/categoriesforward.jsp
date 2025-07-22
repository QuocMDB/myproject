<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Users" session="true" %> 
<!DOCTYPE html>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1
    response.setHeader("Pragma", "no-cache"); // HTTP 1.0
    response.setDateHeader("Expires", 0); // Proxies
%>
<%@page import="model.Users"%>
<%
    Users user = (Users) session.getAttribute("user");
    if (user == null || !"Admin".equals(user.getRoleName()) && !"Nhân viên kho".equals(user.getRoleName())) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản lý Thông tin Vật liệu</title>
        <!-- Material Icons -->
        <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
                font-family: Arial, Helvetica, sans-serif;
            }

            body {
                background-color: #f5f5f5;
                padding: 20px;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }

            .container {
                max-width: 1200px;
                margin: 0 auto;
                padding: 0 15px;
            }

            .header {
                text-align: center;
                margin-bottom: 30px;
            }

            .label {
                color: #888;
                width: 120px;
            }
            .value {
                color: #222;
                font-weight: bold;
            }

            .page-title {
                color: #3f51b5;
                font-size: 2rem;
                margin-bottom: 10px;
            }

            .lead {
                font-size: 1.2rem;
                color: #666;
                margin-bottom: 20px;
            }

            .card-container {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
                gap: 20px;
                justify-content: center;
            }

            .card {
                background-color: #fff;
                border-radius: 10px;
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
                transition: transform 0.3s, box-shadow 0.3s;
                margin-bottom: 20px;
            }

            .card:hover {
                transform: translateY(-5px);
                box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
            }

            .card-header {
                background-color: #3f51b5;
                color: white;
                border-radius: 10px 10px 0 0;
                padding: 15px;
            }

            .card-header h3 {
                margin: 0;
                font-size: 1.2rem;
            }

            .card-body {
                padding: 25px;
                text-align: center;
            }

            .icon-container {
                background-color: #eaecf4;
                width: 70px;
                height: 70px;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                margin: 0 auto 20px;
            }

            .material-icons {
                font-size: 36px;
                color: #3f51b5;
            }

            .card-title {
                font-size: 1.1rem;
                margin-bottom: 10px;
                color: #333;
            }

            .card-text {
                color: #666;
                margin-bottom: 20px;
                line-height: 1.5;
            }

            .btn {
                display: inline-block;
                padding: 10px 20px;
                border-radius: 5px;
                text-decoration: none;
                font-weight: bold;
                cursor: pointer;
                transition: background-color 0.3s;
            }

            .btn-primary {
                background-color: #3f51b5;
                color: white;
            }

            .btn-primary:hover {
                background-color: #303f9f;
            }

            .btn-secondary {
                background-color: transparent;
                color: blue;
                border: 1px solid #ccc;
            }
            .btn-secondaries {
                background-color: transparent;
                color: red;
                border: 1px solid #ccc;
            }
            .btn-secondary:hover {
                background-color: #f0f0f0;
            }

            .footer {
                text-align: center;
                margin-top: 30px;
            }

            .btn-icon {
                font-size: 16px;
                vertical-align: text-bottom;
                margin-left: 5px;
            }

            .back-btn-icon {
                margin-right: 5px;
            }

            .layout-container {
                display: flex;
                min-height: 150vh;
            }

            .main-content {
                flex: 1;
                padding: 20px;
                background: #f5f5f5;
            }
            .header-user {
                display: flex;
                align-items: center;
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

            /* Responsive styles */
            @media (max-width: 1200px) {
                .card-container {
                    grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
                }
            }

            @media (max-width: 768px) {
                .card-container {
                    grid-template-columns: 1fr;
                }
                
                .page-title {
                    font-size: 1.5rem;
                }
            }
        </style>
    </head>
    <body>
        <div class="layout-container">
            <jsp:include page="/include/sidebar.jsp" />
            <div class="main-content">
                <div class="header">
                    <h1 class="page-title">Quản lý Thông tin Vật liệu</h1>
                    <div class="header-user">
                        <label class="label"><%= user.getFullname()%></label>
                        <a href="logout" class="logout-btn">Đăng xuất</a>
                    </div>
                </div>

                <div class="card-container">
                    <!-- Categories Product -->
                    <div class="card">
                        <div class="card-header">
                            <h3>Danh mục Sản phẩm</h3>
                        </div>
                        <div class="card-body">
                            <div class="icon-container">
                                <span class="material-icons">category</span>
                            </div>
                            <h4 class="card-title">Quản lý Danh mục Sản phẩm</h4>
                            <p class="card-text">Thêm, sửa, xóa và xem các danh mục sản phẩm trong hệ thống.</p>
                            <a href="category/list" class="btn btn-primary">
                                Truy cập <span class="material-icons btn-icon">arrow_forward</span>
                            </a>
                        </div>
                    </div>

                    <!-- Categories Department - XẾP BÊN CẠNH -->
                    <div class="card">
                        <div class="card-header">
                            <h3>Danh mục Phòng ban</h3>
                        </div>
                        <div class="card-body">
                            <div class="icon-container">
                                <span class="material-icons">domain</span>
                            </div>
                            <h4 class="card-title">Quản lý Phòng ban</h4>
                            <p class="card-text">Thêm, sửa, xóa và xem thông tin về các phòng ban trong tổ chức.</p>
                            <a href="department/list" class="btn btn-primary">
                                Truy cập <span class="material-icons btn-icon">arrow_forward</span>
                            </a>
                        </div>
                    </div>

                    <!-- Categories Unit -->
                    <div class="card">
                        <div class="card-header">
                            <h3>Danh mục Đơn vị</h3>
                        </div>
                        <div class="card-body">
                            <div class="icon-container">
                                <span class="material-icons">straighten</span>
                            </div>
                            <h4 class="card-title">Quản lý Đơn vị Tính</h4>
                            <p class="card-text">Quản lý các đơn vị đo lường và tính toán cho vật liệu và sản phẩm.</p>
                            <a href="material_unit/materialUnit" class="btn btn-primary">
                                Truy cập <span class="material-icons btn-icon">arrow_forward</span>
                            </a>
                        </div>
                    </div>

                    <!-- Categories Supplier -->
                    <div class="card">
                        <div class="card-header">
                            <h3>Danh mục Nhà cung cấp</h3>
                        </div>
                        <div class="card-body">
                            <div class="icon-container">
                                <span class="material-icons">business</span>
                            </div>
                            <h4 class="card-title">Quản lý Nhà cung cấp</h4>
                            <p class="card-text">Thêm, sửa, xóa và xem thông tin về các nhà cung cấp vật liệu.</p>
                            <a href="LishSupplier" class="btn btn-primary">
                                Truy cập <span class="material-icons btn-icon">arrow_forward</span>
                            </a>
                        </div>
                    </div>   

                    <!-- Product Management -->
                    <div class="card">
                        <div class="card-header">
                            <h3>Quản lý Sản phẩm</h3>
                        </div>
                        <div class="card-body">
                            <div class="icon-container">
                                <span class="material-icons">inventory</span>
                            </div>
                            <h4 class="card-title">Quản lý Sản phẩm</h4>
                            <p class="card-text">Thêm, sửa, xóa và xem thông tin chi tiết về các sản phẩm.</p>
                            <a href="product-list" class="btn btn-primary">
                                Truy cập <span class="material-icons btn-icon">arrow_forward</span>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>