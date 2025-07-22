package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import DBContext.Context;

public class DepartmentStatisticDAO {

    /**
     * Get overview statistics of all departments
     */
    public Map<String, Object> getOverviewStatistics() {
        Map<String, Object> stats = new HashMap<>();
        
        String sql = """
            SELECT 
                COUNT(DISTINCT d.id) as total_departments,
                COUNT(DISTINCT CASE WHEN d.active_flag = 1 THEN d.id END) as active_departments,
                COUNT(DISTINCT CASE WHEN d.active_flag = 0 THEN d.id END) as inactive_departments,
                COUNT(DISTINCT CASE WHEN d.manager_id IS NOT NULL THEN d.id END) as departments_with_manager,
                COUNT(DISTINCT CASE WHEN d.manager_id IS NULL THEN d.id END) as departments_without_manager,
                COUNT(DISTINCT u.id) as total_employees,
                COUNT(DISTINCT CASE WHEN u.active_flag = 1 THEN u.id END) as active_employees
            FROM department d
            LEFT JOIN users u ON d.id = u.department_id
            """;
        
        try (Connection conn = new Context().getJDBCConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                stats.put("totalDepartments", rs.getInt("total_departments"));
                stats.put("activeDepartments", rs.getInt("active_departments"));
                stats.put("inactiveDepartments", rs.getInt("inactive_departments"));
                stats.put("departmentsWithManager", rs.getInt("departments_with_manager"));
                stats.put("departmentsWithoutManager", rs.getInt("departments_without_manager"));
                stats.put("totalEmployees", rs.getInt("total_employees"));
                stats.put("activeEmployees", rs.getInt("active_employees"));
                
                // Calculate percentages
                int total = rs.getInt("total_departments");
                if (total > 0) {
                    stats.put("activePercentage", (rs.getInt("active_departments") * 100.0) / total);
                    stats.put("managerCoveragePercentage", (rs.getInt("departments_with_manager") * 100.0) / total);
                } else {
                    stats.put("activePercentage", 0.0);
                    stats.put("managerCoveragePercentage", 0.0);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error in getOverviewStatistics: " + e.getMessage());
            e.printStackTrace();
        }
        
        return stats;
    }
    
    /**
     * Get employee distribution by department
     */
    public List<Map<String, Object>> getEmployeeDistribution() {
        List<Map<String, Object>> distribution = new ArrayList<>();
        
        String sql = """
            SELECT 
                d.id,
                d.dept_code,
                d.dept_name,
                d.active_flag,
                COUNT(u.id) as total_employees,
                COUNT(CASE WHEN u.active_flag = 1 THEN u.id END) as active_employees,
                COUNT(CASE WHEN u.active_flag = 0 THEN u.id END) as inactive_employees,
                manager.fullname as manager_name
            FROM department d
            LEFT JOIN users u ON d.id = u.department_id
            LEFT JOIN users manager ON d.manager_id = manager.id
            GROUP BY d.id, d.dept_code, d.dept_name, d.active_flag, manager.fullname
            ORDER BY total_employees DESC, d.dept_name ASC
            """;
        
        try (Connection conn = new Context().getJDBCConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Map<String, Object> dept = new HashMap<>();
                dept.put("id", rs.getInt("id"));
                dept.put("deptCode", rs.getString("dept_code"));
                dept.put("deptName", rs.getString("dept_name"));
                dept.put("activeFlag", rs.getBoolean("active_flag"));
                dept.put("totalEmployees", rs.getInt("total_employees"));
                dept.put("activeEmployees", rs.getInt("active_employees"));
                dept.put("inactiveEmployees", rs.getInt("inactive_employees"));
                dept.put("managerName", rs.getString("manager_name"));
                
                // Calculate employee utilization percentage
                int total = rs.getInt("total_employees");
                int active = rs.getInt("active_employees");
                if (total > 0) {
                    dept.put("utilizationPercentage", (active * 100.0) / total);
                } else {
                    dept.put("utilizationPercentage", 0.0);
                }
                
                distribution.add(dept);
            }
        } catch (SQLException e) {
            System.out.println("Error in getEmployeeDistribution: " + e.getMessage());
            e.printStackTrace();
        }
        
        return distribution;
    }
    
    /**
     * Get department creation trend by month
     */
    public List<Map<String, Object>> getDepartmentCreationTrend(int months) {
        List<Map<String, Object>> trend = new ArrayList<>();
        
        String sql = """
            SELECT 
                DATE_FORMAT(create_date, '%Y-%m') as month,
                COUNT(*) as departments_created
            FROM department
            WHERE create_date >= DATE_SUB(CURRENT_DATE, INTERVAL ? MONTH)
            GROUP BY DATE_FORMAT(create_date, '%Y-%m')
            ORDER BY month
            """;
        
        try (Connection conn = new Context().getJDBCConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, months);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> monthData = new HashMap<>();
                    monthData.put("month", rs.getString("month"));
                    monthData.put("departmentsCreated", rs.getInt("departments_created"));
                    trend.add(monthData);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error in getDepartmentCreationTrend: " + e.getMessage());
            e.printStackTrace();
        }
        
        return trend;
    }
    
    /**
     * Get top departments by employee count (INCLUDING MANAGERS)
     */
    public List<Map<String, Object>> getTopDepartmentsByEmployeeCount(int limit) {
        List<Map<String, Object>> topDepartments = new ArrayList<>();
        
        String sql = """
            SELECT 
                d.id,
                d.dept_code,
                d.dept_name,
                COUNT(u.id) as employee_count,
                COUNT(CASE WHEN u.active_flag = 1 THEN u.id END) as active_employee_count,
                manager.fullname as manager_name,
                manager.email as manager_email
            FROM department d
            LEFT JOIN users u ON d.id = u.department_id
            LEFT JOIN users manager ON d.manager_id = manager.id
            WHERE d.active_flag = 1
            GROUP BY d.id, d.dept_code, d.dept_name, manager.fullname, manager.email
            ORDER BY employee_count DESC, d.dept_name ASC
            LIMIT ?
            """;
        
        try (Connection conn = new Context().getJDBCConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, limit);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> dept = new HashMap<>();
                    dept.put("id", rs.getInt("id"));
                    dept.put("deptCode", rs.getString("dept_code"));
                    dept.put("deptName", rs.getString("dept_name"));
                    dept.put("employeeCount", rs.getInt("employee_count"));
                    dept.put("activeEmployeeCount", rs.getInt("active_employee_count"));
                    dept.put("managerName", rs.getString("manager_name"));
                    dept.put("managerEmail", rs.getString("manager_email"));
                    topDepartments.add(dept);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error in getTopDepartmentsByEmployeeCount: " + e.getMessage());
            e.printStackTrace();
        }
        
        return topDepartments;
    }
    
    /**
     * Get departments without managers
     */
    public List<Map<String, Object>> getDepartmentsWithoutManagers() {
        List<Map<String, Object>> departments = new ArrayList<>();
        
        String sql = """
            SELECT 
                d.id,
                d.dept_code,
                d.dept_name,
                d.create_date,
                COUNT(u.id) as employee_count,
                creator.fullname as created_by_name
            FROM department d
            LEFT JOIN users u ON d.id = u.department_id
            LEFT JOIN users creator ON d.created_by = creator.id
            WHERE d.manager_id IS NULL AND d.active_flag = 1
            GROUP BY d.id, d.dept_code, d.dept_name, d.create_date, creator.fullname
            ORDER BY employee_count DESC, d.dept_name ASC
            """;
        
        try (Connection conn = new Context().getJDBCConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
            
            while (rs.next()) {
                Map<String, Object> dept = new HashMap<>();
                dept.put("id", rs.getInt("id"));
                dept.put("deptCode", rs.getString("dept_code"));
                dept.put("deptName", rs.getString("dept_name"));
                dept.put("employeeCount", rs.getInt("employee_count"));
                dept.put("createdBy", rs.getString("created_by_name"));
                
                Timestamp createDate = rs.getTimestamp("create_date");
                if (createDate != null) {
                    dept.put("createDate", createDate.toLocalDateTime().format(formatter));
                    
                    // Calculate days without manager
                    long daysWithoutManager = java.time.Duration.between(
                        createDate.toLocalDateTime(), 
                        LocalDateTime.now()
                    ).toDays();
                    dept.put("daysWithoutManager", daysWithoutManager);
                }
                
                departments.add(dept);
            }
        } catch (SQLException e) {
            System.out.println("Error in getDepartmentsWithoutManagers: " + e.getMessage());
            e.printStackTrace();
        }
        
        return departments;
    }
    
    /**
     * Get department activity statistics (recent updates)
     */
    public List<Map<String, Object>> getRecentDepartmentActivities(int days) {
        List<Map<String, Object>> activities = new ArrayList<>();
        
        String sql = """
            SELECT 
                d.id,
                d.dept_code,
                d.dept_name,
                d.update_date,
                updater.fullname as updated_by_name,
                'update' as activity_type
            FROM department d
            LEFT JOIN users updater ON d.updated_by = updater.id
            WHERE d.update_date >= DATE_SUB(CURRENT_DATE, INTERVAL ? DAY)
            
            UNION ALL
            
            SELECT 
                d.id,
                d.dept_code,
                d.dept_name,
                d.create_date as update_date,
                creator.fullname as updated_by_name,
                'create' as activity_type
            FROM department d
            LEFT JOIN users creator ON d.created_by = creator.id
            WHERE d.create_date >= DATE_SUB(CURRENT_DATE, INTERVAL ? DAY)
            
            ORDER BY update_date DESC
            LIMIT 20
            """;
        
        try (Connection conn = new Context().getJDBCConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, days);
            ps.setInt(2, days);
            
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> activity = new HashMap<>();
                    activity.put("id", rs.getInt("id"));
                    activity.put("deptCode", rs.getString("dept_code"));
                    activity.put("deptName", rs.getString("dept_name"));
                    activity.put("activityType", rs.getString("activity_type"));
                    activity.put("updatedBy", rs.getString("updated_by_name"));
                    
                    Timestamp updateDate = rs.getTimestamp("update_date");
                    if (updateDate != null) {
                        activity.put("updateDate", updateDate.toLocalDateTime().format(formatter));
                    }
                    
                    activities.add(activity);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error in getRecentDepartmentActivities: " + e.getMessage());
            e.printStackTrace();
        }
        
        return activities;
    }
    
    /**
     * Get department employee growth rate
     */
    public Map<String, Object> getDepartmentGrowthStatistics(int departmentId, int months) {
        Map<String, Object> growth = new HashMap<>();
        
        String sql = """
            SELECT 
                d.dept_name,
                d.dept_code,
                (SELECT COUNT(*) FROM users WHERE department_id = ? AND active_flag = 1) as current_employees,
                (SELECT COUNT(*) FROM users WHERE department_id = ? 
                 AND create_date >= DATE_SUB(CURRENT_DATE, INTERVAL ? MONTH)) as new_employees,
                (SELECT COUNT(*) FROM users WHERE department_id = ? 
                 AND active_flag = 0 
                 AND update_date >= DATE_SUB(CURRENT_DATE, INTERVAL ? MONTH)) as left_employees
            FROM department d
            WHERE d.id = ?
            """;
        
        try (Connection conn = new Context().getJDBCConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, departmentId);
            ps.setInt(2, departmentId);
            ps.setInt(3, months);
            ps.setInt(4, departmentId);
            ps.setInt(5, months);
            ps.setInt(6, departmentId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    growth.put("deptName", rs.getString("dept_name"));
                    growth.put("deptCode", rs.getString("dept_code"));
                    growth.put("currentEmployees", rs.getInt("current_employees"));
                    growth.put("newEmployees", rs.getInt("new_employees"));
                    growth.put("leftEmployees", rs.getInt("left_employees"));
                    
                    // Calculate growth rate
                    int netGrowth = rs.getInt("new_employees") - rs.getInt("left_employees");
                    growth.put("netGrowth", netGrowth);
                    
                    int current = rs.getInt("current_employees");
                    if (current > 0) {
                        double growthRate = (netGrowth * 100.0) / current;
                        growth.put("growthRate", growthRate);
                    } else {
                        growth.put("growthRate", 0.0);
                    }
                }
            }
        } catch (SQLException e) {
            System.out.println("Error in getDepartmentGrowthStatistics: " + e.getMessage());
            e.printStackTrace();
        }
        
        return growth;
    }
    
    /**
     * Get role distribution across departments
     */
    public List<Map<String, Object>> getRoleDistributionByDepartment() {
        List<Map<String, Object>> distribution = new ArrayList<>();
        
        String sql = """
            SELECT 
                d.dept_name,
                r.role_name,
                COUNT(DISTINCT u.id) as user_count
            FROM department d
            INNER JOIN users u ON d.id = u.department_id
            INNER JOIN user_role ur ON u.id = ur.user_id
            INNER JOIN role r ON ur.role_id = r.id
            WHERE d.active_flag = 1 AND u.active_flag = 1
            GROUP BY d.dept_name, r.role_name
            ORDER BY d.dept_name, user_count DESC
            """;
        
        try (Connection conn = new Context().getJDBCConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            String currentDept = "";
            Map<String, Object> deptData = null;
            List<Map<String, Object>> roles = null;
            
            while (rs.next()) {
                String deptName = rs.getString("dept_name");
                
                if (!deptName.equals(currentDept)) {
                    if (deptData != null) {
                        deptData.put("roles", roles);
                        distribution.add(deptData);
                    }
                    
                    currentDept = deptName;
                    deptData = new HashMap<>();
                    deptData.put("deptName", deptName);
                    roles = new ArrayList<>();
                }
                
                Map<String, Object> roleData = new HashMap<>();
                roleData.put("roleName", rs.getString("role_name"));
                roleData.put("userCount", rs.getInt("user_count"));
                roles.add(roleData);
            }
            
            // Add last department
            if (deptData != null) {
                deptData.put("roles", roles);
                distribution.add(deptData);
            }
            
        } catch (SQLException e) {
            System.out.println("Error in getRoleDistributionByDepartment: " + e.getMessage());
            e.printStackTrace();
        }
        
        return distribution;
    }
    
    /**
     * Get department comparison statistics
     */
    public List<Map<String, Object>> getDepartmentComparison() {
        List<Map<String, Object>> comparison = new ArrayList<>();
        
        String sql = """
            SELECT 
                d.id,
                d.dept_code,
                d.dept_name,
                d.active_flag,
                COUNT(u.id) as total_employees,
                COUNT(CASE WHEN u.active_flag = 1 THEN u.id END) as active_employees,
                COUNT(CASE WHEN ur.role_id = (SELECT id FROM role WHERE role_name = 'Admin') THEN u.id END) as admin_count,
                COUNT(CASE WHEN ur.role_id = (SELECT id FROM role WHERE role_name = 'Nhân viên kho') THEN u.id END) as warehouse_staff_count,
                CASE WHEN d.manager_id IS NOT NULL THEN 1 ELSE 0 END as has_manager,
                DATEDIFF(CURRENT_DATE, d.create_date) as days_since_creation
            FROM department d
            LEFT JOIN users u ON d.id = u.department_id
            LEFT JOIN user_role ur ON u.id = ur.user_id
            GROUP BY d.id, d.dept_code, d.dept_name, d.active_flag, d.manager_id, d.create_date
            ORDER BY total_employees DESC, d.dept_name ASC
            """;
        
        try (Connection conn = new Context().getJDBCConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Map<String, Object> dept = new HashMap<>();
                dept.put("id", rs.getInt("id"));
                dept.put("deptCode", rs.getString("dept_code"));
                dept.put("deptName", rs.getString("dept_name"));
                dept.put("activeFlag", rs.getBoolean("active_flag"));
                dept.put("totalEmployees", rs.getInt("total_employees"));
                dept.put("activeEmployees", rs.getInt("active_employees"));
                dept.put("adminCount", rs.getInt("admin_count"));
                dept.put("warehouseStaffCount", rs.getInt("warehouse_staff_count"));
                dept.put("hasManager", rs.getBoolean("has_manager"));
                dept.put("daysSinceCreation", rs.getInt("days_since_creation"));
                
                // Calculate efficiency score (example metric)
                int score = 0;
                if (rs.getBoolean("active_flag")) score += 20;
                if (rs.getBoolean("has_manager")) score += 20;
                if (rs.getInt("total_employees") > 0) {
                    double activeRatio = rs.getInt("active_employees") * 100.0 / rs.getInt("total_employees");
                    score += (int)(activeRatio * 0.6);
                }
                dept.put("efficiencyScore", score);
                
                comparison.add(dept);
            }
        } catch (SQLException e) {
            System.out.println("Error in getDepartmentComparison: " + e.getMessage());
            e.printStackTrace();
        }
        
        return comparison;
    }
}