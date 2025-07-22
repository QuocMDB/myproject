package controller;

// Controller for listing, searching, and paginating products

import dao.ProductInfoDAO;
import model.ProductStock;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class ProductListController extends HttpServlet {
    
    private static final int DEFAULT_PAGE_SIZE = 10;
    private final ProductInfoDAO productDAO = new ProductInfoDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        processRequest(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
    
    private void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
          // Get parameters
        String pageParam = request.getParameter("page");
        String pageSizeParam = request.getParameter("pageSize");
        String search = request.getParameter("search");
        String sortBy = request.getParameter("sortBy");
        String sortOrder = request.getParameter("sortOrder");
        
        // Handle success/error messages
        String successMessage = request.getParameter("success");
        String errorMessage = request.getParameter("error");
        
        if (successMessage != null && !successMessage.trim().isEmpty()) {
            request.setAttribute("successMessage", successMessage);
        }
        
        if (errorMessage != null && !errorMessage.trim().isEmpty()) {
            request.setAttribute("errorMessage", errorMessage);
        }
        
        // Parse page and pageSize
        int page = parseIntegerParameter(pageParam, 0);
        int pageSize = parseIntegerParameter(pageSizeParam, DEFAULT_PAGE_SIZE);
        
        // Validate page size
        if (pageSize <= 0 || pageSize > 100) {
            pageSize = DEFAULT_PAGE_SIZE;
        }
        
        // Default sort order
        if (sortOrder == null || (!sortOrder.equals("asc") && !sortOrder.equals("desc"))) {
            sortOrder = "asc";
        }
        
        // Get products with pagination and search
        List<ProductStock> products = productDAO.getProductsWithStock(page, pageSize, search, sortBy, sortOrder);
        int totalProducts = productDAO.getTotalProductCount(search);
        int totalPages = (int) Math.ceil((double) totalProducts / pageSize);
        
        // Calculate statistics for all products (not just current page)
        List<ProductStock> allProductsForStats = productDAO.getProductsWithStock(0, Integer.MAX_VALUE, search, sortBy, sortOrder);
        long lowStockCount = calculateLowStockCount(allProductsForStats);
        long nearExpirationCount = calculateNearExpirationCount(allProductsForStats);
        
        // Set attributes for JSP
        setRequestAttributes(request, products, page, totalPages, pageSize, totalProducts, 
                           search, sortBy, sortOrder, lowStockCount, nearExpirationCount);
        
        // Forward to JSP
        request.getRequestDispatcher("/product-list.jsp").forward(request, response);
    }
    
    private int parseIntegerParameter(String param, int defaultValue) {
        if (param == null || param.isEmpty()) {
            return defaultValue;
        }
        try {
            int value = Integer.parseInt(param);
            return Math.max(value, 0);
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }
    
    private long calculateLowStockCount(List<ProductStock> products) {
        return products.stream().mapToLong(p -> p.isLowStock() ? 1 : 0).sum();
    }
    
    private long calculateNearExpirationCount(List<ProductStock> products) {
        return products.stream().mapToLong(p -> p.isNearExpiration() ? 1 : 0).sum();
    }
    
    private void setRequestAttributes(HttpServletRequest request, List<ProductStock> products,
                                    int page, int totalPages, int pageSize, int totalProducts,
                                    String search, String sortBy, String sortOrder,
                                    long lowStockCount, long nearExpirationCount) {
        request.setAttribute("products", products);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("totalProducts", totalProducts);
        request.setAttribute("search", search != null ? search : "");
        request.setAttribute("sortBy", sortBy != null ? sortBy : "");
        request.setAttribute("sortOrder", sortOrder);
        request.setAttribute("lowStockCount", lowStockCount);
        request.setAttribute("nearExpirationCount", nearExpirationCount);
    }
}