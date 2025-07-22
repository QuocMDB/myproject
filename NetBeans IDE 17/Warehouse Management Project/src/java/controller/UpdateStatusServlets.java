/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author tunga
 */
import dao.MaterialUnitDAO;

@WebServlet("/updateStatus")
public class UpdateStatusServlets extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private MaterialUnitDAO materialUnitDAO;
    
    public void init() {
        materialUnitDAO = new MaterialUnitDAO();
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            // Lấy id và status từ request
            int id = Integer.parseInt(request.getParameter("id"));
            String status = request.getParameter("status");
            
            // Cập nhật trạng thái
            boolean updated = materialUnitDAO.updateMaterialUnitStatus(id, status);
            
            // Trả về kết quả
            response.setContentType("text/plain");
            if (updated) {
                response.getWriter().write("success");
            } else {
                response.getWriter().write("failed");
            }
        } catch (Exception e) {
            // Xử lý lỗi
            System.err.println("Error in UpdateStatusServlet.doPost: " + e.getMessage());
            e.printStackTrace();
            response.setContentType("text/plain");
            response.getWriter().write("error: " + e.getMessage());
        }
    }
}