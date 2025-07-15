<%-- 
    Document   : Home
    Created on : Oct 21, 2023, 1:22:52 AM
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
        <link rel="stylesheet" href="css/styleHome.css">
        <link rel="shortcut icon" href="images/logo3.png">
    </head>

    <body>

        <div class="container-fluid padding">

            <div class="row">

                <div class="col-lg-4 col-md-6 col-sm-12 nopadding banner">

                    <div class="list-option">
                        <div class="logo">
                            <img src="images/logo1.png" alt="">
                        </div>

                        <div class="list-option-middle">
                            <div class="list-option-middle-left">
                                <img src="images/logo3.png" alt=""><br/>

                                <c:if test="${sessionScope.acc != null}">
                                    <a href="logout">Logout</a>
                                </c:if>
                                <c:if test="${sessionScope.acc == null}">
                                    <a href="Login.jsp">Login</a>
                                </c:if>

                            </div>
                            <div>
                                <div class="list-option-element"><a href="home">HOME</a> </div>
                                <div class="list-option-element">
                                    <c:choose>
                                        <c:when test="${sessionScope.acc != null}">
                                            <a href="cart">CART</a>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="Login.jsp">CART</a>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <c:if test="${sessionScope.acc != null}">
                                    <div class="list-option-element"><a href="changepass" style="color: white; font-size: 15px">Change Pass</a></div>
                                </c:if>
                                <c:if test="${sessionScope.acc != null}">
                                    <div class="list-option-element"><a href="yourorder" style="color: white; font-size: 15px">Your Order</a></div>
                                </c:if>
                                <div class="list-option-element"><a href="About.jsp">ABOUT</a></div>
                                <div class="list-option-element"><a href="#footer">CONTACT</a></div>

                            </div>
                        </div>



                        <div class="bestseller">
                            <c:forEach items="${prd1}" var="prd1" >
                                <img class="favorite-item-img nopadding " src="${prd1.image_url}" alt="">
                                <div>
                                    <p>BEST SELLER</p>
                                    <p>${prd1.name}</p>
                                    <h3>${prd1.price}$</h3>
                                    <c:if test="${sessionScope.acc == null}">
                                    </c:if>

                                    <c:if test="${sessionScope.acc != null}">
<!--                                        <form action="addtocart" method="post">
                                            <input type="hidden" name="id" value="${prd1.id}">
                                        </form>-->
                                    </c:if>
                                </div>
                            </c:forEach> 
                        </div>
                    </div>
                </div>
                <div class="col-lg-8 col-md-6 col-sm-12 favorite">

                    <!-- Insert code favorite places here-->
                    <!--categories-->
                    <div class="nopadding form-table" style="display: flex;
                         justify-content: center;">
                        <ul id="list-option">
                            <c:forEach items="${cat}" var="cat" >
                                <li>
                                    <form action="homesubservlet" method="post">
                                        <input type="hidden" name="category" value="${cat.id}">
                                        <input style="${tag == cat.id ? "color: #ff5200;box-shadow: 0 0 20px #ff5200"  : ""}" type="submit" value="${cat.name}">
                                    </form>
                                </li>
                            </c:forEach>   

                            <li class="list-option-search"> 
                                <form action="homesubservlet" method="post">
                                    <input type="hidden" name="category" value="-1">
                                    <input type="text" name="search" style="${tag == -1 ? "color: #ff5200;box-shadow: 0 0 20px #ff5200"  : ""}" maxlength="15">
                                    <button type="submit">Search</button>
                                </form>
                            </li>
                        </ul>
                    </div>
                    <!--                    <form class="nopadding" action="" method="">
                                            
                                        </form>-->
                    <!--products-->
                    <c:if test="${empty prd}">
                        <h1 style="text-align: center; font-size: 30px;
                            font-weight: bold;
                            margin-bottom: 40px;">Opp ! No foods were found with the words '<span style="color: red">${searchKey}</span>'.</h1> 
                    </c:if>

                    <c:forEach items="${prd}" var="prd" >   
                        <div class="col-lg-4 col-md-6 col-sm-12 favorite-item-father nopadding">
                            <div class="favorite-item">
                                <img class="favorite-item-img nopadding" src="${prd.image_url}" alt="">
                                <p style="margin: 0px">${prd.name}</p>
                                <p style="margin: 0px">Sold: ${prd.quantity_sold}</p>
                                <h3>${prd.price}$</h3>
                                <c:if test="${sessionScope.acc != null}">
                                    <form action="productdesservlet" method="post">
                                        <input type="hidden" name="product" value="${prd.id}">
                                        <input type="hidden" name="category" value="${prd.category_id}">
                                        <input type="submit" value="View" style="">
                                    </form>
                                </c:if>
                                <c:if test="${sessionScope.acc == null}">
                                    <!--                                    <form action="login" method="">
                                                                            <input type="submit" value="View">
                                                                        </form>-->
                                </c:if>

                            </div>
                        </div>
                    </c:forEach>   

                </div>
            </div>
        </div> <!--Kết thúc container-fluid-->



        <div class="container-fluid" id="footer">
            <a href="home" class="home-button-footer">HOME</a>
            <div class="row">

                <div class="footer">

                    <p>Email : quocmdbhe186431@fpt.edu.vn</p>
                    <p>Address: FPTU, Thạch Hòa, Thạch Thất , Hà Nội</p>
                    <h5>&copy; Copyright by <a href="https://www.facebook.com/maiquoc04">Mai Quoc</a>. FoodParadise.FPT</h5>
                </div>

            </div>

        </div>
    </body>

</html>
