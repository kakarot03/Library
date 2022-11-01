<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Order Book</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.1.3/dist/css/bootstrap.min.css" integrity="sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO" crossorigin="anonymous">
</head>
<body>
	<div id="idForm" style="margin-top: 8%; margin-left: 38%;">
		<%
		response.addHeader("Pragma", "no-cache");
		response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
		response.addHeader("Cache-Control", "pre-check=0, post-check=0");
		response.setDateHeader("Expires", 0);
		String msg = request.getParameter("msg");
		if (msg != null && msg.equals("success")) {
		%>
		<div style="position: absolute; top: 5%; left: 44%; color: blue;">
			<h5 id="timer"></h5>
		</div>
		<div id="successMsg" style="display: block; margin-left: 7%;">
			<font color="green" size="4">Book Ordered Successfully</font>
		</div>
		<%
		} else if (msg != null && msg.equals("fail")) {
		%>
		<div style="margin-left: 11%;">
			<font color="red" size="4">Couldn't order the Book</font>
		</div>
		<%
		} else if (msg != null && msg.equals("invalidBookId")) {
		%>
		<div style="margin-left: 11%;">
			<font color="red" size="4">Book not found</font>
		</div>
		<%
		} else if (msg != null && msg.equals("invalidCustId")) {
			%>
			<div style="margin-left: 9%;">
				<font color="red" size="4">Customer not found</font>
			</div>
			<%
		} else if (msg != null && msg.equals("invalidDate")) {
			%>
			<div>
				<font color="red" size="4">Return Date cannot be before Order Date</font>
			</div>
			<%
		}
		%>
		<div class="buttons" style="position: absolute; width: max-content; top: 7%; left: 77% ">
			<button type="submit" onclick="window.location.href = 'http://localhost:8080/Library/webapp/UserPanel.jsp'" class="btn btn-danger">Logout</button>
		</div>
		<h1 style="margin-left: 6.5%; margin-top: 2%">Order Book</h1>
		<form action="http://localhost:8080/Library/webapp/OperationManager.jsp" method="post">
			<label for="inputId" style="margin-bottom: 5px; margin-top: 2%; margin-left: 15%;">Book Id</label>
			<input required="required" class="form-control w-25" name="bookId" id="bookId" placeholder="Book Id" style="margin-left: 5%">
			<label for="inputId" style="margin-bottom: 5px; margin-top: 2%; margin-left: 15%;">Customer Id</label> 
			<input required="required" class="form-control w-25" name="custId" id="custId" placeholder="Customer Id" style="margin-left: 5%">
			<label for="exampleInputEmail1" style="margin-bottom: 5px; margin-top: 2%;margin-left: 15%">Order Date</label> 
			<input required="required" class="form-control w-25" type="date" id="exampleInputEmail1" name="oDate" placeholder="Date" style="margin-left: 5%">
			<label for="exampleInputEmail1" style="margin-bottom: 5px; margin-top: 2%;margin-left: 15%">Return Date</label> 
			<input required="required" class="form-control w-25" type="date" id="exampleInputEmail1" name="rDate" placeholder="Date" style="margin-left: 5%">
			<button type="submit" class="btn btn-primary col-xs-1" style="margin-top: 4%; margin-left: 10%; width: 15%">Order</button>
			<div style="display: none">
				<input name="operation" value="9">
			</div>
		</form>
	</div>
	<script>
		document.addEventListener('DOMContentLoaded', () => {
			let num = 2, myInterval;
			if (document.getElementById("successMsg").style.display == "block") {
				myInterval = setInterval(() => {
					document.getElementById("timer").innerHTML = "Redirecting in " + num-- + "...";
				}, 1000);
				setTimeout(() => {
					window.location.href = 'http://localhost:8080/Library/webapp/Users/SuperAdmin/OrderSection.jsp';
					clearInterval(myInterval);
				}, 3000);
			}
		});
	</script>
</body>
</html>