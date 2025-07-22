package controller;

import dao.ProductInfoDAO;
import model.ProductInfo;
import model.Users;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "DeletedProductsController", urlPatterns = {"/deleted-products"})
public class DeletedProductsController extends HttpServlet {
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
        List<ProductInfo> deletedProducts = productDAO.getDeletedProducts();
        request.setAttribute("deletedProducts", deletedProducts);
        request.getRequestDispatcher("deleted-products.jsp").forward(request, response);
    }
} 