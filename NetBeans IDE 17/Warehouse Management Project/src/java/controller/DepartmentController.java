package controller;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import dao.DepartmentDAO;
import model.Department;
import model.Users;
import com.google.gson.Gson;
import com.google.gson.JsonObject;

@WebServlet(name = "DepartmentController", urlPatterns = {"/department/*"})
public class DepartmentController extends HttpServlet {

    private DepartmentDAO departmentDAO;

    // Constants for sorting
    private static final String DEFAULT_SORT_FIELD = "dept_name";
    private static final String DEFAULT_SORT_DIR = "asc";
    private static final String SORT_ASC = "asc";
    private static final String SORT_DESC = "desc";
    private static final String[] ALLOWED_SORT_FIELDS = {"id", "dept_code", "dept_name", "active_flag", "create_date", "update_date"};

    // Constants for pagination
    private static final int DEFAULT_PAGE_SIZE = 10;

    // Initialize DAO when servlet is created
    @Override
    public void init() {
        System.out.println("=== DepartmentController INIT CALLED ===");
        departmentDAO = new DepartmentDAO();
        System.out.println("=== DepartmentDAO initialized ===");
    }

    // Handle GET requests (display pages)
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("=== DepartmentController doGet called ===");
        System.out.println("PathInfo: " + request.getPathInfo());

        // Set UTF-8 encoding for Vietnamese display
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        // Check authentication
        if (!checkAuthentication(request, response)) {
            return;
        }

        // Get path to determine what user wants to do
        String pathInfo = request.getPathInfo();

        // Check path and call corresponding method
        if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("/list")) {
            showDepartmentListWithFilters(request, response);
        } else if (pathInfo.equals("/create")) {
            showCreateForm(request, response);
        } else if (pathInfo.equals("/edit")) {
            showEditForm(request, response);
        } else if (pathInfo.equals("/detail")) {
            showDepartmentDetail(request, response);
        } else if (pathInfo.equals("/toggle-status")) {
            toggleDepartmentStatus(request, response);
        } else if (pathInfo.equals("/employees")) {
            getEmployeesByDepartment(request, response);
        } else if (pathInfo.equals("/available-managers")) {
            getAvailableManagers(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    // Handle POST requests (process forms)
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("=== DepartmentController doPost called ===");
        System.out.println("PathInfo: " + request.getPathInfo());

        // Set UTF-8 encoding
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        // Check authentication
        if (!checkAuthentication(request, response)) {
            return;
        }

        String pathInfo = request.getPathInfo();

        if (pathInfo != null && pathInfo.equals("/create")) {
            createDepartment(request, response);
        } else if (pathInfo != null && pathInfo.equals("/edit")) {
            updateDepartment(request, response);
        } else if (pathInfo != null && pathInfo.equals("/assign-manager")) {
            assignManager(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/department/list");
        }
    }

    // Check authentication
    private boolean checkAuthentication(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        Users user = (Users) session.getAttribute("user");
        if (user == null || (!"Admin".equals(user.getRoleName()) && !"Nhân viên kho".equals(user.getRoleName()))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return false;
        }
        return true;
    }

    // Validate sortField
    private boolean isValidSortField(String sortField) {
        if (sortField == null) {
            return false;
        }
        for (String field : ALLOWED_SORT_FIELDS) {
            if (field.equalsIgnoreCase(sortField)) {
                return true;
            }
        }
        return false;
    }

    // Display create form
    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("=== showCreateForm called ===");

        try {
            // Get list of available managers for dropdown
            List<Map<String, Object>> availableManagers = departmentDAO.getAvailableManagers(0);

            request.setAttribute("availableManagers", availableManagers);

            // SỬA PATH: Từ /department/Department_create.jsp thành /Department_create.jsp
            request.getRequestDispatcher("/Department_create.jsp").forward(request, response);
        } catch (Exception e) {
            System.err.println("Error in showCreateForm: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }

    // Handle department creation
    private void createDepartment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user");

        // 1. Get data from form
        String deptCode = request.getParameter("deptCode");
        String deptName = request.getParameter("deptName");
        String description = request.getParameter("description");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String managerIdStr = request.getParameter("managerId");

        // 2. Check that required fields are not empty
        if (deptCode == null || deptCode.trim().isEmpty()) {
            request.setAttribute("error", "Mã phòng ban không được để trống");
            request.setAttribute("deptCode", deptCode);
            request.setAttribute("deptName", deptName);
            request.setAttribute("description", description);
            request.setAttribute("phone", phone);
            request.setAttribute("email", email);
            showCreateForm(request, response);
            return;
        }

        if (deptName == null || deptName.trim().isEmpty()) {
            request.setAttribute("error", "Tên phòng ban không được để trống");
            request.setAttribute("deptCode", deptCode);
            request.setAttribute("deptName", deptName);
            request.setAttribute("description", description);
            request.setAttribute("phone", phone);
            request.setAttribute("email", email);
            showCreateForm(request, response);
            return;
        }

        deptCode = deptCode.trim();
        deptName = deptName.trim();

        // 3. Check if department code already exists
        if (departmentDAO.isDeptCodeExists(deptCode)) {
            request.setAttribute("error", "Mã phòng ban đã tồn tại");
            request.setAttribute("deptCode", deptCode);
            request.setAttribute("deptName", deptName);
            request.setAttribute("description", description);
            request.setAttribute("phone", phone);
            request.setAttribute("email", email);
            showCreateForm(request, response);
            return;
        }

        // 4. Create Department object
        Department department = new Department();
        department.setDeptCode(deptCode);
        department.setDeptName(deptName);
        department.setDescription(description != null ? description.trim() : null);
        department.setPhone(phone != null && !phone.trim().isEmpty() ? phone.trim() : null);
        department.setEmail(email != null && !email.trim().isEmpty() ? email.trim() : null);
        department.setActiveFlag(true);
        department.setCreatedBy(user.getId());
        department.setCreateDate(LocalDateTime.now());
        department.setUpdatedBy(user.getId());
        department.setUpdateDate(LocalDateTime.now());

        // 5. Handle manager ID
        if (managerIdStr != null && !managerIdStr.trim().isEmpty() && !managerIdStr.equals("0")) {
            try {
                int managerId = Integer.parseInt(managerIdStr);
                department.setManagerId(managerId);
            } catch (NumberFormatException e) {
                department.setManagerId(null);
            }
        } else {
            department.setManagerId(null);
        }

        // 6. Validate department data
        if (!department.isValid()) {
            request.setAttribute("error", "Dữ liệu phòng ban không hợp lệ");
            request.setAttribute("deptCode", deptCode);
            request.setAttribute("deptName", deptName);
            request.setAttribute("description", description);
            request.setAttribute("phone", phone);
            request.setAttribute("email", email);
            showCreateForm(request, response);
            return;
        }

        // 7. Save to database
        boolean success = departmentDAO.createDepartment(department);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/department/list?message=create_success");
        } else {
            request.setAttribute("error", "Không thể thêm phòng ban");
            request.setAttribute("deptCode", deptCode);
            request.setAttribute("deptName", deptName);
            request.setAttribute("description", description);
            request.setAttribute("phone", phone);
            request.setAttribute("email", email);
            showCreateForm(request, response);
        }
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String idStr = request.getParameter("id");
            if (idStr == null || idStr.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/department/list?error=invalid_id");
                return;
            }

            int id = Integer.parseInt(idStr);

            Department department = departmentDAO.getDepartmentById(id);
            if (department == null) {
                response.sendRedirect(request.getContextPath() + "/department/list?error=not_found");
                return;
            }

            List<Map<String, Object>> availableManagers = departmentDAO.getAvailableManagers(id);

            // THÊM: Convert LocalDateTime to Date for JSTL
            if (department.getCreateDate() != null) {
                java.util.Date createDate = java.sql.Timestamp.valueOf(department.getCreateDate());
                request.setAttribute("createDate", createDate);
            }

            if (department.getUpdateDate() != null) {
                java.util.Date updateDate = java.sql.Timestamp.valueOf(department.getUpdateDate());
                request.setAttribute("updateDate", updateDate);
            }

            // DateTimeFormatter for direct formatting
            DateTimeFormatter dateTimeFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss");

            request.setAttribute("department", department);
            request.setAttribute("availableManagers", availableManagers);
            request.setAttribute("dateTimeFormatter", dateTimeFormatter);

            request.getRequestDispatcher("/Department_edit.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("Error in showEditForm: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/department/list?error=system_error");
        }
    }

    // Handle department update
    private void updateDepartment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user");

        // 1. Get data from form
        String idStr = request.getParameter("id");
        String deptCode = request.getParameter("deptCode");
        String deptName = request.getParameter("deptName");
        String description = request.getParameter("description");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String managerIdStr = request.getParameter("managerId");
        String activeFlagStr = request.getParameter("activeFlag");

        if (idStr == null || deptCode == null || deptCode.trim().isEmpty()
                || deptName == null || deptName.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/department/list?error=invalid_data");
            return;
        }

        try {
            int id = Integer.parseInt(idStr);
            deptCode = deptCode.trim();
            deptName = deptName.trim();

            // 2. Get current department
            Department currentDepartment = departmentDAO.getDepartmentById(id);
            if (currentDepartment == null) {
                response.sendRedirect(request.getContextPath() + "/department/list?error=not_found");
                return;
            }

            // 3. Check if department code already exists (excluding current one)
            if (departmentDAO.isDeptCodeExists(deptCode, id)) {
                request.setAttribute("error", "Mã phòng ban đã tồn tại");
                request.setAttribute("id", idStr);
                showEditForm(request, response);
                return;
            }

            // 4. Create Department object with updated data
            Department department = new Department();
            department.setId(id);
            department.setDeptCode(deptCode);
            department.setDeptName(deptName);
            department.setDescription(description != null ? description.trim() : null);
            department.setPhone(phone != null && !phone.trim().isEmpty() ? phone.trim() : null);
            department.setEmail(email != null && !email.trim().isEmpty() ? email.trim() : null);
            department.setActiveFlag("1".equals(activeFlagStr));
            department.setCreatedBy(currentDepartment.getCreatedBy());
            department.setCreateDate(currentDepartment.getCreateDate());
            department.setUpdatedBy(user.getId());
            department.setUpdateDate(LocalDateTime.now());

            // 5. Handle manager ID
            if (managerIdStr != null && !managerIdStr.trim().isEmpty() && !managerIdStr.equals("0")) {
                try {
                    int managerId = Integer.parseInt(managerIdStr);
                    department.setManagerId(managerId);
                } catch (NumberFormatException e) {
                    department.setManagerId(null);
                }
            } else {
                department.setManagerId(null);
            }

            // 6. Validate department data
            if (!department.isValid()) {
                request.setAttribute("error", "Dữ liệu phòng ban không hợp lệ");
                request.setAttribute("id", idStr);
                showEditForm(request, response);
                return;
            }

            // 7. Update database
            boolean success = departmentDAO.updateDepartment(department);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/department/list?message=update_success");
            } else {
                request.setAttribute("error", "Không thể cập nhật phòng ban");
                request.setAttribute("id", idStr);
                showEditForm(request, response);
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/department/list?error=invalid_id");
        }
    }

    // Show department detail
    private void showDepartmentDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Get ID from parameter
        String idStr = request.getParameter("id");
        if (idStr == null) {
            response.sendRedirect(request.getContextPath() + "/department/list?error=invalid_id");
            return;
        }

        try {
            int id = Integer.parseInt(idStr);

            // 2. Get department information
            Department department = departmentDAO.getDepartmentById(id);
            if (department == null) {
                response.sendRedirect(request.getContextPath() + "/department/list?error=not_found");
                return;
            }

            // 3. Get employees list
            List<Map<String, Object>> employees = departmentDAO.getEmployeesByDepartmentId(id);

            // 4. DateTimeFormatter
            DateTimeFormatter dateTimeFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss");

            // 5. Send data to JSP
            request.setAttribute("department", department);
            request.setAttribute("employees", employees);
            request.setAttribute("dateTimeFormatter", dateTimeFormatter);

            // SỬA PATH: Từ /department/Department_detail.jsp thành /Department_detail.jsp
            request.getRequestDispatcher("/Department_detail.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/department/list?error=invalid_id");
        }
    }

    // Method to display messages
    private void showMessage(HttpServletRequest request) {
        String message = request.getParameter("message");
        String error = request.getParameter("error");

        if (message != null) {
            switch (message) {
                case "create_success":
                    request.setAttribute("successMessage", "Thêm phòng ban thành công!");
                    break;
                case "update_success":
                    request.setAttribute("successMessage", "Cập nhật phòng ban thành công!");
                    break;
                case "assign_success":
                    request.setAttribute("successMessage", "Gán trưởng phòng thành công!");
                    break;
            }
        }

        if (error != null) {
            switch (error) {
                case "invalid_id":
                    request.setAttribute("errorMessage", "ID không hợp lệ");
                    break;
                case "not_found":
                    request.setAttribute("errorMessage", "Không tìm thấy phòng ban");
                    break;
                case "invalid_data":
                    request.setAttribute("errorMessage", "Dữ liệu không hợp lệ");
                    break;
                default:
                    request.setAttribute("errorMessage", "Đã xảy ra lỗi");
            }
        }
    }

    /**
     * Hiển thị danh sách phòng ban với bộ lọc nâng cao
     */
    private void showDepartmentListWithFilters(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("=== showDepartmentListWithFilters called ===");

        try {
            // 1. Get pagination parameters
            int page = getIntParameter(request, "page", 1);
            if (page < 1) {
                page = 1;
            }

            // 2. Get filter parameters
            String searchKeyword = getStringParameter(request, "search");
            String statusStr = getStringParameter(request, "status");
            String hasManagerStr = getStringParameter(request, "hasManager");
            String sortField = getStringParameter(request, "sortField");
            String sortDir = getStringParameter(request, "sortDir");

            // 3. Validate and set defaults
            if (!isValidSortField(sortField)) {
                sortField = DEFAULT_SORT_FIELD;
            }
            if (!SORT_ASC.equalsIgnoreCase(sortDir) && !SORT_DESC.equalsIgnoreCase(sortDir)) {
                sortDir = DEFAULT_SORT_DIR;
            }

            // 4. Calculate offset for pagination
            int offset = (page - 1) * DEFAULT_PAGE_SIZE;

            // 5. Get filtered data
            List<Department> departments = departmentDAO.getDepartments(
                    searchKeyword, statusStr, hasManagerStr, sortField, sortDir, page, DEFAULT_PAGE_SIZE);

            // 6. Get total count for pagination
            int totalDepartments = departmentDAO.countDepartments(searchKeyword, statusStr, hasManagerStr);
            int totalPages = (int) Math.ceil((double) totalDepartments / DEFAULT_PAGE_SIZE);

            // 7. Calculate pagination display
            calculatePaginationDisplay(request, page, totalPages);

            // 8. Set attributes for JSP
            request.setAttribute("departments", departments);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalDepartments", totalDepartments);
            request.setAttribute("searchKeyword", searchKeyword);
            request.setAttribute("status", statusStr);
            request.setAttribute("hasManager", hasManagerStr);
            request.setAttribute("sortField", sortField);
            request.setAttribute("sortDir", sortDir);

            // 9. Set reverse sort direction for table headers
            String reverseSortDir = SORT_ASC.equalsIgnoreCase(sortDir) ? SORT_DESC : SORT_ASC;
            request.setAttribute("reverseSortDir", reverseSortDir);

            // 10. Add DateTimeFormatter
            DateTimeFormatter dateTimeFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
            request.setAttribute("dateTimeFormatter", dateTimeFormatter);

            // 11. Show messages
            showMessage(request);

            // 12. Forward to JSP - SỬA PATH: Từ /department/Department_list.jsp thành /Department_list.jsp
            request.getRequestDispatcher("/Department_list.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("Error in showDepartmentListWithFilters: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }

    /**
     * Toggle trạng thái active/inactive của phòng ban
     */
    private void toggleDepartmentStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Set response type to JSON
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        JsonObject jsonResponse = new JsonObject();
        Gson gson = new Gson();

        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user");

        try {
            // 1. Get department ID
            String idStr = request.getParameter("id");
            if (idStr == null || idStr.trim().isEmpty()) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "ID không hợp lệ");
                response.getWriter().write(gson.toJson(jsonResponse));
                return;
            }

            int departmentId = Integer.parseInt(idStr);

            // 2. Get current department to check current status
            Department department = departmentDAO.getDepartmentById(departmentId);
            if (department == null) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Không tìm thấy phòng ban");
                response.getWriter().write(gson.toJson(jsonResponse));
                return;
            }

            boolean currentStatus = department.isActiveFlag();

            // 3. Toggle status
            boolean success = departmentDAO.toggleDepartmentStatus(departmentId, user.getId());

            if (success) {
                boolean newStatus = !currentStatus;

                jsonResponse.addProperty("success", true);
                jsonResponse.addProperty("newStatus", newStatus ? "Hoạt động" : "Không hoạt động");
                jsonResponse.addProperty("statusClass", newStatus ? "badge-success" : "badge-secondary");
                jsonResponse.addProperty("buttonText", newStatus ? "Vô hiệu hóa" : "Kích hoạt");
                jsonResponse.addProperty("buttonClass", newStatus ? "btn-danger" : "btn-success");
                jsonResponse.addProperty("message", newStatus
                        ? "Đã kích hoạt phòng ban thành công" : "Đã vô hiệu hóa phòng ban thành công");
            } else {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Không thể cập nhật trạng thái phòng ban");
            }

        } catch (NumberFormatException e) {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "ID không hợp lệ");
        } catch (Exception e) {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Đã xảy ra lỗi: " + e.getMessage());
            e.printStackTrace();
        }

        response.getWriter().write(gson.toJson(jsonResponse));
    }

    /**
     * Get employees by department (AJAX)
     */
    private void getEmployeesByDepartment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Set response type to JSON
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        JsonObject jsonResponse = new JsonObject();
        Gson gson = new Gson();

        try {
            // 1. Get department ID
            String idStr = request.getParameter("id");
            if (idStr == null || idStr.trim().isEmpty()) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "ID không hợp lệ");
                response.getWriter().write(gson.toJson(jsonResponse));
                return;
            }

            int departmentId = Integer.parseInt(idStr);

            // 2. Get employees list
            List<Map<String, Object>> employees = departmentDAO.getEmployeesByDepartmentId(departmentId);

            jsonResponse.addProperty("success", true);
            jsonResponse.add("employees", gson.toJsonTree(employees));

        } catch (NumberFormatException e) {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "ID không hợp lệ");
        } catch (Exception e) {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Đã xảy ra lỗi: " + e.getMessage());
            e.printStackTrace();
        }

        response.getWriter().write(gson.toJson(jsonResponse));
    }

    /**
     * Get available managers (AJAX)
     */
    private void getAvailableManagers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Set response type to JSON
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        JsonObject jsonResponse = new JsonObject();
        Gson gson = new Gson();

        try {
            int departmentId = getIntParameter(request, "departmentId", 0);

            List<Map<String, Object>> managers = departmentDAO.getAvailableManagers(departmentId);

            jsonResponse.addProperty("success", true);
            jsonResponse.add("managers", gson.toJsonTree(managers));

        } catch (Exception e) {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Đã xảy ra lỗi: " + e.getMessage());
            e.printStackTrace();
        }

        response.getWriter().write(gson.toJson(jsonResponse));
    }

    /**
     * Assign manager to department
     */
    private void assignManager(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user");

        try {
            int departmentId = getIntParameter(request, "departmentId", 0);
            int managerId = getIntParameter(request, "managerId", 0);

            if (departmentId == 0 || managerId == 0) {
                response.sendRedirect(request.getContextPath() + "/department/list?error=invalid_data");
                return;
            }

            boolean success = departmentDAO.assignManager(departmentId, managerId, user.getId());

            if (success) {
                response.sendRedirect(request.getContextPath() + "/department/list?message=assign_success");
            } else {
                response.sendRedirect(request.getContextPath() + "/department/list?error=assign_failed");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/department/list?error=system_error");
        }
    }

    // ===================== HELPER METHODS =====================
    /**
     * Get integer parameter with default value
     */
    private int getIntParameter(HttpServletRequest request, String paramName, int defaultValue) {
        String paramStr = request.getParameter(paramName);
        if (paramStr != null && !paramStr.trim().isEmpty()) {
            try {
                return Integer.parseInt(paramStr);
            } catch (NumberFormatException e) {
                return defaultValue;
            }
        }
        return defaultValue;
    }

    /**
     * Get string parameter, return null if empty
     */
    private String getStringParameter(HttpServletRequest request, String paramName) {
        String param = request.getParameter(paramName);
        if (param != null) {
            param = param.trim();
            if (param.isEmpty()) {
                return null;
            }
        }
        return param;
    }

    /**
     * Calculate pagination display range
     */
    private void calculatePaginationDisplay(HttpServletRequest request, int currentPage, int totalPages) {
        int startPage = Math.max(1, currentPage - 2);
        int endPage = Math.min(totalPages, startPage + 4);

        // Adjust start page if we don't have enough pages at the end
        if (endPage - startPage < 4 && totalPages > 5) {
            startPage = Math.max(1, endPage - 4);
        }

        request.setAttribute("startPage", startPage);
        request.setAttribute("endPage", endPage);
    }

    /**
     * Validate status parameter
     */
    private boolean isValidStatus(String status) {
        return "0".equals(status) || "1".equals(status);
    }
}
