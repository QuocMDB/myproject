package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class InventoryStatisticsController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check user authentication and authorization
        HttpSession session = request.getSession();
        Object userObj = session.getAttribute("user");
        
        if (userObj == null) {
            try {
                response.sendRedirect("login.jsp");
            } catch (IOException e) {
                e.printStackTrace();
            }
            return;
        }
        
        // Make user available to JSP
        request.setAttribute("user", userObj);

        try {
            // Get filter parameters
            String period = request.getParameter("period");
            String categoryIdStr = request.getParameter("categoryId");
            
            if (period == null || period.isEmpty()) {
                period = "month"; // Default to 30 days
            }
            
            Integer categoryId = null;
            if (categoryIdStr != null && !categoryIdStr.isEmpty()) {
                try {
                    categoryId = Integer.parseInt(categoryIdStr);
                } catch (NumberFormatException e) {
                    // Invalid category ID, ignore
                }
            }

            // Get database connection and calculate real statistics
            Connection conn = getConnection();
            if (conn != null) {
                try {
                    // Calculate statistics from database
                    StatisticsData stats = calculateStatistics(conn, period, categoryId);
                    
                    // Set attributes for JSP
                    request.setAttribute("totalProducts", stats.totalProducts);
                    request.setAttribute("activeProductsCount", stats.activeProductsCount);
                    request.setAttribute("inactiveProductsCount", stats.inactiveProductsCount);
                    request.setAttribute("lowStockCount", stats.lowStockCount);
                    request.setAttribute("nearExpirationCount", stats.nearExpirationCount);
                    request.setAttribute("totalStockValue", stats.totalStockValue);
                    request.setAttribute("totalCategories", stats.totalCategories);
                    request.setAttribute("recentTransactionsCount", stats.recentTransactionsCount);
                    
                    request.setAttribute("lowStockProducts", stats.lowStockProducts);
                    request.setAttribute("categories", stats.categories);
                    request.setAttribute("categoryStats", stats.categoryStats);
                    request.setAttribute("recentActivities", stats.recentActivities);
                    
                    // Debug: Check what we're setting
                    System.out.println("Setting lowStockProducts with " + stats.lowStockProducts.size() + " items");
                    if (!stats.lowStockProducts.isEmpty()) {
                        ProductStatItem firstItem = stats.lowStockProducts.get(0);
                        System.out.println("First low stock product: " + firstItem.getCode() + " - " + firstItem.getName());
                    }
                    
                    // Debug: Check recent activities
                    System.out.println("Setting recentActivities with " + stats.recentActivities.size() + " items");
                    if (!stats.recentActivities.isEmpty()) {
                        Object firstActivity = stats.recentActivities.get(0);
                        if (firstActivity instanceof ProductActivity) {
                            ProductActivity pa = (ProductActivity) firstActivity;
                            System.out.println("First activity: " + pa.getType() + " - " + pa.getProductName() + " (" + pa.getFormattedDate() + ")");
                        }
                    }
                    
                } finally {
                    try {
                        conn.close();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }
            } else {
                // Fallback to mock data if connection fails
                setMockData(request);
            }
            
            request.setAttribute("period", period);
            request.setAttribute("categoryId", categoryId);

            // Forward to JSP
            try {
                request.getRequestDispatcher("inventory-statistics.jsp").forward(request, response);
            } catch (ServletException | IOException e) {
                e.printStackTrace();
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            // Fallback to mock data on error
            setMockData(request);
            request.setAttribute("error", "Có lỗi xảy ra khi tải thống kê từ database, hiển thị dữ liệu mẫu");
            request.getRequestDispatcher("inventory-statistics.jsp").forward(request, response);
        }
    }

    private Connection getConnection() {
        try {
            // Try to get connection using reflection to avoid import issues
            Class<?> contextClass = Class.forName("DBContext.Context");
            Connection conn = (Connection) contextClass.getMethod("getJDBCConnection").invoke(null);
            if (conn == null) {
                System.err.println("Database connection is null!");
            } else {
                System.out.println("Successfully connected to database: " + conn.getCatalog());
            }
            return conn;
        } catch (Exception e) {
            System.err.println("Could not get database connection: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }

    private StatisticsData calculateStatistics(Connection conn, String period, Integer categoryId) throws SQLException {
        StatisticsData stats = new StatisticsData();
        Map<String, CategoryStatistic> categoryStatsMap = new HashMap<>();
        
        try {
            // Use ProductInfoDAO to get products with stock information
            Class<?> daoClass = Class.forName("dao.ProductInfoDAO");
            Object daoInstance = daoClass.getDeclaredConstructor().newInstance();
            
            // Get all products with stock using the existing DAO method
            List<?> allProductsList = (List<?>) daoClass.getMethod("getProductsWithStock", int.class, int.class, String.class, String.class, String.class)
                .invoke(daoInstance, 0, 10000, "", "id", "asc");
                
            System.out.println("Product count from DAO: " + (allProductsList != null ? allProductsList.size() : "null"));
            
            // Debug the SQL query being used in the DAO
            try {
                // Use reflection to invoke a countProducts method if it exists
                try {
                    int count = (int) daoClass.getMethod("getTotalProductCount", String.class).invoke(daoInstance, "");
                    System.out.println("Total product count from DAO: " + count);
                } catch (NoSuchMethodException e) {
                    System.out.println("No getTotalProductCount method found");
                }
                
                // Try to get the connection and run a simple count query directly
                Connection directConn = getConnection();
                if (directConn != null) {
                    try {
                        // Check which database we're actually connected to
                        System.out.println("Connected to database: " + directConn.getCatalog());
                        
                        // Check if the product_info table exists and its structure
                        try {
                            PreparedStatement structStmt = directConn.prepareStatement(
                                "SELECT column_name FROM information_schema.columns WHERE table_schema = ? AND table_name = 'product_info'");
                            structStmt.setString(1, directConn.getCatalog());
                            ResultSet structRs = structStmt.executeQuery();
                            
                            System.out.println("product_info table columns:");
                            while (structRs.next()) {
                                System.out.println(" - " + structRs.getString(1));
                            }
                        } catch (Exception e) {
                            System.err.println("Error checking table structure: " + e.getMessage());
                        }
                        
                        // Check count of products
                        PreparedStatement stmt = directConn.prepareStatement("SELECT COUNT(*) FROM product_info");
                        ResultSet rs = stmt.executeQuery();
                        if (rs.next()) {
                            System.out.println("Total product count: " + rs.getInt(1));
                        } else {
                            System.out.println("No products found in direct query");
                        }
                        
                        // Check for product_in_stock table and count
                        try {
                            PreparedStatement stockStmt = directConn.prepareStatement("SELECT COUNT(*) FROM product_in_stock");
                            ResultSet stockRs = stockStmt.executeQuery();
                            if (stockRs.next()) {
                                System.out.println("Product in stock count: " + stockRs.getInt(1));
                            } else {
                                System.out.println("No product stock data found");
                            }
                        } catch (Exception e) {
                            System.err.println("Error checking product_in_stock: " + e.getMessage());
                        }
                        
                    } catch (Exception e) {
                        System.err.println("Error in direct queries: " + e.getMessage());
                    } finally {
                        directConn.close();
                    }
                }
            } catch (Exception e) {
                System.err.println("Error in debugging section: " + e.getMessage());
            }
            
            // Convert and analyze the products
            if (allProductsList == null || allProductsList.isEmpty()) {
                System.out.println("No products returned from DAO, using fallback mock data.");
                return stats; // Return empty stats, will trigger mock data
            }
            
            try {
                System.out.println("Processing " + allProductsList.size() + " products from DAO");
                for (Object productObj : allProductsList) {
                    if (productObj == null) {
                        System.out.println("Encountered null product object in list");
                        continue;
                    }
                    
                    ProductStatItem product = convertToProductStatItem(productObj);
                    
                    // Update counters
                    stats.totalProducts++;
                    if ("active".equalsIgnoreCase(product.status)) {
                        stats.activeProductsCount++;
                    } else {
                        stats.inactiveProductsCount++;
                    }
                    
                    if (product.isLowStock) {
                        stats.lowStockCount++;
                    }
                    
                    if (product.isNearExpiration) {
                        stats.nearExpirationCount++;
                    }
                    
                    // Category statistics
                    String catName = product.categoryName != null ? product.categoryName : "Chưa phân loại";
                    CategoryStatistic catStat = categoryStatsMap.computeIfAbsent(catName, k -> new CategoryStatistic());
                    catStat.categoryName = catName;
                    catStat.productCount++;
                    catStat.totalStock += product.stockQuantity.doubleValue();
                    
                    if (product.isLowStock) {
                        catStat.lowStockCount++;
                    }
                    
                    // Add to low stock list if applicable
                    if (product.isLowStock) {
                        stats.lowStockProducts.add(product);
                    }
                }
            } catch (Exception e) {
                System.err.println("Error processing products: " + e.getMessage());
                e.printStackTrace();
            }
            
            // Debug: Print summary of low stock counting
            System.out.println("=== Low Stock Summary ===");
            System.out.println("Total products processed: " + stats.totalProducts);
            System.out.println("Low stock count: " + stats.lowStockCount);
            System.out.println("Low stock products list size: " + stats.lowStockProducts.size());
            
            // Ensure lowStockProducts is never null for JSP
            if (stats.lowStockProducts == null) {
                stats.lowStockProducts = new ArrayList<>();
                System.out.println("Warning: lowStockProducts was null, initialized empty list");
            }
            
            // Sort and limit low stock products - ensure we have data to display
            if (!stats.lowStockProducts.isEmpty()) {
                stats.lowStockProducts = stats.lowStockProducts.stream()
                    .sorted((p1, p2) -> p1.stockQuantity.compareTo(p2.stockQuantity))
                    .limit(10)
                    .collect(java.util.stream.Collectors.toList());
                
                System.out.println("Top 10 low stock products prepared for display:");
                for (ProductStatItem item : stats.lowStockProducts) {
                    System.out.println("- " + item.name + " (Stock: " + item.stockQuantity + ", Min: " + item.minStockThreshold + ")");
                }
            } else {
                System.out.println("No low stock products found to display");
            }
            
            // Convert category stats to list
            stats.categoryStats = categoryStatsMap.values()
                .stream()
                .sorted((s1, s2) -> s2.productCount - s1.productCount)
                .collect(java.util.stream.Collectors.toList());
            
            // Get categories for filter
            stats.categories = getAllCategories(conn);
            
            // Get recent product activities/history - ALWAYS try to get from database
            System.out.println("Fetching recent activities from database...");
            stats.recentActivities = getRecentProductActivities(conn);
            System.out.println("Retrieved " + stats.recentActivities.size() + " recent activities for statistics");
            
            stats.totalCategories = categoryStatsMap.size();
            
            // Set recent transactions count based on actual data
            stats.recentTransactionsCount = stats.recentActivities.size();
            
        } catch (Exception e) {
            System.err.println("Error calculating statistics: " + e.getMessage());
            e.printStackTrace();
            throw new SQLException("Failed to calculate statistics", e);
        }
        
        return stats;
    }
    
    private ProductStatItem convertToProductStatItem(Object productObj) {
        try {
            ProductStatItem item = new ProductStatItem();
            Class<?> productClass = productObj.getClass();
            
            // Use reflection to get values from ProductStock object
            item.id = (Integer) productClass.getMethod("getId").invoke(productObj);
            item.name = (String) productClass.getMethod("getName").invoke(productObj);
            item.code = (String) productClass.getMethod("getCode").invoke(productObj);
            item.status = (String) productClass.getMethod("getStatus").invoke(productObj);
            item.categoryName = (String) productClass.getMethod("getCategoryName").invoke(productObj);
            item.unitName = (String) productClass.getMethod("getUnitName").invoke(productObj);
            
            // Get stock quantity
            Object stockQty = productClass.getMethod("getStockQuantity").invoke(productObj);
            item.stockQuantity = stockQty != null ? (BigDecimal) stockQty : BigDecimal.ZERO;
            
            // Get minimum threshold
            Object minThreshold = productClass.getMethod("getMinStockThreshold").invoke(productObj);
            item.minStockThreshold = minThreshold != null ? (BigDecimal) minThreshold : BigDecimal.ZERO;
            
            // Check if low stock - improved logic
            // Case 1: If minimum threshold is set and stock is below or equal to threshold
            // Case 2: If no threshold is set but stock is 0 or negative, consider it low stock
            // Case 3: If threshold is 0 but stock is also 0, consider it low stock
            if (item.minStockThreshold.compareTo(BigDecimal.ZERO) > 0) {
                // Normal case: compare with threshold
                item.isLowStock = item.stockQuantity.compareTo(item.minStockThreshold) <= 0;
            } else {
                // No threshold set or threshold is 0: consider low stock if quantity is 0 or negative
                item.isLowStock = item.stockQuantity.compareTo(BigDecimal.ZERO) <= 0;
            }
            
            // Log the values for debugging (after low stock calculation)
            System.out.println("Product: " + item.id + " - " + item.name + ", Stock: " + item.stockQuantity + ", Min: " + item.minStockThreshold + ", Low Stock: " + item.isLowStock);
            
            // For now, set expiration as false (can be enhanced later)
            item.isNearExpiration = false;
            
            return item;
        } catch (Exception e) {
            System.err.println("Error converting product: " + e.getMessage());
            return new ProductStatItem(); // Return empty item on error
        }
    }
    
    private List<Object> getAllCategories(Connection conn) {
        List<Object> categories = new ArrayList<>();
        try {
            String query = "SELECT id, name FROM category WHERE active_flag = 1";
            PreparedStatement ps = conn.prepareStatement(query);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> cat = new HashMap<>();
                cat.put("id", rs.getInt("id"));
                cat.put("name", rs.getString("name"));
                categories.add(cat);
            }
            
            rs.close();
            ps.close();
            
            System.out.println("Retrieved " + categories.size() + " categories for filter");
            
        } catch (SQLException e) {
            System.err.println("Error getting categories: " + e.getMessage());
            // Create some mock categories for fallback
            for (int i = 1; i <= 3; i++) {
                Map<String, Object> cat = new HashMap<>();
                cat.put("id", i);
                cat.put("name", "Danh mục " + i);
                categories.add(cat);
            }
        }
        return categories;
    }

    private void setMockData(HttpServletRequest request) {
        // Mock data as fallback
        request.setAttribute("totalProducts", 50);
        request.setAttribute("activeProductsCount", 45);
        request.setAttribute("inactiveProductsCount", 5);
        request.setAttribute("lowStockCount", 8);
        request.setAttribute("nearExpirationCount", 3);
        request.setAttribute("totalStockValue", 150000.0);
        request.setAttribute("totalCategories", 10);
        request.setAttribute("recentTransactionsCount", 25);
        
        // Create mock low stock products
        List<ProductStatItem> mockLowStockProducts = new ArrayList<>();
        for (int i = 1; i <= 5; i++) {
            ProductStatItem item = new ProductStatItem();
            item.id = i;
            item.name = "Sản phẩm sắp hết " + i;
            item.code = "SP00" + i;
            item.status = "active";
            item.categoryName = "Danh mục " + i;
            item.unitName = "Cái";
            item.stockQuantity = new BigDecimal(i); // Very low stock
            item.minStockThreshold = new BigDecimal(10);
            item.isLowStock = true;
            mockLowStockProducts.add(item);
            
            // Debug: Test that getters work
            System.out.println("Mock product created: ID=" + item.getId() + ", Code=" + item.getCode() + ", Name=" + item.getName());
        }
        
        System.out.println("Created " + mockLowStockProducts.size() + " mock low stock products");
        
        request.setAttribute("lowStockProducts", mockLowStockProducts);
        
        // Debug: Check what we're setting in mock data
        System.out.println("Setting mock lowStockProducts with " + mockLowStockProducts.size() + " items");
        if (!mockLowStockProducts.isEmpty()) {
            ProductStatItem firstItem = mockLowStockProducts.get(0);
            System.out.println("First mock low stock product: " + firstItem.getCode() + " - " + firstItem.getName());
        }
        
        // Create mock categories
        List<Object> mockCategories = new ArrayList<>();
        for (int i = 1; i <= 3; i++) {
            Map<String, Object> cat = new HashMap<>();
            cat.put("id", i);
            cat.put("name", "Danh mục " + i);
            mockCategories.add(cat);
        }
        request.setAttribute("categories", mockCategories);
        
        // Create mock category statistics
        List<CategoryStatistic> mockCategoryStats = new ArrayList<>();
        for (int i = 1; i <= 3; i++) {
            CategoryStatistic stat = new CategoryStatistic();
            stat.categoryName = "Danh mục " + i;
            stat.productCount = 10 + i * 5;
            stat.totalStock = 100.0 + i * 50;
            stat.lowStockCount = i;
            mockCategoryStats.add(stat);
        }
        request.setAttribute("categoryStats", mockCategoryStats);
        
        // Try to get real activities from database first, fall back to mock if needed
        Connection conn = getConnection();
        List<Object> activities = null;
        if (conn != null) {
            try {
                activities = getRecentProductActivities(conn);
                System.out.println("Got " + activities.size() + " activities from database for mock data fallback");
            } catch (Exception e) {
                System.out.println("Could not get activities from database in mock data: " + e.getMessage());
            } finally {
                try {
                    conn.close();
                } catch (Exception e) {
                    // Ignore
                }
            }
        }
        
        // If we couldn't get real activities, create mock ones
        if (activities == null || activities.isEmpty()) {
            activities = createMockActivities();
            System.out.println("Using mock activities as no real data was available");
        }
        
        request.setAttribute("recentActivities", activities);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    // Data classes
    public static class StatisticsData {
        int totalProducts = 0;
        int activeProductsCount = 0;
        int inactiveProductsCount = 0;
        int lowStockCount = 0;
        int nearExpirationCount = 0;
        double totalStockValue = 0.0;
        int totalCategories = 0;
        int recentTransactionsCount = 0;
        
        List<ProductStatItem> lowStockProducts = new ArrayList<>();
        List<Object> categories = new ArrayList<>();
        List<CategoryStatistic> categoryStats = new ArrayList<>();
        List<Object> recentActivities = new ArrayList<>();
    }
    
    public static class ProductStatItem {
        int id;
        String name;
        String code;
        String status;
        String categoryName;
        String unitSymbol;
        String unitName;
        BigDecimal stockQuantity = BigDecimal.ZERO;
        BigDecimal minStockThreshold = BigDecimal.ZERO;
        boolean isLowStock = false;
        boolean isNearExpiration = false;
        
        // Getters for JSP
        public int getId() { return id; }
        public String getName() { return name; }
        public String getCode() { return code; }
        public String getStatus() { return status; }
        public String getCategoryName() { return categoryName; }
        public String getUnitSymbol() { return unitSymbol; }
        public String getUnitName() { return unitName; }
        public BigDecimal getStockQuantity() { return stockQuantity; }
        public BigDecimal getMinStockThreshold() { return minStockThreshold; }
        public boolean isLowStock() { return isLowStock; }
        public boolean isNearExpiration() { return isNearExpiration; }
        
        // Additional helper methods for JSP display
        public String getFormattedStockQuantity() {
            return stockQuantity != null ? stockQuantity.toString() : "0";
        }
        
        public String getFormattedMinThreshold() {
            return minStockThreshold != null ? minStockThreshold.toString() : "0";
        }
        
        public String getStockStatus() {
            if (isLowStock) {
                return "Sap het hang";
            } else {
                return "Day du";
            }
        }
    }

    public static class CategoryStatistic {
        String categoryName;
        int productCount = 0;
        double totalStock = 0.0;
        double totalValue = 0.0;
        int lowStockCount = 0;
        
        // Getters
        public String getCategoryName() { return categoryName; }
        public int getProductCount() { return productCount; }
        public double getTotalStock() { return totalStock; }
        public double getTotalValue() { return totalValue; }
        public int getLowStockCount() { return lowStockCount; }
    }
    
    // Activity data class for recent product activities
    public static class ProductActivity {
        String type;
        int productId;
        String productName;
        BigDecimal quantity;
        java.sql.Timestamp date;
        String userName;
        String description;
        
        // Getters for JSP
        public String getType() { return type; }
        public int getProductId() { return productId; }
        public String getProductName() { return productName; }
        public BigDecimal getQuantity() { return quantity; }
        public java.sql.Timestamp getDate() { return date; }
        public String getUserName() { return userName; }
        public String getDescription() { return description; }
        
        // Formatted date for display
        public String getFormattedDate() {
            if (date != null) {
                java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm");
                return sdf.format(date);
            }
            return "";
        }
    }
    
    private List<Object> getRecentProductActivities(Connection conn) {
        List<Object> activities = new ArrayList<>();
        try {
            System.out.println("Fetching recent product activities from database...");
            
            // First, let's check what tables are available for product activities
            // Try multiple approaches to get recent activities
            
            // Approach 1: Try to get from invoice details (purchases/imports)
            String importQuery = """
                SELECT 
                    'Nhap kho' as activity_type,
                    id.product_id,
                    pi.name as product_name,
                    id.quantity,
                    i.create_date as activity_date,
                    u.full_name as user_name,
                    CONCAT('Nhap kho - Hoa don #', i.id) as description
                FROM invoice_detail id
                JOIN invoice i ON id.invoice_id = i.id
                JOIN product_info pi ON id.product_id = pi.id
                LEFT JOIN users u ON i.created_by = u.id
                WHERE i.create_date >= DATE_SUB(NOW(), INTERVAL 30 DAY)
                AND i.status = 'approved'
                ORDER BY i.create_date DESC
                LIMIT 10
            """;
            
            try {
                PreparedStatement ps1 = conn.prepareStatement(importQuery);
                ResultSet rs1 = ps1.executeQuery();
                
                while (rs1.next()) {
                    ProductActivity activity = new ProductActivity();
                    activity.type = "Import";
                    activity.productId = rs1.getInt("product_id");
                    activity.productName = rs1.getString("product_name");
                    activity.quantity = rs1.getBigDecimal("quantity");
                    activity.date = rs1.getTimestamp("activity_date");
                    activity.userName = rs1.getString("user_name");
                    activity.description = rs1.getString("description");
                    activities.add(activity);
                }
                
                rs1.close();
                ps1.close();
                System.out.println("Retrieved " + activities.size() + " import activities");
                
            } catch (SQLException e) {
                System.out.println("Import query failed, trying alternative: " + e.getMessage());
            }
            
            // Approach 2: Try to get from export requests
            String exportQuery = """
                SELECT 
                    'Xuat kho' as activity_type,
                    eri.product_id,
                    pi.name as product_name,
                    eri.quantity,
                    er.create_date as activity_date,
                    u.full_name as user_name,
                    CONCAT('Xuat kho - Yeu cau #', er.id) as description
                FROM export_request_items eri
                JOIN export_request er ON eri.export_request_id = er.id
                JOIN product_info pi ON eri.product_id = pi.id
                LEFT JOIN users u ON er.created_by = u.id
                WHERE er.create_date >= DATE_SUB(NOW(), INTERVAL 30 DAY)
                AND er.status = 'approved'
                ORDER BY er.create_date DESC
                LIMIT 10
            """;
            
            try {
                PreparedStatement ps2 = conn.prepareStatement(exportQuery);
                ResultSet rs2 = ps2.executeQuery();
                
                int exportCount = 0;
                while (rs2.next()) {
                    ProductActivity activity = new ProductActivity();
                    activity.type = "Export";
                    activity.productId = rs2.getInt("product_id");
                    activity.productName = rs2.getString("product_name");
                    activity.quantity = rs2.getBigDecimal("quantity");
                    activity.date = rs2.getTimestamp("activity_date");
                    activity.userName = rs2.getString("user_name");
                    activity.description = rs2.getString("description");
                    activities.add(activity);
                    exportCount++;
                }
                
                rs2.close();
                ps2.close();
                System.out.println("Retrieved " + exportCount + " export activities");
                
            } catch (SQLException e) {
                System.out.println("Export query failed, trying alternative: " + e.getMessage());
            }
            
            // Approach 3: Try to get from purchase order items
            String purchaseQuery = """
                SELECT 
                    'Dat hang' as activity_type,
                    poi.product_id,
                    pi.name as product_name,
                    poi.quantity,
                    po.create_date as activity_date,
                    u.full_name as user_name,
                    CONCAT('Dat hang - Don #', po.id) as description
                FROM purchase_order_items poi
                JOIN purchase_order_info po ON poi.purchase_order_id = po.id
                JOIN product_info pi ON poi.product_id = pi.id
                LEFT JOIN users u ON po.created_by = u.id
                WHERE po.create_date >= DATE_SUB(NOW(), INTERVAL 30 DAY)
                ORDER BY po.create_date DESC
                LIMIT 5
            """;
            
            try {
                PreparedStatement ps3 = conn.prepareStatement(purchaseQuery);
                ResultSet rs3 = ps3.executeQuery();
                
                int purchaseCount = 0;
                while (rs3.next()) {
                    ProductActivity activity = new ProductActivity();
                    activity.type = "Purchase";
                    activity.productId = rs3.getInt("product_id");
                    activity.productName = rs3.getString("product_name");
                    activity.quantity = rs3.getBigDecimal("quantity");
                    activity.date = rs3.getTimestamp("activity_date");
                    activity.userName = rs3.getString("user_name");
                    activity.description = rs3.getString("description");
                    activities.add(activity);
                    purchaseCount++;
                }
                
                rs3.close();
                ps3.close();
                System.out.println("Retrieved " + purchaseCount + " purchase activities");
                
            } catch (SQLException e) {
                System.out.println("Purchase query failed: " + e.getMessage());
            }
            
            // Sort all activities by date (most recent first)
            activities.sort((a, b) -> {
                ProductActivity pa = (ProductActivity) a;
                ProductActivity pb = (ProductActivity) b;
                if (pa.date == null && pb.date == null) return 0;
                if (pa.date == null) return 1;
                if (pb.date == null) return -1;
                return pb.date.compareTo(pa.date);
            });
            
            // Limit to top 15 most recent
            if (activities.size() > 15) {
                activities = activities.subList(0, 15);
            }
            
            System.out.println("Total retrieved " + activities.size() + " recent product activities from database");
            
            // If we got activities from database, return them
            if (!activities.isEmpty()) {
                return activities;
            }
            
        } catch (Exception e) {
            System.err.println("Error getting recent product activities: " + e.getMessage());
            e.printStackTrace();
        }
        
        // If no activities found or error occurred, fall back to mock data
        System.out.println("No activities found in database, creating mock activities");
        return createMockActivities();
    }
    
    private List<Object> createMockActivities() {
        List<Object> mockActivities = new ArrayList<>();
        
        // Create sample activities for demo purposes with more variety
        String[] activityTypes = {"Import", "Export", "Purchase", "Adjustment"};
        String[] descriptions = {"Nhap kho", "Xuat kho", "Dat hang", "Kiem ke"};
        
        for (int i = 1; i <= 8; i++) {
            ProductActivity activity = new ProductActivity();
            int typeIndex = (i - 1) % activityTypes.length;
            activity.type = activityTypes[typeIndex];
            activity.productId = i;
            activity.productName = "Sản phẩm " + i;
            activity.quantity = new BigDecimal(5 + i * 3);
            
            // Create timestamps spanning the last few days
            long hoursAgo = i * 6; // 6, 12, 18, 24, 30, 36, 42, 48 hours ago
            activity.date = new java.sql.Timestamp(System.currentTimeMillis() - (hoursAgo * 3600000L));
            
            activity.userName = i % 3 == 0 ? "admin" : (i % 3 == 1 ? "staff1" : "manager");
            activity.description = descriptions[typeIndex] + " - " + activity.productName;
            mockActivities.add(activity);
        }
        
        System.out.println("Created " + mockActivities.size() + " mock activities");
        return mockActivities;
    }
}
