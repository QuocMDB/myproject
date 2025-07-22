/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller; // Controller for deleting a material unit

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import dao.MaterialUnitDAO;


public class DeleteMaterialUnitServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private MaterialUnitDAO materialUnitDAO;
    
    public void init() {
        materialUnitDAO = new MaterialUnitDAO();
    }
      protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            
            // Check if the unit can be deleted
            if (!materialUnitDAO.checkIfUnitCanBeDeleted(id)) {
                request.getSession().setAttribute("errorMessage", "Không thể xóa đơn vị đang được sử dụng bởi sản phẩm. Vui lòng ngừng hoạt động đơn vị này trước.");
                response.sendRedirect("materialUnit");
                return;
            }
            
            boolean success = materialUnitDAO.deleteMaterialUnit(id);
            
            if (success) {
                request.getSession().setAttribute("successMessage", "Xóa đơn vị thành công!");
            } else {
                request.getSession().setAttribute("errorMessage", "Không thể xóa đơn vị. Vui lòng thử lại.");
            }
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "ID đơn vị không hợp lệ.");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "Có lỗi xảy ra khi xóa đơn vị.");
        }
        
        response.sendRedirect("materialUnit");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}
