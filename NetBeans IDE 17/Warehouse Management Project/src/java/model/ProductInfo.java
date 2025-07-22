package model;

import java.math.BigDecimal;
import java.sql.Date;

/**
 * Model class for Product Information
 * Represents a product in the warehouse management system
 */
public class ProductInfo {
    private int id;
    private String name;
    private String code;
    private int cate_id;
    private int unit_id;
    private String status;
    private String description;
    private int supplierId;
    private Date expirationDate;
    private String additionalNotes;
    private int createdBy;
    private Date createdDate;
    private int updatedBy;
    private Date updatedDate;
    private BigDecimal stockQuantity;
    private BigDecimal minStockThreshold;
    private String unitSymbol;

    // Default constructor
    public ProductInfo() {
    }

    // Constructor with basic fields
    public ProductInfo(String name, String code, int cate_id, int unit_id, String status, String description,String unitSymbol) {
        this.name = name;
        this.code = code;
        this.cate_id = cate_id;
        this.unit_id = unit_id;
        this.status = status;
        this.description = description;
        this.unitSymbol = unitSymbol;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }
    public String getUnitSymbol() {
    return unitSymbol;
}

public void setUnitSymbol(String unitSymbol) {
    this.unitSymbol = unitSymbol;
}

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public int getCate_id() {
        return cate_id;
    }

    public void setCate_id(int cate_id) {
        this.cate_id = cate_id;
    }

    public int getUnit_id() {
        return unit_id;
    }

    public void setUnit_id(int unit_id) {
        this.unit_id = unit_id;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getSupplierId() {
        return supplierId;
    }

    public void setSupplierId(int supplierId) {
        this.supplierId = supplierId;
    }

    public Date getExpirationDate() {
        return expirationDate;
    }

    public void setExpirationDate(Date expirationDate) {
        this.expirationDate = expirationDate;
    }

    public String getAdditionalNotes() {
        return additionalNotes;
    }

    public void setAdditionalNotes(String additionalNotes) {
        this.additionalNotes = additionalNotes;
    }

    public int getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(int createdBy) {
        this.createdBy = createdBy;
    }

    public Date getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(Date createdDate) {
        this.createdDate = createdDate;
    }

    public int getUpdatedBy() {
        return updatedBy;
    }

    public void setUpdatedBy(int updatedBy) {
        this.updatedBy = updatedBy;
    }

    public Date getUpdatedDate() {
        return updatedDate;
    }

    public void setUpdatedDate(Date updatedDate) {
        this.updatedDate = updatedDate;
    }

    public BigDecimal getStockQuantity() {
        return stockQuantity;
    }

    public void setStockQuantity(BigDecimal stockQuantity) {
        this.stockQuantity = stockQuantity;
    }
    
    public void setStockQuantity(double stockQuantity) {
        this.stockQuantity = BigDecimal.valueOf(stockQuantity);
    }

    public BigDecimal getMinStockThreshold() {
        return minStockThreshold;
    }

    public void setMinStockThreshold(BigDecimal minStockThreshold) {
        this.minStockThreshold = minStockThreshold;
    }

    @Override
    public String toString() {
        return "ProductInfo{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", code='" + code + '\'' +
                ", cate_id=" + cate_id +
                ", unit_id=" + unit_id +
                ", status='" + status + '\'' +
                ", description='" + description + '\'' +
                ", supplierId=" + supplierId +
                ", expirationDate=" + expirationDate +
                ", additionalNotes='" + additionalNotes + '\'' +
                ", minStockThreshold=" + minStockThreshold +
                '}';
    }
}