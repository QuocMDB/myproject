package controller;

import dao.GetExportRequestWithItemsDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import model.ExportRequest;
import model.Users; 

/**
 * Servlet xử lý phê duyệt, từ chối yêu cầu xuất kho và lọc danh sách.
 */
@WebServlet(name = "ApproveExportRequestServlet", urlPatterns = {"/approveexportrequest"})
public class ApproveExportRequestServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try {
            GetExportRequestWithItemsDAO dao = new GetExportRequestWithItemsDAO();

            // Lấy tham số lọc từ form
            String startDateStr = request.getParameter("startDate");
            String endDateStr = request.getParameter("endDate");
            String statusFilter = request.getParameter("statusFilter");
            String requestIdFilter = request.getParameter("requestIdFilter");

            // Kiểm tra và làm sạch các tham số rỗng
            if (startDateStr != null && startDateStr.trim().isEmpty()) {
                startDateStr = null;
            }
            if (endDateStr != null && endDateStr.trim().isEmpty()) {
                endDateStr = null;
            }
            if (statusFilter != null && statusFilter.trim().isEmpty()) {
                statusFilter = null;
            }
            if (requestIdFilter != null && requestIdFilter.trim().isEmpty()) {
                requestIdFilter = null;
            }

            // Parse dates
            java.sql.Date startDate = parseDate(startDateStr);
            java.sql.Date endDate = parseDate(endDateStr);

            // Tính tổng số yêu cầu và số trang
            int countPage = dao.getTotalFilteredExportRequests(startDate, endDate, statusFilter, null);
            int endPage = countPage / 10;
            if (countPage % 10 != 0) {
                endPage++;
            }
            if (endPage == 0) {
                endPage = 1; // Đảm bảo có ít nhất 1 trang
            }
            request.setAttribute("endPage", endPage);
            request.setAttribute("totalRequests", countPage);

            // Lấy trang hiện tại
            String indexPage = request.getParameter("index");
            int index = 1; // Mặc định là trang 1
            if (indexPage != null && indexPage.matches("\\d+")) {
                index = Integer.parseInt(indexPage);
            }

            // Lấy danh sách yêu cầu đã lọc
            List<ExportRequest> exportRequests = dao.getFilteredExportRequests(
                startDate, endDate, statusFilter, null, index, 10
            );
            request.setAttribute("pendingExportRequests", exportRequests);

            // Debug info
            System.out.println("=== SERVLET DEBUG ===");
            System.out.println("Total requests: " + countPage);
            System.out.println("Current page: " + index);
            System.out.println("Total pages: " + endPage);
            System.out.println("Found requests: " + exportRequests.size());

            // Chuyển tiếp đến JSP
            request.getRequestDispatcher("ApproveExportRequest.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Đã xảy ra lỗi khi xử lý yêu cầu: " + e.getMessage());
            request.getRequestDispatcher("ApproveExportRequest.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        GetExportRequestWithItemsDAO dao = new GetExportRequestWithItemsDAO();

        try {
            if ("approve".equals(action)) {
                String requestId = request.getParameter("requestId");
                if (requestId != null && !requestId.isEmpty()) {
                    
                    // Lấy thông tin user từ session
                    HttpSession session = request.getSession();
                    Users currentUser = (Users) session.getAttribute("user");
                    
                    if (currentUser == null) {
                        request.setAttribute("errorMessage", "Bạn cần đăng nhập để thực hiện hành động này!");
                        processRequest(request, response);
                        return;
                    }
                    
                    // Phê duyệt yêu cầu
                    boolean isApproved = dao.updateExportRequestStatus(requestId, "approved", currentUser.getId());
                    
                    if (isApproved) {
                        System.out.println("✅ Đã phê duyệt export request: " + requestId + " bởi user: " + currentUser.getFullname());
                        
                        String redirectUrl = buildRedirectUrl(request);
                        response.sendRedirect(redirectUrl + "&message=Đã phê duyệt yêu cầu xuất kho thành công!");
                        return;
                    } else {
                        request.setAttribute("errorMessage", "Không thể phê duyệt yêu cầu. Vui lòng thử lại!");
                    }
                }
            } else if ("reject".equals(action)) {
                String requestId = request.getParameter("requestId");
                if (requestId != null && !requestId.isEmpty()) {
                    
                    // Lấy thông tin user từ session
                    HttpSession session = request.getSession();
                    Users currentUser = (Users) session.getAttribute("user");
                    
                    if (currentUser == null) {
                        request.setAttribute("errorMessage", "Bạn cần đăng nhập để thực hiện hành động này!");
                        processRequest(request, response);
                        return;
                    }
                    
                    // Từ chối yêu cầu
                    boolean isRejected = dao.updateExportRequestStatus(requestId, "rejected", currentUser.getId());
                    
                    if (isRejected) {
                        System.out.println("✅ Đã từ chối export request: " + requestId + " bởi user: " + currentUser.getFullname());
                        String redirectUrl = buildRedirectUrl(request);
                        response.sendRedirect(redirectUrl + "&message=Đã từ chối yêu cầu xuất kho!");
                        return;
                    } else {
                        request.setAttribute("errorMessage", "Không thể từ chối yêu cầu. Vui lòng thử lại!");
                    }
                }
            }

            // Nếu không có action đặc biệt hoặc có lỗi, xử lý như request thông thường
            processRequest(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Đã xảy ra lỗi khi xử lý yêu cầu: " + e.getMessage());
            processRequest(request, response);
        }
    }

    /**
     * Xây dựng URL redirect với các tham số lọc hiện tại
     */
    private String buildRedirectUrl(HttpServletRequest request) {
        StringBuilder url = new StringBuilder("approveexportrequest");
        boolean hasParams = false;

        // Lấy các tham số lọc từ request
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String statusFilter = request.getParameter("statusFilter");
        String requestIdFilter = request.getParameter("requestIdFilter");
        String currentIndex = request.getParameter("index");

        if (startDate != null && !startDate.trim().isEmpty()) {
            url.append(hasParams ? "&" : "?").append("startDate=").append(startDate);
            hasParams = true;
        }

        if (endDate != null && !endDate.trim().isEmpty()) {
            url.append(hasParams ? "&" : "?").append("endDate=").append(endDate);
            hasParams = true;
        }

        if (statusFilter != null && !statusFilter.trim().isEmpty()) {
            url.append(hasParams ? "&" : "?").append("statusFilter=").append(statusFilter);
            hasParams = true;
        }

        if (requestIdFilter != null && !requestIdFilter.trim().isEmpty()) {
            url.append(hasParams ? "&" : "?").append("requestIdFilter=").append(requestIdFilter);
            hasParams = true;
        }

        if (currentIndex != null && !currentIndex.trim().isEmpty()) {
            url.append(hasParams ? "&" : "?").append("index=").append(currentIndex);
            hasParams = true;
        }

        return url.toString();
    }

    /**
     * Helper method to parse date string to SQL Date
     */
    private java.sql.Date parseDate(String dateStr) {
        if (dateStr == null || dateStr.trim().isEmpty()) {
            return null;
        }
        
        try {
            java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");
            java.util.Date utilDate = sdf.parse(dateStr.trim());
            return new java.sql.Date(utilDate.getTime());
        } catch (Exception e) {
            System.err.println("Error parsing date: " + dateStr + " - " + e.getMessage());
            return null;
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet xử lý phê duyệt, từ chối yêu cầu xuất kho và lọc danh sách";
    }
}
