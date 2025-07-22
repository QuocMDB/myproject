package controller;

import dao.PurchaseOrderDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * Servlet xử lý submit đơn báo giá - CẬP NHẬT thông tin thay vì tạo mới
 */
public class SubmitPurchaseOrderServlet extends HttpServlet {

  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
          throws ServletException, IOException {
      // Redirect về danh sách nếu truy cập trực tiếp
      response.sendRedirect("listpurchaseorder");
  }

  @Override
  protected void doPost(HttpServletRequest request, HttpServletResponse response)
          throws ServletException, IOException {
      response.setContentType("text/html;charset=UTF-8");
      request.setCharacterEncoding("UTF-8");

      HttpSession session = request.getSession(false);
      if (session == null || session.getAttribute("user") == null) {
          response.sendRedirect("login.jsp");
          return;
      }

      try {
          // ✅ 1. LẤY THÔNG TIN CƠ BẢN TỪ FORM
          String originalRequestId = request.getParameter("originalRequestId");
          String quoteDate = request.getParameter("quote_date");
          String supplier = request.getParameter("supplier_name");
          String address = request.getParameter("supplier_address");
          String phone = request.getParameter("supplier_phone");
          String email = request.getParameter("supplier_email");
          String quoteSummary = request.getParameter("quote_summary");

          System.out.println("🔍 Processing quote for ID: " + originalRequestId);
          System.out.println("🔍 Quote date: " + quoteDate);
          System.out.println("🔍 Supplier: " + supplier);

          // ✅ 2. CHUYỂN ĐỔI NGÀY BÁO GIÁ AN TOÀN
          java.sql.Date sqlQuoteDate = null;
          if (quoteDate != null && !quoteDate.isEmpty()) {
              SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
              Date quoteDateParsed = sdf.parse(quoteDate);
              sqlQuoteDate = new java.sql.Date(quoteDateParsed.getTime());
              System.out.println("✅ Converted date successfully: " + sqlQuoteDate);
          }

          // ✅ 3. CẬP NHẬT THÔNG TIN PURCHASE_ORDER_INFO
          PurchaseOrderDAO dao = new PurchaseOrderDAO();
          boolean updateInfoSuccess = dao.updatePurchaseOrderInfo(
              originalRequestId, 
              sqlQuoteDate,  // ✅ Sử dụng java.sql.Date
              supplier, 
              address, 
              phone, 
              email, 
              quoteSummary
          );

          if (!updateInfoSuccess) {
              System.out.println("❌ Failed to update purchase order info");
              request.setAttribute("errorMessage", "Không thể cập nhật thông tin báo giá. Vui lòng thử lại.");
              request.getRequestDispatcher("PurchaseOrderForm.jsp").forward(request, response);
              return;
          }
          
          System.out.println("✅ Updated purchase order info successfully");

          // ✅ 4. CẬP NHẬT GIÁ CHO TỪNG ITEM
          String[] productCodes = request.getParameterValues("product_code");
          String[] pricesPerUnit = request.getParameterValues("pricePerUnit");
          String[] totalPrices = request.getParameterValues("totalPrice");
          String[] itemNotes = request.getParameterValues("quote_item_note");

          if (productCodes != null && pricesPerUnit != null) {
              boolean updateItemsSuccess = true;
              
              System.out.println("🔍 Updating " + productCodes.length + " items");
              
              for (int i = 0; i < productCodes.length; i++) {
                  if (productCodes[i] != null && !productCodes[i].trim().isEmpty()) {
                      
                      // Parse price per unit
                      BigDecimal pricePerUnit = BigDecimal.ZERO;
                      if (pricesPerUnit != null && i < pricesPerUnit.length && pricesPerUnit[i] != null) {
                          try {
                              String priceStr = pricesPerUnit[i].replaceAll("[^0-9,.]", "").replace(",", ".");
                              pricePerUnit = new BigDecimal(priceStr);
                          } catch (NumberFormatException e) {
                              System.out.println("❌ Error parsing price for item " + i + ": " + pricesPerUnit[i]);
                              pricePerUnit = BigDecimal.ZERO;
                          }
                      }

                      // Parse total price
                      BigDecimal totalPrice = BigDecimal.ZERO;
                      if (totalPrices != null && i < totalPrices.length && totalPrices[i] != null) {
                          try {
                              String totalStr = totalPrices[i].replaceAll("[^0-9,.]", "").replace(",", ".");
                              totalPrice = new BigDecimal(totalStr);
                          } catch (NumberFormatException e) {
                              System.out.println("❌ Error parsing total price for item " + i + ": " + totalPrices[i]);
                              totalPrice = BigDecimal.ZERO;
                          }
                      }

                      // Get note
                      String note = (itemNotes != null && i < itemNotes.length) ? itemNotes[i] : "";

                      // Update item
                      boolean itemUpdateSuccess = dao.updatePurchaseOrderItem(
                          originalRequestId, 
                          productCodes[i], 
                          pricePerUnit, 
                          totalPrice, 
                          note
                      );

                      if (!itemUpdateSuccess) {
                          System.out.println("❌ Failed to update item: " + productCodes[i]);
                          updateItemsSuccess = false;
                      } else {
                          System.out.println("✅ Updated item: " + productCodes[i] + " - Price: " + pricePerUnit);
                      }
                  }
              }

              if (!updateItemsSuccess) {
                  request.setAttribute("errorMessage", "Có lỗi khi cập nhật giá sản phẩm. Vui lòng kiểm tra lại.");
                  request.getRequestDispatcher("PurchaseOrderForm.jsp").forward(request, response);
                  return;
              }
          }

          // ✅ 5. CẬP NHẬT STATUS THÀNH 'QUOTED'
          boolean updateStatusSuccess = dao.updatePurchaseOrderStatus(originalRequestId, "quoted");
          
          if (!updateStatusSuccess) {
              System.out.println("❌ Failed to update status to 'quoted'");
              request.setAttribute("errorMessage", "Không thể cập nhật trạng thái báo giá.");
              request.getRequestDispatcher("PurchaseOrderForm.jsp").forward(request, response);
              return;
          }

          // ✅ 6. THÀNH CÔNG - REDIRECT VỀ DANH SÁCH
          System.out.println("✅ Successfully completed quote for: " + originalRequestId);
          response.sendRedirect("QuoteSuccessNotification.jsp");

      } catch (ParseException e) {
          e.printStackTrace();
          System.out.println("❌ Date parsing error: " + e.getMessage());
          request.setAttribute("errorMessage", "Định dạng ngày không hợp lệ. Vui lòng kiểm tra lại.");
          request.getRequestDispatcher("PurchaseOrderForm.jsp").forward(request, response);
      } catch (NumberFormatException e) {
          e.printStackTrace();
          System.out.println("❌ Number format error: " + e.getMessage());
          request.setAttribute("errorMessage", "Định dạng số không hợp lệ. Vui lòng kiểm tra lại giá và số lượng.");
          request.getRequestDispatcher("PurchaseOrderForm.jsp").forward(request, response);
      } catch (Exception e) {
          e.printStackTrace();
          System.out.println("❌ Unexpected error: " + e.getMessage());
          request.setAttribute("errorMessage", "Có lỗi không mong muốn xảy ra: " + e.getMessage());
          request.getRequestDispatcher("PurchaseOrderForm.jsp").forward(request, response);
      }
  }

  @Override
  public String getServletInfo() {
      return "Servlet xử lý submit đơn báo giá - cập nhật thông tin";
  }
}