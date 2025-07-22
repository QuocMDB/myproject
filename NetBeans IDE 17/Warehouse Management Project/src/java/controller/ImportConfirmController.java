//package controller;
//
//import dao.ListRequestImportDAO;
//import java.io.IOException;
//import jakarta.servlet.ServletException;
//import jakarta.servlet.http.HttpServlet;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//import java.util.List;
//import java.sql.SQLException;
//import model.Request;
//import model.RequestItem;
//
//public class ImportConfirmController extends HttpServlet {
//
//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        String requestId = request.getParameter("id");
//        if (requestId == null || requestId.trim().isEmpty()) {
//            System.err.println("Invalid requestId: null or empty");
//            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu mã đơn nhập.");
//            return;
//        }
//
//        ListRequestImportDAO dao = new ListRequestImportDAO();
//        Request req = dao.getRequestById(requestId);
//        List<RequestItem> itemList = dao.getRequestItemsByRequestId(requestId);
//
//        if (req == null) {
//            System.err.println("Request not found for requestId: " + requestId);
//            response.sendRedirect("import?error=request_not_found");
//            return;
//        }
//
//        request.setAttribute("p", req);
//        request.setAttribute("itemList", itemList);
//
//        request.getRequestDispatcher("WarehouseManagement.jsp").forward(request, response);
//    }
//
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        String requestId = request.getParameter("id");
//        String action = request.getParameter("action");
//        String importDate = request.getParameter("importDate");
//        String rejectReason = request.getParameter("rejectReason"); // Thêm dòng này
//
//        // Validate parameters
//        if (requestId == null || requestId.trim().isEmpty()) {
//            System.err.println("Invalid requestId: null or empty");
//            response.sendRedirect("import?error=invalid_data");
//            return;
//        }
//        if (action == null || action.trim().isEmpty()) {
//            System.err.println("Invalid action: null or empty for requestId: " + requestId);
//            response.sendRedirect("import-confirm?id=" + requestId + "&error=invalid_action");
//            return;
//        }
//
//        ListRequestImportDAO dao = new ListRequestImportDAO();
//        List<RequestItem> itemList = dao.getRequestItemsByRequestId(requestId);
//
//        try {
//            if ("confirm".equalsIgnoreCase(action)) {
//                if (importDate == null || importDate.trim().isEmpty()) {
//                    System.err.println("Invalid importDate: null or empty for requestId: " + requestId);
//                    response.sendRedirect("import-confirm?id=" + requestId + "&error=invalid_data");
//                    return;
//                }
//
//                for (RequestItem item : itemList) {
//                    String code = item.getProductCode();
//                    String qtyParam = request.getParameter("importQty_" + code);
//                    String note = request.getParameter("note_" + code);
//
//                    int qty = (qtyParam != null && !qtyParam.trim().isEmpty()) ? Integer.parseInt(qtyParam) : 0;
//                    dao.updateImportItem(requestId, code, qty, note);
//                }
//
//                dao.updateRequestStatus(requestId, "completed", importDate);
//                response.sendRedirect("import?message=approve_success");
//
//            } else if ("reject".equalsIgnoreCase(action)) {
//                // Validate reject reason
//                if (rejectReason == null || rejectReason.trim().isEmpty()) {
//                    System.err.println("Reject reason is required for requestId: " + requestId);
//                    response.sendRedirect("import-confirm?id=" + requestId + "&error=reject_reason_required");
//                    return;
//                }
//                
//                // Cập nhật status thành rejected với lý do
//                dao.updateRequestStatusWithReason(requestId, "rejected", rejectReason.trim());
//                response.sendRedirect("import?message=reject_success");
//                
//            } else {
//                System.err.println("Unknown action: " + action + " for requestId: " + requestId);
//                response.sendRedirect("import-confirm?id=" + requestId + "&error=invalid_action");
//            }
//
//        } catch (SQLException e) {
//            e.printStackTrace();
//            System.err.println("SQLException in doPost for requestId: " + requestId + ", Action: " + action + ", Error: " + e.getMessage());
//            response.sendRedirect("import-confirm?id=" + requestId + "&error=processing_failed");
//        } catch (NumberFormatException e) {
//            e.printStackTrace();
//            System.err.println("NumberFormatException in doPost for requestId: " + requestId + ", Error: " + e.getMessage());
//            response.sendRedirect("import-confirm?id=" + requestId + "&error=invalid_quantity");
//        }
//    }
//
//    @Override
//    public String getServletInfo() {
//        return "ImportConfirmController - xử lý xác nhận hoặc từ chối yêu cầu nhập kho";
//    }
//}
