package model;

import java.time.LocalDateTime;
import java.util.List;

public class Department {
    private int id;
    private String deptCode;
    private String deptName;
    private String description;
    private Integer managerId;
    private String phone;
    private String email;
    private boolean activeFlag;
    private Integer createdBy;
    private LocalDateTime createDate;
    private Integer updatedBy;
    private LocalDateTime updateDate;
    private String managerName;
    private String managerEmail;
    private String managerPhone;
    private String createdByName;
    private String updatedByName;
    private int employeeCount;
    private List<Users> employees;

    // Constructors
    public Department() {
        this.activeFlag = true;
        this.createDate = LocalDateTime.now();
        this.updateDate = LocalDateTime.now();
    }

    public Department(String deptCode, String deptName, String description) {
        this();
        this.deptCode = deptCode;
        this.deptName = deptName;
        this.description = description;
    }

    public Department(int id, String deptCode, String deptName, String description, 
                     Integer managerId, String phone, String email, boolean activeFlag,
                     Integer createdBy, LocalDateTime createDate, Integer updatedBy, 
                     LocalDateTime updateDate) {
        this.id = id;
        this.deptCode = deptCode;
        this.deptName = deptName;
        this.description = description;
        this.managerId = managerId;
        this.phone = phone;
        this.email = email;
        this.activeFlag = activeFlag;
        this.createdBy = createdBy;
        this.createDate = createDate;
        this.updatedBy = updatedBy;
        this.updateDate = updateDate;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getDeptCode() {
        return deptCode;
    }

    public void setDeptCode(String deptCode) {
        this.deptCode = deptCode;
    }

    public String getDeptName() {
        return deptName;
    }

    public void setDeptName(String deptName) {
        this.deptName = deptName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Integer getManagerId() {
        return managerId;
    }

    public void setManagerId(Integer managerId) {
        this.managerId = managerId;
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

    public boolean isActiveFlag() {
        return activeFlag;
    }

    public void setActiveFlag(boolean activeFlag) {
        this.activeFlag = activeFlag;
    }

    public Integer getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(Integer createdBy) {
        this.createdBy = createdBy;
    }

    public LocalDateTime getCreateDate() {
        return createDate;
    }

    public void setCreateDate(LocalDateTime createDate) {
        this.createDate = createDate;
    }

    public Integer getUpdatedBy() {
        return updatedBy;
    }

    public void setUpdatedBy(Integer updatedBy) {
        this.updatedBy = updatedBy;
    }

    public LocalDateTime getUpdateDate() {
        return updateDate;
    }

    public void setUpdateDate(LocalDateTime updateDate) {
        this.updateDate = updateDate;
    }

    // Additional display fields
    public String getManagerName() {
        return managerName;
    }

    public void setManagerName(String managerName) {
        this.managerName = managerName;
    }

    public String getManagerEmail() {
        return managerEmail;
    }

    public void setManagerEmail(String managerEmail) {
        this.managerEmail = managerEmail;
    }

    public String getManagerPhone() {
        return managerPhone;
    }

    public void setManagerPhone(String managerPhone) {
        this.managerPhone = managerPhone;
    }

    public String getCreatedByName() {
        return createdByName;
    }

    public void setCreatedByName(String createdByName) {
        this.createdByName = createdByName;
    }

    public String getUpdatedByName() {
        return updatedByName;
    }

    public void setUpdatedByName(String updatedByName) {
        this.updatedByName = updatedByName;
    }

    public int getEmployeeCount() {
        return employeeCount;
    }

    public void setEmployeeCount(int employeeCount) {
        this.employeeCount = employeeCount;
    }

    public List<Users> getEmployees() {
        return employees;
    }

    public void setEmployees(List<Users> employees) {
        this.employees = employees;
    }

    // Utility methods
    public boolean hasManager() {
        return managerId != null && managerId > 0;
    }

    public boolean hasContact() {
        return (phone != null && !phone.trim().isEmpty()) || 
               (email != null && !email.trim().isEmpty());
    }

    public boolean hasEmployees() {
        return employeeCount > 0;
    }

    public String getStatusText() {
        return activeFlag ? "Hoạt động" : "Không hoạt động";
    }

    public String getStatusBadgeClass() {
        return activeFlag ? "badge-success" : "badge-secondary";
    }

    public String getToggleButtonText() {
        return activeFlag ? "🔒 Vô hiệu hóa" : "🔓 Kích hoạt";
    }

    public String getToggleButtonClass() {
        return activeFlag ? "btn-danger" : "btn-success";
    }

    public String getToggleButtonTitle() {
        return activeFlag ? "Vô hiệu hóa" : "Kích hoạt";
    }

    // Validation methods
    public boolean isValidDeptCode() {
        return deptCode != null && !deptCode.trim().isEmpty() && deptCode.length() <= 20;
    }

    public boolean isValidDeptName() {
        return deptName != null && !deptName.trim().isEmpty() && deptName.length() <= 100;
    }

    public boolean isValidPhone() {
        if (phone == null || phone.trim().isEmpty()) return true; // Optional field
        return phone.length() <= 20 && phone.matches("^[0-9+\\-\\s()]+$");
    }

    public boolean isValidEmail() {
        if (email == null || email.trim().isEmpty()) return true; // Optional field
        String emailRegex = "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$";
        return email.length() <= 100 && email.matches(emailRegex);
    }

    public boolean isValid() {
        return isValidDeptCode() && isValidDeptName() && isValidPhone() && isValidEmail();
    }

    // toString method for debugging
    @Override
    public String toString() {
        return "Department{" +
                "id=" + id +
                ", deptCode='" + deptCode + '\'' +
                ", deptName='" + deptName + '\'' +
                ", description='" + description + '\'' +
                ", managerId=" + managerId +
                ", phone='" + phone + '\'' +
                ", email='" + email + '\'' +
                ", activeFlag=" + activeFlag +
                ", createdBy=" + createdBy +
                ", createDate=" + createDate +
                ", updatedBy=" + updatedBy +
                ", updateDate=" + updateDate +
                ", managerName='" + managerName + '\'' +
                ", employeeCount=" + employeeCount +
                '}';
    }

    // equals and hashCode based on id and deptCode
    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        Department that = (Department) obj;
        return id == that.id && 
               (deptCode != null ? deptCode.equals(that.deptCode) : that.deptCode == null);
    }

    @Override
    public int hashCode() {
        int result = id;
        result = 31 * result + (deptCode != null ? deptCode.hashCode() : 0);
        return result;
    }

    // Builder pattern methods for easier object creation
    public static class Builder {
        private Department department;

        public Builder() {
            department = new Department();
        }

        public Builder deptCode(String deptCode) {
            department.setDeptCode(deptCode);
            return this;
        }

        public Builder deptName(String deptName) {
            department.setDeptName(deptName);
            return this;
        }

        public Builder description(String description) {
            department.setDescription(description);
            return this;
        }

        public Builder managerId(Integer managerId) {
            department.setManagerId(managerId);
            return this;
        }

        public Builder phone(String phone) {
            department.setPhone(phone);
            return this;
        }

        public Builder email(String email) {
            department.setEmail(email);
            return this;
        }

        public Builder activeFlag(boolean activeFlag) {
            department.setActiveFlag(activeFlag);
            return this;
        }

        public Builder createdBy(Integer createdBy) {
            department.setCreatedBy(createdBy);
            return this;
        }

        public Department build() {
            if (!department.isValid()) {
                throw new IllegalArgumentException("Invalid department data");
            }
            return department;
        }
    }

    // Static factory method
    public static Builder builder() {
        return new Builder();
    }
}