<%@page import="lib.DBOperations"%>
<%@page import="java.sql.ResultSet"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Orders</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.1.3/dist/css/bootstrap.min.css" integrity="sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO" crossorigin="anonymous">
</head>
<body>
	<%
	boolean flag = true;
	try {
		ResultSet rs = DBOperations.allOrders(0);
	%>
	<div class="buttons" style="position: absolute; width: max-content; top: 7%; left: 82% ">
		<button type="submit" class="btn btn-info mr-3" onclick="window.location.href = 'http://localhost:8080/Library/userLogin'">Home</button>
		<button type="submit" onclick="window.location.href = 'http://localhost:8080/Library/logout1'" class="btn btn-danger">Logout</button>
	</div>
	<table class="table table-striped w-50" style="position: absolute; margin-top: 10%; left: 24%">
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
	%>
</body>
</html>