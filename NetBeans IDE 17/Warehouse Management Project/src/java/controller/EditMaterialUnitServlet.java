/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller; // Controller for editing a material unit

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import dao.MaterialUnitDAO;
import model.MaterialUnit;


public class EditMaterialUnitServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private MaterialUnitDAO materialUnitDAO;
    
    public void init() {
        materialUnitDAO = new MaterialUnitDAO();
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            // Lấy id từ request
            int id = Integer.parseInt(request.getParameter("id"));
            
            // Lấy thông tin MaterialUnit từ database
            MaterialUnit unit = materialUnitDAO.getMaterialUnitById(id);
              // Kiểm tra xem unit có tồn tại không
            if (unit == null) {
                // Nếu không tìm thấy, chuyển hướng về trang chính
                response.sendRedirect("materialUnit");
                return;
            }
            
            // Đặt vào request attribute
            request.setAttribute("unit", unit);
            
            // In log để debug
            System.out.println("Editing unit: " + unit.getId() + " - " + unit.getName());
            
            // Chuyển đến trang edit
            request.getRequestDispatcher("/material_unit/editMaterialUnit.jsp").forward(request, response);        } catch (NumberFormatException e) {
            // Xử lý lỗi khi id không phải là số
            System.err.println("Invalid ID format: " + e.getMessage());
            response.sendRedirect("materialUnit");
        } catch (Exception e) {
            // Xử lý các lỗi khác
            System.err.println("Error in EditMaterialUnitServlet.doGet: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("materialUnit");
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {        try {            // Lấy dữ liệu từ form
            int id = Integer.parseInt(request.getParameter("id"));
            String name = request.getParameter("name");
            String symbol = request.getParameter("symbol");
            String description = request.getParameter("description");
            String statusParam = request.getParameter("status");
            int status = Integer.parseInt(statusParam != null ? statusParam : "1"); // Default to active

            // Kiểm tra dữ liệu không được để trống
            if (name == null || name.trim().isEmpty()) {
                MaterialUnit unit = new MaterialUnit();
                unit.setId(id);
                unit.setName(name);
                unit.setSymbol(symbol);
                unit.setDescription(description);
                unit.setStatus(status);
                request.setAttribute("unit", unit);
                request.setAttribute("errorMessage", "Tên đơn vị không được để trống.");
                request.getRequestDispatcher("/material_unit/editMaterialUnit.jsp").forward(request, response);
                return;
            }
            
            if (symbol == null || symbol.trim().isEmpty()) {
                MaterialUnit unit = new MaterialUnit();
                unit.setId(id);
                unit.setName(name);
                unit.setSymbol(symbol);
                unit.setDescription(description);
                unit.setStatus(status);
                request.setAttribute("unit", unit);
                request.setAttribute("errorMessage", "Ký hiệu đơn vị không được để trống.");
                request.getRequestDispatcher("/material_unit/editMaterialUnit.jsp").forward(request, response);
                return;
            }

            // Kiểm tra độ dài của tên và ký hiệu
            if (name.length() > 50) {
                MaterialUnit unit = new MaterialUnit();
                unit.setId(id);
                unit.setName(name);
                unit.setSymbol(symbol);
                unit.setDescription(description);
                unit.setStatus(status);
                request.setAttribute("unit", unit);
                request.setAttribute("errorMessage", "Tên đơn vị không được vượt quá 50 ký tự.");
                request.getRequestDispatcher("/material_unit/editMaterialUnit.jsp").forward(request, response);
                return;
            }
            
            if (symbol.length() > 10) {
                MaterialUnit unit = new MaterialUnit();
                unit.setId(id);
                unit.setName(name);
                unit.setSymbol(symbol);
                unit.setDescription(description);
                unit.setStatus(status);
                request.setAttribute("unit", unit);
                request.setAttribute("errorMessage", "Ký hiệu đơn vị không được vượt quá 10 ký tự.");
                request.getRequestDispatcher("/material_unit/editMaterialUnit.jsp").forward(request, response);
                return;
            }

            // Kiểm tra trùng tên hoặc ký hiệu (bỏ qua chính nó)
            if (materialUnitDAO.isDuplicateNameOrSymbol(name, symbol, id)) {
                MaterialUnit unit = new MaterialUnit();
                unit.setId(id);
                unit.setName(name);
                unit.setSymbol(symbol);
                unit.setDescription(description);
                unit.setStatus(status);
                request.setAttribute("unit", unit);
                request.setAttribute("errorMessage", "Tên hoặc ký hiệu đã tồn tại. Vui lòng nhập giá trị khác.");
                request.getRequestDispatcher("/material_unit/editMaterialUnit.jsp").forward(request, response);
                return;
            }

            // In log để debug
            System.out.println("Updating unit: " + id + " - " + name);

            // Tạo đối tượng MaterialUnit
            MaterialUnit unit = new MaterialUnit();
            unit.setId(id);
            unit.setName(name);
            unit.setSymbol(symbol);
            unit.setDescription(description);
            unit.setStatus(status);

            // Cập nhật vào database
            boolean updated = materialUnitDAO.updateMaterialUnit(unit);            if (updated) {
                // Nếu cập nhật thành công, thông báo thành công và chuyển hướng
                request.getSession().setAttribute("successMessage", "Cập nhật đơn vị thành công!");
                response.sendRedirect("materialUnit");
            } else {
                // Nếu cập nhật thất bại, hiển thị lại form với thông báo lỗi
                request.setAttribute("unit", unit);
                request.setAttribute("errorMessage", "Failed to update material unit.");
                request.getRequestDispatcher("/material_unit/editMaterialUnit.jsp").forward(request, response);
            }        } catch (Exception e) {
            // Xử lý lỗi
            System.err.println("Error in EditMaterialUnitServlet.doPost: " + e.getMessage());
            e.printStackTrace();
            // Thông báo lỗi thay vì redirect im lặng
            request.setAttribute("errorMessage", "Có lỗi xảy ra khi cập nhật đơn vị. Vui lòng thử lại.");
            request.getRequestDispatcher("/material_unit/editMaterialUnit.jsp").forward(request, response);
        }
    }
}