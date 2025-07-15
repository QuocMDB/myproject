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
    <a href="home" class="home-button">HOME</a>

    <div class="container">
        <div class="row nopadding login-body">
            <!-- <div class="col-lg-3 col-md-4 nopadding">
                <div class="login-quote">
                    <img src="/images/bannerlogin.jpg" alt="">
                </div>
            </div> -->
            <div class="col-lg-5 col-md-8 login-content">
                <input type="checkbox" id="check">
                <div class="login form">
                    <header>Add information to check password<br><span style="color: red">${pass}</span></header>
                    <form action="forgetpass" method="post">
                        <input type="text" name="name" placeholder="Real name" value="${name}" required="">
                        <input type="text" name="phonenumber" placeholder="Phonenumber" value="${phonenumber}" required="" minlength="10" maxlength="10">
                        <input type="text" name="email" placeholder="Email" value="${email}" required="">
                        <input type="text" name="username" placeholder="Username" value="${username}" required="">
                        <input type="submit" class="button" value="Check">
                    </form>
                    
                </div>
                
            </div>
			<!-- <div class="col-lg-3 col-md-4 nopadding">
                <div class="login-quote">
                    <img src="/images/bannerlogin.jpg" alt="">
                </div>
            </div> -->
        </div>
    </div>
	
</body>

</html>