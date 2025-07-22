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
import jakarta.servlet.http.HttpSession;
import model.Users;

/**
 *
 * @author phucn
 */
public class EditProfileServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet EditProfileServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet EditProfileServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Users user = (Users) (session != null ? session.getAttribute("user") : null);
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        Users latestUser = userDAO.getUserById(user.getId());
        if (latestUser != null) {
            session.setAttribute("user", latestUser); // cập nhật session
            request.setAttribute("user", latestUser);
        } else {
            request.setAttribute("user", user);
        }
        request.getRequestDispatcher("EditProfile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Users sessionUser = (session != null) ? (Users) session.getAttribute("user") : null;
        if (sessionUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int id = sessionUser.getId();
        String fullname = request.getParameter("fullname");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String dobStr = request.getParameter("dob");

        // Validate thông tin đầu vào
        if (fullname == null || fullname.trim().isEmpty()
                || email == null || email.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập đầy đủ thông tin bắt buộc!");
            request.setAttribute("user", sessionUser);
            request.getRequestDispatcher("EditProfile.jsp").forward(request, response);
            return;
        }

        java.sql.Date dob = null;
        try {
            if (dobStr != null && !dobStr.trim().isEmpty()) {
                dob = java.sql.Date.valueOf(dobStr);
            }
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", "Ngày sinh không hợp lệ!");
            request.setAttribute("user", sessionUser);
            request.getRequestDispatcher("EditProfile.jsp").forward(request, response);
            return;
        }

        if (dob != null) {
            java.time.LocalDate birth = dob.toLocalDate();
            java.time.LocalDate now = java.time.LocalDate.now();
            int age = java.time.Period.between(birth, now).getYears();
            if (age < 18 || age > 60) {
                request.setAttribute("error", "Tuổi người dùng phải từ 18 đến 60!");
                request.setAttribute("user", sessionUser);
                request.getRequestDispatcher("EditProfile.jsp").forward(request, response);
                return;
            }
        }

        // Cập nhật user
        Users updatedUser = new Users();
        updatedUser.setId(id);
        updatedUser.setFullname(fullname);
        updatedUser.setEmail(email);
        updatedUser.setPhone(phone);
        updatedUser.setDob(dob);

        try {
            userDAO.updateProfile(updatedUser);
            Users userReload = userDAO.getUserById(id);
            session.setAttribute("user", userReload);
            request.setAttribute("success", "Cập nhật thông tin thành công!");
            request.setAttribute("user", userReload);
        } catch (Exception e) {
            request.setAttribute("error", "Có lỗi khi cập nhật thông tin.");
            request.setAttribute("user", sessionUser);
        }
        request.getRequestDispatcher("EditProfile.jsp").forward(request, response);
    }
}
