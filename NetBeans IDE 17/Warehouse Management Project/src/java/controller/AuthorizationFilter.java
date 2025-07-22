/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 *
 * @author phucn
 */
public class AuthorizationFilter implements Filter {

    private static final Map<String, String> urlPermissionMap = new HashMap<>();

    static {
        // USERS
        urlPermissionMap.put("/Admin.jsp", "ADMIN");        
        urlPermissionMap.put("/usermanager", "USER_VIEW");
        urlPermissionMap.put("/UserManager.jsp", "USER_VIEW");
        urlPermissionMap.put("/adduser", "USER_ADD");
        urlPermissionMap.put("/AddUser.jsp", "USER_ADD");
        urlPermissionMap.put("/edituser", "USER_EDIT");
        urlPermissionMap.put("/EditUser.jsp", "USER_EDIT");
        urlPermissionMap.put("/role-permission", "ROLE_ASSIGN");
        urlPermissionMap.put("/permission.jsp", "ROLE_ASSIGN");
        urlPermissionMap.put("/profile", "USER_PROFILE");
        urlPermissionMap.put("/Profile.jsp", "USER_PROFILE");
        urlPermissionMap.put("/editprofile", "USER_PROFILE_EDIT");
        urlPermissionMap.put("/EditProfile.jsp", "USER_PROFILE_EDIT");
           
        
        // CATEGORY
        urlPermissionMap.put("/categoriesforward.jsp", "CATEGORYFORWARD");
        urlPermissionMap.put("/category_product/list.jsp", "CATEGORY_LIST");
        urlPermissionMap.put("/category/list", "CATEGORY_LIST");
        urlPermissionMap.put("/category_product/create.jsp", "CATEGORY_ADD");
        urlPermissionMap.put("/category/create", "CATEGORY_ADD");
        urlPermissionMap.put("/category_product/edit.jsp", "CATEGORY_EDIT");
        urlPermissionMap.put("/category/edit", "CATEGORY_EDIT");

        // SUPPLIER
        urlPermissionMap.put("/LishSupplier.jsp", "SUPPLIER_VIEW");
        urlPermissionMap.put("/LishSupplier", "SUPPLIER_VIEW");
        urlPermissionMap.put("/AddNewSupplier.jsp", "SUPPLIER_ADD");
        urlPermissionMap.put("/AddNewSupplier", "SUPPLIER_ADD");
        urlPermissionMap.put("/UpdateSupplier.jsp", "SUPPLIER_EDIT");
        urlPermissionMap.put("/UpdateSupplier", "SUPPLIER_EDIT");
        urlPermissionMap.put("/DeleteSupplier", "SUPPLIER_DELETE");
        
        urlPermissionMap.put("/SupplierEvaluation.jsp", "SUPPLIER_EVALUATE");
        urlPermissionMap.put("/TableSupplierEvaluation", "SUPPLIER_EVALUATE");
        urlPermissionMap.put("/ViewSupplierEvaluation.jsp", "SUPPLIER_EVALUATE_VIEW");
        urlPermissionMap.put("/ViewSupplierEvaluation", "SUPPLIER_EVALUATE_VIEW");
        urlPermissionMap.put("/StatisticSupplierEvaluation.jsp", "SUPPLIER_EVALUATE_STATISTIC");
        urlPermissionMap.put("/StatisticSupplierEvaluation", "SUPPLIER_EVALUATE_STATISTIC");
        
        // DEPARTMENT
        urlPermissionMap.put("/Department_list.jsp", "DEPARTMENT_VIEW");
        urlPermissionMap.put("/department/list", "DEPARTMENT_VIEW");
        urlPermissionMap.put("/Department_create.jsp", "DEPARTMENT_ADD");
        urlPermissionMap.put("/department/create", "DEPARTMENT_ADD");
        urlPermissionMap.put("/Department_edit.jsp", "DEPARTMENT_EDIT");
        urlPermissionMap.put("/department/edit", "DEPARTMENT_EDIT");
        urlPermissionMap.put("/Department_detail.jsp", "DEPARTMENT_DETAIL");
        urlPermissionMap.put("/department/detail", "DEPARTMENT_DETAIL");
        urlPermissionMap.put("/Department_list.jsp", "DEPARTMENT_STATISTIC");
        urlPermissionMap.put("/department/statistics", "DEPARTMENT_STATISTIC");
        
        
        // MATERIAL_UNIT
        urlPermissionMap.put("/material_unit/materialUnit.jsp", "UNIT_VIEW");
        urlPermissionMap.put("/material_unit/materialUnit", "UNIT_VIEW");
        urlPermissionMap.put("/material_unit/createMaterialUnit.jsp", "UNIT_ADD");
        urlPermissionMap.put("/material_unit/createMaterialUnit", "UNIT_ADD");
        urlPermissionMap.put("/material_unit/editMaterialUnit.jsp", "UNIT_EDIT");
        urlPermissionMap.put("/material_unit/editMaterialUnit", "UNIT_EDIT");
        urlPermissionMap.put("/material_unit/deleteMaterialUnit", "UNIT_DELETE");
        urlPermissionMap.put("/material_unit/activateMaterialUnit", "UNIT_EDIT");
        urlPermissionMap.put("/material_unit/deactivateMaterialUnit", "UNIT_EDIT");
        
        
        // PRODUCT
        urlPermissionMap.put("/product-list.jsp", "PRODUCT_VIEW");
        urlPermissionMap.put("/product-list", "PRODUCT_VIEW");
        urlPermissionMap.put("/add-product.jsp", "PRODUCT_ADD");
        urlPermissionMap.put("/add-product", "PRODUCT_ADD");
        urlPermissionMap.put("/update-product.jsp", "PRODUCT_EDIT");
        urlPermissionMap.put("/update-product", "PRODUCT_EDIT");
        urlPermissionMap.put("/deleted-products.jsp", "PRODUCT_DELETE");
        urlPermissionMap.put("/deleted-products", "PRODUCT_DELETE");
        urlPermissionMap.put("/recover-product", "PRODUCT_RECOVER");
        
        
        //REQUEST
        urlPermissionMap.put("/RequestForward.jsp", "REQUEST_PAGE");     
        
        //IMPORT
        urlPermissionMap.put("/ListRequestImport.jsp", "REQUEST_PURCHASE_VIEW");        
        urlPermissionMap.put("/import", "REQUEST_PURCHASE_VIEW");
        urlPermissionMap.put("/ItemsSupplyRequestForm.jsp", "REQUEST_PURCHASE_CREATE");        
        urlPermissionMap.put("/loadingrequest", "REQUEST_PURCHASE_CREATE");

        
//        urlPermissionMap.put("/.jsp", "IMPORT_CONFIRM");
//        urlPermissionMap.put("/", "IMPORT_CONFIRM");
        
        //EXPORT
        urlPermissionMap.put("/ExportRequest.jsp", "EXPORT_CREATE");
        urlPermissionMap.put("/exportRequest", "EXPORT_CREATE");
        
        // QUOTE
        urlPermissionMap.put("/ListPurchaseOrder.jsp", "QUOTE_CREATE");
        urlPermissionMap.put("/listpurchaseorder", "QUOTE_CREATE");


        //APPROVE REQUEST
        urlPermissionMap.put("/passwordrequest", "PASSWORD_RESPONSE");
        urlPermissionMap.put("/password_request.jsp", "PASSWORD_RESPONSE");
        urlPermissionMap.put("/reset_user_password", "PASSWORD_RESET");
        urlPermissionMap.put("/reset_user_password.jsp", "PASSWORD_RESET");
        urlPermissionMap.put("/ApproveListForward.jsp", "REQUEST_RESPONSE_PAGE"); 
        urlPermissionMap.put("/ApprovePurchaseRequest.jsp", "REQUEST_PURCHASE_APPROVE");        
        urlPermissionMap.put("/approvepurchaserequest", "REQUEST_PURCHASE_APPROVE");
        urlPermissionMap.put("/ApprovePurchaseQuoted.jsp", "QUOTE_APPROVE");
        urlPermissionMap.put("/approvepurchasequoted", "QUOTE_APPROVE");
        
        // ... bạn có thể bổ sung các chức năng khác theo docx/database
    }

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;
        HttpSession session = request.getSession(false);

        List<String> userPermissions = null;
        if (session != null) {
            Object permObj = session.getAttribute("userPermissions");
            if (permObj instanceof List<?>) {
                @SuppressWarnings("unchecked")
                List<String> checkedList = (List<String>) permObj;
                userPermissions = checkedList;
            }
        }

        String path = request.getServletPath();
        String permissionRequired = urlPermissionMap.get(path);

        System.out.println("====== AUTH FILTER DEBUG ======");
        System.out.println("Session ID: " + (session != null ? session.getId() : "null"));
        System.out.println("Filter path: " + path);
        System.out.println("permissionRequired: " + permissionRequired);
        System.out.println("userPermissions: " + userPermissions);

        if (permissionRequired == null) {
            System.out.println("WARNING: Chưa mapping quyền cho url: " + path);
        }

        if (permissionRequired != null) {
            if (userPermissions == null || !userPermissions.contains(permissionRequired)) {
                request.setAttribute("deniedFeature", path);
                request.getRequestDispatcher("access-denied.jsp").forward(request, response);
                return;
            }
        }

        chain.doFilter(req, res);
    }

    @Override
    public void init(FilterConfig filterConfig) {
    }

    @Override
    public void destroy() {
    }
}
