<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<%@ page import="model.Users" %> 
<%
Users user = (Users) session.getAttribute("user");
if (user == null || (!"Admin".equalsIgnoreCase(user.getRoleName()))) {
    response.sendRedirect("login.jsp");
    return;
}
%>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Statistic Supplier</title>
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                min-height: 100vh;
                padding: 20px;
                color: #333;
            }

            .layout-container {
                display: flex;
                min-height: 100vh;
            }

            .main-content {
                flex: 1;
                padding: 30px;
            }

            .form-wrapper {
                background: white;
                padding: 30px;
                border-radius: 15px;
                box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
                max-width: 1100px;
                margin: 0 auto;
            }

            .title {
                text-align: center;
                color: #1567c1;
                font-size: 2.2em;
                font-weight: bold;
                margin-bottom: 25px;
                position: relative;
            }

            .title::after {
                content: '';
                position: absolute;
                bottom: -8px;
                left: 50%;
                transform: translateX(-50%);
                width: 80px;
                height: 3px;
                background: linear-gradient(45deg, #667eea, #764ba2);
                border-radius: 2px;
            }

            form {
                background: #f8f9fa;
                padding: 25px;
                border-radius: 10px;
                margin-bottom: 30px;
                display: flex;
                gap: 15px;
                align-items: center;
                flex-wrap: wrap;
                justify-content: center;
                box-shadow: 0 5px 15px rgba(0,0,0,0.05);
            }

            select {
                padding: 12px 15px;
                border: 2px solid #e9ecef;
                border-radius: 8px;
                font-size: 14px;
                background: white;
                color: #495057;
                cursor: pointer;
                transition: all 0.3s ease;
                min-width: 200px;
            }

            select:focus {
                outline: none;
                border-color: #667eea;
                box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
            }

            input[type="submit"] {
                background: linear-gradient(45deg, #667eea, #764ba2);
                color: white;
                border: none;
                padding: 12px 25px;
                border-radius: 8px;
                font-size: 14px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                text-transform: uppercase;
                letter-spacing: 1px;
            }

            input[type="submit"]:hover {
                transform: translateY(-2px);
                box-shadow: 0 10px 20px rgba(102, 126, 234, 0.3);
            }

            table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 20px;
                background: white;
                border-radius: 10px;
                overflow: hidden;
                box-shadow: 0 10px 30px rgba(0,0,0,0.1);
                animation: fadeInUp 0.6s ease-out;
            }

            table tr:first-child {
                background: linear-gradient(45deg, #667eea, #764ba2);
                color: white;
            }

            table tr:first-child td {
                font-weight: 600;
                text-transform: uppercase;
                letter-spacing: 1px;
                font-size: 13px;
            }

            table td {
                padding: 15px;
                text-align: left;
                border-bottom: 1px solid #e9ecef;
                transition: background-color 0.3s ease;
            }

            table tr:not(:first-child):hover {
                background-color: #f8f9fa;
            }

            table tr:not(:first-child):nth-child(even) {
                background-color: #fdfdfd;
            }

            table tr:not(:first-child):nth-child(even):hover {
                background-color: #f0f0f0;
            }

            table tr:not(:first-child) {
                transition: all 0.3s ease;
            }

            table tr:not(:first-child):hover {
                transform: translateX(5px);
                box-shadow: 5px 0 15px rgba(0,0,0,0.1);
            }

            .btn-back {
                display: inline-block;
                margin-top: 25px;
                padding: 10px 20px;
                background: #6c757d;
                color: white;
                text-decoration: none;
                border-radius: 5px;
                transition: all 0.3s ease;
                font-weight: 500;
            }

            .btn-back:hover {
                background: #5a6268;
                transform: translateY(-1px);
            }

            .pagination {
                display: flex;
                justify-content: center;
                gap: 10px;
                margin-top: 20px;
            }

            .pagination a {
                padding: 8px 12px;
                background: #667eea;
                color: white;
                text-decoration: none;
                border-radius: 5px;
                transition: all 0.3s ease;
            }

            .pagination a:hover {
                background: #764ba2;
                transform: translateY(-2px);
            }

            .pagination a.active {
                background: #764ba2;
                font-weight: bold;
            }

            @media (max-width: 768px) {
                form {
                    flex-direction: column;
                    align-items: stretch;
                }

                select {
                    width: 100%;
                }

                table {
                    font-size: 12px;
                }

                table td {
                    padding: 10px 8px;
                }
            }

            @media (max-width: 480px) {
                table {
                    font-size: 10px;
                }

                table td {
                    padding: 8px 5px;
                }

                .title {
                    font-size: 1.5em;
                }
            }

            @keyframes fadeInUp {
                from {
                    opacity: 0;
                    transform: translateY(30px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }
            .btn-view {
                display: inline-block;
                padding: 8px 16px;
                background: linear-gradient(45deg, #ffb347, #ffcc33); /* cam vàng nổi bật */
                color: #fff;
                font-size: 13px;
                font-weight: 600;
                text-decoration: none;
                border-radius: 6px;
                transition: all 0.3s ease;
                box-shadow: 0 5px 10px rgba(255, 195, 0, 0.3);
                text-align: center;
            }

            .btn-view:hover {
                background: linear-gradient(45deg, #ffa500, #ffbf00);
                transform: scale(1.05);
                box-shadow: 0 8px 20px rgba(255, 195, 0, 0.5);
            }

        </style>
    </head>
    <body>
        <div class="layout-container">
            <jsp:include page="/include/sidebar.jsp" />
            <div class="main-content">
                <div class="form-wrapper">
                    <c:set var="list" value="${requestScope.list}"/>
                    <c:set var="fl" value="${requestScope.fl}"/>
                    <c:set var="st" value="${requestScope.st}"/>
                    <c:set var="mess" value="${requestScope.mess}"/>
                    <c:set var="sta" value="${requestScope.sta}"/>
                    <c:set var="totalPage" value="${requestScope.totalPage}"/>
                    <c:set var="currentIndex" value="${param.index}"/>
                    <c:set var="listStar" value="${requestScope.listStar}"/>
                    <c:set var="listComment" value="${requestScope.listComment}"/>
                    <h2 class="title">Statistic Evaluation</h2>

                    <form action="StatisticSupplierEvaluation">
                        <select name="top">
                            <option ${fl=="avg"?'selected':''} value="avg">Top-rated Supplier</option>
                            <option ${fl=="expexted"?'selected':''} value="expexted">Top-rated expected delivery</option>
                            <option ${fl=="market"?'selected':''} value="market">Top-rated market price comparison</option>
                        </select>
                        <select name="sort">
                            <option ${st=="desc" || st==null?'selected':''} value="desc">Sort descending</option>
                            <option ${st=="asc"?'selected':''} value="asc">Sort ascending</option>
                        </select>
                        <select name="status">
                            <option ${sta=="ATPX"||sta==null?'selected':''} value="ATPX">All Supplier</option>
                            <option ${sta=="active"?'selected':''} value="active">Active Supplier</option>
                            <option ${sta=="inactive"?'selected':''} value="inactive">Inactive Supplier</option>
                        </select>
                        <input type="submit" value="Statistic" name="name">
                    </form>

                    <c:if test="${not empty list}">
                        <h2 class="title">${mess}</h2>
                        <table>
                            <tr>
                                <td>ID</td>
                                <td>Name</td>
                                <td>Phone</td>
                                <td>Email</td>
                                <td>Address</td>
                                <td>Note</td>
                                <td>Star</td>
                                <td>Number Evaluation</td>
                                <td>Option</td>
                            </tr>
                            <c:set var="index" value="0"/>
                            <c:forEach var="listItem" items="${list}">
                                <tr>
                                    <td>${listItem.supplierID}</td>
                                    <td>${listItem.name}</td>
                                    <td>${listItem.phone}</td>
                                    <td>${listItem.email}</td>
                                    <td>${listItem.address}</td>
                                    <td>${listItem.note}</td>
                                    <td style="color: orange" >${listStar[index]}★</td>
                                    <td>${listComment[index]}</td>
                                    <c:set var="index" value="${index+1}"/>
                                    <td><a class="btn-view" href="ViewSupplierEvaluation?supplierID=${listItem.supplierID}&page=statistic">View Evaluation</a></td>
                                </tr>
                            </c:forEach>                           
                        </table>
                    </c:if>

                    <c:if test="${totalPage > 1}">
                        <div class="pagination">
                            <c:forEach var="i" begin="1" end="${totalPage}">
                                <a href="StatisticSupplierEvaluation?top=${fl}&sort=${st}&status=${sta}&index=${i}" 
                                   class="${i == currentIndex ? 'active' : ''}">${i}</a>
                            </c:forEach>
                        </div>
                    </c:if>

                    <a href="Admin.jsp" class="btn-back">Back</a>
                </div>
            </div>
        </div>
    </body>
</html>
