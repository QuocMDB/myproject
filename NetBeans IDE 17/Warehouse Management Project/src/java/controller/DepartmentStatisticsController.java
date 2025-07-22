package controller;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import dao.DepartmentStatisticDAO;
import model.Users;
import com.google.gson.Gson;

@WebServlet(name = "DepartmentStatisticsController", urlPatterns = {"/department/statistics/*"})
public class DepartmentStatisticsController extends HttpServlet {

    private DepartmentStatisticDAO statisticDAO;
    private Gson gson;
    
    // Constants để dễ thay đổi
    private static final int RECENT_ACTIVITIES_DISPLAY_LIMIT = 5; // Chỉ cần sửa số này
    private static final int TOP_DEPARTMENTS_LIMIT = 10;
    private static final int ACTIVITIES_DAYS_RANGE = 7;
    
    @Override
    public void init() {
        statisticDAO = new DepartmentStatisticDAO();
        gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Set UTF-8 encoding
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        // Check authentication
        HttpSession session = request.getSession(false);
        Users user = (Users) session.getAttribute("user");
        if (user == null || (!"Admin".equals(user.getRoleName()) && !"Nhân viên kho".equals(user.getRoleName()))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        String pathInfo = request.getPathInfo();
        
        // Main statistics page
        if (pathInfo == null || pathInfo.equals("/")) {
            showStatisticsPage(request, response);
        } 
        // Export endpoint
        else if (pathInfo.equals("/export")) {
            exportStatistics(request, response);
        } 
        // AJAX endpoints for dynamic updates
        else if (pathInfo.equals("/overview")) {
            getOverviewData(request, response);
        } else if (pathInfo.equals("/top-departments")) {
            getTopDepartments(request, response);
        } else if (pathInfo.equals("/activities")) {
            getRecentActivities(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    /**
     * Show main statistics page
     */
    private void showStatisticsPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Get overview statistics
            Map<String, Object> overview = statisticDAO.getOverviewStatistics();
            request.setAttribute("overview", overview);
            
            // Get top departments by employee count
            List<Map<String, Object>> topDepartments = statisticDAO.getTopDepartmentsByEmployeeCount(TOP_DEPARTMENTS_LIMIT);
            request.setAttribute("topDepartments", topDepartments);
            
            // Get recent activities - CHỈ LẤY SỐ LƯỢNG GIỚI HẠN
            List<Map<String, Object>> allActivities = statisticDAO.getRecentDepartmentActivities(ACTIVITIES_DAYS_RANGE);
            List<Map<String, Object>> recentActivities = allActivities.size() > RECENT_ACTIVITIES_DISPLAY_LIMIT ? 
                allActivities.subList(0, RECENT_ACTIVITIES_DISPLAY_LIMIT) : allActivities;
            request.setAttribute("recentActivities", recentActivities);
            
            // Forward to JSP
            request.getRequestDispatcher("/Department_statistics.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/department/list?error=statistics_error");
        }
    }

    /**
     * Get overview data (AJAX) - for auto refresh
     */
    private void getOverviewData(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try {
            Map<String, Object> overview = statisticDAO.getOverviewStatistics();
            response.getWriter().write(gson.toJson(overview));
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"Unable to fetch overview data\"}");
        }
    }

    /**
     * Get top departments (AJAX)
     */
    private void getTopDepartments(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try {
            List<Map<String, Object>> topDepts = statisticDAO.getTopDepartmentsByEmployeeCount(TOP_DEPARTMENTS_LIMIT);
            response.getWriter().write(gson.toJson(topDepts));
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"Unable to fetch top departments\"}");
        }
    }

    /**
     * Get recent activities (AJAX) - CHỈ 5 DÒNG GẦN NHẤT
     */
    private void getRecentActivities(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try {
            // Get all activities then limit display
            List<Map<String, Object>> allActivities = statisticDAO.getRecentDepartmentActivities(ACTIVITIES_DAYS_RANGE);
            List<Map<String, Object>> activities = allActivities.size() > RECENT_ACTIVITIES_DISPLAY_LIMIT ? 
                allActivities.subList(0, RECENT_ACTIVITIES_DISPLAY_LIMIT) : allActivities;
            response.getWriter().write(gson.toJson(activities));
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"Unable to fetch activities\"}");
        }
    }

    /**
     * Export statistics to CSV
     */
    private void exportStatistics(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        
        response.setContentType("text/csv; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setHeader("Content-Disposition", "attachment; filename=\"thong_ke_phong_ban_" + 
            java.time.LocalDate.now().format(java.time.format.DateTimeFormatter.ofPattern("yyyyMMdd")) + ".csv\"");
        
        try {
            StringBuilder csv = new StringBuilder();
            
            // Add BOM for Excel to recognize UTF-8
            csv.append('\ufeff');
            
            // Header
            csv.append("THỐNG KÊ PHÒNG BAN\n");
            csv.append("Ngày xuất: ").append(java.time.LocalDateTime.now().format(
                java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss"))).append("\n");
            csv.append("Người xuất: ").append(((Users)request.getSession().getAttribute("user")).getFullname()).append("\n\n");
            
            // Overview statistics
            Map<String, Object> overview = statisticDAO.getOverviewStatistics();
            csv.append("TỔNG QUAN\n");
            csv.append("Tổng số phòng ban,").append(overview.get("totalDepartments")).append("\n");
            csv.append("Phòng ban hoạt động,").append(overview.get("activeDepartments")).append("\n");
            csv.append("Phòng ban không hoạt động,").append(overview.get("inactiveDepartments")).append("\n");
            csv.append("Phòng ban có trưởng phòng,").append(overview.get("departmentsWithManager")).append("\n");
            csv.append("Phòng ban chưa có trưởng phòng,").append(overview.get("departmentsWithoutManager")).append("\n");
            csv.append("Tổng số nhân viên (bao gồm trưởng phòng),").append(overview.get("totalEmployees")).append("\n");
            csv.append("Nhân viên đang hoạt động,").append(overview.get("activeEmployees")).append("\n\n");
            
            // Top departments
            csv.append("TOP PHÒNG BAN CÓ NHIỀU NHÂN VIÊN NHẤT (bao gồm trưởng phòng)\n");
            csv.append("STT,Mã phòng ban,Tên phòng ban,Trưởng phòng,Số nhân viên,Nhân viên hoạt động\n");
            
            List<Map<String, Object>> topDepartments = statisticDAO.getTopDepartmentsByEmployeeCount(20);
            int index = 1;
            for (Map<String, Object> dept : topDepartments) {
                csv.append(index++).append(",");
                csv.append("\"").append(dept.get("deptCode")).append("\",");
                csv.append("\"").append(dept.get("deptName")).append("\",");
                csv.append("\"").append(dept.get("managerName") != null ? dept.get("managerName") : "Chưa có").append("\",");
                csv.append(dept.get("employeeCount")).append(",");
                csv.append(dept.get("activeEmployeeCount")).append("\n");
            }
            
            csv.append("\n");
            
            // Departments without manager
            csv.append("PHÒNG BAN CHƯA CÓ TRƯỞNG PHÒNG\n");
            csv.append("STT,Mã phòng ban,Tên phòng ban,Số nhân viên,Ngày tạo\n");
            
            List<Map<String, Object>> noManagerDepts = statisticDAO.getDepartmentsWithoutManagers();
            index = 1;
            for (Map<String, Object> dept : noManagerDepts) {
                csv.append(index++).append(",");
                csv.append("\"").append(dept.get("deptCode")).append("\",");
                csv.append("\"").append(dept.get("deptName")).append("\",");
                csv.append(dept.get("employeeCount")).append(",");
                csv.append("\"").append(dept.get("createDate") != null ? dept.get("createDate") : "N/A").append("\"\n");
            }
            
            csv.append("\n");
            
            // Recent activities - TẤT CẢ CHO EXPORT
            csv.append("HOẠT ĐỘNG GẦN ĐÂY (").append(ACTIVITIES_DAYS_RANGE).append(" NGÀY QUA)\n");
            csv.append("Thời gian,Phòng ban,Mã phòng ban,Loại hoạt động,Người thực hiện\n");
            
            List<Map<String, Object>> activities = statisticDAO.getRecentDepartmentActivities(ACTIVITIES_DAYS_RANGE);
            for (Map<String, Object> activity : activities) {
                csv.append("\"").append(activity.get("updateDate")).append("\",");
                csv.append("\"").append(activity.get("deptName")).append("\",");
                csv.append("\"").append(activity.get("deptCode")).append("\",");
                csv.append("\"").append(activity.get("activityType").equals("create") ? "Tạo mới" : "Cập nhật").append("\",");
                csv.append("\"").append(activity.get("updatedBy") != null ? activity.get("updatedBy") : "N/A").append("\"\n");
            }
            
            response.getWriter().write(csv.toString());
            
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("Lỗi khi xuất dữ liệu");
        }
    }
}