<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Xử lý Nhập Kho | Hệ thống Quản lý Kho</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            :root {
                --primary: #2563eb;
                --primary-dark: #1d4ed8;
                --success: #10b981;
                --success-dark: #059669;
                --danger: #ef4444;
                --danger-dark: #dc2626;
                --warning: #f59e0b;
                --secondary: #64748b;
                --light: #f8fafc;
                --dark: #1e293b;
                --gray-50: #f9fafb;
                --gray-100: #f3f4f6;
                --gray-200: #e5e7eb;
                --gray-300: #d1d5db;
                --gray-400: #9ca3af;
                --gray-500: #6b7280;
                --gray-600: #4b5563;
                --gray-700: #374151;
                --gray-800: #1f2937;
                --gray-900: #111827;
                --border-radius: 0.5rem;
                --shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1), 0 1px 2px 0 rgba(0, 0, 0, 0.06);
                --shadow-md: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
                --shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
            }

            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                background: #f5f5f5;
                font-family: 'Inter', sans-serif;
                min-height: 100vh;
                color: var(--gray-800);
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

            .container {
                max-width: 1400px;
                margin: 0 auto;
                background: white;
                border-radius: var(--border-radius);
                box-shadow: var(--shadow-lg);
                overflow: hidden;
                border: 1px solid var(--gray-200);
            }

            .header {
                background: linear-gradient(135deg, var(--primary) 0%, var(--primary-dark) 100%);
                color: white;
                padding: 2rem;
                text-align: center;
                position: relative;
            }

            .header h1 {
                font-size: 2rem;
                font-weight: 700;
                margin-bottom: 0.5rem;
                position: relative;
                z-index: 1;
            }

            .header p {
                font-size: 1rem;
                opacity: 0.9;
                position: relative;
                z-index: 1;
            }

            .content {
                padding: 2rem;
                background: white;
            }

            .section {
                background: white;
                border-radius: var(--border-radius);
                box-shadow: var(--shadow);
                margin-bottom: 2rem;
                overflow: hidden;
                border: 1px solid var(--gray-200);
            }

            .section-header {
                background: var(--gray-50);
                padding: 1.25rem 1.5rem;
                border-bottom: 1px solid var(--gray-200);
                display: flex;
                align-items: center;
                gap: 0.75rem;
            }

            .section-header h3 {
                font-size: 1.125rem;
                font-weight: 600;
                color: var(--gray-800);
                margin: 0;
            }

            .section-header .icon {
                width: 2rem;
                height: 2rem;
                background: var(--primary);
                color: white;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 0.875rem;
            }

            .section-body {
                padding: 1.5rem;
                background: white;
            }

            .info-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
                gap: 1.5rem;
            }

            .info-item {
                display: flex;
                flex-direction: column;
                gap: 0.5rem;
            }

            .info-label {
                font-size: 0.875rem;
                font-weight: 500;
                color: var(--gray-600);
                text-transform: uppercase;
                letter-spacing: 0.025em;
            }

            .info-value {
                padding: 0.75rem;
                background: var(--gray-50);
                border: 1px solid var(--gray-200);
                border-radius: var(--border-radius);
                font-size: 0.875rem;
                color: var(--gray-800);
            }

            .table-container {
                overflow-x: auto;
                border-radius: var(--border-radius);
                border: 1px solid var(--gray-200);
                background: white;
            }

            table {
                width: 100%;
                border-collapse: collapse;
                background: white;
            }

            th, td {
                padding: 1rem;
                text-align: left;
                border-bottom: 1px solid var(--gray-200);
                font-size: 0.875rem;
            }

            th {
                background: var(--gray-50);
                font-weight: 600;
                color: var(--gray-700);
                text-transform: uppercase;
                letter-spacing: 0.025em;
                font-size: 0.75rem;
                white-space: nowrap;
            }

            td {
                color: var(--gray-800);
                background: white;
            }

            tr:last-child td {
                border-bottom: none;
            }

            tr:hover {
                background: var(--gray-50);
            }

            .form-input {
                width: 100%;
                padding: 0.75rem;
                border: 1px solid var(--gray-300);
                border-radius: var(--border-radius);
                font-size: 0.875rem;
                transition: all 0.2s ease;
                background: white;
            }

            .form-input:focus {
                outline: none;
                border-color: var(--primary);
                box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
            }

            .form-input:read-only {
                background: var(--gray-50);
                color: var(--gray-600);
            }

            .form-input.editable {
                border-color: var(--success);
                background: #f0fdf4;
            }

            .form-input.editable:focus {
                border-color: var(--success);
                box-shadow: 0 0 0 3px rgba(16, 185, 129, 0.1);
            }

            .quantity-input {
                text-align: center;
                font-weight: 600;
            }

            .btn {
                display: inline-flex;
                align-items: center;
                gap: 0.5rem;
                padding: 0.875rem 1.5rem;
                font-size: 0.875rem;
                font-weight: 500;
                border: none;
                border-radius: var(--border-radius);
                cursor: pointer;
                transition: all 0.2s ease;
                text-decoration: none;
                justify-content: center;
                min-width: 140px;
            }

            .btn:hover {
                transform: translateY(-1px);
                box-shadow: var(--shadow-md);
            }

            .btn:active {
                transform: translateY(0);
            }

            .btn-primary {
                background: linear-gradient(135deg, var(--primary) 0%, var(--primary-dark) 100%);
                color: white;
            }

            .btn-primary:hover {
                background: linear-gradient(135deg, var(--primary-dark) 0%, #1e40af 100%);
            }

            .btn-danger {
                background: linear-gradient(135deg, var(--danger) 0%, var(--danger-dark) 100%);
                color: white;
            }

            .btn-danger:hover {
                background: linear-gradient(135deg, var(--danger-dark) 0%, #b91c1c 100%);
            }

            .btn-secondary {
                background: var(--gray-500);
                color: white;
            }

            .btn-secondary:hover {
                background: var(--gray-600);
            }

            .form-footer {
                background: var(--gray-50);
                padding: 2rem;
                border-top: 1px solid var(--gray-200);
                display: flex;
                gap: 1rem;
                justify-content: center;
                flex-wrap: wrap;
            }

            .status-badge {
                display: inline-flex;
                align-items: center;
                gap: 0.25rem;
                padding: 0.375rem 0.75rem;
                font-size: 0.75rem;
                font-weight: 500;
                border-radius: 9999px;
                text-transform: uppercase;
                letter-spacing: 0.025em;
            }

            .status-approved {
                background: #d1fae5;
                color: #065f46;
            }

            .status-rejected {
                background: #fee2e2;
                color: #991b1b;
            }

            .alert {
                padding: 1rem 1.25rem;
                border-radius: var(--border-radius);
                margin-bottom: 1.5rem;
                display: flex;
                align-items: center;
                gap: 0.75rem;
                border-left: 4px solid;
            }

            .alert-warning {
                background: #fffbeb;
                border-left-color: var(--warning);
                color: #92400e;
            }

            .alert-info {
                background: #eff6ff;
                border-left-color: var(--primary);
                color: #1e40af;
            }

            .alert-danger {
                background: #fef2f2;
                border-left-color: var(--danger);
                color: #991b1b;
            }

            .breadcrumb {
                display: flex;
                align-items: center;
                gap: 0.5rem;
                margin-bottom: 1.5rem;
                font-size: 0.875rem;
                color: var(--gray-600);
            }

            .breadcrumb a {
                color: var(--primary);
                text-decoration: none;
            }

            .breadcrumb a:hover {
                text-decoration: underline;
            }

            .modal {
                display: none;
                position: fixed;
                z-index: 1000;
                left: 0;
                top: 0;
                width: 100%;
                height: 100%;
                background: rgba(0, 0, 0, 0.5);
                backdrop-filter: blur(4px);
            }

            .modal-content {
                background: white;
                margin: 5% auto;
                padding: 0;
                border-radius: var(--border-radius);
                width: 90%;
                max-width: 500px;
                box-shadow: var(--shadow-lg);
                animation: modalSlideIn 0.3s ease;
            }

            @keyframes modalSlideIn {
                from {
                    transform: translateY(-50px);
                    opacity: 0;
                }
                to {
                    transform: translateY(0);
                    opacity: 1;
                }
            }

            .modal-header {
                padding: 1.5rem;
                border-bottom: 1px solid var(--gray-200);
                display: flex;
                align-items: center;
                justify-content: space-between;
                background: white;
            }

            .modal-title {
                font-size: 1.25rem;
                font-weight: 600;
                color: var(--gray-800);
            }

            .modal-close {
                background: none;
                border: none;
                font-size: 1.5rem;
                cursor: pointer;
                color: var(--gray-400);
                padding: 0.25rem;
                border-radius: 50%;
                width: 2rem;
                height: 2rem;
                display: flex;
                align-items: center;
                justify-content: center;
            }

            .modal-close:hover {
                background: var(--gray-100);
                color: var(--gray-600);
            }

            .modal-body {
                padding: 1.5rem;
                background: white;
            }

            .modal-footer {
                padding: 1.5rem;
                border-top: 1px solid var(--gray-200);
                display: flex;
                gap: 1rem;
                justify-content: flex-end;
                background: white;
            }

            .reject-form {
                background: white;
                padding: 1rem;
                border-radius: var(--border-radius);
                border: 1px solid var(--danger);
            }

            .reject-form textarea {
                width: 100%;
                min-height: 100px;
                padding: 0.75rem;
                border: 1px solid var(--gray-300);
                border-radius: var(--border-radius);
                resize: vertical;
                font-family: inherit;
            }

            .reject-form textarea:focus {
                outline: none;
                border-color: var(--danger);
                box-shadow: 0 0 0 3px rgba(239, 68, 68, 0.1);
            }

            @media (max-width: 768px) {
                .main-content {
                    padding: 1rem;
                }

                .header {
                    padding: 1.5rem 1rem;
                }

                .header h1 {
                    font-size: 1.5rem;
                }

                .content {
                    padding: 1rem;
                }

                .section-body {
                    padding: 1rem;
                }

                .info-grid {
                    grid-template-columns: 1fr;
                    gap: 1rem;
                }

                .form-footer {
                    padding: 1.5rem 1rem;
                    flex-direction: column;
                }

                .btn {
                    width: 100%;
                }

                th, td {
                    padding: 0.75rem 0.5rem;
                    font-size: 0.75rem;
                }
            }

            .loading {
                display: none;
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(255, 255, 255, 0.9);
                z-index: 9999;
                justify-content: center;
                align-items: center;
            }

            .spinner {
                width: 40px;
                height: 40px;
                border: 4px solid var(--gray-200);
                border-top: 4px solid var(--primary);
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
        </style>
    </head>
    <body>
        <div class="loading" id="loading">
            <div class="spinner"></div>
        </div>

        <div class="layout-container">
            <jsp:include page="/include/sidebar.jsp" />
            <div class="main-content">
                <div class="container">
                    <div class="header">
                        <h1><i class="fas fa-warehouse"></i> Xử lý Nhập Kho</h1>
                        <p>Xác nhận hoặc từ chối yêu cầu nhập kho vào hệ thống</p>
                    </div>

                    <div class="content">
                        <div class="breadcrumb">
                            <a href="${pageContext.request.contextPath}/Admin.jsp"><i class="fas fa-home"></i> Trang chủ</a>
                            <i class="fas fa-chevron-right"></i>
                            <a href="import">Danh sách yêu cầu</a>
                            <i class="fas fa-chevron-right"></i>
                            <span>Xử lý nhập kho</span>
                        </div>

                        <div class="alert alert-info">
                            <i class="fas fa-info-circle"></i>
                            <div>
                                <strong>Lưu ý:</strong> Vui lòng kiểm tra kỹ thông tin trước khi xác nhận nhập kho. 
                                Sau khi xác nhận, dữ liệu sẽ được cập nhật vào hệ thống kho.
                            </div>
                        </div>

                        <form action="import-confirm" method="post" id="importForm">
                            <!-- Thông tin đơn nhập kho -->
                            <div class="section">
                                <div class="section-header">
                                    <div class="icon"><i class="fas fa-file-alt"></i></div>
                                    <h3>Thông tin đơn nhập kho</h3>
                                    <span class="status-badge status-approved">
                                        <i class="fas fa-check-circle"></i> Đã duyệt
                                    </span>
                                </div>
                                <div class="section-body">
                                    <div class="info-grid">
                                        <div class="info-item">
                                            <label class="info-label">Mã đơn nhập</label>
                                            <input type="text" name="id" value="${p.id}" readonly class="info-value" style="border: none; padding: 0.75rem; background: var(--gray-50);">
                                        </div>
                                        <div class="info-item">
                                            <label class="info-label">Ngày tạo đơn</label>
                                            <input type="text" name="dayRequest" value="${p.day_request}" readonly class="info-value" style="border: none; padding: 0.75rem; background: var(--gray-50);">
                                        </div>
                                        <div class="info-item">
                                            <label class="info-label">Người tạo đơn</label>
                                            <input type="text" name="userId" value="${p.user_id}" readonly class="info-value" style="border: none; padding: 0.75rem; background: var(--gray-50);">
                                        </div>
                                        <div class="info-item">
                                            <label class="info-label">Trạng thái</label>
                                            <input type="text" name="status" value="${p.status}" readonly class="info-value" style="border: none; padding: 0.75rem; background: var(--gray-50);">
                                        </div>
                                        <div class="info-item" style="grid-column: 1 / -1;">
                                            <label class="info-label">Lý do nhập kho</label>
                                            <input type="text" name="reason" value="${p.reason}" readonly class="info-value" style="border: none; padding: 0.75rem; background: var(--gray-50);">
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Thông tin nhà cung cấp -->
                            <div class="section">
                                <div class="section-header">
                                    <div class="icon"><i class="fas fa-building"></i></div>
                                    <h3>Thông tin nhà cung cấp</h3>
                                </div>
                                <div class="section-body">
                                    <div class="info-grid">
                                        <div class="info-item">
                                            <label class="info-label">Tên nhà cung cấp</label>
                                            <input type="text" name="supplier" value="${p.supplier}" readonly class="info-value" style="border: none; padding: 0.75rem; background: var(--gray-50);">
                                        </div>
                                        <div class="info-item">
                                            <label class="info-label">Điện thoại</label>
                                            <input type="text" name="phone" value="${p.phone}" readonly class="info-value" style="border: none; padding: 0.75rem; background: var(--gray-50);">
                                        </div>
                                        <div class="info-item">
                                            <label class="info-label">Email</label>
                                            <input type="text" name="email" value="${p.email}" readonly class="info-value" style="border: none; padding: 0.75rem; background: var(--gray-50);">
                                        </div>
                                        <div class="info-item">
                                            <label class="info-label">Địa chỉ</label>
                                            <input type="text" name="address" value="${p.address}" readonly class="info-value" style="border: none; padding: 0.75rem; background: var(--gray-50);">
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Danh sách vật tư -->
                            <div class="section">
                                <div class="section-header">
                                    <div class="icon"><i class="fas fa-boxes"></i></div>
                                    <h3>Danh sách vật tư nhập kho</h3>
                                </div>
                                <div class="section-body">
                                    <div class="alert alert-warning">
                                        <i class="fas fa-exclamation-triangle"></i>
                                        <div>
                                            <strong>Chú ý:</strong> Nhập số lượng thực tế nhận được. Có thể nhập ít hơn số lượng yêu cầu nếu cần thiết.
                                        </div>
                                    </div>

                                    <div class="table-container">
                                        <table>
                                            <thead>
                                                <tr>
                                                    <th><i class="fas fa-barcode"></i> Mã VT</th>
                                                    <th><i class="fas fa-tag"></i> Tên VT</th>
                                                    <th><i class="fas fa-ruler"></i> Đơn vị</th>
                                                    <th><i class="fas fa-list-ol"></i> SL Yêu cầu</th>
                                                    <th><i class="fas fa-check-circle"></i> Đã nhập</th>
                                                    <th><i class="fas fa-plus-circle"></i> Nhập lần này</th>
                                                    <th><i class="fas fa-sticky-note"></i> Ghi chú</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="item" items="${itemList}" varStatus="status">
                                                    <tr>
                                                        <td>
                                                            <input type="text" name="code_${item.productCode}" value="${item.productCode}" readonly class="form-input">
                                                        </td>
                                                        <td>
                                                            <input type="text" name="name_${item.productCode}" value="${item.productName}" readonly class="form-input">
                                                        </td>
                                                        <td>
                                                            <input type="text" name="unit_${item.productCode}" value="${item.unit}" readonly class="form-input">
                                                        </td>
                                                        <td>
                                                            <input type="text" value="${item.quantity}" readonly class="form-input quantity-input">
                                                        </td>
                                                        <td>
                                                            <input type="text" value="0" readonly class="form-input quantity-input">
                                                        </td>
                                                        <td>
                                                            <input type="number" name="importQty_${item.productCode}" min="0" max="${item.quantity}" 
                                                                   class="form-input editable quantity-input" required 
                                                                   placeholder="Nhập SL">
                                                        </td>
                                                        <td>
                                                            <input type="text" name="note_${item.productCode}" 
                                                                   class="form-input editable" placeholder="Ghi chú...">
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>

                            <!-- Thông tin nhập kho -->
                            <div class="section">
                                <div class="section-header">
                                    <div class="icon"><i class="fas fa-warehouse"></i></div>
                                    <h3>Thông tin nhập kho</h3>
                                </div>
                                <div class="section-body">
                                    <div class="info-grid">
                                        <div class="info-item">
                                            <label class="info-label">Kho nhập hàng *</label>
                                            <select name="warehouse" required class="form-input editable">
                                                <option value="">-- Chọn kho --</option>
                                                <option value="kho1">Kho chính</option>
                                                <option value="kho2">Kho chi nhánh</option>
                                                <option value="kho3">Kho phụ liệu</option>
                                            </select>
                                        </div>
                                        <div class="info-item">
                                            <label class="info-label">Ngày nhập kho thực tế *</label>
                                            <input type="date" name="importDate" required class="form-input editable" 
                                                   value="${currentDate}" min="${currentDate}">
                                        </div>
                                        <div class="info-item">
                                            <label class="info-label">Người nhập kho *</label>
                                            <input type="text" name="receiver" required class="form-input editable" 
                                                   placeholder="Nhập tên người nhận hàng">
                                        </div>
                                        <div class="info-item">
                                            <label class="info-label">Ghi chú bổ sung</label>
                                            <input type="text" name="additionalNote" class="form-input editable" 
                                                   placeholder="Ghi chú thêm (nếu có)">
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="form-footer">
                                <button type="button" onclick="confirmImport()" class="btn btn-primary">
                                    <i class="fas fa-check-circle"></i> Xác nhận nhập kho
                                </button>
                                <button type="button" onclick="rejectImport()" class="btn btn-danger">
                                    <i class="fas fa-times-circle"></i> Từ chối nhập kho
                                </button>
                                <a href="import" class="btn btn-secondary">
                                    <i class="fas fa-arrow-left"></i> Quay lại danh sách
                                </a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal xác nhận -->
        <div id="confirmModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h3 class="modal-title" id="modalTitle">Xác nhận hành động</h3>
                    <button type="button" class="modal-close" onclick="closeModal()">&times;</button>
                </div>
                <div class="modal-body">
                    <div style="text-align: center; padding: 1rem;">
                        <div id="modalIcon" style="font-size: 3rem; margin-bottom: 1rem;"></div>
                        <p id="modalMessage"></p>
                        <div id="rejectReasonContainer" style="display: none; margin-top: 1rem;">
                            <div class="reject-form">
                                <label class="info-label">Lý do từ chối *</label>
                                <textarea id="rejectReason" placeholder="Nhập lý do từ chối yêu cầu nhập kho..." required></textarea>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" onclick="closeModal()">Hủy bỏ</button>
                    <button type="button" id="confirmButton" class="btn">Xác nhận</button>
                </div>
            </div>
        </div>

        <script>
            function confirmImport() {
                // Validate form
                if (!validateForm()) {
                    return;
                }

                document.getElementById('modalTitle').textContent = 'Xác nhận nhập kho';
                document.getElementById('modalIcon').innerHTML = '<i class="fas fa-check-circle" style="color: var(--success);"></i>';
                document.getElementById('modalMessage').textContent = 'Bạn có chắc chắn muốn xác nhận nhập kho? Hành động này không thể hoàn tác.';
                document.getElementById('rejectReasonContainer').style.display = 'none';

                const confirmBtn = document.getElementById('confirmButton');
                confirmBtn.className = 'btn btn-primary';
                confirmBtn.innerHTML = '<i class="fas fa-check-circle"></i> Xác nhận nhập kho';
                confirmBtn.onclick = () => submitForm('confirm');

                document.getElementById('confirmModal').style.display = 'block';
            }

            function rejectImport() {
                document.getElementById('modalTitle').textContent = 'Từ chối nhập kho';
                document.getElementById('modalIcon').innerHTML = '<i class="fas fa-times-circle" style="color: var(--danger);"></i>';
                document.getElementById('modalMessage').textContent = 'Bạn có chắc chắn muốn từ chối yêu cầu nhập kho này?';
                document.getElementById('rejectReasonContainer').style.display = 'block';

                const confirmBtn = document.getElementById('confirmButton');
                confirmBtn.className = 'btn btn-danger';
                confirmBtn.innerHTML = '<i class="fas fa-times-circle"></i> Từ chối nhập kho';
                confirmBtn.onclick = () => submitForm('reject');

                document.getElementById('confirmModal').style.display = 'block';
            }

            function submitForm(action) {
                const form = document.getElementById('importForm');

                // Validate reject reason if rejecting
                if (action === 'reject') {
                    const rejectReason = document.getElementById('rejectReason').value.trim();
                    if (!rejectReason) {
                        showNotification('Vui lòng nhập lý do từ chối!', 'error');
                        return;
                    }

                    // Add reject reason to form
                    const reasonInput = document.createElement('input');
                    reasonInput.type = 'hidden';
                    reasonInput.name = 'rejectReason';
                    reasonInput.value = rejectReason;
                    form.appendChild(reasonInput);
                }

                // Tạo input hidden cho action
                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = action;
                form.appendChild(actionInput);

                // Hiển thị loading
                document.getElementById('loading').style.display = 'flex';

                // Submit form
                form.submit();

                // Close modal
                closeModal();
            }

            function validateForm() {
                const requiredFields = document.querySelectorAll('input[required], select[required]');
                let isValid = true;
                let firstInvalidField = null;

                requiredFields.forEach(field => {
                    if (!field.value.trim()) {
                        field.style.borderColor = 'var(--danger)';
                        field.style.boxShadow = '0 0 0 3px rgba(239, 68, 68, 0.1)';
                        isValid = false;
                        if (!firstInvalidField) {
                            firstInvalidField = field;
                        }
                    } else {
                        field.style.borderColor = 'var(--success)';
                        field.style.boxShadow = '0 0 0 3px rgba(16, 185, 129, 0.1)';
                    }
                });

                // Validate số lượng nhập
                const quantityInputs = document.querySelectorAll('input[name^="importQty_"]');
                let hasQuantity = false;

                quantityInputs.forEach(input => {
                    const value = parseInt(input.value) || 0;
                    const max = parseInt(input.getAttribute('max')) || 0;

                    if (value > 0) {
                        hasQuantity = true;
                        if (value > max) {
                            input.style.borderColor = 'var(--danger)';
                            input.style.boxShadow = '0 0 0 3px rgba(239, 68, 68, 0.1)';
                            isValid = false;
                            showNotification('Số lượng nhập không được vượt quá số lượng yêu cầu!', 'error');
                        }
                    }
                });

                if (!hasQuantity) {
                    showNotification('Vui lòng nhập ít nhất một sản phẩm!', 'warning');
                    isValid = false;
                }

                if (!isValid) {
                    if (firstInvalidField) {
                        firstInvalidField.focus();
                        firstInvalidField.scrollIntoView({behavior: 'smooth', block: 'center'});
                    }
                    showNotification('Vui lòng kiểm tra và điền đầy đủ thông tin bắt buộc!', 'error');
                }

                return isValid;
            }

            function closeModal() {
                document.getElementById('confirmModal').style.display = 'none';
                document.getElementById('rejectReason').value = '';
            }

            function showNotification(message, type = 'info') {
                const notification = document.createElement('div');
                notification.className = `alert alert-${type}`;
                notification.style.cssText = `
                    position: fixed;
                    top: 20px;
                    right: 20px;
                    z-index: 10000;
                    min-width: 300px;
                    max-width: 500px;
                    animation: slideInRight 0.3s ease;
                `;

                const icon = type === 'success' ? 'check-circle' :
                        type === 'error' ? 'exclamation-triangle' :
                        type === 'warning' ? 'exclamation-triangle' : 'info-circle';

                notification.innerHTML = `
                    <i class="fas fa-${icon}"></i>
                    <div>
                        <strong>${type.charAt(0).toUpperCase() + type.slice(1)}:</strong> ${message}
                    </div>
                    <button onclick="this.parentElement.remove()" style="background: none; border: none; color: inherit; font-size: 1.2rem; cursor: pointer; margin-left: auto;">&times;</button>
                `;

                document.body.appendChild(notification);

                setTimeout(() => {
                    if (notification.parentElement) {
                        notification.remove();
                    }
                }, 5000);
            }

            // Event listeners
            document.addEventListener('DOMContentLoaded', function () {
                // Set current date as default
                const dateInput = document.querySelector('input[name="importDate"]');
                if (dateInput && !dateInput.value) {
                    const today = new Date().toISOString().split('T')[0];
                    dateInput.value = today;
                }

                // Add quantity change listeners
                const quantityInputs = document.querySelectorAll('input[name^="importQty_"]');
                quantityInputs.forEach(input => {
                    input.addEventListener('change', function () {
                        const value = parseInt(this.value) || 0;
                        const max = parseInt(this.getAttribute('max')) || 0;

                        if (value > max) {
                            this.value = max;
                            showNotification(`Số lượng tối đa cho sản phẩm này là ${max}`, 'warning');
                        }
                    });
                });

                // Close modal when clicking outside
                window.onclick = function (event) {
                    const modal = document.getElementById('confirmModal');
                    if (event.target === modal) {
                        closeModal();
                    }
                };

                // Keyboard shortcuts
                document.addEventListener('keydown', function (e) {
                    if (e.ctrlKey && e.key === 'Enter') {
                        e.preventDefault();
                        confirmImport();
                    }
                    if (e.key === 'Escape') {
                        closeModal();
                    }
                });

                // REMOVED: Auto notification when page loads
                // showNotification('Trang xử lý nhập kho đã được tải thành công!', 'success');
            });

            // Add CSS animations
            const style = document.createElement('style');
            style.textContent = `
                @keyframes slideInRight {
                    from {
                        transform: translateX(100%);
                        opacity: 0;
                    }
                    to {
                        transform: translateX(0);
                        opacity: 1;
                    }
                }
            `;
            document.head.appendChild(style);
        </script>
    </body>
</html>