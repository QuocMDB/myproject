/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Admin
 */
public class RequestItems {
    private int id;
    private Request request_id;
    private String[] product_name;
    private String[] product_code;
    private String[] unit;
    private int[] quantity;
    private String[] note;

    public RequestItems() {
    }

    public RequestItems(int id, Request request_id, String[] product_name, String[] product_code, String[] unit, int[] quantity, String[] note) {
        this.id = id;
        this.request_id = request_id;
        this.product_name = product_name;
        this.product_code = product_code;
        this.unit = unit;
        this.quantity = quantity;
        this.note = note;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Request getRequest_id() {
        return request_id;
    }

    public void setRequest_id(Request request_id) {
        this.request_id = request_id;
    }

    public String[] getProduct_name() {
        return product_name;
    }

    public void setProduct_name(String[] product_name) {
        this.product_name = product_name;
    }

    public String[] getProduct_code() {
        return product_code;
    }

    public void setProduct_code(String[] product_code) {
        this.product_code = product_code;
    }

    public String[] getUnit() {
        return unit;
    }

    public void setUnit(String[] unit) {
        this.unit = unit;
    }

    public int[] getQuantity() {
        return quantity;
    }

    public void setQuantity(int[] quantity) {
        this.quantity = quantity;
    }

    public String[] getNote() {
        return note;
    }

    public void setNote(String[] note) {
        this.note = note;
    }

}
