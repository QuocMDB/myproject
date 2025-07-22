/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import DBContext.Context;
import java.sql.*;

public class RequestItemsDAO {

    /**
     * Thêm danh sách items (sản phẩm) vào request đã tạo
     */
    public void addItemsIntoDB(String request_id, String[] product_name, String[] product_code,
                           String[] unit, int[] quantity, String[] note) {
        
        // SQL insert một item vào bảng request_items
        String sql = "INSERT INTO request_items (request_id, product_name, product_code, unit, quantity, note) VALUES (?, ?, ?, ?, ?, ?)";
        
        try {
            Connection con = Context.getJDBCConnection();
            PreparedStatement stmt = con.prepareStatement(sql);

            // Lặp qua từng item trong arrays (sử dụng product_code.length làm chuẩn)
            for (int i = 0; i < product_code.length; i++) {
                
                // === DEBUG: In thông tin item sẽ được insert ===
                System.out.println(">>> Inserting item " + (i + 1));
                System.out.println("request_id: " + request_id);
                System.out.println("product_name: " + product_name[i]);
                System.out.println("product_code: " + product_code[i]);
                System.out.println("unit: " + unit[i]);
                System.out.println("quantity: " + quantity[i]);
                System.out.println("note: " + note[i]);

                // Gán giá trị vào prepared statement
                stmt.setString(1, request_id);           // FK tới bảng request
                stmt.setString(2, product_name[i]);      // Tên sản phẩm
                stmt.setString(3, product_code[i]);      // Mã sản phẩm (unique identifier)
                stmt.setString(4, unit[i]);              // Đơn vị tính
                stmt.setInt(5, quantity[i]);             // Số lượng yêu cầu
                stmt.setString(6, note[i]);              // Ghi chú riêng cho item này

                // Thực hiện insert item này
                int rowsAffected = stmt.executeUpdate();
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}