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


                        <th>Image</th>

                        <th>Name</th>

                        <th>Quantity</th>

                        <th>Price</th>

                        <th>Total</th>



                    </tr>
                    <c:forEach items="${ord}" var="ord" >
                        <tr class="cart-item">


                            <td><img src="${ord.image_url}" alt=""></td>
                            <td>${ord.name}</td>
                            <td>${ord.quantity}</td>
                            <td>${ord.price}$</td>
                            <td>${ord.price * ord.quantity}$</td>


                        </tr>
                        <tr class="cart-item">
                         <c:if test="${ord.status == 2}">
                             <tr class="cart-item">
                                <form action="comment" method="post">
                            <input type="hidden" name="product_id" value="${ord.product_id}">
                            <input type="hidden" name="orderID" value="${orderID}">
                            <td colspan="2">Rating: <input type="number" name="rating" value="${rating}" min="0" max="100" step="1" required="">  /100</td>
                            <td colspan="2  ">Comment: <input type="text" name="comment" value="${comment}" required="" style="height: 40px; width: 80%"></td>
                            <td colspan="1"><input type="submit" value="Post"  id="submitBtn"></td>
                            </form>   
                            </tr>
                        </c:if>
                        
                    </c:forEach>


                </table>

            </div>
        </div>

        <script>
            const submitBtn = document.getElementById('submitBtn');
            submitBtn.addEventListener('click', function () {
                alert('Comment and Rating updated!');
            });
        </script>





    </body>

</html>