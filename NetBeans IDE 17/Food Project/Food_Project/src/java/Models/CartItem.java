/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Models;

/**
 *
 * @author Fpt
 */
public class CartItem {
    private int product_id;
    private String image_url;
    private String product_name;
    private Double price;
    private int quantity;
    private int quantity_in_stock;
    private int id;

    public CartItem() {
    }

    public CartItem(int product_id, String image_url, String product_name, Double price, int quantity, int quantity_in_stock, int id) {
        this.product_id = product_id;
        this.image_url = image_url;
        this.product_name = product_name;
        this.price = price;
        this.quantity = quantity;
        this.quantity_in_stock = quantity_in_stock;
        this.id = id;
    }

    public int getProduct_id() {
        return product_id;
    }

    public void setProduct_id(int product_id) {
        this.product_id = product_id;
    }

    public String getImage_url() {
        return image_url;
    }

    public void setImage_url(String image_url) {
        this.image_url = image_url;
    }

    public String getProduct_name() {
        return product_name;
    }

    public void setProduct_name(String product_name) {
        this.product_name = product_name;
    }

    public Double getPrice() {
        return price;
    }

    public void setPrice(Double price) {
        this.price = price;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public int getQuantity_in_stock() {
        return quantity_in_stock;
    }

    public void setQuantity_in_stock(int quantity_in_stock) {
        this.quantity_in_stock = quantity_in_stock;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    @Override
    public String toString() {
        return "CartItem{" + "product_id=" + product_id + ", image_url=" + image_url + ", product_name=" + product_name + ", price=" + price + ", quantity=" + quantity + ", quantity_in_stock=" + quantity_in_stock + ", id=" + id + '}';
    }
    
    
}
