<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!-- Material Unit List Page: Displays, searches, filters, and manages material units -->
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
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đơn vị vật tư</title>
    <style>
        body {
            background: #f6f8fa;
            font-family: 'Segoe UI', Arial, sans-serif;
            margin: 0;
            padding: 0;
        }
        .container {
            max-width: 950px;
            background: #fff;
            margin: 40px auto 0 auto;
            padding: 32px 28px 28px 28px;
            border-radius: 12px;
            box-shadow: 0 4px 24px rgba(0,0,0,0.08);
        }
        h1 {
            color: #222;
            margin-bottom: 28px;
            font-size: 2.1rem;
            letter-spacing: 1px;
            text-align: center;
        }
        .form-group {
            margin-bottom: 18px;
        }
        .form-group label {
            display: block;
            margin-bottom: 6px;
            font-weight: 600;
            color: #444;
        }
        .form-group input[type="text"],
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #cfd8dc;
            border-radius: 5px;
            box-sizing: border-box;
            font-size: 1rem;
            background: #f9fafb;
            transition: border 0.2s;
        }
        .form-group input[type="text"]:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            border: 1.5px solid #4CAF50;
            outline: none;
            background: #fff;
        }
        .form-buttons {
            margin-top: 22px;
        }
        .btn-primary {
            display: inline-block;
            background: linear-gradient(90deg, #4CAF50 80%, #388e3c 100%);
            color: #fff;
            padding: 9px 22px;
            text-decoration: none;
            border-radius: 5px;
            border: none;
            cursor: pointer;
            font-weight: 600;
            font-size: 1rem;
            box-shadow: 0 2px 8px rgba(76,175,80,0.08);
            transition: background 0.2s, box-shadow 0.2s;
        }
        .btn-primary:hover {
            background: linear-gradient(90deg, #388e3c 80%, #4CAF50 100%);
            box-shadow: 0 4px 16px rgba(76,175,80,0.13);
        }
        .btn-secondary {
            display: inline-block;
            background: #f44336;
            color: #fff;
            padding: 9px 22px;
            text-decoration: none;
            border-radius: 5px;
            margin-left: 10px;
            border: none;
            cursor: pointer;
            font-weight: 600;
            font-size: 1rem;
            transition: background 0.2s;
        }
        .btn-secondary:hover {
            background: #d32f2f;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 24px;
            background: #fff;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0,0,0,0.04);
        }
        table, th, td {
            border: 1px solid #e0e0e0;
        }
        th, td {
            padding: 14px 10px;
            text-align: left;
            font-size: 1rem;
        }
        th {
            background: #f2f2f2;
            font-weight: 700;
            color: #333;
            cursor: pointer;
            user-select: none;
            transition: background 0.2s;
        }
        th:hover {
            background: #e0f2f1;
        }
        tr:nth-child(even) {
            background: #f9f9f9;
        }
        tr:hover {
            background: #e3f2fd;
        }
        .btn-edit {
            display: inline-block;
            background: #2196F3;
            color: #fff;
            padding: 6px 14px;
            text-decoration: none;
            border-radius: 4px;
            margin-right: 6px;
            border: none;
            font-size: 0.97rem;
            font-weight: 500;
            cursor: pointer;
            transition: background 0.2s;
        }
        .btn-edit:hover {
            background: #1565c0;
        }
        .btn-delete {
            background: #ff4444;
            border: none;
        }
        .btn-delete:hover {
            background: #b71c1c;
        }
        .status-button {
            padding: 6px 12px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            margin-right: 5px;
        }
        .active-button {
            background: #4CAF50;
            color: #fff;
        }
        .inactive-button {
            background: #f44336;
            color: #fff;
        }
        .disabled-button {
            opacity: 0.5;
            cursor: not-allowed;
            background: #bdbdbd !important;
        }
        .disabled-button:hover {
            background: #bdbdbd !important;
        }
        .status-active {
            color: #4CAF50;
            font-weight: bold;
        }
        .status-inactive {
            color: #f44336;
            font-weight: bold;
        }
        .btn-activate {
            background: #4CAF50;
            color: white;
        }
        .btn-activate:hover {
            background: #388e3c;
        }
        .btn-deactivate {
            background: #ff9800;
            color: white;
        }
        .btn-deactivate:hover {
            background: #f57c00;
        }
        .search-container {
            margin-bottom: 24px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 12px;
            flex-wrap: wrap;
        }
        #searchInput {
            padding: 10px;
            width: 260px;
            border: 1px solid #cfd8dc;
            border-radius: 5px;
            font-size: 1rem;
            background: #f9fafb;
            transition: border 0.2s;
        }
        #searchInput:focus {
            border: 1.5px solid #4CAF50;
            background: #fff;
        }
        #typeFilter {
            padding: 10px;
            border: 1px solid #cfd8dc;
            border-radius: 5px;
            width: 180px;
            font-size: 1rem;
            background: #f9fafb;
            transition: border 0.2s;
        }
        #typeFilter:focus {
            border: 1.5px solid #4CAF50;
            background: #fff;
        }
        .search-form {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .no-data {
            text-align: center;
            padding: 24px;
            font-style: italic;
            color: #757575;
            background: #f9f9f9;
        }
        .pagination {
            text-align: center;
            margin-top: 28px;
        }
        .pagination a, .pagination span.page-number {
            display: inline-block;
            padding: 9px 18px;
            margin: 0 6px;
            background: #007BFF;
            color: #fff;
            text-decoration: none;
            border-radius: 6px;
            font-weight: 600;
            font-size: 1rem;
            transition: background 0.2s;
        }
        .pagination a:hover {
            background: #0056b3;
        }
        .pagination span.page-number {
            background: #6c757d;
            cursor: default;
        }
        .error-message {
            color: #d32f2f;
            background: #ffebee;
            border: 1px solid #ffcdd2;
            padding: 10px 16px;
            border-radius: 5px;
            margin-bottom: 18px;
            text-align: center;
        }
        .success-message {
            color: #388e3c;
            background: #e8f5e9;
            border: 1px solid #c8e6c9;
            padding: 10px 16px;
            border-radius: 5px;
            margin-bottom: 18px;
            text-align: center;
        }
        @media (max-width: 700px) {
            .container {
                padding: 10px 2vw;
            }
            .search-container {
                flex-direction: column;
                align-items: stretch;
                gap: 10px;
            }
            table, th, td {
                font-size: 0.95rem;
            }
            .btn-primary, .btn-secondary {
                width: 100%;
                margin: 8px 0 0 0;
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
                    <h1 class="page-title">Quản lí đơn vị vật tư</h1>
                    <div class="header-user">
                        <label class="label"><%= user.getFullname()%></label>
                        <a href="../logout" class="logout-btn">Đăng xuất</a>
                    </div>
                </div>
        
        <!-- Hiển thị thông báo lỗi nếu có -->
        <c:if test="${not empty errorMessage}">
            <div class="error-message">${errorMessage}</div>
        </c:if>
        
        <!-- Hiển thị thông báo thành công nếu có -->
        <c:if test="${not empty successMessage}">
            <div class="success-message">${successMessage}</div>
            <c:remove var="successMessage" scope="session"/>
        </c:if>
        
        <!-- Thanh tìm kiếm và nút tạo mới -->
        <div class="search-container">
            <form method="get" action="materialUnit" class="search-form">
                <input type="hidden" name="action" value="search" />
                <input type="text" id="searchInput" name="searchTerm" placeholder="Tên, kí hiệu,..." value="${searchTerm}" />
                <button type="submit" class="btn-primary">Tìm kiếm</button>
            </form>
            <select id="statusFilter" onchange="filterByStatus(this.value)">
                <option value="all">Tất cả trạng thái</option>
                <option value="active">Hoạt động</option>
                <option value="inactive">Ngừng hoạt động</option>
            </select>
            <a href="createMaterialUnit" class="btn-primary">Thêm đơn vị mới</a>
            <a href="../unit-statistics" class="btn-primary" style="background: #17a2b8; margin-left: 10px;">📊 Thống Kê Đơn Vị</a>
        </div>

        <script>
        function filterByStatus(status) {
            var table = document.getElementById("materialUnitTable");
            var tr = table.getElementsByTagName("tr");
            for (var i = 1; i < tr.length; i++) {
                var statusCell = tr[i].getElementsByTagName("td")[4];
                if (statusCell) {
                    var statusText = statusCell.textContent || statusCell.innerText;
                    if (status === 'all' || 
                        (status === 'active' && statusText === 'Hoạt động') ||
                        (status === 'inactive' && statusText === 'Ngừng hoạt động')) {
                        tr[i].style.display = "";
                    } else {
                        tr[i].style.display = "none";
                    }
                }
            }
        }
        
        function toggleUnitStatus(unitId, currentStatus) {
            if (currentStatus == 1) {
                // Deactivating - show options
                if (confirm('Bạn có muốn ngừng hoạt động đơn vị này không?')) {
                    // After deactivation, ask if user wants to delete
                    if (confirm('Đơn vị đã được ngừng hoạt động. Bạn có muốn xóa đơn vị này luôn không?')) {
                        // Redirect to deactivate and then delete
                        window.location.href = 'deactivateMaterialUnit?id=' + unitId + '&deleteAfter=true';
                    } else {
                        // Just deactivate
                        window.location.href = 'deactivateMaterialUnit?id=' + unitId;
                    }
                }
            } else {
                // Activating
                if (confirm('Bạn có muốn kích hoạt đơn vị này không?')) {
                    window.location.href = 'activateMaterialUnit?id=' + unitId;
                }
            }
        }
        
        function deleteUnit(unitId, canDelete) {
            if (!canDelete) {
                alert('Không thể xóa đơn vị đang được sử dụng. Vui lòng ngừng hoạt động đơn vị trước, sau đó chọn xóa khi ngừng hoạt động.');
                return;
            }
            
            if (confirm('Bạn có muốn xóa đơn vị này không?')) {
                window.location.href = 'deleteMaterialUnit?id=' + unitId;
            }
        }
        function sortTable(n) {
            var table, rows, switching, i, x, y, shouldSwitch, dir, switchcount = 0;
            table = document.getElementById("materialUnitTable");
            switching = true;
            dir = "asc";
            while (switching) {
                switching = false;
                rows = table.rows;
                for (i = 1; i < (rows.length - 1); i++) {
                    shouldSwitch = false;
                    x = rows[i].getElementsByTagName("td")[n];
                    y = rows[i + 1].getElementsByTagName("td")[n];
                    if (dir == "asc") {
                        if (x.innerHTML.toLowerCase() > y.innerHTML.toLowerCase()) {
                            shouldSwitch = true;
                            break;
                        }
                    } else if (dir == "desc") {
                        if (x.innerHTML.toLowerCase() < y.innerHTML.toLowerCase()) {
                            shouldSwitch = true;
                            break;
                        }
                    }
                }
                if (shouldSwitch) {
                    rows[i].parentNode.insertBefore(rows[i + 1], rows[i]);
                    switching = true;
                    switchcount++;
                } else {
                    if (switchcount == 0 && dir == "asc") {
                        dir = "desc";
                        switching = true;
                    }
                }
            }
            var headers = table.getElementsByTagName("th");
            for (i = 0; i < headers.length; i++) {
                headers[i].className = headers[i].className.replace(" asc desc", "");
            }
            headers[n].className += " " + dir;
        } 
        </script>

        <!-- Bảng hiển thị dữ liệu -->
        <table id="materialUnitTable">
            <thead>
                <tr>
                    <th onclick="sortTable(0)">ID ↕</th>
                    <th onclick="sortTable(1)">Tên ↕</th>
                    <th onclick="sortTable(2)">Kí hiệu ↕</th>
                    <th onclick="sortTable(3)">Mô tả ↕</th>
                    <th onclick="sortTable(4)">Trạng thái ↕</th>
                    <th>Thao tác</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty materialUnits}">
                        <tr>
                            <td colspan="6" class="no-data">Không tìm thấy đơn vị nào.</td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="unit" items="${materialUnits}">
                            <tr>
                                <td>${unit.id}</td>
                                <td>${unit.name}</td>
                                <td>${unit.symbol}</td>
                                <td>${unit.description}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${unit.status == 1}">
                                            <span class="status-active">Hoạt động</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-inactive">Ngừng hoạt động</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <a href="editMaterialUnit?id=${unit.id}" class="btn-edit">Thay đổi</a>
                                    <c:choose>
                                        <c:when test="${unit.status == 1}">
                                            <button onclick="toggleUnitStatus(${unit.id}, ${unit.status})" class="btn-edit btn-deactivate">Ngừng hoạt động</button>
                                        </c:when>
                                        <c:otherwise>
                                            <button onclick="toggleUnitStatus(${unit.id}, ${unit.status})" class="btn-edit btn-activate">Kích hoạt</button>
                                            <!-- Show delete option for inactive units -->
                                            <button onclick="deleteUnit(${unit.id}, true)" class="btn-edit btn-delete">Xóa</button>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
   
<!-- Pagination at the very bottom -->


<c:if test="${requestScope.totalPages > 1}">
<div class="pagination">
    <c:choose>
        <c:when test="${requestScope.currentPage gt 1}">
            <a href="materialUnit?page=${requestScope.currentPage - 1}&action=${param.action}&searchTerm=${searchTerm}">Trước</a>
        </c:when>
    </c:choose>

    <span class="page-number">
        Trang ${requestScope.currentPage} / ${requestScope.totalPages}
    </span>

    <c:choose>
        <c:when test="${requestScope.currentPage lt requestScope.totalPages}">
            <a href="materialUnit?page=${requestScope.currentPage + 1}&action=${param.action}&searchTerm=${searchTerm}">Sau</a>
        </c:when>
    </c:choose>
</div>
</c:if>
<div style="text-align: center; margin-top: 30px;">
    <a href="../categoriesforward.jsp" class="btn-primary" style="background: #6c757d;">Quay lại trang trước</a>
</div>
    </div>
                </div>
</body>
</html>