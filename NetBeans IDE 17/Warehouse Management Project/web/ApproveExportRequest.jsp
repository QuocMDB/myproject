<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.ExportRequest"%>
<%@page import="model.ExportRequestItem"%>
<!DOCTYPE html>
<html lang="vi">
  <head>
      <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <!-- Material Icons -->
      <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
      <title>Phê Duyệt Yêu Cầu Xuất Kho</title>
      <style>
          * {
              margin: 0;
              padding: 0;
              box-sizing: border-box;
              font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
          }
          body {
              background-color: #f0f2f5;
              align-items: flex-start;
              min-height: 100vh;
              padding: 20px;
          }
          .container {
              background: #fff;
              padding: 30px;
              border-radius: 12px;
              box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
              width: 100%;
              max-width: 1400px;
          }
          h1 {
              text-align: center;
              color: #333;
              margin-bottom: 20px;
              font-size: 28px;
          }
          .filter-section {
              margin-bottom: 20px;
              display: flex;
              justify-content: center;
              gap: 20px;
              flex-wrap: wrap;
          }
          .filter-item {
              display: flex;
              align-items: center;
              gap: 5px;
          }
          .filter-section label {
              font-size: 14px;
              color: #555;
          }
          .filter-section select, .filter-section input {
              padding: 10px;
              border: 1px solid #ddd;
              border-radius: 8px;
              font-size: 14px;
          }
          .filter-section .filter-button, .filter-section .clear-filter-button {
              padding: 10px 20px;
              color: #fff;
              border: none;
              border-radius: 8px;
              cursor: pointer;
              font-size: 14px;
              display: flex;
              align-items: center;
              gap: 5px;
              transition: background 0.3s, transform 0.2s;
              box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
          }
          .filter-section .filter-button {
              background: #28a745;
          }
          .filter-section .filter-button:hover {
              background: #218838;
              transform: translateY(-2px);
              box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
          }
          .filter-section .clear-filter-button {
              background: #dc3545;
          }
          .filter-section .clear-filter-button:hover {
              background: #c82333;
              transform: translateY(-2px);
              box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
          }
          .filter-section .material-icons {
              font-size: 18px;
          }
          .requests-table {
              width: 100%;
              border-collapse: collapse;
              margin-bottom: 20px;
          }
          .requests-table th, .requests-table td {
              border: 1px solid #ddd;
              padding: 12px;
              text-align: center;
              font-size: 14px;
          }
          .requests-table th {
              background-color: #007bff;
              color: #fff;
          }

          /* Style cho action buttons trong table */
          .action-buttons-cell {
              display: flex;
              gap: 5px;
              justify-content: center;
              align-items: center;
              flex-wrap: wrap;
          }
          .action-btn {
              padding: 6px 12px;
              border: none;
              border-radius: 8px;
              cursor: pointer;
              font-size: 12px;
              display: flex;
              align-items: center;
              gap: 3px;
              transition: all 0.3s;
              text-decoration: none;
              color: #fff;
          }
          .view-btn {
              background: #17a2b8;
          }
          .view-btn:hover {
              background: #138496;
              transform: translateY(-1px);
          }

          /* Nút phê duyệt và từ chối */
          .approve-btn {
              background: #28a745;
              color: #fff !important;
          }
          .approve-btn:hover {
              background: #218838;
              transform: translateY(-1px);
          }
          .reject-btn {
              background: #dc3545;
              color: #fff !important;
          }
          .reject-btn:hover {
              background: #c82333;
              transform: translateY(-1px);
          }

          .action-btn .material-icons {
              font-size: 16px;
          }
          .status-rejected {
              background-color: #f8d7da !important;
              border-left: 4px solid #dc3545 !important;
              color: #721c24 !important;
              font-weight: bold !important;
          }
          .status-approved {
              background-color: #d4edda !important;
              border-left: 4px solid #28a745 !important;
              color: #155724 !important;
              font-weight: bold !important;
          }
          
          /* CẬP NHẬT: Điều chỉnh độ rộng cột cho phù hợp với "Người Yêu Cầu" */
          .requests-table th:nth-child(1),
          .requests-table td:nth-child(1) {
              width: 1cm;
          }
          .requests-table th:nth-child(2),
          .requests-table td:nth-child(2) {
              width: 1.5cm;
          }
          .requests-table th:nth-child(3),
          .requests-table td:nth-child(3) {
              width: 3cm; /* Tăng độ rộng cho cột "Người Yêu Cầu" */
          }
          .requests-table th:nth-child(4),
          .requests-table td:nth-child(4) {
              width: 2cm;
          }
          .requests-table th:nth-child(5),
          .requests-table td:nth-child(5) {
              width: 1.5cm;
          }
          .requests-table th:nth-child(6),
          .requests-table td:nth-child(6) {
              width: 5cm;
          }
          .requests-table th:nth-child(7),
          .requests-table td:nth-child(7) {
              width: 4cm;
          }
          .action-buttons-cell {
              display: flex;
              gap: 5px;
              justify-content: center;
              align-items: center;
              flex-wrap: wrap;
              padding: 8px;
          }

          .detail-row {
              display: none;
          }
          .detail-table {
              width: 100%;
              border-collapse: collapse;
              background: #f8f9fa;
              animation: dropDown 0.3s ease-out;
          }
          .detail-table th, .detail-table td {
              border: 1px solid #ddd;
              padding: 10px;
              text-align: center;
              font-size: 14px;
          }
          .detail-table th {
              background-color: #28a745;
              color: #fff;
          }
          .detail-table th:nth-child(2), .detail-table td:nth-child(2) {
              width: 10cm;
          }
          .detail-table th:nth-child(1), .detail-table td:nth-child(1) {
              width: 1.5cm;
          }
          .detail-table th:nth-child(3), .detail-table td:nth-child(3) {
              width: 1.5cm;
          }
          .detail-table th:nth-child(4), .detail-table td:nth-child(4) {
              width: 1.5cm;
          }
          .detail-table th:nth-child(5), .detail-table td:nth-child(5) {
              width: 8cm;
          }
          .action-buttons {
              margin-top: 10px;
              text-align: center;
              display: flex;
              justify-content: center;
              gap: 10px;
          }
          .status-message {
              color: #555;
              font-style: italic;
              text-align: center;
              margin-top: 10px;
          }
          .pagination {
              display: flex;
              justify-content: center;
              align-items: center;
              gap: 15px;
              margin-top: 20px;
              flex-wrap: wrap;
          }
          .pagination button {
              padding: 8px 16px;
              background: #007bff;
              color: #fff;
              border: none;
              border-radius: 8px;
              cursor: pointer;
              font-size: 14px;
              display: flex;
              align-items: center;
              gap: 5px;
              transition: background 0.3s, transform 0.2s;
              box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
          }
          .pagination .pagination-button {
              text-decoration: none;
          }
          .pagination button:hover:not(:disabled) {
              background: #0056b3;
              transform: translateY(-2px);
              box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
          }
          .pagination button:disabled {
              background: #6c757d;
              cursor: not-allowed;
              opacity: 0.6;
          }
          .pagination button a {
              color: #fff;
              text-decoration: none;
          }
          .pagination .current-page {
              font-size: 16px;
              color: #333;
              font-weight: bold;
              padding: 8px 12px;
              background: #e9ecef;
              border-radius: 8px;
          }
          .pagination .total-pages {
              font-size: 14px;
              color: #555;
              margin-top: 10px;
              text-align: center;
              width: 100%;
          }
          .footer {
              text-align: center;
              margin-top: 30px;
          }
          .btn-secondary {
              display: inline-block;
              padding: 10px 20px;
              border-radius: 5px;
              text-decoration: none;
              font-weight: bold;
              cursor: pointer;
              transition: background-color 0.3s;
              background-color: transparent;
              color: #666;
              border: 1px solid #ccc;
          }
          .btn-secondary:hover {
              background-color: #f0f0f0;
          }
          .back-btn-icon {
              font-size: 16px;
              vertical-align: text-bottom;
              margin-right: 5px;
          }

          /* Modal styles */
          .modal {
              display: none;
              position: fixed;
              z-index: 1000;
              left: 0;
              top: 0;
              width: 100%;
              height: 100%;
              background-color: rgba(0,0,0,0.5);
          }
          .modal-content {
              background-color: #fefefe;
              margin: 15% auto;
              padding: 20px;
              border: none;
              border-radius: 10px;
              width: 400px;
              box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
          }
          .modal-header {
              display: flex;
              justify-content: space-between;
              align-items: center;
              margin-bottom: 20px;
          }
          .modal-title {
              margin: 0;
              color: #333;
          }
          .close {
              color: #aaa;
              font-size: 28px;
              font-weight: bold;
              cursor: pointer;
          }
          .close:hover {
              color: #000;
          }
          .modal-buttons {
              display: flex;
              justify-content: flex-end;
              gap: 10px;
              margin-top: 20px;
          }
          .modal-btn {
              padding: 8px 16px;
              border: none;
              border-radius: 5px;
              cursor: pointer;
              font-size: 14px;
          }
          .modal-btn-confirm {
              background-color: #dc3545;
              color: white;
          }
          .modal-btn-cancel {
              background-color: #6c757d;
              color: white;
          }

          @keyframes dropDown {
              from {
                  opacity: 0;
                  transform: translateY(-10px);
              }
              to {
                  opacity: 1;
                  transform: translateY(0);
              }
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

          /* Message styles */
          .message {
              padding: 10px;
              margin-bottom: 20px;
              border-radius: 8px;
              text-align: center;
          }
          .message.success {
              background-color: #d4edda;
              color: #155724;
              border: 1px solid #c3e6cb;
          }
          .message.error {
              background-color: #f8d7da;
              color: #721c24;
              border: 1px solid #f5c6cb;
          }
          
          /* Style cho tên người yêu cầu */
          .requester-name {
              font-weight: 600;
              color: #2c5aa0;
              text-align: left;
              padding-left: 8px;
          }
          
          /* Fallback styling cho Unknown User */
          .unknown-user {
              color: #dc3545;
              font-style: italic;
              font-weight: normal;
          }
      </style>
  </head>
  <body>
      <div class="layout-container">
          <jsp:include page="/include/sidebar.jsp" />
          <div class="main-content">
              <h1>PHÊ DUYỆT YÊU CẦU XUẤT KHO</h1>

              <!-- Hiển thị thông báo -->
              <c:if test="${not empty param.message}">
                  <div class="message success">
                      ${param.message}
                  </div>
              </c:if>

              <!-- Hiển thị thông báo lỗi -->
              <c:if test="${not empty errorMessage}">
                  <div class="message error">
                      ${errorMessage}
                  </div>
              </c:if>

              <form action="approveexportrequest" method="post" class="filter-section" id="filterForm">
                  <div class="filter-item">
                      <label for="startDate">Từ ngày:</label>
                      <input type="date" id="startDate" name="startDate" value="${param.startDate}">
                  </div>
                  <div class="filter-item">
                      <label for="endDate">Đến ngày:</label>
                      <input type="date" id="endDate" name="endDate" value="${param.endDate}">
                  </div>
                  <div class="filter-item">
                      <label for="statusFilter">Trạng thái:</label>
                      <select id="statusFilter" name="statusFilter">
                          <option value="" ${empty param.statusFilter ? 'selected' : ''}>Tất cả</option>
                          <option value="approved" ${param.statusFilter == 'approved' || param.statusFilter == 'completed'||param.statusFilter == 'partial_exported' ? 'selected' : ''}>Đã duyệt</option>
                          <option value="rejected" ${param.statusFilter == 'rejected' ? 'selected' : ''}>Đã từ chối</option>
                          <option value="pending" ${param.statusFilter == 'pending' ? 'selected' : ''}>Đang chờ</option>
                      </select>
                  </div>
                  <div class="filter-item">
                      <label for="requestIdFilter">ID:</label>
                      <input type="text" id="requestIdFilter" name="requestIdFilter" value="${param.requestIdFilter}" placeholder="Nhập ID">
                  </div>
                  <button type="submit" class="filter-button">
                      <span class="material-icons">filter_alt</span> Lọc
                  </button>
                  <button type="button" class="clear-filter-button" onclick="clearFilters()">
                      <span class="material-icons">clear</span> Xóa
                  </button>
              </form>
              <table class="requests-table">
                  <thead>
                      <tr>
                          <th>STT</th>
                          <th>ID</th>
                          <th>Người Yêu Cầu</th>
                          <th>Ngày Yêu Cầu</th>
                          <th>Trạng thái</th>
                          <th>Lý Do Xuất Kho</th>
                          <th>Hành Động</th>
                      </tr>
                  </thead>
                  <tbody id="requestsTableBody">
                      <c:choose>
                          <c:when test="${not empty pendingExportRequests}">
                              <c:forEach var="req" items="${pendingExportRequests}" varStatus="loop">
                                  <c:set var="status" value="" />
                                  <c:set var="rowClass" value="" />
                                  <c:choose>
                                      <c:when test="${req.status == 'pending'}">
                                          <c:set var="status" value="Đang chờ" />
                                      </c:when>
                                      <c:when test="${req.status == 'approved' || req.status == 'completed'||req.status == 'partial_exported'}">
                                          <c:set var="status" value="Đã duyệt" />
                                          <c:set var="rowClass" value="status-approved" />
                                      </c:when>
                                      <c:when test="${req.status == 'rejected'}">
                                          <c:set var="status" value="Đã từ chối" />
                                          <c:set var="rowClass" value="status-rejected" />
                                      </c:when>
                                  </c:choose>
                                  <tr class="${rowClass}">
                                      <td>${loop.count}</td>
                                      <td>${req.id}</td>
                                      <!-- THAY ĐỔI: Hiển thị requester_name thay vì user_id -->
                                      <td class="requester-name">
                                          <c:choose>
                                              <c:when test="${req.requester_name == 'Unknown User'}">
                                                  <span class="unknown-user">${req.requester_name}</span>
                                              </c:when>
                                              <c:otherwise>
                                                  <span title="User ID: ${req.user_id}">${req.requester_name}</span>
                                              </c:otherwise>
                                          </c:choose>
                                      </td>
                                      <td>
                                          <c:if test="${not empty req.day_request}">
                                              <fmt:formatDate value="${req.day_request}" pattern="dd/MM/yyyy" />
                                          </c:if>
                                      </td>
                                      <td>${status}</td>
                                      <td>${req.reason}</td>
                                      <td>
                                          <div class="action-buttons-cell">
                                              <!-- Nút xem chi tiết -->
                                              <button onclick="toggleDetails(this)" class="action-btn view-btn">
                                                  <span class="material-icons">visibility</span>
                                                  <span>Chi tiết</span>
                                              </button>

                                              <!-- Nút phê duyệt và từ chối chỉ hiển thị khi status = pending -->
                                              <c:if test="${req.status == 'pending'}">
                                                  <button onclick="approveExportRequest('${req.id}')" class="action-btn approve-btn">
                                                      <span class="material-icons">check_circle</span>
                                                      <span>Phê duyệt</span>
                                                  </button>
                                                  <button onclick="rejectExportRequest('${req.id}')" class="action-btn reject-btn">
                                                      <span class="material-icons">cancel</span>
                                                      <span>Từ chối</span>
                                                  </button>
                                              </c:if>
                                          </div>
                                      </td>

                                  </tr>
                                  <tr class="detail-row">
                                      <td colspan="7">
                                          <table class="detail-table">
                                              <thead>
                                                  <tr>
                                                      <th>Mã SP</th>
                                                      <th>Tên Sản Phẩm</th>     
                                                      <th>Đơn Vị</th>
                                                      <th>Số Lượng</th>
                                                      <th>Ghi Chú</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:choose>
                                                        <c:when test="${not empty req.items}">
                                                            <c:forEach var="item" items="${req.items}">
                                                                <tr>
                                                                    <td>${item.product_code}</td>
                                                                    <td>${item.product_name}</td>
                                                                    <td>${item.unit}</td>
                                                                    <td>${item.quantity}</td>
                                                                    <td>${item.note}</td>
                                                                </tr>
                                                            </c:forEach>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <tr>
                                                                <td colspan="5">Không có dữ liệu chi tiết</td>
                                                            </tr>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </tbody>
                                            </table>

                                            <!-- Status message cho các trạng thái khác -->
                                            <c:if test="${req.status == 'approved'}">
                                                <div class="status-message">Bạn đã duyệt yêu cầu xuất kho này</div>
                                            </c:if>
                                            <c:if test="${req.status == 'rejected'}">
                                                <div class="status-message">Bạn đã từ chối yêu cầu xuất kho này</div>
                                            </c:if>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="7" style="text-align: center; padding: 20px; color: #666;">
                                        <span class="material-icons" style="font-size: 48px; color: #ccc;">inventory_2</span><br>
                                        Không có yêu cầu xuất kho nào trong khoảng thời gian hoặc trạng thái này.
                                    </td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>

                <!-- Pagination -->
                <div class="pagination">
                    <c:set var="currentPage" value="${empty param.index ? 1 : param.index}" />
                    <c:set var="endPage" value="${requestScope.endPage}" />
                    <c:set var="filterParams" value="" />
                    <c:if test="${not empty param.startDate}">
                        <c:set var="filterParams" value="${filterParams}&startDate=${param.startDate}" />
                    </c:if>
                    <c:if test="${not empty param.endDate}">
                        <c:set var="filterParams" value="${filterParams}&endDate=${param.endDate}" />
                    </c:if>
                    <c:if test="${not empty param.statusFilter}">
                        <c:set var="filterParams" value="${filterParams}&statusFilter=${param.statusFilter}" />
                    </c:if>
                    <c:if test="${not empty param.requestIdFilter}">
                        <c:set var="filterParams" value="${filterParams}&requestIdFilter=${param.requestIdFilter}" />
                    </c:if>
                    <c:choose>
                        <c:when test="${currentPage <= 1}">
                            <button disabled>
                                <span class="material-icons">chevron_left</span>
                            </button>
                        </c:when>
                        <c:otherwise>
                            <a href="approveexportrequest?index=${currentPage - 1}${filterParams}" class="pagination-button">
                                <button>
                                    <span class="material-icons">chevron_left</span>
                                </button>
                            </a>
                        </c:otherwise>
                    </c:choose>
                    <span class="current-page">${currentPage}</span>
                    <c:choose>
                        <c:when test="${currentPage >= endPage}">
                            <button disabled>
                                <span class="material-icons">chevron_right</span>
                            </button>
                        </c:when>
                        <c:otherwise>
                            <a href="approveexportrequest?index=${currentPage + 1}${filterParams}" class="pagination-button">
                                <button>
                                    <span class="material-icons">chevron_right</span>
                                </button>
                            </a>
                        </c:otherwise>
                    </c:choose>
                    <div class="total-pages">Tổng số: ${totalRequests} mục | ${endPage} trang</div>
                </div>

                <div class="footer">
                    <a href="Admin.jsp" class="btn-secondary">
                        <span class="material-icons back-btn-icon">arrow_back</span> Quay Lại Trang Chủ
                    </a>
                </div>
            </div>
        </div>

        <!-- Modal xác nhận từ chối -->
        <div id="rejectModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h3 class="modal-title">Xác nhận từ chối</h3>
                    <span class="close" onclick="closeRejectModal()">&times;</span>
                </div>
                <p>Bạn có chắc chắn muốn từ chối yêu cầu xuất kho này không?</p>
                <p><strong>Yêu cầu sẽ được chuyển về trạng thái "Đã từ chối"</strong></p>
                <div class="modal-buttons">
                    <button class="modal-btn modal-btn-cancel" onclick="closeRejectModal()">Hủy</button>
                    <button class="modal-btn modal-btn-confirm" onclick="confirmReject()">Xác nhận từ chối</button>
                </div>
            </div>
        </div>

        <script>
            let currentRejectId = null;

            // Hàm toggle chi tiết
            function toggleDetails(button) {
                const row = button.closest('tr').nextElementSibling;
                if (row.classList.contains('detail-row')) {
                    const isVisible = row.style.display === 'table-row';
                    row.style.display = isVisible ? 'none' : 'table-row';

                    // Cập nhật icon và text
                    const icon = button.querySelector('.material-icons');
                    const text = button.querySelector('span:last-child');
                    if (isVisible) {
                        icon.textContent = 'visibility';
                        text.textContent = 'Chi tiết';
                    } else {
                        icon.textContent = 'visibility_off';
                        text.textContent = 'Ẩn';
                    }
                }
            }

            // Hàm phê duyệt yêu cầu xuất kho
            // Hàm phê duyệt yêu cầu xuất kho
function approveExportRequest(requestId) {
    if (confirm('Bạn có chắc chắn muốn phê duyệt yêu cầu xuất kho này không?')) {
        // Tạo form để submit
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = 'approveexportrequest';

        // Thêm action
        const actionInput = document.createElement('input');
        actionInput.type = 'hidden';
        actionInput.name = 'action';
        actionInput.value = 'approve';
        form.appendChild(actionInput);

        // Thêm requestId
        const idInput = document.createElement('input');
        idInput.type = 'hidden';
        idInput.name = 'requestId';
        idInput.value = requestId;
        form.appendChild(idInput);

        // Thêm các filter parameters để giữ nguyên trang hiện tại
        const currentFilters = ['startDate', 'endDate', 'statusFilter', 'requestIdFilter', 'index'];
        currentFilters.forEach(filterName => {
            const filterValue = document.querySelector(`[name="${filterName}"]`)?.value ||
                    new URLSearchParams(window.location.search).get(filterName);
            if (filterValue) {
                const filterInput = document.createElement('input');
                filterInput.type = 'hidden';
                filterInput.name = filterName;
                filterInput.value = filterValue;
                form.appendChild(filterInput);
            }
        });

        document.body.appendChild(form);
        form.submit();
    }
}

// Hàm từ chối yêu cầu xuất kho
function rejectExportRequest(requestId) {
    currentRejectId = requestId;
    document.getElementById('rejectModal').style.display = 'block';
}

// Đóng modal từ chối
function closeRejectModal() {
    document.getElementById('rejectModal').style.display = 'none';
    currentRejectId = null;
}

// Xác nhận từ chối
function confirmReject() {
    if (currentRejectId) {
        // Tạo form để submit
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = 'approveexportrequest';

        // Thêm action
        const actionInput = document.createElement('input');
        actionInput.type = 'hidden';
        actionInput.name = 'action';
        actionInput.value = 'reject';
        form.appendChild(actionInput);

        // Thêm requestId
        const idInput = document.createElement('input');
        idInput.type = 'hidden';
        idInput.name = 'requestId';
        idInput.value = currentRejectId;
        form.appendChild(idInput);

        // Thêm các filter parameters để giữ nguyên trang hiện tại
        const currentFilters = ['startDate', 'endDate', 'statusFilter', 'requestIdFilter', 'index'];
        currentFilters.forEach(filterName => {
            const filterValue = document.querySelector(`[name="${filterName}"]`)?.value ||
                    new URLSearchParams(window.location.search).get(filterName);
            if (filterValue) {
                const filterInput = document.createElement('input');
                filterInput.type = 'hidden';
                filterInput.name = filterName;
                filterInput.value = filterValue;
                form.appendChild(filterInput);
            }
        });

        document.body.appendChild(form);
        form.submit();
    }
    closeRejectModal();
}

// Đóng modal khi click bên ngoài
window.onclick = function (event) {
    const modal = document.getElementById('rejectModal');
    if (event.target == modal) {
        closeRejectModal();
    }
}

// Hàm xóa bộ lọc
function clearFilters() {
    document.getElementById('startDate').value = '';
    document.getElementById('endDate').value = '';
    document.getElementById('statusFilter').value = '';
    document.getElementById('requestIdFilter').value = '';
    window.location.href = 'approveexportrequest';
}

// Validation form
document.getElementById('filterForm').addEventListener('submit', function (e) {
    const startDate = document.getElementById('startDate').value;
    const endDate = document.getElementById('endDate').value;

    if (startDate && endDate && startDate > endDate) {
        e.preventDefault();
        alert('Ngày bắt đầu không thể lớn hơn ngày kết thúc!');
        return false;
    }
});
        </script>
    </body>
</html>