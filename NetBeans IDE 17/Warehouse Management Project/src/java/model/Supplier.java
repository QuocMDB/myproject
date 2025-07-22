
/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;
import java.sql.Date;
/**
 *
 * @author Fpt06
 */
public class Supplier {
    private int supplierID;
    private String name;
    private String phone;
    private String email;
    private String address;
    private String note;
    private int activeFlag;
    private Date createDate;

    public Supplier() {
    }
    
    public Supplier(String name, String phone, String email, String address, String note, int activeFlag, Date createDate) {
        this.name = name;
        this.phone = phone;
        this.email = email;
        this.address = address;
        this.note = note;
        this.activeFlag = activeFlag;
        this.createDate = createDate;
    }
    
    public Supplier(int supplierID, String name, String phone, String email, String address, String note, int activeFlag, Date createDate) {
        this.supplierID = supplierID;
        this.name = name;
        this.phone = phone;
        this.email = email;
        this.address = address;
        this.note = note;
        this.activeFlag = activeFlag;
        this.createDate = createDate;
    }
    
    

    public int getSupplierID() {
        return supplierID;
    }

    public void setSupplierID(int supplierID) {
        this.supplierID = supplierID;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public int getActiveFlag() {
        return activeFlag;
    }

    public void setActiveFlag(int activeFlag) {
        this.activeFlag = activeFlag;
    }

    public Date getCreateDate() {
        return createDate;
    }

    public void setCreateDate(Date createDate) {
        this.createDate = createDate;
    }

    @Override
    public String toString() {
        return "Supplier{" + "supplierID=" + supplierID + ", name=" + name + ", phone=" + phone + ", email=" + email + ", address=" + address + ", note=" + note + ", activeFlag=" + activeFlag + ", createDate=" + createDate + '}';
    }
    
}
