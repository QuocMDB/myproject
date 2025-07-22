package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import dao.PurchaseOrderDAO;
import model.PurchaseOrderInfo;

/**
 * List Purchase Order Servlet
 * @author Admin
 */
public class ApprovePurchaseQuotedServlet extends HttpServlet {
 
  private PurchaseOrderDAO dao;
  
  @Override
  public void init() throws ServletException {
      dao = new PurchaseOrderDAO();
  }
  
  protected void processRequest(HttpServletRequest request, HttpServletResponse response)
          throws ServletException, IOException {
      response.setContentType("text/html;charset=UTF-8");
      request.setCharacterEncoding("UTF-8");
      
      // Kiểm tra xem có action nào được gửi không (approve/reject)
      String action = request.getParameter("action");
      String purchaseOrderId = request.getParameter("purchaseOrderId");
      
      if (action != null && purchaseOrderId != null) {
          handleAction(request, response, action, purchaseOrderId);
          return;
      }
      
      try {
          // Lấy parameters cho filter từ JSP
          String statusFilter = request.getParameter("statusFilter");
          String startDate = request.getParameter("startDate");
          String endDate = request.getParameter("endDate");
          String requestIdFilter = request.getParameter("requestIdFilter");
          
          // Debug logging
          System.out.println("=== SERVLET PARAMETERS ===");
          System.out.println("statusFilter: " + statusFilter);
          System.out.println("startDate: " + startDate);
          System.out.println("endDate: " + endDate);
          System.out.println("requestIdFilter: " + requestIdFilter);
          
          // Phân trang - sử dụng 'page' thay vì 'index' để phù hợp với JSP
          int currentPage = 1;
          try {
              if (request.getParameter("page") != null && !request.getParameter("page").isEmpty()) {
                  currentPage = Integer.parseInt(request.getParameter("page"));
                  if (currentPage < 1) {
                      currentPage = 1;
                  }
              }
          } catch (NumberFormatException e) {
              currentPage = 1;
          }
          
          System.out.println("currentPage: " + currentPage);
          
          // Lấy danh sách purchase orders với phân trang (10 records per page)
          List<PurchaseOrderInfo> purchaseOrders = dao.getAllPurchaseOrders(
              currentPage, startDate, endDate, statusFilter, requestIdFilter);
          
          // Lấy tổng số records để tính pagination
          int totalRecords = dao.getTotalFilteredPurchaseOrders(
              startDate, endDate, statusFilter, requestIdFilter);
          
          int totalPages = (int) Math.ceil((double) totalRecords / 10); // 10 records per page
          
          System.out.println("totalRecords: " + totalRecords);
          System.out.println("totalPages: " + totalPages);
          System.out.println("purchaseOrders size: " + purchaseOrders.size());
          
          // Set attributes cho JSP
          request.setAttribute("purchaseOrders", purchaseOrders);
          request.setAttribute("currentPage", currentPage);
          request.setAttribute("totalPages", totalPages);
          request.setAttribute("totalRecords", totalRecords);
          
          // Giữ lại các filter parameters để JSP có thể hiển thị
          request.setAttribute("statusFilter", statusFilter);
          request.setAttribute("startDate", startDate);
          request.setAttribute("endDate", endDate);
          request.setAttribute("requestIdFilter", requestIdFilter);
          
          // Thông báo thành công nếu có
          String message = request.getParameter("message");
          if (message != null && !message.isEmpty()) {
              request.setAttribute("successMessage", message);
          }
          
          // Chuyển sang JSP
          request.getRequestDispatcher("ApprovePurchaseQuoted.jsp").forward(request, response);
          
      } catch (Exception e) {
          System.err.println("Error in ApprovePurchaseQuotedServlet: " + e.getMessage());
          e.printStackTrace();
          
          // Set error message
          request.setAttribute("errorMessage", "Có lỗi xảy ra khi tải danh sách đơn mua hàng: " + e.getMessage());
          
          // Vẫn forward về JSP để hiển thị lỗi
          request.getRequestDispatcher("ApprovePurchaseQuoted.jsp").forward(request, response);
      }
  }
  
  /**
   * Xử lý các action approve/reject
   */
  private void handleAction(HttpServletRequest request, HttpServletResponse response, 
                           String action, String purchaseOrderId) 
          throws ServletException, IOException {
      
      try {
          boolean success = false;
          String message = "";
          
          if ("approve".equals(action)) {
              // Phê duyệt đơn mua hàng
              success = dao.updatePurchaseOrderStatus(purchaseOrderId, "approved");
              if (success) {
                  message = "Đã phê duyệt đơn mua hàng " + purchaseOrderId + " thành công!";
                  System.out.println("✅ Approved purchase order: " + purchaseOrderId);
              } else {
                  message = "Có lỗi xảy ra khi phê duyệt đơn mua hàng " + purchaseOrderId;
                  System.out.println("❌ Failed to approve purchase order: " + purchaseOrderId);
              }
              
          } else if ("reject".equals(action)) {
              // Từ chối đơn mua hàng
              success = dao.updatePurchaseOrderStatus(purchaseOrderId, "re-quote");
              if (success) {
                  message = "Đã từ chối đơn mua hàng " + purchaseOrderId + ". Đơn sẽ được báo giá lại.";
                  System.out.println("✅ Rejected purchase order: " + purchaseOrderId);
              } else {
                  message = "Có lỗi xảy ra khi từ chối đơn mua hàng " + purchaseOrderId;
                  System.out.println("❌ Failed to reject purchase order: " + purchaseOrderId);
              }
          }
          
          // Tạo URL redirect với message và các filter parameters
          StringBuilder redirectUrl = new StringBuilder("approvepurchasequoted?");
          
          if (success) {
              redirectUrl.append("message=").append(java.net.URLEncoder.encode(message, "UTF-8"));
          } else {
              redirectUrl.append("error=").append(java.net.URLEncoder.encode(message, "UTF-8"));
          }
          
          // Thêm lại các filter parameters
          String[] filterParams = {"startDate", "endDate", "statusFilter", "requestIdFilter", "page"};
          for (String param : filterParams) {
              String value = request.getParameter(param);
              if (value != null && !value.trim().isEmpty()) {
                  redirectUrl.append("&").append(param).append("=")
                           .append(java.net.URLEncoder.encode(value, "UTF-8"));
              }
          }
          
          response.sendRedirect(redirectUrl.toString());
          
      } catch (Exception e) {
          System.err.println("Error handling action " + action + " for purchase order " + purchaseOrderId + ": " + e.getMessage());
          e.printStackTrace();
          
          String errorMessage = "Có lỗi xảy ra khi xử lý yêu cầu: " + e.getMessage();
          response.sendRedirect("approvepurchasequoted?error=" + java.net.URLEncoder.encode(errorMessage, "UTF-8"));
      }
  }

  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
          throws ServletException, IOException {
      processRequest(request, response);
  }

  @Override
  protected void doPost(HttpServletRequest request, HttpServletResponse response)
          throws ServletException, IOException {
      processRequest(request, response);
  }

  @Override
  public String getServletInfo() {
      return "List Purchase Order Servlet - Hiển thị danh sách đơn mua hàng với phân trang và filter";
  }
}
