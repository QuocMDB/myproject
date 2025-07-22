<%-- 
    Document   : LishSupplier
    Created on : 28 thg 5, 2025, 14:13:26
    Author     : Fpt06
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<%@ page import="model.Users" %> 
<%
Users user = (Users) session.getAttribute("user");
if (user == null) {
    response.sendRedirect("login.jsp");
    return;
}

%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Lish Supplier</title>
        <style>
            body {
                font-family: 'Segoe UI', Tahoma, sans-serif;
                background: linear-gradient(to right, #cfd9df, #e2ebf0);
                margin: 0;
                padding: 30px;
                animation: fadeIn 1s ease-in-out;
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

            .LishHead {
                background: linear-gradient(to right, #ffffff, #f0f8ff);
                padding: 30px;
                margin-bottom: 30px;
                border-radius: 10px;
                box-shadow: 0 6px 18px rgba(0, 0, 0, 0.1);
                text-align: center;
                animation: slideDown 0.8s ease;
            }

            @keyframes slideDown {
                from {
                    transform: translateY(-20px);
                    opacity: 0;
                }
                to {
                    transform: translateY(0);
                    opacity: 1;
                }
            }

            .LishHead h1 {
                margin-bottom: 20px;
                color: #0d6efd;
            }

            .LishHead input[type="text"] {
                padding: 10px;
                width: 280px;
                border: 1px solid #ccc;
                border-radius: 6px;
                margin-right: 10px;
                transition: box-shadow 0.3s;
            }
            .LishHead input[type="text"]:focus {
                box-shadow: 0 0 5px #007bff;
                outline: none;
            }

            .LishHead input[type="submit"] {
                padding: 10px 20px;
                background-color: #007bff;
                color: white;
                border: none;
                border-radius: 6px;
                cursor: pointer;
                font-weight: bold;
                transition: background-color 0.3s, transform 0.2s;
            }
            .LishHead input[type="submit"]:hover {
                background-color: #0056b3;
                transform: scale(1.05);
            }

            .LishBody table {
                width: 100%;
                border-collapse: collapse;
                border-radius: 10px;
                overflow: hidden;
                box-shadow: 0 6px 15px rgba(0, 0, 0, 0.1);
                animation: fadeIn 1s ease;
                background: #ffffff;
            }

            .LishBody th {
                background-color: #007bff;
                color: white;
                font-weight: bold;
                text-align: center;
            }

            .LishBody td {
                padding: 12px 14px;
                text-align: left;
                border-bottom: 1px solid #eee;
                background-color: #f8f9fa;
            }

            .LishBody tr:nth-child(even) td {
                background-color: #e9f7ff;
            }

            .LishBody tr:hover td {
                background-color: #d4edff;
            }

            .LishBody a {
                display: inline-block;
                padding: 6px 12px;
                margin: 2px;
                color: white;
                text-decoration: none;
                border-radius: 5px;
                font-weight: 500;
                transition: all 0.3s ease;
            }

            .LishBody a:nth-child(1) {
                background-color: #ffc107;
                border: 1px solid #e0a800;
                color: black;
            }
            .LishBody a:nth-child(1):hover {
                background-color: purple;
                transform: scale(1.05);
            }

            .LishBody a:nth-child(2) {
                background-color: #dc3545;
                border: 1px solid #bd2130;
            }
            .LishBody a:nth-child(2):hover {
                background-color: purple;
                transform: scale(1.05);
            }

            .LishBody a:nth-child(3) {
                background-color: green;
                border: 1px solid #bd2130;
                color: yellow;
            }
            .LishBody a:nth-child(3):hover {
                background-color: purple;
                transform: scale(1.05);
            }

            .LishHead a[href="AddNewSupplier.jsp"],
            .but {
                display: inline-block;
                margin-top: 20px;
                color: #007bff;
                border: 1px solid #007bff;
                padding: 8px 16px;
                border-radius: 6px;
                text-decoration: none;
                font-weight: 500;
                transition: all 0.3s ease;
            }
            .LishHead a[href="AddNewSupplier.jsp"]:hover,
            .but:hover {
                background-color: #007bff;
                color: white;
                transform: translateY(-2px);
            }
            .pagination-container {
                text-align: center;
                margin-top: 20px;
            }

            .pagination-link {
                display: inline-block;
                margin: 0 4px;
                padding: 8px 14px;
                background-color: #f0f0f0;
                border-radius: 6px;
                border: 1px solid #ccc;
                color: #333;
                text-decoration: none;
                transition: all 0.3s ease;
            }

            .pagination-link:hover {
                background-color: #007bff;
                color: white;
            }

            .pagination-link.active-page {
                background-color: #007bff;
                color: white;
                font-weight: bold;
                border-color: #0056b3;
            }

            .filter{
                height: 35px;
                width: 100px;
            }
            /* CSS cải thiện cho các nút action trong bảng */
            .action-container {
                display: flex;
                flex-direction: column;
                gap: 6px;
                align-items: stretch;
                min-width: 140px;
                padding: 8px 4px;
            }

            .action-btn {
                display: inline-flex;
                align-items: center;
                justify-content: center;
                padding: 8px 16px;
                min-width: 100px;
                height: 36px;
                text-align: center;
                text-decoration: none;
                border-radius: 6px;
                font-weight: 500;
                font-size: 13px;
                transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                border: 1px solid transparent;
                cursor: pointer;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                position: relative;
                overflow: hidden;
            }

            .action-btn::before {
                content: '';
                position: absolute;
                top: 0;
                left: -100%;
                width: 100%;
                height: 100%;
                background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.3), transparent);
                transition: left 0.5s;
            }

            .action-btn:hover::before {
                left: 100%;
            }

            /* Nút Edit - màu vàng cam gradient */
            .btn-edit {
                background: linear-gradient(135deg, #ffc107, #ff8f00);
                color: #212529;
                border-color: #ffc107;
                box-shadow: 0 2px 8px rgba(255, 193, 7, 0.3);
            }

            .btn-edit:hover {
                background: linear-gradient(135deg, #e0a800, #f57c00);
                color: white;
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(255, 193, 7, 0.4);
            }

            /* Nút Delete - màu đỏ gradient */
            .btn-delete {
                background: linear-gradient(135deg, #dc3545, #c82333);
                color: white;
                border-color: #dc3545;
                box-shadow: 0 2px 8px rgba(220, 53, 69, 0.3);
            }

            .btn-delete:hover {
                background: linear-gradient(135deg, #c82333, #bd2130);
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(220, 53, 69, 0.4);
            }

            /* Nút Active - màu xanh lá gradient */
            .btn-active {
                background: linear-gradient(135deg, #28a745, #20c997);
                color: white;
                border-color: #28a745;
                box-shadow: 0 2px 8px rgba(40, 167, 69, 0.3);
            }

            .btn-active:hover {
                background: linear-gradient(135deg, #218838, #1e7e34);
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(40, 167, 69, 0.4);
            }

            /* Nút Evaluation - màu xanh dương gradient */
            .btn-evaluation {
                background: linear-gradient(135deg, #17a2b8, #138496);
                color: white;
                border-color: #17a2b8;
                box-shadow: 0 2px 8px rgba(23, 162, 184, 0.3);
            }

            .btn-evaluation:hover {
                background: linear-gradient(135deg, #138496, #117a8b);
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(23, 162, 184, 0.4);
            }

            /* Nút View evaluation - màu tím gradient */
            .btn-view {
                background: linear-gradient(135deg, #6f42c1, #5a32a3);
                color: white;
                border-color: #6f42c1;
                box-shadow: 0 2px 8px rgba(111, 66, 193, 0.3);
            }

            .btn-view:hover {
                background: linear-gradient(135deg, #5a32a3, #4e2a87);
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(111, 66, 193, 0.4);
            }

            /* Responsive design cho mobile */
            @media (max-width: 768px) {
                .action-container {
                    min-width: 120px;
                }

                .action-btn {
                    min-width: 80px;
                    padding: 6px 12px;
                    font-size: 12px;
                    height: 32px;
                }
            }

            /* Cải thiện cho table cell chứa action buttons */
            .LishBody td.action-cell {
                padding: 12px 8px;
                vertical-align: middle;
                background-color: #f8f9fa !important;
            }

            .LishBody tr:nth-child(even) td.action-cell {
                background-color: #e9f7ff !important;
            }

            .LishBody tr:hover td.action-cell {
                background-color: #d4edff !important;
            }

            /* Animation cho loading state */
            .action-btn:active {
                transform: scale(0.95);
                transition: transform 0.1s;
            }

            /* Tooltip effect (optional) */
            .action-btn[title]:hover::after {
                content: attr(title);
                position: absolute;
                bottom: 100%;
                left: 50%;
                transform: translateX(-50%);
                background: rgba(0, 0, 0, 0.8);
                color: white;
                padding: 4px 8px;
                border-radius: 4px;
                font-size: 11px;
                white-space: nowrap;
                z-index: 1000;
                margin-bottom: 5px;
            }

            /* Icon support (nếu muốn thêm icon) */
            .action-btn i {
                margin-right: 6px;
                font-size: 14px;
            }

            /* Trạng thái disabled */
            .action-btn:disabled,
            .action-btn.disabled {
                opacity: 0.6;
                cursor: not-allowed;
                transform: none !important;
                box-shadow: none !important;
            }

            .action-btn:disabled:hover,
            .action-btn.disabled:hover {
                transform: none;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
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
            /* Container chứa các nút option chia làm 2 hàng 2 cột */
            .action-container {
                display: grid;
                grid-template-columns: repeat(2, 1fr);
                gap: 8px;
                justify-items: center;
                align-items: center;
                padding: 8px 0;
            }

            /* Nút nhỏ gọn & đồng đều */
            .action-btn {
                padding: 6px 12px;
                font-size: 13px;
                width: 100px;
                height: 34px;
                border-radius: 5px;
                font-weight: 600;
                text-align: center;
                white-space: nowrap;
                transition: all 0.2s ease;
                box-shadow: 0 1px 2px rgba(0, 0, 0, 0.15);
                border: none;
            }

            /* Các màu nút giữ nguyên */
            .btn-edit {
                background: linear-gradient(135deg, #ffc107, #ff8f00);
                color: black;
            }
            .btn-delete {
                background: linear-gradient(135deg, #dc3545, #c82333);
                color: white;
            }
            .btn-active {
                background: linear-gradient(135deg, #28a745, #20c997);
                color: white;
            }
            .btn-evaluation {
                background: linear-gradient(135deg, #17a2b8, #138496);
                color: yellow;
            }
            .btn-view {
                background: linear-gradient(135deg, #6f42c1, #5a32a3);
                color: white;
            }
        </style>

    </head>
    <body>
        <div class="layout-container">
            <jsp:include page="/include/sidebar.jsp" />
            <div class="main-content">
                <c:if test="${(user.roleName == 'Admin')||(user.roleName == 'Nhân viên kho')}"></c:if>
                <c:set var="currentPage" value="${requestScope.currentPage}"/>
                <c:set var="listSupplier" value="${listSupplier}" />
                <c:set var="option" value="${requestScope.filter}"/>
                <c:set var="status" value="${requestScope.status}"/>
                <c:set var="name" value="${requestScope.name}"/>
                <c:set var="line" value="${requestScope.line}"/>
                <c:set var="user" value="${sessionScope.user}" />

                <div class="LishHead">
                    <h1>List Supplier</h1>
                    <form action="SearchListSupplier">
                        <select class="filter" name="status">
                            <option value="all" ${status == 'all' ? 'selected="selected"' : ''}>All Status</option>
                            <option value="1" ${status == '1' ? 'selected="selected"' : ''}>Active</option>
                            <option value="0" ${status == '0' ? 'selected="selected"' : ''}>Inactive</option>
                        </select>
                        <select class="filter" name="line">
                            <option value="7" ${line == '7'?'selected=selected':''}>7 Line</option>
                            <option value="10" ${line == '10'?'selected=selected':''}>10 Line</option>
                            <option value="15" ${line == '15'?'selected=selected':''}>15 Line</option>
                        </select>
                        <input type="text"placeholder="Nhập Tên nhà cung cấp" value="${name}"  name="name">
                        <input type="submit" value="Search" name="name">
                    </form>
                    <c:if test="${(user.roleName == 'Admin')||(user.roleName == 'Nhân viên kho')}">
                        <a href="AddNewSupplier.jsp">+ Add new supplier</a>
                    </c:if>
                </div>
                <div class="LishBody">
                    <c:if test="${not empty listSupplier}">
                        <table border="1px solid">

                            <thead>
                            <th>ID</th>
                            <th>Name</th>
                            <th>Phone</th>
                            <th>Email</th>
                            <th>Address</th>
                            <th>Note</th>
                            <th>Status</th>
                            <th>Date Create</th>
                                <c:if test="${(user.roleName == 'Admin')||(user.roleName == 'Nhân viên kho')}">
                                <th style="text-align: center;">Option</th> 
                                </c:if>
                            </thead>
                            <c:forEach var="listItem" items="${listSupplier}">
                                <tr>
                                    <td>${listItem.supplierID}</td>
                                    <td>${listItem.name}</td>
                                    <td>${listItem.phone}</td>
                                    <td>${listItem.email}</td>
                                    <td>${listItem.address}</td>
                                    <td>${listItem.note}</td>
                                    <c:choose>
                                        <c:when test="${listItem.activeFlag == 1}">
                                            <td style="color: red;font-weight: bold">Active</td>
                                        </c:when>
                                        <c:otherwise>
                                            <td style="font-weight: bold">Inactive</td>
                                        </c:otherwise>
                                    </c:choose>
                                    <td>${listItem.createDate}</td> 
                                    <c:if test="${(user.roleName == 'Admin')||(user.roleName == 'Nhân viên kho')}">
                                        <td  class="option-cell" colspan="4" >
                                            <div class="action-container">

                                                <c:choose>
                                                    <c:when test="${listItem.activeFlag == 1}">
                                                        <a class="action-btn btn-edit" 
                                                           href="UpdateSupplier.jsp?id=${listItem.supplierID}&name=${listItem.name}&phone=${listItem.phone}&email=${listItem.email}&address=${listItem.address}&note=${listItem.note}">
                                                            Edit
                                                        </a>
                                                        <a class="action-btn btn-delete" 
                                                           href="DeleteSupplier?id=${listItem.supplierID}&filter=${option}&status=${status}&name=${name}&line=${line}&currentPage=${currentPage}" 
                                                           onclick="return confirm('Bạn có chắc chắn muốn xoá nhà cung cấp này không?')">
                                                            Delete
                                                        </a>
                                                        <a class="action-btn btn-evaluation"
                                                           href="TableSupplierEvaluation?id=${listItem.supplierID}">
                                                            Evaluation
                                                        </a>
                                                        <a class="action-btn btn-view"
                                                           href="ViewSupplierEvaluation?supplierID=${listItem.supplierID}">
                                                            View evaluation
                                                        </a>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <a class="action-btn btn-active"
                                                           href="ActiveSupplier?id=${listItem.supplierID}&filter=${option}&status=${status}&name=${name}&line=${line}"
                                                           onclick="return confirm('Bạn có chắc chắn muốn active nhà cung cấp này không?')">
                                                            Active
                                                        </a>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </td>
                                    </c:if>

                                </tr>
                            </c:forEach>
                        </table>
                    </c:if>
                </div>
                <c:if test="${empty option }">
                    <c:if test="${totalPages > 1}">
                        <div class="pagination-container">
                            <c:forEach var="i" begin="1" end="${totalPages}">
                                <a class="pagination-link ${i == currentPage ? 'active-page' : ''}" 
                                   href="LishSupplier?page=${i}">${i}</a>
                            </c:forEach>
                        </div>
                    </c:if>
                </c:if>
                <c:if test="${not empty option}">
                    <c:if test="${totalPages > 1}">
                        <div class="pagination-container">
                            <c:forEach var="i" begin="1" end="${totalPages}">
                                <a class="pagination-link ${i == currentPage ? 'active-page' : ''}" 
                                   href="SearchListSupplier?status=${status}&name=${name}&line=${line}&page=${i}">${i}</a>
                            </c:forEach>
                        </div>
                    </c:if>
                </c:if>
                <a class="but" href="categoriesforward.jsp">Back</a>
            </div>
        </div>
    </body>
</html>
