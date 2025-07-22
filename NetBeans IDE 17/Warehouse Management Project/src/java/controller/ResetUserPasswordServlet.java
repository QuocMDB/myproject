/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import dao.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.ForgotPasswordRequest;
import model.Users;
import org.mindrot.jbcrypt.BCrypt;

/**
 *
 * @author phucn
 */
public class ResetUserPasswordServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet ResetUserPasswordServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ResetUserPasswordServlet at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

    private UserDAO userDao = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String reqIdStr = request.getParameter("reqId");
        ForgotPasswordRequest req = null;
        Users targetUser = null;
        if (reqIdStr != null) {
            try {
                int reqId = Integer.parseInt(reqIdStr);
                req = userDao.getPasswordResetRequestById(reqId);
                if (req != null) {
                    targetUser = userDao.getUserById(req.getUserId());
                }
            } catch (Exception e) {
                request.setAttribute("msg", "Không tìm thấy yêu cầu đổi mật khẩu!");
            }
        }
        request.setAttribute("resetRequest", req);
        request.setAttribute("targetUser", targetUser);
        request.getRequestDispatcher("reset_user_password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String reqIdStr = request.getParameter("reqId");
        String userIdStr = request.getParameter("userId");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        String msg = null;

        if (newPassword == null || !newPassword.equals(confirmPassword)) {
            msg = "Mật khẩu xác nhận không khớp!";
        } else if (newPassword.length() < 6) {
            msg = "Mật khẩu phải từ 6 ký tự trở lên!";
        } else {
            try {
                int userId = Integer.parseInt(userIdStr);
                int reqId = Integer.parseInt(reqIdStr);
                // Hash password trước khi lưu
                String hashedPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt(12));
                Users admin = (Users) request.getSession().getAttribute("user");
                boolean updated = userDao.approveAndUpdate(reqId, userId, hashedPassword, admin.getId());
                if (updated) {
                    msg = "Cập nhật mật khẩu thành công và đã duyệt yêu cầu!";
                    response.sendRedirect("passwordrequest?msg=" + java.net.URLEncoder.encode(msg, "UTF-8"));
                    return;
                } else {
                    msg = "Không thể cập nhật mật khẩu!";
                }
            } catch (Exception e) {
                msg = "Có lỗi xảy ra: " + e.getMessage();
            }
        }

        doGet(request, response);
        request.setAttribute("msg", msg);
    }
}
