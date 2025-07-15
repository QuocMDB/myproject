/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Models;

/**
 *
 * @author Fpt
 */
public class Categories {
    private int id;
    private String name;
    private String descrip;

    public Categories() {
    }

    public Categories(int id, String name, String descrip) {
        this.id = id;
        this.name = name;
        this.descrip = descrip;
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

    public String getDescrip() {
        return descrip;
    }

    public void setDescrip(String descrip) {
        this.descrip = descrip;
    }

    @Override
    public String toString() {
        return "Categories{" + "id=" + id + ", name=" + name + ", descrip=" + descrip + '}';
    }

    
    
    
}
