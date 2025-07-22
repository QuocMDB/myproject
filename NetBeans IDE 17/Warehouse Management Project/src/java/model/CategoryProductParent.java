package model;

import java.time.LocalDateTime;

public class CategoryProductParent {

    private int id;
    private String name;
    private String description;
    private boolean activeFlag;
    private LocalDateTime createDate;
    private LocalDateTime updateDate;
    private int childCount; // ✅ THÊM FIELD NÀY

    // Constructors
    public CategoryProductParent() {
    }

    public CategoryProductParent(String name, String description) {
        this.name = name;
        this.description = description;
        this.activeFlag = true;
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

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public boolean isActiveFlag() {
        return activeFlag;
    }

    public void setActiveFlag(boolean activeFlag) {
        this.activeFlag = activeFlag;
    }

    public LocalDateTime getCreateDate() {
        return createDate;
    }

    public void setCreateDate(LocalDateTime createDate) {
        this.createDate = createDate;
    }

    public LocalDateTime getUpdateDate() {
        return updateDate;
    }

    public void setUpdateDate(LocalDateTime updateDate) {
        this.updateDate = updateDate;
    }

    public int getChildCount() {
        return childCount;
    }

    public void setChildCount(int childCount) {
        this.childCount = childCount;
    }
    // Thêm methods format

    public String getFormattedCreateDate() {
        if (createDate != null) {
            return createDate.format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy"));
        }
        return null;
    }

    public String getFormattedCreateTime() {
        if (createDate != null) {
            return createDate.format(java.time.format.DateTimeFormatter.ofPattern("HH:mm:ss"));
        }
        return null;
    }

    public String getFormattedUpdateDate() {
        if (updateDate != null) {
            return updateDate.format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy"));
        }
        return null;
    }

    public String getFormattedUpdateTime() {
        if (updateDate != null) {
            return updateDate.format(java.time.format.DateTimeFormatter.ofPattern("HH:mm:ss"));
        }
        return null;
    }

}
