<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Danh Sách Sản Phẩm Đã Xóa</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: #f5f7fa; }
        .container { display: flex; min-height: 100vh; }
        .main-content { flex: 1; padding: 30px; background: #f5f7fa; }
        h1 { color: black; margin-bottom: 20px; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { padding: 12px 10px; border-bottom: 1px solid #eee; text-align: left; }
        th { background: #f8d7da; color: #721c24; }
        tr:last-child td { border-bottom: none; }
        .btn-recover { background: #ffc107; color: #333; padding: 8px 16px; border-radius: 4px; text-decoration: none; font-weight: 500; transition: background 0.2s; }
        .btn-recover:hover { background: #ffb300; color: #222; }
        .back-btn { display: inline-block; background: #667eea; color: white; padding: 10px 20px; border-radius: 5px; text-decoration: none; margin-bottom: 20px; }
        .back-btn:hover { background: #5a67d8; }
        .no-data { text-align: center; color: #888; margin: 40px 0; }
    </style>
</head>
<body>
<div class="container">
    <jsp:include page="/include/sidebar.jsp" />
    <div class="main-content">
        <a href="product-list" class="back-btn">← Quay lại danh sách sản phẩm</a>
        <h1>🗑️ Sản Phẩm Đã Xóa</h1>
        <c:choose>
            <c:when test="${empty deletedProducts}">
                <div class="no-data">Không có sản phẩm nào đã bị xóa.</div>
            </c:when>
            <c:otherwise>
                <table>
                    <thead>
                        <tr>
                            <th>Mã sản phẩm</th>
                            <th>Tên sản phẩm</th>
                            <th>Danh mục</th>

                            <th>Trạng thái</th>
                            <th>Khôi phục</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="product" items="${deletedProducts}">
                            <tr>
                                <td>${product.code}</td>
                                <td>${product.name}</td>
                                <td>${product.cate_id}</td>

                                <td><span style="color: #dc3545; font-weight: bold;">Đã xóa</span></td>
                                <td>
                                    <a href="recover-product?id=${product.id}" class="btn-recover">♻️ Khôi phục</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:otherwise>
        </c:choose>
    </div>
</div>
</body>
</html> 