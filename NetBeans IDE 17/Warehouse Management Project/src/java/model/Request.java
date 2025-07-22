
/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 *
 * @author Admin
 */
public class Request {

    private String id;
    private String fullname;
    private String role;
    private Date day_request;
    private String status;
    private String reason;
    private List<RequestItem> items;

    public Request() {
    }

    public Request(String id, String fullname, String role, Date day_request, String status, String reason, List<RequestItem> items) {
        this.id = id;
        this.fullname = fullname;
        this.role = role;
        this.day_request = day_request;
        this.status = status;
        this.reason = reason;
        this.items = items;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getFullname() {
        return fullname;
    }

    public void setFullname(String fullname) {
        this.fullname = fullname;
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

    public List<RequestItem> getItems() {
        return items;
    }

    public void setItems(List<RequestItem> items) {
        this.items = items;
    }

   
}
