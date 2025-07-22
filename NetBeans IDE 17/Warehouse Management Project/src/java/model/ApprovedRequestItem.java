package model;

public class ApprovedRequestItem {

    private String requestId;
    private String dayRequest;
    private String status;
    private String supplier;
    private String address;
    private String phone;
    private String email;
    private String productName;
    private String productCode;
    private String productFullName;
    private double price;
    private String unit;
    private double quantity;
    private String note;
    private String reasonDetail;

    public ApprovedRequestItem(String requestId, String dayRequest, String status, String supplier, String address, String phone, String email, String productName, String productCode, String productFullName, double price, String unit, double quantity, String note, String reasonDetail) {
        this.requestId = requestId;
        this.dayRequest = dayRequest;
        this.status = status;
        this.supplier = supplier;
        this.address = address;
        this.phone = phone;
        this.email = email;
        this.productName = productName;
        this.productCode = productCode;
        this.productFullName = productFullName;
        this.price = price;
        this.unit = unit;
        this.quantity = quantity;
        this.note = note;
        this.reasonDetail = reasonDetail;
    }

    public ApprovedRequestItem() {
    }

    // Getters & Setters
    public String getRequestId() {
        return requestId;
    }

    public void setRequestId(String requestId) {
        this.requestId = requestId;
    }

    public String getDayRequest() {
        return dayRequest;
    }

    public void setDayRequest(String dayRequest) {
        this.dayRequest = dayRequest;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
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

    public String getProductFullName() {
        return productFullName;
    }

    public void setProductFullName(String productFullName) {
        this.productFullName = productFullName;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
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

    public String getReasonDetail() {
        return reasonDetail;
    }

    public void setReasonDetail(String reasonDetail) {
        this.reasonDetail = reasonDetail;
    }

    @Override
    public String toString() {
        return "ApprovedRequestItem{"
                + "requestId='" + requestId + '\''
                + ", dayRequest='" + dayRequest + '\''
                + ", status='" + status + '\''
                + ", supplier='" + supplier + '\''
                + ", address='" + address + '\''
                + ", phone='" + phone + '\''
                + ", email='" + email + '\''
                + ", productName='" + productName + '\''
                + ", productCode='" + productCode + '\''
                + ", productFullName='" + productFullName + '\''
                + ", price=" + price
                + ", unit='" + unit + '\''
                + ", quantity=" + quantity
                + ", note='" + note + '\''
                + ", reasonDetail='" + reasonDetail + '\''
                + '}';
    }
}
