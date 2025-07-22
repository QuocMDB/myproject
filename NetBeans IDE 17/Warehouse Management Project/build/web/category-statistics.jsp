<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>
<%@page import="model.Users"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDate"%>
<%
    Users user = (Users) session.getAttribute("user");
    if (user == null || !"Admin".equals(user.getRoleName()) && !"Nhân viên kho".equals(user.getRoleName())) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Date formatter for LocalDateTime
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
    request.setAttribute("dateFormatter", formatter);
%>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Thống kê danh mục loại sản phẩm</title>
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: Arial, sans-serif;
                background: #f5f5f5;
                color: #333;
            }

            .layout-container {
                display: flex;
                min-height: 100vh;
            }

            .main-content {
                flex: 1;
                padding: 20px;
            }

            .header {
                background: white;
                padding: 20px;
                margin-bottom: 20px;
                border-radius: 5px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .page-title {
                color: #333;
                font-size: 24px;
            }

            .header-user {
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .logout-btn {
                background: red;
                color: white;
                padding: 8px 16px;
                border-radius: 4px;
                text-decoration: none;
                font-size: 14px;
            }

            .nav-buttons {
                margin-bottom: 20px;
            }

            .btn {
                padding: 10px 20px;
                border-radius: 4px;
                text-decoration: none;
                margin-right: 10px;
                display: inline-block;
                border: none;
                cursor: pointer;
            }

            .btn-info {
                background: #17a2b8;
                color: white;
            }

            .btn-success {
                background: #28a745;
                color: white;
            }

            /* Stats Cards */
            .stats-container {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                gap: 20px;
                margin-bottom: 30px;
            }

            .stat-card {
                background: white;
                padding: 20px;
                border-radius: 5px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
                text-align: center;
            }

            .stat-card h3 {
                font-size: 14px;
                color: #666;
                margin-bottom: 10px;
            }

            .stat-card .value {
                font-size: 32px;
                font-weight: bold;
                margin-bottom: 5px;
            }

            .stat-card .sub-text {
                font-size: 12px;
                color: #999;
            }

            .stat-card.primary .value {
                color: #007bff;
            }
            .stat-card.success .value {
                color: #28a745;
            }
            .stat-card.warning .value {
                color: #ffc107;
            }
            .stat-card.danger .value {
                color: #dc3545;
            }
            
            /* Special cards for category statistics */
            .stat-card.special {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
            }
            
            .stat-card.special h3 {
                color: white;
            }
            
            .stat-card.special .value {
                color: white;
                font-size: 24px;
            }
            
            .stat-card.special .sub-text {
                color: rgba(255,255,255,0.8);
            }
            
            .stat-card.special .detail-info {
                margin-top: 10px;
                font-size: 14px;
                color: rgba(255,255,255,0.9);
            }

            /* Time-based statistics */
            .time-stats-container {
                background: white;
                padding: 20px;
                border-radius: 5px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
                margin-bottom: 20px;
            }

            .time-stats-container h3 {
                margin-bottom: 20px;
                color: #333;
            }

            .time-stats-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                gap: 20px;
            }

            .time-stat-item {
                text-align: center;
                padding: 15px;
                border: 1px solid #e0e0e0;
                border-radius: 5px;
                transition: all 0.3s ease;
            }

            .time-stat-item:hover {
                border-color: #007bff;
                box-shadow: 0 2px 8px rgba(0,123,255,0.1);
            }

            .time-stat-item h4 {
                font-size: 16px;
                color: #666;
                margin-bottom: 10px;
            }

            .time-stat-item .count {
                font-size: 28px;
                font-weight: bold;
                color: #007bff;
                margin-bottom: 5px;
            }

            .time-stat-item .period {
                font-size: 12px;
                color: #999;
            }

            /* Recent items */
            .recent-container {
                background: white;
                padding: 20px;
                border-radius: 5px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
                margin-bottom: 20px;
            }

            .recent-list {
                list-style: none;
            }

            .recent-item {
                padding: 10px;
                border-bottom: 1px solid #eee;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .recent-item:last-child {
                border-bottom: none;
            }

            .recent-date {
                font-size: 12px;
                color: #999;
            }
            
            .recent-item .status-badge {
                display: inline-block;
                padding: 2px 8px;
                border-radius: 12px;
                font-size: 11px;
                margin-left: 8px;
            }
            
            .status-badge.active {
                background: #d4edda;
                color: #155724;
            }
            
            .status-badge.inactive {
                background: #f8d7da;
                color: #721c24;
            }

            /* Chart container */
            .chart-container {
                background: white;
                padding: 20px;
                border-radius: 5px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
                margin-bottom: 20px;
            }

            .chart-wrapper {
                position: relative;
                height: 300px;
                margin-top: 20px;
            }

            /* Loading overlay */
            .loading-overlay {
                display: none;
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(0,0,0,0.5);
                z-index: 9999;
                justify-content: center;
                align-items: center;
            }

            .loading-spinner {
                width: 50px;
                height: 50px;
                border: 5px solid #f3f3f3;
                border-top: 5px solid #3498db;
                border-radius: 50%;
                animation: spin 1s linear infinite;
            }

            @keyframes spin {
                0% {
                    transform: rotate(0deg);
                }
                100% {
                    transform: rotate(360deg);
                }
            }

            /* Date info */
            .date-info {
                text-align: right;
                font-size: 12px;
                color: #666;
                margin-bottom: 10px;
            }

            /* Export buttons */
            .export-buttons {
                text-align: right;
                margin-top: 15px;
            }

            .btn-export {
                padding: 8px 16px;
                margin-left: 10px;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                color: white;
            }

            .btn-excel {
                background: #107c41;
            }

            .btn-pdf {
                background: #d32f2f;
            }

            /* Category badge */
            .category-badge {
                display: inline-block;
                padding: 4px 8px;
                border-radius: 3px;
                font-size: 12px;
                background: #e9ecef;
                color: #495057;
                margin-left: 10px;
            }
        </style>
    </head>
    <body>
        <!-- Loading overlay -->
        <div class="loading-overlay" id="loadingOverlay">
            <div class="loading-spinner"></div>
        </div>

        <div class="layout-container">
            <jsp:include page="/include/sidebar.jsp" />
            <div class="main-content">
                <!-- Header -->
                <div class="header">
                    <h1 class="page-title">Thống kê danh mục loại sản phẩm</h1>
                    <div class="header-user">
                        <span><%= user.getFullname()%></span>
                        <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Đăng xuất</a>
                    </div>
                </div>

                <!-- Navigation -->
                <div class="nav-buttons">
                    <a href="${pageContext.request.contextPath}/category/list" class="btn btn-info">← Quay lại</a>
                </div>

                <!-- Date info -->
                <div class="date-info">
                    Cập nhật: <%= new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(new java.util.Date()) %>
                </div>

                <!-- Error message if any -->
                <c:if test="${not empty errorMessage}">
                    <div style="background: #f8d7da; color: #721c24; padding: 15px; border-radius: 5px; margin-bottom: 20px;">
                        ${errorMessage}
                    </div>
                </c:if>

                <!-- Stats Cards -->
                <div class="stats-container">
                    <div class="stat-card primary">
                        <h3>Tổng số danh mục loại sản phẩm</h3>
                        <div class="value">
                            <c:choose>
                                <c:when test="${not empty stats.totalCategories}">${stats.totalCategories}</c:when>
                                <c:otherwise>0</c:otherwise>
                            </c:choose>
                        </div>
                        <div class="sub-text">
                            <c:if test="${not empty monthlyDifferenceSign && not empty monthlyDifference}">
                                ${monthlyDifferenceSign}${monthlyDifference} so với tháng trước
                            </c:if>
                        </div>
                    </div>
                    <div class="stat-card success">
                        <h3>Loại sản phẩm hoạt động</h3>
                        <div class="value">
                            <c:choose>
                                <c:when test="${not empty stats.activeCategories}">${stats.activeCategories}</c:when>
                                <c:otherwise>0</c:otherwise>
                            </c:choose>
                        </div>
                        <div class="sub-text">
                            <c:if test="${not empty activePercentage}">${activePercentage}%</c:if>
                        </div>
                    </div>
                    <div class="stat-card warning">
                        <h3>Loại sản phẩm ngừng kinh doanh</h3>
                        <div class="value">
                            <c:choose>
                                <c:when test="${not empty stats.inactiveCategories}">${stats.inactiveCategories}</c:when>
                                <c:otherwise>0</c:otherwise>
                            </c:choose>
                        </div>
                        <div class="sub-text">
                            <c:if test="${not empty inactivePercentage}">${inactivePercentage}%</c:if>
                        </div>
                    </div>
                    <div class="stat-card danger">
                        <h3>Loại SP có nhiều sản phẩm nhất</h3>
                        <div class="value">
                            <c:choose>
                                <c:when test="${not empty topCategory && not empty topCategory.name}">${topCategory.name}</c:when>
                                <c:otherwise>N/A</c:otherwise>
                            </c:choose>
                        </div>
                        <div class="sub-text">
                            <c:if test="${not empty topCategory && topCategory.totalProducts > 0}">
                                ${topCategory.totalProducts} sản phẩm
                                <c:if test="${not empty topCategory.parentName}">
                                    <br/>Thuộc: ${topCategory.parentName}
                                </c:if>
                            </c:if>
                        </div>
                    </div>
                </div>
                
               
                <!-- Time-based Statistics -->
                <div class="time-stats-container">
                    <h3>Thống kê danh mục loại sản phẩm được thêm theo thời gian</h3>
                    <div class="time-stats-grid">
                        <div class="time-stat-item">
                            <h4>Tháng này</h4>
                            <div class="count">${timeStats.thisMonth}</div>
                            <div class="period">${timeStats.thisMonthPeriod}</div>
                        </div>
                        <div class="time-stat-item">
                            <h4>Quý này</h4>
                            <div class="count">${timeStats.thisQuarter}</div>
                            <div class="period">${timeStats.thisQuarterPeriod}</div>
                        </div>
                        <div class="time-stat-item">
                            <h4>6 tháng gần nhất</h4>
                            <div class="count">${timeStats.lastSixMonths}</div>
                            <div class="period">${timeStats.lastSixMonthsPeriod}</div>
                        </div>
                        <div class="time-stat-item">
                            <h4>Năm nay</h4>
                            <div class="count">${timeStats.thisYear}</div>
                            <div class="period">Năm ${timeStats.currentYear}</div>
                        </div>
                    </div>

                    <div class="export-buttons">
                        <button class="btn-export btn-excel" onclick="exportToExcel()">📊 Xuất Excel</button>
                    </div>
                </div>

                <!-- Recently Added Categories with Enhanced Info -->
                <div class="recent-container">
                    <h3>Loại sản phẩm được thêm gần đây</h3>
                    <ul class="recent-list">
                        <c:forEach items="${recentCategories}" var="category">
                            <li class="recent-item">
                                <div>
                                    <strong>${category.name}</strong>
                                    <span class="category-badge">${category.parentName}</span>
                                    <span style="color: #666; font-size: 14px;"> - ${category.productCount} sản phẩm</span>
                                    <c:if test="${not empty category.activeProducts}">
                                        <span style="color: #28a745; font-size: 12px;"> (${category.activeProducts} hoạt động)</span>
                                    </c:if>
                                    <span class="status-badge ${category.activeFlag ? 'active' : 'inactive'}">
                                        ${category.activeFlag ? 'Đang hoạt động' : 'Ngừng hoạt động'}
                                    </span>
                                </div>
                                <div class="recent-date">
                                    <c:if test="${category.createDate != null}">
                                        ${category.createDate.format(dateFormatter)}
                                        <c:if test="${not empty category.daysSinceCreated}">
                                            <br/><small>${category.daysSinceCreated} ngày trước</small>
                                        </c:if>
                                    </c:if>
                                </div>
                            </li>
                        </c:forEach>
                        <c:if test="${empty recentCategories}">
                            <li class="recent-item">
                                <span style="color: #999;">Chưa có danh mục loại sản phẩm nào được thêm gần đây</span>
                            </li>
                        </c:if>
                    </ul>
                </div>

            </div>
        </div>

        <script>
            // Store values from server
            const statsData = {
                totalCategories: ${stats.totalCategories != null ? stats.totalCategories : 0},
                activeCategories: ${stats.activeCategories != null ? stats.activeCategories : 0},
                inactiveCategories: ${stats.inactiveCategories != null ? stats.inactiveCategories : 0},
                topCategoryName: '${topCategory.name != null ? topCategory.name : "N/A"}',
                topCategoryProductCount: ${topCategory.totalProducts != null ? topCategory.totalProducts : 0},
                topCategoryParentName: '${topCategory.parentName != null ? topCategory.parentName : "N/A"}',
                mostRecentCategoryName: '${mostRecentCategory.name != null ? mostRecentCategory.name : "N/A"}',
                mostRecentCategoryDate: '${mostRecentCategory.createDateFormatted != null ? mostRecentCategory.createDateFormatted : "N/A"}',
                thisMonth: ${timeStats.thisMonth != null ? timeStats.thisMonth : 0},
                thisMonthPeriod: '${timeStats.thisMonthPeriod != null ? timeStats.thisMonthPeriod : ""}',
                thisQuarter: ${timeStats.thisQuarter != null ? timeStats.thisQuarter : 0},
                thisQuarterPeriod: '${timeStats.thisQuarterPeriod != null ? timeStats.thisQuarterPeriod : ""}',
                lastSixMonths: ${timeStats.lastSixMonths != null ? timeStats.lastSixMonths : 0},
                lastSixMonthsPeriod: '${timeStats.lastSixMonthsPeriod != null ? timeStats.lastSixMonthsPeriod : ""}',
                thisYear: ${timeStats.thisYear != null ? timeStats.thisYear : 0},
                currentYear: ${timeStats.currentYear != null ? timeStats.currentYear : 2025}
            };

            // Chart data
            const chartLabels = [];
            const chartData = [];
            const chartColors = [];
            
            <c:forEach items="${categoryDistribution}" var="item">
                chartLabels.push('${item.name}');
                chartData.push(${item.productCount});
                chartColors.push('hsl(' + Math.random() * 360 + ', 70%, 60%)');
            </c:forEach>

            // Create chart
            if (chartLabels.length > 0) {
                const ctx = document.getElementById('categoryChart').getContext('2d');
                new Chart(ctx, {
                    type: 'doughnut',
                    data: {
                        labels: chartLabels,
                        datasets: [{
                            data: chartData,
                            backgroundColor: chartColors,
                            borderWidth: 2,
                            borderColor: '#fff'
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: {
                            legend: {
                                position: 'right',
                                labels: {
                                    padding: 15,
                                    font: {
                                        size: 12
                                    }
                                }
                            },
                            tooltip: {
                                callbacks: {
                                    label: function(context) {
                                        const label = context.label || '';
                                        const value = context.parsed || 0;
                                        const total = context.dataset.data.reduce((a, b) => a + b, 0);
                                        const percentage = ((value / total) * 100).toFixed(1);
                                        return label + ': ' + value + ' sản phẩm (' + percentage + '%)';
                                    }
                                }
                            }
                        }
                    }
                });
            }

            // Export to Excel function
            function exportToExcel() {
                let csvContent = '\ufeff'; // BOM for UTF-8

                // Add header
                csvContent += 'Thống kê danh mục loại sản phẩm - Xuất ngày: ' + new Date().toLocaleDateString('vi-VN') + '\n\n';

                // Add main statistics
                csvContent += 'THỐNG KÊ TỔNG QUAN\n';
                csvContent += 'Tổng số danh mục loại sản phẩm,' + statsData.totalCategories + '\n';
                csvContent += 'Loại sản phẩm hoạt động,' + statsData.activeCategories + '\n';
                csvContent += 'Loại sản phẩm ngừng kinh doanh,' + statsData.inactiveCategories + '\n';
                csvContent += 'Loại SP có nhiều sản phẩm nhất,"' + statsData.topCategoryName + '",' + statsData.topCategoryProductCount + ' sản phẩm \n';
               
                // Add time-based statistics
                csvContent += 'THỐNG KÊ THEO THỜI GIAN\n';
                csvContent += 'Tháng này,' + statsData.thisMonth + ',"' + statsData.thisMonthPeriod + '"\n';
                csvContent += 'Quý này,' + statsData.thisQuarter + ',"' + statsData.thisQuarterPeriod + '"\n';
                csvContent += '6 tháng gần nhất,' + statsData.lastSixMonths + ',"' + statsData.lastSixMonthsPeriod + '"\n';
                csvContent += 'Năm nay,' + statsData.thisYear + ',Năm ' + statsData.currentYear + '\n\n';

                // Add distribution data
                if (chartLabels.length > 0) {
                    csvContent += 'PHÂN BỐ SẢN PHẨM THEO LOẠI\n';
                    csvContent += 'Loại sản phẩm,Số lượng sản phẩm\n';
                    for (let i = 0; i < chartLabels.length; i++) {
                        csvContent += '"' + chartLabels[i] + '",' + chartData[i] + '\n';
                    }
                }

                // Create blob and download
                const blob = new Blob([csvContent], {type: 'text/csv;charset=utf-8;'});
                const link = document.createElement('a');
                const url = URL.createObjectURL(blob);
                link.setAttribute('href', url);
                link.setAttribute('download', 'thong_ke_loai_san_pham_' + new Date().getTime() + '.csv');
                link.style.visibility = 'hidden';
                document.body.appendChild(link);
                link.click();
                document.body.removeChild(link);
            }

            // Add print styles
            const printStyles = document.createElement('style');
            printStyles.textContent = `
                @media print {
                    .header-user, .nav-buttons, .export-buttons, .layout-container > :first-child {
                        display: none !important;
                    }
                    .main-content {
                        margin: 0;
                        padding: 20px;
                    }
                    .time-stat-item, .recent-item {
                        page-break-inside: avoid;
                    }
                    .chart-wrapper {
                        height: 400px !important;
                    }
                }
            `;
            document.head.appendChild(printStyles);
        </script>
    </body>
</html>