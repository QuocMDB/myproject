<%-- 
    Document   : Cart
    Created on : Oct 21, 2023, 5:18:49 PM
    Author     : Fpt
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">

    <head>
        <title>Food Shop</title>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <!-- Bootstrap -->
        <link href="css/bootstrap.min.css" rel="stylesheet">
        <!-- Embed css here-->
        <link rel="stylesheet" href="css/styleCart.css">
        <link rel="shortcut icon" href="images/logo3.png">
        <style>
            .button {
                display: inline-block;
                padding: 10px 20px;
                background-color: #f44336; /* Màu nền đỏ */
                color: white; /* Màu chữ trắng */
                text-align: center;
                text-decoration: none; /* Bỏ gạch chân */
                border-radius: 4px; /* Bo góc */
                border: none; /* Bỏ viền */
                cursor: pointer; /* Thay đổi con trỏ chuột khi hover */
            }

            input[type="text"] {
                width: 100%;
                padding: 10px;
                margin: 5px 0;
                box-sizing: border-box;
                border: 1px solid #ccc;
                border-radius: 4px;
            }

        </style>

    </head>

    <body>

        <a href="homeadmin" class="home-button">HOME</a>
        <div class="cart-content">
            <div>
                <table class="cart-table">
                    <tr class="cart-header-table">
                        <th>User ID</th>
                        <th>User Name</th>
                        <th>Full Name</th>
                        <th>Email</th>
                        <th>Phone Number</th>
                        <th>Delete/Ban</th>

                    </tr>
                    <c:forEach items="${user}" var="user">
                        <tr class="cart-item">
                        <form action="updateuserinformation" method="post">
                            <td>${user.user_id}</td>
                            <td><input type="text" name="username" value="${user.username}"></td>
                            <td><input type="text" name="fullname" value="${user.fullname}"></td>
                            <td><input type="text" name="email" value="${user.email}"></td>
                            <td><input type="text" name="phone" value="${user.phone_number}"></td>
                            <td>
                                <input type="hidden" name="user_id" value="${user.user_id}">
                                <c:if test="${user.user_id != 1}">
                                    <input type="submit" value="Update" style="background-color: blue">
                                    <a href="deleteuser?user_id=${user.user_id}" class="button">Delete</a>
                                </c:if>
                            </td>
                        </form>
                        </tr>
                    </c:forEach>


                </table>
            </div>
        </div>





    </body>

</html>