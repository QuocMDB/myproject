<%-- 
    Document   : login
    Created on : 19 thg 5, 2025, 22:07:13
    Author     : phucn
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đăng Nhập</title>
    <style>
        body {
            background: linear-gradient(135deg, #fdfbfb, #ebedee);
            font-family: Arial, sans-serif;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .login-container {
            width: 400px;
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }

        .card-header {
            background-color: #007bff;
            color: #fff;
            text-align: center;
            font-size: 1.5rem;
            padding: 20px;
        }

        .card-body {
            padding: 20px;
        }

        .form-group {
            margin-bottom: 15px;
            padding: 0 10px;
        }

        .card-body {
            padding: 20px;
        }

        input[type="text"], input[type="password"] {
            width: 100%;
            padding: 10px 15px;
            border-radius: 20px;
            border: 1px solid #ccc;
            font-size: 1rem;
            box-sizing: border-box; /* rất quan trọng */
        }


        .btn {
            width: 100%;
            padding: 10px;
            border: none;
            border-radius: 20px;
            background-color: #007bff;
            color: white;
            font-size: 1rem;
            cursor: pointer;
        }

        .btn:hover {
            background-color: lightskyblue;
        }

        .card-footer {
            background-color: #f1f1f1;
            text-align: center;
            padding: 15px;
            font-size: 0.9rem;
        }

        .card-footer a {
            color: green;
            text-decoration: none;
        }

        .alert {
            margin-top: 15px;
            padding: 10px;
            border-radius: 5px;
            color: #721c24;
            background-color: #f8d7da;
            border: 1px solid #f5c6cb;
            font-size: 0.95rem;
        }
    </style>
</head>
<body>
<div class="login-container">
    <div class="card-header">
        System Login
    </div>
    <div class="card-body">
        <form action="login" method="POST">
            <div class="form-group">
                <input type="text" placeholder="User Name" id="username" name="username" required>
            </div>
            <div class="form-group">
                <input type="password" placeholder="Password" id="password" name="password" required>
            </div>
            <button type="submit" class="btn">Log in</button>
        </form>

        <%
            String errorMessage = (String) request.getAttribute("error");
            if (errorMessage != null) {
        %>
        <div class="alert"><%= errorMessage %></div>
        <%
            }
        %>
    </div>
    <div class="card-footer">
        <a href="forgot.jsp">Forgot?</a>
    </div>
</div>
</body>
</html>