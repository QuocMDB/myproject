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
import java.util.Comparator;
import java.util.List;
import model.Supplier;
import model.SupplierEvaluation;

/**
 *
 * @author Fpt06
 */
@WebServlet(name = "ViewSupplierEvaluation", urlPatterns = {"/ViewSupplierEvaluation"})
public class ViewSupplierEvaluation extends HttpServlet {

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
            out.println("<title>Servlet ViewSupplierEvaluation</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ViewSupplierEvaluation at " + request.getContextPath() + "</h1>");
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
        String id_raw = request.getParameter("supplierID");
        String indexPage = request.getParameter("index");
        String page = request.getParameter("page");
        if(page!=null && page.length()!=0){
            request.setAttribute("page", "Statistic");
        }
        try {
            int id = Integer.parseInt(id_raw);
            SupplierEvaluationDAO sed = new SupplierEvaluationDAO();
            List<SupplierEvaluation> list = sed.getSupplierEvaluationByID(id);
            float avg_rate = 0;
            for (int i = 0; i < list.size(); i++) {
                avg_rate += list.get(i).getAvgRate();
            }
            avg_rate = avg_rate / list.size();
            String avg = String.valueOf(avg_rate);
            avg = avg.substring(0, 3);
            list.sort(Comparator.comparing(SupplierEvaluation::getAvgRate).reversed());

            request.setAttribute("avg", avg);
            SupplierDAO sd = new SupplierDAO();
            Supplier s = sd.getSupplierByID(id);
            request.setAttribute("supplier", s);

            //phan trang
            int totalPage = (int) Math.ceil((double) list.size() / 5);
            request.setAttribute("totalPage", totalPage);
            if (indexPage != null) {
                int index = Integer.parseInt(indexPage);
                if (index < totalPage) {
                    list = list.subList((index - 1) * 5, (index - 1) * 5 + 5);
                } else {
                    list = list.subList((index - 1) * 5, list.size());
                }
                request.setAttribute("index", index);
                request.setAttribute("listSED", list);
            } else {
                if (list.size() < 5) {
                    request.setAttribute("index", 1);
                    request.setAttribute("listSED", list);
                } else {
                    list = list.subList(0, 5);
                    request.setAttribute("index", 1);
                    request.setAttribute("listSED", list);
                }
            }

            request.getRequestDispatcher("ViewSupplierEvaluation.jsp").forward(request, response);
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
