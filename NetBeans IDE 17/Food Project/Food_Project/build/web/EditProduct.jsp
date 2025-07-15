<%-- 
    Document   : EditProduct
    Created on : Oct 23, 2023, 11:38:41 PM
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
        <link rel="stylesheet" href="css/styleEditProduct.css">
        <link rel="shortcut icon" href="images/logo3.png">
        <style>
            .bestseller img {
                height: 510px;
                width: auto;
                float: left;
            }
            .bestseller-footer-btn-1 {
                text-align: center;
                padding: 10px 15px;
                background-color: rgb(228, 28, 28);
                color: #fff;
                border: none;
                border-radius: 4px;

                /* Căn giữa cho nút */
                position: absolute;
                left: 50%;
                transform: translateX(-50%);
                bottom: -20px;
                transform: scale(1);
                transition: transform 0.3s;
            }

            .bestseller-footer-btn-1:hover {
                background-color: rgb(172, 3, 3);
                transform: scale(1.1);
            }
            .review-box{
                margin-top: 50px;
                margin-bottom: 50px;

            }
            .review-table{
                margin-top: 0px;
                margin-left: 20%;
                color:black;
                text-align: left;
                margin-bottom: 50px;
                background-color: white;

            }

            .review-table tr td{
                padding: 10px 10px;
                border: 3px solid #888;
                border-radius: 5px;

            }

            .review-table tr td span{
                padding-right: 40px;
            }
        </style>
    </head>

    <body>
        <!-- home button -->
        <a href="homeadmin" class="home-button">HOME</a>
        <div class="bestseller">
            <c:forEach items="${prd}" var="prd" >
                <img class="favorite-item-img nopadding " src="${prd.image_url}" alt="">
                <div>
                    <form id="myForm" class="bestseller-footer" action="changeproduct" method="post">
                        <input type="hidden" name="id" value="${prd.id}"><br>
                        <input type="text" name="name" value="${prd.name}"><br>
                        <input type="text" name="description" value="${prd.description}"><br>
                        <span style="color: white; font-size: 20px">Category:</span><select name="category_id">
                            <c:forEach items="${rela}" var="rela" >
                                <option  value="${rela.id}" selected>${rela.name}</option>
                            </c:forEach>

                            <c:forEach items="${cate}" var="cate" >
                                <option value="${cate.id}">${cate.name}</option>
                            </c:forEach>

                        </select><br>
                        <div style="margin: 20px 0px 0px 0px"><span style="color: white; font-size: 20px">Sold: ${prd.quantity_sold}</span></div><input type="hidden" name="quantity_sold" value="${prd.quantity_sold}" min="0"><br>
                        <span style="color: white;font-size: 20px">Remaining:</span><input type="number" name="quantity_in_stock" value="${prd.quantity_in_stock}" min="0"><br>

<!--				<p>Sold: ${prd.quantity_sold}</p>
<p>Remaining: ${prd.quantity_in_stock}</p>-->
                        <input id="myInput" type="text" name="price" value="${prd.price}"><br>
                        <input  id="mySubmit" class="bestseller-footer-btn" type="submit" value="Save Change">
                    </form>
                    <form class="" action="deleteproduct" method="post">
                        <input type="hidden" name="id" value="${prd.id}"><br>
                        <input class="bestseller-footer-btn-1" type="submit" value="Delete Product">
                    </form>
                </div>
            </c:forEach>
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
        <h1 style="color: white; margin: 50px 0px 0px 100px">Comment:</h1>
        <div class="review-box">
            <c:forEach items="${rew}" var="rew" >
                <form action="deletecomment" method="post">
                    <input type="hidden" name="user_id" value="${rew.user_id}">
                    <input type="hidden" name="product_id" value="${rew.product_id}">
                    <input type="hidden" name="category_id" value="${category_id}">
                    <input type="submit" value="Delete" style="margin: -10px 0px 0px 20%; color: white; background-color: red; border: none; padding: 5px 10px;">
                </form>
                            <table class="review-table">
                            <tr>
                                <td>${rew.username}</td>
                            </tr>

                            <tr>
                                <td> Rating:<span> ${rew.rating}/100</span> Date: ${rew.review_date}</td>
                            </tr>
                            <tr>
                                <td> ${rew.comment}</td>
                            </tr>
                        </table>
                            
            </c:forEach>
        </div>
    </body>

</html>
