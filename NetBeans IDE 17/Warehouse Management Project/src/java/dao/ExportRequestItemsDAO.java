package dao;

import DBContext.Context;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class ExportRequestItemsDAO {

    public void addExportItemsIntoDB(String export_request_id, String[] product_name,
            String[] product_code, String[] unit, int[] quantity,
            String[] note, String reason_detail) {
        
        String sql = "INSERT INTO export_request_items (export_request_id, product_name, product_code, unit, quantity, note, reason_detail) VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection con = Context.getJDBCConnection(); 
             PreparedStatement stmt = con.prepareStatement(sql)) {

            for (int i = 0; i < product_code.length; i++) {
                // Kiểm tra dữ liệu trước khi insert
                if (product_code[i] != null && !product_code[i].trim().isEmpty()) {
                    stmt.setString(1, export_request_id);
                    stmt.setString(2, product_name[i]);
                    stmt.setString(3, product_code[i]);
                    stmt.setString(4, unit[i]);
                    stmt.setInt(5, quantity[i]);
                    stmt.setString(6, note[i]);
                    stmt.setString(7, reason_detail);
                    
                    int rowsAffected = stmt.executeUpdate();
                    System.out.println("Đã thêm item " + (i+1) + ": " + rowsAffected + " rows affected");
                } else {
                    System.out.println("Bỏ qua item " + (i+1) + " vì product_code rỗng");
                }
            }

        } catch (SQLException e) {
            System.out.println(">>> LỖI SQL khi insert export_request_items: ");
            e.printStackTrace();
        }
    }
}
