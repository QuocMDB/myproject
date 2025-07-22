<%-- 
    Document   : forgot
    Created on : 19 thg 5, 2025, 22:57:15
    Author     : phucn
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String msg = null;
    if (session != null && session.getAttribute("msg") != null) {
        msg = (String) session.getAttribute("msg");
        session.removeAttribute("msg");
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <title>Yêu cầu Reset Mật Khẩu</title>
        <style>
            body {
                background: #f3f6fb;
                font-family: Arial, sans-serif;
            }
            .container {
                width: 370px;
                margin: 100px auto;
                padding: 32px 28px;
                background: #fff;
                border-radius: 12px;
                box-shadow: 0 2px 16px rgba(0,0,0,0.08);
            }
            h2 {
                margin-bottom: 24px;
                text-align: center;
                color: #1e3a5c;
            }
            label {
                font-size: 16px;
                color: #2b2b2b;
            }
            input[type="email"], textarea {
                width: 100%;
                padding: 8px 10px;
                margin-top: 10px;
                margin-bottom: 22px;
                border: 1px solid #b4bed2;
                border-radius: 7px;
                font-size: 15px;
            }
            textarea {
                resize: vertical;
                min-height: 50px;
            }
            button {
                margin-top: 15px;
                width: 100%;
                padding: 14px;
                background-color: #3498db;
                border: none;
                border-radius: 5px;
                color: white;
                font-size: 1.18rem;
                cursor: pointer;
            }
            .pw-link {
                display: inline-block;
                margin: 22px 7px 0 0;
                text-decoration: none;
                color: #fff;
                background: #3498db;
                padding: 9px 22px;
                border-radius: 5px;
                font-weight: bold;
                transition: background 0.18s;
            }
            .pw-link {
                background: #e74c3c;
            }
            
            back {
                margin-top: 15px;
                width: 100%;
                padding: 14px;
                background-color: #3498db;
                border: none;
                border-radius: 5px;
                color: white;
                font-size: 1.18rem;
                cursor: pointer;
            }

            .msg {
                text-align: center;
                margin-top: 10px;
                color: #148e08;
                font-size: 15px;
                min-height: 20px;
            }
            .msg.err {
                color: #c71e1e;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h2>Yêu cầu Reset Mật Khẩu</h2>
            <form action="forgotpassword" method="post">
                <label for="email">Email của bạn</label>
                <input type="email" id="email" name="email" placeholder="Nhập email của bạn">
                <label for="note">Lý do đổi mật khẩu</label>
                <textarea id="note" name="note" placeholder="Nhập lý do đổi mật khẩu..."></textarea>
                <button type="submit">Gửi yêu cầu</button>
                <div class="back" style="text-align: center;">
                    <a href="javascript:window.history.back()" class="pw-link">Quay lại</a>

                </div>
            </form>
            <div class="msg<%= (msg != null && msg.contains("không")) ? " err" : "" %>">
                <%= (msg != null) ? msg : "" %>
            </div>
        </div>
    </body>
</html>
