<%-- 
    Document   : reset_user_password
    Created on : 6 thg 7, 2025, 10:12:12
    Author     : phucn
--%>

<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@page import="model.ForgotPasswordRequest, model.Users"%>
<%
    String msg = (String) request.getAttribute("msg");
    ForgotPasswordRequest req = (ForgotPasswordRequest) request.getAttribute("resetRequest");
    Users targetUser = (Users) request.getAttribute("targetUser");
%>
<!DOCTYPE html>
<html>
    <head>
        <title>Cập nhật mật khẩu người dùng</title>
        <meta charset="UTF-8">
        <style>
            body {
                background: #f5f8fb;
                font-family: Arial, sans-serif;
            }
            .pw-reset-container {
                max-width: 430px;
                margin: 44px auto;
                background: #fff;
                border-radius: 13px;
                box-shadow: 0 2px 14px rgba(0,0,0,0.09);
                padding: 38px 32px 28px 32px;
            }
            h2 {
                text-align: center;
                color: #1976d2;
                margin-bottom: 25px;
            }
            .info-row {
                margin-bottom: 16px;
                color: #222;
            }
            .info-label {
                font-weight: bold;
                color: #2977c8;
            }
            .form-group {
                margin-bottom: 18px;
            }
            input[type=password] {
                width: 100%;
                padding: 10px 13px;
                border-radius: 6px;
                border: 1px solid #b3cee7;
                font-size: 1.08rem;
                box-sizing: border-box;
                margin-top:6px;
            }
            button[type=submit] {
                background: #1976d2;
                color: #fff;
                padding: 12px 0;
                width: 100%;
                border-radius: 7px;
                border: none;
                font-size: 1.13rem;
                font-weight: bold;
                cursor: pointer;
                margin-top: 8px;
                transition: background 0.16s;
            }
            button[type=submit]:hover {
                background: #145a96;
            }
            .back-link {
                display: block;
                text-align: center;
                margin: 22px 0 0 0;
                color: #1976d2;
                text-decoration: none;
            }
            .back-link:hover {
                text-decoration: underline;
            }
            .msg-success {
                background: #e8f5e9;
                color: #127021;
                border:1px solid #b0dfbb;
                border-radius:6px;
                padding: 10px;
                text-align:center;
                margin-bottom:14px;
            }
            .msg-error {
                background: #fdecea;
                color: #c0392b;
                border:1px solid #f7b2b2;
                border-radius:6px;
                padding: 10px;
                text-align:center;
                margin-bottom:14px;
            }
        </style>
    </head>
    <body>
        <div class="pw-reset-container">
            <h2>Cập nhật mật khẩu mới</h2>
            <c:if test="${not empty msg}">
                <div class="${msg.contains('thành công') ? 'msg-success' : 'msg-error'}">${msg}</div>
            </c:if>
            <% if (msg != null && !msg.trim().isEmpty()) { %>
            <div class="<%= msg.contains("thành công") ? "msg-success" : "msg-error" %>"><%= msg %></div>
            <% } %>
            <% if (req != null && targetUser != null) { %>
            <div class="info-row"><span class="info-label">Tên người dùng:</span> <%= targetUser.getFullname() %></div>
            <div class="info-row"><span class="info-label">Email:</span> <%= targetUser.getEmail() %></div>
            <div class="info-row"><span class="info-label">Lý do yêu cầu:</span> <%= req.getNote() != null ? req.getNote() : "(Không có ghi chú)" %></div>
            <form method="post" action="reset-user-password">
                <input type="hidden" name="reqId" value="<%= req.getId() %>">
                <input type="hidden" name="userId" value="<%= targetUser.getId() %>">
                <div class="form-group">
                    <label>Mật khẩu mới:</label>
                    <input type="password" name="newPassword" required minlength=" 7">
                </div>
                <div class="form-group">
                    <label>Nhập lại mật khẩu mới:</label>
                    <input type="password" name="confirmPassword" required minlength=" 7">
                </div>
                <button type="submit">Cập nhật & Duyệt yêu cầu</button>
            </form>
            <% } else { %>
            <div class="msg-error">Không tìm thấy thông tin yêu cầu hoặc người dùng!</div>
            <% } %>
            <a href="passwordrequest" class="back-link">Quay lại danh sách yêu cầu</a>
        </div>
    </body>
</html>

