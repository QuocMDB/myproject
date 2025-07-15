<%-- 
    Document   : ProductDes
    Created on : Oct 21, 2023, 8:49:46 PM
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
        <link rel="stylesheet" href="css/styleProductDes.css">
        <link rel="shortcut icon" href="images/logo3.png">
        <style>
            .bestseller  p{
                color: white;
                font-size: 20px;
                padding-left: 40px;
                padding-top: 10px;

            }

            .bestseller  p:first-child {
                color: white;
                font-size: 20px;
                padding-left: 40px;
                padding-top: 10px;
                margin-top: 40px

            }

            .quantity-btn{
                padding: 10px 15px;
                margin-left: 10px;
                background-color: #fff;
                color: black;
                border: none;
                border-radius: 4px;
                margin-top: 40px;
                /* Căn giữa cho nút */

            }
            .review-table{
                margin-top: 40px;
                margin-left: 40px;
                color:white;
                text-align: left;
                margin-bottom: 50px;
                background-color: rgba(0, 0, 0, 0.7);
                border: 3px solid #888;
                border-radius: 5px;

            }

            .review-table tr td{
                padding: 10px 10px;
                min-width: 300px;
                width: 300px;
            }

            .review-table tr td span{
                padding-right: 40px;
            }
            .review-box{
                margin-top: 500px;
                margin-bottom: 50px;
            }
            
           


        </style>

    </head>

    <body>
        <!-- home button -->
        <a href="home" class="home-button">HOME</a>


        <div class="container-fluid padding">
            <!-- product select -->
            <div class="row">

                <div class="col-lg-7 col-md-6 col-sm-12 nopadding banner">

                    <div class="logo">
                        <img src="images/logo1.png" alt="">
                    </div>

                    <div class="bestseller">
                        <c:forEach items="${prd}" var="prd" >
                            <div class="col-lg-6 col-md-6 col-sm-6 nopadding ">
                                <img class="favorite-item-img nopadding " src="${prd.image_url}" alt="">
                            </div>

                            <div class="col-lg-6 col-md-6 col-sm-6">
                                <p>${prd.name}</p>
                                <p>${prd.description}</p>
                                <p>Sold: ${prd.quantity_sold}</p>
                                <p>Remaining: ${prd.quantity_in_stock}</p>
                                <h3>${prd.price}$</h3>
                                <form action="addtocart">
                                    <input type="hidden" name="product_id" value="${prd.id}">
                                    <c:choose>
                                        <c:when test="${sessionScope.acc.getIsAdmin() == 0}">
                                            <input style="background-color: #ff5200;" type="submit" value="Add to cart">
                                        </c:when>
                                        <c:otherwise>
                                            <p></p>
                                        </c:otherwise>
                                    </c:choose>
                                    <input type="number" name="quantity" value="1" min="1" max="${prd.quantity_in_stock}" class="quantity-btn">
                                </form>
                            </div>
                        </c:forEach>
                    </div>

                    <div class="review-box">
                        <c:forEach items="${rew}" var="rew" >
                            <table class="review-table">
                                <tr>
                                    <td>${rew.username}</td>
                                </tr>

                                <tr>
                                    <td> Rating:<span> ${rew.rating}/100</span> Date: ${rew.review_date}</td>
                                </tr>
                                <tr>
                                    <td>${rew.comment}</td>
                                </tr>
                            </table>
                        </c:forEach>

                    </div>
                </div>


                <!-- related product -->
                <div class="col-lg-5 col-md-6 col-sm-12 favorite">

                    <!-- Insert code favorite places here-->
                    <div id="list-option">
                        <h2>related products</h2>
                    </div>
                    <c:forEach items="${rela}" var="rela" >
                        <div class="col-lg-6 col-md-6 col-sm-12 favorite-item-father nopadding">
                            <div class="favorite-item">
                                <img class="favorite-item-img nopadding" src="${rela.image_url}" alt="">
                                <p>${rela.name}</p>
                                <h3>${rela.price}$</h3>
                                <form action="productdesservlet" method="post">
                                    <input type="hidden" name="product" value="${rela.id}">
                                    <input type="hidden" name="category" value="${rela.category_id}">
                                    <input style="background-color: #ff5200;" type="submit" value="View">
                                </form>

                            </div>
                        </div>
                    </c:forEach>



                </div>
            </div>
        </div> <!--Kết thúc container-fluid-->


        <!-- footer -->
        <div class="container-fluid" id="footer">
            <div class="row">

                <div class="footer" style="background-color: #ff5200;"
                     >

                    <p>Email : aaaaaaa@fpt.edu.vn</p>
                    <p>Address: FPTU, Thạch Hòa, Thạch Thất , Hà Nội</p>
                    <h5>&copy; Copyright 2021. VietTravel.VN</h5>
                </div>

            </div>

        </div>

    </body>

</html>