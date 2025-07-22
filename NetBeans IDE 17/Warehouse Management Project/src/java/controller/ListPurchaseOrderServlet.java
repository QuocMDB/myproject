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
public class ListPurchaseOrderServlet extends HttpServlet {
 
  private PurchaseOrderDAO dao;
  
  @Override
  public void init() throws ServletException {
      dao = new PurchaseOrderDAO();
  }
  
  protected void processRequest(HttpServletRequest request, HttpServletResponse response)
          throws ServletException, IOException {
      response.setContentType("text/html;charset=UTF-8");
      request.setCharacterEncoding("UTF-8");
      
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
          request.getRequestDispatcher("ListPurchaseOrder.jsp").forward(request, response);
          
      } catch (Exception e) {
          System.err.println("Error in ListPurchaseOrderServlet: " + e.getMessage());
          e.printStackTrace();
          
          // Set error message
          request.setAttribute("errorMessage", "Có lỗi xảy ra khi tải danh sách đơn mua hàng: " + e.getMessage());
          
          // Vẫn forward về JSP để hiển thị lỗi
          request.getRequestDispatcher("ListPurchaseOrder.jsp").forward(request, response);
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