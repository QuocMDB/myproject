/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Date;

/**
 *
 * @author Fpt06
 */
public class SupplierEvaluation {

    private int supplierEvaluationID;
    private Supplier supplierID;
    private Users userID;
    private int expectedDeliveryTime;
    private int productQuality;
    private int marketPriceComparison;
    private int transparencyReputation;
    private int serviceQuality;
    private String comment;
    private float avgRate;
    private Date commentTime;
    private int editCount;

    public SupplierEvaluation() {
    }

    public SupplierEvaluation(int supplierEvaluationID, Supplier supplierID, Users userID, int expectedDeliveryTime, int productQuality, int marketPriceComparison, int transparencyReputation, int serviceQuality, String comment, float avgRate, Date commentTime, int editCount) {
        this.supplierEvaluationID = supplierEvaluationID;
        this.supplierID = supplierID;
        this.userID = userID;
        this.expectedDeliveryTime = expectedDeliveryTime;
        this.productQuality = productQuality;
        this.marketPriceComparison = marketPriceComparison;
        this.transparencyReputation = transparencyReputation;
        this.serviceQuality = serviceQuality;
        this.comment = comment;
        this.avgRate = avgRate;
        this.commentTime = commentTime;
        this.editCount = editCount;
    }

    public int getSupplierEvaluationID() {
        return supplierEvaluationID;
    }

    public void setSupplierEvaluationID(int supplierEvaluationID) {
        this.supplierEvaluationID = supplierEvaluationID;
    }

    public Supplier getSupplierID() {
        return supplierID;
    }

    public void setSupplierID(Supplier supplierID) {
        this.supplierID = supplierID;
    }

    public Users getUserID() {
        return userID;
    }

    public void setUserID(Users userID) {
        this.userID = userID;
    }

    public int getExpectedDeliveryTime() {
        return expectedDeliveryTime;
    }

    public void setExpectedDeliveryTime(int expectedDeliveryTime) {
        this.expectedDeliveryTime = expectedDeliveryTime;
    }

    public int getProductQuality() {
        return productQuality;
    }

    public void setProductQuality(int productQuality) {
        this.productQuality = productQuality;
    }

    public int getMarketPriceComparison() {
        return marketPriceComparison;
    }

    public void setMarketPriceComparison(int marketPriceComparison) {
        this.marketPriceComparison = marketPriceComparison;
    }

    public int getTransparencyReputation() {
        return transparencyReputation;
    }

    public void setTransparencyReputation(int transparencyReputation) {
        this.transparencyReputation = transparencyReputation;
    }

    public int getServiceQuality() {
        return serviceQuality;
    }

    public void setServiceQuality(int serviceQuality) {
        this.serviceQuality = serviceQuality;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public float getAvgRate() {
        return avgRate;
    }

    public void setAvgRate(float avgRate) {
        this.avgRate = avgRate;
    }

    public Date getCommentTime() {
        return commentTime;
    }

    public void setCommentTime(Date commentTime) {
        this.commentTime = commentTime;
    }

    public int getEditCount() {
        return editCount;
    }

    public void setEditCount(int editCount) {
        this.editCount = editCount;
    }

    @Override
    public String toString() {
        return "SupplierEvaluation{" + "supplierEvaluationID=" + supplierEvaluationID + ", supplierID=" + supplierID + ", userID=" + userID + ", expectedDeliveryTime=" + expectedDeliveryTime + ", productQuality=" + productQuality + ", marketPriceComparison=" + marketPriceComparison + ", transparencyReputation=" + transparencyReputation + ", serviceQuality=" + serviceQuality + ", comment=" + comment + ", avgRate=" + avgRate + ", commentTime=" + commentTime + ", editCount=" + editCount + '}';
    }

}
