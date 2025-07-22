/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

// Model for material unit entity
public class Unit {
    // Unique identifier for the unit
    private int id;
    // Name of the unit
    private String name;
    // Symbol of the unit (e.g., kg, m)
    private String symbol;
    
    public Unit() {
    }
    
    public Unit(int id, String name) {
        this.id = id;
        this.name = name;
    }
    
    public Unit(int id, String name, String symbol) {
        this.id = id;
        this.name = name;
        this.symbol = symbol;
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
    
    public String getSymbol() {
        return symbol;
    }
    
    public void setSymbol(String symbol) {
        this.symbol = symbol;
    }
}
