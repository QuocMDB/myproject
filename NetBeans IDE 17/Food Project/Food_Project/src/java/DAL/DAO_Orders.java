/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAL;

import Models.CartItem;
import Models.DetailYourOrder;
import Models.Orders;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.List;
import java.util.Vector;

/**
 *
 * @author Fpt
 */
public class DAO_Orders {

    public static DAO_Orders INSTANCE = new DAO_Orders();
    public Connection con;
    private String status = "OK";

    public DAO_Orders() {
        if (INSTANCE == null) {
            try {
                con = new DBContext().getConnection();
                System.out.println("Kết nối database: " + con.isClosed());
            } catch (Exception e) {
                status = "Error ar connection" + e.getMessage();
            }
        }
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Orders checkOrderStatus(int user_id) {
        String sql = "select * from Orders where [status] = 1 and user_id = ?";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, user_id);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                return new Orders(
                        rs.getInt(1),
                        rs.getInt(2),
                        rs.getString(3),
                        rs.getString(4),
                        rs.getString(5),
                        rs.getDouble(6),
                        rs.getInt(7)
                );
            }
        } catch (Exception e) {
            status = "Error ar read Users " + e.getMessage();
        }
        return null;

    }

    public void InsertNewOrder(int user_id) {
        String sql = "insert into Orders (user_id, status) values (? , 1);";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, user_id);
            ps.executeUpdate();
        } catch (Exception e) {
            status = "Error ar read Users " + e.getMessage();
        }

    }

    public void InsertNewOrderDetail(int orderID, int product_id, int quantity) {
        String sql = "insert into OrderDetails(orderID, product_id, quantity) values(?,?,?)";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, orderID);
            ps.setInt(2, product_id);
            ps.setInt(3, quantity);
            ps.executeUpdate();
        } catch (Exception e) {
            status = "Error ar read Users " + e.getMessage();
        }

    }

    public List<CartItem> loadCartItem(int user_id) {
        List<CartItem> cat = new Vector<>();
        String sql = "select  o.product_id, p.image_url, p.product_name, p.price, o.quantity,p.quantity_in_stock, o.id from OrderDetails o\n"
                + "join Products p on o.product_id = p.product_id\n"
                + "join Orders oo on oo.orderID = o.orderID\n"
                + "where oo.user_id = ? and oo.status = 1";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, user_id);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                cat.add(new CartItem(
                        rs.getInt(1),
                        rs.getString(2),
                        rs.getString(3),
                        rs.getDouble(4),
                        rs.getInt(5),
                        rs.getInt(6),
                        rs.getInt(7)
                ));
            }
        } catch (Exception e) {
            status = "Error ar read Products " + e.getMessage();
        }

        return cat;
    }

    public void deleteOrderDetail(String id) {
        String sql = "delete OrderDetails where id = ?";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, Integer.parseInt(id));
            ps.executeUpdate();
        } catch (Exception e) {
            status = "Error ar read Products " + e.getMessage();
        }

    }

    public void UpdateQuantityOrderDetail(String id, String quantity) {
        String sql = "update OrderDetails set quantity = ? where id = ?";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, Integer.parseInt(quantity));
            ps.setInt(2, Integer.parseInt(id));
            ps.executeUpdate();
        } catch (Exception e) {
            status = "Error ar read Products " + e.getMessage();
        }

    }

    public void InsertOrderComplete(int user_id, String date, String address, String phonenumber, double totalmoney) {
        String sql = "update Orders set status = 0, date = ? ,address=?, phonenumber= ?, totalmoney = ? where user_id = ? and status = 1";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, date);
            ps.setString(2, address);
            ps.setString(3, phonenumber);
            ps.setDouble(4, totalmoney);
            ps.setInt(5, user_id);
            ps.executeUpdate();
        } catch (Exception e) {
            status = "Error ar read Users " + e.getMessage();
        }

    }

    public List<Orders> loadOrders(int user_id) {
        List<Orders> ord = new Vector<>();
        String sql = "select * from Orders where user_id = ?";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, user_id);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ord.add(new Orders(
                        rs.getInt(1),
                        rs.getInt(2),
                        rs.getString(3),
                        rs.getString(4),
                        rs.getString(5),
                        rs.getDouble(6),
                        rs.getInt(7)
                ));
            }
        } catch (Exception e) {
            status = "Error ar read Products " + e.getMessage();
        }

        return ord;
    }

    public List<DetailYourOrder> loadOrderDetail(int orderID) {
        List<DetailYourOrder> ord = new Vector<>();
        String sql = "select p.image_url,p.product_name, p.price, sum(o.quantity) quantity, p.product_id, oo.status from OrderDetails o\n"
                + "join Products p on o.product_id = p.product_id\n"
                + "join Orders oo on oo.orderID = o.orderID\n"
                + "where oo.orderID = ?\n"
                + "group by p.image_url,p.product_name, p.price,p.product_id, oo.status";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, orderID);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ord.add(new DetailYourOrder(
                        rs.getString(1),
                        rs.getString(2),
                        rs.getDouble(3),
                        rs.getInt(4),
                        rs.getInt(5),
                        rs.getInt(6)
                ));
            }
        } catch (Exception e) {
            status = "Error ar read Products " + e.getMessage();
        }

        return ord;
    }
}
