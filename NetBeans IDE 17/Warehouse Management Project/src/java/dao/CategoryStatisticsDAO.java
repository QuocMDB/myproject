package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import DBContext.Context;
import model.CategoryProduct;

public class CategoryStatisticsDAO {

    /**
     * Get basic statistics for categories
     */
    public Map<String, Object> getBasicStatistics() {
        Map<String, Object> stats = new HashMap<>();

        String sql = "SELECT "
                + "COUNT(*) as total_categories, "
                + "SUM(CASE WHEN active_flag = 1 THEN 1 ELSE 0 END) as active_categories, "
                + "SUM(CASE WHEN active_flag = 0 THEN 1 ELSE 0 END) as inactive_categories "
                + "FROM category";

        try (Connection conn = new Context().getJDBCConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql); 
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                stats.put("totalCategories", rs.getInt("total_categories"));
                stats.put("activeCategories", rs.getInt("active_categories"));
                stats.put("inactiveCategories", rs.getInt("inactive_categories"));
            }

        } catch (SQLException e) {
            System.out.println("Error in getBasicStatistics: " + e.getMessage());
            e.printStackTrace();
        }

        return stats;
    }

    /**
     * Get category with most products
     */
    public Map<String, Object> getTopCategoryByProductCount() {
        Map<String, Object> topCategory = new HashMap<>();

        String sql = "SELECT c.id, c.name, COUNT(p.id) as product_count "
                + "FROM category c "
                + "LEFT JOIN product_info p ON c.id = p.cate_id "
                + "GROUP BY c.id, c.name "
                + "ORDER BY product_count DESC "
                + "LIMIT 1";

        try (Connection conn = new Context().getJDBCConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql); 
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                topCategory.put("id", rs.getInt("id"));
                topCategory.put("name", rs.getString("name"));
                topCategory.put("productCount", rs.getInt("product_count"));
            }

        } catch (SQLException e) {
            System.out.println("Error in getTopCategoryByProductCount: " + e.getMessage());
            e.printStackTrace();
        }

        return topCategory;
    }

    /**
     * Get time-based statistics for categories
     */
    public Map<String, Object> getTimeBasedStatistics() {
        Map<String, Object> timeStats = new HashMap<>();
        LocalDate now = LocalDate.now();

        // Calculate date ranges
        LocalDate startOfMonth = now.withDayOfMonth(1);
        LocalDate startOfQuarter = now.with(now.getMonth().firstMonthOfQuarter()).withDayOfMonth(1);
        LocalDate sixMonthsAgo = now.minusMonths(6);
        LocalDate startOfYear = now.withDayOfYear(1);

        // Format periods for display
        DateTimeFormatter monthFormatter = DateTimeFormatter.ofPattern("MM/yyyy");

        timeStats.put("thisMonthPeriod", "Tháng " + now.format(monthFormatter));
        timeStats.put("thisQuarterPeriod", "Quý " + ((now.getMonthValue() - 1) / 3 + 1) + "/" + now.getYear());
        timeStats.put("lastSixMonthsPeriod", sixMonthsAgo.format(monthFormatter) + " - " + now.format(monthFormatter));
        timeStats.put("currentYear", now.getYear());

        String sql = "SELECT "
                + "SUM(CASE WHEN DATE(create_date) >= ? THEN 1 ELSE 0 END) as this_month, "
                + "SUM(CASE WHEN DATE(create_date) >= ? THEN 1 ELSE 0 END) as this_quarter, "
                + "SUM(CASE WHEN DATE(create_date) >= ? THEN 1 ELSE 0 END) as last_six_months, "
                + "SUM(CASE WHEN YEAR(create_date) = ? THEN 1 ELSE 0 END) as this_year "
                + "FROM category";

        try (Connection conn = new Context().getJDBCConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setDate(1, java.sql.Date.valueOf(startOfMonth));
            ps.setDate(2, java.sql.Date.valueOf(startOfQuarter));
            ps.setDate(3, java.sql.Date.valueOf(sixMonthsAgo));
            ps.setInt(4, now.getYear());

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    timeStats.put("thisMonth", rs.getInt("this_month"));
                    timeStats.put("thisQuarter", rs.getInt("this_quarter"));
                    timeStats.put("lastSixMonths", rs.getInt("last_six_months"));
                    timeStats.put("thisYear", rs.getInt("this_year"));
                }
            }

        } catch (SQLException e) {
            System.out.println("Error in getTimeBasedStatistics: " + e.getMessage());
            e.printStackTrace();
        }

        return timeStats;
    }

    /**
     * Get recently added categories with parent info
     */
    public List<Map<String, Object>> getRecentlyAddedCategories(int limit) {
        List<Map<String, Object>> recentCategories = new ArrayList<>();

        String sql = "SELECT c.*, parent_c.name as parent_name, COUNT(p.id) as product_count "
                + "FROM category c "
                + "LEFT JOIN category parent_c ON c.parent_id = parent_c.id "
                + "LEFT JOIN product_info p ON c.id = p.cate_id "
                + "GROUP BY c.id "
                + "ORDER BY c.create_date DESC "
                + "LIMIT ?";

        try (Connection conn = new Context().getJDBCConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, limit);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> category = new HashMap<>();
                    category.put("id", rs.getInt("id"));
                    category.put("name", rs.getString("name"));
                    category.put("parentName", rs.getString("parent_name"));
                    category.put("productCount", rs.getInt("product_count"));
                    category.put("activeFlag", rs.getBoolean("active_flag"));

                    if (rs.getTimestamp("create_date") != null) {
                        category.put("createDate", rs.getTimestamp("create_date").toLocalDateTime());
                    }

                    recentCategories.add(category);
                }
            }

        } catch (SQLException e) {
            System.out.println("Error in getRecentlyAddedCategories: " + e.getMessage());
            e.printStackTrace();
        }

        return recentCategories;
    }

    /**
     * Get top categories by product count
     */
    public List<Map<String, Object>> getTopCategoriesByProducts(int limit) {
        List<Map<String, Object>> topCategories = new ArrayList<>();

        String sql = "SELECT c.id, c.name, parent_c.name as parent_name, COUNT(p.id) as product_count "
                + "FROM category c "
                + "LEFT JOIN category parent_c ON c.parent_id = parent_c.id "
                + "LEFT JOIN product_info p ON c.id = p.cate_id "
                + "GROUP BY c.id, c.name, parent_c.name "
                + "ORDER BY product_count DESC "
                + "LIMIT ?";

        try (Connection conn = new Context().getJDBCConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, limit);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> category = new HashMap<>();
                    category.put("id", rs.getInt("id"));
                    category.put("name", rs.getString("name"));
                    category.put("parentName", rs.getString("parent_name"));
                    category.put("productCount", rs.getInt("product_count"));

                    topCategories.add(category);
                }
            }

        } catch (SQLException e) {
            System.out.println("Error in getTopCategoriesByProducts: " + e.getMessage());
            e.printStackTrace();
        }

        return topCategories;
    }

    /**
     * Get category distribution for chart (by parent category)
     */

    /**
     * Get monthly growth statistics
     */
    public Map<String, Integer> getMonthlyGrowth() {
        Map<String, Integer> growth = new HashMap<>();
        LocalDate now = LocalDate.now();
        LocalDate lastMonth = now.minusMonths(1);

        String sql = "SELECT "
                + "SUM(CASE WHEN YEAR(create_date) = ? AND MONTH(create_date) = ? THEN 1 ELSE 0 END) as this_month, "
                + "SUM(CASE WHEN YEAR(create_date) = ? AND MONTH(create_date) = ? THEN 1 ELSE 0 END) as last_month "
                + "FROM category";

        try (Connection conn = new Context().getJDBCConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, now.getYear());
            ps.setInt(2, now.getMonthValue());
            ps.setInt(3, lastMonth.getYear());
            ps.setInt(4, lastMonth.getMonthValue());

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int thisMonthCount = rs.getInt("this_month");
                    int lastMonthCount = rs.getInt("last_month");

                    growth.put("thisMonth", thisMonthCount);
                    growth.put("lastMonth", lastMonthCount);
                    growth.put("difference", thisMonthCount - lastMonthCount);
                }
            }

        } catch (SQLException e) {
            System.out.println("Error in getMonthlyGrowth: " + e.getMessage());
            e.printStackTrace();
        }

        return growth;
    }

    /**
     * Get percentage calculations
     */
    public Map<String, Double> getPercentageStatistics() {
        Map<String, Double> percentages = new HashMap<>();

        Map<String, Object> basicStats = getBasicStatistics();
        int total = (int) basicStats.getOrDefault("totalCategories", 0);
        int active = (int) basicStats.getOrDefault("activeCategories", 0);
        int inactive = (int) basicStats.getOrDefault("inactiveCategories", 0);

        if (total > 0) {
            percentages.put("activePercentage", (active * 100.0) / total);
            percentages.put("inactivePercentage", (inactive * 100.0) / total);
        } else {
            percentages.put("activePercentage", 0.0);
            percentages.put("inactivePercentage", 0.0);
        }

        return percentages;
    }

    /**
     * Get filtered statistics based on criteria
     */
    public Map<String, Object> getFilteredStatistics(String status, String parentId, String startDate, String endDate) {
        Map<String, Object> filteredStats = new HashMap<>();

        StringBuilder sql = new StringBuilder(
                "SELECT "
                + "COUNT(*) as total_categories, "
                + "SUM(CASE WHEN active_flag = 1 THEN 1 ELSE 0 END) as active_categories, "
                + "SUM(CASE WHEN active_flag = 0 THEN 1 ELSE 0 END) as inactive_categories "
                + "FROM category WHERE 1=1 "
        );

        List<Object> params = new ArrayList<>();

        // Add filters
        if (status != null && !status.isEmpty()) {
            sql.append("AND active_flag = ? ");
            params.add(Integer.parseInt(status));
        }

        if (parentId != null && !parentId.isEmpty() && !"-1".equals(parentId)) {
            sql.append("AND parent_id = ? ");
            params.add(Integer.parseInt(parentId));
        }

        if (startDate != null && !startDate.isEmpty() && endDate != null && !endDate.isEmpty()) {
            sql.append("AND DATE(create_date) BETWEEN ? AND ? ");
            params.add(startDate);
            params.add(endDate);
        }

        try (Connection conn = new Context().getJDBCConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            // Set parameters
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    filteredStats.put("totalCategories", rs.getInt("total_categories"));
                    filteredStats.put("activeCategories", rs.getInt("active_categories"));
                    filteredStats.put("inactiveCategories", rs.getInt("inactive_categories"));
                }
            }

        } catch (SQLException e) {
            System.out.println("Error in getFilteredStatistics: " + e.getMessage());
            e.printStackTrace();
        }

        return filteredStats;
    }

    /**
     * Get statistics grouped by parent category
     */

    /**
     * Get monthly trend data for the current year
     */

    /**
     * Get product distribution by category (top N)
     */

    /**
     * Get category with most products (FIXED VERSION)
     * Lấy loại sản phẩm có nhiều sản phẩm nhất
     */
    public Map<String, Object> getCategoryWithMostProducts() {
        Map<String, Object> result = new HashMap<>();
        
        String sql = "SELECT c.id, c.name, parent_c.name as parent_name, " +
                    "COUNT(p.id) as product_count, " +
                    "COUNT(DISTINCT CASE WHEN p.active_flag = 1 THEN p.id END) as active_product_count " +
                    "FROM category c " +
                    "LEFT JOIN category parent_c ON c.parent_id = parent_c.id " +
                    "LEFT JOIN product_info p ON c.id = p.cate_id " +
                    "WHERE c.active_flag = 1 " +
                    "GROUP BY c.id, c.name, parent_c.name " +
                    "ORDER BY product_count DESC " +
                    "LIMIT 1";
        
        try (Connection conn = new Context().getJDBCConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                result.put("id", rs.getInt("id"));
                result.put("name", rs.getString("name"));
                result.put("parentName", rs.getString("parent_name"));
                result.put("totalProducts", rs.getInt("product_count"));
                result.put("activeProducts", rs.getInt("active_product_count"));
                
                // Tính phần trăm sản phẩm active
                int total = rs.getInt("product_count");
                int active = rs.getInt("active_product_count");
                if (total > 0) {
                    result.put("activePercentage", (active * 100.0) / total);
                } else {
                    result.put("activePercentage", 0.0);
                }
            }
            
        } catch (SQLException e) {
            System.out.println("Error in getCategoryWithMostProducts: " + e.getMessage());
            e.printStackTrace();
        }
        
        return result;
    }

    /**
     * Get most recently added category (FIXED VERSION)
     * Lấy loại sản phẩm được thêm gần đây nhất
     */

    /**
     * Get top N recently added categories with statistics (FIXED VERSION)
     * Lấy danh sách N loại sản phẩm được thêm gần đây nhất kèm thống kê
     */
    public List<Map<String, Object>> getRecentCategoriesWithStats(int limit) {
        List<Map<String, Object>> categories = new ArrayList<>();
        
        String sql = "SELECT c.id, c.name, parent_c.name as parent_name, " +
                    "c.create_date, c.active_flag, " +
                    "COUNT(DISTINCT p.id) as product_count, " +
                    "COUNT(DISTINCT CASE WHEN p.active_flag = 1 THEN p.id END) as active_products, " +
                    "COALESCE(SUM(ps.qty), 0) as total_stock " +
                    "FROM category c " +
                    "LEFT JOIN category parent_c ON c.parent_id = parent_c.id " +
                    "LEFT JOIN product_info p ON c.id = p.cate_id " +
                    "LEFT JOIN product_in_stock ps ON p.id = ps.product_id " +
                    "GROUP BY c.id, c.name, parent_c.name, c.create_date, c.active_flag " +
                    "ORDER BY c.create_date DESC " +
                    "LIMIT ?";
        
        try (Connection conn = new Context().getJDBCConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, limit);
            
            try (ResultSet rs = ps.executeQuery()) {
                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
                
                while (rs.next()) {
                    Map<String, Object> category = new HashMap<>();
                    category.put("id", rs.getInt("id"));
                    category.put("name", rs.getString("name"));
                    category.put("parentName", rs.getString("parent_name"));
                    category.put("productCount", rs.getInt("product_count"));
                    category.put("activeProducts", rs.getInt("active_products"));
                    category.put("totalStock", rs.getDouble("total_stock"));
                    category.put("activeFlag", rs.getBoolean("active_flag"));
                    
                    if (rs.getTimestamp("create_date") != null) {
                        LocalDateTime createDate = rs.getTimestamp("create_date").toLocalDateTime();
                        category.put("createDate", createDate);
                        category.put("createDateFormatted", createDate.format(formatter));
                        
                        // Tính số ngày
                        long daysSince = java.time.temporal.ChronoUnit.DAYS.between(
                            createDate.toLocalDate(), 
                            LocalDate.now()
                        );
                        category.put("daysSinceCreated", daysSince);
                    }
                    
                    categories.add(category);
                }
            }
            
        } catch (SQLException e) {
            System.out.println("Error in getRecentCategoriesWithStats: " + e.getMessage());
            e.printStackTrace();
        }
        
        return categories;
    }

    /**
     * Get category statistics summary
     * Lấy tổng hợp thống kê về loại sản phẩm
     */
    public Map<String, Object> getCategoryStatisticsSummary() {
        Map<String, Object> summary = new HashMap<>();
        
        // Lấy loại SP có nhiều sản phẩm nhất
        Map<String, Object> topCategory = getCategoryWithMostProducts();
        summary.put("categoryWithMostProducts", topCategory);
        
        
        // Lấy thống kê cơ bản
        Map<String, Object> basicStats = getBasicStatistics();
        summary.put("totalCategories", basicStats.get("totalCategories"));
        summary.put("activeCategories", basicStats.get("activeCategories"));
        
        // Lấy top 5 loại SP có nhiều sản phẩm
        List<Map<String, Object>> topCategories = getTopCategoriesByProducts(5);
        summary.put("top5Categories", topCategories);
        
        // Lấy 5 loại SP được thêm gần đây
        List<Map<String, Object>> recentCategories = getRecentCategoriesWithStats(5);
        summary.put("recent5Categories", recentCategories);
        
        return summary;
    }
}