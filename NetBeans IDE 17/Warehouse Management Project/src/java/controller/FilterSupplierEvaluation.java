/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.SupplierDAO;
import dao.SupplierEvaluationDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Supplier;
import model.SupplierEvaluation;

/**
 *
 * @author Fpt06
 */
@WebServlet(name = "FilterSupplierEvaluation", urlPatterns = {"/FilterSupplierEvaluation"})
public class FilterSupplierEvaluation extends HttpServlet {

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
            out.println("<title>Servlet FilterSupplierEvaluation</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet FilterSupplierEvaluation at " + request.getContextPath() + "</h1>");
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
        String filter = request.getParameter("filter");
        String sid = request.getParameter("sid");
        String indexPage = request.getParameter("index");
        try {
            int id = Integer.parseInt(sid);
            SupplierDAO sd = new SupplierDAO();
            Supplier s = sd.getSupplierByID(id);
            request.setAttribute("supplier", s);

            if (filter.matches("star")) {
                SupplierEvaluationDAO sed = new SupplierEvaluationDAO();
                List<SupplierEvaluation> list = sed.sortDescendingByStar(id);
                request.setAttribute("fl", filter);
                float avg_rate = 0;
                for (int i = 0; i < list.size(); i++) {
                    avg_rate += list.get(i).getAvgRate();
                }
                avg_rate = avg_rate / list.size();
                String avg = String.valueOf(avg_rate);
                avg = avg.substring(0, 3);
                
                //phan trang
                int totalPage = (int) Math.ceil((double) list.size() / 5);
                request.setAttribute("totalPage", totalPage);
                int index = Integer.parseInt(indexPage);
                if (index < totalPage) {
                    list = list.subList((index - 1) * 5, (index - 1) * 5 + 5);
                } else {
                    list = list.subList((index - 1) * 5, list.size());
                }
                request.setAttribute("index", index);
                request.setAttribute("listSED", list);
                //
                request.setAttribute("isFilter", "filter");
                request.setAttribute("avg", avg);
                request.getRequestDispatcher("ViewSupplierEvaluation.jsp").forward(request, response);

            } else {
                SupplierEvaluationDAO sed = new SupplierEvaluationDAO();
                List<SupplierEvaluation> list = sed.sortDescendingByDate(id);                            
                request.setAttribute("fl", filter);
                float avg_rate = 0;
                for (int i = 0; i < list.size(); i++) {
                    avg_rate += list.get(i).getAvgRate();
                }
                avg_rate = avg_rate / list.size();
                String avg = String.valueOf(avg_rate);
                avg = avg.substring(0, 3);
                
                //phan trang
                int totalPage = (int) Math.ceil((double) list.size() / 5);
                request.setAttribute("totalPage", totalPage);
                int index = Integer.parseInt(indexPage);
                if (index < totalPage) {
                    list = list.subList((index - 1) * 5, (index - 1) * 5 + 5);
                } else {
                    list = list.subList((index - 1) * 5, list.size());
                }
                request.setAttribute("index", index);
                request.setAttribute("listSED", list);
                //
                request.setAttribute("isFilter", "filter");
                request.setAttribute("avg", avg);
                request.getRequestDispatcher("ViewSupplierEvaluation.jsp").forward(request, response);

            }

        } catch (NumberFormatException e) {
        }
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
