/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Timestamp;
import java.util.Date;

/**
 *
 * @author phucn
 */
public class Users {

    private int id;
    private String username;
    private Date dob;
    private String password;
    private String email;
    private String fullname;
    private String phone;
    private Integer departmentId;
    private String deptName;
    private String roleName;
    private int activeFlag;
    private Timestamp createDate;

    public Users() {
    }

    public Users(int id, String username, Date dob, String password, String email, String fullname, String phone, Integer departmentId, String deptName, String roleName, int activeFlag, Timestamp createDate) {
        this.id = id;
        this.username = username;
        this.dob = dob;
        this.password = password;
        this.email = email;
        this.fullname = fullname;
        this.departmentId = departmentId;
        this.deptName = deptName;
        this.phone = phone;
        this.roleName = roleName;
        this.activeFlag = activeFlag;
        this.createDate = createDate;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public Date getDob() {
        return dob;
    }

    public void setDob(Date dob) {
        this.dob = dob;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getFullname() {
        return fullname;
    }

    public void setFullname(String fullname) {
        this.fullname = fullname;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public Integer getDepartmentId() {
        return departmentId;
    }

    public void setDepartmentId(Integer departmentId) {
        this.departmentId = departmentId;
    }
    
    public String getDeptName() {
        return deptName;
    }

    public void setDeptName(String deptName) {
        this.deptName = deptName;
    }

    public String getRoleName() {
        return roleName;
    }

    public void setRoleName(String roleName) {
        this.roleName = roleName;
    }

    public int getActiveFlag() {
        return activeFlag;
    }

    public void setActiveFlag(int activeFlag) {
        this.activeFlag = activeFlag;
    }

    public Timestamp getCreateDate() {
        return createDate;
    }

    public void setCreateDate(Timestamp createDate) {
        this.createDate = createDate;
    }

    @Override
    public String toString() {
        return "Users{" + "id=" + id + ", username=" + username + ", dob=" + dob + ", password=" + password + ", email=" + email + ", fullname=" + fullname + ", phone=" + phone + ", roleName=" + roleName + ", activeFlag=" + activeFlag + ", createDate=" + createDate + '}';
    }

}
