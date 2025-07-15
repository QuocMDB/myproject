/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Models;

/**
 *
 * @author Fpt
 */
public class Products {
    private int id;
    private String name;
    private String description;
    private double price;
    private int category_id;
    private String image_url;
    private int quantity_in_stock;
    private int quantity_sold;

    public Products() {
    }

    public Products(int id, String name, String description, double price, int category_id, String image_url, int quantity_in_stock, int quantity_sold) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.price = price;
        this.category_id = category_id;
        this.image_url = image_url;
        this.quantity_in_stock = quantity_in_stock;
        this.quantity_sold = quantity_sold;
    }

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

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public int getCategory_id() {
        return category_id;
    }

    public void setCategory_id(int category_id) {
        this.category_id = category_id;
    }

    public String getImage_url() {
        return image_url;
    }

    public void setImage_url(String image_url) {
        this.image_url = image_url;
    }

    public int getQuantity_in_stock() {
        return quantity_in_stock;
    }

    public void setQuantity_in_stock(int quantity_in_stock) {
        this.quantity_in_stock = quantity_in_stock;
    }

    public int getQuantity_sold() {
        return quantity_sold;
    }

    public void setQuantity_sold(int quantity_sold) {
        this.quantity_sold = quantity_sold;
    }

    @Override
    public String toString() {
        return "Products{" + "id=" + id + ", name=" + name + ", description=" + description + ", price=" + price + ", category_id=" + category_id + ", image_url=" + image_url + ", quantity_in_stock=" + quantity_in_stock + ", quantity_sold=" + quantity_sold + '}';
    }


}
