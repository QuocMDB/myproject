/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import dao.MaterialUnitDAO;

public class DeactivateMaterialUnitServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private MaterialUnitDAO materialUnitDAO;
    
    public void init() {
        materialUnitDAO = new MaterialUnitDAO();
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String deleteAfter = request.getParameter("deleteAfter");
            boolean shouldDelete = "true".equals(deleteAfter);
            
            boolean success = materialUnitDAO.deactivateMaterialUnit(id);
            
            if (success) {
                if (shouldDelete) {
                    // Try to delete the unit after deactivation
                    boolean deleteSuccess = materialUnitDAO.deleteMaterialUnit(id);
                    if (deleteSuccess) {
                        request.getSession().setAttribute("successMessage", "Đơn vị đã được ngừng hoạt động và xóa thành công!");
                    } else {
                        request.getSession().setAttribute("successMessage", "Đơn vị đã được ngừng hoạt động, nhưng không thể xóa. Có thể đơn vị đang được sử dụng.");
                    }
                } else {
                    request.getSession().setAttribute("successMessage", "Ngừng hoạt động đơn vị thành công!");
                }
            } else {
                request.getSession().setAttribute("errorMessage", "Không thể ngừng hoạt động đơn vị. Vui lòng thử lại.");
            }
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "ID đơn vị không hợp lệ.");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "Có lỗi xảy ra khi ngừng hoạt động đơn vị.");
        }
        
        response.sendRedirect("materialUnit");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}
