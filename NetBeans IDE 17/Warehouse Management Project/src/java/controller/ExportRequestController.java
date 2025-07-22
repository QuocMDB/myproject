package controller;

import dao.ExportRequestDAO;
import dao.ExportRequestItemsDAO;
import dao.ProductInfoDAO;
import dao.UnitDAO;
import dao.UserDAO;
import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.ProductInfo;
import model.Unit;
import model.Users;

public class ExportRequestController extends HttpServlet {

  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
          throws ServletException, IOException {

      // Kiểm tra session trước khi sử dụng
      HttpSession session = request.getSession(false);

      if (session == null) {
          System.out.println("Session is null - redirecting to login");
          response.sendRedirect("login.jsp");
          return;
      }

      Users currentUser = (Users) session.getAttribute("user");

      if (currentUser == null) {
          System.out.println("Current user is null - redirecting to login");
          response.sendRedirect("login.jsp");
          return;
      }

      try {
          // Khởi tạo các DAO
          UserDAO dao = new UserDAO();
          ExportRequestDAO exportRequestDAO = new ExportRequestDAO();
          ProductInfoDAO product = new ProductInfoDAO();
          UnitDAO unitDAO = new UnitDAO();

          // Lấy thông tin user
          String fullname = dao.getFullName(currentUser.getId());
          Date DoB = dao.getDoB(currentUser.getId());
          
          // Lấy ID preview cho form
          String nextExportID = exportRequestDAO.getNextExportRequestId();

          // Tính tuổi
          if (DoB != null) {
              java.util.Calendar cal = java.util.Calendar.getInstance();
              cal.setTime(DoB);
              int yearOfBirth = cal.get(java.util.Calendar.YEAR);
              int currentYear = java.util.Calendar.getInstance().get(java.util.Calendar.YEAR);
              int age = currentYear - yearOfBirth;
              request.setAttribute("age", age);
          } else {
              System.out.println("DOB is null for user: " + currentUser.getId());
              request.setAttribute("age", "N/A");
          }

          // Lấy dữ liệu cho form
          List<ProductInfo> products_list = product.getAllProducts();
          List<Unit> units_list = unitDAO.getAllUnits();

          // Set attributes
          request.setAttribute("nextExportID", nextExportID);
          request.setAttribute("products_list", products_list);
          request.setAttribute("units_list", units_list);
          session.setAttribute("currentUser", fullname);
          session.setAttribute("DoB", DoB);

          request.getRequestDispatcher("ExportRequest.jsp").forward(request, response);
          
      } catch (Exception e) {
          System.out.println("Error in doGet: " + e.getMessage());
          e.printStackTrace();
          request.setAttribute("error", "Có lỗi xảy ra khi tải trang: " + e.getMessage());
          request.getRequestDispatcher("error.jsp").forward(request, response);
      }
  }

  @Override
  protected void doPost(HttpServletRequest request, HttpServletResponse response)
          throws ServletException, IOException {
      response.setContentType("text/html;charset=UTF-8");
      request.setCharacterEncoding("UTF-8");

      try {
          // Lấy dữ liệu từ form
          String role = request.getParameter("role");
          String dayRequestStr = request.getParameter("day_request");
          String reason = request.getParameter("reason");
          String department = request.getParameter("department");
          String recipientName = request.getParameter("recipient_name");
          String recipientPhone = request.getParameter("recipient_phone");
          String recipientEmail = request.getParameter("recipient_email");

          // Debug log
          System.out.println("=== DEBUG EXPORT REQUEST ===");
          System.out.println("Role: " + role);
          System.out.println("Day request: " + dayRequestStr);
          System.out.println("Department: " + department);
          System.out.println("Recipient: " + recipientName);

          // Parse ngày
          Date dayRequest = null;
          try {
              java.util.Date utilDate = new SimpleDateFormat("yyyy-MM-dd").parse(dayRequestStr);
              dayRequest = new java.sql.Date(utilDate.getTime());
          } catch (ParseException e) {
              e.printStackTrace();
              request.setAttribute("error", "Ngày không hợp lệ");
              doGet(request, response); // Reload form với error
              return;
          }

          // Lấy thông tin items
          String[] sttArr = request.getParameterValues("stt");
          String[] productNameArr = request.getParameterValues("product_name");
          String[] productCodeArr = request.getParameterValues("product_code");
          String[] unitArr = request.getParameterValues("unit");
          String[] quantityArr = request.getParameterValues("quantity");
          String[] noteArr = request.getParameterValues("note");
          String reasonDetail = request.getParameter("reason_detail");

          // Debug items
          System.out.println("Product names: " + java.util.Arrays.toString(productNameArr));
          System.out.println("Product codes: " + java.util.Arrays.toString(productCodeArr));
          System.out.println("Original units: " + java.util.Arrays.toString(unitArr));
          System.out.println("Quantities: " + java.util.Arrays.toString(quantityArr));

          // Validate dữ liệu
          if (productNameArr == null || productCodeArr == null || quantityArr == null) {
              request.setAttribute("error", "Vui lòng nhập đầy đủ thông tin sản phẩm");
              doGet(request, response);
              return;
          }

          // Convert quantity sang int
          int[] quantityIntArr = new int[quantityArr.length];
          for (int i = 0; i < quantityArr.length; i++) {
              try {
                  quantityIntArr[i] = Integer.parseInt(quantityArr[i]);
              } catch (NumberFormatException e) {
                  quantityIntArr[i] = 0;
              }
          }

          // Lấy user từ session
          HttpSession session = request.getSession(false);
          Users currentUser = (Users) session.getAttribute("user");
          int user_id = currentUser.getId();

          // Convert product IDs thành tên sản phẩm
          ProductInfoDAO productDAO = new ProductInfoDAO();
          String[] actualProductNames = new String[productNameArr.length];
          for (int i = 0; i < productNameArr.length; i++) {
              if (productNameArr[i] != null && !productNameArr[i].trim().isEmpty()) {
                  try {
                      int productId = Integer.parseInt(productNameArr[i]);
                      actualProductNames[i] = productDAO.getProductNameById(productId);
                  } catch (NumberFormatException e) {
                      actualProductNames[i] = productNameArr[i];
                  }
              } else {
                  actualProductNames[i] = "";
              }
          }

          // Convert unit IDs thành tên đơn vị
          UnitDAO unitDAO = new UnitDAO();
          String[] actualUnitNames = convertUnitsToNames(unitArr, unitDAO);
          
          System.out.println("Converted units: " + java.util.Arrays.toString(actualUnitNames));

          // Khởi tạo DAO
          ExportRequestDAO exportRequestDAO = new ExportRequestDAO();
          ExportRequestItemsDAO exportRequestItemsDAO = new ExportRequestItemsDAO();

          // Thêm export request - ID sẽ được tạo trong method này
          String export_request_id = exportRequestDAO.addExportRequestIntoDB(
                  user_id, role, dayRequest, "pending", reason, department,
                  recipientName, recipientPhone, recipientEmail);

          if (export_request_id != null && !export_request_id.trim().isEmpty()) {
              // Thêm items
              exportRequestItemsDAO.addExportItemsIntoDB(
                      export_request_id, actualProductNames, productCodeArr,
                      actualUnitNames, quantityIntArr, noteArr, reasonDetail);

              // Set thông tin cho success page
              request.setAttribute("exportRequestId", export_request_id);
              request.setAttribute("requestDate", new SimpleDateFormat("dd/MM/yyyy").format(dayRequest));
              request.setAttribute("department", department);
              request.setAttribute("recipientName", recipientName);

              // Forward đến success page
              request.getRequestDispatcher("ExportRequestSuccessNotification.jsp").forward(request, response);
          } else {
              request.setAttribute("error", "Không thể tạo đơn xuất kho. Vui lòng thử lại.");
              doGet(request, response);
          }

      } catch (Exception e) {
          e.printStackTrace();
          request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
          doGet(request, response);
      }
  }

  /**
   * Convert unit IDs thành tên đơn vị
   */
  private String[] convertUnitsToNames(String[] unitArr, UnitDAO unitDAO) {
      if (unitArr == null) return new String[0];
      
      String[] actualUnitNames = new String[unitArr.length];
      
      for (int i = 0; i < unitArr.length; i++) {
          if (unitArr[i] != null && !unitArr[i].trim().isEmpty()) {
              try {
                  int unitId = Integer.parseInt(unitArr[i]);
                  Unit unit = unitDAO.getUnitById(unitId);
                  if (unit != null) {
                      String unitDisplay = (unit.getSymbol() != null && !unit.getSymbol().trim().isEmpty()) 
                                         ? unit.getSymbol() 
                                         : unit.getName();
                      actualUnitNames[i] = unitDisplay;
                      System.out.println("Converted unit ID " + unitId + " to: " + unitDisplay);
                  } else {
                      actualUnitNames[i] = unitArr[i];
                      System.out.println("Warning: Không tìm thấy unit với ID: " + unitId);
                  }
              } catch (NumberFormatException e) {
                  actualUnitNames[i] = unitArr[i];
                  System.out.println("Unit is already a name: " + unitArr[i]);
              } catch (Exception e) {
                  actualUnitNames[i] = unitArr[i];
                  System.out.println("Database error when getting unit: " + e.getMessage());
              }
          } else {
              actualUnitNames[i] = "";
          }
      }
      
      return actualUnitNames;
  }

  @Override
  public String getServletInfo() {
      return "Export Request Servlet";
  }
}