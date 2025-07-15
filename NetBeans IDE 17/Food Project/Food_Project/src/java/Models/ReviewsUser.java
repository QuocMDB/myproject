/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Models;

/**
 *
 * @author Fpt
 */
public class ReviewsUser {
    private int product_id;
    private int user_id;
    private int rating;
    private String comment;
    private String review_date;
    private String username;

    public ReviewsUser() {
    }

    public ReviewsUser(int product_id, int user_id, int rating, String comment, String review_date, String username) {
        this.product_id = product_id;
        this.user_id = user_id;
        this.rating = rating;
        this.comment = comment;
        this.review_date = review_date;
        this.username = username;
    }

    public int getProduct_id() {
        return product_id;
    }

    public void setProduct_id(int product_id) {
        this.product_id = product_id;
    }

    public int getUser_id() {
        return user_id;
    }

    public void setUser_id(int user_id) {
        this.user_id = user_id;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public String getReview_date() {
        return review_date;
    }

    public void setReview_date(String review_date) {
        this.review_date = review_date;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    @Override
    public String toString() {
        return "ReviewsUser{" + "product_id=" + product_id + ", user_id=" + user_id + ", rating=" + rating + ", comment=" + comment + ", review_date=" + review_date + ", username=" + username + '}';
    }
    
}
