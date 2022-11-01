<%@page import="lib.DBOperations"%>
<%@page import="lib.Book" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Search Book</title>
</head>
<body>
	<%
	int id = Integer.parseInt(request.getParameter("bookId"));
	try {
		Book b = DBOperations.fetchBook(id);
		if(b == null) {
			response.sendRedirect("EditBook.jsp?msg=invalidId");
		} else {
			response.sendRedirect("EditBook.jsp?msg=valid&bookId=" + id);
		}
	} catch (Exception e) {
		e.printStackTrace();
	}
	%>
</body>
</html>