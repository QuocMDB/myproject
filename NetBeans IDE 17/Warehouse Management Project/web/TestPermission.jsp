<%-- 
    Document   : TestPermission
    Created on : 2 thg 7, 2025, 16:44:08
    Author     : phucn
--%>

<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<!DOCTYPE html>
<html>
<head>
    <title>Test Permission</title>
</head>
<body>
    <h2>Test Quyền Người Dùng Trong Session</h2>
    <%
        Object perms = session.getAttribute("userPermissions");
        out.println("<p>userPermissions trong session: " + perms + "</p>");
    %>
</body>
</html>

