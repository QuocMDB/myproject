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

        <a href="homeadmin" class="home-button">HOME</a>
         
        
        <div class="cart-content">
            <h2>Total Revenue: ${sum}$</h2>
            <h2>Profit: ${sum * 0.25}$</h2>
            <div>
                <table class="cart-table">
                    <tr class="cart-header-table">
                        <th>User_id</th>
                        <th>Date</th>
                        <th>address</th>
                        <th>phonenumber</th>
                        <th>totalmoney</th>
                        <th>Detail</th>
  
                    </tr>
                    <c:forEach items="${ord}" var="ord" >
                        <tr class="cart-item">
                            <td>${ord.user_id}</td>
                            <td>${ord.date}</td>
                            
                            <td>${ord.address}</td>
                            <td>${ord.phonenumber}</td>
                            
                            <td>${ord.totalmoney}$</td>
                            <td>
                                <c:if test="${ord.status == 0}">
                                    <form action="shiporder" method="post">
                                    <input type="hidden" value="${ord.orderID}" name="orderID">
                                    <input type="submit" value="Ship">
                                </form>
                                </c:if>
                                <c:if test="${ord.status == 2}">
                                    Complete!
                                </form>
                                </c:if>
                                
                            </td>
                            
                        </tr>
                    </c:forEach>
                    

                </table>
            </div>
        </div>





    </body>

</html>