/*
     * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
     * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.DepartmentDAO;
import dao.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.mindrot.jbcrypt.BCrypt;
import java.util.List;
import model.Department;
import model.Users;

/**
 *
 * @author phucn
 */
public class AdduserServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet AdduserServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AdduserServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        DepartmentDAO deptDAO = new DepartmentDAO();
        List<Department> departments = deptDAO.getAllDepartments();
        request.setAttribute("departments", departments);
        request.getRequestDispatcher("AddUser.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        DepartmentDAO deptDAO = new DepartmentDAO();
        List<Department> departments = deptDAO.getAllDepartments();
        request.setAttribute("departments", departments);

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

        String fullname = request.getParameter("fullname");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String dobStr = request.getParameter("dob");
        int activeFlag = Integer.parseInt(request.getParameter("activeFlag"));
        int roleId = Integer.parseInt(request.getParameter("role"));
        String departmentIdStr = request.getParameter("departmentId");
        Integer departmentId = null;
        if (departmentIdStr != null && !departmentIdStr.isEmpty()) {
            try {
                departmentId = Integer.parseInt(departmentIdStr);
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Phòng ban không hợp lệ!");
                request.getRequestDispatcher("AddUser.jsp").forward(request, response);
                return;
            }
        }

        Users user = new Users();
        user.setUsername(username);
        user.setPassword(hashedPassword);

        user.setFullname(fullname);
        user.setEmail(email);
        user.setPhone(phone);

        // Xử lý ngày sinh
        java.sql.Date dob = null;
        try {
            if (dobStr != null && !dobStr.trim().isEmpty()) {
                dob = java.sql.Date.valueOf(dobStr); // Format: yyyy-MM-dd
            }
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", "Ngày sinh không hợp lệ!");
            request.getRequestDispatcher("AddUser.jsp").forward(request, response);
            return;
        }
        user.setDob(dob); // Đặt giá trị ngày sinh
        if (dob != null) {
            java.time.LocalDate birthDate = dob.toLocalDate();
            java.time.LocalDate today = java.time.LocalDate.now();
            int age = java.time.Period.between(birthDate, today).getYears();

            if (age < 18 || age > 60) {
                request.setAttribute("error", "Tuổi người dùng phải từ 18 đến 60!");
                request.getRequestDispatcher("AddUser.jsp").forward(request, response);
                return;
            }
        }

        user.setDepartmentId(departmentId);
        user.setActiveFlag(activeFlag);

        try {
            UserDAO userDAO = new UserDAO();
            userDAO.addUser(user, roleId);
            HttpSession session = request.getSession();
            session.setAttribute("message", "Thêm người dùng thành công!");
            response.sendRedirect("adduser");
        } catch (Exception e) {
            request.setAttribute("error", "Không thể thêm người dùng");
            request.getRequestDispatcher("AddUser.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}