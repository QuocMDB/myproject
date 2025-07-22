/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import dao.MaterialUnitDAO;
import model.MaterialUnit;

public class MaterialUnitServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private MaterialUnitDAO materialUnitDAO;
    
    public void init() {
        materialUnitDAO = new MaterialUnitDAO();
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }
        System.out.println("Servlet: Handling action=" + action);

        switch (action) {
        case "search":
            searchMaterialUnits(request, response);
            break;
        case "paginate":
            paginateMaterialUnits(request, response);
            break;
        default:
            listMaterialUnits(request, response);
            break;
    }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
    
    // Controller for listing, searching, and paginating material units
    private void listMaterialUnits(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        int page = 1;
        int recordsPerPage = 10; // Increased to 20
        if(request.getParameter("page") != null) {
            page = Integer.parseInt(request.getParameter("page"));
        }
        List<MaterialUnit> materialUnits = materialUnitDAO.getMaterialUnitsWithPaging((page-1)*recordsPerPage, recordsPerPage);
        int totalRecords = materialUnitDAO.getTotalRecords();
        int totalPages = (int) Math.ceil(totalRecords * 1.0 / recordsPerPage);
        request.setAttribute("materialUnits", materialUnits);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        System.out.println("listMaterialUnits: materialUnits size=" + materialUnits.size() + ", page=" + page + ", totalRecords=" + totalRecords + ", totalPages=" + totalPages);
        request.getRequestDispatcher("/material_unit/materialUnit.jsp").forward(request, response);
    }
    private void searchMaterialUnits(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String searchTerm = request.getParameter("searchTerm");
        if (searchTerm == null) {
            searchTerm = "";
        }
        int page = 1;
        int recordsPerPage = 10; // Increased to 20
        if (request.getParameter("page") != null) {
            page = Integer.parseInt(request.getParameter("page"));
        }
        List<MaterialUnit> materialUnits = materialUnitDAO.searchMaterialUnitsWithPaging(
            searchTerm, (page - 1) * recordsPerPage, recordsPerPage
        );
        int totalRecords = materialUnitDAO.getTotalSearchRecords(searchTerm);
        int totalPages = (int) Math.ceil(totalRecords * 1.0 / recordsPerPage);
        request.setAttribute("materialUnits", materialUnits);
        request.setAttribute("searchTerm", searchTerm);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        System.out.println("searchMaterialUnits: materialUnits size=" + materialUnits.size() + ", searchTerm=" + searchTerm + ", page=" + page + ", totalRecords=" + totalRecords + ", totalPages=" + totalPages);
        request.getRequestDispatcher("/material_unit/materialUnit.jsp").forward(request, response);
    }
    private void paginateMaterialUnits(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {
        int page = 1;
        int recordsPerPage = 10; // Increased to 20
        if(request.getParameter("page") != null) {
            page = Integer.parseInt(request.getParameter("page"));
        }
        List<MaterialUnit> materialUnits = materialUnitDAO.getMaterialUnitsWithPaging((page-1)*recordsPerPage, recordsPerPage);
        int totalRecords = materialUnitDAO.getTotalRecords();
        int totalPages = (int) Math.ceil(totalRecords * 1.0 / recordsPerPage);
        request.setAttribute("materialUnits", materialUnits);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("recordsPerPage", recordsPerPage);
        request.setAttribute("paginationMode", true);
        System.out.println("paginateMaterialUnits: materialUnits size=" + materialUnits.size() + ", page=" + page + ", totalRecords=" + totalRecords + ", totalPages=" + totalPages);
        request.getRequestDispatcher("/material_unit/materialUnit.jsp").forward(request, response);
    }
}