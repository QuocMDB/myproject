package test;

import dao.PurchaseOrderDAO;
import java.math.BigDecimal;
import java.sql.Date; // ✅ Import java.sql.Date thay vì java.util.Date

/**
 * Test nhanh cho việc cập nhật báo giá
 */
public class QuickPurchaseOrderTest {
    
    public static void main(String[] args) {
        System.out.println("🧪 QUICK TEST - Purchase Order Update");
        
        PurchaseOrderDAO dao = new PurchaseOrderDAO();
        
        String testPurchaseOrderId = "NK1-042";
        
        System.out.println("Testing with Purchase Order ID: " + testPurchaseOrderId);
        
        // Test 1: Cập nhật thông tin cơ bản
        System.out.println("\n--- Test 1: Update Basic Info ---");
        
        // ✅ Tạo java.sql.Date thay vì java.util.Date
        Date quoteDate = new Date(System.currentTimeMillis());
        
        boolean test1 = dao.updatePurchaseOrderInfo(
            testPurchaseOrderId,
            quoteDate, // Sử dụng java.sql.Date
            "Công ty Test ABC",
            "123 Test Street, Test City",
            "0901234567",
            "test@company.com",
            "Đây là tổng kết báo giá test cho đơn NK1-042"
        );
        System.out.println("Result: " + (test1 ? "✅ SUCCESS" : "❌ FAILED"));
        
        // Test 2: Cập nhật một item
        System.out.println("\n--- Test 2: Update Item Price ---");
        boolean test2 = dao.updatePurchaseOrderItem(
            testPurchaseOrderId,
            "m01",
            new BigDecimal("25000"), // Giá 25,000 VND
            new BigDecimal("250000"), // Tổng 250,000 VND
            "Ghi chú test cho sản phẩm m01"
        );
        System.out.println("Result: " + (test2 ? "✅ SUCCESS" : "❌ FAILED"));
        
        // Test 3: Cập nhật status
        System.out.println("\n--- Test 3: Update Status ---");
        boolean test3 = dao.updatePurchaseOrderStatus(testPurchaseOrderId, "quoted");
        System.out.println("Result: " + (test3 ? "✅ SUCCESS" : "❌ FAILED"));
        
        // Test 4: Verify - lấy lại dữ liệu để kiểm tra
        System.out.println("\n--- Test 4: Verify Results ---");
        var result = dao.getPurchaseOrderById(testPurchaseOrderId);
        if (result != null) {
            System.out.println("✅ Found Purchase Order NK1-042:");
            System.out.println("   Status: " + result.getStatus());
            System.out.println("   Supplier: " + result.getSupplier());
            System.out.println("   Phone: " + result.getPhone());
            System.out.println("   Email: " + result.getEmail());
            System.out.println("   Summary: " + result.getSummary());
            System.out.println("   Quote Date: " + result.getDayQuote());
            System.out.println("   Items count: " + (result.getPurchaseItems() != null ? result.getPurchaseItems().size() : 0));
            
            if (result.getPurchaseItems() != null) {
                result.getPurchaseItems().forEach(item -> {
                    System.out.println("   Item: " + item.getProductCode() + 
                                     " - Name: " + item.getProductName() +
                                     " - Price: " + item.getPricePerUnit() + 
                                     " - Total: " + item.getTotalPrice() +
                                     " - Note: " + item.getNote());
                });
            }
        } else {
            System.out.println("❌ Purchase Order NK1-042 not found!");
        }
        
        System.out.println("\n🏁 Quick test completed for NK1-042!");
    }
}
