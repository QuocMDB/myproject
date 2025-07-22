<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ page import="model.Users" session="true" %>
<!DOCTYPE html>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>
<%@page import="model.Users"%>
<%
    Users user = (Users) session.getAttribute("user");
    if (user == null || !"Admin".equals(user.getRoleName()) && !"Nhân viên kho".equals(user.getRoleName())) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thống Kê Đơn Vị Tính - Warehouse Manager</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f5f7fa;
            color: #333;
            line-height: 1.6;
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

        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            border-radius: 15px;
            margin-bottom: 30px;
            box-shadow: 0 8px 32px rgba(0,0,0,0.1);
        }

        .header h1 {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 10px;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
        }

        .header p {
            font-size: 1.1rem;
            opacity: 0.9;
        }

        .filters-section {
            background: white;
            padding: 25px;
            border-radius: 15px;
            margin-bottom: 30px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
        }

        .filters-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            align-items: end;
        }

        .filter-group {
            display: flex;
            flex-direction: column;
        }

        .filter-group label {
            font-weight: 600;
            margin-bottom: 8px;
            color: #555;
            font-size: 0.9rem;
        }

        .filter-group select {
            padding: 12px;
            border: 2px solid #e1e8ed;
            border-radius: 8px;
            font-size: 1rem;
            background: white;
            color: #333;
            transition: all 0.3s ease;
        }

        .filter-group select:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        .filter-actions {
            display: flex;
            gap: 10px;
        }

        .filter-btn {
            padding: 12px 24px;
            border: none;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .filter-btn.primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .filter-btn.primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.4);
        }

        .filter-btn.secondary {
            background: #6c757d;
            color: white;
        }

        .filter-btn.secondary:hover {
            background: #545b62;
            transform: translateY(-2px);
        }

        .stats-overview {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 25px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
            border-left: 5px solid;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .stat-card::before {
            content: '';
            position: absolute;
            top: 0;
            right: 0;
            width: 100px;
            height: 100px;
            opacity: 0.1;
            border-radius: 50%;
            transform: translate(30px, -30px);
        }

        .stat-card.total-units {
            border-left-color: #667eea;
        }

        .stat-card.total-units::before {
            background: #667eea;
        }

        .stat-card.active-units {
            border-left-color: #28a745;
        }

        .stat-card.active-units::before {
            background: #28a745;
        }

        .stat-card.products-using {
            border-left-color: #17a2b8;
        }

        .stat-card.products-using::before {
            background: #17a2b8;
        }

        .stat-card.recent-units {
            border-left-color: #fd7e14;
        }

        .stat-card.recent-units::before {
            background: #fd7e14;
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
        }

        .stat-number {
            font-size: 3rem;
            font-weight: 700;
            color: #333;
            margin-bottom: 10px;
            position: relative;
            z-index: 1;
        }

        .stat-label {
            font-size: 1.1rem;
            color: #666;
            font-weight: 500;
            position: relative;
            z-index: 1;
        }

        .charts-section {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
            margin-bottom: 30px;
        }

        .chart-container {
            background: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
        }

        .chart-title {
            font-size: 1.4rem;
            font-weight: 700;
            margin-bottom: 25px;
            color: #333;
            text-align: center;
        }

        .details-section {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
            margin-bottom: 30px;
        }

        .detail-panel {
            background: white;
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
            overflow: hidden;
        }

        .panel-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            font-size: 1.2rem;
            font-weight: 600;
        }

        .panel-content {
            padding: 25px;
        }

        .unit-list {
            max-height: 400px;
            overflow-y: auto;
        }

        .unit-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px;
            border-bottom: 1px solid #eee;
            transition: background-color 0.3s ease;
        }

        .unit-item:hover {
            background-color: #f8f9fa;
        }

        .unit-item:last-child {
            border-bottom: none;
        }

        .unit-info {
            flex: 1;
        }

        .unit-name {
            font-weight: 600;
            color: #333;
            margin-bottom: 5px;
        }

        .unit-details {
            font-size: 0.9rem;
            color: #666;
        }

        .unit-stats {
            text-align: right;
        }

        .unit-count {
            font-size: 1.2rem;
            font-weight: 700;
            color: #667eea;
            margin-bottom: 5px;
        }

        .unit-usage {
            font-size: 0.85rem;
            padding: 3px 8px;
            border-radius: 12px;
            font-weight: 500;
        }

        .usage-high {
            background: #d4edda;
            color: #155724;
        }

        .usage-medium {
            background: #fff3cd;
            color: #856404;
        }

        .usage-low {
            background: #f8d7da;
            color: #721c24;
        }

        .recent-activities {
            background: white;
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
            margin-bottom: 30px;
        }

        .activity-item {
            display: flex;
            align-items: center;
            padding: 15px 25px;
            border-bottom: 1px solid #eee;
            transition: background-color 0.3s ease;
        }

        .activity-item:hover {
            background-color: #f8f9fa;
        }

        .activity-item:last-child {
            border-bottom: none;
        }

        .activity-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 15px;
            color: white;
            font-weight: bold;
        }

        .activity-content {
            flex: 1;
        }

        .activity-description {
            font-weight: 600;
            color: #333;
            margin-bottom: 5px;
        }

        .activity-meta {
            font-size: 0.9rem;
            color: #666;
        }

        .activity-time {
            font-size: 0.85rem;
            color: #999;
            text-align: right;
        }

        .type-stats-grid {
            display: grid;
            gap: 20px;
        }

        .type-stat-item {
            padding: 20px;
            background: #f8f9fa;
            border-radius: 10px;
            border-left: 4px solid #667eea;
            transition: all 0.3s ease;
        }

        .type-stat-item:hover {
            background: #e9ecef;
            transform: translateX(5px);
        }

        .type-name {
            font-size: 1.1rem;
            font-weight: 600;
            color: #333;
            margin-bottom: 10px;
        }

        .type-metrics {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 10px;
            font-size: 0.9rem;
            color: #666;
        }

        .error-message {
            background: #f8d7da;
            color: #721c24;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            border: 1px solid #f5c6cb;
        }

        @media (max-width: 768px) {
            .charts-section,
            .details-section {
                grid-template-columns: 1fr;
            }

            .stats-overview {
                grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            }

            .filters-grid {
                grid-template-columns: 1fr;
            }

            .filter-actions {
                justify-content: stretch;
            }

            .filter-actions .filter-btn {
                flex: 1;
            }
        }

        .no-data {
            text-align: center;
            padding: 40px;
            color: #666;
            font-style: italic;
        }

        .back-link {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            color: #667eea;
            text-decoration: none;
            font-weight: 600;
            margin-bottom: 20px;
            transition: color 0.3s ease;
        }

        .back-link:hover {
            color: #764ba2;
        }

        .status-indicator {
            display: inline-block;
            width: 8px;
            height: 8px;
            border-radius: 50%;
            margin-right: 6px;
        }

        .status-active {
            background: #28a745;
        }

        .status-inactive {
            background: #dc3545;
        }
    </style>
</head>
<body>
    <div class="layout-container">
        <jsp:include page="include/sidebar.jsp" />

        <div class="main-content">
            <a href="javascript:history.back()" class="back-link">
                ← Quay lại
            </a>

            <div class="header">
                <h1>📊 Thống Kê Đơn Vị Tính</h1>
                <p>Tổng quan về các đơn vị tính trong hệ thống và mức độ sử dụng</p>
            </div>

            <c:if test="${not empty error}">
                <div class="error-message">
                    ${error}
                </div>
            </c:if>

            <!-- Filters Section -->
            <div class="filters-section">
                <form method="get" action="unit-statistics">
                    <div class="filters-grid">
                        <div class="filter-group">
                            <label for="period">Thời gian</label>
                            <select id="period" name="period">
                                <option value="all" ${period == 'all' ? 'selected' : ''}>Tất cả thời gian</option>
                                <option value="week" ${period == 'week' ? 'selected' : ''}>7 ngày qua</option>
                                <option value="month" ${period == 'month' ? 'selected' : ''}>30 ngày qua</option>
                                <option value="quarter" ${period == 'quarter' ? 'selected' : ''}>90 ngày qua</option>
                            </select>
                        </div>
                        <!-- Unit type filter removed since database doesn't support it -->
                        <div class="filter-actions">
                            <button type="submit" class="filter-btn primary">Lọc dữ liệu</button>
                            <button type="button" class="filter-btn secondary" onclick="window.location.href='unit-statistics'">Đặt lại</button>
                        </div>
                    </div>
                </form>
            </div>

            <!-- Statistics Overview -->
            <div class="stats-overview">
                <div class="stat-card total-units">
                    <div class="stat-number">${totalUnits}</div>
                    <div class="stat-label">Tổng số đơn vị</div>
                </div>
                <div class="stat-card active-units">
                    <div class="stat-number">${activeUnitsCount}</div>
                    <div class="stat-label">Đơn vị đang hoạt động</div>
                </div>
                <div class="stat-card products-using">
                    <div class="stat-number">${totalProductsUsingUnits}</div>
                    <div class="stat-label">Sản phẩm sử dụng đơn vị</div>
                </div>
                <div class="stat-card recent-units">
                    <div class="stat-number">${recentUnitsCount}</div>
                    <div class="stat-label">Hoạt động gần đây</div>
                </div>
            </div>

            <!-- Charts Section -->
            <div class="charts-section">
                <!-- Unit Type Distribution -->
                <div class="chart-container">
                    <h3 class="chart-title">Thống kê đơn vị tính</h3>
                    <div class="type-stats-grid">
                        <c:forEach var="typeStat" items="${unitTypeStats}">
                            <div class="type-stat-item">
                                <div class="type-name">${typeStat.typeName}</div>
                                <div class="type-metrics">
                                    <div>Số đơn vị: <strong>${typeStat.unitCount}</strong></div>
                                    <div>Đang hoạt động: <strong>${typeStat.activeUnitCount}</strong></div>
                                    <div>Sản phẩm: <strong>${typeStat.totalProductCount}</strong></div>
                                    <div>Tỷ lệ hoạt động: <strong><fmt:formatNumber value="${typeStat.activePercentage}" pattern="#.#"/>%</strong></div>
                                </div>
                            </div>
                        </c:forEach>
                        <c:if test="${empty unitTypeStats}">
                            <div class="no-data">Không có dữ liệu thống kê đơn vị</div>
                        </c:if>
                    </div>
                </div>

                <!-- Unit Usage Chart -->
                <div class="chart-container">
                    <h3 class="chart-title">Mức độ sử dụng đơn vị</h3>
                    <div class="unit-list">
                        <c:forEach var="unitStat" items="${unitUsageStats}" begin="0" end="9">
                            <div class="unit-item">
                                <div class="unit-info">
                                    <div class="unit-name">
                                        <span class="status-indicator ${unitStat.status == 1 ? 'status-active' : 'status-inactive'}"></span>
                                        ${unitStat.unitName} (${unitStat.unitSymbol})
                                    </div>
                                    <div class="unit-details">${unitStat.unitType}</div>
                                </div>
                                <div class="unit-stats">
                                    <div class="unit-count">${unitStat.productCount}</div>
                                    <div class="unit-usage ${unitStat.productCount >= 15 ? 'usage-high' : (unitStat.productCount >= 5 ? 'usage-medium' : 'usage-low')}">
                                        ${unitStat.usageLevel}
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                        <c:if test="${empty unitUsageStats}">
                            <div class="no-data">Không có dữ liệu thống kê sử dụng</div>
                        </c:if>
                    </div>
                </div>
            </div>

            <!-- Detailed Statistics -->
            <div class="details-section">
                <!-- Top Used Units -->
                <div class="detail-panel">
                    <div class="panel-header">🔥 Đơn vị được sử dụng nhiều nhất</div>
                    <div class="panel-content">
                        <div class="unit-list">
                            <c:forEach var="unit" items="${topUsedUnits}">
                                <div class="unit-item">
                                    <div class="unit-info">
                                        <div class="unit-name">${unit.unitName} (${unit.unitSymbol})</div>
                                        <div class="unit-details">${unit.unitType}</div>
                                    </div>
                                    <div class="unit-stats">
                                        <div class="unit-count">${unit.productCount}</div>
                                        <div class="unit-usage usage-high">Phổ biến</div>
                                    </div>
                                </div>
                            </c:forEach>
                            <c:if test="${empty topUsedUnits}">
                                <div class="no-data">Không có dữ liệu</div>
                            </c:if>
                        </div>
                    </div>
                </div>

                <!-- Least Used Units -->
                <div class="detail-panel">
                    <div class="panel-header">📉 Đơn vị ít được sử dụng</div>
                    <div class="panel-content">
                        <div class="unit-list">
                            <c:forEach var="unit" items="${leastUsedUnits}">
                                <div class="unit-item">
                                    <div class="unit-info">
                                        <div class="unit-name">${unit.unitName} (${unit.unitSymbol})</div>
                                        <div class="unit-details">${unit.unitType}</div>
                                    </div>
                                    <div class="unit-stats">
                                        <div class="unit-count">${unit.productCount}</div>
                                        <div class="unit-usage usage-low">Ít sử dụng</div>
                                    </div>
                                </div>
                            </c:forEach>
                            <c:if test="${empty leastUsedUnits}">
                                <div class="no-data">Không có dữ liệu</div>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Recent Activities -->
            <div class="recent-activities">
                <div class="panel-header">📅 Hoạt động gần đây</div>
                <div class="panel-content">
                    <c:forEach var="activity" items="${recentUnitActivities}">
                        <div class="activity-item">
                            <div class="activity-icon">📦</div>
                            <div class="activity-content">
                                <div class="activity-description">${activity.description}</div>
                                <div class="activity-meta">
                                    Loại: ${activity.unitType} | Sản phẩm sử dụng: ${activity.productCount}
                                </div>
                            </div>
                            <div class="activity-time">${activity.formattedDate}</div>
                        </div>
                    </c:forEach>
                    <c:if test="${empty recentUnitActivities}">
                        <div class="no-data">Không có hoạt động nào gần đây</div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Auto-refresh data every 5 minutes
        setTimeout(function() {
            window.location.reload();
        }, 300000);

        // Add loading effect for form submission
        document.querySelector('form').addEventListener('submit', function() {
            const submitBtn = this.querySelector('.filter-btn.primary');
            submitBtn.textContent = 'Đang tải...';
            submitBtn.disabled = true;
        });
    </script>
</body>
</html>
