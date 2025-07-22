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
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;
import model.Permission;
import model.Role;
import model.Users;

/**
 *
 * @author phucn
 */
public class RolePermissionServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet RolePermissionServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet RolePermissionServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    private UserDAO dao = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Role> roles = dao.getAllRoles();
        List<Permission> permissions = dao.getAllPermissions();

        // Lọc theo search (tên quyền)
        String search = request.getParameter("search");
        if (search != null && !search.trim().isEmpty()) {
            String lowerSearch = search.trim().toLowerCase();
            permissions = permissions.stream()
                    .filter(p -> p.getName().toLowerCase().contains(lowerSearch))
                    .collect(Collectors.toList());
        }

        // Lọc theo code
        String code = request.getParameter("code");
        if (code != null && !code.trim().isEmpty()) {
            String lowerCode = code.trim().toLowerCase();
            permissions = permissions.stream()
                    .filter(p -> p.getCode().toLowerCase().contains(lowerCode))
                    .collect(Collectors.toList());
        }

        // Lọc theo vai trò
        String roleIdStr = request.getParameter("role");
        Integer filterRoleId = null;
        if (roleIdStr != null && !roleIdStr.isEmpty()) {
            try {
                filterRoleId = Integer.parseInt(roleIdStr);
            } catch (Exception e) {
            }
        }
        List<Role> filteredRoles = roles;
        if (filterRoleId != null) {
            final Integer selectedRoleId = filterRoleId;
            filteredRoles = roles.stream()
                    .filter(r -> r.getId() == selectedRoleId)
                    .collect(Collectors.toList());

        }

        // Phân trang
        int pageSize = 10;
        int page = 1;
        String pageStr = request.getParameter("page");
        if (pageStr != null) try {
            page = Integer.parseInt(pageStr);
        } catch (Exception e) {
        }
        if (page < 1) {
            page = 1;
        }

        int totalItems = permissions.size();
        int totalPages = (int) Math.ceil(totalItems / (double) pageSize);
        int fromIdx = (page - 1) * pageSize;
        int toIdx = Math.min(page * pageSize, totalItems);
        if (fromIdx > totalItems) {
            fromIdx = 0;
        }
        List<Permission> pageList = permissions.subList(fromIdx, toIdx);

        // Map roleId -> List<permissionId>
        Map<Integer, List<Integer>> rolePermissions = new HashMap<>();
        for (Role role : roles) {
            List<Integer> perms = dao.getPermissionIdsByRoleId(role.getId());
            rolePermissions.put(role.getId(), perms);
        }

        request.setAttribute("roles", filteredRoles);
        request.setAttribute("permissions", pageList);
        request.setAttribute("rolePermissions", rolePermissions);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);

        request.setAttribute("filterSearch", search);
        request.setAttribute("filterCode", code);
        request.setAttribute("filterRole", roleIdStr);

        request.getRequestDispatcher("permission.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String search = request.getParameter("search");
        String code = request.getParameter("code");
        String role = request.getParameter("role");
        String pageStr = request.getParameter("page");
        int page = 1;
        if (pageStr != null) try {
            page = Integer.parseInt(pageStr);
        } catch (Exception e) {
        }
            List<Role> roles = dao.getAllRoles();
            List<Permission> allPermissions = dao.getAllPermissions();

            // Áp dụng filter để lấy permission trên trang hiện tại
            String lowerSearch = (search != null) ? search.trim().toLowerCase() : "";
            String lowerCode = (code != null) ? code.trim().toLowerCase() : "";
            List<Permission> filteredPermissions = allPermissions;
            if (!lowerSearch.isEmpty()) {
                filteredPermissions = filteredPermissions.stream()
                        .filter(p -> p.getName().toLowerCase().contains(lowerSearch))
                        .collect(Collectors.toList());
            }
            if (!lowerCode.isEmpty()) {
                filteredPermissions = filteredPermissions.stream()
                        .filter(p -> p.getCode().toLowerCase().contains(lowerCode))
                        .collect(Collectors.toList());
            }

            int pageSize = 10;
            int totalItems = filteredPermissions.size();
            int fromIdx = (page - 1) * pageSize;
            int toIdx = Math.min(page * pageSize, totalItems);
            if (fromIdx > totalItems) {
                fromIdx = 0;
            }
            List<Permission> pagePermissions = filteredPermissions.subList(fromIdx, toIdx);
            List<Integer> pagePermIds = pagePermissions.stream().map(Permission::getId).collect(Collectors.toList());

            for (Role roleObj : roles) {
                // checkedPerms: quyền được check trên trang này
                List<Integer> checkedPerms = new ArrayList<>();
                for (Permission perm : pagePermissions) {
                    String param = "perm_" + perm.getId() + "_role_" + roleObj.getId();
                    if (request.getParameter(param) != null) {
                        checkedPerms.add(perm.getId());
                    }
                }
                // Xóa chỉ các quyền thuộc trang này cho vai trò đó
                dao.deletePermissionsOfRoleForPermissions(roleObj.getId(), pagePermIds);
                // Thêm các quyền được chọn trên trang hiện tại
                if (!checkedPerms.isEmpty()) {
                    dao.addPermissionsToRole(roleObj.getId(), checkedPerms);
                }

            }
            try {
            // Redirect giữ filter, page và báo thành công
            StringBuilder sb = new StringBuilder("role-permission?success=1");
            if (search != null && !search.trim().isEmpty()) {
                sb.append("&search=").append(java.net.URLEncoder.encode(search, "UTF-8"));
            }
            if (code != null && !code.trim().isEmpty()) {
                sb.append("&code=").append(java.net.URLEncoder.encode(code, "UTF-8"));
            }
            if (role != null && !role.isEmpty()) {
                sb.append("&role=").append(java.net.URLEncoder.encode(role, "UTF-8"));
            }
            if (pageStr != null) {
                sb.append("&page=").append(pageStr);
            }

            response.sendRedirect(sb.toString());

        } catch (Exception e) {
            response.sendRedirect("role-permission?error=1");
        }
    }
}


