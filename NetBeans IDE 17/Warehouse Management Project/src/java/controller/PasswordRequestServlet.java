/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.UserDAO;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;
import static java.util.Collections.list;
import java.util.List;
import model.ForgotPasswordRequest;

/**
 *
 * @author phucn
 */
public class PasswordRequestServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet PasswordRequestServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet PasswordRequestServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    UserDAO dao = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        // Đảm bảo chỉ admin mới vào được (nếu cần)
        model.Users user = (model.Users) session.getAttribute("user");
        if (!"Admin".equalsIgnoreCase(user.getRoleName())) {
            response.sendRedirect("login.jsp");
            return;
        }

        List<ForgotPasswordRequest> requests = dao.getAllRequests();
        String msg = (String) session.getAttribute("msg");
        session.removeAttribute("msg");
        request.setAttribute("msg", msg);
        request.setAttribute("requests", requests);
        System.out.println("Số lượng đơn yêu cầu: " + requests.size());

        RequestDispatcher rd = request.getRequestDispatcher("password_request.jsp");
        rd.forward(request, response);

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        int reqId = Integer.parseInt(request.getParameter("reqId"));

        HttpSession session = request.getSession();
        model.Users user = (model.Users) session.getAttribute("user");
        if (user == null || !"Admin".equalsIgnoreCase(user.getRoleName())) {
            response.sendRedirect("login.jsp");
            return;
        }
        int adminId = user.getId();

        boolean success = dao.updateRequestStatus(reqId, adminId,
                "approve".equals(action) ? "approved" : "rejected");
        session.setAttribute("msg", success ? "Xử lý yêu cầu thành công!" : "Có lỗi, vui lòng thử lại!");
        response.sendRedirect("passwordrequest");
    }

}