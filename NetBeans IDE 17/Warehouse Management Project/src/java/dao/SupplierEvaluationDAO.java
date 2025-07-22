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
import java.util.Collection;
import java.util.stream.Collectors;
import model.SupplierEvaluation;
import model.Users;

/**
 *
 * @author Fpt06
 */
public class SupplierEvaluationDAO {

    private Connection conn = null;
    private PreparedStatement ps = null;
    private ResultSet rs = null;

    public List<Supplier> staticRated(String sort) {
        List<Supplier> list = new ArrayList<>();
        String sql = "select supplier_evaluation.supplier_id,avg(supplier_evaluation.avg_rate) as avgrate \n"
                + "from supplier_evaluation group by supplier_id order by avg(supplier_evaluation.avg_rate) " + sort;
        try {
            System.out.println(sql);
            conn = new Context().getJDBCConnection();
            ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            SupplierDAO sd = new SupplierDAO();
            UserDAO ud = new UserDAO();
            while (rs.next()) {
                Supplier s = sd.getSupplierByID(rs.getInt("supplier_id"));
                list.add(s);
            }
        } catch (SQLException e) {
        }
        return list;
    }

    public List<Supplier> staticMarketPrice(String sort) {
        List<Supplier> list = new ArrayList<>();
        String sql = "select supplier_evaluation.supplier_id,avg(supplier_evaluation.market_price_comparison) as avgrate \n"
                + "from supplier_evaluation group by supplier_id order by avg(supplier_evaluation.market_price_comparison) " + sort;
        try {
            conn = new Context().getJDBCConnection();
            ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            SupplierDAO sd = new SupplierDAO();
            UserDAO ud = new UserDAO();
            while (rs.next()) {
                Supplier s = sd.getSupplierByID(rs.getInt("supplier_id"));
                list.add(s);
            }
        } catch (SQLException e) {
        }
        return list;
    }

    public List<Supplier> staticExpectedDelivery(String sort) {
        List<Supplier> list = new ArrayList<>();
        String sql = "select supplier_evaluation.supplier_id,avg(supplier_evaluation.expected_delivery_time) as avgrate \n"
                + "from supplier_evaluation group by supplier_id order by avg(supplier_evaluation.expected_delivery_time) " + sort;
        try {
            System.out.println(sql);
            conn = new Context().getJDBCConnection();
            ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            SupplierDAO sd = new SupplierDAO();
            UserDAO ud = new UserDAO();
            while (rs.next()) {
                Supplier s = sd.getSupplierByID(rs.getInt("supplier_id"));
                list.add(s);
            }
        } catch (SQLException e) {
        }
        return list;
    }

    public List<SupplierEvaluation> sortDescendingByStar(int id) {
        List<SupplierEvaluation> list = new ArrayList<>();
        String sql = "SELECT * FROM supplier_evaluation where supplier_id = " + id + " order by avg_rate desc";
        try {
            conn = new Context().getJDBCConnection();
            ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            SupplierDAO sd = new SupplierDAO();
            UserDAO ud = new UserDAO();
            while (rs.next()) {
                SupplierEvaluation se = new SupplierEvaluation();
                se.setAvgRate(rs.getFloat("avg_rate"));
                se.setComment(rs.getString("comment"));
                se.setCommentTime(rs.getDate("comment_time"));
                se.setEditCount(rs.getInt("edit_count"));
                se.setExpectedDeliveryTime(rs.getInt("expected_delivery_time"));
                se.setMarketPriceComparison(rs.getInt("market_price_comparison"));
                se.setProductQuality(rs.getInt("product_quality"));
                se.setServiceQuality(rs.getInt("service_quality"));
                se.setSupplierEvaluationID(rs.getInt("id"));

                Supplier s = sd.getSupplierByID(rs.getInt("supplier_id"));
                Users u = ud.getUserById(rs.getInt("user_id"));
                se.setSupplierID(s);
                se.setTransparencyReputation(rs.getInt("transparency_reputation"));
                se.setUserID(u);

                list.add(se);
            }
        } catch (SQLException e) {
        }
        return list;
    }

    public List<SupplierEvaluation> sortDescendingByDate(int id) {
        List<SupplierEvaluation> list = new ArrayList<>();
        String sql = "SELECT * FROM supplier_evaluation where supplier_id = " + id + " order by comment_time desc";
        try {
            conn = new Context().getJDBCConnection();
            ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            SupplierDAO sd = new SupplierDAO();
            UserDAO ud = new UserDAO();
            while (rs.next()) {
                SupplierEvaluation se = new SupplierEvaluation();
                se.setAvgRate(rs.getFloat("avg_rate"));
                se.setComment(rs.getString("comment"));
                se.setCommentTime(rs.getDate("comment_time"));
                se.setEditCount(rs.getInt("edit_count"));
                se.setExpectedDeliveryTime(rs.getInt("expected_delivery_time"));
                se.setMarketPriceComparison(rs.getInt("market_price_comparison"));
                se.setProductQuality(rs.getInt("product_quality"));
                se.setServiceQuality(rs.getInt("service_quality"));
                se.setSupplierEvaluationID(rs.getInt("id"));

                Supplier s = sd.getSupplierByID(rs.getInt("supplier_id"));
                Users u = ud.getUserById(rs.getInt("user_id"));
                se.setSupplierID(s);
                se.setTransparencyReputation(rs.getInt("transparency_reputation"));
                se.setUserID(u);

                list.add(se);
            }
        } catch (SQLException e) {
        }
        return list;
    }

    public void UpdateSupplierEvaluation(int dt, int mpc, int tr, int sq, String comment, int seid) {
        String sql = "UPDATE `supplier_evaluation`\n"
                + "SET\n"
                + "`expected_delivery_time` = ?,\n"
                + "`market_price_comparison` = ?,\n"
                + "`transparency_reputation` = ?,\n"
                + "`service_quality` = ?,\n"
                + "`comment` = ?,\n"
                + "`avg_rate` = ?,\n"
                + "`edit_count` = ?\n"
                + "WHERE `id` = ?";
        try {
            conn = new Context().getJDBCConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, dt);
            ps.setInt(2, mpc);
            ps.setInt(3, tr);
            ps.setInt(4, sq);
            ps.setString(5, comment);
            float avg_rate = (dt + mpc + tr + sq) / 4.0f;
            ps.setFloat(6, avg_rate);
            ps.setInt(7, 1);
            ps.setInt(8, seid);
            ps.executeUpdate();
        } catch (SQLException e) {
        }
    }

    public void evaluation(int sid, int uid, int dt, int pq, int mpc, int tr, int sq, String comment) {
        String sql = "INSERT INTO `supplier_evaluation`\n"
                + "(\n"
                + "`supplier_id`,\n"
                + "`user_id`,\n"
                + "`expected_delivery_time`,\n"
                + "`product_quality`,\n"
                + "`market_price_comparison`,\n"
                + "`transparency_reputation`,\n"
                + "`service_quality`,\n"
                + "`comment`,\n"
                + "`avg_rate`\n"
                + ")\n"
                + "VALUES\n"
                + "(?,?,?,?,?,?,?,?,?);";
        try {
            conn = new Context().getJDBCConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, sid);
            ps.setInt(2, uid);
            ps.setInt(3, dt);
            ps.setInt(4, pq);
            ps.setInt(5, mpc);
            ps.setInt(6, tr);
            ps.setInt(7, sq);
            ps.setString(8, comment);
            float avg_rate = (dt + pq + mpc + tr + sq) / 4.0f;
            ps.setFloat(9, avg_rate);
            ps.executeUpdate();
        } catch (SQLException e) {
        }
    }

    public List<SupplierEvaluation> getSupplierEvaluationByID(int id) {
        List<SupplierEvaluation> list = new ArrayList<>();
        String sql = "SELECT * FROM supplier_evaluation where supplier_id = " + id;
        try {
            conn = new Context().getJDBCConnection();
            ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            SupplierDAO sd = new SupplierDAO();
            UserDAO ud = new UserDAO();
            while (rs.next()) {
                SupplierEvaluation se = new SupplierEvaluation();
                se.setAvgRate(rs.getFloat("avg_rate"));
                se.setComment(rs.getString("comment"));
                se.setCommentTime(rs.getDate("comment_time"));
                se.setEditCount(rs.getInt("edit_count"));
                se.setExpectedDeliveryTime(rs.getInt("expected_delivery_time"));
                se.setMarketPriceComparison(rs.getInt("market_price_comparison"));
                se.setProductQuality(rs.getInt("product_quality"));
                se.setServiceQuality(rs.getInt("service_quality"));
                se.setSupplierEvaluationID(rs.getInt("id"));

                Supplier s = sd.getSupplierByID(rs.getInt("supplier_id"));
                Users u = ud.getUserById(rs.getInt("user_id"));
                se.setSupplierID(s);
                se.setTransparencyReputation(rs.getInt("transparency_reputation"));
                se.setUserID(u);

                list.add(se);
            }
        } catch (SQLException e) {
        }
        return list;

    }

    public void deleteSupplierEvaluation(int id) {
        String sql = "delete from supplier_evaluation where id = " + id;
        try {
            conn = new Context().getJDBCConnection();
            ps = conn.prepareStatement(sql);
            ps.executeUpdate();
        } catch (SQLException e) {
        }
    }

    public static void main(String[] args) {
        SupplierEvaluationDAO sed = new SupplierEvaluationDAO();
        List<Supplier> list = sed.staticRated("desc");
        System.out.println(list.size());
        
    }

}
