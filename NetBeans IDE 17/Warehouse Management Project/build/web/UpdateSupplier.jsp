<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Update Supplier</title>
        <style>
            * {
                box-sizing: border-box;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }

            body {
                margin: 0;
                padding: 0;
                height: 100vh;
                background: linear-gradient(270deg, #f39c12, #e74c3c, #8e44ad, #3498db);
                background-size: 800% 800%;
                animation: gradientBG 15s ease infinite;
            }

            @keyframes gradientBG {
                0% {
                    background-position: 0% 50%;
                }
                50% {
                    background-position: 100% 50%;
                }
                100% {
                    background-position: 0% 50%;
                }
            }

            .layout-container {
                display: flex;
                min-height: 100vh;
            }

            .main-content {
                flex: 1;
                padding: 40px 20px;
                background: rgba(255, 255, 255, 0.92);
                display: flex;
                justify-content: center;
                align-items: center;
            }

            .form-container {
                background: white;
                padding: 40px 50px;
                border-radius: 16px;
                box-shadow: 0 12px 32px rgba(0, 0, 0, 0.2);
                width: 100%;
                max-width: 500px;
                animation: slideIn 0.6s ease-out;
            }

            @keyframes slideIn {
                from {
                    opacity: 0;
                    transform: translateY(50px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            h1 {
                text-align: center;
                color: #2c3e50;
                margin-bottom: 30px;
                font-size: 28px;
            }

            label {
                font-weight: 600;
                color: #333;
                display: block;
                margin-bottom: 6px;
            }

            input[type="text"],
            input[type="number"],
            input[type="email"] {
                width: 100%;
                padding: 12px;
                margin-bottom: 20px;
                border: 1.5px solid #ccc;
                border-radius: 8px;
                font-size: 15px;
                transition: all 0.3s ease-in-out;
            }

            input[type="text"]:focus,
            input[type="number"]:focus,
            input[type="email"]:focus {
                border-color: #3498db;
                box-shadow: 0 0 0 4px rgba(52, 152, 219, 0.2);
                outline: none;
            }

            input[type="submit"] {
                width: 100%;
                padding: 12px;
                background: linear-gradient(to right, #3498db, #2980b9);
                color: white;
                border: none;
                border-radius: 8px;
                font-size: 16px;
                font-weight: bold;
                cursor: pointer;
                transition: transform 0.2s ease, background 0.4s ease;
            }

            input[type="submit"]:hover {
                transform: translateY(-2px);
                background: linear-gradient(to right, #2980b9, #3498db);
            }

            .back-link {
                display: inline-block;
                text-align: center;
                margin-top: 20px;
                padding: 10px 20px;
                color: #3498db;
                text-decoration: none;
                border: 2px solid #3498db;
                border-radius: 8px;
                font-weight: bold;
                transition: all 0.3s ease;
            }

            .back-link:hover {
                background-color: #3498db;
                color: white;
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(52, 152, 219, 0.4);
            }

            .error-message {
                color: red;
                font-size: larger;
                text-align: center;
                margin-bottom: 20px;
            }
        </style>
    </head>
    <body>
        <%
            String id = request.getParameter("id");
            String name = request.getParameter("name");
            String phone = request.getParameter("phone");
            String email = request.getParameter("email");
            String address = request.getParameter("address");
            String note = request.getParameter("note");
        %>

        <div class="layout-container">
            <jsp:include page="/include/sidebar.jsp" />
            <div class="main-content">
                <div class="form-container">
                    <h1>Update Supplier</h1>
                    <c:set var="mess" value="${requestScope.mess}" />
                    <c:set var="invalidPhone" value="${requestScope.invalidPhone}"/>
                    <c:set var="invalidEmail" value="${requestScope.invalidEmail}"/>
                    <c:if test="${not empty mess}">
                        <div class="error-message" style="color: green">${mess}</div>
                    </c:if>
                    <form action="UpdateSupplier" method="get">
                        <input type="hidden" name="id" value="<%=id%>">
                        <label for="name">Tên nhà cung cấp:</label>
                        <input type="text" id="name" name="name" value="<%= name %>" required>

                        <label for="phone">Số điện thoại:</label>
                        <c:if test="${not empty invalidPhone}">
                            <label style="color: red" >${invalidPhone}</label>
                        </c:if>
                        <input type="number" id="phone" name="phone" value="<%= phone %>" required>

                        <label for="email">Email:</label>
                        <c:if test="${not empty invalidEmail}">
                            <label style="color: red" >${invalidEmail}</label>
                        </c:if>
                        <input type="email" id="email" name="email" value="<%= email %>" required>

                        <label for="address">Địa chỉ:</label>
                        <input type="text" id="address" name="address" value="<%= address %>" required>

                        <label for="note">Ghi chú:</label>
                        <input type="text" id="note" name="note" value="<%= note %>">

                        <input type="submit" value="Cập nhật">
                    </form>
                    <div style="text-align: center;">
                        <a href="LishSupplier" class="back-link">← Back</a>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
