package test;

import dao.GetExportRequestWithItemsDAO;
import model.ExportRequest;
import model.ExportRequestItem;
import java.sql.Date;
import java.util.List;

public class TestExportRequestDAO {
    
    public static void main(String[] args) {
        System.out.println("=== TESTING EXPORT REQUEST DAO WITH FULLNAME ===\n");
        
        GetExportRequestWithItemsDAO dao = new GetExportRequestWithItemsDAO();
        
        // Test 1: Lấy tất cả requests (trang 1, 10 items)
        System.out.println("TEST 1: Lấy tất cả export requests với fullname");
        System.out.println("-".repeat(50));
        
        List<ExportRequest> allRequests = dao.getFilteredExportRequests(null, null, null, null, 1, 10);
        
        if (allRequests.isEmpty()) {
            System.out.println("Không có export request nào trong database!");
        } else {
            System.out.println("Tìm thấy " + allRequests.size() + " export requests:");
            
            for (ExportRequest request : allRequests) {
                System.out.println("\n--- Export Request ---");
                System.out.println("ID: " + request.getId());
                System.out.println("User ID: " + request.getUser_id());
                System.out.println("Họ tên người yêu cầu: " + request.getRequester_name()); // *** KIỂM TRA FULLNAME ***
                System.out.println("Status: " + request.getStatus());
                System.out.println("Role: " + request.getRole());
                System.out.println("Ngày yêu cầu: " + request.getDay_request());
                System.out.println("Lý do: " + request.getReason());
                
                if (request.getItems() != null && !request.getItems().isEmpty()) {
                    System.out.println("Items (" + request.getItems().size() + "):");
                    for (ExportRequestItem item : request.getItems()) {
                        System.out.println("  - " + item.getProduct_name() + 
                                         " (Code: " + item.getProduct_code() + 
                                         ", Qty: " + item.getQuantity() + 
                                         " " + item.getUnit() + ")");
                    }
                } else {
                    System.out.println("Không có items");
                }
            }
        }
        
        // Test 2: Test với filter status
        System.out.println("\n" + "=".repeat(60));
        System.out.println("TEST 2: Lấy export requests với status = 'pending'");
        System.out.println("-".repeat(50));
        
        List<ExportRequest> pendingRequests = dao.getFilteredExportRequests(null, null, "pending", null, 1, 5);
        System.out.println("Tìm thấy " + pendingRequests.size() + " pending requests");
        
        for (ExportRequest request : pendingRequests) {
            System.out.println("ID: " + request.getId() + 
                             " | Họ tên: " + request.getRequester_name() + 
                             " | Status: " + request.getStatus());
        }
        
        // Test 3: Test count function
        System.out.println("\n" + "=".repeat(60));
        System.out.println("TEST 3: Đếm tổng số export requests");
        System.out.println("-".repeat(50));
        
        int totalCount = dao.getTotalFilteredExportRequests(null, null, null, null);
        System.out.println("Tổng số export requests: " + totalCount);
        
        int pendingCount = dao.getTotalFilteredExportRequests(null, null, "pending", null);
        System.out.println("Tổng số pending requests: " + pendingCount);
        
        // Test 4: Test với date range
        System.out.println("\n" + "=".repeat(60));
        System.out.println("TEST 4: Test với date range (30 ngày gần đây)");
        System.out.println("-".repeat(50));
        
        // Lấy requests trong 30 ngày gần đây
        Date endDate = new Date(System.currentTimeMillis());
        Date startDate = new Date(System.currentTimeMillis() - (30L * 24 * 60 * 60 * 1000)); // 30 days ago
        
        List<ExportRequest> recentRequests = dao.getFilteredExportRequests(startDate, endDate, null, null, 1, 10);
        System.out.println("Tìm thấy " + recentRequests.size() + " requests trong 30 ngày gần đây");
        
        for (ExportRequest request : recentRequests) {
            System.out.println("ID: " + request.getId() + 
                             " | Họ tên: " + request.getRequester_name() + 
                             " | Ngày: " + request.getDay_request());
        }
        
        // Test 5: Kiểm tra fallback logic (fullname -> username -> Unknown User)
        System.out.println("\n" + "=".repeat(60));
        System.out.println("TEST 5: Kiểm tra logic fallback cho tên người dùng");
        System.out.println("-".repeat(50));
        
        for (ExportRequest request : allRequests) {
            String requesterName = request.getRequester_name();
            System.out.println("Request ID: " + request.getId() + 
                             " | User ID: " + request.getUser_id() + 
                             " | Tên hiển thị: " + requesterName);
            
            // Phân tích loại tên được hiển thị
            if ("Unknown User".equals(requesterName)) {
                System.out.println("  → User không tồn tại trong database");
            } else if (requesterName != null && requesterName.length() > 0) {
                System.out.println("  → Hiển thị fullname (hoặc fallback username)");
            }
        }
        
        System.out.println("\n" + "=".repeat(60));
        System.out.println("TESTING COMPLETED!");
        System.out.println("Kiểm tra xem có hiển thị fullname thay vì username không!");
        System.out.println("=".repeat(60));
    }
}
