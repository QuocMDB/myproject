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

    <body id="body">

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
                                <div class="list-option-element"><a href="homeadmin">HOME</a> </div>
                                <div class="list-option-element"><a href="loadaddproduct">ADD PRODUCTS</a> </div>
                                <div class="list-option-element"><a href="usermanage">Users Manage</a></div>
                                <div class="list-option-element"><a href="ordermanage">Orders Manage</a></div>
                                <c:if test="${sessionScope.acc != null}">
                                    <div class="list-option-element"><a href="changepass" style="color: white; font-size: 15px">Change Pass</a></div>
                                </c:if>
                            </div>
                        </div>



<!--                        <div class="bestseller" style="margin-top: 50px">
                            <c:forEach items="${prd1}" var="prd1" >
                                <img class="favorite-item-img nopadding " src="images/${prd1.image_url}" alt="">
                                <div>
                                    <p>BEST SELLER</p>
                                    <p>${prd1.name}</p>
                                    <h3>${prd1.price}$</h3>
                                    <c:if test="${sessionScope.acc == null}">
                                        <form action="login" method="">
                                            <input type="submit" value="Edit">
                                        </form>
                                    </c:if>

                                    <c:if test="${sessionScope.acc != null}">
                                        <form action="editproduct" method="post">
                                            <input type="submit" value="Edit">
                                        </form>
                                    </c:if>



                                </div>
                            </c:forEach> 
                        </div>-->
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
                                    <form action="homeadminsubservlet" method="post">
                                        <input type="hidden" name="category" value="${cat.id}">
                                        <input style="${tag == cat.id ? "color: aqua;box-shadow: 0 0 20px aqua"  : ""}" type="submit" value="${cat.name}">
                                    </form>
                                </li>
                            </c:forEach>   
                            <li class="list-option-search"> 
                                <form action="homeadminsubservlet" method="post">
                                    <input type="hidden" name="category" value="-1">
                                    <input type="text" name="search" style="${tag == -1 ? "color: aqua;box-shadow: 0 0 20px aqua"  : ""}">
                                    <button type="submit">Search</button>
                                </form>
                            </li>
                        </ul>
                    </div>
                    <!--                    <form class="nopadding" action="" method="">
                                            
                                        </form>-->
                    <!--products-->
                    <c:forEach items="${prd}" var="prd" >   
                        <div class="col-lg-4 col-md-6 col-sm-12 favorite-item-father nopadding">
                            <div class="favorite-item">
                                <img class="favorite-item-img nopadding" src="${prd.image_url}" alt="">
                                <p style="margin: 0px">${prd.name}</p>
                                <p style="margin: 0px">Sold: ${prd.quantity_sold}</p>
                                <h3>${prd.price}$</h3>
                                <c:if test="${sessionScope.acc != null}">
                                        <form action="editproduct" method="post">
                                        <input type="hidden" name="product" value="${prd.id}">
                                        <input type="hidden" name="category" value="${prd.category_id}">
                                        <input type="submit" value="Edit">
                                    </form>
                                </c:if>
                                <c:if test="${sessionScope.acc == null}">
                                    <form action="login" method="">
                                        <input type="submit" value="View">
                                    </form>
                                </c:if>

                            </div>
                        </div>
                    </c:forEach>   

                </div>
            </div>
        </div> <!--Kết thúc container-fluid-->



        <div class="container-fluid" id="footer">
            <a href="#body" class="home-button-footer">HOME</a>
            <div class="row">

                <div class="footer">

                    <p>Email : aaaaaaa@fpt.edu.vn</p>
                    <p>Address: FPTU, Thạch Hòa, Thạch Thất , Hà Nội</p>
                    <h5>&copy; Copyright 2021. VietTravel.VN</h5>
                </div>

            </div>

        </div>
    </body>

</html>
