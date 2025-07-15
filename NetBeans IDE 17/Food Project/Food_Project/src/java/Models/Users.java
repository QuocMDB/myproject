/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Models;

/**
 *
 * @author Fpt
 */
public class Users {
    private int user_id;
    private String username;
    private String password;
    private String email;
    private String fullname;
    private String phone_number;
    private int isAdmin;

    public Users() {
    }

    public Users(int user_id, String username, String password, String email, String fullname, String phone_number, int isAdmin) {
        this.user_id = user_id;
        this.username = username;
        this.password = password;
        this.email = email;
        this.fullname = fullname;
        this.phone_number = phone_number;
        this.isAdmin = isAdmin;
    }

    public int getUser_id() {
        return user_id;
    }

    public void setUser_id(int user_id) {
        this.user_id = user_id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
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

    public String getPhone_number() {
        return phone_number;
    }

    public void setPhone_number(String phone_number) {
        this.phone_number = phone_number;
    }

    public int getIsAdmin() {
        return isAdmin;
    }

    public void setIsAdmin(int isAdmin) {
        this.isAdmin = isAdmin;
    }

    @Override
    public String toString() {
        return "Users{" + "user_id=" + user_id + ", username=" + username + ", password=" + password + ", email=" + email + ", fullname=" + fullname + ", phone_number=" + phone_number + ", isAdmin=" + isAdmin + '}';
    }

}
