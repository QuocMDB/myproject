package model;

public class RequestItem {

    private int id;
    private String requestId;
    private String productName;
    private String productCode;
    private String unit;
    private double quantity; // Sửa từ int thành double
    private double importedQty; // mới
    private String note;

    public RequestItem() {
    }

    public RequestItem(int id, String requestId, String productName, String productCode, String unit, double quantity, double importedQty, String note) {
        this.id = id;
        this.requestId = requestId;
        this.productName = productName;
        this.productCode = productCode;
        this.unit = unit;
        this.quantity = quantity;
        this.importedQty = importedQty;
        this.note = note;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getRequestId() {
        return requestId;
    }

    public void setRequestId(String requestId) {
        this.requestId = requestId;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getProductCode() {
        return productCode;
    }

    public void setProductCode(String productCode) {
        this.productCode = productCode;
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

    public double getImportedQty() {
        return importedQty;
    }

    public void setImportedQty(double importedQty) {
        this.importedQty = importedQty;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }
}
