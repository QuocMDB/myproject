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
import model.Supplier;

/**
 *
 * @author Fpt06
 */
@WebServlet(name = "TableSupplierEvaluation", urlPatterns = {"/TableSupplierEvaluation"})
public class TableSupplierEvaluation extends HttpServlet {

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
            out.println("<title>Servlet TableSupplierEvaluation</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet TableSupplierEvaluation at " + request.getContextPath() + "</h1>");
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
        String id_raw = request.getParameter("id");
        String seid_raw = request.getParameter("seid");
        if (seid_raw != null) {
            try {
                int id = Integer.parseInt(id_raw);
                int seid = Integer.parseInt(seid_raw);
                SupplierDAO sd = new SupplierDAO();
                Supplier s = sd.getSupplierByID(id);
                request.setAttribute("seid", seid);
                request.setAttribute("supplier", s);
                request.getRequestDispatcher("SupplierEvaluation.jsp").forward(request, response);
            } catch (NumberFormatException e) {
            }
        } else {
            try {
                int id = Integer.parseInt(id_raw);
                SupplierDAO sd = new SupplierDAO();
                Supplier s = sd.getSupplierByID(id);
                request.setAttribute("supplier", s);
                request.getRequestDispatcher("SupplierEvaluation.jsp").forward(request, response);
            } catch (NumberFormatException e) {
            }
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
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        String seid_raw = request.getParameter("seid");
        String sid_raw = request.getParameter("supplier");
        String dt_raw = request.getParameter("delivery_time");
        String mpc_raw = request.getParameter("market_price_comparison");
        String tr_raw = request.getParameter("transparency_reputation");
        String sq_raw = request.getParameter("service_quality");
        String comment = request.getParameter("comment");
        String uid_raw = request.getParameter("uid");
        int sid = Integer.parseInt(sid_raw);
        SupplierDAO sd = new SupplierDAO();
        Supplier s = sd.getSupplierByID(sid);
        request.setAttribute("supplier", s);
        if (seid_raw != null && seid_raw.length()>0) {
            try {
                int seid = Integer.parseInt(seid_raw);
                int dt = Integer.parseInt(dt_raw);
                int mpc = Integer.parseInt(mpc_raw);
                int tr = Integer.parseInt(tr_raw);
                int sq = Integer.parseInt(sq_raw);
                SupplierEvaluationDAO sed = new SupplierEvaluationDAO();
                sed.UpdateSupplierEvaluation(dt, mpc, tr, sq, comment, seid);
                request.setAttribute("mess", "Update Succesful");
                request.getRequestDispatcher("SupplierEvaluation.jsp").forward(request, response);
            } catch (NumberFormatException e) {

                request.setAttribute("mess", "error");
                request.getRequestDispatcher("SupplierEvaluation.jsp").forward(request, response);
            }
        } else {
            try {

                int dq = Integer.parseInt(dt_raw);
                int mpc = Integer.parseInt(mpc_raw);
                int tr = Integer.parseInt(tr_raw);
                int sq = Integer.parseInt(sq_raw);
                int uid = Integer.parseInt(uid_raw);
                SupplierEvaluationDAO sed = new SupplierEvaluationDAO();
                sed.evaluation(sid, uid, dq, 0, mpc, tr, sq, comment);

                request.setAttribute("mess", "successful supplier evaluation");
                request.getRequestDispatcher("SupplierEvaluation.jsp").forward(request, response);
            } catch (NumberFormatException e) {

                request.setAttribute("mess", "error");
                request.getRequestDispatcher("SupplierEvaluation.jsp").forward(request, response);
            }
        }

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
