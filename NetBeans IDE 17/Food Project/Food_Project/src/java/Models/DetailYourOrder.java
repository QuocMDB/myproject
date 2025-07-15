/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Models;

/**
 *
 * @author Fpt
 */
public class DetailYourOrder {
    private String image_url;
    private String name;
    private double price;
    private int quantity;
    private int product_id;
    private int status;

    public DetailYourOrder() {
    }

    public DetailYourOrder(String image_url, String name, double price, int quantity, int product_id, int status) {
        this.image_url = image_url;
        this.name = name;
        this.price = price;
        this.quantity = quantity;
        this.product_id = product_id;
        this.status = status;
    }

    public String getImage_url() {
        return image_url;
    }

    public void setImage_url(String image_url) {
        this.image_url = image_url;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public int getProduct_id() {
        return product_id;
    }

    public void setProduct_id(int product_id) {
        this.product_id = product_id;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return "DetailYourOrder{" + "image_url=" + image_url + ", name=" + name + ", price=" + price + ", quantity=" + quantity + ", product_id=" + product_id + ", status=" + status + '}';
    }

    
}
