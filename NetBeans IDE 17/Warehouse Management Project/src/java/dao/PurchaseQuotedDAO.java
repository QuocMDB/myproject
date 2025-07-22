///*
// * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
// * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
// */
//package dao;
//
//import DBContext.Context;
//import java.sql.*;
//import java.text.ParseException;
//import java.text.SimpleDateFormat;
//import java.util.ArrayList;
//import java.util.List;
//import model.PurchaseOrderInfo;
//import model.PurchaseOrderItems;
//
///**
// *
// * @author Admin
// */
//public class PurchaseQuotedDAO {
//
//    /**
//     * Lấy danh sách Purchase Order đã được tạo kèm theo items Hỗ trợ phân trang
//     * và filter theo ngày, status, ID
//     */
//    public List<PurchaseOrderInfo> getAllPurchaseQuoted(int index, String startDateStr, String endDateStr, String statusFilter, String orderIdFilter) {
//        List<PurchaseOrderInfo> allPurchaseOrders = new ArrayList<>();
//
//        // BƯỚC 1: Lấy danh sách Purchase Order IDs với phân trang
//        // FIX: Thêm day_purchase vào SELECT để có thể ORDER BY
//        StringBuilder sqlOrderIds = new StringBuilder(
//                "SELECT DISTINCT p.id, p.day_purchase "
//                + "FROM purchase_order_info p "
//                + "WHERE 1=1 "
//        );
//
//        List<Object> params = new ArrayList<>();
//        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
//
//        try {
//            // Thêm các điều kiện filter
//            if (startDateStr != null && !startDateStr.isEmpty()) {
//                sqlOrderIds.append("AND p.day_purchase >= ? ");
//                params.add(sdf.parse(startDateStr));
//            }
//            if (endDateStr != null && !endDateStr.isEmpty()) {
//                sqlOrderIds.append("AND p.day_purchase <= ? ");
//                params.add(sdf.parse(endDateStr));
//            }
//            if (statusFilter != null && !statusFilter.isEmpty()) {
//                if (statusFilter.equals("pending") || statusFilter.equals("approved")
//                        || statusFilter.equals("rejected") || statusFilter.equals("completed")) {
//                    sqlOrderIds.append("AND p.status = ? ");
//                    params.add(statusFilter);
//                }
//            }
//            if (orderIdFilter != null && !orderIdFilter.isEmpty()) {
//                sqlOrderIds.append("AND p.id LIKE ? ");
//                params.add("%" + orderIdFilter.toUpperCase() + "%");
//            }
//
//            // Phân trang và sắp xếp
//            sqlOrderIds.append("ORDER BY p.day_purchase DESC, p.id DESC LIMIT ? OFFSET ?");
//            params.add(10);
//            params.add((index - 1) * 10);
//
//            // Debug logging
//            System.out.println("=== getAllPurchaseQuoted DEBUG ===");
//            System.out.println("SQL: " + sqlOrderIds.toString());
//
//            // Lấy danh sách Purchase Order IDs
//            List<String> orderIds = new ArrayList<>();
//            try (Connection con = Context.getJDBCConnection(); PreparedStatement stmt = con.prepareStatement(sqlOrderIds.toString())) {
//
//                for (int i = 0; i < params.size(); i++) {
//                    stmt.setObject(i + 1, params.get(i));
//                }
//
//                try (ResultSet rs = stmt.executeQuery()) {
//                    while (rs.next()) {
//                        orderIds.add(rs.getString("id"));
//                    }
//                }
//            }
//
//            System.out.println("Found " + orderIds.size() + " Purchase Order IDs");
//
//            // BƯỚC 2: Lấy chi tiết Purchase Order + Items trong một query
//            if (!orderIds.isEmpty()) {
//                StringBuilder sqlDetails = new StringBuilder(
//                        "SELECT p.id AS order_id, p.fullname, p.DoB, p.day_purchase, p.status, p.reason, p.supplier, "
//                        + "p.address, p.phone, p.email, p.summary, "
//                        + "pi.id AS item_id, pi.product_name, pi.product_code, pi.unit, pi.quantity, "
//                        + "pi.price_per_unit, pi.total_price, pi.note AS item_note "
//                        + "FROM purchase_order_info p "
//                        + "LEFT JOIN purchase_order_items pi ON p.id = pi.purchase_id "
//                        + "WHERE p.id IN ("
//                );
//
//                // Tạo placeholders cho IN clause
//                for (int i = 0; i < orderIds.size(); i++) {
//                    sqlDetails.append("?");
//                    if (i < orderIds.size() - 1) {
//                        sqlDetails.append(",");
//                    }
//                }
//                sqlDetails.append(") ORDER BY p.day_purchase DESC, p.id DESC, pi.id");
//
//                try (Connection con = Context.getJDBCConnection(); PreparedStatement stmt = con.prepareStatement(sqlDetails.toString())) {
//
//                    // Gán Purchase Order IDs vào prepared statement
//                    for (int i = 0; i < orderIds.size(); i++) {
//                        stmt.setString(i + 1, orderIds.get(i));
//                    }
//
//                    try (ResultSet rs = stmt.executeQuery()) {
//                        PurchaseOrderInfo currentOrder = null;
//                        while (rs.next()) {
//                            String orderId = rs.getString("order_id");
//
//                            // Tạo PurchaseOrderInfo object mới khi gặp order_id khác
//                            if (currentOrder == null || !currentOrder.getId().equals(orderId)) {
//                                currentOrder = new PurchaseOrderInfo();
//                                currentOrder.setId(orderId);
//                                currentOrder.setFullname(rs.getString("fullname"));
//                                currentOrder.setDoB(rs.getDate("DoB"));
//                                currentOrder.setDayPurchase(rs.getDate("day_purchase"));
//                                currentOrder.setStatus(rs.getString("status"));
//                                currentOrder.setReason(rs.getString("reason"));
//                                currentOrder.setSupplier(rs.getString("supplier"));
//                                currentOrder.setAddress(rs.getString("address"));
//                                currentOrder.setPhone(rs.getString("phone"));
//                                currentOrder.setEmail(rs.getString("email"));
//                                currentOrder.setSummary(rs.getString("summary"));
//                                currentOrder.setPurchaseItems(new ArrayList<>());
//                                allPurchaseOrders.add(currentOrder);
//                            }
//
//                            // Thêm item vào Purchase Order hiện tại (nếu có)
//                            if (rs.getObject("item_id") != null) {
//                                PurchaseOrderItems item = new PurchaseOrderItems();
//                                item.setId(rs.getInt("item_id"));
//                                item.setPurchaseId(orderId);
//                                item.setProductName(rs.getString("product_name"));
//                                item.setProductCode(rs.getString("product_code"));
//                                item.setUnit(rs.getString("unit"));
//                                item.setQuantity(rs.getBigDecimal("quantity"));
//                                item.setPricePerUnit(rs.getBigDecimal("price_per_unit"));
//                                item.setTotalPrice(rs.getBigDecimal("total_price"));
//                                item.setNote(rs.getString("item_note") != null ? rs.getString("item_note") : "");
//                                currentOrder.getPurchaseItems().add(item);
//                            }
//                        }
//                    }
//                }
//            }
//
//            System.out.println("✅ Total Purchase Orders loaded: " + allPurchaseOrders.size());
//            return allPurchaseOrders;
//
//        } catch (SQLException | ParseException e) {
//            System.err.println("Error in getAllPurchaseQuoted: " + e.getMessage());
//            e.printStackTrace();
//            return new ArrayList<>();
//        }
//    }
//
//    /**
//     * Đếm tổng số Purchase Order (để tính pagination)
//     */
//    public int getTotalFilteredPurchaseQuoted(String startDateStr, String endDateStr, String statusFilter, String orderIdFilter) {
//        StringBuilder sql = new StringBuilder(
//                "SELECT COUNT(DISTINCT p.id) FROM purchase_order_info p WHERE 1=1 "
//        );
//
//        List<Object> params = new ArrayList<>();
//        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
//
//        try {
//            // Áp dụng cùng logic filter như getAllPurchaseQuoted
//            if (startDateStr != null && !startDateStr.isEmpty()) {
//                sql.append("AND p.day_purchase >= ? ");
//                params.add(sdf.parse(startDateStr));
//            }
//            if (endDateStr != null && !endDateStr.isEmpty()) {
//                sql.append("AND p.day_purchase <= ? ");
//                params.add(sdf.parse(endDateStr));
//            }
//            if (statusFilter != null && !statusFilter.isEmpty()) {
//                if (statusFilter.equals("pending") || statusFilter.equals("approved")
//                        || statusFilter.equals("rejected") || statusFilter.equals("completed")) {
//                    sql.append("AND p.status = ? ");
//                    params.add(statusFilter);
//                }
//            }
//            if (orderIdFilter != null && !orderIdFilter.isEmpty()) {
//                sql.append("AND p.id LIKE ? ");
//                params.add("%" + orderIdFilter.toUpperCase() + "%");
//            }
//
//            // Debug logging
//            System.out.println("=== getTotalFilteredPurchaseQuoted DEBUG ===");
//            System.out.println("SQL: " + sql.toString());
//            System.out.println("Params: " + params);
//
//            try (Connection con = Context.getJDBCConnection(); PreparedStatement stmt = con.prepareStatement(sql.toString())) {
//
//                for (int i = 0; i < params.size(); i++) {
//                    stmt.setObject(i + 1, params.get(i));
//                }
//
//                try (ResultSet rs = stmt.executeQuery()) {
//                    if (rs.next()) {
//                        int count = rs.getInt(1);
//                        System.out.println("Total Purchase Orders count: " + count);
//                        return count;
//                    }
//                }
//            }
//        } catch (SQLException | ParseException e) {
//            System.err.println("Error in getTotalFilteredPurchaseQuoted: " + e.getMessage());
//            e.printStackTrace();
//        }
//        return 0;
//    }
//
//    /**
//     * Cập nhật trạng thái Purchase Order và đồng bộ với bảng Request Logic: -
//     * Nếu Purchase Order status = "approved" → Request status = "completed" -
//     * Nếu Purchase Order status = "rejected" → Request status = "pending
//     * re-quote"
//     */
//    public boolean updateStatus(String purchaseOrderId, String newPurchaseStatus) {
//        if (purchaseOrderId == null || purchaseOrderId.trim().isEmpty()
//                || newPurchaseStatus == null || newPurchaseStatus.trim().isEmpty()) {
//            System.err.println("Purchase Order ID or status is null/empty");
//            return false;
//        }
//
//        // Validate Purchase Order status
//        if (!newPurchaseStatus.equals("pending") && !newPurchaseStatus.equals("approved")
//                && !newPurchaseStatus.equals("rejected") && !newPurchaseStatus.equals("completed")) {
//            System.err.println("Invalid Purchase Order status: " + newPurchaseStatus);
//            return false;
//        }
//
//        // Xác định Request status tương ứng
//        String requestStatus = null;
//        if ("approved".equals(newPurchaseStatus)) {
//            requestStatus = "completed";
//        } else if ("rejected".equals(newPurchaseStatus)) {
//            requestStatus = "pending re-quote";
//        }
//        // Nếu status khác (pending, completed) thì không cập nhật Request
//
//        String updatePurchaseOrderSql = "UPDATE purchase_order_info SET status = ? WHERE id = ?";
//        String updateRequestSql = "UPDATE request SET status = ? WHERE id = ?";
//
//        try (Connection con = Context.getJDBCConnection()) {
//            con.setAutoCommit(false); // Bắt đầu transaction
//
//            try {
//                // BƯỚC 1: Cập nhật Purchase Order status
//                int purchaseOrderUpdated = 0;
//                try (PreparedStatement stmt1 = con.prepareStatement(updatePurchaseOrderSql)) {
//                    stmt1.setString(1, newPurchaseStatus);
//                    stmt1.setString(2, purchaseOrderId);
//                    purchaseOrderUpdated = stmt1.executeUpdate();
//                }
//
//                if (purchaseOrderUpdated == 0) {
//                    con.rollback();
//                    System.err.println("❌ Purchase Order not found: " + purchaseOrderId);
//                    return false;
//                }
//
//                System.out.println("✅ Purchase Order status updated: " + purchaseOrderId + " -> " + newPurchaseStatus);
//
//                // BƯỚC 2: Cập nhật Request status (nếu cần)
//                if (requestStatus != null) {
//                    try (PreparedStatement stmt2 = con.prepareStatement(updateRequestSql)) {
//                        stmt2.setString(1, requestStatus);
//                        stmt2.setString(2, purchaseOrderId); // Giả sử Purchase Order ID = Request ID
//                        int requestUpdated = stmt2.executeUpdate();
//
//                        if (requestUpdated > 0) {
//                            System.out.println("✅ Request status updated: " + purchaseOrderId + " -> " + requestStatus);
//                        } else {
//                            System.out.println("⚠️ Request not found or already updated: " + purchaseOrderId);
//                            // Không rollback vì Purchase Order đã được cập nhật thành công
//                        }
//                    }
//                }
//
//                con.commit(); // Commit transaction
//                return true;
//
//            } catch (SQLException e) {
//                con.rollback(); // Rollback nếu có lỗi
//                throw e;
//            }
//        } catch (SQLException e) {
//            System.err.println("Error in updateStatus: " + e.getMessage());
//            e.printStackTrace();
//            return false;
//        }
//    }
//
//    /**
//     * Cập nhật đơn báo giá đã tồn tại (khi báo giá lại) - Cập nhật thông tin
//     * Purchase Order - Cập nhật/thay thế tất cả items
//     */
//    public boolean updatePurchaseQuoted(PurchaseOrderInfo purchaseOrder) {
//        if (purchaseOrder == null || purchaseOrder.getId() == null || purchaseOrder.getId().trim().isEmpty()) {
//            System.err.println("PurchaseOrderInfo or ID is null/empty");
//            return false;
//        }
//
//        String updateOrderSql = "UPDATE purchase_order_info SET fullname = ?, DoB = ?, day_purchase = ?, "
//                + "reason = ?, supplier = ?, address = ?, phone = ?, email = ?, summary = ? WHERE id = ?";
//
//        String deleteItemsSql = "DELETE FROM purchase_order_items WHERE purchase_id = ?";
//
//        String insertItemSql = "INSERT INTO purchase_order_items (purchase_id, product_name, product_code, "
//                + "unit, quantity, price_per_unit, total_price, note) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
//
//        try (Connection con = Context.getJDBCConnection()) {
//            con.setAutoCommit(false); // Bắt đầu transaction
//
//            try {
//                // BƯỚC 1: Cập nhật thông tin Purchase Order
//                int orderUpdated = 0;
//                try (PreparedStatement stmt1 = con.prepareStatement(updateOrderSql)) {
//                    stmt1.setString(1, purchaseOrder.getFullname());
//                    stmt1.setDate(2, purchaseOrder.getDoB() != null ? new java.sql.Date(purchaseOrder.getDoB().getTime()) : null);
//                    stmt1.setDate(3, purchaseOrder.getDayPurchase() != null ? new java.sql.Date(purchaseOrder.getDayPurchase().getTime()) : null);
//                    stmt1.setString(4, purchaseOrder.getReason());
//                    stmt1.setString(5, purchaseOrder.getSupplier());
//                    stmt1.setString(6, purchaseOrder.getAddress());
//                    stmt1.setString(7, purchaseOrder.getPhone());
//                    stmt1.setString(8, purchaseOrder.getEmail());
//                    stmt1.setString(9, purchaseOrder.getSummary());
//                    stmt1.setString(10, purchaseOrder.getId());
//
//                    orderUpdated = stmt1.executeUpdate();
//                }
//
//                if (orderUpdated == 0) {
//                    con.rollback();
//                    System.err.println("❌ Purchase Order not found for update: " + purchaseOrder.getId());
//                    return false;
//                }
//
//                System.out.println("✅ Purchase Order info updated: " + purchaseOrder.getId());
//
//                // BƯỚC 2: Xóa tất cả items cũ
//                try (PreparedStatement stmt2 = con.prepareStatement(deleteItemsSql)) {
//                    stmt2.setString(1, purchaseOrder.getId());
//                    int itemsDeleted = stmt2.executeUpdate();
//                    System.out.println("🗑️ Deleted " + itemsDeleted + " old items for: " + purchaseOrder.getId());
//                }
//
//                // BƯỚC 3: Thêm items mới
//                if (purchaseOrder.getPurchaseItems() != null && !purchaseOrder.getPurchaseItems().isEmpty()) {
//                    try (PreparedStatement stmt3 = con.prepareStatement(insertItemSql)) {
//                        for (PurchaseOrderItems item : purchaseOrder.getPurchaseItems()) {
//                            stmt3.setString(1, purchaseOrder.getId());
//                            stmt3.setString(2, item.getProductName());
//                            stmt3.setString(3, item.getProductCode());
//                            stmt3.setString(4, item.getUnit());
//                            stmt3.setBigDecimal(5, item.getQuantity());
//                            stmt3.setBigDecimal(6, item.getPricePerUnit());
//                            stmt3.setBigDecimal(7, item.getTotalPrice());
//                            stmt3.setString(8, item.getNote());
//                            stmt3.addBatch();
//                        }
//
//                        int[] itemsInserted = stmt3.executeBatch();
//                        System.out.println("✅ Inserted " + itemsInserted.length + " new items for: " + purchaseOrder.getId());
//                    }
//                }
//
//                con.commit(); // Commit transaction
//                System.out.println("✅ updatePurchaseQuoted completed successfully for: " + purchaseOrder.getId());
//                return true;
//
//            } catch (SQLException e) {
//                con.rollback(); // Rollback nếu có lỗi
//                throw e;
//            }
//        } catch (SQLException e) {
//            System.err.println("Error in updatePurchaseQuoted: " + e.getMessage());
//            e.printStackTrace();
//            return false;
//        }
//    }
//
//    /**
//     * Cập nhật status khi báo giá lại cho đơn đã tồn tại - Purchase Order
//     * status: "rejected" → "pending" - Request status: "pending re-quote" →
//     * "quoted"
//     */
//    public boolean updateQuoteExistStatus(String orderId) {
//        if (orderId == null || orderId.trim().isEmpty()) {
//            System.err.println("Order ID is null or empty");
//            return false;
//        }
//
//        String updatePurchaseOrderSql = "UPDATE purchase_order_info SET status = 'pending' WHERE id = ?";
//        String updateRequestSql = "UPDATE request SET status = 'quoted' WHERE id = ?";
//
//        try (Connection con = Context.getJDBCConnection()) {
//            con.setAutoCommit(false); // Bắt đầu transaction
//
//            try {
//                // BƯỚC 1: Cập nhật Purchase Order status thành "pending"
//                int purchaseOrderUpdated = 0;
//                try (PreparedStatement stmt1 = con.prepareStatement(updatePurchaseOrderSql)) {
//                    stmt1.setString(1, orderId);
//                    purchaseOrderUpdated = stmt1.executeUpdate();
//                }
//
//                if (purchaseOrderUpdated == 0) {
//                    con.rollback();
//                    System.err.println("❌ Purchase Order not found: " + orderId);
//                    return false;
//                }
//
//                System.out.println("✅ Purchase Order status updated: " + orderId + " -> pending");
//
//                // BƯỚC 2: Cập nhật Request status thành "quoted"
//                try (PreparedStatement stmt2 = con.prepareStatement(updateRequestSql)) {
//                    stmt2.setString(1, orderId);
//                    int requestUpdated = stmt2.executeUpdate();
//
//                    if (requestUpdated > 0) {
//                        System.out.println("✅ Request status updated: " + orderId + " -> quoted");
//                    } else {
//                        System.out.println("⚠️ Request not found: " + orderId);
//                        // Không rollback vì Purchase Order đã được cập nhật thành công
//                    }
//                }
//
//                con.commit(); // Commit transaction
//                System.out.println("✅ updateQuoteExistStatus completed successfully for: " + orderId);
//                return true;
//
//            } catch (SQLException e) {
//                con.rollback(); // Rollback nếu có lỗi
//                throw e;
//            }
//        } catch (SQLException e) {
//            System.err.println("Error in updateQuoteExistStatus: " + e.getMessage());
//            e.printStackTrace();
//            return false;
//        }
//    }
//}
