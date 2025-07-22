package controller;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.ArrayList;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import dao.CategoryStatisticsDAO;
import model.Users;
import com.google.gson.Gson;
import java.util.HashMap;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class CategoryStatisticsController extends HttpServlet {
    
    private CategoryStatisticsDAO statisticsDAO;
    private Gson gson;
    
    @Override
    public void init() throws ServletException {
        System.out.println("=== CategoryStatisticsController INIT ===");
        statisticsDAO = new CategoryStatisticsDAO();
        gson = new Gson();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        System.out.println("=== CategoryStatisticsController doGet called ===");
        System.out.println("Request method: " + request.getMethod());
        System.out.println("Action parameter: " + request.getParameter("action"));
        
        // Check authentication
        Users user = (Users) request.getSession().getAttribute("user");
        if (user == null || (!"Admin".equals(user.getRoleName()) && !"Nhân viên kho".equals(user.getRoleName()))) {
            System.out.println("User not authenticated, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        // Set encoding
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        try {
            System.out.println("Loading category statistics data...");
            
            // Check if this is an AJAX request for filtered data
            String action = request.getParameter("action");
            
            if ("filter".equals(action)) {
                System.out.println("Processing filter request...");
                handleFilterRequest(request, response);
                return;
            }
            
            // Load all statistics data for initial page load
            loadStatisticsData(request);
            
            // Forward to JSP at root level
            System.out.println("Forwarding to: /category-statistics.jsp");
            request.getRequestDispatcher("/category-statistics.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.out.println("ERROR in doGet: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi khi tải dữ liệu thống kê: " + e.getMessage());
            request.getRequestDispatcher("/category-statistics.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        System.out.println("=== CategoryStatisticsController doPost called ===");
        
        // Check if this is an AJAX filter request
        String action = request.getParameter("action");
        if ("filter".equals(action)) {
            // Check authentication first
            Users user = (Users) request.getSession().getAttribute("user");
            if (user == null || (!"Admin".equals(user.getRoleName()) && !"Nhân viên kho".equals(user.getRoleName()))) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                Map<String, Object> result = new HashMap<>();
                result.put("success", false);
                result.put("message", "Phiên làm việc đã hết hạn");
                response.getWriter().write(gson.toJson(result));
                return;
            }
            
            handleFilterRequest(request, response);
            return;
        }
        
        // For other POST requests, delegate to doGet
        doGet(request, response);
    }
    
    /**
     * Handle AJAX filter requests
     */
    private void handleFilterRequest(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        // Set response type and encoding FIRST
        response.setContentType("application/json; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        Map<String, Object> result = new HashMap<>();
        
        try {
            String startDate = request.getParameter("startDate");
            String endDate = request.getParameter("endDate");
            String status = request.getParameter("status");
            String parentId = request.getParameter("parentId");
            
            System.out.println("Filter request - Start: " + startDate + ", End: " + endDate + 
                             ", Status: " + status + ", ParentId: " + parentId);
            
            // Validate dates
            if (startDate != null && endDate != null && !startDate.isEmpty() && !endDate.isEmpty()) {
                LocalDate start = LocalDate.parse(startDate);
                LocalDate end = LocalDate.parse(endDate);
                
                if (start.isAfter(end)) {
                    result.put("success", false);
                    result.put("message", "Ngày bắt đầu phải trước ngày kết thúc");
                } else {
                    // Get filtered statistics
                    Map<String, Object> filteredStats = statisticsDAO.getFilteredStatistics(status, parentId, startDate, endDate);
                    
                    if (filteredStats == null) {
                        filteredStats = new HashMap<>();
                        filteredStats.put("totalCategories", 0);
                        filteredStats.put("activeCategories", 0);
                        filteredStats.put("inactiveCategories", 0);
                    }
                    
                    result.put("success", true);
                    result.put("data", filteredStats);
                    result.put("message", "Đã lọc dữ liệu thành công. Tìm thấy " + 
                              filteredStats.getOrDefault("totalCategories", 0) + " loại sản phẩm trong khoảng thời gian này.");
                    
                    System.out.println("Filter result: " + filteredStats);
                }
            } else {
                result.put("success", false);
                result.put("message", "Vui lòng chọn khoảng thời gian");
            }
            
        } catch (Exception e) {
            System.out.println("Error in handleFilterRequest: " + e.getMessage());
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "Lỗi khi lọc dữ liệu: " + e.getMessage());
        }
        
        // Write response
        String jsonResponse = gson.toJson(result);
        System.out.println("Sending JSON response: " + jsonResponse);
        
        response.getWriter().write(jsonResponse);
        response.getWriter().flush();
    }
    
    /**
     * Load all statistics data
     */
    private void loadStatisticsData(HttpServletRequest request) {
        try {
            System.out.println("Getting category statistics from DAO...");
            
            // 1. Get basic statistics
            Map<String, Object> basicStats = statisticsDAO.getBasicStatistics();
            
            int totalCategories = (int) basicStats.getOrDefault("totalCategories", 0);
            int activeCategories = (int) basicStats.getOrDefault("activeCategories", 0);
            int inactiveCategories = (int) basicStats.getOrDefault("inactiveCategories", 0);
            
            // Create stats map for JSP compatibility
            Map<String, Integer> stats = new HashMap<>();
            stats.put("totalCategories", totalCategories);
            stats.put("activeCategories", activeCategories);
            stats.put("inactiveCategories", inactiveCategories);
            request.setAttribute("stats", stats);
            
            // 2. Get percentage statistics
            Map<String, Double> percentages = statisticsDAO.getPercentageStatistics();
            request.setAttribute("activePercentage", String.format("%.1f", percentages.getOrDefault("activePercentage", 0.0)));
            request.setAttribute("inactivePercentage", String.format("%.1f", percentages.getOrDefault("inactivePercentage", 0.0)));
            
            // 3. Get category with most products (SỬ DỤNG PHƯƠNG THỨC MỚI)
            Map<String, Object> topCategory = statisticsDAO.getCategoryWithMostProducts();
            request.setAttribute("topCategory", topCategory);
            
            // 4. Get most recently added category (THÊM MỚI)
            
            // 5. Get monthly growth
            Map<String, Integer> monthlyGrowth = statisticsDAO.getMonthlyGrowth();
            int monthlyDifference = monthlyGrowth.getOrDefault("difference", 0);
            request.setAttribute("monthlyDifference", Math.abs(monthlyDifference));
            request.setAttribute("monthlyDifferenceSign", monthlyDifference >= 0 ? "+" : "");
            
            // 6. Get time-based statistics
            Map<String, Object> timeStats = statisticsDAO.getTimeBasedStatistics();
            if (timeStats == null) {
                timeStats = new HashMap<>();
                timeStats.put("thisMonth", 0);
                timeStats.put("thisQuarter", 0);
                timeStats.put("lastSixMonths", 0);
                timeStats.put("thisYear", 0);
                timeStats.put("currentYear", LocalDate.now().getYear());
                timeStats.put("thisMonthPeriod", "Tháng " + LocalDate.now().getMonthValue() + "/" + LocalDate.now().getYear());
                timeStats.put("thisQuarterPeriod", "Quý " + ((LocalDate.now().getMonthValue() - 1) / 3 + 1) + "/" + LocalDate.now().getYear());
                timeStats.put("lastSixMonthsPeriod", 
                    LocalDate.now().minusMonths(6).format(DateTimeFormatter.ofPattern("MM/yyyy")) + " - " + 
                    LocalDate.now().format(DateTimeFormatter.ofPattern("MM/yyyy")));
            }
            request.setAttribute("timeStats", timeStats);
            
            // 7. Get recently added categories with statistics (SỬ DỤNG PHƯƠNG THỨC MỚI)
            List<Map<String, Object>> recentCategories = statisticsDAO.getRecentCategoriesWithStats(5);
            if (recentCategories == null) recentCategories = new ArrayList<>();
            request.setAttribute("recentCategories", recentCategories);
            
            // 8. Get top categories by product count
            List<Map<String, Object>> topCategoriesByProducts = statisticsDAO.getTopCategoriesByProducts(10);
            if (topCategoriesByProducts == null) topCategoriesByProducts = new ArrayList<>();
            request.setAttribute("topCategoriesByProducts", topCategoriesByProducts);
            
            
            // Calculate totals for summary row
            int totalCategoryCount = 0;
            int totalActiveCount = 0;
            int totalInactiveCount = 0;
            int totalProductCount = 0;
            
            
            request.setAttribute("totalCategoryCount", totalCategoryCount);
            request.setAttribute("totalActiveCount", totalActiveCount);
            request.setAttribute("totalInactiveCount", totalInactiveCount);
            request.setAttribute("totalProductCount", totalProductCount);
            
            // 13. Get category statistics summary (THÊM MỚI - Tổng hợp tất cả)
            Map<String, Object> categoryStatsSummary = statisticsDAO.getCategoryStatisticsSummary();
            request.setAttribute("categoryStatsSummary", categoryStatsSummary);
            
            // 14. Add current date info for display
            LocalDate currentDate = LocalDate.now();
            request.setAttribute("currentMonth", currentDate.getMonth().toString());
            request.setAttribute("currentYear", currentDate.getYear());
            
            System.out.println("Category statistics data loaded successfully");
            System.out.println("Total categories: " + totalCategories);
            System.out.println("Active categories: " + activeCategories);
            System.out.println("Inactive categories: " + inactiveCategories);
            System.out.println("Top category: " + topCategory);
            System.out.println("Time stats loaded: " + timeStats);
            
        } catch (Exception e) {
            System.out.println("ERROR in loadStatisticsData: " + e.getMessage());
            e.printStackTrace();
            
            // Set default values to prevent JSP errors
            Map<String, Integer> emptyStats = new HashMap<>();
            emptyStats.put("totalCategories", 0);
            emptyStats.put("activeCategories", 0);
            emptyStats.put("inactiveCategories", 0);
            request.setAttribute("stats", emptyStats);
            
            Map<String, Object> emptyTopCategory = new HashMap<>();
            emptyTopCategory.put("name", "N/A");
            emptyTopCategory.put("totalProducts", 0);
            emptyTopCategory.put("activeProducts", 0);
            emptyTopCategory.put("parentName", "N/A");
            request.setAttribute("topCategory", emptyTopCategory);
            
            Map<String, Object> emptyRecentCategory = new HashMap<>();
            emptyRecentCategory.put("name", "N/A");
            emptyRecentCategory.put("createDateFormatted", "N/A");
            emptyRecentCategory.put("daysSinceCreated", 0);
            emptyRecentCategory.put("productCount", 0);
            request.setAttribute("mostRecentCategory", emptyRecentCategory);
            
            request.setAttribute("activePercentage", "0.0");
            request.setAttribute("inactivePercentage", "0.0");
            request.setAttribute("monthlyDifference", 0);
            request.setAttribute("monthlyDifferenceSign", "");
            request.setAttribute("recentCategories", new ArrayList<>());
            request.setAttribute("topCategoriesByProducts", new ArrayList<>());
            request.setAttribute("categoryDistribution", new ArrayList<>());
            request.setAttribute("categoryStatsByParent", new ArrayList<>());
            request.setAttribute("monthlyTrendJson", "[]");
            request.setAttribute("productDistributionJson", "[]");
            request.setAttribute("categoryStatsSummary", new HashMap<>());
            
            // Default time stats
            Map<String, Object> emptyTimeStats = new HashMap<>();
            emptyTimeStats.put("thisMonth", 0);
            emptyTimeStats.put("thisQuarter", 0);
            emptyTimeStats.put("lastSixMonths", 0);
            emptyTimeStats.put("thisYear", 0);
            emptyTimeStats.put("currentYear", LocalDate.now().getYear());
            emptyTimeStats.put("thisMonthPeriod", "Tháng " + LocalDate.now().getMonthValue() + "/" + LocalDate.now().getYear());
            emptyTimeStats.put("thisQuarterPeriod", "Quý " + ((LocalDate.now().getMonthValue() - 1) / 3 + 1) + "/" + LocalDate.now().getYear());
            emptyTimeStats.put("lastSixMonthsPeriod", 
                LocalDate.now().minusMonths(6).format(DateTimeFormatter.ofPattern("MM/yyyy")) + " - " + 
                LocalDate.now().format(DateTimeFormatter.ofPattern("MM/yyyy")));
            request.setAttribute("timeStats", emptyTimeStats);
            
            request.setAttribute("totalCategoryCount", 0);
            request.setAttribute("totalActiveCount", 0);
            request.setAttribute("totalInactiveCount", 0);
            request.setAttribute("totalProductCount", 0);
        }
    }
}