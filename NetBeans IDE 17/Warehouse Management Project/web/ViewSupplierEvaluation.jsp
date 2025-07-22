<%-- 
    Document   : ViewSupplierEvaluation
    Created on : 13 thg 6, 2025, 08:01:09
    Author     : Fpt06
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="model.Users" %> 
<%
Users user = (Users) session.getAttribute("user");
if (user == null || (!"Admin".equalsIgnoreCase(user.getRoleName())&&!"Nhân viên kho".equalsIgnoreCase(user.getRoleName()))) {
    response.sendRedirect("login.jsp");
    return;
}

%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>View Supplier Evaluation</title>
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }

            body {
                background-color: #f5f7fa;
                color: #333;
                line-height: 1.6;
                padding: 20px;
            }

            /* Supplier Info Container */
            .supplier-container {
                max-width: 900px;
                margin: 20px auto;
                background: white;
                border-radius: 12px;
                box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
                overflow: hidden;
                padding: 25px;
                border-top: 5px solid #3498db;
            }

            /* Comments Container */
            .comments-container {
                max-width: 900px;
                margin: 30px auto;
                background: white;
                border-radius: 12px;
                box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
                overflow: hidden;
                padding: 25px;
            }

            h2 {
                color: #2c3e50;
                font-size: 24px;
                font-weight: 600;
                margin-bottom: 20px;
                position: relative;
                padding-bottom: 10px;
            }

            h2:after {
                content: '';
                position: absolute;
                bottom: 0;
                left: 0;
                width: 100%;
                height: 3px;
                background: linear-gradient(to right, #e74c3c 0%, #3498db 50%, transparent 100%);
            }

            /* Supplier Info Table */
            .supplier-info {
                width: 100%;
                border-collapse: collapse;
            }

            .supplier-info td {
                padding: 12px 8px;
                border-bottom: 1px solid #eaeaea;
            }

            .supplier-info td:first-child {
                width: 120px;
                font-weight: 600;
                color: #16a085;
            }

            /* Comment Item */
            .comment-item {
                margin-bottom: 15px;
                border-left: 4px solid transparent;
                border-radius: 8px;
                overflow: hidden;
            }

            /* Comment Header */
            .comment-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 12px 15px;
                background-color: #f0f7ff;
            }

            /* User Info */
            .user-info {
                display: flex;
                align-items: center;
            }

            .username {
                color: #2c3e50;
                font-weight: 600;
                margin-right: 10px;
            }

            .rating {
                color: #f39c12;
                font-weight: 500;
            }

            /* Right Side Info */
            .comment-actions {
                display: flex;
                align-items: center;
            }

            .date {
                color: #7f8c8d;
                font-size: 0.9em;
                margin-right: 15px;
            }

            /* Edit Button */
            .edit-button {
                background-color: white;
                color: #e74c3c;
                border: 1px solid #e74c3c;
                border-radius: 20px;
                padding: 5px 15px;
                font-size: 14px;
                cursor: pointer;
                transition: all 0.2s ease;
                text-decoration: none;
                display: inline-block;
            }

            .edit-button:hover {
                background-color: #e74c3c;
                color: white;
            }

            .delete-button {
                background-color: red;
                color: #ffffff;
                border: 1px solid #e74c3c;
                border-radius: 20px;
                padding: 5px 15px;
                font-size: 14px;
                cursor: pointer;
                transition: all 0.2s ease;
                text-decoration: none;
                display: inline-block;
            }

            .delete-button:hover {
                background-color: #2980b9;
                color: white;
            }

            /* Comment Content */
            .comment-content {
                padding: 15px;
                background-color: #f9f9f9;
                line-height: 1.5;
            }

            /* Rating-based styles */
            .rating-5 {
                border-left-color: #4caf50;
            }

            .rating-5 .comment-header {
                background-color: #e8f5e9;
            }

            .rating-4 {
                border-left-color: #2196f3;
            }

            .rating-4 .comment-header {
                background-color: #e3f2fd;
            }

            .rating-3 {
                border-left-color: #ffc107;
            }

            .rating-3 .comment-header {
                background-color: #fff8e1;
            }

            .rating-2,
            .rating-1 {
                border-left-color: #f44336;
            }

            .rating-2 .comment-header,
            .rating-1 .comment-header {
                background-color: #ffebee;
            }

            @media (max-width: 768px) {
                .supplier-container,
                .comments-container {
                    padding: 15px;
                }

                .supplier-info td {
                    display: block;
                }

                .supplier-info td:first-child {
                    padding-bottom: 0;
                }

                .comment-header {
                    flex-direction: column;
                    align-items: flex-start;
                }

                .comment-actions {
                    margin-top: 10px;
                    width: 100%;
                    justify-content: space-between;
                }
            }
            .btn-back {
                display: inline-block;
                background-color: #3498db;
                color: white;
                text-decoration: none;
                padding: 10px 20px;
                border-radius: 30px;
                font-weight: 500;
                font-size: 16px;
                transition: all 0.3s ease;
                box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
                margin: 20px 0;
                border: none;
                cursor: pointer;
            }

            .btn-back:hover {
                background-color: #2980b9;
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
                transform: translateY(-2px);
            }

            .btn-back:active {
                transform: translateY(0);
                box-shadow: 0 2px 3px rgba(0, 0, 0, 0.1);
            }

            .btn-back:before {
                content: "←";
                margin-right: 8px;
                font-weight: bold;
            }

            /* Container cho nút back */
            .action-buttons {
                max-width: 900px;
                margin: 0 auto;
                padding: 0 25px;
            }
            /* Filter and Search Container */
            .filter-search-container {
                max-width: 900px;
                margin: 20px auto;
                background: white;
                border-radius: 12px;
                box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
                padding: 25px;
                border-left: 5px solid #9b59b6;
            }

            .filter-search-container h3 {
                color: #2c3e50;
                font-size: 20px;
                font-weight: 600;
                margin-bottom: 20px;
                position: relative;
                padding-bottom: 8px;
            }

            .filter-search-container h3:after {
                content: '';
                position: absolute;
                bottom: 0;
                left: 0;
                width: 60px;
                height: 3px;
                background: linear-gradient(to right, #9b59b6, #3498db);
            }

            /* Forms Container - Đặt 2 form trên cùng 1 dòng */
            .forms-wrapper {
                display: flex;
                gap: 20px;
                align-items: flex-start;
            }

            /* Form Layout */
            .filter-form, .search-form {
                display: flex;
                align-items: center;
                gap: 10px;
                padding: 15px;
                background-color: #f8f9fa;
                border-radius: 8px;
                border: 1px solid #e9ecef;
                flex: 1; /* Chia đều không gian */
            }

            /* Form Labels */
            .form-label {
                font-weight: 600;
                color: #2c3e50;
                margin-right: 5px;
                white-space: nowrap;
                font-size: 14px;
            }

            /* Select Styling */
            .filter-form select {
                padding: 8px 12px;
                border: 2px solid #ddd;
                border-radius: 20px;
                background-color: white;
                font-size: 14px;
                color: #333;
                min-width: 180px;
                transition: all 0.3s ease;
                outline: none;
            }

            .filter-form select:focus {
                border-color: #9b59b6;
                box-shadow: 0 0 0 3px rgba(155, 89, 182, 0.1);
            }

            /* Input Styling */
            .search-form input[type="text"] {
                padding: 8px 12px;
                border: 2px solid #ddd;
                border-radius: 20px;
                background-color: white;
                font-size: 14px;
                color: #333;
                min-width: 200px;
                transition: all 0.3s ease;
                outline: none;
                flex: 1;
            }

            .search-form input[type="text"]:focus {
                border-color: #3498db;
                box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.1);
            }

            .search-form input[type="text"]::placeholder {
                color: #999;
                font-style: italic;
            }

            /* Button Styling */
            .filter-form input[type="submit"],
            .search-form input[type="submit"] {
                background: linear-gradient(135deg, #9b59b6, #8e44ad);
                color: white;
                border: none;
                padding: 8px 16px;
                border-radius: 20px;
                font-size: 14px;
                font-weight: 500;
                cursor: pointer;
                transition: all 0.3s ease;
                box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
                white-space: nowrap;
            }

            .search-form input[type="submit"] {
                background: linear-gradient(135deg, #3498db, #2980b9);
            }

            .filter-form input[type="submit"]:hover {
                background: linear-gradient(135deg, #8e44ad, #732d91);
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
                transform: translateY(-2px);
            }

            .search-form input[type="submit"]:hover {
                background: linear-gradient(135deg, #2980b9, #1f618d);
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
                transform: translateY(-2px);
            }

            .filter-form input[type="submit"]:active,
            .search-form input[type="submit"]:active {
                transform: translateY(0);
                box-shadow: 0 2px 3px rgba(0, 0, 0, 0.1);
            }

            /* Icon for forms */
            .filter-form::before {
                content: "🔍";
                font-size: 16px;
                margin-right: 5px;
            }

            .search-form::before {
                content: "🔎";
                font-size: 16px;
                margin-right: 5px;
            }

            /* Responsive Design */
            @media (max-width: 768px) {
                .filter-search-container {
                    padding: 15px;
                    margin: 10px;
                }

                .forms-wrapper {
                    flex-direction: column;
                    gap: 15px;
                }

                .filter-form, .search-form {
                    flex-direction: column;
                    align-items: stretch;
                    gap: 10px;
                }

                .filter-form select,
                .search-form input[type="text"] {
                    min-width: auto;
                    width: 100%;
                }

                .filter-form input[type="submit"],
                .search-form input[type="submit"] {
                    width: 100%;
                    padding: 12px;
                }

                .form-label {
                    text-align: center;
                }
            }

            @media (max-width: 1024px) and (min-width: 769px) {
                .filter-form select {
                    min-width: 150px;
                }

                .search-form input[type="text"] {
                    min-width: 160px;
                }
            }
            /* Pagination Container */
            .pagination-container {
                max-width: 900px;
                margin: 20px auto;
                padding: 20px 25px;
                text-align: center;
            }

            /* Pagination Wrapper */
            .pagination {
                display: inline-flex;
                align-items: center;
                gap: 8px;
                background: white;
                padding: 15px 20px;
                border-radius: 50px;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
                border: 1px solid #e9ecef;
            }

            /* Pagination Links */
            .pagination a {
                display: inline-flex;
                align-items: center;
                justify-content: center;
                width: 40px;
                height: 40px;
                text-decoration: none;
                color: #495057;
                font-weight: 500;
                font-size: 14px;
                border-radius: 50%;
                transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                position: relative;
                overflow: hidden;
            }

            /* Default state */
            .pagination a:hover {
                background-color: #e3f2fd;
                color: #1976d2;
                transform: translateY(-2px);
                box-shadow: 0 4px 8px rgba(25, 118, 210, 0.2);
            }

            /* Active page styling */
            .pagination a.active {
                background: linear-gradient(135deg, #3498db, #2980b9);
                color: white;
                box-shadow: 0 4px 12px rgba(52, 152, 219, 0.3);
                transform: translateY(-1px);
            }

            .pagination a.active:hover {
                background: linear-gradient(135deg, #2980b9, #1f618d);
                transform: translateY(-2px);
                box-shadow: 0 6px 16px rgba(52, 152, 219, 0.4);
            }

            /* Ripple effect */
            .pagination a::before {
                content: '';
                position: absolute;
                top: 50%;
                left: 50%;
                width: 0;
                height: 0;
                background: rgba(52, 152, 219, 0.2);
                border-radius: 50%;
                transform: translate(-50%, -50%);
                transition: width 0.3s, height 0.3s;
            }

            .pagination a:active::before {
                width: 100%;
                height: 100%;
            }

            /* First and Last page special styling */
            .pagination a:first-child,
            .pagination a:last-child {
                font-weight: 600;
            }

            /* Disabled state (nếu cần) */
            .pagination a.disabled {
                color: #adb5bd;
                cursor: not-allowed;
                pointer-events: none;
            }

            /* Responsive Design */
            @media (max-width: 768px) {
                .pagination-container {
                    padding: 15px;
                    margin: 15px auto;
                }

                .pagination {
                    padding: 12px 15px;
                    gap: 6px;
                    flex-wrap: wrap;
                    justify-content: center;
                }

                .pagination a {
                    width: 36px;
                    height: 36px;
                    font-size: 13px;
                }
            }

            @media (max-width: 480px) {
                .pagination a {
                    width: 32px;
                    height: 32px;
                    font-size: 12px;
                }

                .pagination {
                    gap: 4px;
                    padding: 10px 12px;
                }
            }

            /* Animation cho container */
            .pagination-container {
                animation: fadeInUp 0.6s ease-out;
            }

            @keyframes fadeInUp {
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
                padding: 20px;
                background: #f5f5f5;
            }
        </style>
    </head>
    <body>
        <div class="layout-container">
            <jsp:include page="/include/sidebar.jsp" />
            <div class="main-content">
                <c:set var="listVSE" value="${requestScope.listSED}"/>
                <c:set var="supplier" value="${requestScope.supplier}"/>
                <c:set var="user" value="${sessionScope.user}"/>
                <c:set var="avg" value="${requestScope.avg}"/>
                <c:set var="fl" value="${requestScope.fl}"/>
                <c:set var="totalPage" value="${requestScope.totalPage}"/>
                <c:set var="index" value="${requestScope.index}"/>
                <c:set var="nameSearch" value="${requestScope.name}"/>
                <!-- isFilter -->
                <c:set var="isFilter" value="${requestScope.isFilter}"/>
                <!-- isFilter -->
                <c:if test="${empty fl or fl == null}">
                    <c:set var="fl" value="star"/>
                </c:if>
                <c:set var="page" value="${requestScope.page}"/>
                <div class="supplier-container">
                    <c:if test="${empty listVSE}">
                        <h2>Supplier Information</h2>
                    </c:if>
                    <c:if test="${not empty listVSE}">
                        <h2 style="color: orange">Supplier Information ${avg}★</h2>
                    </c:if>
                    <table class="supplier-info">
                        <tr><td>Name:</td><td>${supplier.name}</td></tr>
                        <tr><td>Phone:</td><td>${supplier.phone}</td></tr>
                        <tr><td>Email:</td><td>${supplier.email}</td></tr>
                        <tr><td>Address:</td><td>${supplier.address}</td></tr>
                        <tr><td>Note:</td><td>${supplier.note}</td></tr>
                    </table>    
                </div>
                <div class="filter-search-container">
                    <h3>Filter & Search</h3>
                    <div class="forms-wrapper">
                        <form action="FilterSupplierEvaluation" class="filter-form">
                            <span class="form-label">Filter:</span>
                            <select name="filter">
                                <option ${fl==null || fl=="start"?'selected':''} value="star">Sort descending by star</option>
                                <option ${fl=="date"?'selected':''} value="date">Sort descending by date</option>
                            </select>
                            <input style="display:none" type="text" value="${supplier.supplierID}" name="sid">
                            <input style="display:none" type="text" value="${index}" name="index">
                            <input type="submit" value="Apply Filter" name="x">
                        </form>

                        <form action="SearchSupplierEvaluation" class="search-form">
                            <span class="form-label">Search:</span>
                            <input style="display:none" type="text" value="${supplier.supplierID}" name="sid">
                            <input style="display:none" type="text" value="${fl}" name="fl">
                            <input style="display:none" type="text" value="${index}" name="index">
                            <input type="text" placeholder="Enter user name to search..." name="name">
                            <input type="submit" value="Search" name="y">
                        </form>
                    </div>
                </div>
                <div class="comments-container">
                    <div>
                        <h2>Comments</h2>
                    </div>

                    <c:forEach var="i" items="${listVSE}">
                        <c:set var="ratingValue" value="${i.avgRate}"/>
                        <c:set var="ratingClass" value="rating-3"/>

                        <c:if test="${ratingValue >= 5}">
                            <c:set var="ratingClass" value="rating-5"/>
                        </c:if>
                        <c:if test="${ratingValue >= 4 && ratingValue < 5}">
                            <c:set var="ratingClass" value="rating-4"/>
                        </c:if>
                        <c:if test="${ratingValue >= 3 && ratingValue < 4}">
                            <c:set var="ratingClass" value="rating-3"/>
                        </c:if>
                        <c:if test="${ratingValue >= 2 && ratingValue < 3}">
                            <c:set var="ratingClass" value="rating-2"/>
                        </c:if>
                        <c:if test="${ratingValue < 2}">
                            <c:set var="ratingClass" value="rating-1"/>
                        </c:if>

                        <!-- Format date: convert yyyy-MM-dd to dd/MM/yyyy -->
                        <fmt:parseDate value="${i.commentTime}" pattern="yyyy-MM-dd" var="parsedDate" />
                        <fmt:formatDate value="${parsedDate}" pattern="dd/MM/yyyy" var="formattedDate" />

                        <div class="comment-item ${ratingClass}">
                            <div class="comment-header">
                                <div class="user-info">
                                    <span class="username">${i.userID.fullname}:</span>
                                    <span class="rating">${i.avgRate}★</span>
                                </div>
                                <div class="comment-actions">
                                    <span class="date">${formattedDate}</span>
                                    <c:if test="${i.userID.id == user.id}">
                                        <a href="TableSupplierEvaluation?seid=${i.supplierEvaluationID}&id=${supplier.supplierID}" 
                                           class="edit-button">Edit</a>

                                    </c:if>
                                    <c:if test="${i.userID.id == user.id}">
                                        <a href="DeleteSupplierEvaluation?id=${i.supplierEvaluationID}&sid=${supplier.supplierID}&index=${index}" class="delete-button"
                                           onclick="return confirm('Bạn có chắc chắn muốn xoá đánh giá nhà cung cấp này không?')">
                                            Delete</a>
                                        </c:if>
                                </div>
                            </div>
                            <div class="comment-content">
                                ${i.comment}
                            </div>
                        </div>
                    </c:forEach>
                </div>
                <c:if test="${empty isFilter}">
                    <div class="pagination-container">
                        <div class="pagination">
                            <c:forEach var="i" begin="1" end="${totalPage}">
                                <a href="ViewSupplierEvaluation?supplierID=${supplier.supplierID}&index=${i}" 
                                   class="${i == index ? 'active' : ''}">${i}</a>
                            </c:forEach>
                        </div>
                    </div>
                </c:if>
                <c:if test="${isFilter eq 'filter'}">
                    <div class="pagination-container">
                        <div class="pagination">
                            <c:forEach var="i" begin="1" end="${totalPage}">
                                <a href="FilterSupplierEvaluation?index=${i}&filter=${fl}&sid=${supplier.supplierID}" 
                                   class="${i == index ? 'active' : ''}">${i}</a>
                            </c:forEach>
                        </div>
                    </div>
                </c:if>
                <c:if test="${isFilter eq 'search'}">
                    <div class="pagination-container">
                        <div class="pagination">
                            <c:forEach var="i" begin="1" end="${totalPage}">
                                <a href="SearchSupplierEvaluation?index=${i}&fl=${fl}&sid=${supplier.supplierID}&name=${nameSearch}" 
                                   class="${i == index ? 'active' : ''}">${i}</a>
                            </c:forEach>
                        </div>
                    </div>
                </c:if>
                <c:if test="${empty page}">
                    <div class="action-buttons">
                        <a class="btn-back" href="LishSupplier">Back</a>
                    </div>
                </c:if>
                <c:if test="${not empty page}">
                    <div class="action-buttons">
                        <a class="btn-back" href="StatisticSupplierEvaluation.jsp">Back</a>
                    </div>
                </c:if>
            </div>
        </div>
    </body>
</html>

