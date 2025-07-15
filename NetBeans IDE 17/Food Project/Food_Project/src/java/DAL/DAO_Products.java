/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAL;

import java.sql.*;
import java.util.List;
import java.util.Vector;
import Models.*;

/**
 *
 * @author Adim
 */
public class DAO_Products {

    public static DAO_Products INSTANCE = new DAO_Products();
    public Connection con;
    private String status = "OK";

    public DAO_Products() {
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
//    Products

    public List<Products> loadProduct(String s) {
        List<Products> prd = new Vector<>();
        String sql = "select * from Products " + s;
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                prd.add(new Products(
                        rs.getInt(1),
                        rs.getString(2), //Name
                        rs.getString(3),
                        rs.getDouble(4),
                        rs.getInt(5),
                        rs.getString(6),
                        rs.getInt(7),
                        rs.getInt(8)
                ));
            }
        } catch (Exception e) {
            status = "Error ar read Products " + e.getMessage();
        }

        return prd;
    }
    
    public List<Products> loadProductForCustomer() {
        List<Products> prd = new Vector<>();
        String sql = "Select * from Products where quantity_in_stock > 0";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                prd.add(new Products(
                        rs.getInt(1),
                        rs.getString(2), //Name
                        rs.getString(3),
                        rs.getDouble(4),
                        rs.getInt(5),
                        rs.getString(6),
                        rs.getInt(7),
                        rs.getInt(8)
                ));
            }
        } catch (Exception e) {
            status = "Error ar read Products " + e.getMessage();
        }

        return prd;
    }

    public List<Products> loadProductTop1() {
        List<Products> prd = new Vector<>();
        String sql = "select top 1 * from Products order by quantity_sold desc";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                prd.add(new Products(
                        rs.getInt(1),
                        rs.getString(2), //Name
                        rs.getString(3),
                        rs.getDouble(4),
                        rs.getInt(5),
                        rs.getString(6),
                        rs.getInt(7),
                        rs.getInt(8)
                ));
            }
        } catch (Exception e) {
            status = "Error ar read Products " + e.getMessage();
        }

        return prd;
    }

    //thay doi du lieu product
    public void changeProduct(String id, String name, String description, String category_id, String quantity_sold, String quantity_in_stock, String price) {
        String sql = "UPDATE Products\n"
                + "SET product_name = ?, \n"
                + "    description = ?,\n"
                + "    price = ?, \n"
                + "    category_id = ?,\n"
                + "    quantity_in_stock = ?,\n"
                + "    quantity_sold = ?\n"
                + "WHERE product_id = ?";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, name);
            ps.setString(2, description);
            ps.setDouble(3, Double.parseDouble(price));
            ps.setInt(4, Integer.parseInt(category_id));
            ps.setInt(5, Integer.parseInt(quantity_in_stock));
            ps.setInt(6, Integer.parseInt(quantity_sold));
            ps.setInt(7, Integer.parseInt(id));
            ps.executeUpdate();
        } catch (Exception e) {
            status = "Error ar read Products " + e.getMessage();
        }

    }

    //update product
    public void updateProduct(int id, int sold_quantity) {
        String sql = "update Products set quantity_sold += ?, quantity_in_stock -= ? where product_id = ? ";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, sold_quantity);
            ps.setInt(2, sold_quantity);
            ps.setInt(3, id);
            ps.executeUpdate();
        } catch (Exception e) {
            status = "Error ar read Products " + e.getMessage();
        }

    }

    // xoa san pham
    public void deleteProduct(String id) {
        String sql = "delete Products where product_id = ?";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, id);
            ps.executeUpdate();
        } catch (Exception e) {
            status = "Error ar read Products " + e.getMessage();
        }

    }

    //them san pham
    public void insertProduct(String name, String description, String price, String category_id, String image_url, String quantity_sold, String quantity_in_stock) {
        String sql = "INSERT INTO Products (product_name, description, price, category_id, image_url, \n"
                + "  quantity_in_stock, quantity_sold)\n"
                + "VALUES (?, ?, ?, ?, ?, ?, ?);";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, name);
            ps.setString(2, description);
            ps.setDouble(3, Double.parseDouble(price));
            ps.setInt(4, Integer.parseInt(category_id));
            ps.setString(5, image_url);
            ps.setInt(6, Integer.parseInt(quantity_in_stock));
            ps.setInt(7, Integer.parseInt(quantity_sold));
            ps.executeUpdate();
        } catch (Exception e) {
            status = "Error ar read Products " + e.getMessage();
        }

    }

//    categories
    public List<Categories> loadCategory(String s) {
        List<Categories> cat = new Vector<>();
        String sql = "select * from Categories " + s;
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                cat.add(new Categories(
                        rs.getInt(1),
                        rs.getString(2), //Name
                        rs.getString(3)
                ));
            }
        } catch (Exception e) {
            status = "Error ar read Categories " + e.getMessage();
        }

        return cat;

    }

    public Categories checkCategory(String category_name) {
        String sql = "select * from Categories where category_name = ?";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, category_name);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                return new Categories(
                        rs.getInt(1),
                        rs.getString(2), //Name
                        rs.getString(3)
                );
            }
        } catch (Exception e) {
            status = "Error ar read Categories " + e.getMessage();
        }

        return null;

    }

    public void insertCategory(String category_name, String description) {
        String sql = "insert into Categories(category_name, description) values (?,?)";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, category_name);
            ps.setString(2, description);
            ps.executeUpdate();

        } catch (Exception e) {
            status = "Error ar read Categories " + e.getMessage();
        }

    }

//    User - Login
    // đăng nhập
    public Users login(String email, String pass) {
        String sql = "select * from Users where email = ? and password = ?";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, pass);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                return new Users(
                        rs.getInt(1),
                        rs.getString(2),
                        rs.getString(3),
                        rs.getString(4),
                        rs.getString(5),
                        rs.getString(6),
                        rs.getInt(7)
                );
            }
        } catch (Exception e) {
            status = "Error ar read Users " + e.getMessage();
        }
        return null;

    }

    // xem đã tồn tại tài khoản chưa
    public Users checkSignUp(String user) {
        String sql = "select * from Users where username = ?";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, user);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                return new Users(
                        rs.getInt(1),
                        rs.getString(2),
                        rs.getString(3),
                        rs.getString(4),
                        rs.getString(5),
                        rs.getString(6),
                        rs.getInt(7)
                );
            }
        } catch (Exception e) {
            status = "Error ar read Users " + e.getMessage();
        }
        return null;

    }

    // tìm lại pass word
    public String checkPassWord(String username, String email, String name, String phonenumber) {
        String sql = "select * from Users where username = ? and email = ? and phone_number = ? and full_name = ?";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, email);
            ps.setString(3, phonenumber);
            ps.setString(4, name);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                return (new Users(
                        rs.getInt(1),
                        rs.getString(2),
                        rs.getString(3),
                        rs.getString(4),
                        rs.getString(5),
                        rs.getString(6),
                        rs.getInt(7)).getPassword());
            }
        } catch (Exception e) {
            status = "Error ar read Users " + e.getMessage();
        }
        return null;

    }

    // check xem đúng mật khẩu cần sửa chưa
    public Users checkChangePassWord(String username, String oldpassword, String name, String phonenumber, String email) {
        String sql = "select * from Users where username = ? and [password] = ? and email = ? and full_name = ? \n"
                + "and phone_number = ?";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, oldpassword);
            ps.setString(3, email);
            ps.setString(4, name);
            ps.setString(5, phonenumber);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                return (new Users(
                        rs.getInt(1),
                        rs.getString(2),
                        rs.getString(3),
                        rs.getString(4),
                        rs.getString(5),
                        rs.getString(6),
                        rs.getInt(7)
                ));
            }
        } catch (Exception e) {
            status = "Error ar read Users " + e.getMessage();
        }
        return null;

    }

    // sửa mật khẩu
    public void changePassWord(String username, String newpasword) {
        String sql = "UPDATE Users  SET password = ?  WHERE username = ? ";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, newpasword);
            ps.setString(2, username);
            ps.executeUpdate();
        } catch (Exception e) {
            status = "Error ar read Users " + e.getMessage();
        }

    }

    // thêm tài khoản
    public void signUp(String name, String phonenumber, String email, String username, String pass) {
        String sql = "INSERT INTO Users (username, password, email, full_name, phone_number, isAdmin) \n"
                + "VALUES(?,?,?,?,?,0)";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, pass);
            ps.setString(3, email);
            ps.setString(4, name);
            ps.setString(5, phonenumber);
            ps.executeUpdate();
        } catch (Exception e) {
            status = "Error ar read Users " + e.getMessage();
        }

    }

//Cart
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

    public List<Orders> loadAllOrders() {
        List<Orders> ord = new Vector<>();
        String sql = "select * from Orders";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
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

    public void updateOrderStatus(int order_id) {
        String sql = "update Orders set [status] = 2 where orderID = ?";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, order_id);
            ps.executeUpdate();
        } catch (Exception e) {
            status = "Error ar read Orders " + e.getMessage();
        }

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

    // managa user
    public List<Users> loadAllUsers() {
        List<Users> user = new Vector<>();
        String sql = "select * from Users";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                user.add(new Users(
                        rs.getInt(1),
                        rs.getString(2), //Name
                        rs.getString(3),
                        rs.getString(4),
                        rs.getString(5),
                        rs.getString(6),
                        rs.getInt(7)
                ));
            }
        } catch (Exception e) {
            status = "Error ar read Products " + e.getMessage();
        }

        return user;
    }

    public void deleteUser(String user_id) {
        String sql = "delete from Users where user_id = ?";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, Integer.parseInt(user_id));
            ps.executeUpdate();
        } catch (Exception e) {
            status = "Error ar read Products " + e.getMessage();
        }

    }

    //review 
    public Reviews checkReview(int user_id, int product_id) {
        String sql = "select * from Reviews where user_id = ? and product_id = ?";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, user_id);
            ps.setInt(2, product_id);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                return new Reviews(
                        rs.getInt(1),
                        rs.getInt(2), //Name
                        rs.getInt(3),
                        rs.getString(4),
                        rs.getString(5)
                );
            }
        } catch (Exception e) {
            status = "Error ar read Products " + e.getMessage();
        }

        return null;
    }

    public void insertReview(int product_id, int user_id, int rating, String comment, String review_date) {
        String sql = "insert into Reviews(product_id,user_id, rating, comment, review_date)\n"
                + "values (?,?,?,?,?)";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, product_id);
            ps.setInt(2, user_id);
            ps.setInt(3, rating);
            ps.setString(4, comment);
            ps.setString(5, review_date);
            ps.executeUpdate();
        } catch (Exception e) {
            status = "Error ar read Products " + e.getMessage();
        }

    }

    public void updateReview(int product_id, int user_id, int rating, String comment, String review_date) {
        String sql = "update Reviews set rating = ?, comment = ?, review_date = ? where product_id = ? and user_id = ?";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, rating);
            ps.setString(2, comment);
            ps.setString(3, review_date);
            ps.setInt(4, product_id);
            ps.setInt(5, user_id);
            ps.executeUpdate();
        } catch (Exception e) {
            status = "Error ar read Products " + e.getMessage();
        }

    }

    public List<ReviewsUser> loadAllReviews(int product_id) {
        List<ReviewsUser> rew = new Vector<>();
        String sql = "select r.product_id, r.user_id, r.rating, r.comment, r.review_date, u.username from Reviews r\n"
                + "join Users u on r.user_id = u.user_id\n"
                + "where r.product_id = ?";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, product_id);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                rew.add(new ReviewsUser(
                        rs.getInt(1),
                        rs.getInt(2), //Name
                        rs.getInt(3),
                        rs.getString(4),
                        rs.getString(5),
                        rs.getString(6)
                ));
            }
        } catch (Exception e) {
            status = "Error ar read Products " + e.getMessage();
        }

        return rew;
    }

    public void deleteReview(int user_id, int product_id) {
        String sql = "delete Reviews where user_id = ? and product_id = ?";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, user_id);
            ps.setInt(2, product_id);
            ps.executeUpdate();
        } catch (Exception e) {
            status = "Error ar read Reviews " + e.getMessage();
        }

    }

}
