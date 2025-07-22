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

public class ActivateMaterialUnitServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private MaterialUnitDAO materialUnitDAO;
    
    public void init() {
        materialUnitDAO = new MaterialUnitDAO();
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            boolean success = materialUnitDAO.activateMaterialUnit(id);
            
            if (success) {
                request.getSession().setAttribute("successMessage", "Kích hoạt đơn vị thành công!");
            } else {
                request.getSession().setAttribute("errorMessage", "Không thể kích hoạt đơn vị. Vui lòng thử lại.");
            }
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "ID đơn vị không hợp lệ.");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "Có lỗi xảy ra khi kích hoạt đơn vị.");
        }
        
        response.sendRedirect("materialUnit");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}
