/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Unit;
import DBContext.Context;

public class UnitDAO {

    private Connection connection;

    public UnitDAO() {
        try {
            connection = new Context().getJDBCConnection();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Method lấy tất cả units (đã có)
    public List<Unit> getAllUnits() {
        List<Unit> units = new ArrayList<>();
        try {
            String sql = "SELECT * FROM unit ORDER BY name";
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Unit unit = new Unit();
                unit.setId(rs.getInt("id"));
                unit.setName(rs.getString("name"));
                unit.setSymbol(rs.getString("symbol"));
                units.add(unit);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return units;
    }

    // *** THÊM METHOD NÀY: Lấy symbol theo ID ***
    public String getUnitSymbolById(int unitId) {
        try {
            String sql = "SELECT symbol FROM unit WHERE id = ?";
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, unitId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getString("symbol");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "";
    }

// Sửa method getUnitById() trong UnitDAO.java
    public Unit getUnitById(int id) {
        try {
            String sql = "SELECT * FROM unit WHERE id = ?";
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Unit unit = new Unit();
                unit.setId(rs.getInt("id"));
                unit.setName(rs.getString("name"));
                unit.setSymbol(rs.getString("symbol")); // THÊM DÒNG NÀY
                return unit;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Thêm đơn vị tính mới
    public boolean addUnit(Unit unit) {
        try {
            String sql = "INSERT INTO unit (name) VALUES (?)";
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, unit.getName());

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Cập nhật đơn vị tính
    public boolean updateUnit(Unit unit) {
        try {
            String sql = "UPDATE unit SET name = ? WHERE id = ?";
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, unit.getName());
            ps.setInt(2, unit.getId());

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Xóa đơn vị tính
    public boolean deleteUnit(int id) {
        try {
            String sql = "DELETE FROM unit WHERE id = ?";
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, id);

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Kiểm tra xem đơn vị tính có đang được sử dụng không
    public boolean isUnitInUse(int id) {
        try {
            // Kiểm tra xem đơn vị tính có được sử dụng trong bảng product không
            String sql = "SELECT COUNT(*) FROM product WHERE unit_id = ?";
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, id);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            // Nếu bảng product chưa tồn tại, bỏ qua lỗi
            System.out.println("Bảng product chưa tồn tại hoặc không có liên kết với unit");
        }
        return false;
    }

    public boolean isValidUnitId(int unitId) {
        try {
            String sql = "SELECT COUNT(*) FROM unit WHERE id = ?";
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, unitId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}