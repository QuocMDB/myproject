package dao;

import DBContext.Context;
import java.sql.*;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import model.Request;
import model.RequestItem;

public class GetStatusOfPurchaseRequestInformationDAO {

  /**
   * Lấy danh sách yêu cầu mua hàng với phân trang và lọc
   */
  public List<Request> getAllPurchaseRequests(int index, String startDateStr, String endDateStr, String statusFilter, String requestIdFilter) {
      List<Request> allRequests = new ArrayList<>();
      SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

      try {
          // BƯỚC 1: Lấy danh sách request_id với phân trang và lọc
          StringBuilder sqlIds = new StringBuilder(
                  "SELECT DISTINCT r.id "
                  + "FROM request r "
                  + "WHERE 1=1 "
          );

          List<Object> params = new ArrayList<>();

          // Thêm các điều kiện filter vào SQL
          if (startDateStr != null && !startDateStr.isEmpty()) {
              sqlIds.append("AND r.day_request >= ? ");
              params.add(sdf.parse(startDateStr));
          }
          if (endDateStr != null && !endDateStr.isEmpty()) {
              sqlIds.append("AND r.day_request <= ? ");
              params.add(sdf.parse(endDateStr));
          }

          // Xử lý đặc biệt cho status filter "approved" (bao gồm nhiều trạng thái)
          if (statusFilter != null && !statusFilter.isEmpty()) {
              if ("approved".equals(statusFilter)) {
                  // Lọc tất cả status được coi là "Đã duyệt"
                  sqlIds.append("AND r.status IN ('approved', 'quoted', 'pending re-quote') ");
              } else {
                  // Các status khác vẫn lọc bình thường
                  sqlIds.append("AND r.status = ? ");
                  params.add(statusFilter);
              }
          }

          if (requestIdFilter != null && !requestIdFilter.isEmpty()) {
              sqlIds.append("AND r.id LIKE ? ");
              params.add("%" + requestIdFilter.toUpperCase() + "%");
          }

          // Thêm phân trang: 10 records per page
          sqlIds.append("ORDER BY r.id LIMIT ? OFFSET ?");
          params.add(10); // LIMIT 10 requests
          params.add((index - 1) * 10); // OFFSET

          // Debug logging
          System.out.println("=== STEP 1: Get Request IDs ===");
          System.out.println("SQL: " + sqlIds.toString());
          System.out.println("Params: " + params);

          // Thực thi query để lấy danh sách request IDs
          List<String> requestIds = new ArrayList<>();
          try (Connection con = Context.getJDBCConnection(); 
               PreparedStatement stmt = con.prepareStatement(sqlIds.toString())) {

              for (int i = 0; i < params.size(); i++) {
                  stmt.setObject(i + 1, params.get(i));
              }

              try (ResultSet rs = stmt.executeQuery()) {
                  while (rs.next()) {
                      requestIds.add(rs.getString("id"));
                  }
              }
          }

          System.out.println("Found " + requestIds.size() + " request IDs: " + requestIds);

          if (requestIds.isEmpty()) {
              return allRequests; // Trả về list rỗng nếu không tìm thấy
          }

          // BƯỚC 2: Lấy chi tiết đầy đủ cho các request_id đã lọc
          StringBuilder sqlDetails = new StringBuilder(
                  "SELECT r.id AS request_id, r.fullname, r.role, r.day_request, r.status, r.reason, "
                  + "ri.id AS item_id, ri.product_name, ri.product_code, ri.unit, ri.quantity, ri.note "
                  + "FROM request r "
                  + "LEFT JOIN request_items ri ON r.id = ri.request_id "
                  + "WHERE r.id IN ("
          );

          // Tạo placeholders cho IN clause
          for (int i = 0; i < requestIds.size(); i++) {
              if (i > 0) {
                  sqlDetails.append(", ");
              }
              sqlDetails.append("?");
          }
          sqlDetails.append(") ORDER BY r.id, ri.id");

          System.out.println("=== STEP 2: Get Request Details ===");
          System.out.println("SQL: " + sqlDetails.toString());

          // Thực thi query để lấy chi tiết requests và items
          try (Connection con = Context.getJDBCConnection(); 
               PreparedStatement stmt = con.prepareStatement(sqlDetails.toString())) {

              // Set parameters cho IN clause
              for (int i = 0; i < requestIds.size(); i++) {
                  stmt.setString(i + 1, requestIds.get(i));
              }

              try (ResultSet rs = stmt.executeQuery()) {
                  Request currentRequest = null;

                  while (rs.next()) {
                      String requestId = rs.getString("request_id");

                      // Tạo request object mới khi gặp request_id khác
                      if (currentRequest == null || !currentRequest.getId().equals(requestId)) {
                          currentRequest = new Request();
                          currentRequest.setId(requestId);
                          currentRequest.setFullname(rs.getString("fullname"));
                          currentRequest.setRole(rs.getString("role"));
                          currentRequest.setDay_request(rs.getDate("day_request"));
                          currentRequest.setStatus(rs.getString("status"));
                          currentRequest.setReason(rs.getString("reason"));
                          currentRequest.setItems(new ArrayList<>());
                          allRequests.add(currentRequest);
                      }

                      // Thêm item vào request hiện tại (nếu có)
                      if (rs.getObject("item_id") != null) {
                          RequestItem item = new RequestItem();
                          item.setId(rs.getInt("item_id"));
                          item.setRequestId(requestId);
                          item.setProductName(rs.getString("product_name"));
                          item.setProductCode(rs.getString("product_code"));
                          item.setUnit(rs.getString("unit"));
                          item.setQuantity(rs.getDouble("quantity"));
                          item.setNote(rs.getString("note") != null ? rs.getString("note") : "");
                          currentRequest.getItems().add(item);
                      }
                  }
              }
          }

          System.out.println("Final result: " + allRequests.size() + " requests");
          System.out.println("=== END DAO ===");

      } catch (SQLException | ParseException e) {
          System.err.println("Error in getAllPurchaseRequests: " + e.getMessage());
          e.printStackTrace();
      }

      return allRequests;
  }

  /**
   * Đếm tổng số yêu cầu sau khi áp dụng filter (để tính pagination)
   */
  public int getTotalFilteredRequests(String startDateStr, String endDateStr, String statusFilter, String requestIdFilter) {
      StringBuilder sql = new StringBuilder("SELECT COUNT(DISTINCT r.id) FROM request r WHERE 1=1 ");
      List<Object> params = new ArrayList<>();
      SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

      try {
          // Áp dụng cùng logic filter như method getAllPurchaseRequests
          if (startDateStr != null && !startDateStr.isEmpty()) {
              sql.append("AND r.day_request >= ? ");
              params.add(sdf.parse(startDateStr));
          }
          if (endDateStr != null && !endDateStr.isEmpty()) {
              sql.append("AND r.day_request <= ? ");
              params.add(sdf.parse(endDateStr));
          }

          // Xử lý đặc biệt cho status filter "approved"
          if (statusFilter != null && !statusFilter.isEmpty()) {
              if ("approved".equals(statusFilter)) {
                  // Lọc tất cả status được coi là "Đã duyệt"
                  sql.append("AND r.status IN ('approved', 'quoted', 'pending re-quote') ");
              } else {
                  // Các status khác vẫn lọc bình thường
                  sql.append("AND r.status = ? ");
                  params.add(statusFilter);
              }
          }

          if (requestIdFilter != null && !requestIdFilter.isEmpty()) {
              sql.append("AND r.id LIKE ? ");
              params.add("%" + requestIdFilter.toUpperCase() + "%");
          }

          try (Connection con = Context.getJDBCConnection(); 
               PreparedStatement stmt = con.prepareStatement(sql.toString())) {
              for (int i = 0; i < params.size(); i++) {
                  stmt.setObject(i + 1, params.get(i));
              }
              try (ResultSet rs = stmt.executeQuery()) {
                  if (rs.next()) {
                      return rs.getInt(1);
                  }
              }
          }
      } catch (SQLException | ParseException e) {
          e.printStackTrace();
      }
      return 0;
  }

  /**
   * Cập nhật trạng thái yêu cầu thành "approved"
   */
  public boolean updateApprovedStatus(String requestId) {
      if (requestId == null || requestId.trim().isEmpty()) {
          return false;
      }

      String sql = "UPDATE request SET status = ? WHERE id = ?";
      try (Connection con = Context.getJDBCConnection(); 
           PreparedStatement stmt = con.prepareStatement(sql)) {
          con.setAutoCommit(false);
          stmt.setString(1, "approved");
          stmt.setString(2, requestId);
          int rowsAffected = stmt.executeUpdate();
          con.commit();
          return rowsAffected > 0;
      } catch (SQLException e) {
          e.printStackTrace();
          return false;
      }
  }

  /**
   * Cập nhật trạng thái yêu cầu thành "rejected"
   */
  public boolean updateRejectedStatus(String requestId) {
      if (requestId == null || requestId.trim().isEmpty()) {
          return false;
      }

      String sql = "UPDATE request SET status = ? WHERE id = ?";
      try (Connection con = Context.getJDBCConnection(); 
           PreparedStatement stmt = con.prepareStatement(sql)) {
          con.setAutoCommit(false);
          stmt.setString(1, "rejected");
          stmt.setString(2, requestId);
          int rowsAffected = stmt.executeUpdate();
          con.commit();
          return rowsAffected > 0;
      } catch (SQLException e) {
          e.printStackTrace();
          return false;
      }
  }
}