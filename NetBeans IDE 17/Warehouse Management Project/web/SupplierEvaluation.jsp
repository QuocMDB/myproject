<%-- 
    Document   : SupplierEvaluation
    Created on : 11 thg 6, 2025, 01:38:28
    Author     : Fpt06
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<%@ page import="model.Users" %> 
<%
Users user = (Users) session.getAttribute("user");
if (user == null || (!"Admin".equalsIgnoreCase(user.getRoleName())&&!"Nhân viên kho".equalsIgnoreCase(user.getRoleName()))) {
    response.sendRedirect("login.jsp");
    return;
}

%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Supplier Evaluation</title>
        <style>
            body {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
                font-family: 'Segoe UI', Arial, sans-serif;
                background: linear-gradient(120deg, #e0e7ff 0%, #f6f8fa 100%);
                min-height: 100vh;
            }

            /* Căn giữa toàn bộ */
            .container {
                min-height: 100vh;
                display: flex;
                justify-content: center;
                align-items: center;
                gap: 40px;
            }

            /* Hai bảng bằng nhau, glassmorphism, hiệu ứng */
            .left, .right {
                background: rgba(255,255,255,0.82);
                border-radius: 18px;
                box-shadow: 0 8px 40px rgba(26,77,143,0.13), 0 1.5px 10px rgba(0,0,0,0.07);
                padding: 32px 38px;
                min-width: 370px;
                width: 390px;
                min-height: 440px;
                display: flex;
                flex-direction: column;
                justify-content: stretch;
                align-items: flex-start;
                border: 1.5px solid #e0e7ff;
                backdrop-filter: blur(6px);
                position: relative;
                transition: box-shadow 0.35s, transform 0.3s, border 0.3s;
                /* Đảm bảo cùng chiều cao */
                height: 100%;
            }
            .left {
                animation: floatLeft 2.5s infinite ease-in-out alternate;
            }
            .right {
                animation: floatRight 2.5s infinite ease-in-out alternate;
            }

            @keyframes floatLeft {
                0% {
                    transform: translateY(0);
                }
                100% {
                    transform: translateY(-10px);
                }
            }
            @keyframes floatRight {
                0% {
                    transform: translateY(0);
                }
                100% {
                    transform: translateY(7px);
                }
            }

            .left:hover, .right:hover {
                box-shadow: 0 16px 48px 0 rgba(26,77,143,0.19), 0 1.5px 10px rgba(0,0,0,0.09);
                border: 1.5px solid #a5b4fc;
                transform: scale(1.025);
            }

            /* Tiêu đề có icon động */
            .left h2::before, .right h2::before {
                content: "📦 ";
                animation: bounce 1.4s infinite alternate;
                font-size: 22px;
                display: inline-block;
                margin-right: 6px;
            }
            .right h2::before {
                content: "⭐ ";
            }
            @keyframes bounce {
                0% {
                    transform: translateY(0);
                }
                100% {
                    transform: translateY(-4px);
                }
            }

            .left h2, .right h2 {
                margin-top: 0;
                color: #1a4d8f;
                margin-bottom: 24px;
                font-weight: bold;
                font-size: 23px;
                letter-spacing: 1px;
                text-shadow: 0 2px 10px #e0e7ff80;
            }

            table {
                width: 100%;
                border-collapse: separate;
                border-spacing: 0 4px;
            }

            td {
                padding: 8px 4px;
                vertical-align: top;
                font-size: 16px;
                transition: background 0.25s;
                border-radius: 6px;
            }
            tr:hover td {
                background: #e0e7ff32;
            }

            /* Hiệu ứng cho radio và sao */
            .radio-row {
                display: flex;
                gap: 8px;
                align-items: center;
            }
            .radio-row label {
                cursor: pointer;
                transition: transform 0.2s;
                display: flex;
                align-items: center;
                margin-right: 2px;
            }
            .radio-row input[type="radio"] {
                display: none;
            }
            .radio-row label .star {
                color: #b0b4c9;
                font-size: 19px;
                transition: color 0.2s, transform 0.2s, text-shadow 0.2s;
                margin-right: 1px;
                filter: drop-shadow(0 1px 2px #e0e7ff80);
            }
            .radio-row input[type="radio"]:checked + .star {
                color: #FFD700;
                transform: scale(1.22) rotate(-10deg);
                text-shadow: 0 0 10px #fff8c7, 0 2px 8px #ffd70055;
            }
            .radio-row label:hover .star,
            .radio-row input[type="radio"]:focus + .star {
                color: #ffdc73;
                transform: scale(1.15);
                text-shadow: 0 0 8px #fff7c0;
            }

            /* Nút Save hiệu ứng */
            input[type="submit"] {
                background: linear-gradient(90deg, #3b82f6 10%, #6366f1 90%);
                color: #fff;
                border: none;
                border-radius: 7px;
                padding: 12px 38px;
                font-size: 17px;
                cursor: pointer;
                font-weight: 600;
                margin-top: 8px;
                margin-bottom: 4px;
                box-shadow: 0 2px 12px rgba(99,102,241,0.08);
                transition: background 0.2s, transform 0.2s, box-shadow 0.2s;
                letter-spacing: 0.2px;
            }
            input[type="submit"]:hover {
                background: linear-gradient(90deg, #6366f1 10%, #3b82f6 90%);
                transform: scale(1.07) translateY(-2px);
                box-shadow: 0 6px 22px #6366f155;
            }

            .comment-box {
                width: 100%;
                min-height: 80px;
                max-width: 100%;
                padding: 10px 12px;
                border: 1.5px solid #c7d3e1;
                border-radius: 8px;
                font-size: 16px;
                resize: vertical;
                transition: border-color 0.2s, box-shadow 0.2s;
                font-family: inherit;
                background: #fafdffcc;
                box-sizing: border-box;
                margin-top: 2px;
            }
            .comment-box:focus {
                border-color: #6366f1;
                outline: none;
                box-shadow: 0 0 0 2px #b4d2ff77;
            }

            /* Nút Back gradient, icon, hiệu ứng sóng */
            .back-btn {
                display: inline-flex;
                align-items: center;
                gap: 7px;
                position: fixed;
                left: 40px;
                bottom: 40px;
                background: linear-gradient(100deg, #6366f1 10%, #3b82f6 90%);
                color: #fff;
                padding: 13px 32px;
                border-radius: 30px;
                font-size: 17px;
                text-decoration: none;
                font-weight: 500;
                box-shadow: 0 4px 18px rgba(99,102,241,0.13);
                transition: background 0.2s, transform 0.2s, box-shadow 0.2s;
                z-index: 1000;
                letter-spacing: 0.5px;
                border: none;
                overflow: hidden;
            }
            .back-btn::before {
                content: "⟵";
                font-size: 20px;
                margin-right: 7px;
                transition: margin 0.2s;
            }
            .back-btn:hover {
                background: linear-gradient(100deg, #3b82f6 10%, #6366f1 90%);
                transform: translateY(-2px) scale(1.07);
                box-shadow: 0 8px 28px rgba(99,102,241,0.23);
            }
            .back-btn:hover::before {
                margin-right: 16px;
            }
            @media (max-width: 900px) {
                .container {
                    flex-direction: column;
                    gap: 24px;
                }
                .back-btn {
                    left: 20px;
                    bottom: 20px;
                    padding: 12px 20px;
                }
                .left, .right {
                    width: 97vw;
                    min-width: unset;
                }
            }
            .radio-row input[type="radio"] {
                display: none;
            }
            .radio-row label .star {
                color: #b0b4c9;
                font-size: 19px;
                transition: color 0.2s, transform 0.2s, text-shadow 0.2s;
                margin-right: 2px;
                cursor: pointer;
            }
            .radio-row input[type="radio"]:checked ~ .star,
            .radio-row label:hover .star {
                color: #FFD700;
                transform: scale(1.15) rotate(-10deg);
                text-shadow: 0 0 8px #fff7c0;
            }
            .radio-row label:hover ~ label .star {
                color: #b0b4c9;
                transform: none;
                text-shadow: none;
            }
            .star-rating {
                direction: rtl;
                unicode-bidi: bidi-override;
                display: flex;
                gap: 2px;
                align-items: center;
                margin-top: 3px;
                flex-direction: row-reverse;
                justify-content: flex-start;
            }

            .star-rating input[type="radio"] {
                display: none;
            }

            .star-rating label {
                cursor: pointer;
                font-size: 26px;
                color: #b0b4c9;
                position: relative;
                transition: transform 0.18s, color 0.2s;
                padding: 0 2px;
                display: flex;
                flex-direction: column;
                align-items: center;
            }

            .star-rating label .star-num {
                display: block;
                font-size: 13px;
                color: #b0b4c9;
                font-weight: 500;
                margin-top: -2px;
                transition: color 0.2s;
            }

            /* Hiệu ứng khi hover hoặc chọn */
            .star-rating input[type="radio"]:checked ~ label,
            .star-rating label:hover,
            .star-rating label:hover ~ label {
                color: #FFD700;
                transform: scale(1.12);
            }

            .star-rating input[type="radio"]:checked ~ label .star-num,
            .star-rating label:hover .star-num,
            .star-rating label:hover ~ label .star-num {
                color: #FFD700;
            }
             .layout-container {
                display: flex;
                min-height: 100vh;
            }

            .main-content {
                flex: 1;
                padding: 20px;
                background: #f5f5f5;
            }
        </style>

    </head>
    <body>
        <div class="layout-container">
            <jsp:include page="/include/sidebar.jsp" />
            <div class="main-content">
        <c:set var="supplier" value="${requestScope.supplier}"/>
        <c:set var="mess" value="${requestScope.mess}"/>
        <c:set var="user" value="${sessionScope.user}"/>
        <c:set var="seid" value="${requestScope.seid}"/>
        <div class="container">
            <div class="left">
                <h2>Supplier Information</h2>
                <table>
                    <tr><td>Name:</td><td>${supplier.name}</td></tr>
                    <tr><td>Phone:</td><td>${supplier.phone}</td></tr>
                    <tr><td>Email:</td><td>${supplier.email}</td></tr>
                    <tr><td>Address:</td><td>${supplier.address}</td></tr>
                    <tr><td>Note:</td><td>${supplier.note}</td></tr>
                </table>
            </div>
            <div class="right">
                <h2>Supplier Evaluation</h2>
                <label style="color: red;font-weight: bold" >${mess}</label>
                <form action="TableSupplierEvaluation" method="post">
                    <table>
                        <tr>
                            <td><input type="hidden" name="supplier" value="${supplier.supplierID}"></td>
                            <td><input type="hidden" name="uid" value="${user.id}"></td>
                            <td><input type="hidden" name="seid" value="${seid}"></td>
                        </tr>
                        <tr>
                            <td>Delivery Time:</td>
                            <td>
                                <div class="star-rating">
                                    <input type="radio" id="delivery_time_star5" name="delivery_time" value="5" required />
                                    <label for="delivery_time_star5" title="5 stars">★<div class="star-num">5</div></label>
                                    <input type="radio" id="delivery_time_star4" name="delivery_time" value="4" />
                                    <label for="delivery_time_star4" title="4 stars">★<div class="star-num">4</div></label>
                                    <input type="radio" id="delivery_time_star3" name="delivery_time" value="3" />
                                    <label for="delivery_time_star3" title="3 stars">★<div class="star-num">3</div></label>
                                    <input type="radio" id="delivery_time_star2" name="delivery_time" value="2" />
                                    <label for="delivery_time_star2" title="2 stars">★<div class="star-num">2</div></label>
                                    <input type="radio" id="delivery_time_star1" name="delivery_time" value="1" />
                                    <label for="delivery_time_star1" title="1 star">★<div class="star-num">1</div></label>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>Market Price Comparison:</td>
                            <td>
                                <div class="star-rating">
                                    <input type="radio" id="market_price_comparison_star5" name="market_price_comparison" value="5" required />
                                    <label for="market_price_comparison_star5" title="5 stars">★<div class="star-num">5</div></label>
                                    <input type="radio" id="market_price_comparison_star4" name="market_price_comparison" value="4" />
                                    <label for="market_price_comparison_star4" title="4 stars">★<div class="star-num">4</div></label>
                                    <input type="radio" id="market_price_comparison_star3" name="market_price_comparison" value="3" />
                                    <label for="market_price_comparison_star3" title="3 stars">★<div class="star-num">3</div></label>
                                    <input type="radio" id="market_price_comparison_star2" name="market_price_comparison" value="2" />
                                    <label for="market_price_comparison_star2" title="2 stars">★<div class="star-num">2</div></label>
                                    <input type="radio" id="market_price_comparison_star1" name="market_price_comparison" value="1" />
                                    <label for="market_price_comparison_star1" title="1 star">★<div class="star-num">1</div></label>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>Supply Ability:</td>
                            <td>
                                <div class="star-rating">
                                    <input type="radio" id="transparency_reputation_star5" name="transparency_reputation" value="5" required />
                                    <label for="transparency_reputation_star5" title="5 stars">★<div class="star-num">5</div></label>
                                    <input type="radio" id="transparency_reputation_star4" name="transparency_reputation" value="4" />
                                    <label for="transparency_reputation_star4" title="4 stars">★<div class="star-num">4</div></label>
                                    <input type="radio" id="transparency_reputation_star3" name="transparency_reputation" value="3" />
                                    <label for="transparency_reputation_star3" title="3 stars">★<div class="star-num">3</div></label>
                                    <input type="radio" id="transparency_reputation_star2" name="transparency_reputation" value="2" />
                                    <label for="transparency_reputation_star2" title="2 stars">★<div class="star-num">2</div></label>
                                    <input type="radio" id="transparency_reputation_star1" name="transparency_reputation" value="1" />
                                    <label for="transparency_reputation_star1" title="1 star">★<div class="star-num">1</div></label>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>Service Quality:</td>
                            <td>
                                <div class="star-rating">
                                    <input type="radio" id="service_quality_star5" name="service_quality" value="5" required />
                                    <label for="service_quality_star5" title="5 stars">★<div class="star-num">5</div></label>
                                    <input type="radio" id="service_quality_star4" name="service_quality" value="4" />
                                    <label for="service_quality_star4" title="4 stars">★<div class="star-num">4</div></label>
                                    <input type="radio" id="service_quality_star3" name="service_quality" value="3" />
                                    <label for="service_quality_star3" title="3 stars">★<div class="star-num">3</div></label>
                                    <input type="radio" id="service_quality_star2" name="service_quality" value="2" />
                                    <label for="service_quality_star2" title="2 stars">★<div class="star-num">2</div></label>
                                    <input type="radio" id="service_quality_star1" name="service_quality" value="1" />
                                    <label for="service_quality_star1" title="1 star">★<div class="star-num">1</div></label>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>Comment:</td>
                            <td>
                                <textarea name="comment" rows="1" class="comment-box"></textarea>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" style="text-align: center;">
                                <input type="submit" value="Save">
                            </td>
                        </tr>
                    </table>
                </form>
            </div>
        </div>
                        </div>
        <a href="LishSupplier" class="back-btn">Back</a>
    </body>

</html>

