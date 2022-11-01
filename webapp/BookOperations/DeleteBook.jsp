<%@page import="lib.DBOperations" %>
<!DOCTYPE html>
<html>
<head>
<title>Search Book</title>
</head>

<body>
    <% 
    int id = Integer.parseInt(request.getParameter("id"));
	try {
		DBOperations.deleteBook(id);
        response.sendRedirect("http://localhost:8080/Library/webapp/Users/SuperAdmin/SuperAdmin.jsp");
	} catch (Exception e) {
		e.printStackTrace();
	}
	%>
</body>
</html>