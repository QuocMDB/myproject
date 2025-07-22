package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import DBContext.Context;
import model.Department;

public class DepartmentDAO {

    /**
     * Get all departments with full information
     */
    public List<Department> getAllDepartments() {
        List<Department> departments = new ArrayList<>();
        String sql = """
            SELECT d.id, d.dept_code, d.dept_name, d.description, d.manager_id, 
                   d.phone, d.email, d.active_flag, d.created_by, d.create_date, 
                   d.updated_by, d.update_date,
                   manager.fullname as manager_name,
                   manager.email as manager_email,
                   manager.phone as manager_phone,
                   creator.fullname as created_by_name,
                   updater.fullname as updated_by_name,
                   COUNT(DISTINCT CASE WHEN u.active_flag = 1 THEN u.id END) as employee_count
            FROM department d
            LEFT JOIN users manager ON d.manager_id = manager.id
            LEFT JOIN users creator ON d.created_by = creator.id
            LEFT JOIN users updater ON d.updated_by = updater.id
            LEFT JOIN users u ON d.id = u.department_id
            GROUP BY d.id, d.dept_code, d.dept_name, d.description, d.manager_id, 
                     d.phone, d.email, d.active_flag, d.created_by, d.create_date, 
                     d.updated_by, d.update_date, manager.fullname, manager.email, 
                     manager.phone, creator.fullname, updater.fullname
            ORDER BY d.dept_name
            """;
        
        try (Connection conn = new Context().getJDBCConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                departments.add(mapResultSetToDepartment(rs));
            }
        } catch (SQLException e) {
            System.out.println("Error in getAllDepartments: " + e.getMessage());
            e.printStackTrace();
        }
        
        return departments;
    }
    
    /**
     * Get departments with pagination and filtering
     */
    public List<Department> getDepartments(String searchKeyword, String status, 
                                         String hasManager, String sortField, 
                                         String sortDir, int page, int pageSize) {
        List<Department> departments = new ArrayList<>();
        StringBuilder sql = new StringBuilder("""
            SELECT d.id, d.dept_code, d.dept_name, d.description, d.manager_id, 
                   d.phone, d.email, d.active_flag, d.created_by, d.create_date, 
                   d.updated_by, d.update_date,
                   manager.fullname as manager_name,
                   manager.email as manager_email,
                   manager.phone as manager_phone,
                   creator.fullname as created_by_name,
                   updater.fullname as updated_by_name,
                   COUNT(DISTINCT CASE WHEN u.active_flag = 1 THEN u.id END) as employee_count
            FROM department d
            LEFT JOIN users manager ON d.manager_id = manager.id
            LEFT JOIN users creator ON d.created_by = creator.id
            LEFT JOIN users updater ON d.updated_by = updater.id
            LEFT JOIN users u ON d.id = u.department_id
            WHERE 1=1
            """);
        
        List<Object> params = new ArrayList<>();
        
        // Add search condition
        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            sql.append(" AND (d.dept_name LIKE ? OR d.dept_code LIKE ?)");
            String searchPattern = "%" + searchKeyword.trim() + "%";
            params.add(searchPattern);
            params.add(searchPattern);
        }
        
        // Add status condition
        if (status != null && !status.isEmpty()) {
            sql.append(" AND d.active_flag = ?");
            params.add("1".equals(status));
        }
        
        // Add manager condition
        if (hasManager != null && !hasManager.isEmpty()) {
            if ("1".equals(hasManager)) {
                sql.append(" AND d.manager_id IS NOT NULL");
            } else {
                sql.append(" AND d.manager_id IS NULL");
            }
        }
        
        sql.append("""
            GROUP BY d.id, d.dept_code, d.dept_name, d.description, d.manager_id, 
                     d.phone, d.email, d.active_flag, d.created_by, d.create_date, 
                     d.updated_by, d.update_date, manager.fullname, manager.email, 
                     manager.phone, creator.fullname, updater.fullname
            """);
        
        // Add sorting
        if (sortField != null && !sortField.isEmpty()) {
            String direction = "desc".equalsIgnoreCase(sortDir) ? "DESC" : "ASC";
            switch (sortField.toLowerCase()) {
                case "id":
                    sql.append(" ORDER BY d.id ").append(direction);
                    break;
                case "dept_code":
                    sql.append(" ORDER BY d.dept_code ").append(direction);
                    break;
                case "dept_name":
                    sql.append(" ORDER BY d.dept_name ").append(direction);
                    break;
                case "active_flag":
                    sql.append(" ORDER BY d.active_flag ").append(direction);
                    break;
                case "create_date":
                    sql.append(" ORDER BY d.create_date ").append(direction);
                    break;
                default:
                    sql.append(" ORDER BY d.dept_name ASC");
            }
        } else {
            sql.append(" ORDER BY d.dept_name ASC");
        }
        
        // Add pagination
        sql.append(" LIMIT ? OFFSET ?");
        params.add(pageSize);
        params.add((page - 1) * pageSize);
        
        try (Connection conn = new Context().getJDBCConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            // Set parameters
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    departments.add(mapResultSetToDepartment(rs));
                }
            }
        } catch (SQLException e) {
            System.out.println("Error in getDepartments: " + e.getMessage());
            e.printStackTrace();
        }
        
        return departments;
    }
    
    /**
     * Count departments with filter conditions
     */
    public int countDepartments(String searchKeyword, String status, String hasManager) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(DISTINCT d.id) FROM department d WHERE 1=1");
        List<Object> params = new ArrayList<>();
        
        // Add search condition
        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            sql.append(" AND (d.dept_name LIKE ? OR d.dept_code LIKE ?)");
            String searchPattern = "%" + searchKeyword.trim() + "%";
            params.add(searchPattern);
            params.add(searchPattern);
        }
        
        // Add status condition
        if (status != null && !status.isEmpty()) {
            sql.append(" AND d.active_flag = ?");
            params.add("1".equals(status));
        }
        
        // Add manager condition
        if (hasManager != null && !hasManager.isEmpty()) {
            if ("1".equals(hasManager)) {
                sql.append(" AND d.manager_id IS NOT NULL");
            } else {
                sql.append(" AND d.manager_id IS NULL");
            }
        }
        
        try (Connection conn = new Context().getJDBCConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            // Set parameters
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error in countDepartments: " + e.getMessage());
            e.printStackTrace();
        }
        
        return 0;
    }
    
    /**
     * Get department by ID
     */
    public Department getDepartmentById(int id) {
        String sql = """
            SELECT d.id, d.dept_code, d.dept_name, d.description, d.manager_id, 
                   d.phone, d.email, d.active_flag, d.created_by, d.create_date, 
                   d.updated_by, d.update_date,
                   manager.fullname as manager_name,
                   manager.email as manager_email,
                   manager.phone as manager_phone,
                   creator.fullname as created_by_name,
                   updater.fullname as updated_by_name,
                   COUNT(DISTINCT CASE WHEN u.active_flag = 1 THEN u.id END) as employee_count
            FROM department d
            LEFT JOIN users manager ON d.manager_id = manager.id
            LEFT JOIN users creator ON d.created_by = creator.id
            LEFT JOIN users updater ON d.updated_by = updater.id
            LEFT JOIN users u ON d.id = u.department_id
            WHERE d.id = ?
            GROUP BY d.id, d.dept_code, d.dept_name, d.description, d.manager_id, 
                     d.phone, d.email, d.active_flag, d.created_by, d.create_date, 
                     d.updated_by, d.update_date, manager.fullname, manager.email, 
                     manager.phone, creator.fullname, updater.fullname
            """;
        
        try (Connection conn = new Context().getJDBCConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToDepartment(rs);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error in getDepartmentById: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Check if department code exists (excluding current ID for updates)
     */
    public boolean isDeptCodeExists(String deptCode, int excludeId) {
        String sql = "SELECT COUNT(*) FROM department WHERE dept_code = ? AND id != ?";
        try (Connection conn = new Context().getJDBCConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, deptCode);
            ps.setInt(2, excludeId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            System.out.println("Error in isDeptCodeExists: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Check if department code exists (for new department)
     */
    public boolean isDeptCodeExists(String deptCode) {
        return isDeptCodeExists(deptCode, 0);
    }
    
    /**
     * Create new department
     */
    public boolean createDepartment(Department department) {
        String sql = """
            INSERT INTO department (dept_code, dept_name, description, manager_id, 
                                  phone, email, active_flag, created_by, create_date, 
                                  updated_by, update_date)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            """;
        
        try (Connection conn = new Context().getJDBCConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setString(1, department.getDeptCode());
            ps.setString(2, department.getDeptName());
            ps.setString(3, department.getDescription());
            ps.setObject(4, department.getManagerId());
            ps.setString(5, department.getPhone());
            ps.setString(6, department.getEmail());
            ps.setBoolean(7, department.isActiveFlag());
            ps.setObject(8, department.getCreatedBy());
            ps.setTimestamp(9, Timestamp.valueOf(department.getCreateDate()));
            ps.setObject(10, department.getUpdatedBy());
            ps.setTimestamp(11, Timestamp.valueOf(department.getUpdateDate()));
            
            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        department.setId(generatedKeys.getInt(1));
                        return true;
                    }
                }
            }
        } catch (SQLException e) {
            System.out.println("Error in createDepartment: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Validate if user can be manager of a department
     * Kiểm tra xem user có thuộc phòng ban đó không
     */
    public boolean canBeManager(int userId, int departmentId) {
        String sql = """
            SELECT COUNT(*) 
            FROM users u
            WHERE u.id = ? 
            AND u.department_id = ?
            AND u.active_flag = 1
            """;
        
        try (Connection conn = new Context().getJDBCConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ps.setInt(2, departmentId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            System.out.println("Error in canBeManager: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Update department (with manager validation)
     */
    public boolean updateDepartment(Department department) {
        // Nếu có manager_id, kiểm tra xem người đó có thuộc phòng ban không
        if (department.getManagerId() != null) {
            if (!canBeManager(department.getManagerId(), department.getId())) {
                System.out.println("Manager must be from the same department");
                return false;
            }
        }
        
        String sql = """
            UPDATE department 
            SET dept_code = ?, dept_name = ?, description = ?, manager_id = ?, 
                phone = ?, email = ?, active_flag = ?, updated_by = ?, update_date = ?
            WHERE id = ?
            """;
        
        try (Connection conn = new Context().getJDBCConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, department.getDeptCode());
            ps.setString(2, department.getDeptName());
            ps.setString(3, department.getDescription());
            ps.setObject(4, department.getManagerId());
            ps.setString(5, department.getPhone());
            ps.setString(6, department.getEmail());
            ps.setBoolean(7, department.isActiveFlag());
            ps.setObject(8, department.getUpdatedBy());
            ps.setTimestamp(9, Timestamp.valueOf(LocalDateTime.now()));
            ps.setInt(10, department.getId());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error in updateDepartment: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Toggle department status
     */
    public boolean toggleDepartmentStatus(int id, int updatedBy) {
        String sql = """
            UPDATE department 
            SET active_flag = NOT active_flag, updated_by = ?, update_date = ?
            WHERE id = ?
            """;
        
        try (Connection conn = new Context().getJDBCConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, updatedBy);
            ps.setTimestamp(2, Timestamp.valueOf(LocalDateTime.now()));
            ps.setInt(3, id);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error in toggleDepartmentStatus: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Assign manager to department (with validation)
     */
    public boolean assignManager(int departmentId, int managerId, int updatedBy) {
        // Kiểm tra xem người được gán có thuộc phòng ban không
        if (!canBeManager(managerId, departmentId)) {
            System.out.println("User " + managerId + " is not in department " + departmentId);
            return false;
        }
        
        String sql = """
            UPDATE department 
            SET manager_id = ?, updated_by = ?, update_date = ?
            WHERE id = ?
            """;
        
        try (Connection conn = new Context().getJDBCConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, managerId);
            ps.setInt(2, updatedBy);
            ps.setTimestamp(3, Timestamp.valueOf(LocalDateTime.now()));
            ps.setInt(4, departmentId);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error in assignManager: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Remove manager from department
     */
    public boolean removeManager(int departmentId, int updatedBy) {
        String sql = """
            UPDATE department 
            SET manager_id = NULL, updated_by = ?, update_date = ?
            WHERE id = ?
            """;
        
        try (Connection conn = new Context().getJDBCConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, updatedBy);
            ps.setTimestamp(2, Timestamp.valueOf(LocalDateTime.now()));
            ps.setInt(3, departmentId);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error in removeManager: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Get employees by department ID
     */
    public List<Map<String, Object>> getEmployeesByDepartmentId(int departmentId) {
        List<Map<String, Object>> employees = new ArrayList<>();
        
        // Query đơn giản để lấy thông tin users
        String userSql = """
            SELECT u.id, u.username, u.fullname, u.email, u.phone, 
                   u.active_flag, u.create_date
            FROM users u
            WHERE u.department_id = ?
            ORDER BY u.fullname
            """;
        
        // Query để lấy roles cho mỗi user
        String roleSql = """
            SELECT r.role_name 
            FROM user_role ur
            INNER JOIN role r ON ur.role_id = r.id
            WHERE ur.user_id = ?
            """;
        
        try (Connection conn = new Context().getJDBCConnection();
             PreparedStatement psUser = conn.prepareStatement(userSql)) {
            
            psUser.setInt(1, departmentId);
            
            System.out.println("Executing query for department ID: " + departmentId); // Debug log
            
            try (ResultSet rsUser = psUser.executeQuery()) {
                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss");
                
                while (rsUser.next()) {
                    Map<String, Object> employee = new HashMap<>();
                    int userId = rsUser.getInt("id");
                    
                    employee.put("id", userId);
                    employee.put("username", rsUser.getString("username"));
                    employee.put("fullname", rsUser.getString("fullname"));
                    employee.put("email", rsUser.getString("email"));
                    employee.put("phone", rsUser.getString("phone"));
                    employee.put("active", rsUser.getBoolean("active_flag"));
                    
                    // Convert LocalDateTime thành String
                    Timestamp createDate = rsUser.getTimestamp("create_date");
                    if (createDate != null) {
                        LocalDateTime dateTime = createDate.toLocalDateTime();
                        employee.put("joinDate", dateTime.format(formatter));
                    } else {
                        employee.put("joinDate", null);
                    }
                    
                    // Lấy roles riêng cho user
                    List<String> roles = new ArrayList<>();
                    try (PreparedStatement psRole = conn.prepareStatement(roleSql)) {
                        psRole.setInt(1, userId);
                        try (ResultSet rsRole = psRole.executeQuery()) {
                            while (rsRole.next()) {
                                roles.add(rsRole.getString("role_name"));
                            }
                        }
                    }
                    
                    // Nối các roles lại
                    String rolesStr = roles.isEmpty() ? "N/A" : String.join(", ", roles);
                    employee.put("roles", rolesStr);
                    
                    employees.add(employee);
                }
            }
            
            System.out.println("Found " + employees.size() + " employees"); // Debug log
            
        } catch (SQLException e) {
            System.out.println("Error in getEmployeesByDepartmentId: " + e.getMessage());
            e.printStackTrace();
        }
        
        return employees;
    }
    
    /**
     * Get available users that can be assigned as managers
     * CHỈ LẤY NGƯỜI TRONG PHÒNG BAN ĐÓ
     */
    public List<Map<String, Object>> getAvailableManagers(int departmentId) {
        List<Map<String, Object>> managers = new ArrayList<>();
        
        // Query chỉ lấy users thuộc phòng ban này
        String userSql = """
            SELECT u.id, u.username, u.fullname, u.email, u.phone
            FROM users u
            WHERE u.active_flag = 1 
            AND u.department_id = ?
            AND u.id NOT IN (
                SELECT manager_id 
                FROM department 
                WHERE manager_id IS NOT NULL 
                AND id != ?
            )
            ORDER BY u.fullname
            """;
        
        // Query để lấy roles
        String roleSql = """
            SELECT r.role_name 
            FROM user_role ur
            INNER JOIN role r ON ur.role_id = r.id
            WHERE ur.user_id = ?
            """;
        
        try (Connection conn = new Context().getJDBCConnection();
             PreparedStatement psUser = conn.prepareStatement(userSql)) {
            
            psUser.setInt(1, departmentId); // department_id của user phải = departmentId
            psUser.setInt(2, departmentId); // loại trừ manager của phòng ban khác
            
            try (ResultSet rsUser = psUser.executeQuery()) {
                while (rsUser.next()) {
                    Map<String, Object> manager = new HashMap<>();
                    int userId = rsUser.getInt("id");
                    
                    manager.put("id", userId);
                    manager.put("username", rsUser.getString("username"));
                    manager.put("fullname", rsUser.getString("fullname"));
                    manager.put("email", rsUser.getString("email"));
                    manager.put("phone", rsUser.getString("phone"));
                    
                    // Lấy roles riêng
                    List<String> roles = new ArrayList<>();
                    try (PreparedStatement psRole = conn.prepareStatement(roleSql)) {
                        psRole.setInt(1, userId);
                        try (ResultSet rsRole = psRole.executeQuery()) {
                            while (rsRole.next()) {
                                roles.add(rsRole.getString("role_name"));
                            }
                        }
                    }
                    
                    String rolesStr = roles.isEmpty() ? "N/A" : String.join(", ", roles);
                    manager.put("roles", rolesStr);
                    
                    managers.add(manager);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error in getAvailableManagers: " + e.getMessage());
            e.printStackTrace();
        }
        
        return managers;
    }
    
    /**
     * Get current status of department (for toggle operations)
     */
    public boolean getDepartmentStatus(int id) {
        String sql = "SELECT active_flag FROM department WHERE id = ?";
        try (Connection conn = new Context().getJDBCConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getBoolean("active_flag");
                }
            }
        } catch (SQLException e) {
            System.out.println("Error in getDepartmentStatus: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Map ResultSet to Department object
     */
    private Department mapResultSetToDepartment(ResultSet rs) throws SQLException {
        Department dept = new Department();
        dept.setId(rs.getInt("id"));
        dept.setDeptCode(rs.getString("dept_code"));
        dept.setDeptName(rs.getString("dept_name"));
        dept.setDescription(rs.getString("description"));
        dept.setManagerId(rs.getObject("manager_id", Integer.class));
        dept.setPhone(rs.getString("phone"));
        dept.setEmail(rs.getString("email"));
        dept.setActiveFlag(rs.getBoolean("active_flag"));
        dept.setCreatedBy(rs.getObject("created_by", Integer.class));
        
        Timestamp createDate = rs.getTimestamp("create_date");
        if (createDate != null) {
            dept.setCreateDate(createDate.toLocalDateTime());
        }
        
        dept.setUpdatedBy(rs.getObject("updated_by", Integer.class));
        
        Timestamp updateDate = rs.getTimestamp("update_date");
        if (updateDate != null) {
            dept.setUpdateDate(updateDate.toLocalDateTime());
        }
        
        // Additional display fields
        dept.setManagerName(rs.getString("manager_name"));
        dept.setManagerEmail(rs.getString("manager_email"));
        dept.setManagerPhone(rs.getString("manager_phone"));
        dept.setCreatedByName(rs.getString("created_by_name"));
        dept.setUpdatedByName(rs.getString("updated_by_name"));
        dept.setEmployeeCount(rs.getInt("employee_count"));
        
        return dept;
    }
}