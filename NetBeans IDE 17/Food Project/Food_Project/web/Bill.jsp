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
                        <th>Price</th>
                        <th>Quantity</th>
                        <th>Total Price</th>

                    </tr>
                    <c:forEach items="${cat}" var="cat" >
                        <tr class="cart-item">

                            <td><img src="${cat.image_url}" alt=""></td>

                            <td>${cat.product_name}</td>
                            <td>${cat.price}$</td>
                            <td>
                                ${cat.quantity}    
                            </td>
                            <td>${cat.price * cat.quantity}$</td>
                        </tr>
                    </c:forEach>
                    
                    
                </table>
                <form action="ordercomplete" method="post">
                    <input type="text" name="address" id="inputText" placeholder="address" style="background-color: white;
                                               color: black;
                                               padding: 10px 20px;
                                               border-radius: 5px;
                                               border: 1px solid black;
                                               margin: 20px 70px;" required="">
                    <input type="text" name="phonenumber" id="inputText" placeholder="phone number" style="background-color: white;
                                               color: black;
                                               padding: 10px 20px;
                                               border-radius: 5px;
                                               border: 1px solid black;
                                               margin: 20px 70px;" required="" minlength="10" maxlength="10">
                        <input type="hidden" name="totalmoney" value="${sum}" >
                        <input type="submit" value="Oder" style="padding: 5px 15px; color: white; background-color: red; margin-left: 150px">
                </form>
            </div>
        </div>
                        <script>
                            // Lấy phần tử form 
var form = document.getElementById("form");

// Xử lý sự kiện submit form
form.addEventListener("submit", function(event) {

  // Lấy value của input text
  var inputValue = document.getElementById("inputText").value;
  
  // Kiểm tra nếu input rỗng thì ngăn chặn submit
  if (inputValue == "") {
    event.preventDefault();
    alert("Vui lòng nhập vào ô input!");
  }

});
                        </script>




    </body>

</html>