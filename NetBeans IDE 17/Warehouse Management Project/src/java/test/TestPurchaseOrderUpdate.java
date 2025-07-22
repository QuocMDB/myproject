package test;

import dao.PurchaseOrderDAO;
import model.PurchaseOrderInfo;
import model.PurchaseOrderItems;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

/**
 * Test class để kiểm tra việc cập nhật thông tin báo giá
 */
public class TestPurchaseOrderUpdate {
    
    private PurchaseOrderDAO dao;
    private SimpleDateFormat sdf;
    
    public TestPurchaseOrderUpdate() {
        dao = new PurchaseOrderDAO();
        sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    }
    
    /**
     * Test cập nhật thông tin purchase order info
     */
    public void testUpdatePurchaseOrderInfo() {
        System.out.println("\n=== TEST UPDATE PURCHASE ORDER INFO ===");
        
        String testId = "PO001"; // Thay bằng ID thực tế có trong DB
        Date quoteDate = new Date(); // Ngày hiện tại
        String supplier = "Công ty TNHH ABC";
        String address = "123 Đường Nguyễn Văn A, Quận 1, TP.HCM";
        String phone = "0901234567";
        String email = "abc@company.com";
        String summary = "Báo giá cho các sản phẩm văn phòng phẩm theo yêu cầu";
        
        System.out.println("🔍 Testing with ID: " + testId);
        System.out.println("🔍 Quote Date: " + sdf.format(quoteDate));
        System.out.println("🔍 Supplier: " + supplier);
        
        boolean result = dao.updatePurchaseOrderInfo(testId, (java.sql.Date) quoteDate, supplier, address, phone, email, summary);
        
        if (result) {
            System.out.println("✅ UPDATE PURCHASE ORDER INFO: SUCCESS");
        } else {
            System.out.println("❌ UPDATE PURCHASE ORDER INFO: FAILED");
        }
    }
    
    /**
     * Test cập nhật giá cho items
     */
    public void testUpdatePurchaseOrderItems() {
        System.out.println("\n=== TEST UPDATE PURCHASE ORDER ITEMS ===");
        
        String testId = "PO001"; // Thay bằng ID thực tế
        
        // Giả lập dữ liệu items (thay bằng dữ liệu thực tế)
        String[] productCodes = {"SP001", "SP002", "SP003"};
        BigDecimal[] pricesPerUnit = {
            new BigDecimal("15000"), 
            new BigDecimal("25000"), 
            new BigDecimal("50000")
        };
        BigDecimal[] totalPrices = {
            new BigDecimal("150000"), 
            new BigDecimal("500000"), 
            new BigDecimal("100000")
        };
        String[] notes = {
            "Bút bi xanh chất lượng cao", 
            "Giấy A4 loại 1", 
            "Thước kẻ nhựa trong"
        };
        
        boolean allSuccess = true;
        
        for (int i = 0; i < productCodes.length; i++) {
            System.out.println("🔍 Updating item: " + productCodes[i] + 
                             " - Price: " + pricesPerUnit[i] + 
                             " - Total: " + totalPrices[i]);
            
            boolean result = dao.updatePurchaseOrderItem(
                testId, 
                productCodes[i], 
                pricesPerUnit[i], 
                totalPrices[i], 
                notes[i]
            );
            
            if (!result) {
                allSuccess = false;
                System.out.println("❌ Failed to update item: " + productCodes[i]);
            } else {
                System.out.println("✅ Successfully updated item: " + productCodes[i]);
            }
        }
        
        if (allSuccess) {
            System.out.println("✅ UPDATE ALL ITEMS: SUCCESS");
        } else {
            System.out.println("❌ UPDATE SOME ITEMS: FAILED");
        }
    }
    
    /**
     * Test cập nhật status
     */
    public void testUpdateStatus() {
        System.out.println("\n=== TEST UPDATE STATUS ===");
        
        String testId = "PO001";
        String newStatus = "quoted";
        
        System.out.println("🔍 Updating status to: " + newStatus + " for ID: " + testId);
        
        boolean result = dao.updatePurchaseOrderStatus(testId, newStatus);
        
        if (result) {
            System.out.println("✅ UPDATE STATUS: SUCCESS");
        } else {
            System.out.println("❌ UPDATE STATUS: FAILED");
        }
    }
    
    /**
     * Test lấy thông tin purchase order để verify
     */
    public void testGetPurchaseOrderById() {
        System.out.println("\n=== TEST GET PURCHASE ORDER BY ID ===");
        
        String testId = "PO001";
        
        System.out.println("🔍 Getting purchase order with ID: " + testId);
        
        PurchaseOrderInfo po = dao.getPurchaseOrderById(testId);
        
        if (po != null) {
            System.out.println("✅ FOUND PURCHASE ORDER:");
            System.out.println("   ID: " + po.getId());
            System.out.println("   Fullname: " + po.getFullname());
            System.out.println("   Day Purchase: " + (po.getDayPurchase() != null ? sdf.format(po.getDayPurchase()) : "null"));
            System.out.println("   Day Quote: " + (po.getDayQuote() != null ? sdf.format(po.getDayQuote()) : "null"));
            System.out.println("   Status: " + po.getStatus());
            System.out.println("   Reason: " + po.getReason());
            System.out.println("   Supplier: " + po.getSupplier());
            System.out.println("   Address: " + po.getAddress());
            System.out.println("   Phone: " + po.getPhone());
            System.out.println("   Email: " + po.getEmail());
            System.out.println("   Summary: " + po.getSummary());
            
            List<PurchaseOrderItems> items = po.getPurchaseItems();
            if (items != null && !items.isEmpty()) {
                System.out.println("   ITEMS (" + items.size() + "):");
                for (PurchaseOrderItems item : items) {
                    System.out.println("     - " + item.getProductCode() + ": " + item.getProductName());
                    System.out.println("       Unit: " + item.getUnit() + ", Quantity: " + item.getQuantity());
                    System.out.println("       Price/Unit: " + item.getPricePerUnit() + ", Total: " + item.getTotalPrice());
                    System.out.println("       Note: " + item.getNote());
                }
            } else {
                System.out.println("   No items found");
            }
        } else {
            System.out.println("❌ PURCHASE ORDER NOT FOUND");
        }
    }
    
    /**
     * Test toàn bộ flow như form submit
     */
    public void testCompleteQuoteFlow() {
        System.out.println("\n=== TEST COMPLETE QUOTE FLOW ===");
        
        String testId = "PO001"; // Thay bằng ID thực tế
        
        try {
            // 1. Cập nhật thông tin cơ bản
            Date quoteDate = new Date();
            String supplier = "Nhà Cung Cấp Test";
            String address = "Địa chỉ test";
            String phone = "0123456789";
            String email = "test@supplier.com";
            String summary = "Tổng kết báo giá test";
            
            boolean step1 = dao.updatePurchaseOrderInfo(testId, (java.sql.Date) quoteDate, supplier, address, phone, email, summary);
            System.out.println("Step 1 - Update Info: " + (step1 ? "✅ SUCCESS" : "❌ FAILED"));
            
            // 2. Cập nhật items (giả lập dữ liệu)
            String[] codes = {"SP001", "SP002"};
            BigDecimal[] prices = {new BigDecimal("10000"), new BigDecimal("20000")};
            BigDecimal[] totals = {new BigDecimal("100000"), new BigDecimal("400000")};
            String[] notes = {"Note 1", "Note 2"};
            
            boolean step2 = true;
            for (int i = 0; i < codes.length; i++) {
                boolean itemResult = dao.updatePurchaseOrderItem(testId, codes[i], prices[i], totals[i], notes[i]);
                if (!itemResult) step2 = false;
            }
            System.out.println("Step 2 - Update Items: " + (step2 ? "✅ SUCCESS" : "❌ FAILED"));
            
            // 3. Cập nhật status
            boolean step3 = dao.updatePurchaseOrderStatus(testId, "quoted");
            System.out.println("Step 3 - Update Status: " + (step3 ? "✅ SUCCESS" : "❌ FAILED"));
            
            // 4. Verify kết quả
            System.out.println("\n--- VERIFICATION ---");
            PurchaseOrderInfo result = dao.getPurchaseOrderById(testId);
            if (result != null) {
                System.out.println("✅ Final Status: " + result.getStatus());
                System.out.println("✅ Final Supplier: " + result.getSupplier());
                System.out.println("✅ Final Quote Date: " + (result.getDayQuote() != null ? sdf.format(result.getDayQuote()) : "null"));
                
                if (result.getPurchaseItems() != null) {
                    System.out.println("✅ Items with prices:");
                    for (PurchaseOrderItems item : result.getPurchaseItems()) {
                        System.out.println("   " + item.getProductCode() + ": " + item.getPricePerUnit() + " VND");
                    }
                }
            }
            
            if (step1 && step2 && step3) {
                System.out.println("\n🎉 COMPLETE FLOW TEST: SUCCESS");
            } else {
                System.out.println("\n❌ COMPLETE FLOW TEST: SOME STEPS FAILED");
            }
            
        } catch (Exception e) {
            System.out.println("❌ COMPLETE FLOW TEST: EXCEPTION - " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    /**
     * Main method để chạy test
     */
    public static void main(String[] args) {
        System.out.println("🚀 STARTING PURCHASE ORDER UPDATE TESTS");
        System.out.println("==========================================");
        
        TestPurchaseOrderUpdate test = new TestPurchaseOrderUpdate();
        
        // Chạy từng test
        test.testGetPurchaseOrderById(); // Xem dữ liệu hiện tại
        test.testUpdatePurchaseOrderInfo(); // Test update info
        test.testUpdatePurchaseOrderItems(); // Test update items
        test.testUpdateStatus(); // Test update status
        test.testGetPurchaseOrderById(); // Xem dữ liệu sau khi update
        
        // Test toàn bộ flow
        test.testCompleteQuoteFlow();
        
        System.out.println("\n==========================================");
        System.out.println("🏁 TESTS COMPLETED");
    }
}
