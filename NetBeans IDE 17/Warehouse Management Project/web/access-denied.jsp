<%-- 
    Document   : access-denied
    Created on : 3 thg 7, 2025, 22:44:29
    Author     : phucn
--%>

<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Không đủ quyền truy cập</title>
        <style>
            body {
                font-family: Arial;
                background: #f4f4f4;
            }
            .box {
                max-width: 500px;
                margin: 60px auto;
                padding: 30px 36px 22px 36px;
                background: white;
                border-radius: 10px;
                box-shadow: 0 2px 12px rgba(0,0,0,0.08);
                text-align: center;
            }
            .box h2 {
                color: #d32f2f;
                margin-bottom: 12px;
            }
            .box p {
                margin-bottom: 18px;
                color: #555;
            }
            .btn-back {
                display: inline-block;
                background: #3498db;
                color: white;
                text-decoration: none;
                padding: 10px 22px;
                border-radius: 5px;
                margin-top: 8px;
                font-size: 1rem;
            }
            .btn-back:hover {
                background: #1976d2;
            }
        </style>
    </head>
    <body>
        <div class="box">
            <c:if test="${not empty deniedFeature}">
                <p>Bạn không đủ quyền truy cập: ${deniedFeature}</p>
            </c:if>
            <p>Vui lòng liên hệ quản trị viên nếu bạn nghĩ đây là nhầm lẫn.</p>
            <a href="javascript:history.back()" class="btn-back">Quay lại</a>
        </div>
    </body>
</html>

