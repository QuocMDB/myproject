/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;


import java.util.Date;
import java.util.List;

/**
 *
 * @author Admin
 */
public class PurchaseOrderInfo {
    private String id;
    private String fullname;
    private Date dayPurchase;
    private Date dayQuote;
    private String status;
    private String reason;
    private String supplier;
    private String address;
    private String phone;
    private String email;
    private String summary;
    private List<PurchaseOrderItems> purchaseItems;

    public PurchaseOrderInfo() {
    }

    public PurchaseOrderInfo(String id, String fullname, Date dayPurchase, Date dayQuote, String status, String reason, String supplier, String address, String phone, String email, String summary, List<PurchaseOrderItems> purchaseItems) {
        this.id = id;
        this.fullname = fullname;
        this.dayPurchase = dayPurchase;
        this.dayQuote = dayQuote;
        this.status = status;
        this.reason = reason;
        this.supplier = supplier;
        this.address = address;
        this.phone = phone;
        this.email = email;
        this.summary = summary;
        this.purchaseItems = purchaseItems;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getFullname() {
        return fullname;
    }

    public void setFullname(String fullname) {
        this.fullname = fullname;
    }

    public Date getDayPurchase() {
        return dayPurchase;
    }

    public void setDayPurchase(Date dayPurchase) {
        this.dayPurchase = dayPurchase;
    }

    public Date getDayQuote() {
        return dayQuote;
    }

    public void setDayQuote(Date dayQuote) {
        this.dayQuote = dayQuote;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

    public String getSupplier() {
        return supplier;
    }

    public void setSupplier(String supplier) {
        this.supplier = supplier;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
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

    public String getSummary() {
        return summary;
    }

    public void setSummary(String summary) {
        this.summary = summary;
    }

    public List<PurchaseOrderItems> getPurchaseItems() {
        return purchaseItems;
    }

    public void setPurchaseItems(List<PurchaseOrderItems> purchaseItems) {
        this.purchaseItems = purchaseItems;
    }

    
}
