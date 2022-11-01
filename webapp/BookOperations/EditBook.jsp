<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Edit Book</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.1.3/dist/css/bootstrap.min.css" integrity="sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO" crossorigin="anonymous">
</head>
<body style="overflow: hidden;">
	<%
	response.addHeader("Pragma", "no-cache");
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.addHeader("Cache-Control", "pre-check=0, post-check=0");
    response.setDateHeader("Expires", 0);
	String msg = request.getParameter("msg");
	if (msg != null && msg.equals("success")) {
	%>
	<h5 style="position: absolute; top: 8%; left: 44%; color: blue;">Redirecting...</h5>
	<div id="successMsg" style="display: block; margin-left: 41%; margin-top: 9%">
		<font color="green" size="4">Book Updated Successfully</font>
		<!-- <div class="buttons" style="position: absolute; width: max-content; top: 7%; left: 67% ">
			<button type="submit" onclick="window.location.href = 'http://localhost:8080/Library/webapp/Users/SuperAdmin/SuperAdmin.jsp'" class="btn btn-warning mr-3">View All Books</button>
		</div> -->
	</div>
	<%
	} else if (msg != null && msg.equals("fail")) {
	%>
	<div style="margin-left: 42%; margin-top: 8%">
		<font color="red" size="4">Couldn't update the Book</font>
	</div>
	<%
	} else if (msg != null && msg.equals("invalidId")) {
	%>
	<div style="margin-left: 44%; margin-top: 8%">
		<font color="red" size="4">Book not found</font>
	</div>
	<%
	}
	%>
	<div class="buttons" style="position: absolute; width: max-content; top: 7%; left: 77% ">
		<button type="submit" onclick="window.location.href = 'http://localhost:8080/Library/logout1'" class="btn btn-danger">Logout</button>
	</div>
	<div class="container" style="position: absolute; left: 35%; top: 25%; overflow: hidden;">
		<h1 style="margin-left: 9%;">Edit Book</h1>
		<%
		if (msg == null || (msg != null && !msg.equals("valid"))) {
		%>
		<div id="idForm">
			<form action="http://localhost:8080/Library/webapp/BookOperations/SearchBook.jsp" method="post">
				<label for="inputId" style="margin-bottom: 5px; margin-top: 2%; margin-left: 15%;">Book Id</label> 
				<input class="form-control w-25" name="bookId" id="bookId" placeholder="Id" style="margin-left: 5%">
				<button type="submit" class="btn btn-primary col-xs-1" style="margin-top: 2%; margin-left: 10%; width: 15%">Submit</button>
			</form>
		</div>
		<%
		}
		%>
		<%
		if (msg != null && msg.equals("valid")) {
			int id = Integer.parseInt(request.getParameter("bookId"));
			session.setAttribute("bookId2", id);
		%>
		<form action="http://localhost:8080/Library/webapp/OperationManager.jsp" method="post" id="form"
			style="display: flex; flex-direction: column; justify-content: center; margin-top: 2%; margin-left: 5.5%;">
			<div class="form-group">
				<label for="bookElement" style="margin-bottom: 5px; margin-top: 2%; margin-left: 8%">Book Property</label>
				<div class="input-group w-25">
					<select class="custom-select" id="bookProp" name="bookProp">
						<option value="1">Name</option>
						<option value="2">Author</option>
						<option value="3">Category</option>
						<option value="4">Price</option>
					</select>
				</div>
				<div class="form-group" id='inputVal'>
					<label style="margin-bottom: 5px; margin-top: 2%; margin-left: 10%">Value</label>
					<input class="form-control w-25" id="value" name="userInput" placeholder="Value">
				</div>
				<div id='catForm' style="display: none">
					<label for="exampleInputEmail1" style="margin-bottom: 5px; margin-top: 2%;; margin-left: 8%">Book Category</label>
					<div class="input-group w-25">
						<select class="custom-select" id="inputGroupSelect04" name="bookCat">
							<option value="1">History</option>
							<option value="5">Literature</option>
							<option value="2">Biography</option>
							<option value="3">Medical</option>
							<option value="4">Comic</option>
						</select>
					</div>
				</div>
			</div>
			<button type="submit" class="btn btn-primary w-25 col-xs-1" style="margin-top: 2%;">Submit</button>
			<div style="display: none">
				<input name="operation" value="2">
			</div>
		</form>
		<%
		}
		%>
	</div>
	<script>
		const ele = document.getElementById('bookProp');
		const ele2 = document.getElementById('bookId');
		ele?.addEventListener("click", () => {
			if(ele.value === '3') {
				document.getElementById('catForm').style.display = 'block';
				document.getElementById('inputVal').style.display = 'none';
			} else {
				document.getElementById('catForm').style.display = 'none';
				document.getElementById('inputVal').style.display = 'block';
			}
		});
		window.addEventListener('load', () => {
			if (document.getElementById("successMsg").style.display == "block") {
				setTimeout(() => {
					window.location.href = 'http://localhost:8080/Library/webapp/Users/SuperAdmin/SuperAdmin.jsp';
				}, 1500);
			}
		});
	</script>
</body>
</html>