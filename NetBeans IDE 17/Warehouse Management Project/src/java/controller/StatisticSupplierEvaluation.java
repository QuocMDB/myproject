/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.SupplierEvaluationDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;
import model.Supplier;
import model.SupplierEvaluation;

/**
 *
 * @author Fpt06
 */
@WebServlet(name = "StatisticSupplierEvaluation", urlPatterns = {"/StatisticSupplierEvaluation"})
public class StatisticSupplierEvaluation extends HttpServlet {

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
            out.println("<title>Servlet StatisticSupplierEvaluation</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet StatisticSupplierEvaluation at " + request.getContextPath() + "</h1>");
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
        String sort = request.getParameter("sort");
        String top = request.getParameter("top");
        String status = request.getParameter("status");
        SupplierEvaluationDAO sed = new SupplierEvaluationDAO();
        request.setAttribute("sta", status);
        String index_raw = request.getParameter("index");

        int index = 1;
        if (index_raw != null) {
            index = Integer.parseInt(index_raw);
        }
        if (top.equalsIgnoreCase("avg")) {
            List<Supplier> list = sed.staticRated(sort);
            if (status.equalsIgnoreCase("active")) {
                list = list.stream().filter((c) -> c.getActiveFlag() == 1).collect(Collectors.toList());
            } else if (status.equalsIgnoreCase("inactive")) {
                list = list.stream().filter((c) -> c.getActiveFlag() == 0).collect(Collectors.toList());
            }
            //phan trang
            int totalPage = (int) Math.ceil((double) list.size() / 5);
            if (index < totalPage) {
                list = list.subList((index - 1) * 5, index * 5);
            }
            if (index == totalPage) {
                list = list.subList((index - 1) * 5, list.size());
            }
            request.setAttribute("totalPage", totalPage);
            //
            List<Float> listStar = new ArrayList<>();
            List<Integer> listComment = new ArrayList<>();
            for (int i = 0; i < list.size(); i++) {
                List<SupplierEvaluation> lse = sed.getSupplierEvaluationByID(list.get(i).getSupplierID());
                float star = 0;
                for (int j = 0; j < lse.size(); j++) {
                    star = star + lse.get(j).getAvgRate();
                }
                listComment.add(lse.size());
                star = star / lse.size();
                star = Math.round(star * 10) / 10.0f;
                listStar.add(star);
            }
            request.setAttribute("listComment", listComment);
            request.setAttribute("listStar", listStar);
            request.setAttribute("list", list);
            request.setAttribute("fl", top);
            request.setAttribute("st", sort);
            request.setAttribute("mess", "Top-rated Supplier");
            request.getRequestDispatcher("StatisticSupplierEvaluation.jsp").forward(request, response);
        } else if (top.equalsIgnoreCase("expexted")) {

            List<Supplier> list = sed.staticExpectedDelivery(sort);
            if (status.equalsIgnoreCase("active")) {
                list = list.stream().filter((c) -> c.getActiveFlag() == 1).collect(Collectors.toList());
            } else if (status.equalsIgnoreCase("inactive")) {
                list = list.stream().filter((c) -> c.getActiveFlag() == 0).collect(Collectors.toList());
            }
            //phan trang
            int totalPage = (int) Math.ceil((double) list.size() / 5);
            if (index < totalPage) {
                list = list.subList((index - 1) * 5, index * 5);
            }
            if (index == totalPage) {
                list = list.subList((index - 1) * 5, list.size());
            }
            request.setAttribute("totalPage", totalPage);
            //
            List<Float> listStar = new ArrayList<>();
            List<Integer> listComment = new ArrayList<>();
            for (int i = 0; i < list.size(); i++) {
                List<SupplierEvaluation> lse = sed.getSupplierEvaluationByID(list.get(i).getSupplierID());
                float star = 0;
                for (int j = 0; j < lse.size(); j++) {
                    star = star + lse.get(j).getExpectedDeliveryTime();
                }
                listComment.add(lse.size());
                star = star / lse.size();
                star = Math.round(star * 10) / 10.0f;
                listStar.add(star);
            }
            request.setAttribute("listComment", listComment);
            request.setAttribute("listStar", listStar);
            request.setAttribute("list", list);
            request.setAttribute("mess", "Top-rated expected delivery");
            request.setAttribute("fl", top);
            request.setAttribute("st", sort);
            request.getRequestDispatcher("StatisticSupplierEvaluation.jsp").forward(request, response);
        } else {
            List<Supplier> list = sed.staticMarketPrice(sort);
            if (status.equalsIgnoreCase("active")) {
                list = list.stream().filter((c) -> c.getActiveFlag() == 1).collect(Collectors.toList());
            } else if (status.equalsIgnoreCase("inactive")) {
                list = list.stream().filter((c) -> c.getActiveFlag() == 0).collect(Collectors.toList());
            }
            //phan trang
            int totalPage = (int) Math.ceil((double) list.size() / 5);
            if (index < totalPage) {
                list = list.subList((index - 1) * 5, index * 5);
            }
            if (index == totalPage) {
                list = list.subList((index - 1) * 5, list.size());
            }
            request.setAttribute("totalPage", totalPage);
            //
            List<Float> listStar = new ArrayList<>();
            List<Integer> listComment = new ArrayList<>();
            for (int i = 0; i < list.size(); i++) {
                List<SupplierEvaluation> lse = sed.getSupplierEvaluationByID(list.get(i).getSupplierID());
                float star = 0;
                for (int j = 0; j < lse.size(); j++) {
                    star = star + lse.get(j).getMarketPriceComparison();
                }
                listComment.add(lse.size());
                star = star / lse.size();
                star = Math.round(star * 10) / 10.0f;
                listStar.add(star);
            }
            request.setAttribute("listStar", listStar);
            request.setAttribute("listComment", listComment);
            request.setAttribute("mess", "Top-rated market price comparison");
            request.setAttribute("list", list);
            request.setAttribute("fl", top);
            request.setAttribute("st", sort);
            request.getRequestDispatcher("StatisticSupplierEvaluation.jsp").forward(request, response);
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