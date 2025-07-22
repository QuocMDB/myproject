package controller;

import java.io.IOException;
import java.util.List;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import dao.CategoryProductDAO;
import model.CategoryProduct;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import java.util.ArrayList;

@WebServlet(name = "CategoryController", urlPatterns = {"/category/*"})
public class CategoryProductController extends HttpServlet {

    private CategoryProductDAO categoryDAO;

    // Constants for sorting
    private static final String DEFAULT_SORT_FIELD = "id";
    private static final String DEFAULT_SORT_DIR = "asc";
    private static final String SORT_ASC = "asc";
    private static final String SORT_DESC = "desc";
    private static final String[] ALLOWED_SORT_FIELDS = {"id", "name", "parent_name", "active_flag", "create_date", "update_date"};

    // Constants for pagination
    private static final int DEFAULT_PAGE_SIZE = 10;

    // Initialize DAO when servlet is created
    @Override
    public void init() {
        categoryDAO = new CategoryProductDAO();
    }

    // Handle GET requests (display pages)
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Set UTF-8 encoding for Vietnamese display
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        // Get path to determine what user wants to do
        String pathInfo = request.getPathInfo();

        // Check path and call corresponding method
        if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("/list")) {
            showCategoryListWithFilters(request, response);
        } else if (pathInfo.equals("/create")) {
            showCreateForm(request, response);
        } else if (pathInfo.equals("/edit")) {
            showEditForm(request, response);
        } else if (pathInfo.equals("/delete")) {
            deleteCategory(request, response);
        } else if (pathInfo.equals("/toggle-status")) {
            toggleCategoryStatus(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    // Handle POST requests (process forms)
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Set UTF-8 encoding
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String pathInfo = request.getPathInfo();

        if (pathInfo != null && pathInfo.equals("/create")) {
            createCategory(request, response);
        } else if (pathInfo != null && pathInfo.equals("/edit")) {
            updateCategory(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/category/list");
        }
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

        // Lấy tất cả danh mục đang hoạt động
        List<CategoryProduct> allCategories = categoryDAO.getAllCategoriesForDropdown();

        // Lọc danh mục: 
        // - Giữ lại TẤT CẢ danh mục gốc (parentId = null)
        // - Chỉ giữ lại danh mục con nếu nó KHÔNG có con
        List<CategoryProduct> availableParents = new ArrayList<>();
        for (CategoryProduct cat : allCategories) {
            if (cat.getParentId() == null) {
                // Luôn giữ lại danh mục gốc
                availableParents.add(cat);
            } else if (!categoryDAO.hasChildCategories(cat.getId())) {
                // Chỉ giữ lại danh mục con nếu nó không có con
                availableParents.add(cat);
            }
        }

        request.setAttribute("allCategories", availableParents);

        request.getRequestDispatcher("/category_product/create.jsp").forward(request, response);
    }

    // Handle category creation
    private void createCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Get data from form
        String name = request.getParameter("name");
        String parentIdStr = request.getParameter("parentId");
        String activeFlagStr = request.getParameter("activeFlag");

        // 2. Check that name is not empty
        if (name == null || name.trim().isEmpty()) {
            request.setAttribute("error", "Tên danh mục không được để trống");
            showCreateForm(request, response);
            return;
        }

        name = name.trim();

        // 3. Check if name already exists
        if (categoryDAO.isCategoryNameExists(name)) {
            request.setAttribute("error", "Tên danh mục đã tồn tại");
            showCreateForm(request, response);
            return;
        }

        // 4. Create CategoryProduct object
        CategoryProduct category = new CategoryProduct();
        category.setName(name);

        // 5. Handle parent ID
        if (parentIdStr != null && !parentIdStr.trim().isEmpty()) {
            if (parentIdStr.equals("-1") || parentIdStr.equals("0")) {
                // -1 hoặc 0 nghĩa là danh mục gốc
                category.setParentId(null);
            } else {
                try {
                    int parentId = Integer.parseInt(parentIdStr);
                    // Check if parent is active
                    CategoryProduct parent = categoryDAO.getCategoryById(parentId);
                    if (parent != null && !parent.isActiveFlag() && "1".equals(activeFlagStr)) {
                        request.setAttribute("error", "Không thể tạo danh mục hoạt động với danh mục cha đang bị vô hiệu hóa");
                        showCreateForm(request, response);
                        return;
                    }
                    category.setParentId(parentId);
                } catch (NumberFormatException e) {
                    category.setParentId(null);
                }
            }
        } else {
            category.setParentId(null);
        }

        // 6. Handle active status
        category.setActiveFlag("1".equals(activeFlagStr));

        // 7. Save to database
        boolean success = categoryDAO.addCategory(category);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/category/list?message=create_success");
        } else {
            request.setAttribute("error", "Không thể thêm danh mục");
            showCreateForm(request, response);
        }
    }

// Display edit form
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Get ID from parameter
        String idStr = request.getParameter("id");
        if (idStr == null) {
            response.sendRedirect(request.getContextPath() + "/category/list?error=invalid_id");
            return;
        }

        try {
            int id = Integer.parseInt(idStr);

            // 2. Get category information
            CategoryProduct category = categoryDAO.getCategoryWithParentById(id);
            if (category == null) {
                response.sendRedirect(request.getContextPath() + "/category/list?error=not_found");
                return;
            }

            // 3. Kiểm tra xem danh mục này có con hay không
            boolean hasChildren = categoryDAO.hasChildCategories(id);

            // 4. Nếu có con rồi thì không cho phép chọn danh mục cha
            List<CategoryProduct> parentCategories = new ArrayList<>();
            boolean canSelectParent = !hasChildren;

            if (canSelectParent) {
                // Lấy tất cả danh mục để làm cha
                parentCategories = categoryDAO.getAllCategoriesForDropdown();

                // Loại bỏ chính nó
                parentCategories.removeIf(cat -> cat.getId() == id);

                // Loại bỏ các danh mục con của nó (tránh vòng lặp)
                List<Integer> childIds = categoryDAO.getAllChildCategoryIds(id);
                parentCategories.removeIf(cat -> childIds.contains(cat.getId()));
            }

            // 5. DateTimeFormatter
            DateTimeFormatter dateTimeFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss");

            // 6. Send data to JSP
            request.setAttribute("category", category);
            request.setAttribute("parentCategories", parentCategories);
            request.setAttribute("canSelectParent", canSelectParent);
            request.setAttribute("hasChildren", hasChildren);
            request.setAttribute("dateTimeFormatter", dateTimeFormatter);

            request.getRequestDispatcher("/category_product/edit.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/category/list?error=invalid_id");
        }
    }

    // Handle category update
    private void updateCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Get data from form
        String idStr = request.getParameter("id");
        String name = request.getParameter("name");
        String parentIdStr = request.getParameter("parentId");
        String activeFlagStr = request.getParameter("activeFlag");

        if (idStr == null || name == null || name.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/category/list?error=invalid_data");
            return;
        }

        try {
            int id = Integer.parseInt(idStr);
            name = name.trim();

            // 2. Check if name already exists (excluding current one)
            if (categoryDAO.isCategoryNameExists(name, id)) {
                request.setAttribute("error", "Tên danh mục đã tồn tại");
                request.setAttribute("id", idStr);
                showEditForm(request, response);
                return;
            }

            // 3. Get current category
            CategoryProduct currentCategory = categoryDAO.getCategoryById(id);
            if (currentCategory == null) {
                response.sendRedirect(request.getContextPath() + "/category/list?error=not_found");
                return;
            }

            // 4. Handle parent ID and validate
            Integer newParentId = null;
            if (parentIdStr != null && !parentIdStr.trim().isEmpty()) {
                if (parentIdStr.equals("-1") || parentIdStr.equals("0")) {
                    // -1 hoặc 0 nghĩa là danh mục gốc
                    newParentId = null;
                } else {
                    try {
                        newParentId = Integer.parseInt(parentIdStr);

                        // Prevent self-referencing
                        if (newParentId == id) {
                            request.setAttribute("error", "Danh mục không thể là cha của chính nó");
                            request.setAttribute("id", idStr);
                            showEditForm(request, response);
                            return;
                        }

                        // Prevent circular reference (category cannot be parent of its own parent)
                        List<Integer> childIds = categoryDAO.getAllChildCategoryIds(id);
                        if (childIds.contains(newParentId)) {
                            request.setAttribute("error", "Không thể chọn danh mục con làm danh mục cha");
                            request.setAttribute("id", idStr);
                            showEditForm(request, response);
                            return;
                        }

                        // Check if parent is active when trying to activate this category
                        if ("1".equals(activeFlagStr) && !currentCategory.isActiveFlag()) {
                            CategoryProduct parent = categoryDAO.getCategoryById(newParentId);
                            if (parent != null && !parent.isActiveFlag()) {
                                request.setAttribute("error", "Không thể kích hoạt danh mục khi danh mục cha đang bị vô hiệu hóa");
                                request.setAttribute("id", idStr);
                                showEditForm(request, response);
                                return;
                            }
                        }
                    } catch (NumberFormatException e) {
                        newParentId = null;
                    }
                }
            } else {
                newParentId = null;
            }

            // 5. Create CategoryProduct object
            CategoryProduct category = new CategoryProduct();
            category.setId(id);
            category.setName(name);
            category.setParentId(newParentId);

            // 6. Handle active status change
            boolean newActiveStatus = "1".equals(activeFlagStr);
            boolean oldActiveStatus = currentCategory.isActiveFlag();
            category.setActiveFlag(newActiveStatus);

            // 7. If deactivating and has children, warn user (but still allow in backend)
            if (oldActiveStatus && !newActiveStatus && categoryDAO.hasChildCategories(id)) {
                // This will be handled by the DAO's toggleCategoryStatus method
            }

            // 8. Update database
            boolean success = categoryDAO.updateCategory(category);

            if (success) {
                // If status changed from active to inactive, deactivate children
                if (oldActiveStatus && !newActiveStatus) {
                    categoryDAO.deactivateChildCategories(id);
                }
                response.sendRedirect(request.getContextPath() + "/category/list?message=update_success");
            } else {
                request.setAttribute("error", "Không thể cập nhật danh mục");
                request.setAttribute("id", idStr);
                showEditForm(request, response);
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/category/list?error=invalid_id");
        }
    }

    // Handle category deletion
    private void deleteCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Get ID from parameter
        String idStr = request.getParameter("id");
        if (idStr == null) {
            response.sendRedirect(request.getContextPath() + "/category/list?error=invalid_id");
            return;
        }

        try {
            int id = Integer.parseInt(idStr);

            // 2. Check if category exists
            CategoryProduct category = categoryDAO.getCategoryById(id);
            if (category == null) {
                response.sendRedirect(request.getContextPath() + "/category/list?error=not_found");
                return;
            }

            // 3. Check if category has child categories
            if (categoryDAO.hasChildCategories(id)) {
                response.sendRedirect(request.getContextPath() + "/category/list?error=has_children");
                return;
            }

            // 4. Check if category has products
            if (categoryDAO.hasCategoryProducts(id)) {
                response.sendRedirect(request.getContextPath() + "/category/list?error=has_products");
                return;
            }

            // 5. Delete category
            boolean success = categoryDAO.deleteCategory(id);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/category/list?message=delete_success");
            } else {
                response.sendRedirect(request.getContextPath() + "/category/list?error=delete_failed");
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/category/list?error=invalid_id");
        }
    }

    // Method to display messages
    private void showMessage(HttpServletRequest request) {
        String message = request.getParameter("message");
        String error = request.getParameter("error");

        if (message != null) {
            switch (message) {
                case "create_success":
                    request.setAttribute("successMessage", "Thêm danh mục thành công!");
                    break;
                case "update_success":
                    request.setAttribute("successMessage", "Cập nhật danh mục thành công!");
                    break;
                case "delete_success":
                    request.setAttribute("successMessage", "Xóa danh mục thành công!");
                    break;
            }
        }

        if (error != null) {
            switch (error) {
                case "invalid_id":
                    request.setAttribute("errorMessage", "ID không hợp lệ");
                    break;
                case "not_found":
                    request.setAttribute("errorMessage", "Không tìm thấy danh mục");
                    break;
                case "delete_failed":
                    request.setAttribute("errorMessage", "Không thể xóa danh mục");
                    break;
                case "invalid_data":
                    request.setAttribute("errorMessage", "Dữ liệu không hợp lệ");
                    break;
                case "has_children":
                    request.setAttribute("errorMessage", "Không thể xóa danh mục có danh mục con");
                    break;
                case "has_products":
                    request.setAttribute("errorMessage", "Không thể xóa danh mục có sản phẩm");
                    break;
                default:
                    request.setAttribute("errorMessage", "Đã xảy ra lỗi");
            }
        }
    }

    /**
     * Hiển thị danh sách danh mục với bộ lọc nâng cao
     */
    private void showCategoryListWithFilters(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Get pagination parameters
        int page = getIntParameter(request, "page", 1);
        if (page < 1) {
            page = 1;
        }

        // 2. Get filter parameters
        String searchKeyword = getStringParameter(request, "search");
        String statusStr = getStringParameter(request, "status");
        String parentIdStr = getStringParameter(request, "parentId");
        String sortField = getStringParameter(request, "sortField");
        String sortDir = getStringParameter(request, "sortDir");

        // 3. Validate and set defaults
        if (!isValidSortField(sortField)) {
            sortField = DEFAULT_SORT_FIELD;
        }
        if (!SORT_ASC.equalsIgnoreCase(sortDir) && !SORT_DESC.equalsIgnoreCase(sortDir)) {
            sortDir = DEFAULT_SORT_DIR;
        }

        // 4. Parse filter values
        Integer status = null;
        if (statusStr != null && !statusStr.isEmpty()) {
            try {
                status = Integer.parseInt(statusStr);
            } catch (NumberFormatException e) {
                status = null;
            }
        }

        Integer parentId = null;
        if (parentIdStr != null && !parentIdStr.isEmpty()) {
            try {
                parentId = Integer.parseInt(parentIdStr);
            } catch (NumberFormatException e) {
                parentId = null;
            }
        }

        // 5. Calculate offset for pagination
        int offset = (page - 1) * DEFAULT_PAGE_SIZE;

        // 6. Get filtered data
        List<CategoryProduct> categories = categoryDAO.searchCategoriesWithFilters(
                searchKeyword, status, parentId, sortField, sortDir, offset, DEFAULT_PAGE_SIZE);

        // 7. Get total count for pagination
        int totalCategories = categoryDAO.countCategoriesWithFilters(searchKeyword, status, parentId);
        int totalPages = (int) Math.ceil((double) totalCategories / DEFAULT_PAGE_SIZE);

        // 8. Get root categories for dropdown filter
        List<CategoryProduct> rootCategories = categoryDAO.getRootCategories();
        request.setAttribute("rootCategories", rootCategories);

        // 9. Calculate pagination display
        calculatePaginationDisplay(request, page, totalPages);

        // 10. Set attributes for JSP
        request.setAttribute("categories", categories);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalCategories", totalCategories);
        request.setAttribute("searchKeyword", searchKeyword);
        request.setAttribute("status", statusStr);
        request.setAttribute("parentId", parentId);
        request.setAttribute("sortField", sortField);
        request.setAttribute("sortDir", sortDir);
        request.setAttribute("rootCategories", rootCategories);

        // 11. Set reverse sort direction for table headers
        String reverseSortDir = SORT_ASC.equalsIgnoreCase(sortDir) ? SORT_DESC : SORT_ASC;
        request.setAttribute("reverseSortDir", reverseSortDir);

        // 12. Add DateTimeFormatter
        DateTimeFormatter dateTimeFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
        request.setAttribute("dateTimeFormatter", dateTimeFormatter);

        // 13. Add parent name if filtering by parent
        if (parentId != null && parentId != -1) {
            CategoryProduct parentCategory = categoryDAO.getCategoryById(parentId);
            if (parentCategory != null) {
                request.setAttribute("parentName", parentCategory.getName());
            }
        }

        // 14. Add statistics
        getCategoryStatistics(request);

        // 15. Show messages
        showMessage(request);

        // 16. Forward to JSP
        request.getRequestDispatcher("/category_product/list.jsp").forward(request, response);
    }

    /**
     * Toggle trạng thái active/inactive của danh mục Khi vô hiệu hóa danh mục
     * cha, tất cả danh mục con cũng bị vô hiệu hóa
     */
    private void toggleCategoryStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Set response type to JSON
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        JsonObject jsonResponse = new JsonObject();
        Gson gson = new Gson();

        try {
            // 1. Get category ID
            String idStr = request.getParameter("id");
            if (idStr == null || idStr.trim().isEmpty()) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "ID không hợp lệ");
                response.getWriter().write(gson.toJson(jsonResponse));
                return;
            }

            int categoryId = Integer.parseInt(idStr);

            // 2. Get current category to check current status
            CategoryProduct category = categoryDAO.getCategoryById(categoryId);
            if (category == null) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Không tìm thấy danh mục");
                response.getWriter().write(gson.toJson(jsonResponse));
                return;
            }

            // 3. Check if can activate (parent must be active)
            if (!category.isActiveFlag() && !categoryDAO.canActivateCategory(categoryId)) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Không thể kích hoạt danh mục này vì danh mục cha đang bị vô hiệu hóa");
                response.getWriter().write(gson.toJson(jsonResponse));
                return;
            }

            // 4. Toggle status (will automatically deactivate children if deactivating)
            boolean success = categoryDAO.toggleCategoryStatus(categoryId);

            if (success) {
                // 5. Get updated category to return new status
                CategoryProduct updatedCategory = categoryDAO.getCategoryById(categoryId);
                boolean newStatus = updatedCategory.isActiveFlag();

                jsonResponse.addProperty("success", true);
                jsonResponse.addProperty("newStatus", newStatus ? "Hoạt động" : "Không hoạt động");
                jsonResponse.addProperty("statusClass", newStatus ? "badge-success" : "badge-secondary");
                jsonResponse.addProperty("buttonText", newStatus ? "vô hiệu hóa" : "kích hoạt");
                jsonResponse.addProperty("buttonClass", newStatus ? "btn-danger" : "btn-success");

                // Add message about children being deactivated
                if (!newStatus && categoryDAO.hasChildCategories(categoryId)) {
                    jsonResponse.addProperty("message", "Đã vô hiệu hóa danh mục và tất cả danh mục con");
                    jsonResponse.addProperty("childrenDeactivated", true);
                } else {
                    jsonResponse.addProperty("message", newStatus
                            ? "Đã kích hoạt danh mục thành công" : "Đã vô hiệu hóa danh mục thành công");
                    jsonResponse.addProperty("childrenDeactivated", false);
                }
            } else {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Không thể cập nhật trạng thái danh mục");
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

    /**
     * Get category statistics
     */
    private void getCategoryStatistics(HttpServletRequest request) {
        int totalCategories = categoryDAO.getTotalCategoriesCount();
        int activeCategories = categoryDAO.getCategoriesCountByStatus(true);
        int inactiveCategories = categoryDAO.getCategoriesCountByStatus(false);

        request.setAttribute("totalCategoriesCount", totalCategories);
        request.setAttribute("activeCategoriesCount", activeCategories);
        request.setAttribute("inactiveCategoriesCount", inactiveCategories);
    }
}
