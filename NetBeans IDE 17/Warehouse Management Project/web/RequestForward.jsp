<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1
    response.setHeader("Pragma", "no-cache"); // HTTP 1.0
    response.setDateHeader("Expires", 0); // Proxies
%>
<%@page import="model.Users"%>
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
            .h1 {
                color: #f4f4f9;
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
                display: flex;
                flex-wrap: wrap;
                justify-content: space-between;
                gap: 10px;
            }

            .card {
                background-color: #fff;
                border-radius: 10px;
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
                transition: transform 0.3s, box-shadow 0.3s;
                width: calc(50% - 5px);
                margin-bottom: 10px;
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
                text-align: center;
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
                color: #666;
                border: 1px solid #ccc;
            }

            .btn-secondary:hover {
                background-color: #f0f0f0;
            }

            .footer {
                text-align: center;
                margin-top: 30px;
                display: flex;
                justify-content: center;
                gap: 15px;
            }

            .btn-icon {
                font-size: 16px;
                vertical-align: text-bottom;
                margin-left: 5px;
            }

            .back-btn-icon {
                margin-right: 5px;
            }

            /* Responsive styles */
            @media (max-width: 900px) {
                .card {
                    width: calc(50% - 15px);
                }
            }

            @media (max-width: 600px) {
                .card {
                    width: 100%;
                }
                .footer {
                    flex-direction: column;
                    gap: 10px;
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
            }
            .label {
                color: #888;
                width: 120px;
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
            .page-title {
                color: #3f51b5;
                font-size: 2rem;
                margin-bottom: 10px;
            }
        </style>
    </head>
    <body>
        <div class="layout-container">
            <jsp:include page="/include/sidebar.jsp" />
            <div class="main-content">           
                <div class="header">
                    <h1 class="page-title">Quản lý Xuất Nhập kho</h1>
                    <div class="header-user">
                        <label class="label"><%= user.getFullname()%></label>
                        <a href="logout" class="logout-btn">Đăng xuất</a>
                    </div>
                </div>

            <div class="card-container">
                <!-- Request in -->
                <div class="card">
                    <div class="card-header">
                        <h3>Mua hàng</h3>
                    </div>
                    <div class="card-body">
                        <div class="icon-container">
                            <span class="material-icons">add_shopping_cart</span>
                        </div>
                        <h4 class="card-title">Đơn yêu cầu mua hàng</h4>
                        <p class="card-text">Yêu cầu mua một số sản phẩm nhất định.</p>
                        <a href="loadingrequest" class="btn btn-primary">
                            Truy cập <span class="material-icons btn-icon">arrow_forward</span>
                        </a>
                    </div>
                </div>

                <!-- Request out -->
                <div class="card">
                    <div class="card-header">
                        <h3>Xuất kho</h3>
                    </div>
                    <div class="card-body">
                        <div class="icon-container">
                            <span class="material-icons">outbound</span>
                        </div>
                        <h4 class="card-title">Đơn yêu cầu xuất kho</h4>
                        <p class="card-text">Yêu cầu xuất kho một số sản phẩm nhất định.</p>
                        <a href="exportRequest" class="btn btn-primary">
                            Truy cập <span class="material-icons btn-icon">arrow_forward</span>
                        </a>
                    </div>
                </div>

                <!-- Request list -->
                <div class="card">
                    <div class="card-header">
                        <h3>Danh sách yêu cầu nhập</h3>
                    </div>
                    <div class="card-body">
                        <div class="icon-container">
                            <span class="material-icons">list</span>
                        </div>
                        <h4 class="card-title">Danh sách yêu cầu nhập kho</h4>
                        <p class="card-text">Xem danh sách các yêu cầu nhập kho.</p>
                        <a href="import" class="btn btn-primary">
                            Truy cập <span class="material-icons btn-icon">arrow_forward</span>
                        </a>
                    </div>
                </div>
                <div class="card">
                    <div class="card-header">
                        <h3>Danh sách báo giá</h3>
                    </div>
                    <div class="card-body">
                        <div class="icon-container">
                            <span class="material-icons">receipt_long</span>
                        </div>
                        <h4 class="card-title">Danh sách báo giá</h4>
                        <p class="card-text">Xem và tạo đơn báo giá các sản phẩm được phép mua.</p>
                        <a href="listpurchaseorder" class="btn btn-primary">
                            Truy cập <span class="material-icons btn-icon">arrow_forward</span>
                        </a>
                    </div>
                </div>
            </div>

            <div class="footer">
                <a href="categoriesforward.jsp" class="btn btn-secondary">
                    Quay lại Trang chủ
                </a>
            </div>
        </div>
            </div>
    </body>
</html>