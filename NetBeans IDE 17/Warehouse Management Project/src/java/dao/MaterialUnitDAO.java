/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

// DAO for advanced operations on material units (search, paging, duplicate check)

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import DBContext.Context;
import model.MaterialUnit;

public class MaterialUnitDAO {
    //Lấy tất cả các unit từ db
    public List<MaterialUnit> getAllMaterialUnits() {
        List<MaterialUnit> materialUnits = new ArrayList<>();
        
        try (Connection conn = Context.getJDBCConnection();
             Statement statement = conn.createStatement();
             ResultSet resultSet = statement.executeQuery("SELECT * FROM unit ORDER BY id")) {
            
            while (resultSet.next()) {
                MaterialUnit unit = new MaterialUnit();
                unit.setId(resultSet.getInt("id"));
                unit.setName(resultSet.getString("name"));
                unit.setSymbol(resultSet.getString("symbol"));
                unit.setDescription(resultSet.getString("description"));
                unit.setStatus(resultSet.getInt("status"));
                unit.setCanDelete(checkIfUnitCanBeDeleted(unit.getId()));
                materialUnits.add(unit);
            }
            
        } catch (SQLException e) {
            System.err.println("Error in getAllMaterialUnits: " + e.getMessage());
            e.printStackTrace();
        }
        
        return materialUnits;
    }
    //Tìm các unit từ db
    public List<MaterialUnit> searchMaterialUnits(String searchTerm) {
        List<MaterialUnit> units = new ArrayList<>();
        String sql = "SELECT * FROM unit WHERE name LIKE ? OR symbol LIKE ?";
        
        try (Connection conn = Context.getJDBCConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            String searchPattern = "%" + searchTerm + "%";
            pstmt.setString(1, searchPattern);
            pstmt.setString(2, searchPattern);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    MaterialUnit unit = new MaterialUnit();
                    unit.setId(rs.getInt("id"));
                    unit.setName(rs.getString("name"));
                    unit.setSymbol(rs.getString("symbol"));
                    unit.setDescription(rs.getString("description"));
                    unit.setStatus(rs.getInt("status"));
                    unit.setCanDelete(checkIfUnitCanBeDeleted(unit.getId()));
                    units.add(unit);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return units;
    }
    //Lấy các unit dựa vào id
    public MaterialUnit getMaterialUnitById(int id) {
        MaterialUnit unit = null;
        String sql = "SELECT * FROM unit WHERE id = ?";
        
        try (Connection conn = Context.getJDBCConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    unit = new MaterialUnit();
                    unit.setId(rs.getInt("id"));
                    unit.setName(rs.getString("name"));
                    unit.setSymbol(rs.getString("symbol"));
                    unit.setDescription(rs.getString("description"));
                    unit.setStatus(rs.getInt("status"));
                    unit.setCanDelete(checkIfUnitCanBeDeleted(unit.getId()));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return unit;
    }
    //Thêm unit mới
    public boolean addMaterialUnit(MaterialUnit unit) {
        String sql = "INSERT INTO unit (name, symbol, description, status) VALUES (?, ?, ?, ?)";
        try (Connection conn = Context.getJDBCConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, unit.getName());
            pstmt.setString(2, unit.getSymbol());
            pstmt.setString(3, unit.getDescription());
            pstmt.setInt(4, unit.getStatus());
            int affectedRows = pstmt.executeUpdate();
            System.out.println("addMaterialUnit: Added unit, name=" + unit.getName() + ", affectedRows=" + affectedRows);
            return affectedRows > 0;
        } catch (SQLException e) {
            System.err.println("addMaterialUnit: Error - " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    //Update unit có từ trước
    public boolean updateMaterialUnit(MaterialUnit unit) {
        String sql = "UPDATE unit SET name = ?, symbol = ?, description = ?, status = ? WHERE id = ?";
        
        try (Connection conn = Context.getJDBCConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, unit.getName());
            pstmt.setString(2, unit.getSymbol());
            pstmt.setString(3, unit.getDescription());
            pstmt.setInt(4, unit.getStatus());
            pstmt.setInt(5, unit.getId());
            
            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    //Xóa unit 
    public boolean deleteMaterialUnit(int id) {
        String sql = "DELETE FROM unit WHERE id = ?";
        
        try (Connection conn = Context.getJDBCConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, id);
            
            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    //Thay đổi trạng thái của unit
    public boolean updateMaterialUnitStatus(int id, String status) {
        boolean updated = false;
        
        try (Connection conn = Context.getJDBCConnection();
             PreparedStatement preparedStatement = conn.prepareStatement(
                     "UPDATE unit SET active_flag = ? WHERE id = ?")) {
            
            preparedStatement.setBoolean(1, status.equalsIgnoreCase("active"));
            preparedStatement.setInt(2, id);
            
            int rowsAffected = preparedStatement.executeUpdate();
            updated = rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error in updateMaterialUnitStatus: " + e.getMessage());
            e.printStackTrace();
        }
        
        return updated;
    }
    //Lấy unit dựa theo giới hạn phân trang
    public List<MaterialUnit> getMaterialUnitsWithPaging(int offset, int recordsPerPage) {
        List<MaterialUnit> units = new ArrayList<>();
        String query = "SELECT * FROM unit ORDER BY id LIMIT ?, ?";
        
        try (Connection conn = Context.getJDBCConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, offset);
            pstmt.setInt(2, recordsPerPage);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    MaterialUnit unit = new MaterialUnit();
                    unit.setId(rs.getInt("id"));
                    unit.setName(rs.getString("name"));
                    unit.setSymbol(rs.getString("symbol"));
                    unit.setDescription(rs.getString("description"));
                    unit.setStatus(rs.getInt("status"));
                    unit.setCanDelete(checkIfUnitCanBeDeleted(unit.getId()));
                    units.add(unit);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return units;
    }
    //Tìm unit dựa theo giới hạn phân trang 
    public List<MaterialUnit> searchMaterialUnitsWithPaging(String searchTerm, int offset, int recordsPerPage) {
        List<MaterialUnit> units = new ArrayList<>();
        String sql = "SELECT * FROM unit WHERE name LIKE ? OR symbol LIKE ? ORDER BY id LIMIT ?, ?";
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = Context.getJDBCConnection();
            if (conn == null) {
                System.err.println("searchMaterialUnitsWithPaging: Database connection is null");
                return units;
            }
            
            pstmt = conn.prepareStatement(sql);
            String searchPattern = "%" + searchTerm + "%";
            pstmt.setString(1, searchPattern);
            pstmt.setString(2, searchPattern);
            pstmt.setInt(3, offset);
            pstmt.setInt(4, recordsPerPage);
            
            rs = pstmt.executeQuery();
            while (rs.next()) {
                MaterialUnit unit = new MaterialUnit();
                unit.setId(rs.getInt("id"));
                unit.setName(rs.getString("name"));
                unit.setSymbol(rs.getString("symbol"));
                unit.setDescription(rs.getString("description"));
                unit.setStatus(rs.getInt("status"));
                unit.setCanDelete(checkIfUnitCanBeDeleted(unit.getId()));
                units.add(unit);
            }
            System.out.println("searchMaterialUnitsWithPaging: Fetched " + units.size() + " units for searchTerm='" + searchTerm + "', offset=" + offset + ", limit=" + recordsPerPage);
            
        } catch (SQLException e) {
            System.err.println("searchMaterialUnitsWithPaging: Database error - " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                System.err.println("Error closing database resources: " + e.getMessage());
            }
        }
        
        return units;
    }
    
    public int getTotalRecords() {
        int count = 0;
        String query = "SELECT COUNT(*) FROM unit";
        
        try (Connection conn = Context.getJDBCConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }
    
    
    public int getTotalSearchRecords(String searchTerm) {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM unit WHERE name LIKE ? OR symbol LIKE ?";
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = Context.getJDBCConnection();
            if (conn == null) {
                System.err.println("getTotalSearchRecords: Database connection is null");
                return count;
            }
            pstmt = conn.prepareStatement(sql);
            String searchPattern = "%" + searchTerm + "%";
            pstmt.setString(1, searchPattern);
            pstmt.setString(2, searchPattern);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                System.err.println("Error closing database resources: " + e.getMessage());
            }
        }
        return count;
    }

    //Kiểm tra trùng tên hoặc kí hiệu (trừ id hiện tại)
    public boolean isDuplicateNameOrSymbol(String name, String symbol, Integer excludeId) {
        String sql = "SELECT COUNT(*) FROM unit WHERE (name = ? OR symbol = ?)" + (excludeId != null ? " AND id <> ?" : "");
        try (Connection conn = Context.getJDBCConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, name);
            pstmt.setString(2, symbol);
            if (excludeId != null) {
                pstmt.setInt(3, excludeId);
            }
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    //Kiểm tra xem unit có thể xóa được không (không được sử dụng bởi product nào)
    public boolean checkIfUnitCanBeDeleted(int unitId) {
        String sql = "SELECT COUNT(*) FROM product_info WHERE unit_id = ?";
        try (Connection conn = Context.getJDBCConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, unitId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) == 0; // Trả về true nếu không có product nào sử dụng unit này
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    //Kích hoạt unit
    public boolean activateMaterialUnit(int id) {
        String sql = "UPDATE unit SET status = 1 WHERE id = ?";
        try (Connection conn = Context.getJDBCConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    //Ngừng hoạt động unit
    public boolean deactivateMaterialUnit(int id) {
        String sql = "UPDATE unit SET status = 0 WHERE id = ?";
        try (Connection conn = Context.getJDBCConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}