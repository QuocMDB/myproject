package controller;

import dao.ProductInfoDAO;
import dao.CategoryProductDAO;
import dao.UnitDAO;
import dao.SupplierDAO;
import model.ProductInfo;
import model.CategoryProduct;
import model.Unit;
import model.Supplier;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Controller for displaying detailed product information
 */
public class ProductDetailController extends HttpServlet {
    
    private final transient ProductInfoDAO productDAO = new ProductInfoDAO();
    private final transient CategoryProductDAO categoryDAO = new CategoryProductDAO();
    private final transient UnitDAO unitDAO = new UnitDAO();
    private final transient SupplierDAO supplierDAO = new SupplierDAO();

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
        
        try {
            // Get product ID from request
            String productIdParam = request.getParameter("id");
            
            if (productIdParam == null || productIdParam.trim().isEmpty()) {
                response.sendRedirect("product-list?error=Product ID is required");
                return;
            }
            
            int productId;
            try {
                productId = Integer.parseInt(productIdParam.trim());
            } catch (NumberFormatException e) {
                response.sendRedirect("product-list?error=Invalid product ID format");
                return;
            }
            
            // Get product details
            ProductInfo product = productDAO.getProductById(productId);
            
            if (product == null) {
                response.sendRedirect("product-list?error=Product not found");
                return;
            }
            
            // Get additional information
            CategoryProduct category = null;
            if (product.getCate_id() > 0) {
                category = categoryDAO.getCategoryById(product.getCate_id());
            }
            
            Unit unit = null;
            if (product.getUnit_id() > 0) {
                unit = unitDAO.getUnitById(product.getUnit_id());
            }
            
            Supplier supplier = null;
            if (product.getSupplierId() > 0) {
                supplier = supplierDAO.getSupplierByID(product.getSupplierId());
            }
            
            // Set attributes for JSP
            request.setAttribute("product", product);
            request.setAttribute("category", category);
            request.setAttribute("unit", unit);
            request.setAttribute("supplier", supplier);
            
            // Calculate stock status
            if (product.getStockQuantity() != null && product.getMinStockThreshold() != null) {
                boolean isLowStock = product.getStockQuantity().compareTo(product.getMinStockThreshold()) <= 0;
                request.setAttribute("isLowStock", isLowStock);
            }
            
            // Forward to product detail page
            request.getRequestDispatcher("product-detail.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("product-list?error=An error occurred while loading product details");
        }
    }
}
