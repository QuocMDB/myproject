/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import DBContext.Context;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Supplier;
import java.sql.Date;

/**
 *
 * @author Fpt06
 */
public class SupplierDAO {

    private Connection conn = null;
    private PreparedStatement ps = null;
    private ResultSet rs = null;

    public Supplier getSupplierByID(int id) {
        String sql = "select * from swp.supplier where id = " + id;
        try {
            conn = new Context().getJDBCConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            if (rs.next()) {
                Supplier s = new Supplier();
                s.setSupplierID(rs.getInt("id"));
                s.setActiveFlag(rs.getInt("active_flag"));
                s.setAddress(rs.getString("address"));
                s.setCreateDate(rs.getDate("create_date"));
                s.setEmail(rs.getString("email"));
                s.setName(rs.getString("name"));
                s.setNote(rs.getString("note"));
                s.setPhone(rs.getString("phone"));
                return s;
            }
        } catch (SQLException e) {
        }
        return null;
    }

    public List<Supplier> getLishSupplier() {
        String sql = "select * from supplier where active_flag = 1";
        List<Supplier> list = new ArrayList<>();
        try {
            conn = new Context().getJDBCConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                Supplier s = new Supplier();
                s.setSupplierID(rs.getInt("id"));
                s.setActiveFlag(rs.getInt("active_flag"));
                s.setAddress(rs.getString("address"));
                s.setCreateDate(rs.getDate("create_date"));
                s.setEmail(rs.getString("email"));
                s.setName(rs.getString("name"));
                s.setNote(rs.getString("note"));
                s.setPhone(rs.getString("phone"));
                list.add(s);
            }
        } catch (SQLException e) {
        }
        return list;
    }

    public List<Supplier> searchLishSupplierByName(String name) {
        List<Supplier> list = new ArrayList<>();
        String sql = "select * from supplier where name like '%" + name + "%' and active_flag = 1";
        try {
            conn = new Context().getJDBCConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                Supplier s = new Supplier();
                s.setSupplierID(rs.getInt("id"));
                s.setActiveFlag(rs.getInt("active_flag"));
                s.setAddress(rs.getString("address"));
                s.setCreateDate(rs.getDate("create_date"));
                s.setEmail(rs.getString("email"));
                s.setName(rs.getString("name"));
                s.setNote(rs.getString("note"));
                s.setPhone(rs.getString("phone"));
                list.add(s);
            }
        } catch (SQLException e) {
        }
        return list;
    }

    public void AddNewSupplier(String name, String phone, String email, String address, String note) {
        String sql = "INSERT INTO `supplier` (\n"
                + "    `name`,\n"
                + "    `phone`,\n"
                + "    `email`,\n"
                + "    `address`,\n"
                + "    `note`,\n"
                + "    `active_flag`,\n"
                + "    `create_date`\n"
                + ") VALUES (?, ?, ?, ?, ?, 1, CURRENT_TIMESTAMP);";
        try {
            conn = new Context().getJDBCConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, name);
            ps.setString(2, phone);
            ps.setString(3, email);
            ps.setString(4, address);
            ps.setString(5, note);

            ps.executeUpdate();
        } catch (SQLException e) {
        }
    }

    public void updateSupplier(String id, String name, String phone, String email, String address, String note) {
        String sql = "UPDATE `supplier`\n"
                + "SET\n"
                + "`name` = ?,\n"
                + "`phone` = ?,\n"
                + "`email` = ?,\n"
                + "`address` = ?,\n"
                + "`note` = ?\n"
                + "WHERE `id` = " + id;
        try {
            conn = new Context().getJDBCConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, name);
            ps.setString(2, phone);
            ps.setString(3, email);
            ps.setString(4, address);
            ps.setString(5, note);
            ps.executeUpdate();
        } catch (SQLException e) {
        }
    }

    public void deleteSupplier(String id) {
        String sql = "UPDATE `supplier`\n"
                + "SET `active_flag` = 0\n"
                + "WHERE `id` = " + id;

        try {
            conn = new Context().getJDBCConnection();
            ps = conn.prepareStatement(sql);
            ps.executeUpdate();
        } catch (SQLException e) {
        }
    }

    public void activeSupplier(String id) {
        String sql = "UPDATE `supplier`\n"
                + "SET `active_flag` = 1\n"
                + "WHERE `id` = " + id;

        try {
            conn = new Context().getJDBCConnection();
            ps = conn.prepareStatement(sql);
            ps.executeUpdate();
        } catch (SQLException e) {
        }
    }

    public List<Supplier> getSuppliersByPage(int pageIndex, int pageSize) {
        List<Supplier> list = new ArrayList<>();
        String sql = "SELECT * FROM supplier ORDER BY id LIMIT ?, ?";
        try {
            conn = new Context().getJDBCConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, (pageIndex - 1) * pageSize);
            ps.setInt(2, pageSize);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Supplier(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("phone"),
                        rs.getString("email"),
                        rs.getString("address"),
                        rs.getString("note"),
                        rs.getInt("active_flag"),
                        rs.getDate("create_date")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countTotalSuppliers() {
        String sql = "SELECT COUNT(*) FROM supplier";
        try {
            conn = new Context().getJDBCConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
    //

    public List<Supplier> getSuppliersByPageFilter(int pageIndex, int pageSize, String status, String name) {
        List<Supplier> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM supplier");

        List<String> conditions = new ArrayList<>();

        if (!"all".equalsIgnoreCase(status)) {
            conditions.add("active_flag = " + status);
        }

        if (name != null && !name.trim().isEmpty()) {
            conditions.add("name LIKE '%" + name.trim() + "%'");
        }

        if (!conditions.isEmpty()) {
            sql.append(" WHERE ");
            sql.append(String.join(" AND ", conditions));
        }

        sql.append(" ORDER BY id LIMIT ?, ?");

        try {
            conn = new Context().getJDBCConnection();
            ps = conn.prepareStatement(sql.toString());
            ps.setInt(1, (pageIndex - 1) * pageSize);
            ps.setInt(2, pageSize);
            System.out.println(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Supplier(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("phone"),
                        rs.getString("email"),
                        rs.getString("address"),
                        rs.getString("note"),
                        rs.getInt("active_flag"),
                        rs.getDate("create_date")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countTotalSuppliersFilter(String status, String name) {
        String filter = "";
        if (status.equalsIgnoreCase("all")) {
            if (name != null && name.length() > 0) {
                filter += " where name like '%" + name + "%' ";
            }
        } else {
            filter = "where active_flag = " + status + "  ";
            if (name != null && name.length() > 0) {
                filter += " and name like'%" + name + "%' ";
            }
        }
        String sql = "SELECT COUNT(*) FROM supplier " + filter;
        System.out.println(sql);
        try {
            conn = new Context().getJDBCConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public Supplier getSupplierByName(String name) {
        String sql = "select * from swp.supplier where name = \"" + name + "\"";
        try {
            conn = new Context().getJDBCConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            if (rs.next()) {
                Supplier s = new Supplier();
                s.setSupplierID(rs.getInt("id"));
                s.setActiveFlag(rs.getInt("active_flag"));
                s.setAddress(rs.getString("address"));
                s.setCreateDate(rs.getDate("create_date"));
                s.setEmail(rs.getString("email"));
                s.setName(rs.getString("name"));
                s.setNote(rs.getString("note"));
                s.setPhone(rs.getString("phone"));
                return s;
            }
        } catch (SQLException e) {
        }
        return null;
    }

    public static void main(String[] args) {
        SupplierDAO sd = new SupplierDAO();
        Supplier s = sd.getSupplierByName("Công ty TNHH Bao Bì Bình Minh");
        System.out.println(s.getSupplierID());
        // limit (offset),(limit)
//        List<Supplier> l = sd.getSuppliersByPageFilter(2, 10, "all", "");
//        System.out.println(Math.ceil((double)l.size()/5));
    }

}