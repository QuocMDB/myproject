/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Timestamp;

/**
 *
 * @author phucn
 */
public class ForgotPasswordRequest {
    private int id;
    private int userId;
    private String username;
    private String email;
    private Timestamp requestTime;
    private String note;
    private Timestamp responseTime;
    private String status;

    public ForgotPasswordRequest() {
    }

    public ForgotPasswordRequest(int id, int userId, String username, String email, Timestamp requestTime, String note, Timestamp responseTime, String status) {
        this.id = id;
        this.userId = userId;
        this.username = username;
        this.email = email;
        this.requestTime = requestTime;
        this.note = note;
        this.responseTime = responseTime;
        this.status = status;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }
    
    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public Timestamp getRequestTime() {
        return requestTime;
    }

    public void setRequestTime(Timestamp requestTime) {
        this.requestTime = requestTime;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public Timestamp getResponseTime() {
        return responseTime;
    }

    public void setResponseTime(Timestamp responseTime) {
        this.responseTime = responseTime;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
    
    
}