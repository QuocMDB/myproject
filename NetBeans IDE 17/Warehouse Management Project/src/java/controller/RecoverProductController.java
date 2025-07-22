package controller;

import dao.ProductInfoDAO;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Users;

@WebServlet(name = "RecoverProductController", urlPatterns = {"/recover-product"})
public class RecoverProductController extends HttpServlet {
    private final ProductInfoDAO productDAO = new ProductInfoDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user");
        if (user == null || !"Admin".equalsIgnoreCase(user.getRoleName())) {
            response.sendRedirect("login.jsp");
            return;
        }
        String productIdStr = request.getParameter("id");
        if (productIdStr == null || productIdStr.trim().isEmpty()) {
            String errorMsg = URLEncoder.encode("Không tìm thấy sản phẩm để khôi phục!", StandardCharsets.UTF_8);
            response.sendRedirect("product-list?error=" + errorMsg);
            return;
        }
        try {
            int productId = Integer.parseInt(productIdStr);
            boolean success = productDAO.recoverProduct(productId);
            if (success) {
                String successMsg = URLEncoder.encode("Đã khôi phục sản phẩm thành công!", StandardCharsets.UTF_8);
                response.sendRedirect("product-list?success=" + successMsg);
            } else {
                String errorMsg = URLEncoder.encode("Không thể khôi phục sản phẩm. Vui lòng thử lại!", StandardCharsets.UTF_8);
                response.sendRedirect("product-list?error=" + errorMsg);
            }
        } catch (NumberFormatException e) {
            String errorMsg = URLEncoder.encode("ID sản phẩm không hợp lệ!", StandardCharsets.UTF_8);
            response.sendRedirect("product-list?error=" + errorMsg);
        } catch (Exception e) {
            e.printStackTrace();
            String errorMsg = URLEncoder.encode("Có lỗi hệ thống xảy ra!", StandardCharsets.UTF_8);
            response.sendRedirect("product-list?error=" + errorMsg);
        }
    }
} 