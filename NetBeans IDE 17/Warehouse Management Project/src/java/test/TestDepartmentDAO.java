package test;

import dao.DepartmentDAO;
import model.Department;

public class TestDepartmentDAO {
    public static void main(String[] args) {
        DepartmentDAO dao = new DepartmentDAO();
        int testId = 1; // Thay bằng ID phòng ban bạn muốn test

        Department dept = dao.getDepartmentById(testId);

        if (dept != null) {
            System.out.println("== Thông tin phòng ban ==");
            System.out.println("ID: " + dept.getId());
            System.out.println("Mã phòng ban: " + dept.getDeptCode());
            System.out.println("Tên phòng ban: " + dept.getDeptName());
            System.out.println("Mô tả: " + dept.getDescription());
            System.out.println("Điện thoại: " + dept.getPhone());
            System.out.println("Email: " + dept.getEmail());
            System.out.println("Trạng thái: " + (dept.isActiveFlag() ? "Hoạt động" : "Không hoạt động"));
            System.out.println("Ngày tạo: " + dept.getCreateDate());
            System.out.println("Ngày cập nhật: " + dept.getUpdateDate());
        } else {
            System.out.println("Không tìm thấy phòng ban với id = " + testId);
        }
    }
}
