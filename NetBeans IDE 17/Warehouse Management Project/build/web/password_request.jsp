<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="java.util.List" %>
<%@ page import="model.ForgotPasswordRequest" %>
<%@ page import="model.Users" %>
<%
  Users user = (Users) session.getAttribute("user");
  if (user == null || !"Admin".equalsIgnoreCase(user.getRoleName())) {
      response.sendRedirect("login.jsp");
      return;
  }
  String msg = (String) request.getAttribute("msg");
  List<ForgotPasswordRequest> requests = (List<ForgotPasswordRequest>) request.getAttribute("requests");
%>
<!DOCTYPE html>
<html>
    <head>
        <title>Quản lý yêu cầu reset mật khẩu</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <style>
            body {
                font-family: 'Segoe UI', 'Roboto', 'Helvetica Neue', Arial, sans-serif;
                background: #f0f4f8;
                color: #222;
                margin: 0;
                padding: 0;
            }
            .pw-layout-container {
                display: flex;
                min-height: 100vh;
            }
            .pw-sidebar {
                position: fixed;
                top: 0;
                left: 0;
                width: 250px;
                height: 100vh;
                background: #e6f0fa;
                padding: 20px 0;
                border-right: 1px solid #d6e0ef;
                z-index: 100;
            }
            .pw-sidebar h2 {
                font-size: 1.4rem;
                color: #1567c1;
                text-align: center;
                margin-bottom: 20px;
            }
            .pw-nav-item {
                display: block;
                padding: 10px 20px;
                color: #214463;
                text-decoration: none;
                font-size: 1rem;
                transition: background .15s, color .15s;
            }
            .pw-nav-item:hover, .pw-nav-item.active {
                background: #c2e9fb;
                color: #1567c1;
            }
            .pw-container {
                margin-left: 250px;
                width: 100%;
                background: #fff;
                border-radius: 12px;
                box-shadow: 0 2px 18px rgba(0,0,0,.08);
                padding: 32px 24px;
                max-width: 1200px;
                min-height: 100vh;
            }
            .header {
                background: #fff;
                padding: 15px;
                border-bottom: 1px solid #d6e0ef;
                margin-bottom: 20px;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }
            .header-title {
                font-size: 1.8rem;
                color: #1567c1;
                margin: 0;
                display: flex;
                align-items: center;
            }
            .header-user {
                display: flex;
                align-items: center;
            }
            .user-name {
                font-size: 1rem;
                color: #214463;
                margin-right: 15px;
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
            .pw-alert-success {
                background: #e9fbe7;
                color: #127021;
                padding: 12px;
                border-radius: 6px;
                text-align: center;
                border: 1px solid #bbdfbe;
                margin-bottom: 17px;
            }
            .pw-alert-error {
                background: #fdecea;
                color: #c0392b;
                padding: 12px;
                border-radius: 6px;
                text-align: center;
                border: 1px solid #f7b2b2;
                margin-bottom: 17px;
            }
            .pw-count-info {
                font-weight: bold;
                margin-bottom: 14px;
                font-size: 16px;
                color: #333;
            }
            .pw-table-wrapper {
                overflow-x: auto;
            }
            .pw-table {
                width: 100%;
                min-width: 800px;
                border-collapse: collapse;
            }
            .pw-table th, .pw-table td {
                padding: 11px 10px;
                border-bottom: 1px solid #e5e7eb;
                vertical-align: middle;
            }
            .pw-table th {
                background: #e3f2fd;
                color: #1976d2;
                font-weight: bold;
            }
            .pw-table tr:hover {
                background: #f5faff;
            }
            .pw-status-pending {
                color: #ffc107;
                background: #fff8e1;
                padding: 3px 9px;
                border-radius: 5px;
                font-weight: bold;
            }
            .pw-status-approved {
                color: #27ae60;
                background: #e9f7ef;
                padding: 3px 9px;
                border-radius: 5px;
                font-weight: bold;
            }
            .pw-status-rejected {
                color: #c0392b;
                background: #fdecea;
                padding: 3px 9px;
                border-radius: 5px;
                font-weight: bold;
            }
            .pw-btn-approve, .pw-btn-reject {
                border: none;
                border-radius: 4px;
                padding: 7px 16px;
                font-size: 14px;
                color: #fff;
                font-weight: bold;
                cursor: pointer;
                margin-right: 4px;
                margin-bottom: 2px;
                transition: background .15s;
            }
            .pw-btn-approve {
                background: #27ae60;
            }
            .pw-btn-approve:hover {
                background: #219150;
            }
            .pw-btn-reject {
                background: #e74c3c;
            }
            .pw-btn-reject:hover {
                background: #c0392b;
            }
            .pw-no-data {
                text-align: center;
                color: #888;
                padding: 35px;
            }
            .pw-small {
                font-size: 13px;
                color: #6c757d;
                font-style: italic;
            }
            @media (max-width: 900px){
                .pw-container {
                    padding:12px;
                }
                .pw-table {
                    font-size:14px;
                }
                .pw-header-bar{
                    flex-direction:column;
                    gap:10px;
                }
            }
            @media (max-width: 700px){
                .pw-sidebar {
                    width: 90px;
                    padding: 9px 0;
                }
                .pw-container {
                    margin-left: 90px;
                }
                .pw-header-bar .pw-title {
                    font-size: 1.15rem;
                }
            }
        </style>
    </head>
    <body>
        <div class="pw-layout-container">
            <!-- Sidebar -->
            <div class="pw-sidebar">
                <h2>Warehouse Manager</h2>
                <a href="usermanager" class="pw-nav-item">Quản lý người dùng</a>
                <a href="role-permission" class="pw-nav-item">Phân quyền người dùng</a>
                <a href="categoriesforward.jsp" class="pw-nav-item">Thông tin vật tư</a>
                <a href="passwordrequest" class="pw-nav-item active">Reset mật khẩu</a>
                <a href="ApproveListForward.jsp" class="pw-nav-item">Đơn từ</a>
                <a href="RequestForward.jsp" class="pw-nav-item">Giao dịch</a>
                <a href="StatisticSupplierEvaluation.jsp" class="pw-nav-item">Thống kê</a>
            </div>
            <div class="pw-container">
                <div class="header">
                    <h1 class="header-title">Yêu cầu đổi mật khẩu</h1>
                    <div class="header-user">
                        <span class="user-name"><%= user.getFullname()%></span>
                        <a href="logout" class="logout-btn">Đăng xuất</a>
                    </div>
                </div>
                <%-- Thông báo --%>
                <% if (msg != null && !msg.trim().isEmpty()) { %>
                <div class="pw-<%= (msg.contains("lỗi") || msg.contains("thất bại")) ? "alert-error" : "alert-success" %>">
                    <%= msg %>
                </div>
                <% } %>
                <div class="pw-count-info">
                    Tổng số yêu cầu: <%= (requests != null ? requests.size() : 0) %>
                </div>
                <div class="pw-table-wrapper">
                    <table class="pw-table">
                        <thead>
                            <tr>
                                <th>STT</th>
                                <th>Tên người dùng</th>
                                <th>Email</th>
                                <th>Thời gian gửi</th>
                                <th>Lý do</th>
                                <th>Thời gian phản hồi</th>
                                <th>Trạng thái</th>
                                <th>Hành động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                if (requests != null && !requests.isEmpty()) {
                                    int stt = 1;
                                    for (ForgotPasswordRequest req : requests) {
                                        String statusClass = "pw-status-pending";
                                        String statusText = "Đang chờ";
                                        if ("approved".equalsIgnoreCase(req.getStatus())) {
                                            statusClass = "pw-status-approved";
                                            statusText = "Đã duyệt";
                                        } else if ("rejected".equalsIgnoreCase(req.getStatus())) {
                                            statusClass = "pw-status-rejected";
                                            statusText = "Đã từ chối";
                                        }
                            %>
                            <tr>
                                <td><%= stt++ %></td>
                                <td><%= req.getUsername() != null ? req.getUsername() : "N/A" %></td>
                                <td><%= req.getEmail() != null ? req.getEmail() : "N/A" %></td>
                                <td>
                                    <%= req.getRequestTime() != null ?
                                        new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(req.getRequestTime()) :
                                        "N/A" %>
                                </td>
                                <td><%= req.getNote() != null ? req.getNote() : "Không có ghi chú" %></td>
                                <td>
                                    <%= req.getResponseTime() != null ?
                                        new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(req.getResponseTime()) :
                                        "<span class='pw-small'>Chưa phản hồi</span>" %>
                                </td>
                                <td>
                                    <span class="<%= statusClass %>"><%= statusText %></span>
                                </td>
                                <td class="action-buttons">
                                    <% if (req.getResponseTime() == null) { %>
                                    <a href="reset-user-password?reqId=<%= req.getId() %>" 
                                       class="pw-btn-approve">
                                       Duyệt & Đổi mật khẩu
                                    </a>



                                    <form action="passwordrequest" method="post" style="display:inline-block;">
                                        <input type="hidden" name="reqId" value="<%= req.getId() %>">
                                        <button class="pw-btn-reject" name="action" value="reject" type="submit"
                                                onclick="return confirm('Bạn có chắc chắn muốn từ chối yêu cầu này?')">
                                            Từ chối
                                        </button>
                                    </form>
                                    <% } else { %>
                                    <span class="pw-small">Đã xử lý</span>
                                    <% } %>
                                </td>
                            </tr>
                            <%
                                    }
                                } else {
                            %>
                            <tr>
                                <td colspan="8" class="pw-no-data">
                                    Hiện tại không có yêu cầu reset mật khẩu nào!
                                </td>
                            </tr>
                            <%
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </body>
</html>