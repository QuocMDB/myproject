<%-- 
    Document   : AddNewSupplier
    Created on : 28 thg 5, 2025, 21:45:04
    Author     : Fpt06
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<%@ page import="model.Users" %> 
<%
Users user = (Users) session.getAttribute("user");
if (user == null || (!"Admin".equalsIgnoreCase(user.getRoleName())&&!"Nhân viên kho".equalsIgnoreCase(user.getRoleName()))) {
    response.sendRedirect("login.jsp");
    return;
}

%>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Add New Supplier</title>
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
        <style>
            * {
                box-sizing: border-box;
                font-family: 'Roboto', sans-serif;
            }

            body {
                margin: 0;
                background: linear-gradient(135deg, #e0f7fa, #e1bee7);

                min-height: 100vh;
                animation: fadeIn 1.2s ease-in-out;
            }

            @keyframes fadeIn {
                0% {
                    opacity: 0;
                    transform: translateY(-20px);
                }
                100% {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .form-container {
                background: #fff;
                padding: 40px;
                border-radius: 16px;
                box-shadow: 0 8px 24px rgba(0, 0, 0, 0.2);
                width: 100%;
                max-width: 420px;
                animation: slideUp 0.8s ease-in-out;
            }

            @keyframes slideUp {
                0% {
                    transform: translateY(50px);
                    opacity: 0;
                }
                100% {
                    transform: translateY(0);
                    opacity: 1;
                }
            }

            h1 {
                text-align: center;
                color: #5e35b1;
                margin-bottom: 24px;
            }

            .input-group {
                margin-bottom: 20px;
            }

            .input-group label {
                display: block;
                margin-bottom: 6px;
                font-weight: 500;
            }

            .input-group input {
                width: 100%;
                padding: 10px 12px;
                border: 1px solid #ccc;
                border-radius: 8px;
                transition: 0.3s;
            }

            .input-group input:focus {
                border-color: #5e35b1;
                outline: none;
                box-shadow: 0 0 8px #ce93d8;
            }

            .input-group textarea {
                width: 100%;
                padding: 10px 12px;
                border: 1px solid #ccc;
                border-radius: 8px;
                resize: vertical; /* cho phép kéo giãn chiều cao */
                min-height: 80px;
                transition: 0.3s;
                font-family: 'Roboto', sans-serif;
            }

            .input-group textarea:focus {
                border-color: #5e35b1;
                outline: none;
                box-shadow: 0 0 8px #ce93d8;
            }

            .submit-btn {
                width: 100%;
                background: #43a047;
                color: white;
                font-weight: bold;
                border: none;
                padding: 12px;
                border-radius: 8px;
                font-size: 16px;
                cursor: pointer;
                transition: background 0.3s, transform 0.2s;
            }

            .submit-btn:hover {
                background: #388e3c;
                transform: translateY(-2px);
            }

            .back-btn {
                display: flex;
                align-items: center;
                justify-content: center;
                margin-top: 16px;
                text-decoration: none;
                font-size: 14px;
                color: #5e35b1;
                transition: all 0.3s ease;
            }

            .back-btn:hover {
                color: #311b92;
                transform: scale(1.05);
            }

            .material-icons {
                vertical-align: middle;
                margin-right: 6px;
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
            body {
                margin: 0;
                background: linear-gradient(135deg, #dbeeff, #f1f8ff);
                font-family: 'Roboto', sans-serif;
                min-height: 100vh;
                animation: fadeIn 0.8s ease-in;
            }

            @keyframes fadeIn {
                from {
                    opacity: 0;
                    transform: translateY(20px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .layout-container {
                display: flex;
                min-height: 100vh;
            }

            .main-content {
                flex: 1;
                padding: 40px 20px;
                display: flex;
                justify-content: center;
                align-items: center;
                background-color: #f4f8fb;
            }

            .form-container {
                background-color: white;
                padding: 32px 40px;
                border-radius: 16px;
                box-shadow: 0 8px 24px rgba(0, 0, 0, 0.1);
                max-width: 500px;
                width: 100%;
                animation: slideUp 0.5s ease;
            }

            @keyframes slideUp {
                from {
                    transform: translateY(40px);
                    opacity: 0;
                }
                to {
                    transform: translateY(0);
                    opacity: 1;
                }
            }

            h1 {
                text-align: center;
                color: #1567c1;
                font-size: 26px;
                margin-bottom: 24px;
            }

            .input-group {
                margin-bottom: 18px;
            }

            .input-group label {
                display: block;
                margin-bottom: 6px;
                font-weight: 600;
                color: #333;
            }

            .input-group input,
            .input-group textarea {
                width: 100%;
                padding: 10px 12px;
                border: 1px solid #ccc;
                border-radius: 8px;
                font-size: 14px;
                transition: 0.3s;
            }

            .input-group input:focus,
            .input-group textarea:focus {
                border-color: #1567c1;
                outline: none;
                box-shadow: 0 0 5px rgba(21, 103, 193, 0.3);
            }

            .input-group textarea {
                resize: vertical;
                min-height: 80px;
            }

            .submit-btn {
                width: 100%;
                background: linear-gradient(135deg, #43a047, #2e7d32);
                color: white;
                font-weight: bold;
                border: none;
                padding: 12px 0;
                border-radius: 8px;
                font-size: 15px;
                cursor: pointer;
                transition: all 0.3s ease;
            }

            .submit-btn:hover {
                background: linear-gradient(135deg, #388e3c, #1b5e20);
                transform: translateY(-1px);
            }

            .back-btn {
                display: flex;
                align-items: center;
                justify-content: center;
                margin-top: 20px;
                font-size: 14px;
                color: #1567c1;
                text-decoration: none;
                transition: 0.3s;
            }

            .back-btn:hover {
                color: #0d47a1;
                transform: scale(1.05);
            }

            .material-icons {
                vertical-align: middle;
                margin-right: 6px;
                font-size: 18px;
            }

            @media (max-width: 600px) {
                .form-container {
                    padding: 24px 20px;
                    border-radius: 12px;
                }

                h1 {
                    font-size: 22px;
                }
            }

        </style>
    </head>
    <body>
        <div class="layout-container">
            <jsp:include page="/include/sidebar.jsp" />
            <div class="main-content">
                <div class="form-container">
                    <h1>Add New Supplier</h1>
                    <c:set var="mess" value="${requestScope.mess}"/>
                    <c:set var="invalidPhone" value="${requestScope.invalidPhone}"/>
                    <c:set var="invalidEmail" value="${requestScope.invalidEmail}"/>
                    <c:if test="${not empty mess}">
                        <p style="color: green;font-size: larger" >${mess}</p>
                    </c:if>
                    <form action="AddNewSupplier" method="get">
                        <div class="input-group">
                            <label><i class="material-icons">business</i> Tên nhà cung cấp</label>
                            <input type="text" name="nameSupplier" required>
                        </div>

                        <div class="input-group">
                            <label><i class="material-icons">phone</i> Số điện thoại</label>
                            <c:if test="${not empty invalidPhone}">
                                <label style="color: red" >${invalidPhone}</label>
                            </c:if>
                            <input type="number" name="phone" required>
                        </div>
                        <div class="input-group">                         
                            <label><i class="material-icons">email</i> Email</label>
                            <c:if test="${not empty invalidEmail}">
                                <label style="color: red" >${invalidEmail}</label>
                            </c:if>
                            <input type="email" name="email" required>
                        </div>
                        <div class="input-group">
                            <label><i class="material-icons">home</i> Địa chỉ</label>
                            <input type="text" name="address" required>
                        </div>
                        <div class="input-group">
                            <label><i class="material-icons">edit_note</i> Ghi chú</label>
                            <textarea name="note" rows="3"></textarea>
                        </div>
                        <button type="submit" class="submit-btn">Add</button>
                    </form>
                    <a href="LishSupplier" class="back-btn"><i class="material-icons">arrow_back</i> Back</a>
                </div>
            </div>
        </div>
    </body>
</html>
