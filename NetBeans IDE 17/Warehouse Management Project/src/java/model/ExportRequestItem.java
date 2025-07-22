/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Dell
 */
public class ExportRequestItem {

    private int id;
    private String export_request_id;
    private String product_name;
    private String product_code;
    private String unit;
    private double quantity;
    private String note;
    private String reason_detail;
    private int product_id;
    private double exported_qty;

    public ExportRequestItem() {
    }

    public ExportRequestItem(int id, String export_request_id, String product_name,
            String product_code, String unit, double quantity, String note,
            String reason_detail, int product_id, double exported_qty) {
        this.id = id;
        this.export_request_id = export_request_id;
        this.product_name = product_name;
        this.product_code = product_code;
        this.unit = unit;
        this.quantity = quantity;
        this.note = note;
        this.reason_detail = reason_detail;
        this.product_id = product_id;
        this.exported_qty = exported_qty;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getExport_request_id() {
        return export_request_id;
    }

    public void setExport_request_id(String export_request_id) {
        this.export_request_id = export_request_id;
    }

    public String getProduct_name() {
        return product_name;
    }

    public void setProduct_name(String product_name) {
        this.product_name = product_name;
    }

    public String getProduct_code() {
        return product_code;
    }

    public void setProduct_code(String product_code) {
        this.product_code = product_code;
    }

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }

    public double getQuantity() {
        return quantity;
    }

    public void setQuantity(double quantity) {
        this.quantity = quantity;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public String getReason_detail() {
        return reason_detail;
    }

    public void setReason_detail(String reason_detail) {
        this.reason_detail = reason_detail;
    }

    public int getProduct_id() {
        return product_id;
    }

    public void setProduct_id(int product_id) {
        this.product_id = product_id;
    }

    public double getExported_qty() {
        return exported_qty;
    }

    public void setExported_qty(double exported_qty) {
        this.exported_qty = exported_qty;
    }
}
