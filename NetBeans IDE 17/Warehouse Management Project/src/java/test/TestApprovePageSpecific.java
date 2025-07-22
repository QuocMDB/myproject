package test;

import java.util.List;
import dao.PurchaseOrderDAO;
import model.PurchaseOrderInfo;

public class TestApprovePageSpecific {
    
    public static void main(String[] args) {
        System.out.println("=== TEST APPROVE PAGE SPECIFIC ===");
        System.out.println("==================================");
        
        PurchaseOrderDAO dao = new PurchaseOrderDAO();
        
        // Test 1: Lấy đơn hàng cần approve (status = quoted)
        testOrdersNeedApproval(dao);
        
        // Test 2: Test approve/reject functionality
        testApproveRejectFunctionality(dao);
    }
    
    private static void testOrdersNeedApproval(PurchaseOrderDAO dao) {
        System.out.println("\n✅ TEST: Đơn hàng cần phê duyệt (status = 'quoted')");
        System.out.println("===================================================");
        
        try {
            List<PurchaseOrderInfo> quotedOrders = dao.getAllPurchaseOrders(1, null, null, "quoted", null);
            
            if (quotedOrders == null || quotedOrders.isEmpty()) {
                System.out.println("⚠️ Không có đơn hàng nào cần phê duyệt (status = 'quoted')");
                System.out.println("Để test approve page, bạn cần:");
                System.out.println("1. Có ít nhất 1 đơn hàng với status = 'quoted'");
                System.out.println("2. Đơn hàng đó phải có đầy đủ thông tin nhà cung cấp");
                System.out.println("3. Các items phải có giá (price_per_unit, total_price)");
            } else {
                System.out.println("✅ Tìm thấy " + quotedOrders.size() + " đơn hàng cần phê duyệt:");
                System.out.println();
                
                for (PurchaseOrderInfo order : quotedOrders) {
                    System.out.println("📋 Đơn hàng ID: " + order.getId());
                    System.out.println("   Người tạo: " + order.getFullname());
                    System.out.println("   Ngày tạo: " + order.getDayPurchase());
                    System.out.println("   Nhà cung cấp: " + order.getSupplier());
                    System.out.println("   Địa chỉ: " + order.getAddress());
                    System.out.println("   Điện thoại: " + order.getPhone());
                    System.out.println("   Email: " + order.getEmail());
                    System.out.println("   Số items: " + (order.getPurchaseItems() != null ? order.getPurchaseItems().size() : 0));
                    
                    // Kiểm tra xem có đủ thông tin để approve không
                    boolean readyToApprove = checkReadyToApprove(order);
                    System.out.println("   Sẵn sàng approve: " + (readyToApprove ? "✅ YES" : "❌ NO"));
                    System.out.println("   ─────────────────────────────────────");
                }
            }
            
        } catch (Exception e) {
            System.out.println("❌ Lỗi khi lấy đơn hàng cần approve: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    private static void testApproveRejectFunctionality(PurchaseOrderDAO dao) {
        System.out.println("\n🔄 TEST: Chức năng Approve/Reject");
        System.out.println("=================================");
        
        try {
            List<PurchaseOrderInfo> quotedOrders = dao.getAllPurchaseOrders(1, null, null, "quoted", null);
            
            if (quotedOrders != null && !quotedOrders.isEmpty()) {
                String testId = quotedOrders.get(0).getId();
                System.out.println("🧪 Test với đơn hàng ID: " + testId);
                
                // Test approve
                System.out.println("\n1. Test APPROVE:");
                boolean approveResult = dao.updatePurchaseOrderStatus(testId, "approved");
                System.out.println("   Kết quả: " + (approveResult ? "✅ Approved thành công" : "❌ Approve thất bại"));
                
                // Đợi 1 giây
                Thread.sleep(1000);
                
                // Test reject (chuyển về re-quote)
                System.out.println("\n2. Test REJECT:");
                boolean rejectResult = dao.updatePurchaseOrderStatus(testId, "re-quote");
                System.out.println("   Kết quả: " + (rejectResult ? "✅ Reject thành công" : "❌ Reject thất bại"));
                
                // Chuyển lại về quoted để test tiếp
                Thread.sleep(1000);
                dao.updatePurchaseOrderStatus(testId, "quoted");
                System.out.println("\n3. Đã chuyển lại về status 'quoted' để test tiếp");
                
            } else {
                System.out.println("⚠️ Không có đơn hàng nào để test approve/reject");
            }
            
        } catch (Exception e) {
            System.out.println("❌ Lỗi khi test approve/reject: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    private static boolean checkReadyToApprove(PurchaseOrderInfo order) {
        // Kiểm tra các điều kiện cần thiết để approve
        if (order.getSupplier() == null || order.getSupplier().trim().isEmpty()) {
            System.out.println("     ⚠️ Thiếu thông tin nhà cung cấp");
            return false;
        }
        
        if (order.getPurchaseItems() == null || order.getPurchaseItems().isEmpty()) {
            System.out.println("     ⚠️ Không có items");
            return false;
        }
        
        // Kiểm tra items có giá chưa
        for (var item : order.getPurchaseItems()) {
            if (item.getPricePerUnit() == null || item.getTotalPrice() == null) {
                System.out.println("     ⚠️ Item '" + item.getProductName() + "' chưa có giá");
                return false;
            }
        }
        
        return true;
    }
}
