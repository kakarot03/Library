<%@page import="java.sql.ResultSet"%>
<%@page import="lib.DBOperations"%>
<%@page import="lib.Book" %>
<%@page import="java.util.*"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.1.3/dist/css/bootstrap.min.css" integrity="sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO" crossorigin="anonymous">
</head>
</head>
<body>
	<%
	String str = request.getParameter("operation");
	int op = str != null ? Integer.parseInt(str) : (int)session.getAttribute("opn");
	Object ob = session.getAttribute("cus");
	int cuId = ob == null ? -1 : (int) ob; 

	switch (op) {
	case 1:
		String name = request.getParameter("bookName"), auth = request.getParameter("bookAuthor");
		int cat = Integer.parseInt(request.getParameter("bookCat"));
		float price = Float.parseFloat(request.getParameter("bookPrice"));
		try {
			DBOperations.newBook(name, auth, cat, price);
			int temp = DBOperations.lastBookId();
			response.sendRedirect("http://localhost:8080/Library/webapp/BookOperations/AddBook.jsp?msg=success&bId=" + temp);
		} catch (Exception e) {
			response.sendRedirect("http://localhost:8080/Library/webapp/BookOperations/AddBook.jsp?msg=fail");
			e.printStackTrace();
		}
		break;

	case 2:
		int ch = Integer.parseInt(request.getParameter("bookProp"));
		int id = (int) (session.getAttribute("bookId2"));
		name = request.getParameter("userInput");
		String bCat = request.getParameter("bookCat");
		try {
			Book b = DBOperations.fetchBook(id);
			if (ch == 1 || ch == 2 || ch == 4) {
				DBOperations.editBook(b, ch, name);
			} else {
				DBOperations.editBook(b, ch, bCat);
			}
			response.sendRedirect("http://localhost:8080/Library/webapp/BookOperations/EditBook.jsp?msg=success");
		} catch (Exception e) {
			response.sendRedirect("http://localhost:8080/Library/webapp/BookOperations/EditBook.jsp?msg=fail");
			e.printStackTrace();
		}
		break;

	case 3:
		id = Integer.parseInt(request.getParameter("bookId"));
		try {
			Book b = DBOperations.fetchBook(id);
			if (b == null) {
				response.sendRedirect("http://localhost:8080/Library/webapp/BookOperations/DeleteBook.jsp?msg=invalidId");
			} else {
				response.sendRedirect("http://localhost:8080/Library/webapp/BookOperations/DeleteBook.jsp?msg=success");
			}
		} catch (Exception e) {
			response.sendRedirect("DeleteBook.jsp?msg=fail");
			e.printStackTrace();
		}
		DBOperations.deleteBook(id);
		break;

	case 4:
		ResultSet rs;
		boolean flag = true;
		ch = Integer.parseInt(request.getParameter("bookProp"));
		try {
			if (ch == 1 || ch == 2) {
				name = request.getParameter("userInput");
				rs = DBOperations.searchBook(ch, name, "");
			} else if (ch == 3) {
				bCat = request.getParameter("bookCat");
				rs = DBOperations.searchBook(ch, bCat, "");
			} else {
				String p1 = request.getParameter("price1");
				String p2 = request.getParameter("price2");
				rs = DBOperations.searchBook(ch, p1, p2);
			}
	%>
	<div class="buttons" style="position: absolute; width: max-content; top: 7%; left: 77% ">
		<button type="submit" class="btn btn-info mr-3" onclick="window.location.href = 'http://localhost:8080/Library/userLogin'">Home</button>
		<button type="submit" onclick="window.location.href = 'http://localhost:8080/Library/logout'" class="btn btn-danger">Logout</button>
	</div>
	<table class="table table-striped w-50" style="position: absolute; margin-top: 10%; left: 24%">
		<thead class="thead-dark">
			<tr>
				<th scope="col">Book Id</th>
				<th scope="col">Book Name</th>
				<th scope="col">Book Author</th>
				<th scope="col">Book Category</th>
				<th scope="col">Book Price</th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<%
				while (rs.next()) {
					if (flag)
						flag = !flag;
				%>
				<td scope="row"><%=rs.getString(1)%></td>
				<td scope="row"><%=rs.getString(2)%></td>
				<td scope="row"><%=rs.getString(3)%></td>
				<td scope="row"><%=rs.getString(4)%></td>
				<td scope="row"><%=rs.getFloat(5)%></td>
			</tr>
				<%
				}
				if (flag) {
				%>
					<h4 style="position: absolute; margin-top: 23%; color: red; left: 46%">No Books Found!</h4>
				<%
				}
				%>
		</tbody>
	</table>
	<%
	} catch (Exception e) {
		e.printStackTrace();
	}
	break;

	case 5:
		ch = Integer.parseInt(request.getParameter("bookProp"));
		try {
			if (ch == 1) {
				DBOperations.exportAllBooks();
				response.sendRedirect("http://localhost:8080/Library/webapp/ExportOperations/Export.jsp?msg=success");
			} else {
				id = Integer.parseInt(request.getParameter("bookId"));
				Book b = DBOperations.fetchBook(id);
				if (b == null) {
					response.sendRedirect("http://localhost:8080/Library/webapp/ExportOperations/Export.jsp?msg=invalidId");
				} else {
					DBOperations.exportBook(b);
					response.sendRedirect("http://localhost:8080/Library/webapp/ExportOperations/Export.jsp?msg=success");
				}
			}
		} catch (Exception e) {
			response.sendRedirect("http://localhost:8080/Library/webapp/ExportOperations/Export.jsp?msg=fail");
			e.printStackTrace();
		}
		break;

	case 6:
		ch = Integer.parseInt(request.getParameter("bookProp"));
		try {
			if (ch == 1) {
				DBOperations.deleteAllExport();
				response.sendRedirect("http://localhost:8080/Library/webapp/ExportOperations/DeleteExport.jsp?msg=success");
			} else {
				id = Integer.parseInt(request.getParameter("bookId"));
				Book b = DBOperations.fetchBook(id);
				if (b == null) {
					response.sendRedirect("http://localhost:8080/Library/webapp/ExportOperations/DeleteExport.jsp?msg=invalidId");
				} else {
					DBOperations.deleteExport(id);
					response.sendRedirect("http://localhost:8080/Library/webapp/ExportOperations/DeleteExport.jsp?msg=success");
				}
			}
		} catch (Exception e) {
			response.sendRedirect("http://localhost:8080/Library/webapp/ExportOperations/DeleteExport.jsp?msg=fail");
			e.printStackTrace();
		}
		break;

	case 7:
		try {
			if(!DBOperations.validatePassword(request.getParameter("password")) && request.getParameter("role").equals("customer")) {
				response.sendRedirect("http://localhost:8080/Library/webapp/UserOperations/AddUser.jsp?msg=fail&pass=err");
			} else {
				DBOperations.addUser(request.getParameter("uName"), request.getParameter("password"), request.getParameter("role"));
				int cId = DBOperations.lastUserId();
				response.sendRedirect("http://localhost:8080/Library/webapp/UserOperations/AddUser.jsp?msg=success&cId=" + cId);
			}
		} catch (Exception e) {
			response.sendRedirect("http://localhost:8080/Library/webapp/UserOperations/AddUser.jsp?msg=fail&pass=succ");
			e.printStackTrace();
		}
		break;

	case 8:
		try {
			str = request.getParameter("custId");
			id = str == null ? -1 : Integer.parseInt(str);
			if (DBOperations.findUser(id)) {
				DBOperations.deleteUser(id);
				response.sendRedirect("http://localhost:8080/Library/webapp/UserOperations/DeleteUser.jsp?msg=success");
			} else {
				response.sendRedirect("http://localhost:8080/Library/webapp/UserOperations/DeleteUser.jsp?msg=invalidId");
			}
		} catch (Exception e) {
			response.sendRedirect("http://localhost:8080/Library/webapp/UserOperations/DeleteUser.jsp?msg=fail");
			e.printStackTrace();
		}
		break;

	case 9:
		try {
			int bId = Integer.parseInt(request.getParameter("bookId")),
			cId = Integer.parseInt(request.getParameter("custId"));
			String d1 = request.getParameter("oDate"), d2 = request.getParameter("rDate");
			Book b = DBOperations.fetchBook(bId);
			if (b == null) {
				response.sendRedirect("http://localhost:8080/Library/webapp/OrderOperations/OrderBook.jsp?msg=invalidBookId");
			} else if (!DBOperations.findUser(cId)) {
				response.sendRedirect("http://localhost:8080/Library/webapp/OrderOperations/OrderBook.jsp?msg=invalidCustId");
			} else if (DBOperations.isValidDate(d1, d2)) {
				response.sendRedirect("http://localhost:8080/Library/webapp/OrderOperations/OrderBook.jsp?msg=invalidDate");
			} else {
				DBOperations.orderBook(bId, cId, d1, d2);
				response.sendRedirect("http://localhost:8080/Library/webapp/OrderOperations/OrderBook.jsp?msg=success");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		break;

	case 10:
		flag = true;
		try {
			String time = request.getParameter("time"), date = request.getParameter("date");
			rs = DBOperations.filterDate(date, Integer.parseInt(time));
	%>
	<div class="buttons" style="position: absolute; width: max-content; top: 7%; left: 77% ">
		<button type="submit" class="btn btn-info mr-3" onclick="window.location.href = 'http://localhost:8080/Library/userLogin'">Home</button>
		<button type="submit" onclick="window.location.href = 'http://localhost:8080/Library/logout'" class="btn btn-danger">Logout</button>
	</div>
	<table class="table table-striped" style="position: absolute; margin-top: 10%; width: 75%;  margin-left: 12%">
		<thead class="thead-dark">
			<tr>
				<th scope="col">Book Id</th>
				<th scope="col">Customer Id</th>
				<th scope="col">Customer Name</th>
				<th scope="col">Book Name</th>
				<th scope="col">Book Author</th>
				<th scope="col">Book Category</th>
				<th scope="col">Book Price</th>
				<th scope="col">Order Date</th>
				<th scope="col">Return Date</th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<%
				while (rs.next()) {
					if (flag)
						flag = !flag;
				%>
				<td scope="row"><%=rs.getInt(1)%></td>
				<td scope="row"><%=rs.getInt(2)%></td>
				<td scope="row"><%=rs.getString(3)%></td>
				<td scope="row"><%=rs.getString(4)%></td>
				<td scope="row"><%=rs.getString(5)%></td>
				<td scope="row"><%=rs.getString(6)%></td>
				<td scope="row"><%=rs.getFloat(7)%></td>
				<td scope="row"><%=rs.getDate(8)%></td>
				<td scope="row"><%=rs.getDate(9)%></td>
			</tr>
				<%
				}
				if (flag) {
				%>
					<h4 style="position: absolute; margin-top: 20%; color: red; left: 42%">No Orders matching the details</h4>
				<%
				}
				%>
		</tbody>
	</table>
	<%
	} catch (Exception e) {
		e.printStackTrace();
	}
	break;
	
	case 11:
		flag = true;
		try {
			rs = DBOperations.allOrders(cuId);
	%>
	<div class="buttons" style="position: absolute; width: max-content; top: 7%; left: 77% ">
		<button type="submit" class="btn btn-info mr-3" onclick="window.location.href = 'http://localhost:8080/Library/userLogin'">Home</button>
		<button type="submit" onclick="window.location.href = 'http://localhost:8080/Library/logout'" class="btn btn-danger">Logout</button>
	</div>
	<table class="table table-striped" style="position: absolute; margin-top: 10%; width: 80%;  margin-left: -4%">
		<thead class="thead-dark">
			<tr>
				<th scope="col">Book Id</th>
				<th scope="col">Customer Id</th>
				<th scope="col">Customer Name</th>
				<th scope="col">Book Name</th>
				<th scope="col">Book Author</th>
				<th scope="col">Book Category</th>
				<th scope="col">Book Price</th>
				<th scope="col">Order Date</th>
				<th scope="col">Return Date</th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<%
				while (rs.next()) {
					if (flag)
						flag = !flag;
				%>
				<td scope="row"><%=rs.getInt(1)%></td>
				<td scope="row"><%=rs.getInt(2)%></td>
				<td scope="row"><%=rs.getString(3)%></td>
				<td scope="row"><%=rs.getString(4)%></td>
				<td scope="row"><%=rs.getString(5)%></td>
				<td scope="row"><%=rs.getString(6)%></td>
				<td scope="row"><%=rs.getFloat(7)%></td>
				<td scope="row"><%=rs.getDate(8)%></td>
				<td scope="row"><%=rs.getDate(9)%></td>
			</tr>
				<%
				}
				if (flag) {
				%>
					<h4 style="position: absolute; margin-top: 23%; color: red; left: 46%">No Orders!</h4>
				<%
				}
				%>
		</tbody>
	</table>
	<%
	} catch (Exception e) {
		e.printStackTrace();
	}
	break;
	}
	%>
</body>
</html>