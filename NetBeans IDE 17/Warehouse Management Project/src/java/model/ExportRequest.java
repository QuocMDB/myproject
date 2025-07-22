/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.util.ArrayList;
import java.util.Date;

/**
 *
 * @author Dell
 */
public class ExportRequest {

    private String id;
    private int user_id;
    private String role;
    private Date day_request;
    private String status;
    private String reason;
    private String department;
    private String recipient_name;
    private String recipient_phone;
    private String recipient_email;
    private String approve_by;
    private String warehouse;
    private ArrayList<ExportRequestItem> items;
    private String requester_name;

    public ExportRequest() {
    }

    public ExportRequest(String id, int user_id, String role, Date day_request, String status, String reason, String department, String recipient_name, String recipient_phone, String recipient_email, String approve_by, String warehouse, ArrayList<ExportRequestItem> items, String requester_name) {
        this.id = id;
        this.user_id = user_id;
        this.role = role;
        this.day_request = day_request;
        this.status = status;
        this.reason = reason;
        this.department = department;
        this.recipient_name = recipient_name;
        this.recipient_phone = recipient_phone;
        this.recipient_email = recipient_email;
        this.approve_by = approve_by;
        this.warehouse = warehouse;
        this.items = items;
        this.requester_name = requester_name;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public int getUser_id() {
        return user_id;
    }

    public void setUser_id(int user_id) {
        this.user_id = user_id;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public Date getDay_request() {
        return day_request;
    }

    public void setDay_request(Date day_request) {
        this.day_request = day_request;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

    public String getDepartment() {
        return department;
    }

    public void setDepartment(String department) {
        this.department = department;
    }

    public String getRecipient_name() {
        return recipient_name;
    }

    public void setRecipient_name(String recipient_name) {
        this.recipient_name = recipient_name;
    }

    public String getRecipient_phone() {
        return recipient_phone;
    }

    public void setRecipient_phone(String recipient_phone) {
        this.recipient_phone = recipient_phone;
    }

    public String getRecipient_email() {
        return recipient_email;
    }

    public void setRecipient_email(String recipient_email) {
        this.recipient_email = recipient_email;
    }

    public String getApprove_by() {
        return approve_by;
    }

    public void setApprove_by(String approve_by) {
        this.approve_by = approve_by;
    }

    public String getWarehouse() {
        return warehouse;
    }

    public void setWarehouse(String warehouse) {
        this.warehouse = warehouse;
    }

    public ArrayList<ExportRequestItem> getItems() {
        return items;
    }

    public void setItems(ArrayList<ExportRequestItem> items) {
        this.items = items;
    }

    public String getRequester_name() {
        return requester_name;
    }

    public void setRequester_name(String requester_name) {
        this.requester_name = requester_name;
    }
}
