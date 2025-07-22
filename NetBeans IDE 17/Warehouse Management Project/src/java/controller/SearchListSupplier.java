/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.SupplierDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import model.Supplier;

/**
 *
 * @author Fpt06
 */
@WebServlet(name = "SearchListSupplier", urlPatterns = {"/SearchListSupplier"})
public class SearchListSupplier extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
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
            out.println("<title>Servlet SearchListSupplier</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet SearchListSupplier at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String status = request.getParameter("status");
        String name = request.getParameter("name");
        String line = request.getParameter("line");
        if(name==null){
            name = "";
        }
        SupplierDAO sd = new SupplierDAO();
        String pageRaw = request.getParameter("page");
        int pageIndex = 1;
        int pageSize = Integer.parseInt(line);

        if (pageRaw != null) {
            try {
                pageIndex = Integer.parseInt(pageRaw);
            } catch (NumberFormatException e) {
                pageIndex = 1;
            }
        }

        int totalSuppliers = sd.countTotalSuppliersFilter(status, name);
        int totalPages = (int) Math.ceil((double) totalSuppliers / pageSize);

        List<Supplier> listSupplier = sd.getSuppliersByPageFilter(pageIndex, pageSize,status,name);
        request.setAttribute("filter", "option");
        request.setAttribute("status", status);
        request.setAttribute("name", name);
        request.setAttribute("line", line);
        request.setAttribute("listSupplier", listSupplier);
        request.setAttribute("currentPage", pageIndex);
        request.setAttribute("totalPages", totalPages);

        request.getRequestDispatcher("LishSupplier.jsp").forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
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
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
