/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import DBContext.Context;
import java.sql.*;
import java.util.Date;

public class RequestInformationDAO {

    public String addRequestInformationIntoDB(String fullname, String role, Date day_request,
            String status, String reason) {

        String insertSql = "INSERT INTO request (id, fullname, role, day_request, status, reason) VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection con = Context.getJDBCConnection(); PreparedStatement insertStmt = con.prepareStatement(insertSql)) {

            // Tạo ID trước
            String nextId = getNextRequestId();
            System.out.println("Generated ID: " + nextId);

            insertStmt.setString(1, nextId);
            insertStmt.setString(2, fullname);
            insertStmt.setString(3, role);
            insertStmt.setDate(4, new java.sql.Date(day_request.getTime()));
            insertStmt.setString(5, status);
            insertStmt.setString(6, reason);

            int result = insertStmt.executeUpdate();
            System.out.println("Request insert result: " + result);

            if (result > 0) {
                return nextId;
            }

        } catch (SQLException e) {
            System.err.println("❌ SQL Error in addRequestInformationIntoDB: " + e.getMessage());
            e.printStackTrace();
        }

        return null;
    }

    /**
     * Tự động tạo ID tiếp theo cho request theo format: NK{số}-{số thứ tự}
     */
    public String getNextRequestId() {
        // Query lấy ID cuối cùng có format NK{số}-{3 chữ số}
        String sql = "SELECT id FROM request WHERE id LIKE 'NK%-___' ORDER BY id DESC LIMIT 1";

        try (Connection con = Context.getJDBCConnection(); PreparedStatement stmt = con.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {

            if (!rs.next()) {
                // Nếu chưa có record nào, bắt đầu từ NK1-000
                return "NK1-000";
            } else {
                // Parse ID cuối cùng để tạo ID tiếp theo
                String lastId = rs.getString("id");
                String prefix = lastId.split("-")[0]; // Ví dụ: "NK1"
                int num = Integer.parseInt(lastId.split("-")[1]); // Ví dụ: 003

                if (num < 999) {
                    // Nếu chưa đến 999, tăng số thứ tự
                    num++;
                    return prefix + "-" + String.format("%03d", num); // NK1-004
                } else {
                    // Nếu đã đến 999, chuyển sang prefix tiếp theo
                    int prefixNum = Integer.parseInt(prefix.substring(2)) + 1; // NK1 -> 1 -> 2
                    return "NK" + prefixNum + "-000"; // NK2-000
                }
            }

        } catch (Exception e) {
            e.printStackTrace(); // Nên có error handling
        }
        return null;
    }
                                                                        
    public boolean addItemsIntoDB(String request_id, String[] productNameArr,
            String[] productCodeArr, String[] unitArr, int[] quantityArr,
            String[] noteArr) {

        String sql = "INSERT INTO request_items (request_id, product_name, product_code, unit, quantity, note) VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection con = Context.getJDBCConnection(); PreparedStatement stmt = con.prepareStatement(sql)) {

            System.out.println("=== SAVING REQUEST ITEMS ===");
            System.out.println("Request ID: " + request_id);
            System.out.println("Number of items: " + productNameArr.length);

            for (int i = 0; i < productNameArr.length; i++) {
                // Kiểm tra dữ liệu trước khi insert
                if (productNameArr[i] == null || productNameArr[i].trim().isEmpty()) {
                    System.out.println("Skipping empty product at index " + i);
                    continue;
                }

                stmt.setString(1, request_id);
                stmt.setString(2, productNameArr[i]);
                stmt.setString(3, productCodeArr[i]);
                stmt.setString(4, unitArr[i]);
                stmt.setInt(5, quantityArr[i]); // ✅ Dùng setDouble thay vì setInt
                stmt.setString(6, noteArr[i]);

                System.out.println("Inserting item " + (i + 1) + ": " + productNameArr[i]
                        + " - Code: " + productCodeArr[i] + " - Qty: " + quantityArr[i]);

                int result = stmt.executeUpdate();
                System.out.println("Insert result: " + result);
            }

            System.out.println("✅ All items saved successfully!");
            return true;

        } catch (SQLException e) {
            System.err.println("❌ SQL Error: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

}
