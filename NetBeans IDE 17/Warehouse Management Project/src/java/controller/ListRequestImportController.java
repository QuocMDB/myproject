//package controller;
//
//import dao.ListRequestImportDAO;
//import dao.SupplierDAO;
//import java.io.IOException;
//import jakarta.servlet.ServletException;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.http.HttpServlet;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//import java.util.List;
//import java.sql.SQLException;
//import java.util.ArrayList;
//import model.ApprovedRequestItem;
//import model.Supplier;
//
//@WebServlet("/request/list")
//public class ListRequestImportController extends HttpServlet {
//
//  @Override
//  protected void doGet(HttpServletRequest request, HttpServletResponse response)
//          throws ServletException, IOException {
//
//      // Tạo instance của DAO
//      ListRequestImportDAO dao = new ListRequestImportDAO();
//
//      // Lấy loại request (purchase hoặc history)
//      String type = request.getParameter("type");
//      if (type == null) {
//          type = "purchase"; // Mặc định là purchase
//      }
//
//      // Lấy tham số tìm kiếm dựa trên loại
//      String searchType = null;
//      String searchValue = null;
//
//      if ("history".equals(type)) {
//          // Tìm kiếm cho lịch sử
//          searchType = request.getParameter("historySearchType");
//          searchValue = request.getParameter("historySearchValue");
//      } else {
//          // Tìm kiếm cho yêu cầu đã duyệt
//          searchType = request.getParameter("searchType");
//          searchValue = request.getParameter("searchValue");
//      }
//
//      System.out.println("Request type: " + type);
//      System.out.println("Search parameters - Type: " + searchType + ", Value: " + searchValue);
//
//      // Lấy dữ liệu dựa trên loại request
//      List<ApprovedRequestItem> approvedItems = new ArrayList<>();
//      List<ApprovedRequestItem> completedItems = new ArrayList<>();
//
//      if ("history".equals(type)) {
//          // Chỉ lấy lịch sử khi cần
//          completedItems = dao.getCompletedRequestItems(searchType, searchValue);
//          // Lấy approved items không có tìm kiếm để hiển thị số lượng
//          approvedItems = dao.getApprovedRequestItems(null, null);
//      } else {
//          // Lấy approved items với tìm kiếm
//          approvedItems = dao.getApprovedRequestItems(searchType, searchValue);
//          // Lấy completed items không có tìm kiếm để hiển thị số lượng
//          completedItems = dao.getCompletedRequestItems(null, null);
//      }
//
//      // Debug logs
//      System.out.println("Approved items size: " + (approvedItems != null ? approvedItems.size() : "null"));
//      System.out.println("Completed items size: " + (completedItems != null ? completedItems.size() : "null"));
//
//      // Lấy thông tin supplier
//      SupplierDAO sd = new SupplierDAO();
//      List<Supplier> listSupplier = new ArrayList<>();
//      for (ApprovedRequestItem item : completedItems) {
//          if (item.getSupplier() != null) {
//              Supplier s = sd.getSupplierByName(item.getSupplier());
//              if (s != null) {
//                  listSupplier.add(s);
//              }
//          }
//      }
//
//      // Gửi dữ liệu sang JSP
//      request.setAttribute("items", approvedItems);
//      request.setAttribute("historyItems", completedItems);
//      request.setAttribute("searchType", searchType);
//      request.setAttribute("searchValue", searchValue);
//      request.setAttribute("supplier", listSupplier);
//      request.setAttribute("requestType", type);
//
//      request.getRequestDispatcher("/ListRequestImport.jsp").forward(request, response);
//  }
//
//  @Override
//  protected void doPost(HttpServletRequest request, HttpServletResponse response)
//          throws ServletException, IOException {
//
//      ListRequestImportDAO dao = new ListRequestImportDAO();
//      String requestId = request.getParameter("id");
//      String note = request.getParameter("note");
//      String approveDate = request.getParameter("approveDate");
//
//      // Validate parameters
//      if (requestId == null || requestId.trim().isEmpty()
//              || approveDate == null || approveDate.trim().isEmpty()) {
//
//          System.err.println("Invalid parameters: requestId=" + requestId + ", approveDate=" + approveDate);
//          response.sendRedirect(request.getContextPath() + "/request/list?error=invalid_data");
//          return;
//      }
//
//      try {
//          // Cập nhật trạng thái yêu cầu thành 'completed'
//          dao.updateRequestStatus(requestId, "completed", approveDate);
//
//          // Chuyển hướng về danh sách với thông báo thành công
//          response.sendRedirect(request.getContextPath() + "/request/list?message=approve_success");
//
//      } catch (SQLException e) {
//          e.printStackTrace();
//          System.err.println("SQLException occurred while updating request status for requestId: "
//                  + requestId + ", Error: " + e.getMessage());
//          response.sendRedirect(request.getContextPath() + "/request/list?error=approve_failed");
//      }
//  }
//}