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

    </head>

    <body>

        <a href="home" class="home-button">HOME</a>
        <div class="cart-content">
            <div>
                <table class="cart-table">
                    <tr class="cart-header-table">
                        <th>ID</th>
                        <th>Image</th>
                        <th>Name</th>
                        <th>Price</th>
                        <th>Quantity</th>
                        <th>Total Price</th>
                        <th>Clear Cart</th>
                    </tr>
                    <c:if test="${not empty cat}">
                        <c:forEach items="${cat}" var="cat" >
                            <tr class="cart-item">
                                <td>${cat.product_id}</td>
                                <td><img src="${cat.image_url}" alt=""></td>
                                <td>${cat.product_name}</td>
                                <td>${cat.price}$</td>
                                <td>
                                    <form action="updatequantitycartitem" method="post">
                                        <input type="hidden" name="cart_id" value="${cat.id}">
                                        <input type="number" name="quantity" value="${cat.quantity}" min="1" max="${cat.quantity_in_stock}">
                                        <input type="submit" value="Change" style="padding: 5px 10px; background-color: #333" >
                                    </form>

                                </td>
                                <td>${cat.price * cat.quantity}$</td>
                                <td>
                                    <form action="deletecartitem" method="post">
                                        <input type="hidden" value="${cat.id}" name="id">
                                        <input type="submit" value="Delete">
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                        <tr class="cart-bottom">
                            <td colspan="3"><a href="home">Continue Shopping</a></td>
                            <td colspan="2">Grand Total</td>

                            <td><c:out value="${sum}"/>$</td>
                            <td>
                                <form action="bill" method="post">
                                    <c:if test="${cat.size() != 0}">
                                        <input type="submit" value="Checkout">
                                    </c:if>

                                </form>
                            </td>
                        </tr>
                    </c:if>
                </table>
            </div>
        </div>

    </body>

</html>