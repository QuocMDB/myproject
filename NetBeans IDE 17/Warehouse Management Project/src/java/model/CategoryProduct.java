package model;

import java.time.LocalDateTime;

public class CategoryProduct {
    private int id;
    private String name;
    private Integer parentId;
    private boolean activeFlag;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    
    // Field cho tên danh mục cha
    private String parentName;

    // Constructors
    public CategoryProduct() {}

    public CategoryProduct(int id, String name, Integer parentId, boolean activeFlag) {
        this.id = id;
        this.name = name;
        this.parentId = parentId;
        this.activeFlag = activeFlag;
    }

    public CategoryProduct(int id, String name, Integer parentId, boolean activeFlag, 
                          LocalDateTime createdAt, LocalDateTime updatedAt) {
        this.id = id;
        this.name = name;
        this.parentId = parentId;
        this.activeFlag = activeFlag;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
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

    public Integer getParentId() {
        return parentId;
    }

    public void setParentId(Integer parentId) {
        this.parentId = parentId;
    }

    public boolean isActiveFlag() {
        return activeFlag;
    }

    public void setActiveFlag(boolean activeFlag) {
        this.activeFlag = activeFlag;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    public String getParentName() {
        return parentName;
    }

    public void setParentName(String parentName) {
        this.parentName = parentName;
    }

    @Override
    public String toString() {
        return "CategoryProduct{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", parentId=" + parentId +
                ", parentName='" + parentName + '\'' +
                ", activeFlag=" + activeFlag +
                ", createdAt=" + createdAt +
                ", updatedAt=" + updatedAt +
                '}';
    }
}