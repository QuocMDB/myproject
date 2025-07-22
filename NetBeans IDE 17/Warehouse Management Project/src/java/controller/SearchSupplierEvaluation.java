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
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;
import model.Supplier;
import model.SupplierEvaluation;

/**
 *
 * @author Fpt06
 */
@WebServlet(name = "SearchSupplierEvaluation", urlPatterns = {"/SearchSupplierEvaluation"})
public class SearchSupplierEvaluation extends HttpServlet {

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
            out.println("<title>Servlet SearchSupplierEvaluation</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet SearchSupplierEvaluation at " + request.getContextPath() + "</h1>");
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
        String filter = request.getParameter("fl");
        String sid = request.getParameter("sid");
        String name = request.getParameter("name");
        String indexPage = request.getParameter("index");
        try {
            int id = Integer.parseInt(sid);
            SupplierDAO sd = new SupplierDAO();
            Supplier s = sd.getSupplierByID(id);
            //supplier
            request.setAttribute("supplier", s);
            //fl
            request.setAttribute("fl", filter);
            SupplierEvaluationDAO sed = new SupplierEvaluationDAO();
            List<SupplierEvaluation> list = sed.getSupplierEvaluationByID(id);
            //avg
            float avg_rate = 0;
            for (int i = 0; i < list.size(); i++) {
                avg_rate += list.get(i).getAvgRate();
            }
            avg_rate = avg_rate / list.size();
            String avg = String.valueOf(avg_rate);
            avg = avg.substring(0, 3);
            request.setAttribute("avg", avg);
            //list
            List<SupplierEvaluation> list2 = list.stream().
                    filter((c) -> c.getUserID().getFullname().toLowerCase().contains(name.toLowerCase())).
                    collect(Collectors.toList());
            if (filter.matches("star")) {
                list2.sort(Comparator.comparing(SupplierEvaluation::getAvgRate).reversed());
                
                //phan trang
                int totalPage = (int) Math.ceil((double) list2.size() / 5);
                request.setAttribute("totalPage", totalPage);
                int index = Integer.parseInt(indexPage);
                if (index < totalPage) {
                    list2 = list2.subList((index - 1) * 5, (index - 1) * 5 + 5);
                } else {
                    list2 = list2.subList((index - 1) * 5, list2.size());
                }
                request.setAttribute("index", index);
                request.setAttribute("listSED", list2);
                //
                request.setAttribute("name", name);
                request.setAttribute("isFilter", "search");
                request.getRequestDispatcher("ViewSupplierEvaluation.jsp").forward(request, response);
            } else {
                list2.sort(Comparator.comparing(SupplierEvaluation::getCommentTime).reversed());
                request.setAttribute("listSED", list2);
                
                //phan trang
                int totalPage = (int) Math.ceil((double) list2.size() / 5);
                request.setAttribute("totalPage", totalPage);
                int index = Integer.parseInt(indexPage);
                if (index < totalPage) {
                    list2 = list2.subList((index - 1) * 5, (index - 1) * 5 + 5);
                } else {
                    list2 = list2.subList((index - 1) * 5, list2.size());
                }
                request.setAttribute("index", index);
                request.setAttribute("listSED", list2);
                //
                request.setAttribute("name", name);
                request.setAttribute("isFilter", "search");
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
