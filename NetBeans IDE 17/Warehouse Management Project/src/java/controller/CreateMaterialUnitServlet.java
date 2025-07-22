/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller; // Controller for creating a new material unit

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import dao.MaterialUnitDAO;
import model.MaterialUnit;

public class CreateMaterialUnitServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private MaterialUnitDAO materialUnitDAO;
    
    @Override
    public void init() {
        materialUnitDAO = new MaterialUnitDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Hiển thị form tạo mới
        request.getRequestDispatcher("/material_unit/createMaterialUnit.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {        try {            // Lấy dữ liệu từ form
            String name = request.getParameter("name");
            String symbol = request.getParameter("symbol");
            String description = request.getParameter("description");
            String statusParam = request.getParameter("status");
            int status = Integer.parseInt(statusParam != null ? statusParam : "1"); // Default to active

            // Kiểm tra dữ liệu không được để trống
            if (name == null || name.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Tên đơn vị không được để trống.");
                MaterialUnit unit = new MaterialUnit();
                unit.setName(name);
                unit.setSymbol(symbol);
                unit.setDescription(description);
                unit.setStatus(status);
                request.setAttribute("unit", unit);
                request.getRequestDispatcher("/material_unit/createMaterialUnit.jsp").forward(request, response);
                return;
            }
            
            if (symbol == null || symbol.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Ký hiệu đơn vị không được để trống.");
                MaterialUnit unit = new MaterialUnit();
                unit.setName(name);
                unit.setSymbol(symbol);
                unit.setDescription(description);
                unit.setStatus(status);
                request.setAttribute("unit", unit);
                request.getRequestDispatcher("/material_unit/createMaterialUnit.jsp").forward(request, response);
                return;
            }

            // Kiểm tra độ dài của tên và ký hiệu
            if (name.length() > 50) {
                request.setAttribute("errorMessage", "Tên đơn vị không được vượt quá 50 ký tự.");
                MaterialUnit unit = new MaterialUnit();
                unit.setName(name);
                unit.setSymbol(symbol);
                unit.setDescription(description);
                unit.setStatus(status);
                request.setAttribute("unit", unit);
                request.getRequestDispatcher("/material_unit/createMaterialUnit.jsp").forward(request, response);
                return;
            }
            
            if (symbol.length() > 10) {
                request.setAttribute("errorMessage", "Ký hiệu đơn vị không được vượt quá 10 ký tự.");
                MaterialUnit unit = new MaterialUnit();
                unit.setName(name);
                unit.setSymbol(symbol);
                unit.setDescription(description);
                unit.setStatus(status);
                request.setAttribute("unit", unit);
                request.getRequestDispatcher("/material_unit/createMaterialUnit.jsp").forward(request, response);
                return;
            }

            // Kiểm tra trùng tên hoặc ký hiệu
            if (materialUnitDAO.isDuplicateNameOrSymbol(name, symbol, null)) {
                request.setAttribute("errorMessage", "Tên hoặc ký hiệu đã tồn tại. Vui lòng nhập giá trị khác.");
                // Giữ lại dữ liệu đã nhập
                MaterialUnit unit = new MaterialUnit();
                unit.setName(name);
                unit.setSymbol(symbol);
                unit.setDescription(description);
                unit.setStatus(status);
                request.setAttribute("unit", unit);
                request.getRequestDispatcher("/material_unit/createMaterialUnit.jsp").forward(request, response);
                return;
            }

            // Tạo đối tượng MaterialUnit
            MaterialUnit unit = new MaterialUnit();
            unit.setName(name);
            unit.setSymbol(symbol);
            unit.setDescription(description);
            unit.setStatus(status);            // Lưu vào database
            boolean success = materialUnitDAO.addMaterialUnit(unit);

            if (success) {
                // Thông báo thành công
                request.getSession().setAttribute("successMessage", "Thêm đơn vị thành công!");
                response.sendRedirect("materialUnit");
            } else {
                // Thông báo lỗi khi không thể lưu
                request.setAttribute("errorMessage", "Không thể thêm đơn vị. Vui lòng thử lại.");
                request.setAttribute("unit", unit);
                request.getRequestDispatcher("/material_unit/createMaterialUnit.jsp").forward(request, response);
            }        } catch (Exception e) {
            e.printStackTrace();
            // Thông báo lỗi thay vì redirect im lặng
            request.setAttribute("errorMessage", "Có lỗi xảy ra khi thêm đơn vị. Vui lòng thử lại.");
            request.getRequestDispatcher("/material_unit/createMaterialUnit.jsp").forward(request, response);
        }
    }
}
