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
import java.util.List;
import model.Department;
import model.Users;

/**
 *
 * @author phucn
 */
public class UserManager extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet UserManager</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet UserManager at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("/login.jsp");
            return;
        }

        // Đọc các param filter/search
        String roleParam = request.getParameter("role");
        String status = request.getParameter("status");
        String keyword = request.getParameter("keyword");
        String departmentIdStr = request.getParameter("departmentId");
        String pageParam = request.getParameter("page");
        int pageIndex = 1;
        int pageSize = 10;
        if (pageParam != null) {
            try {
                pageIndex = Integer.parseInt(pageParam);
                if (pageIndex < 1) {
                    pageIndex = 1;
                }
            } catch (NumberFormatException e) {
                pageIndex = 1;
            }
        }

        boolean includeAdmin = false;
        Integer roleId = null;
        Integer departmentId = null;

        if (roleParam != null) {
            if ("all".equalsIgnoreCase(roleParam)) {
                includeAdmin = true;
            } else {
                try {
                    roleId = Integer.parseInt(roleParam);
                } catch (NumberFormatException e) {
                    roleId = null;
                }
            }
        }
        if (departmentIdStr != null && !departmentIdStr.trim().isEmpty()) {
            try {
                departmentId = Integer.parseInt(departmentIdStr);
            } catch (NumberFormatException e) {
                departmentId = null;
            }
        }

        // Truy vấn phòng ban cho dropdown
        DepartmentDAO deptDAO = new DepartmentDAO();
        List<Department> departments = deptDAO.getAllDepartments();
        request.setAttribute("departments", departments);

        // Truy vấn user theo filter và phân trang
        UserDAO userDAO = new UserDAO();

        // Lấy tổng số user theo filter
        int totalUsers = userDAO.countFilteredUsers(roleId, status, keyword, departmentId, includeAdmin);
        int totalPages = (int) Math.ceil((double) totalUsers / pageSize);
        if (pageIndex > totalPages && totalPages > 0) {
            pageIndex = totalPages;
        }
        if (pageIndex < 1) {
            pageIndex = 1;
        }

        List<Users> userList = userDAO.filterUsersWithPaging(roleId, status, keyword, departmentId, includeAdmin, pageIndex, pageSize);

        request.setAttribute("userList", userList);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentPage", pageIndex);

        // Giữ lại các filter param để trả lại view
        request.setAttribute("roleSelected", roleParam);
        request.setAttribute("statusSelected", status);
        request.setAttribute("keyword", keyword);
        request.setAttribute("departmentIdSelected", departmentIdStr);

        request.getRequestDispatcher("UserManager.jsp").forward(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
