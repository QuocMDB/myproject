/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package Controllers;

import DAL.DAO_Products;
import Models.Users;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author Fpt
 */
@WebServlet(name="ChangePassWord", urlPatterns={"/changepassword"})
public class ChangePassWord extends HttpServlet {
   
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
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet ChangePassWord</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ChangePassWord at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
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
        String username = request.getParameter("username");
        String fullname = request.getParameter("fullname");
        String phonenumber = request.getParameter("phonenumber");
        String email = request.getParameter("email");
        String oldpassword = request.getParameter("oldpassword");
        String newpassword = request.getParameter("newpassword");
        Users pass = (Users)DAO_Products.INSTANCE.checkChangePassWord(username, oldpassword, fullname, phonenumber, email);
        String confirmpass = request.getParameter("confirmpass");
        if(confirmpass.equals(newpassword)){
            if(pass == null){
            request.setAttribute("pass", "Wrong Information!");
            request.setAttribute("name",username);
            request.setAttribute("fullname", fullname);
            request.setAttribute("phonenumber", phonenumber);
            request.setAttribute("email", email);
            request.setAttribute("oldpassword", oldpassword);
            request.setAttribute("newpassword", newpassword);
            request.setAttribute("confirmpass", confirmpass);
            request.getRequestDispatcher("changepass").forward(request, response);
        }else {
            // tra ve neu da ton tai
            DAO_Products.INSTANCE.changePassWord(username, newpassword);
            request.setAttribute("pass", "Change complete!");
            request.getRequestDispatcher("changepass").forward(request, response);
            
        }
        }else {
            request.setAttribute("pass", "Wrong Information!");
            request.setAttribute("name",username);
            request.setAttribute("fullname", fullname);
            request.setAttribute("phonenumber", phonenumber);
            request.setAttribute("email", email);
            request.setAttribute("oldpassword", oldpassword);
            request.setAttribute("newpassword", newpassword);
            request.setAttribute("confirmpass", confirmpass);
            request.getRequestDispatcher("changepass").forward(request, response);
        }
        
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
