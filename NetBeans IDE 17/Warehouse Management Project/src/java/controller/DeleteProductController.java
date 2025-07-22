package controller;

// Controller for deleting a product

import dao.ProductInfoDAO;
import model.ProductInfo;
import model.Users;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class DeleteProductController extends HttpServlet {
    
    private final ProductInfoDAO productDAO = new ProductInfoDAO();
      @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Debug logging
        System.out.println("DeleteProductController: doGet method called");
        
        // Check user authentication and authorization
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user");
        if (user == null || !"Admin".equalsIgnoreCase(user.getRoleName())) {
            System.out.println("DeleteProductController: User not authenticated or not Admin");
            response.sendRedirect("login.jsp");
            return;
        }
          String productIdStr = request.getParameter("id");
        System.out.println("DeleteProductController: Product ID parameter = " + productIdStr);
        
        if (productIdStr == null || productIdStr.trim().isEmpty()) {
            System.out.println("DeleteProductController: Product ID is null or empty");
            showAlertAndBack(response, "Không tìm thấy sản phẩm!");
            return;
        }
        
        try {
            int productId = Integer.parseInt(productIdStr);
            System.out.println("DeleteProductController: Parsed product ID = " + productId);
              // Get product details before deletion
            ProductInfo product = productDAO.getProductById(productId);
            if (product == null) {
                System.out.println("DeleteProductController: Product not found in database");
                showAlertAndBack(response, "Sản phẩm không tồn tại!");
                return;
            }
            
            System.out.println("DeleteProductController: Found product = " + product.getName());
            
            // Always perform soft delete
            boolean success = productDAO.deleteProduct(productId);
            System.out.println("DeleteProductController: Soft delete operation result = " + success);
              if (success) {
                // Log the deletion activity
                System.out.println("Product soft deleted successfully: " + product.getName() + " (ID: " + productId + ") by user: " + user.getUsername());
                
                // Redirect to product list
                response.sendRedirect("product-list");
            } else {
                System.out.println("DeleteProductController: Soft delete operation failed");
                showAlertAndBack(response, "Có lỗi xảy ra khi xóa sản phẩm. Vui lòng thử lại!");
            }
              } catch (NumberFormatException e) {
            System.out.println("DeleteProductController: Invalid product ID format - " + e.getMessage());
            showAlertAndBack(response, "ID sản phẩm không hợp lệ!");
        } catch (Exception e) {
            System.out.println("DeleteProductController: Exception occurred - " + e.getMessage());
            e.printStackTrace();
            showAlertAndBack(response, "Có lỗi hệ thống xảy ra!");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect POST requests to GET
        doGet(request, response);
    }

    private void showAlertAndBack(HttpServletResponse response, String message) throws IOException {
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write("<script>alert('" + message.replace("'", "\\'") + "'); window.history.back();</script>");
    }
}
