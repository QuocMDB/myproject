/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Models;

/**
 *
 * @author Fpt
 */
public class Orders {
    private int orderID;
    private int user_id;
    private String date;
    private String address;
    private String phonenumber;
    private double totalmoney;
    private int status;

    public Orders() {
    }

    public Orders(int orderID, int user_id, String date, String address, String phonenumber, double totalmoney, int status) {
        this.orderID = orderID;
        this.user_id = user_id;
        this.date = date;
        this.address = address;
        this.phonenumber = phonenumber;
        this.totalmoney = totalmoney;
        this.status = status;
    }

    public int getOrderID() {
        return orderID;
    }

    public void setOrderID(int orderID) {
        this.orderID = orderID;
    }

    public int getUser_id() {
        return user_id;
    }

    public void setUser_id(int user_id) {
        this.user_id = user_id;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getPhonenumber() {
        return phonenumber;
    }

    public void setPhonenumber(String phonenumber) {
        this.phonenumber = phonenumber;
    }

    public double getTotalmoney() {
        return totalmoney;
    }

    public void setTotalmoney(double totalmoney) {
        this.totalmoney = totalmoney;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return "Orders{" + "orderID=" + orderID + ", user_id=" + user_id + ", date=" + date + ", address=" + address + ", phonenumber=" + phonenumber + ", totalmoney=" + totalmoney + ", status=" + status + '}';
    }

   
   
    
    
}
