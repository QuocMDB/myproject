package controller;

// Controller for updating product information

import dao.ProductInfoDAO;
import model.CategoryProduct;
import model.ProductInfo;
import model.Supplier;
import model.Unit;
import model.Users;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class UpdateProductController extends HttpServlet {
    
    private final ProductInfoDAO productDAO = new ProductInfoDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        System.out.println("DEBUG: UpdateProductController doGet method called");
        System.out.println("DEBUG: Request URI: " + request.getRequestURI());
        System.out.println("DEBUG: Query String: " + request.getQueryString());
        
        // Check user authentication and authorization
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user");
        if (user == null) {
            System.out.println("DEBUG: User not authenticated, redirecting to login");
            response.sendRedirect("login.jsp");
            return;
        }
        
        System.out.println("DEBUG: User authenticated: " + user.getFullname() + " (Role: " + user.getRoleName() + ")");
        
        String productIdStr = request.getParameter("id");
        System.out.println("DEBUG: Product ID parameter: " + productIdStr);
        
        if (productIdStr == null || productIdStr.trim().isEmpty()) {
            System.out.println("DEBUG: Product ID is null or empty");
            response.sendRedirect("product-list?error=Không tìm thấy sản phẩm!");
            return;
        }
        
        try {
            int productId = Integer.parseInt(productIdStr);
            System.out.println("DEBUG: Parsed product ID: " + productId);
            
            // Get product details
            System.out.println("DEBUG: Calling productDAO.getProductById(" + productId + ")");
            ProductInfo product = productDAO.getProductById(productId);
            System.out.println("DEBUG: Product from DAO: " + (product != null ? product.getName() : "null"));
            
            if (product == null) {
                System.out.println("DEBUG: Product is null, redirecting with error");
                response.sendRedirect("product-list?error=Sản phẩm không tồn tại!");
                return;
            }
            
            // Load dropdown data FIRST
            System.out.println("DEBUG: Loading dropdown data");
            loadDropdownData(request);
            
            // Set product data for form - Make sure this is set
            request.setAttribute("product", product);
            request.setAttribute("mode", "edit");
            
            // Debug log
            System.out.println("DEBUG: Product set in request: " + product.getName() + " (ID: " + product.getId() + ")");
            System.out.println("DEBUG: Request attributes set, forwarding to JSP");
            System.out.println("DEBUG: About to forward to: update-product.jsp");
            
            // Forward to update product page
            request.getRequestDispatcher("update-product.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            System.out.println("DEBUG: NumberFormatException for product ID: " + e.getMessage());
            response.sendRedirect("product-list?error=ID sản phẩm không hợp lệ!");
        } catch (Exception e) {
            System.out.println("DEBUG: Exception in doGet: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("product-list?error=Có lỗi xảy ra khi tải thông tin sản phẩm!");
        }
        
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check user authentication and authorization
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user");
        if (user == null || !"Admin".equalsIgnoreCase(user.getRoleName())) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        try {
            // Get product ID
            int productId = Integer.parseInt(request.getParameter("id"));
            
            // Get existing product
            ProductInfo existingProduct = productDAO.getProductById(productId);
            if (existingProduct == null) {
                request.setAttribute("error", "Sản phẩm không tồn tại!");
                loadDropdownData(request);
                request.getRequestDispatcher("update-product.jsp").forward(request, response);
                return;
            }
            
            // Validate and collect form data
            String validationError = validateAndSetProductData(request, existingProduct, user.getId());
            
            if (validationError != null) {
                request.setAttribute("error", validationError);
                request.setAttribute("product", existingProduct);
                loadDropdownData(request);
                request.getRequestDispatcher("update-product.jsp").forward(request, response);
                return;
            }
            
            // Update product in database
            boolean success = productDAO.updateProduct(existingProduct);
            
            System.out.println("DEBUG: Update product result: " + success);
            System.out.println("DEBUG: Product ID: " + productId);
            System.out.println("DEBUG: Product name: " + existingProduct.getName());
            
            if (success) {
                // Update stock quantity if provided
                String stockQuantityStr = request.getParameter("stockQuantity");
                if (stockQuantityStr != null && !stockQuantityStr.trim().isEmpty()) {
                    try {
                        double stockQuantity = Double.parseDouble(stockQuantityStr);
                        productDAO.updateProductStock(productId, stockQuantity);
                        System.out.println("DEBUG: Stock updated to: " + stockQuantity);
                    } catch (NumberFormatException e) {
                        System.err.println("Failed to update stock quantity: " + e.getMessage());
                    }
                }
                
                System.out.println("DEBUG: Update successful, preparing redirect");
                
                // Set success attributes for ProductSuccessNotification.jsp
                request.setAttribute("productName", existingProduct.getName());
                request.setAttribute("productCode", existingProduct.getCode());
                request.setAttribute("successMessage", "Sản phẩm '" + existingProduct.getName() + "' đã được cập nhật thành công!");
                
                // Forward to success page instead of redirect
                request.getRequestDispatcher("ProductSuccessNotification.jsp").forward(request, response);
                return;
            } else {
                request.setAttribute("error", "Có lỗi xảy ra khi cập nhật sản phẩm. Vui lòng thử lại!");
                request.setAttribute("product", existingProduct);
                loadDropdownData(request);
                request.getRequestDispatcher("update-product.jsp").forward(request, response);
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect("product-list?error=ID sản phẩm không hợp lệ!");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi hệ thống xảy ra. Vui lòng thử lại sau!");
            loadDropdownData(request);
            request.getRequestDispatcher("update-product.jsp").forward(request, response);
        }
    }
    
    private String validateAndSetProductData(HttpServletRequest request, ProductInfo product, int userId) {
        // Get form parameters
        String name = request.getParameter("name");
        String code = request.getParameter("code");
        String categoryIdStr = request.getParameter("categoryId");
        String unitIdStr = request.getParameter("unitId");
        String supplierIdStr = request.getParameter("supplierId");
        String status = request.getParameter("status");
        String description = request.getParameter("description");
        String expirationDateStr = request.getParameter("expirationDate");
        String additionalNotes = request.getParameter("additionalNotes");
        String minStockThresholdStr = request.getParameter("minStockThreshold");
        
        // Basic validation
        if (name == null || name.trim().isEmpty()) {
            return "Tên sản phẩm không được để trống!";
        }
        
        if (code == null || code.trim().isEmpty()) {
            // For updates, if code is missing, use the existing code
            code = product.getCode();
        }
        
        // Check for duplicate product code (excluding current product)
        if (productDAO.isProductCodeExistsForOtherProduct(code.trim(), product.getId())) {
            return "Mã sản phẩm đã tồn tại! Vui lòng chọn mã khác.";
        }
        
        // Set basic product data
        product.setName(name.trim());
        product.setCode(code.trim());
        product.setStatus(status != null ? status : "active");
        product.setDescription(description != null ? description.trim() : "");
        product.setAdditionalNotes(additionalNotes != null ? additionalNotes.trim() : "");
        product.setUpdatedBy(userId);
        
        // Parse and set numeric fields
        try {
            if (categoryIdStr != null && !categoryIdStr.trim().isEmpty()) {
                product.setCate_id(Integer.parseInt(categoryIdStr));
            }
            
            if (unitIdStr != null && !unitIdStr.trim().isEmpty()) {
                product.setUnit_id(Integer.parseInt(unitIdStr));
            }
            
            if (supplierIdStr != null && !supplierIdStr.trim().isEmpty()) {
                product.setSupplierId(Integer.parseInt(supplierIdStr));
            }
            
            if (expirationDateStr != null && !expirationDateStr.trim().isEmpty()) {
                Date expirationDate = Date.valueOf(expirationDateStr);
                product.setExpirationDate(expirationDate);
            }
            
            if (minStockThresholdStr != null && !minStockThresholdStr.trim().isEmpty()) {
                BigDecimal minStockThreshold = new BigDecimal(minStockThresholdStr);
                if (minStockThreshold.compareTo(BigDecimal.ZERO) >= 0) {
                    product.setMinStockThreshold(minStockThreshold);
                } else {
                    product.setMinStockThreshold(BigDecimal.ZERO);
                }
            } else {
                product.setMinStockThreshold(BigDecimal.ZERO);
            }
            
        } catch (NumberFormatException e) {
            return "Dữ liệu số không hợp lệ! Vui lòng kiểm tra lại.";
        } catch (IllegalArgumentException e) {
            return "Ngày hết hạn không hợp lệ! Vui lòng sử dụng định dạng YYYY-MM-DD.";
        }
        
        return null; // No validation errors
    }
    
    private void loadDropdownData(HttpServletRequest request) {
        try {
            System.out.println("DEBUG: Loading categories...");
            List<CategoryProduct> categories = productDAO.getAllActiveCategories();
            System.out.println("DEBUG: Categories loaded: " + (categories != null ? categories.size() : "null"));
            
            System.out.println("DEBUG: Loading units...");
            List<Unit> units = productDAO.getAllActiveUnits();
            System.out.println("DEBUG: Units loaded: " + (units != null ? units.size() : "null"));
            
            System.out.println("DEBUG: Loading suppliers...");
            List<Supplier> suppliers = productDAO.getAllActiveSuppliers();
            System.out.println("DEBUG: Suppliers loaded: " + (suppliers != null ? suppliers.size() : "null"));
            
            request.setAttribute("categories", categories != null ? categories : List.of());
            request.setAttribute("units", units != null ? units : List.of());
            request.setAttribute("suppliers", suppliers != null ? suppliers : List.of());
            
            System.out.println("DEBUG: All dropdown data loaded and set in request");
            
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("ERROR in loadDropdownData: " + e.getMessage());
            // Set empty lists if there's an error
            request.setAttribute("categories", List.of());
            request.setAttribute("units", List.of());
            request.setAttribute("suppliers", List.of());
        }
    }
}
