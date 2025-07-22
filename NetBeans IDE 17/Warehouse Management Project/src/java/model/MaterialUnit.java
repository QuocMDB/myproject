/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author tunga
 */

import java.sql.Timestamp;

public class MaterialUnit {
    private int id;
    private String name;
    private String symbol;
    private String description;
    private int status; // Changed from String type to int status
    private boolean canDelete; // New property to check if unit can be deleted
    private Timestamp createdAt;
    
    public MaterialUnit() {
    }
    
    public MaterialUnit(int id, String name, String symbol, String description, int status, Timestamp createdAt) {
        this.id = id;
        this.name = name;
        this.symbol = symbol;
        this.description = description;
        this.status = status;
        this.createdAt = createdAt;
    }
    
    // Getters and Setters
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public String getSymbol() {
        return symbol;
    }
    
    public void setSymbol(String symbol) {
        this.symbol = symbol;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public int getStatus() {
        return status;
    }
    
    public void setStatus(int status) {
        this.status = status;
    }
    
    public boolean isCanDelete() {
        return canDelete;
    }
    
    public void setCanDelete(boolean canDelete) {
        this.canDelete = canDelete;
    }
    
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
    
    public String getFormattedCreatedDate() {
        // Format date as MM/dd/yyyy
        if (createdAt != null) {
            java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("MM/dd/yyyy");
            return sdf.format(createdAt);
        }
        return "";
    }
}

