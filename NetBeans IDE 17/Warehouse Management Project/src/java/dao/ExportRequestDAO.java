package dao;

import DBContext.Context;
import java.sql.*;
import java.util.Date;

public class ExportRequestDAO {

  /**
   * Thêm export request vào database
   * @param user_id ID người dùng
   * @param role Vai trò
   * @param day_request Ngày yêu cầu
   * @param status Trạng thái
   * @param reason Lý do
   * @param department Bộ phận
   * @param recipient_name Tên người nhận
   * @param recipient_phone SĐT người nhận
   * @param recipient_email Email người nhận
   * @return ID của export request đã tạo
   */
  public String addExportRequestIntoDB(int user_id, String role, Date day_request,
          String status, String reason, String department, String recipient_name,
          String recipient_phone, String recipient_email) {
      
      // Tạo ID mới trong method này để đảm bảo tính nhất quán
      String generatedId = generateNextExportRequestId();

      if (generatedId == null) {
          System.out.println("Không thể tạo ID cho export request");
          return null;
      }

      String insertSql = "INSERT INTO export_request (id, user_id, role, day_request, status, reason, department, recipient_name, recipient_phone, recipient_email) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

      try (Connection con = Context.getJDBCConnection(); PreparedStatement insertStmt = con.prepareStatement(insertSql)) {

          insertStmt.setString(1, generatedId);
          insertStmt.setInt(2, user_id);
          insertStmt.setString(3, role);
          insertStmt.setDate(4, new java.sql.Date(day_request.getTime()));
          insertStmt.setString(5, status);
          insertStmt.setString(6, reason);
          insertStmt.setString(7, department);
          insertStmt.setString(8, recipient_name);
          insertStmt.setString(9, recipient_phone);
          insertStmt.setString(10, recipient_email);

          int rowsAffected = insertStmt.executeUpdate();

          if (rowsAffected > 0) {
              System.out.println("Đã thêm export request thành công với ID: " + generatedId);
              return generatedId;
          } else {
              System.out.println("Không thể thêm export request");
              return null;
          }

      } catch (SQLException e) {
          System.out.println("Lỗi SQL khi thêm export request: ");
          e.printStackTrace();
          return null;
      }
  }

  /**
   * Lấy ID tiếp theo để hiển thị trên form (chỉ để preview)
   * @return ID preview
   */
  public String getNextExportRequestId() {
      return generateNextExportRequestId();
  }

  /**
   * Tạo ID export request tiếp theo
   * @return ID mới được tạo
   */
  private String generateNextExportRequestId() {
      String sql = "SELECT id FROM export_request WHERE id LIKE 'XK%-___' ORDER BY id DESC LIMIT 1";
      
      try (Connection con = Context.getJDBCConnection(); 
           PreparedStatement stmt = con.prepareStatement(sql); 
           ResultSet rs = stmt.executeQuery()) {

          if (!rs.next()) {
              // Không có record nào, bắt đầu từ XK1-001
              return "XK1-001";
          } else {
              String lastId = rs.getString("id");
              System.out.println("Last ID found: " + lastId);
              
              try {
                  // Tách prefix và number
                  String[] parts = lastId.split("-");
                  if (parts.length != 2) {
                      System.out.println("Invalid ID format: " + lastId);
                      return "XK1-001";
                  }
                  
                  String prefix = parts[0]; // XK1, XK2, etc.
                  int num = Integer.parseInt(parts[1]); // 001, 002, etc.

                  if (num < 999) {
                      num++;
                      String newId = prefix + "-" + String.format("%03d", num);
                      System.out.println("Generated new ID: " + newId);
                      return newId;
                  } else {
                      // Nếu đã đến 999, chuyển sang prefix tiếp theo
                      int prefixNum = Integer.parseInt(prefix.substring(2)) + 1;
                      String newId = "XK" + prefixNum + "-001";
                      System.out.println("Generated new ID with new prefix: " + newId);
                      return newId;
                  }
              } catch (NumberFormatException e) {
                  System.out.println("Error parsing ID: " + lastId);
                  return "XK1-001";
              }
          }

      } catch (SQLException e) {
          System.out.println("Lỗi khi tạo ID export request: ");
          e.printStackTrace();
          return "XK1-001"; // Fallback ID
      }
  }
  
}