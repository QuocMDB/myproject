/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package Controllers;

import DAL.DAO_Products;
import Models.CartItem;
import Models.Users;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;

/**
 *
 * @author Fpt
 */
@WebServlet(name = "OrderComplete", urlPatterns = {"/ordercomplete"})
public class OrderComplete extends HttpServlet {
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            LocalDate currentDate = LocalDate.now(); 
            HttpSession session = request.getSession();
            Users u = (Users)session.getAttribute("acc");
            String user_id = u.getUser_id() + "";
            String address = request.getParameter("address");
            String phonenumber = request.getParameter("phonenumber");
            String totalmoney = request.getParameter("totalmoney");
            String date = currentDate.format(DateTimeFormatter.ofPattern("dd/MM/yyyy"));
            List<CartItem> cat = DAO_Products.INSTANCE.loadCartItem(Integer.parseInt(user_id));
            for (CartItem ca : cat) {
                int sold_quantity = ca.getQuantity();
                int id = ca.getProduct_id();
                DAO_Products.INSTANCE.updateProduct(id, sold_quantity);
            }
            DAO_Products.INSTANCE.InsertOrderComplete(Integer.parseInt(user_id), date, address, phonenumber, Double.parseDouble(totalmoney));
            response.sendRedirect("home");
        }
    } 

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    } 

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
