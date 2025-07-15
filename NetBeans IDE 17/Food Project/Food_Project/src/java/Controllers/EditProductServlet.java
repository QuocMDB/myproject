/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package Controllers;

import DAL.DAO_Products;
import Models.*;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;

/**
 *
 * @author Fpt
 */
@WebServlet(name="EditProductServlet", urlPatterns={"/editproduct"})
public class EditProductServlet extends HttpServlet {
   
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
            out.println("<title>Servlet EditProductServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet EditProductServlet at " + request.getContextPath () + "</h1>");
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
        int id = Integer.parseInt(request.getParameter("product"));
        int cat = Integer.parseInt(request.getParameter("category"));  
        String str1 = "where product_id = " + id;
        String str2 = "where category_id = " + cat;
        List<Categories> cate = DAO_Products.INSTANCE.loadCategory("");
        List<Categories> rela = DAO_Products.INSTANCE.loadCategory(str2);
        List<Products> prd = DAO_Products.INSTANCE.loadProduct(str1);
        request.setAttribute("prd", prd);
        request.setAttribute("rela", rela);
        request.setAttribute("cate", cate);
        List<ReviewsUser> rew = DAO_Products.INSTANCE.loadAllReviews(id);
        request.setAttribute("rew", rew);
        request.setAttribute("category_id", cat);
        request.getRequestDispatcher("EditProduct.jsp").forward(request, response);
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
        int id = Integer.parseInt(request.getParameter("product"));
        int cat = Integer.parseInt(request.getParameter("category"));  
        String str1 = "where product_id = " + id;
        String str2 = "where category_id = " + cat;
        List<Categories> cate = DAO_Products.INSTANCE.loadCategory("");
        List<Categories> rela = DAO_Products.INSTANCE.loadCategory(str2);
        List<Products> prd = DAO_Products.INSTANCE.loadProduct(str1);
        request.setAttribute("prd", prd);
        request.setAttribute("rela", rela);
        request.setAttribute("cate", cate);
        List<ReviewsUser> rew = DAO_Products.INSTANCE.loadAllReviews(id);
        request.setAttribute("rew", rew);
        request.setAttribute("category_id", cat);
        request.getRequestDispatcher("EditProduct.jsp").forward(request, response);
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
