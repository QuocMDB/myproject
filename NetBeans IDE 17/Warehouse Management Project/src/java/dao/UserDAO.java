package dao;

import DBContext.Context;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import model.ForgotPasswordRequest;
import model.Permission;
import model.Role;
import model.Users;

public class UserDAO extends Context {

    public List<Users> getAllUsers() {
        List<Users> list = new ArrayList<>();
        String sql = "SELECT u.*, r.role_name "
                + "FROM users u "
                + "LEFT JOIN user_role ur ON u.id = ur.user_id "
                + "LEFT JOIN role r ON ur.role_id = r.id "
                + "WHERE r.role_name != 'Admin'";

        try (Connection connection = Context.getJDBCConnection(); PreparedStatement stmt = connection.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Users user = new Users();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setDob(rs.getDate("dob"));
                user.setPhone(rs.getString("phone"));
                user.setFullname(rs.getString("fullname"));
                user.setEmail(rs.getString("email"));
                user.setActiveFlag(rs.getInt("active_flag"));
                user.setCreateDate(rs.getTimestamp("create_date"));
                user.setRoleName(rs.getString("role_name"));
                list.add(user);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Users> getAllUsersExcludeAdmin() {
        List<Users> list = new ArrayList<>();
        String sql = "SELECT u.*, r.role_name "
                + "FROM users u "
                + "LEFT JOIN user_role ur ON u.id = ur.user_id "
                + "LEFT JOIN role r ON ur.role_id = r.id "
                + "WHERE r.role_name != 'Admin'";

        try (Connection connection = Context.getJDBCConnection(); PreparedStatement stmt = connection.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Users user = new Users();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setFullname(rs.getString("fullname"));
                user.setEmail(rs.getString("email"));
                user.setPhone(rs.getString("phone"));
                user.setDob(rs.getDate("dob"));
                user.setActiveFlag(rs.getInt("active_flag"));
                user.setCreateDate(rs.getTimestamp("create_date"));
                user.setRoleName(rs.getString("role_name"));
                list.add(user);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Permission> getAllPermissions() {
        List<Permission> list = new ArrayList<>();
        String sql = "SELECT * FROM permission";
        try (Connection connection = Context.getJDBCConnection(); PreparedStatement stmt = connection.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Permission p = new Permission(
                        rs.getInt("id"),
                        rs.getString("code"),
                        rs.getString("name")
                );
                list.add(p);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Role> getAllRoles() {
        List<Role> list = new ArrayList<>();
        String sql = "SELECT * FROM role";
        try (Connection con = Context.getJDBCConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Role r = new Role(
                        rs.getInt("id"),
                        rs.getString("role_name")
                );
                list.add(r);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Integer> getPermissionIdsByRoleId(int roleId) {
        List<Integer> list = new ArrayList<>();
        String sql = "SELECT permission_id FROM role_permission WHERE role_id = ?";
        try (Connection con = Context.getJDBCConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, roleId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(rs.getInt(1));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<String> getUserPermissions(int userId) {
        List<String> codes = new ArrayList<>();
        String sql = "SELECT p.code FROM user_role ur "
                + "JOIN role_permission rp ON ur.role_id = rp.role_id "
                + "JOIN permission p ON rp.permission_id = p.id "
                + "WHERE ur.user_id = ?";
        try (Connection con = Context.getJDBCConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    codes.add(rs.getString(1));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return codes;
    }

    public void addPermissionsToRole(int roleId, List<Integer> permissionIds) {
        if (permissionIds == null || permissionIds.isEmpty()) {
            return;
        }
        String sql = "INSERT INTO role_permission (role_id, permission_id) VALUES (?, ?)";
        try (Connection conn = Context.getJDBCConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            for (Integer pid : permissionIds) {
                ps.setInt(1, roleId);
                ps.setInt(2, pid);
                ps.addBatch();
            }
            ps.executeBatch();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void deletePermissionsOfRoleForPermissions(int roleId, List<Integer> permissionIds) {
        if (permissionIds == null || permissionIds.isEmpty()) {
            return;
        }
        StringBuilder sql = new StringBuilder("DELETE FROM role_permission WHERE role_id=? AND permission_id IN (");
        for (int i = 0; i < permissionIds.size(); i++) {
            sql.append("?");
            if (i < permissionIds.size() - 1) {
                sql.append(",");
            }
        }
        sql.append(")");
        try (Connection conn = Context.getJDBCConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            ps.setInt(1, roleId);
            for (int i = 0; i < permissionIds.size(); i++) {
                ps.setInt(i + 2, permissionIds.get(i));
            }
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void addUser(Users user, int roleId) throws SQLException {
        Connection connection = Context.getJDBCConnection();
        connection.setAutoCommit(false);
        try {
            String sqlUser = "INSERT INTO users(username, password, email, fullname, phone, dob, active_flag, department_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            try (PreparedStatement stmtUser = connection.prepareStatement(sqlUser, Statement.RETURN_GENERATED_KEYS)) {
                stmtUser.setString(1, user.getUsername());
                stmtUser.setString(2, user.getPassword());
                stmtUser.setString(3, user.getEmail());
                stmtUser.setString(4, user.getFullname());
                stmtUser.setString(5, user.getPhone());
                if (user.getDob() != null) {
                    stmtUser.setDate(6, new java.sql.Date(user.getDob().getTime()));
                } else {
                    stmtUser.setNull(6, java.sql.Types.DATE);
                }
                stmtUser.setInt(7, user.getActiveFlag());
                // Bổ sung departmentId
                if (user.getDepartmentId() != null) {
                    stmtUser.setInt(8, user.getDepartmentId());
                } else {
                    stmtUser.setNull(8, java.sql.Types.INTEGER);
                }
                stmtUser.executeUpdate();

                try (ResultSet generatedKeys = stmtUser.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        int userId = generatedKeys.getInt(1);

                        String sqlUserRole = "INSERT INTO user_role(user_id, role_id) VALUES (?, ?)";
                        try (PreparedStatement stmtUserRole = connection.prepareStatement(sqlUserRole)) {
                            stmtUserRole.setInt(1, userId);
                            stmtUserRole.setInt(2, roleId);
                            stmtUserRole.executeUpdate();
                        }
                    } else {
                        throw new SQLException("Failed to get user ID.");
                    }
                }
            }
            connection.commit();
        } catch (SQLException e) {
            connection.rollback();
            throw e;
        } finally {
            connection.setAutoCommit(true);
        }
    }

    public Users getUserById(int id) { 
    String sql = "SELECT u.*, r.role_name, d.dept_name "
            + "FROM users u "
            + "LEFT JOIN user_role ur ON u.id = ur.user_id "
            + "LEFT JOIN role r ON ur.role_id = r.id "
            + "LEFT JOIN department d ON u.department_id = d.id "
            + "WHERE u.id = ?";
    try (Connection connection = Context.getJDBCConnection(); 
         PreparedStatement stmt = connection.prepareStatement(sql)) {
        stmt.setInt(1, id);
        try (ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                Users user = new Users();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setPassword(rs.getString("password"));
                user.setDob(rs.getDate("dob"));
                user.setPhone(rs.getString("phone"));
                user.setFullname(rs.getString("fullname"));
                user.setEmail(rs.getString("email"));
                user.setActiveFlag(rs.getInt("active_flag"));
                user.setCreateDate(rs.getTimestamp("create_date"));
                user.setRoleName(rs.getString("role_name"));
                user.setDepartmentId(rs.getObject("department_id") != null ? rs.getInt("department_id") : null);
                user.setDeptName(rs.getString("dept_name"));
                return user;
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return null;
}


    public void updateUser(Users user, int roleId) throws SQLException {
    Connection connection = Context.getJDBCConnection();
    connection.setAutoCommit(false);
    try {
        String sqlUser = "UPDATE users SET username=?, fullname=?, email=?, phone=?, dob=?, active_flag=?, department_id=?, password=? WHERE id=?";
        try (PreparedStatement stmtUser = connection.prepareStatement(sqlUser)) {
            stmtUser.setString(1, user.getUsername());
            stmtUser.setString(2, user.getFullname());
            stmtUser.setString(3, user.getEmail());
            stmtUser.setString(4, user.getPhone());
            if (user.getDob() != null) {
                stmtUser.setDate(5, new java.sql.Date(user.getDob().getTime()));
            } else {
                stmtUser.setNull(5, java.sql.Types.DATE);
            }
            stmtUser.setInt(6, user.getActiveFlag());
            if (user.getDepartmentId() != null) {
                stmtUser.setInt(7, user.getDepartmentId());
            } else {
                stmtUser.setNull(7, java.sql.Types.INTEGER);
            }
            stmtUser.setString(8, user.getPassword()); // Luôn truyền mật khẩu (cũ hoặc mới)
            stmtUser.setInt(9, user.getId());
            stmtUser.executeUpdate();
        }

        String sqlDelete = "DELETE FROM user_role WHERE user_id=?";
        try (PreparedStatement stmtDelete = connection.prepareStatement(sqlDelete)) {
            stmtDelete.setInt(1, user.getId());
            stmtDelete.executeUpdate();
        }

        String sqlInsert = "INSERT INTO user_role(user_id, role_id) VALUES (?, ?)";
        try (PreparedStatement stmtInsert = connection.prepareStatement(sqlInsert)) {
            stmtInsert.setInt(1, user.getId());
            stmtInsert.setInt(2, roleId);
            stmtInsert.executeUpdate();
        }

        connection.commit();
    } catch (Exception e) {
        connection.rollback();
        throw e;
    } finally {
        connection.setAutoCommit(true);
    }
}


    public void updateProfile(Users user) throws SQLException {
    String sql = "UPDATE users SET fullname=?, email=?, phone=?, dob=? WHERE id=?";
    try (Connection connection = Context.getJDBCConnection();
         PreparedStatement stmt = connection.prepareStatement(sql)) {
        stmt.setString(1, user.getFullname());
        stmt.setString(2, user.getEmail());
        stmt.setString(3, user.getPhone());
        if (user.getDob() != null) {
            stmt.setDate(4, new java.sql.Date(user.getDob().getTime()));
        } else {
            stmt.setNull(4, java.sql.Types.DATE);
        }
        stmt.setInt(5, user.getId());
        stmt.executeUpdate();
    }
}


    public List<Users> filterUsers(Integer roleId, String status, String keyword, Integer departmentId, boolean includeAdmin) {
        List<Users> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT u.*, r.role_name, d.dept_name "
                + "FROM users u "
                + "LEFT JOIN user_role ur ON u.id = ur.user_id "
                + "LEFT JOIN role r ON ur.role_id = r.id "
                + "LEFT JOIN department d ON u.department_id = d.id "
                + "WHERE 1=1 ");

        if (!includeAdmin) {
            sql.append(" AND r.role_name != 'Admin' ");
        }

        if (roleId != null) {
            sql.append(" AND r.id = ? ");
        }

        if (status != null && !status.isEmpty()) {
            if ("active".equalsIgnoreCase(status)) {
                sql.append(" AND u.active_flag = 1 ");
            } else if ("inactive".equalsIgnoreCase(status)) {
                sql.append(" AND u.active_flag = 0 ");
            }
        }

        if (departmentId != null) {
            sql.append(" AND u.department_id = ? ");
        }

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (u.username LIKE ? OR u.fullname LIKE ? OR u.email LIKE ? OR d.dept_name LIKE ? OR d.dept_code LIKE ?) ");
        }

        try (Connection connection = Context.getJDBCConnection(); PreparedStatement stmt = connection.prepareStatement(sql.toString())) {
            int paramIndex = 1;

            if (roleId != null) {
                stmt.setInt(paramIndex++, roleId);
            }
            if (departmentId != null) {
                stmt.setInt(paramIndex++, departmentId);
            }
            if (keyword != null && !keyword.trim().isEmpty()) {
                String kw = "%" + keyword.trim() + "%";
                for (int i = 0; i < 5; i++) {
                    stmt.setString(paramIndex++, kw);
                }
            }

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Users user = new Users();
                    user.setId(rs.getInt("id"));
                    user.setUsername(rs.getString("username"));
                    user.setFullname(rs.getString("fullname"));
                    user.setEmail(rs.getString("email"));
                    user.setPhone(rs.getString("phone"));
                    user.setDob(rs.getDate("dob"));
                    user.setActiveFlag(rs.getInt("active_flag"));
                    user.setCreateDate(rs.getTimestamp("create_date"));

                    String roleName = rs.getString("role_name");
                    if (roleName == null) {
                        roleName = "No Role";
                    }
                    user.setRoleName(roleName);

                    String deptName = rs.getString("dept_name");
                    user.setDeptName(deptName);

                    list.add(user);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<Users> getUsersByPage(int pageIndex, int pageSize) {
        List<Users> list = new ArrayList<>();
        String sql = "SELECT u.*, r.role_name "
                + "FROM users u "
                + "LEFT JOIN user_role ur ON u.id = ur.user_id "
                + "LEFT JOIN role r ON ur.role_id = r.id "
                + "WHERE r.role_name != 'Admin'"
                + "ORDER BY u.id "
                + "LIMIT ? OFFSET ?";

        int offset = (pageIndex - 1) * pageSize;

        try (
                Connection connection = Context.getJDBCConnection(); PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, pageSize);
            stmt.setInt(2, offset);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Users user = new Users();
                    user.setId(rs.getInt("id"));
                    user.setUsername(rs.getString("username"));
                    user.setFullname(rs.getString("fullname"));
                    user.setEmail(rs.getString("email"));
                    user.setPhone(rs.getString("phone"));
                    user.setDob(rs.getDate("dob"));
                    user.setActiveFlag(rs.getInt("active_flag"));
                    user.setCreateDate(rs.getTimestamp("create_date"));
                    user.setRoleName(rs.getString("role_name"));
                    list.add(user);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public int getTotalUserCount() {
        String sql = "SELECT COUNT(*) FROM users";
        try (Connection connection = Context.getJDBCConnection(); PreparedStatement stmt = connection.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int countFilteredUsers(Integer roleId, String status, String keyword, Integer departmentId, boolean includeAdmin) {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) FROM users u "
                + "LEFT JOIN user_role ur ON u.id = ur.user_id "
                + "LEFT JOIN role r ON ur.role_id = r.id "
                + "LEFT JOIN department d ON u.department_id = d.id "
                + "WHERE 1=1 ");

        if (!includeAdmin) {
            sql.append(" AND r.role_name != 'Admin' ");
        }
        if (roleId != null) {
            sql.append(" AND r.id = ? ");
        }
        if (status != null && !status.isEmpty()) {
            if ("active".equalsIgnoreCase(status)) {
                sql.append(" AND u.active_flag = 1 ");
            } else if ("inactive".equalsIgnoreCase(status)) {
                sql.append(" AND u.active_flag = 0 ");
            }
        }
        if (departmentId != null) {
            sql.append(" AND u.department_id = ? ");
        }
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (u.username LIKE ? OR u.fullname LIKE ? OR u.email LIKE ? OR d.dept_name LIKE ? OR d.dept_code LIKE ?) ");
        }

        try (Connection connection = Context.getJDBCConnection(); PreparedStatement stmt = connection.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            if (roleId != null) {
                stmt.setInt(paramIndex++, roleId);
            }
            if (departmentId != null) {
                stmt.setInt(paramIndex++, departmentId);
            }
            if (keyword != null && !keyword.trim().isEmpty()) {
                String kw = "%" + keyword.trim() + "%";
                for (int i = 0; i < 5; i++) {
                    stmt.setString(paramIndex++, kw);
                }
            }
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<Users> filterUsersWithPaging(Integer roleId, String status, String keyword, Integer departmentId, boolean includeAdmin, int pageIndex, int pageSize) {
        List<Users> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT u.*, r.role_name, d.dept_name "
                + "FROM users u "
                + "LEFT JOIN user_role ur ON u.id = ur.user_id "
                + "LEFT JOIN role r ON ur.role_id = r.id "
                + "LEFT JOIN department d ON u.department_id = d.id "
                + "WHERE 1=1 ");

        if (!includeAdmin) {
            sql.append(" AND r.role_name != 'Admin' ");
        }
        if (roleId != null) {
            sql.append(" AND r.id = ? ");
        }
        if (status != null && !status.isEmpty()) {
            if ("active".equalsIgnoreCase(status)) {
                sql.append(" AND u.active_flag = 1 ");
            } else if ("inactive".equalsIgnoreCase(status)) {
                sql.append(" AND u.active_flag = 0 ");
            }
        }
        if (departmentId != null) {
            sql.append(" AND u.department_id = ? ");
        }
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (u.username LIKE ? OR u.fullname LIKE ? OR u.email LIKE ? OR d.dept_name LIKE ? OR d.dept_code LIKE ?) ");
        }

        sql.append(" ORDER BY u.id ");
        sql.append(" LIMIT ? OFFSET ? ");

        int offset = (pageIndex - 1) * pageSize;

        try (Connection connection = Context.getJDBCConnection(); PreparedStatement stmt = connection.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            if (roleId != null) {
                stmt.setInt(paramIndex++, roleId);
            }
            if (departmentId != null) {
                stmt.setInt(paramIndex++, departmentId);
            }
            if (keyword != null && !keyword.trim().isEmpty()) {
                String kw = "%" + keyword.trim() + "%";
                for (int i = 0; i < 5; i++) {
                    stmt.setString(paramIndex++, kw);
                }
            }
            stmt.setInt(paramIndex++, pageSize);
            stmt.setInt(paramIndex++, offset);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Users user = new Users();
                    user.setId(rs.getInt("id"));
                    user.setUsername(rs.getString("username"));
                    user.setFullname(rs.getString("fullname"));
                    user.setEmail(rs.getString("email"));
                    user.setPhone(rs.getString("phone"));
                    user.setDob(rs.getDate("dob"));
                    user.setActiveFlag(rs.getInt("active_flag"));
                    user.setCreateDate(rs.getTimestamp("create_date"));
                    user.setRoleName(rs.getString("role_name"));
                    user.setDeptName(rs.getString("dept_name"));
                    list.add(user);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Integer getUserIdByEmail(String email) {
        String sql = "SELECT id FROM users WHERE email = ?";
        try (Connection conn = Context.getJDBCConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("id");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

// Thêm yêu cầu reset mật khẩu
    public boolean insertPasswordResetRequest(int userId, String note) {
        String sql = "INSERT INTO password_reset_requests (user_id, note) VALUES (?, ?)";
        try (Connection conn = Context.getJDBCConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, note);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public ForgotPasswordRequest getPasswordResetRequestById(int reqId) {
        String sql = "SELECT prr.*, u.username, u.email "
                + "FROM password_reset_requests prr "
                + "LEFT JOIN users u ON prr.user_id = u.id "
                + "WHERE prr.id = ?";
        try (Connection conn = Context.getJDBCConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, reqId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    ForgotPasswordRequest req = new ForgotPasswordRequest();
                    req.setId(rs.getInt("id"));
                    req.setUserId(rs.getInt("user_id"));
                    req.setUsername(rs.getString("username"));
                    req.setEmail(rs.getString("email"));
                    req.setRequestTime(rs.getTimestamp("request_time"));
                    req.setNote(rs.getString("note"));
                    req.setResponseTime(rs.getTimestamp("response_time"));
                    req.setStatus(rs.getString("status"));
                    return req;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<ForgotPasswordRequest> getAllRequests() {
        List<ForgotPasswordRequest> requests = new ArrayList<>();
        String sql = "SELECT prr.id, u.username, u.email, prr.request_time, prr.note, prr.response_time, prr.status "
                + "FROM password_reset_requests prr "
                + "LEFT JOIN users u ON prr.user_id = u.id "
                //+ "WHERE prr.status = 'pending' "
                + "ORDER BY prr.request_time DESC";
        try (Connection conn = Context.getJDBCConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                ForgotPasswordRequest req = new ForgotPasswordRequest();
                req.setId(rs.getInt("id"));
                req.setUsername(rs.getString("username"));
                req.setEmail(rs.getString("email"));
                req.setRequestTime(rs.getTimestamp("request_time"));
                req.setNote(rs.getString("note"));
                req.setResponseTime(rs.getTimestamp("response_time"));
                req.setStatus(rs.getString("status"));
                requests.add(req);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return requests;
    }

    public boolean approveAndUpdate(
            int reqId, int userId, String newPassword, int adminId) {
        Connection conn = null;
        PreparedStatement psUpdateUser = null;
        PreparedStatement psUpdateRequest = null;
        try {
            conn = Context.getJDBCConnection();
            conn.setAutoCommit(false); // Đảm bảo atomicity

            // 1. Cập nhật mật khẩu mới cho user
            String sql1 = "UPDATE users SET password=? WHERE id=?";
            psUpdateUser = conn.prepareStatement(sql1);
            psUpdateUser.setString(1, newPassword);
            psUpdateUser.setInt(2, userId);
            int updatedRows = psUpdateUser.executeUpdate();

            if (updatedRows == 0) {
                conn.rollback();
                return false;
            }

            // 2. Duyệt (approve) đơn yêu cầu đổi mật khẩu
            String sql2 = "UPDATE password_reset_requests SET status='approved', admin_id=?, response_time=NOW() WHERE id=?";
            psUpdateRequest = conn.prepareStatement(sql2);
            psUpdateRequest.setInt(1, adminId);
            psUpdateRequest.setInt(2, reqId);
            int updatedReq = psUpdateRequest.executeUpdate();

            if (updatedReq == 0) {
                conn.rollback();
                return false;
            }

            conn.commit();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            try {
                if (conn != null) {
                    conn.rollback();
                }
            } catch (Exception ex) {
            }
        } finally {
            try {
                if (psUpdateUser != null) {
                    psUpdateUser.close();
                }
            } catch (Exception e) {
            }
            try {
                if (psUpdateRequest != null) {
                    psUpdateRequest.close();
                }
            } catch (Exception e) {
            }
            try {
                if (conn != null) {
                    conn.close();
                }
            } catch (Exception e) {
            }
        }
        return false;
    }

    // Từ chối (reject) yêu cầu
    public boolean updateRequestStatus(int reqId, int adminId, String status) {
        String sql = "UPDATE password_reset_requests SET status=?, admin_id=?, response_time=NOW() WHERE id=?";
        try (Connection conn = Context.getJDBCConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, adminId);
            ps.setInt(3, reqId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public Users findByUsername(String username) {
        String sql = "SELECT u.*, r.role_name "
                + "FROM users u "
                + "LEFT JOIN user_role ur ON u.id = ur.user_id "
                + "LEFT JOIN role r ON ur.role_id = r.id "
                + "WHERE u.username = ? AND u.active_flag = 1";
        try {
            Connection connection = Context.getJDBCConnection();
            PreparedStatement stmt = connection.prepareStatement(sql);
            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                Users user = new Users();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setPassword(rs.getString("password")); // Đây là chuỗi hash đã lưu trong DB
                user.setEmail(rs.getString("email"));
                user.setDob(rs.getDate("dob"));
                user.setPhone(rs.getString("phone"));
                user.setFullname(rs.getString("fullname"));
                user.setActiveFlag(rs.getInt("active_flag"));
                user.setCreateDate(rs.getTimestamp("create_date"));
                user.setRoleName(rs.getString("role_name"));
                return user;
            }
            rs.close();
            stmt.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updatePasswordHash(int userId, String hashedPassword) {
        String sql = "UPDATE users SET password = ? WHERE id = ?";
        try (
                Connection connection = Context.getJDBCConnection(); PreparedStatement stmt = connection.prepareStatement(sql);) {
            stmt.setString(1, hashedPassword);
            stmt.setInt(2, userId);

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public String getFullName(int userId) {
        String fullName = null;
        String sql = "SELECT fullname FROM users WHERE id = ?";

        try (Connection conn = Context.getJDBCConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    fullName = rs.getString("fullname");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return fullName;
    }

    public Date getDoB(int userId) {
        Date dob = null;
        String sql = "SELECT DoB FROM users WHERE id = ?";

        try (Connection conn = Context.getJDBCConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    dob = rs.getDate("DoB");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return dob;
    }
}
