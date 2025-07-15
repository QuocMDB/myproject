<%-- 
    Document   : Login
    Created on : Oct 21, 2023, 5:01:42 PM
    Author     : Fpt
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login</title>
    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet"
        integrity="sha384-GLhlTQ8iRABdZLl6O3oVMWSktQOp6b7In1Zl3/Jr59b6EGGoI1aFkw7cmDA6j6gD" crossorigin="anonymous">
    <!-- Icons -->
    <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
    <!-- Global CSS -->
    <!-- <link rel="stylesheet" href="css/styleGlobal.css"> -->
    <!-- Login CSS -->
    <link rel="stylesheet" href="css/styleLogin.css ">
    <link rel="shortcut icon" href="images/logo3.png">

</head>

<body>
    <a href="homeadmin" class="home-button">HOME</a>

    <div class="container">
        <div class="row nopadding login-body">
            <div class="col-lg-5 col-md-8 login-content">
                <input type="checkbox" id="check">
                <div class="login form">
                    <header>Add Category<br><span style="color: red">${mess}</span></header>
                    <form action="addcategory" method="post">
                        <input type="text" name="category_name" placeholder="Category" value="${category_name}" required="">
                        <input type="text" name="description" placeholder="Description" value="${description}" required="">
                        <input type="submit" class="button" value="Add">
                    </form>
                    
                </div>
                
            </div>
			
        </div>
        <div class="row nopadding login-body">
            <div class="col-lg-5 col-md-8 login-content">
                <input type="checkbox" id="check" id="myForm">
                <div class="login form">
                    <header>Add Product<br><span style="color: red">${pass}</span></header>
                    <form action="addproduct" method="post">
                        <input type="text" name="name" placeholder="Product name" required="">
                        <input type="text" name="description" placeholder="description"required="">
                        <input type="text" id="myInput" name="price" placeholder="price"required="">
                        <select name="category_id" style="margin-bottom: 20px">
                            <c:forEach items="${cat}" var="cat" >
                                <option value="${cat.id}">${cat.name}</option>
                            </c:forEach>

                        </select>
                        <input type="text" name="image_url" placeholder="image_url"required="">
                        <span style="color: white">Stock</span><input type="number" name="quantity_in_stock" min="0" value="0" required="">    
                        <span style="color: white">Sold</span><input type="number" name="quantity_sold" min="0" value="0" readonly="">
                        <input type="submit" class="button" value="Add" id="mySubmit">
                    </form>
                    
                </div>
                
            </div>
			
        </div>
    </div>
                    <script>

            const myForm = document.getElementById("myForm");
            const myInput = document.getElementById("myInput");

            myForm.addEventListener("submit", function (event) {
                const inputValue = myInput.value.trim();
                if (!isValidDouble(inputValue) || parseFloat(inputValue) <= 0) {
                    alert("Vui lòng nhập giá hợp lệ!");
                    event.preventDefault(); // Ngăn chuyển trang mặc định
                }
            });

            function isValidDouble(value) {
                return !isNaN(parseFloat(value)) && isFinite(value);
            }
        </script>
	
</body>

</html>