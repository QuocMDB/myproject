
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Danh sách yêu cầu nhập kho | Hệ thống quản lý kho</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            /* CSS giữ nguyên như trước */
            * {
                box-sizing: border-box;
                margin: 0;
                padding: 0;
                font-family: 'Inter', sans-serif;
            }

            :root {
                --primary: #2563eb;
                --primary-dark: #1d4ed8;
                --secondary: #64748b;
                --success: #10b981;
                --danger: #ef4444;
                --warning: #f59e0b;
                --info: #3b82f6;
                --light: #f9fafb;
                --dark: #1e293b;
                --gray-50: #f8fafc;
                --gray-100: #f1f5f9;
                --gray-200: #e2e8f0;
                --gray-300: #cbd5e1;
                --gray-400: #94a3b8;
                --gray-500: #64748b;
                --gray-600: #475569;
                --gray-700: #334155;
                --gray-800: #1e293b;
                --gray-900: #0f172a;
                --border-radius: 0.375rem;
                --shadow-sm: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
                --shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1), 0 1px 2px 0 rgba(0, 0, 0, 0.06);
                --shadow-md: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
                --shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
            }

            body {
                background-color: var(--gray-100);
                color: var(--gray-800);
                line-height: 1.5;
                font-size: 0.875rem;
            }

            .container {
                max-width: 1200px;
                margin: 2rem auto;
                padding: 0 1rem;
            }

            .card {
                background-color: white;
                border-radius: var(--border-radius);
                box-shadow: var(--shadow-md);
                overflow: hidden;
            }

            .card-header {
                background-color: white;
                padding: 1.25rem 1.5rem;
                border-bottom: 1px solid var(--gray-200);
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .card-body {
                padding: 1.5rem;
            }

            .card-footer {
                background-color: var(--gray-50);
                padding: 1rem 1.5rem;
                border-top: 1px solid var(--gray-200);
            }

            h1, h2, h3, h4, h5, h6 {
                color: var(--gray-900);
                font-weight: 600;
                line-height: 1.25;
                margin-bottom: 1rem;
            }

            h1 {
                font-size: 1.5rem;
            }
            h2 {
                font-size: 1.25rem;
            }
            p {
                margin-bottom: 1rem;
            }

            .breadcrumbs {
                display: flex;
                align-items: center;
                gap: 0.5rem;
                font-size: 0.875rem;
                margin-bottom: 1.5rem;
                color: var(--gray-500);
            }

            .breadcrumbs a {
                color: var(--gray-600);
                text-decoration: none;
            }

            .breadcrumbs a:hover {
                color: var(--primary);
            }

            .breadcrumbs .separator {
                color: var(--gray-400);
            }

            .breadcrumbs .current {
                color: var(--gray-800);
                font-weight: 500;
            }

            .alert {
                padding: 1rem 1.25rem;
                border-radius: var(--border-radius);
                margin-bottom: 1.5rem;
                display: flex;
                align-items: center;
                gap: 0.75rem;
            }

            .alert-icon {
                flex-shrink: 0;
                width: 1.5rem;
                height: 1.5rem;
                display: flex;
                align-items: center;
                justify-content: center;
                border-radius: 50%;
            }

            .alert-content {
                flex: 1;
            }

            .alert-title {
                font-weight: 600;
                margin-bottom: 0.25rem;
            }

            .alert-close {
                flex-shrink: 0;
                cursor: pointer;
                color: inherit;
                opacity: 0.7;
                transition: opacity 0.15s;
            }

            .alert-close:hover {
                opacity: 1;
            }

            .alert-success {
                background-color: #ecfdf5;
                color: #065f46;
            }

            .alert-success .alert-icon {
                background-color: #10b981;
                color: white;
            }

            .alert-danger {
                background-color: #fef2f2;
                color: #b91c1c;
            }

            .alert-danger .alert-icon {
                background-color: #ef4444;
                color: white;
            }

            .alert-info {
                background-color: #eff6ff;
                color: #1e40af;
            }

            .alert-info .alert-icon {
                background-color: #3b82f6;
                color: white;
            }

            .form-group {
                margin-bottom: 1.25rem;
            }

            .form-label {
                display: block;
                margin-bottom: 0.5rem;
                font-weight: 500;
                color: var(--gray-700);
            }

            .form-control {
                display: block;
                width: 100%;
                padding: 0.625rem 0.875rem;
                font-size: 0.875rem;
                line-height: 1.5;
                color: var(--gray-900);
                background-color: white;
                background-clip: padding-box;
                border: 1px solid var(--gray-300);
                border-radius: var(--border-radius);
                transition: border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out;
            }

            .form-control:focus {
                border-color: var(--primary);
                outline: 0;
                box-shadow: 0 0 0 0.2rem rgba(37, 99, 235, 0.25);
            }

            .form-control::placeholder {
                color: var(--gray-400);
            }

            .btn {
                display: inline-block;
                font-weight: 500;
                text-align: center;
                vertical-align: middle;
                user-select: none;
                padding: 0.625rem 1rem;
                font-size: 0.875rem;
                line-height: 1.5;
                border-radius: var(--border-radius);
                border: 1px solid transparent;
                transition: color 0.15s ease-in-out, background-color 0.15s ease-in-out,
                    border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out;
                cursor: pointer;
                text-decoration: none;
            }

            .btn:focus {
                outline: 0;
                box-shadow: 0 0 0 0.2rem rgba(37, 99, 235, 0.25);
            }

            .btn-sm {
                padding: 0.375rem 0.75rem;
                font-size: 0.75rem;
            }

            .btn-primary {
                color: white;
                background-color: var(--primary);
                border-color: var(--primary);
            }

            .btn-primary:hover {
                background-color: var(--primary-dark);
                border-color: var(--primary-dark);
            }

            .btn-secondary {
                color: white;
                background-color: var(--secondary);
                border-color: var(--secondary);
            }

            .btn-secondary:hover {
                background-color: #4b5563;
                border-color: #4b5563;
            }

            .btn-success {
                color: white;
                background-color: var(--success);
                border-color: var(--success);
            }

            .btn-success:hover {
                background-color: #059669;
                border-color: #059669;
            }

            .btn-info {
                color: white;
                background-color: var(--info);
                border-color: var(--info);
            }

            .btn-info:hover {
                background-color: #2563eb;
                border-color: #2563eb;
            }

            .btn-warning {
                color: white;
                background-color: var(--warning);
                border-color: var(--warning);
            }

            .btn-warning:hover {
                background-color: #d97706;
                border-color: #d97706;
            }

            .btn-icon {
                display: inline-flex;
                align-items: center;
                gap: 0.5rem;
            }

            .table-container {
                margin-bottom: 1.5rem;
                overflow-x: auto;
                border-radius: var(--border-radius);
                box-shadow: var(--shadow);
            }

            .table {
                width: 100%;
                margin-bottom: 0;
                color: var(--gray-700);
                border-collapse: collapse;
            }

            .table th,
            .table td {
                padding: 0.875rem 1.25rem;
                vertical-align: middle;
                border-bottom: 1px solid var(--gray-200);
            }

            .table th {
                font-weight: 600;
                color: var(--gray-800);
                background-color: var(--gray-50);
                text-align: left;
                font-size: 0.75rem;
                text-transform: uppercase;
                letter-spacing: 0.05em;
            }

            .table tbody tr:last-child td {
                border-bottom: none;
            }

            .table-hover tbody tr:hover {
                background-color: var(--gray-50);
            }

            .pagination {
                display: flex;
                padding-left: 0;
                list-style: none;
                border-radius: var(--border-radius);
            }

            .page-item {
                margin: 0 0.125rem;
            }

            .page-item.active .page-link {
                background-color: var(--primary);
                border-color: var(--primary);
                color: white;
            }

            .page-item.disabled .page-link {
                color: var(--gray-400);
                pointer-events: none;
                background-color: var(--gray-100);
                border-color: var(--gray-200);
            }

            .page-link {
                position: relative;
                display: flex;
                align-items: center;
                justify-content: center;
                padding: 0.5rem 0.75rem;
                margin-left: -1px;
                line-height: 1.25;
                color: var(--primary);
                background-color: white;
                border: 1px solid var(--gray-200);
                text-decoration: none;
                min-width: 2.25rem;
                transition: all 0.15s ease-in-out;
            }

            .page-link:hover {
                z-index: 2;
                color: var(--primary-dark);
                text-decoration: none;
                background-color: var(--gray-100);
                border-color: var(--gray-200);
            }

            /* CSS cho tìm kiếm cải tiến */
            .filter-panel {
                background-color: white;
                border-radius: var(--border-radius);
                padding: 1.25rem;
                margin-bottom: 1.5rem;
                box-shadow: var(--shadow);
            }

            .filter-title {
                font-size: 0.875rem;
                font-weight: 600;
                margin-bottom: 1rem;
                color: var(--gray-700);
                text-transform: uppercase;
                letter-spacing: 0.05em;
            }

            .filter-row {
                display: flex;
                flex-wrap: wrap;
                gap: 1rem;
                align-items: end;
            }

            .filter-item {
                flex: 1;
                min-width: 200px;
            }

            .search-group {
                display: flex;
                gap: 0.5rem;
                align-items: end;
            }

            .search-group .form-control {
                flex: 1;
            }

            /* Highlight search results */
            mark {
                background-color: #fff3cd;
                color: #856404;
                padding: 0.1em 0.2em;
                border-radius: 0.2em;
                font-weight: 500;
            }

            .searchable {
                position: relative;
            }

            /* Status badges */
            .status-badge {
                display: inline-block;
                padding: 0.25rem 0.5rem;
                font-size: 0.75rem;
                font-weight: 500;
                border-radius: 0.25rem;
                text-transform: uppercase;
                letter-spacing: 0.05em;
            }

            .status-completed {
                background-color: #d1fae5;
                color: #065f46;
            }

            .status-pending {
                background-color: #fef3c7;
                color: #92400e;
            }

            .status-processing {
                background-color: #dbeafe;
                color: #1e40af;
            }

            .status-cancelled {
                background-color: #fee2e2;
                color: #991b1b;
            }

            .status-rejected {
                background-color: #fee2e2;
                color: #991b1b;
            }

            .d-flex {
                display: flex !important;
            }

            .align-items-center {
                align-items: center !important;
            }

            .justify-content-between {
                justify-content: space-between !important;
            }

            .justify-content-center {
                justify-content: center !important;
            }

            .gap-2 {
                gap: 0.5rem !important;
            }

            .gap-3 {
                gap: 0.75rem !important;
            }

            .mb-0 {
                margin-bottom: 0 !important;
            }

            .mb-2 {
                margin-bottom: 0.5rem !important;
            }

            .mb-3 {
                margin-bottom: 0.75rem !important;
            }

            .mb-4 {
                margin-bottom: 1rem !important;
            }

            .text-center {
                text-align: center !important;
            }

            .text-muted {
                color: var(--gray-500) !important;
            }

            .modal {
                display: none;
                position: fixed;
                z-index: 1050;
                left: 0;
                top: 0;
                width: 100%;
                height: 100%;
                overflow: auto;
                background-color: rgba(0, 0, 0, 0.4);
            }

            .modal-dialog {
                position: relative;
                width: auto;
                margin: 1.75rem auto;
                max-width: 800px;
            }

            .modal-content {
                position: relative;
                display: flex;
                flex-direction: column;
                width: 100%;
                background-color: white;
                border-radius: var(--border-radius);
                box-shadow: var(--shadow-lg);
                outline: 0;
            }

            .modal-header {
                display: flex;
                align-items: center;
                justify-content: space-between;
                padding: 1.25rem;
                border-bottom: 1px solid var(--gray-200);
            }

            .modal-title {
                margin-bottom: 0;
                font-size: 1.25rem;
            }

            .modal-close {
                background: transparent;
                border: 0;
                font-size: 1.25rem;
                cursor: pointer;
                color: var(--gray-500);
            }

            .modal-body {
                position: relative;
                flex: 1 1 auto;
                padding: 1.25rem;
            }

            .modal-footer {
                display: flex;
                align-items: center;
                justify-content: flex-end;
                padding: 1.25rem;
                border-top: 1px solid var(--gray-200);
                gap: 0.5rem;
            }

            /* Statistics cards */
            .stats-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                gap: 1rem;
                margin-bottom: 1.5rem;
            }

            .stat-card {
                background-color: white;
                border-radius: var(--border-radius);
                padding: 1.25rem;
                box-shadow: var(--shadow);
                border-left: 4px solid var(--primary);
            }

            .stat-card.success {
                border-left-color: var(--success);
            }

            .stat-card.warning {
                border-left-color: var(--warning);
            }

            .stat-card.info {
                border-left-color: var(--info);
            }

            .stat-value {
                font-size: 2rem;
                font-weight: 700;
                color: var(--gray-900);
                margin-bottom: 0.25rem;
            }

            .stat-label {
                font-size: 0.875rem;
                color: var(--gray-600);
                margin-bottom: 0.5rem;
            }

            .stat-change {
                font-size: 0.75rem;
                font-weight: 500;
            }

            .stat-change.positive {
                color: var(--success);
            }

            .stat-change.negative {
                color: var(--danger);
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

            /* Tab Styles - PHẦN MỚI THÊM */
            .tab-container {
                margin-bottom: 1.5rem;
            }

            .tab-nav {
                display: flex;
                background-color: white;
                border-radius: var(--border-radius);
                box-shadow: var(--shadow);
                overflow: hidden;
            }

            .tab-button {
                flex: 1;
                padding: 1rem 1.5rem;
                background: transparent;
                border: none;
                color: var(--gray-600);
                font-weight: 500;
                cursor: pointer;
                transition: all 0.3s ease;
                position: relative;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 0.5rem;
            }

            .tab-button:hover {
                background-color: var(--gray-50);
                color: var(--gray-800);
            }

            .tab-button.active {
                background-color: var(--primary);
                color: white;
            }

            .tab-button.active::after {
                content: '';
                position: absolute;
                bottom: 0;
                left: 0;
                right: 0;
                height: 3px;
                background-color: var(--primary-dark);
            }

            .tab-content {
                display: none;
            }

            .tab-content.active {
                display: block;
            }

            .tab-badge {
                background-color: var(--gray-200);
                color: var(--gray-700);
                padding: 0.2rem 0.5rem;
                border-radius: 1rem;
                font-size: 0.75rem;
                font-weight: 600;
                margin-left: 0.5rem;
            }

            .tab-button.active .tab-badge {
                background-color: rgba(255, 255, 255, 0.2);
                color: white;
            }

            .row {
                display: flex;
                flex-wrap: wrap;
                margin: -0.5rem;
            }

            .col-md-6 {
                flex: 0 0 50%;
                max-width: 50%;
                padding: 0.5rem;
            }

            .table-sm th,
            .table-sm td {
                padding: 0.5rem;
                font-size: 0.875rem;
            }

            .mt-3 {
                margin-top: 1rem;
            }

            @media (max-width: 768px) {
                .filter-row {
                    flex-direction: column;
                    gap: 1rem;
                }

                .filter-item {
                    width: 100%;
                }

                .search-group {
                    flex-direction: column;
                    align-items: stretch;
                }

                .container {
                    padding: 0 0.5rem;
                }

                .card-body {
                    padding: 1rem;
                }

                .table-container {
                    font-size: 0.75rem;
                }

                .table th,
                .table td {
                    padding: 0.5rem;
                }

                .stats-grid {
                    grid-template-columns: 1fr;
                }

                .tab-nav {
                    flex-direction: column;
                }

                .tab-button {
                    justify-content: flex-start;
                }

                .col-md-6 {
                    flex: 0 0 100%;
                    max-width: 100%;
                }
            }
        </style>
    </head>
    <body>
        <div class="layout-container">
            <jsp:include page="/include/sidebar.jsp" />
            <div class="main-content">
                <!-- Breadcrumbs -->
                <div class="breadcrumbs mb-4">
                    <a href="${pageContext.request.contextPath}/Admin.jsp">Trang chủ</a>
                    <span class="separator"><i class="fas fa-chevron-right" style="font-size: 0.75rem;"></i></span>
                    <span class="current">Danh sách yêu cầu nhập kho</span>
                </div>

                <!-- Statistics Cards -->
                <div class="stats-grid">
                    <div class="stat-card success">
                        <div class="stat-value">${not empty items ? items.size() : 0}</div>
                        <div class="stat-label">Yêu cầu đơn nhập kho đã duyệt</div>
                        <div class="stat-change positive">
                            <i class="fas fa-arrow-up"></i> Đang chờ xử lý
                        </div>
                    </div>
                    <div class="stat-card info">
                        <div class="stat-value">${not empty historyItems ? historyItems.size() : 0}</div>
                        <div class="stat-label">Đã hoàn thành</div>
                        <div class="stat-change positive">
                            <i class="fas fa-check-circle"></i> Nhập kho thành công
                        </div>
                    </div>
                    <div class="stat-card warning">
                        <div class="stat-value">${(not empty items ? items.size() : 0) + (not empty historyItems ? historyItems.size() : 0)}</div>
                        <div class="stat-label">Tổng yêu cầu</div>
                        <div class="stat-change">
                            <i class="fas fa-chart-line"></i> Tất cả yêu cầu
                        </div>
                    </div>
                </div>

                <div class="card mb-4">
                    <div class="card-header">
                        <h1 class="mb-0">Quản lý yêu cầu nhập kho</h1>
                    </div>

                    <div class="card-body">
                        <!-- Thông báo -->
                        <c:if test="${param.message != null}">
                            <div class="alert alert-success" id="successAlert">
                                <div class="alert-icon">
                                    <i class="fas fa-check"></i>
                                </div>
                                <div class="alert-content">
                                    <div class="alert-title">Thành công</div>
                                    <c:choose>
                                        <c:when test="${param.message eq 'approve_success'}">Phê duyệt nhập kho thành công!</c:when>
                                        <c:when test="${param.message eq 'reject_success'}">Từ chối yêu cầu thành công!</c:when>
                                        <c:otherwise>Thao tác thành công!</c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="alert-close" onclick="this.parentElement.style.display = 'none'">
                                    <i class="fas fa-times"></i>
                                </div>
                            </div>
                        </c:if>

                        <c:if test="${param.error != null}">
                            <div class="alert alert-danger" id="errorAlert">
                                <div class="alert-icon">
                                    <i class="fas fa-exclamation-triangle"></i>
                                </div>
                                <div class="alert-content">
                                    <div class="alert-title">Lỗi</div>
                                    <c:choose>
                                        <c:when test="${param.error eq 'invalid_id'}">ID yêu cầu không hợp lệ!</c:when>
                                        <c:when test="${param.error eq 'request_not_found'}">Không tìm thấy yêu cầu!</c:when>
                                        <c:when test="${param.error eq 'approve_failed'}">Không thể phê duyệt nhập kho!</c:when>
                                        <c:when test="${param.error eq 'invalid_data'}">Dữ liệu không hợp lệ!</c:when>
                                        <c:when test="${param.error eq 'permission_denied'}">Bạn không có quyền thực hiện hành động này!</c:when>
                                        <c:when test="${param.error eq 'invalid_quantity'}">Số lượng nhập không hợp lệ!</c:when>
                                        <c:when test="${param.error eq 'invalid_action'}">Hành động không hợp lệ!</c:when>
                                        <c:when test="${param.error eq 'processing_failed'}">Xử lý yêu cầu thất bại!</c:when>
                                    </c:choose>
                                </div>
                                <div class="alert-close" onclick="this.parentElement.style.display = 'none'">
                                    <i class="fas fa-times"></i>
                                </div>
                            </div>
                        </c:if>

                        <!-- Tab Navigation -->
                        <div class="tab-container">
                            <div class="tab-nav">
                                <button class="tab-button active" onclick="switchTab('approved-requests')" id="tab-approved">
                                    <i class="fas fa-clock"></i>
                                    Yêu cầu đơn nhập kho đã duyệt
                                    <span class="tab-badge">${not empty items ? items.size() : 0}</span>
                                </button>
                                <button class="tab-button" onclick="switchTab('history')" id="tab-history">
                                    <i class="fas fa-history"></i>
                                    Lịch sử nhập kho
                                    <span class="tab-badge">${not empty historyItems ? historyItems.size() : 0}</span>
                                </button>
                            </div>
                        </div>

                        <!-- Tab Content: Yêu cầu đã duyệt -->
                        <div id="approved-requests" class="tab-content active">
                            <!-- Bộ lọc và tìm kiếm cải tiến -->
                            <div class="filter-panel mb-4">
                                <div class="filter-title">
                                    <i class="fas fa-search"></i> Tìm kiếm yêu cầu đã duyệt
                                </div>
                                <form action="${pageContext.request.contextPath}/request/list" method="get" id="searchForm">
                                    <input type="hidden" name="type" value="purchase">
                                    <div class="filter-row">
                                        <div class="filter-item">
                                            <label class="form-label">Tìm kiếm theo:</label>
                                            <select name="searchType" class="form-control" required>
                                                <option value="requestId" ${param.searchType == 'requestId' ? 'selected' : ''}>Mã yêu cầu</option>
                                                <option value="productName" ${param.searchType == 'productName' ? 'selected' : ''}>Tên sản phẩm</option>
                                                <option value="productCode" ${param.searchType == 'productCode' ? 'selected' : ''}>Mã sản phẩm</option>
                                            </select>
                                        </div>
                                        <div class="filter-item">
                                            <label class="form-label">Từ khóa:</label>
                                            <input type="text" name="searchValue" value="${param.searchValue}" 
                                                   class="form-control" placeholder="Nhập từ khóa tìm kiếm..."
                                                   autocomplete="off">
                                        </div>
                                        <div class="filter-item">
                                            <div class="search-group">
                                                <button type="submit" class="btn btn-primary btn-icon">
                                                    <i class="fas fa-search"></i> Tìm kiếm
                                                </button>
                                                <button type="button" class="btn btn-secondary btn-icon" onclick="clearSearch()">
                                                    <i class="fas fa-times"></i> Xóa
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </form>
                            </div>

                            <!-- Hiển thị kết quả tìm kiếm -->
                            <c:if test="${not empty param.searchValue && (param.type == 'purchase' || empty param.type)}">
                                <div class="alert alert-info mb-3">
                                    <div class="alert-icon">
                                        <i class="fas fa-info-circle"></i>
                                    </div>
                                    <div class="alert-content">
                                        <div class="alert-title">Kết quả tìm kiếm</div>
                                        <div>
                                            Tìm kiếm "<strong>${param.searchValue}</strong>" theo 
                                            <strong>
                                                <c:choose>
                                                    <c:when test="${param.searchType == 'requestId'}">Mã yêu cầu</c:when>
                                                    <c:when test="${param.searchType == 'productName'}">Tên sản phẩm</c:when>
                                                    <c:when test="${param.searchType == 'productCode'}">Mã sản phẩm</c:when>
                                                </c:choose>
                                            </strong>
                                        </div>
                                        <div class="mt-2">
                                            Tìm thấy <strong>${not empty items ? items.size() : 0}</strong> yêu cầu đã duyệt.
                                        </div>
                                    </div>
                                </div>
                            </c:if>

                            <!-- Bảng danh sách yêu cầu nhập đã duyệt -->
                            <div class="table-container">
                                <table class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th>STT</th>
                                            <th>Mã yêu cầu</th>
                                            <th>Ngày yêu cầu</th>
                                            <th>Nhà cung cấp</th>
                                            <th>Tên sản phẩm</th>
                                            <th>Mã sản phẩm</th>
                                            <th>Đơn vị</th>
                                            <th>Số lượng</th>
                                            <th>Giá</th>
                                            <th>Ghi chú</th>
                                            <th>Thao tác</th>
                                        </tr>
                                    </thead>
                                    <tbody id="approvedTableBody">
                                        <c:choose>
                                            <c:when test="${empty items}">
                                                <tr>
                                                    <td colspan="11" class="text-center py-4">
                                                        <div style="color: gray;">
                                                            <i class="fas fa-inbox mb-2" style="font-size: 2rem;"></i>
                                                            <p>Không có yêu cầu đơn nhập kho đã duyệt nào để hiển thị.</p>
                                                            <c:if test="${not empty param.searchValue}">
                                                                <p class="text-muted">Thử tìm kiếm với từ khóa khác hoặc thay đổi tiêu chí tìm kiếm.</p>
                                                            </c:if>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:when>
                                            <c:otherwise>
                                                <c:forEach var="item" items="${items}" varStatus="status">
                                                    <tr>
                                                        <td>${status.index + 1}</td>
                                                        <td class="searchable">${item.requestId}</td>
                                                        <td>${item.dayRequest}</td>
                                                        <td class="searchable">${item.supplier != null ? item.supplier : 'N/A'}</td>
                                                        <td class="searchable">${item.productName != null ? item.productName : 'No items'}</td>
                                                        <td class="searchable">${item.productCode != null ? item.productCode : 'N/A'}</td>
                                                        <td>${item.unit != null ? item.unit : 'N/A'}</td>
                                                        <td><fmt:formatNumber value="${item.quantity != null ? item.quantity : 0}" pattern="#,##0.##" /></td>
                                                        <td><fmt:formatNumber value="${item.price != null ? item.price : 0}" pattern="#,##0.## VNĐ" /></td>
                                                        <td>${item.note != null ? item.note : 'N/A'}</td>
                                                        <td>
                                                            <div class="d-flex gap-2">
                                                                <a href="${pageContext.request.contextPath}/import-confirm?id=${item.requestId}" class="btn btn-sm btn-success">
                                                                    <i class="fas fa-check"></i> Xử lý nhập kho
                                                                </a>
                                                                
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </c:otherwise>
                                        </c:choose>
                                    </tbody>
                                </table>
                            </div>

                            <!-- Phân trang cho yêu cầu đã duyệt -->
                            <c:if test="${totalPages > 1}">
                                <nav aria-label="Page navigation" class="d-flex justify-content-center">
                                    <ul class="pagination">
                                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                            <a class="page-link" href="${pageContext.request.contextPath}/request/list?type=purchase&page=${currentPage - 1}&searchType=${param.searchType}&searchValue=${param.searchValue}" aria-label="Previous">
                                                <i class="fas fa-chevron-left"></i>
                                            </a>
                                        </li>

                                        <c:forEach begin="1" end="${totalPages}" var="i">
                                            <li class="page-item ${currentPage == i ? 'active' : ''}">
                                                <a class="page-link" href="${pageContext.request.contextPath}/request/list?type=purchase&page=${i}&searchType=${param.searchType}&searchValue=${param.searchValue}">${i}</a>
                                            </li>
                                        </c:forEach>

                                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                            <a class="page-link" href="${pageContext.request.contextPath}/request/list?type=purchase&page=${currentPage + 1}&searchType=${param.searchType}&searchValue=${param.searchValue}" aria-label="Next">
                                                <i class="fas fa-chevron-right"></i>
                                            </a>
                                        </li>
                                    </ul>
                                </nav>
                            </c:if>
                        </div>

                        <!-- Tab Content: Lịch sử nhập kho -->
                        <div id="history" class="tab-content">
                            <!-- Bộ lọc và tìm kiếm cho lịch sử -->
                            <div class="filter-panel mb-4">
                                <div class="filter-title">
                                    <i class="fas fa-search"></i> Tìm kiếm lịch sử nhập kho
                                </div>
                                <form action="${pageContext.request.contextPath}/request/list" method="get" id="historySearchForm">
                                    <input type="hidden" name="type" value="history">
                                    <div class="filter-row">
                                        <div class="filter-item">
                                            <label class="form-label">Tìm kiếm theo:</label>
                                            <select name="historySearchType" class="form-control">
                                                <option value="requestId" ${param.historySearchType == 'requestId' ? 'selected' : ''}>Mã đơn</option>
                                                <option value="productName" ${param.historySearchType == 'productName' ? 'selected' : ''}>Tên sản phẩm</option>
                                                <option value="productCode" ${param.historySearchType == 'productCode' ? 'selected' : ''}>Mã sản phẩm</option>
                                                <option value="supplier" ${param.historySearchType == 'supplier' ? 'selected' : ''}>Nhà cung cấp</option>
                                            </select>
                                        </div>
                                        <div class="filter-item">
                                            <label class="form-label">Từ khóa:</label>
                                            <input type="text" name="historySearchValue" value="${param.historySearchValue}"
                                                   class="form-control" placeholder="Nhập từ khóa tìm kiếm..."
                                                   autocomplete="off">
                                        </div>
                                        <div class="filter-item">
                                            <div class="search-group">
                                                <button type="submit" class="btn btn-primary btn-icon">
                                                    <i class="fas fa-search"></i> Tìm kiếm
                                                </button>
                                                <button type="button" class="btn btn-secondary btn-icon" onclick="clearHistorySearch()">
                                                    <i class="fas fa-times"></i> Xóa
                                                </button>
                                                <button type="button" class="btn btn-warning btn-icon" onclick="exportHistoryToExcel()">
                                                    <i class="fas fa-file-excel"></i> Xuất Excel
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </form>
                            </div>

                            <!-- Hiển thị kết quả tìm kiếm lịch sử -->
                            <c:if test="${not empty param.historySearchValue && param.type == 'history'}">
                                <div class="alert alert-info mb-3">
                                    <div class="alert-icon">
                                        <i class="fas fa-info-circle"></i>
                                    </div>
                                    <div class="alert-content">
                                        <div class="alert-title">Kết quả tìm kiếm lịch sử</div>
                                        <div>
                                            Tìm kiếm "<strong>${param.historySearchValue}</strong>" theo 
                                            <strong>
                                                <c:choose>
                                                    <c:when test="${param.historySearchType == 'requestId'}">Mã đơn</c:when>
                                                    <c:when test="${param.historySearchType == 'productName'}">Tên sản phẩm</c:when>
                                                    <c:when test="${param.historySearchType == 'productCode'}">Mã sản phẩm</c:when>
                                                    <c:when test="${param.historySearchType == 'supplier'}">Nhà cung cấp</c:when>
                                                </c:choose>
                                            </strong>
                                        </div>
                                        <div class="mt-2">
                                            Tìm thấy <strong>${not empty historyItems ? historyItems.size() : 0}</strong> kết quả.
                                        </div>
                                    </div>
                                </div>
                            </c:if>

                            <!-- Bảng lịch sử nhập kho -->
                            <div class="table-container">
                                <table class="table table-hover" id="historyTable">
                                    <thead>
                                        <tr>
                                            <th>STT</th>
                                            <th>Mã đơn</th>
                                            <th>Ngày nhập</th>
                                            <th>Tên sản phẩm</th>
                                            <th>Mã sản phẩm</th>
                                            <th>Nhà cung cấp</th>
                                            <th>Số lượng</th>
                                            <th>Đơn giá</th>
                                            <th>Thành tiền</th>
                                            <th>Trạng thái</th>
                                            <th>Thao tác</th>
                                        </tr>
                                    </thead>
                                    <tbody id="historyTableBody">
                                        <c:choose>
                                            <c:when test="${empty historyItems}">
                                                <tr>
                                                    <td colspan="11" class="text-center py-4">
                                                        <div style="color: gray;">
                                                            <i class="fas fa-inbox mb-2" style="font-size: 2rem;"></i>
                                                            <p>Không có lịch sử nhập kho nào để hiển thị.</p>
                                                            <c:if test="${not empty param.historySearchValue}">
                                                                <p class="text-muted">Thử tìm kiếm với từ khóa khác hoặc thay đổi tiêu chí tìm kiếm.</p>
                                                            </c:if>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:when>
                                            <c:otherwise>
                                                <c:forEach var="item" items="${historyItems}" varStatus="status">                                                                   
                                                    <tr>
                                                        <td>${status.index + 1}</td>
                                                        <td class="searchable">${item.requestId}</td>
                                                        <td>${item.dayRequest}</td>
                                                        <td class="searchable">${item.productName != null ? item.productName : 'No items'}</td>
                                                        <td class="searchable">${item.productCode != null ? item.productCode : 'N/A'}</td>
                                                        <td class="searchable">${item.supplier}</td>
                                                        <td><fmt:formatNumber value="${item.quantity != null ? item.quantity : 0}" pattern="#,##0.##" /></td>
                                                        <td><fmt:formatNumber value="${item.price != null ? item.price : 0}" pattern="#,##0.## VNĐ" /></td>
                                                        <td><fmt:formatNumber value="${(item.quantity != null ? item.quantity : 0) * (item.price != null ? item.price : 0)}" pattern="#,##0.## VNĐ" /></td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${item.status == 'completed' || item.status == 'COMPLETED'}">
                                                                    <span class="status-badge status-completed">
                                                                        <i class="fas fa-check-circle"></i> Hoàn thành
                                                                    </span>
                                                                </c:when>
                                                                <c:when test="${item.status == 'rejected' || item.status == 'REJECTED'}">
                                                                    <span class="status-badge status-rejected">
                                                                        <i class="fas fa-times-circle"></i> Từ chối
                                                                    </span>
                                                                </c:when>
                                                                <c:when test="${item.status == 'pending' || item.status == 'PENDING'}">
                                                                    <span class="status-badge status-pending">
                                                                        <i class="fas fa-clock"></i> Chờ xử lý
                                                                    </span>
                                                                </c:when>
                                                                <c:when test="${item.status == 'processing' || item.status == 'PROCESSING'}">
                                                                    <span class="status-badge status-processing">
                                                                        <i class="fas fa-spinner"></i> Đang xử lý
                                                                    </span>
                                                                </c:when>
                                                                <c:when test="${item.status == 'cancelled' || item.status == 'CANCELLED'}">
                                                                    <span class="status-badge status-cancelled">
                                                                        <i class="fas fa-ban"></i> Đã hủy
                                                                    </span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="status-badge status-completed">
                                                                        <i class="fas fa-question-circle"></i> ${item.status}
                                                                    </span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <div class="d-flex gap-2">
                                                                
                                                                <a href="LishSupplier" class="btn btn-sm btn-warning btn-icon">
                                                                    <i class="fas fa-star"></i> Đánh giá
                                                                </a>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </c:otherwise>
                                        </c:choose>
                                    </tbody>
                                </table>
                            </div>

                            <!-- Phân trang cho lịch sử -->
                            <c:if test="${historyTotalPages > 1}">
                                <nav aria-label="History pagination" class="d-flex justify-content-center">
                                    <ul class="pagination">
                                        <li class="page-item ${historyCurrentPage == 1 ? 'disabled' : ''}">
                                            <a class="page-link" href="${pageContext.request.contextPath}/request/list?type=history&page=${historyCurrentPage - 1}&historySearchType=${param.historySearchType}&historySearchValue=${param.historySearchValue}" aria-label="Previous">
                                                <i class="fas fa-chevron-left"></i>
                                            </a>
                                        </li>

                                        <c:forEach begin="1" end="${historyTotalPages}" var="i">
                                            <li class="page-item ${historyCurrentPage == i ? 'active' : ''}">
                                                <a class="page-link" href="${pageContext.request.contextPath}/request/list?type=history&page=${i}&historySearchType=${param.historySearchType}&historySearchValue=${param.historySearchValue}">${i}</a>
                                            </li>
                                        </c:forEach>

                                        <li class="page-item ${historyCurrentPage == historyTotalPages ? 'disabled' : ''}">
                                            <a class="page-link" href="${pageContext.request.contextPath}/request/list?type=history&page=${historyCurrentPage + 1}&historySearchType=${param.historySearchType}&historySearchValue=${param.historySearchValue}" aria-label="Next">
                                                <i class="fas fa-chevron-right"></i>
                                            </a>
                                        </li>
                                    </ul>
                                </nav>
                            </c:if>
                        </div>
                    </div>
                    <div class="card-footer">
                        <div class="d-flex justify-content-between align-items-center">
                            <div class="d-flex gap-2">
                                <button type="button" class="btn btn-warning btn-icon" onclick="showNotifications()">
                                    <i class="fas fa-bell"></i> Thông báo
                                </button>
                                <button type="button" class="btn btn-info btn-icon" onclick="showHelp()">
                                    <i class="fas fa-question-circle"></i> Trợ giúp
                                </button>
                            </div>
                            <a href="${pageContext.request.contextPath}/Admin.jsp" class="btn btn-primary btn-icon">
                                <i class="fas fa-arrow-left"></i> Quay lại Trang chủ
                            </a>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Modal xác nhận phê duyệt nhập kho -->
            <div id="approveModal" class="modal">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">Xác nhận phê duyệt nhập kho</h5>
                            <button type="button" class="modal-close" onclick="closeApproveModal()">
                                <i class="fas fa-times"></i>
                            </button>
                        </div>
                        <form id="approveForm" action="${pageContext.request.contextPath}/request/list" method="post">
                            <div class="modal-body">
                                <div class="d-flex align-items-center gap-3 mb-3">
                                    <div style="width: 3rem; height: 3rem; background-color: #d1fae5; border-radius: 50%; display: flex; align-items: center; justify-content: center;">
                                        <i class="fas fa-check-circle" style="font-size: 1.5rem; color: #10b981;"></i>
                                    </div>
                                    <div>
                                        <h2 class="mb-1">Xác nhận nhập kho</h2>
                                        <p class="mb-0 text-muted">Hàng hóa sẽ được cập nhật vào kho sau khi phê duyệt.</p>
                                    </div>
                                </div>

                                <input type="hidden" id="requestIdInput" name="id" value="">
                                <p>Bạn đang phê duyệt nhập kho yêu cầu có ID: <strong id="approveRequestId"></strong></p>

                                <div class="form-group">
                                    <label for="approveNote" class="form-label">Ghi chú:</label>
                                    <textarea id="approveNote" name="note" class="form-control" rows="3" placeholder="Nhập ghi chú phê duyệt (nếu có)"></textarea>
                                </div>

                                <div class="form-group">
                                    <label for="approveDate" class="form-label">Ngày nhập kho:</label>
                                    <input type="date" id="approveDate" name="approveDate" class="form-control" value="${currentDate}" required>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" onclick="closeApproveModal()">
                                    Hủy bỏ
                                </button>
                                <button type="submit" class="btn btn-success btn-icon">
                                    <i class="fas fa-check-circle"></i> Xác nhận nhập kho
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <!-- Modal chi tiết yêu cầu -->
            <div id="detailModal" class="modal">
                <div class="modal-dialog" style="max-width: 800px;">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">Chi tiết yêu cầu nhập kho</h5>
                            <button type="button" class="modal-close" onclick="closeDetailModal()">
                                <i class="fas fa-times"></i>
                            </button>
                        </div>
                        <div class="modal-body" id="detailModalBody">
                            <!-- Nội dung chi tiết sẽ được load bằng JavaScript -->
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" onclick="closeDetailModal()">
                                Đóng
                            </button>
                        </div>
                    </div>
                </div>
            </div>
            <script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.17.0/xlsx.full.min.js"></script>
            <script>
                                // Biến global để lưu giá trị tìm kiếm
                                var searchValue = '${param.searchValue}' || '';
                                var searchType = '${param.searchType}' || '';
                                var historySearchValue = '${param.historySearchValue}' || '';
                                var historySearchType = '${param.historySearchType}' || '';

                                // FUNCTION CHUYỂN ĐỔI TAB - ĐÃ SỬA
                                function switchTab(tabName) {
                                    // Ẩn tất cả tab content
                                    var tabContents = document.querySelectorAll('.tab-content');
                                    tabContents.forEach(function (content) {
                                        content.classList.remove('active');
                                    });

                                    // Bỏ active cho tất cả tab button
                                    var tabButtons = document.querySelectorAll('.tab-button');
                                    tabButtons.forEach(function (button) {
                                        button.classList.remove('active');
                                    });

                                    // Hiển thị tab được chọn
                                    document.getElementById(tabName).classList.add('active');

                                    // Active tab button tương ứng
                                    if (tabName === 'approved-requests') {
                                        document.getElementById('tab-approved').classList.add('active');
                                        // Cập nhật URL để giữ trạng thái
                                        history.replaceState(null, null, '${pageContext.request.contextPath}/request/list?type=purchase');
                                    } else if (tabName === 'history') {
                                        document.getElementById('tab-history').classList.add('active');
                                        // Cập nhật URL để giữ trạng thái
                                        history.replaceState(null, null, '${pageContext.request.contextPath}/request/list?type=history');
                                    }

                                    // Lưu trạng thái tab hiện tại
                                    localStorage.setItem('activeTab', tabName);
                                }

                                // Khôi phục tab dựa trên URL parameter - ĐÃ SỬA
                                document.addEventListener('DOMContentLoaded', function () {
                                    var urlParams = new URLSearchParams(window.location.search);
                                    var type = urlParams.get('type');

                                    if (type === 'history') {
                                        switchTab('history');
                                    } else {
                                        switchTab('approved-requests');
                                    }

                                    // Highlight search results
                                    highlightSearchResults();
                                });

                                // Xử lý đóng alert sau 5 giây
                                window.addEventListener('DOMContentLoaded', function () {
                                    setTimeout(function () {
                                        var successAlert = document.getElementById('successAlert');
                                        var errorAlert = document.getElementById('errorAlert');
                                        if (successAlert) {
                                            successAlert.style.display = 'none';
                                        }
                                        if (errorAlert) {
                                            errorAlert.style.display = 'none';
                                        }
                                    }, 5000);
                                });

                                // Xuất lịch sử ra Excel
                                function exportHistoryToExcel() {
                                    try {
                                        var table = document.getElementById('historyTable');
                                        if (!table) {
                                            showNotification('Không tìm thấy bảng dữ liệu!', 'error');
                                            return;
                                        }

                                        // Tạo workbook mới
                                        var wb = XLSX.utils.book_new();
                                        // Lấy dữ liệu từ bảng
                                        var ws_data = [];
                                        var rows = table.querySelectorAll('tr');
                                        // Thêm tiêu đề
                                        ws_data.push(['LỊCH SỬ NHẬP KHO']);
                                        ws_data.push(['Ngày xuất: ' + new Date().toLocaleDateString('vi-VN')]);
                                        ws_data.push([]); // Dòng trống

                                        rows.forEach(function (row, index) {
                                            var rowData = [];
                                            var cells = row.querySelectorAll('th, td');
                                            // Bỏ qua cột thao tác (cột cuối)
                                            for (var i = 0; i < cells.length - 1; i++) {
                                                var cellText = cells[i].textContent.trim();
                                                // Xử lý các ký tự đặc biệt
                                                cellText = cellText.replace(/\s+/g, ' ');
                                                rowData.push(cellText);
                                            }

                                            if (rowData.length > 0 && rowData.some(cell => cell !== '')) {
                                                ws_data.push(rowData);
                                            }
                                        });
                                        // Tạo worksheet
                                        var ws = XLSX.utils.aoa_to_sheet(ws_data);
                                        // Thiết lập độ rộng cột
                                        var colWidths = [
                                            {wch: 5}, // STT
                                            {wch: 15}, // Mã đơn
                                            {wch: 12}, // Ngày nhập
                                            {wch: 25}, // Tên sản phẩm
                                            {wch: 15}, // Mã sản phẩm
                                            {wch: 20}, // Nhà cung cấp
                                            {wch: 10}, // Số lượng
                                            {wch: 15}, // Đơn giá
                                            {wch: 15}, // Thành tiền
                                            {wch: 12}  // Trạng thái
                                        ];
                                        ws['!cols'] = colWidths;
                                        // Thêm worksheet vào workbook
                                        XLSX.utils.book_append_sheet(wb, ws, "Lịch sử nhập kho");
                                        // Tạo tên file với timestamp
                                        var fileName = 'Lich_su_nhap_kho_' + new Date().toISOString().slice(0, 10) + '.xlsx';
                                        // Xuất file
                                        XLSX.writeFile(wb, fileName);

                                        showNotification('Xuất file Excel thành công!', 'success');

                                    } catch (error) {
                                        console.error('Lỗi khi xuất Excel:', error);
                                        showNotification('Có lỗi xảy ra khi xuất file Excel!', 'error');
                                    }
                                }

                                // Hàm hiển thị thông báo
                                function showNotification(message, type) {
                                    var alertClass = type === 'success' ? 'alert-success' : 'alert-danger';
                                    var icon = type === 'success' ? 'fa-check' : 'fa-exclamation-triangle';

                                    var notification = document.createElement('div');
                                    notification.className = 'alert ' + alertClass;
                                    notification.style.position = 'fixed';
                                    notification.style.top = '20px';
                                    notification.style.right = '20px';
                                    notification.style.zIndex = '9999';
                                    notification.style.minWidth = '300px';
                                    notification.innerHTML = `
                        <div class="alert-icon">
                            <i class="fas ${icon}"></i>
                        </div>
                        <div class="alert-content">
                            <div class="alert-title">$(type === 'success' ? 'Thành công' : 'Lỗi')</div>
                            <div>${message}</div>
                        </div>
                        <div class="alert-close" onclick="this.parentElement.remove()">
                            <i class="fas fa-times"></i>
                        </div>
                    `;

                                    document.body.appendChild(notification);

                                    // Tự động ẩn sau 3 giây
                                    setTimeout(function () {
                                        if (notification.parentNode) {
                                            notification.parentNode.removeChild(notification);
                                        }
                                    }, 3000);
                                }

                                // Hàm highlight kết quả tìm kiếm - ĐÃ SỬA
                                function highlightSearchResults() {
                                    var currentTab = document.querySelector('.tab-content.active').id;
                                    var currentSearchValue = '';

                                    if (currentTab === 'approved-requests') {
                                        currentSearchValue = searchValue;
                                    } else if (currentTab === 'history') {
                                        currentSearchValue = historySearchValue;
                                    }

                                    if (currentSearchValue && currentSearchValue.trim() !== '') {
                                        var searchables = document.querySelectorAll('#' + currentTab + ' .searchable');
                                        searchables.forEach(function (element) {
                                            var text = element.textContent;
                                            var highlightedText = text.replace(
                                                    new RegExp('(' + escapeRegExp(currentSearchValue) + ')', 'gi'),
                                                    '<mark>$1</mark>'
                                                    );
                                            element.innerHTML = highlightedText;
                                        });
                                    }
                                }

                                // Hàm escape RegExp
                                function escapeRegExp(string) {
                                    return string.replace(/[.*+?^$()()|[\]\\]/g, '\\$&');
                                }

                                // Hàm xóa tìm kiếm - ĐÃ SỬA
                                function clearSearch() {
                                    document.querySelector('select[name="searchType"]').value = 'requestId';
                                    document.querySelector('input[name="searchValue"]').value = '';
                                    window.location.href = '${pageContext.request.contextPath}/request/list?type=purchase';
                                }

                                // Hàm xóa tìm kiếm lịch sử - ĐÃ SỬA
                                function clearHistorySearch() {
                                    document.querySelector('select[name="historySearchType"]').value = 'requestId';
                                    document.querySelector('input[name="historySearchValue"]').value = '';
                                    window.location.href = '${pageContext.request.contextPath}/request/list?type=history';
                                }

                                // Hàm xem chi tiết yêu cầu đã duyệt
                                function viewDetails(requestId) {
                                    loadRequestDetails(requestId);
                                    document.getElementById('detailModal').style.display = 'block';
                                }

                                // Hàm xem chi tiết lịch sử
                                function viewHistoryDetails(requestId) {
                                    loadHistoryDetails(requestId);
                                    document.getElementById('detailModal').style.display = 'block';
                                }

                                // Hàm load chi tiết yêu cầu đã duyệt
                                function loadRequestDetails(requestId) {
                                    // Tìm thông tin từ bảng hiện tại
                                    var approvedRows = document.querySelectorAll('#approvedTableBody tr');
                                    var requestData = null;

                                    approvedRows.forEach(function (row) {
                                        var cells = row.querySelectorAll('td');
                                        if (cells.length > 1 && cells[1].textContent.trim() === requestId) {
                                            requestData = {
                                                requestId: cells[1].textContent.trim(),
                                                dayRequest: cells[2].textContent.trim(),
                                                supplier: cells[3].textContent.trim(),
                                                productName: cells[4].textContent.trim(),
                                                productCode: cells[5].textContent.trim(),
                                                unit: cells[6].textContent.trim(),
                                                quantity: cells[7].textContent.trim(),
                                                price: cells[8].textContent.trim(),
                                                note: cells[9].textContent.trim()
                                            };
                                        }
                                    });

                                    if (requestData) {
                                        document.getElementById('detailModalBody').innerHTML = `
                            <div class="row">
                                <div class="col-md-6">
                                    <h6><i class="fas fa-info-circle"></i> Thông tin yêu cầu</h6>
                                    <table class="table table-sm">
                                        <tr><td><strong>Mã yêu cầu:</strong></td><td>${requestData.requestId}</td></tr>
                                        <tr><td><strong>Ngày tạo:</strong></td><td>${requestData.dayRequest}</td></tr>
                                        <tr><td><strong>Nhà cung cấp:</strong></td><td>${requestData.supplier}</td></tr>
                                        <tr><td><strong>Ghi chú:</strong></td><td>${requestData.note}</td></tr>
                                    </table>
                                </div>
                                <div class="col-md-6">
                                    <h6><i class="fas fa-box"></i> Thông tin sản phẩm</h6>
                                    <table class="table table-sm">
                                        <tr><td><strong>Tên sản phẩm:</strong></td><td>${requestData.productName}</td></tr>
                                        <tr><td><strong>Mã sản phẩm:</strong></td><td>${requestData.productCode}</td></tr>
                                        <tr><td><strong>Đơn vị:</strong></td><td>${requestData.unit}</td></tr>
                                        <tr><td><strong>Số lượng:</strong></td><td>${requestData.quantity}</td></tr>
                                        <tr><td><strong>Đơn giá:</strong></td><td>${requestData.price}</td></tr>
                                    </table>
                                </div>
                            </div>
                            <div class="mt-3">
                                <div class="alert alert-info">
                                    <i class="fas fa-info-circle"></i>
                                    <strong>Trạng thái:</strong> Đã duyệt - Chờ xử lý nhập kho
                                </div>
                            </div>
                            <div class="mt-3">
                                <div class="d-flex gap-2">
                                    <a href="${pageContext.request.contextPath}/import-confirm?id=${requestData.requestId}" 
                                       class="btn btn-success btn-sm">
                                        <i class="fas fa-check"></i> Xử lý nhập kho
                                    </a>
                                </div>
                            </div>
                        `;
                                    } else {
                                        document.getElementById('detailModalBody').innerHTML = `
                            <div class="alert alert-danger">
                                <i class="fas fa-exclamation-triangle"></i>
                                Không tìm thấy thông tin chi tiết cho yêu cầu này.
                            </div>
                        `;
                                    }
                                }

                                // Hàm load chi tiết lịch sử
                                function loadHistoryDetails(requestId) {
                                    // Tìm thông tin từ bảng lịch sử
                                    var historyRows = document.querySelectorAll('#historyTableBody tr');
                                    var historyData = null;

                                    historyRows.forEach(function (row) {
                                        var cells = row.querySelectorAll('td');
                                        if (cells.length > 1 && cells[1].textContent.trim() === requestId) {
                                            // Lấy text từ status badge
                                            var statusCell = cells[9];
                                            var statusText = statusCell.textContent.trim();

                                            historyData = {
                                                requestId: cells[1].textContent.trim(),
                                                dayRequest: cells[2].textContent.trim(),
                                                productName: cells[3].textContent.trim(),
                                                productCode: cells[4].textContent.trim(),
                                                supplier: cells[5].textContent.trim(),
                                                quantity: cells[6].textContent.trim(),
                                                price: cells[7].textContent.trim(),
                                                totalAmount: cells[8].textContent.trim(),
                                                status: statusText,
                                                statusRaw: statusCell.querySelector('.status-badge') ?
                                                        statusCell.querySelector('.status-badge').className : ''
                                            };
                                        }
                                    });

                                    if (historyData) {
                                        var statusClass = '';
                                        var statusIcon = '';
                                        var statusMessage = '';

                                        // Xác định loại trạng thái và hiển thị tương ứng
                                        if (historyData.statusRaw.includes('status-completed')) {
                                            statusClass = 'alert-success';
                                            statusIcon = 'fa-check-circle';
                                            statusMessage = 'Đã hoàn thành nhập kho - Sản phẩm đã được cập nhật vào kho';
                                        } else if (historyData.statusRaw.includes('status-rejected')) {
                                            statusClass = 'alert-danger';
                                            statusIcon = 'fa-times-circle';
                                            statusMessage = 'Yêu cầu đã bị từ chối - Không thực hiện nhập kho';
                                        } else if (historyData.statusRaw.includes('status-cancelled')) {
                                            statusClass = 'alert-warning';
                                            statusIcon = 'fa-ban';
                                            statusMessage = 'Yêu cầu đã bị hủy';
                                        } else {
                                            statusClass = 'alert-info';
                                            statusIcon = 'fa-info-circle';
                                            statusMessage = 'Trạng thái: ' + historyData.status;
                                        }

                                        document.getElementById('detailModalBody').innerHTML = `
                            <div class="row">
                                <div class="col-md-6">
                                    <h6><i class="fas fa-history"></i> Thông tin nhập kho</h6>
                                    <table class="table table-sm">
                                        <tr><td><strong>Mã đơn:</strong></td><td>${historyData.requestId}</td></tr>
                                        <tr><td><strong>Ngày nhập:</strong></td><td>${historyData.dayRequest}</td></tr>
                                        <tr><td><strong>Nhà cung cấp:</strong></td><td>${historyData.supplier}</td></tr>
                                        <tr><td><strong>Trạng thái:</strong></td><td>${historyData.status}</td></tr>
                                    </table>
                                </div>
                                <div class="col-md-6">
                                    <h6><i class="fas fa-box"></i> Thông tin sản phẩm</h6>
                                    <table class="table table-sm">
                                        <tr><td><strong>Tên sản phẩm:</strong></td><td>${historyData.productName}</td></tr>
                                        <tr><td><strong>Mã sản phẩm:</strong></td><td>${historyData.productCode}</td></tr>
                                        <tr><td><strong>Số lượng:</strong></td><td>${historyData.quantity}</td></tr>
                                        <tr><td><strong>Đơn giá:</strong></td><td>${historyData.price}</td></tr>
                                        <tr><td><strong>Thành tiền:</strong></td><td>${historyData.totalAmount}</td></tr>
                                    </table>
                                </div>
                            </div>
                            <div class="mt-3">
                                <div class="alert ${statusClass}">
                                    <i class="fas ${statusIcon}"></i>
                                    <strong>${statusMessage}</strong>
                                </div>
                            </div>
                        `;
                                    } else {
                                        document.getElementById('detailModalBody').innerHTML = `
                            <div class="alert alert-danger">
                                <i class="fas fa-exclamation-triangle"></i>
                                Không tìm thấy thông tin chi tiết cho đơn hàng này.
                            </div>
                        `;
                                    }
                                }

                                // Hàm đóng modal chi tiết
                                function closeDetailModal() {
                                    document.getElementById('detailModal').style.display = 'none';
                                }

                                // Hàm đóng modal phê duyệt
                                function closeApproveModal() {
                                    document.getElementById('approveModal').style.display = 'none';
                                }

                                // Hàm hiển thị thông báo
                                function showNotifications() {
                                    alert('Chức năng thông báo đang được phát triển!');
                                }

                                // Hàm hiển thị trợ giúp
                                function showHelp() {
                                    var helpContent = `
                        HƯỚNG DẪN SỬ DỤNG:
                        
                        1. TAB YÊU CẦU ĐÃ DUYỆT:
                        - Xem danh sách các yêu cầu nhập kho đã được phê duyệt
                        - Sử dụng chức năng tìm kiếm để lọc theo mã yêu cầu, tên sản phẩm, mã sản phẩm
                        - Nhấn "Xử lý nhập kho" để thực hiện nhập kho
                        - Nhấn "Chi tiết" để xem thông tin đầy đủ
                        
                        2. TAB LỊCH SỬ NHẬP KHO:
                        - Xem lịch sử tất cả các đơn nhập kho đã hoàn thành hoặc bị từ chối
                        - Tìm kiếm theo nhiều tiêu chí khác nhau (mã đơn, tên sản phẩm, mã sản phẩm, nhà cung cấp)
                        - Xuất dữ liệu ra file Excel
                        - Đánh giá nhà cung cấp
                        
                        3. CHỨC NĂNG KHÁC:
                        - Thống kê hiển thị tổng quan về tình trạng nhập kho
                        - Phân trang để dễ dàng điều hướng
                        - Giao diện responsive, tương thích với mobile
                    `;
                                    alert(helpContent);
                                }

                                // Xử lý click ngoài modal để đóng
                                window.onclick = function (event) {
                                    var detailModal = document.getElementById('detailModal');
                                    var approveModal = document.getElementById('approveModal');

                                    if (event.target == detailModal) {
                                        detailModal.style.display = 'none';
                                    }
                                    if (event.target == approveModal) {
                                        approveModal.style.display = 'none';
                                    }
                                }

                                // Xử lý phím ESC để đóng modal
                                document.addEventListener('keydown', function (event) {
                                    if (event.key === 'Escape') {
                                        closeDetailModal();
                                        closeApproveModal();
                                    }
                                });

                                // Xử lý form tìm kiếm với Enter
                                document.addEventListener('DOMContentLoaded', function () {
                                    var searchInputs = document.querySelectorAll('input[name="searchValue"], input[name="historySearchValue"]');
                                    searchInputs.forEach(function (input) {
                                        input.addEventListener('keypress', function (e) {
                                            if (e.key === 'Enter') {
                                                e.preventDefault();
                                                this.closest('form').submit();
                                            }
                                        });
                                    });
                                });

                                // Hàm format số tiền
                                function formatCurrency(amount) {
                                    return new Intl.NumberFormat('vi-VN', {
                                        style: 'currency',
                                        currency: 'VND'
                                    }).format(amount);
                                }

                                // Hàm format ngày tháng
                                function formatDate(dateString) {
                                    var date = new Date(dateString);
                                    return date.toLocaleDateString('vi-VN', {
                                        year: 'numeric',
                                        month: '2-digit',
                                        day: '2-digit'
                                    });
                                }

                                // Auto refresh page mỗi 5 phút để cập nhật dữ liệu mới
                                setInterval(function () {
                                    if (document.visibilityState === 'visible') {
                                        // Chỉ refresh khi trang đang được xem
                                        console.log('Auto refreshing data...');
                                        // Có thể thêm AJAX call để refresh data thay vì reload trang
                                    }
                                }, 300000); // 5 phút

                                // Khởi tạo tooltips nếu có
                                document.addEventListener('DOMContentLoaded', function () {
                                    // Thêm tooltip cho các button
                                    var buttons = document.querySelectorAll('.btn');
                                    buttons.forEach(function (button) {
                                        if (button.title) {
                                            button.addEventListener('mouseenter', function () {
                                                // Có thể thêm custom tooltip
                                            });
                                        }
                                    });
                                });

                                console.log('ListRequestImport.jsp loaded successfully');
            </script>
        </div>
    </body>
</html>