<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Add Book</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.1.3/dist/css/bootstrap.min.css" integrity="sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO" crossorigin="anonymous">
</head>
<body style="overflow: hidden">
<%
    response.addHeader("Pragma", "no-cache");
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.addHeader("Cache-Control", "pre-check=0, post-check=0");
    response.setDateHeader("Expires", 0);
	String msg = request.getParameter("msg");
	if(msg != null && msg.equals("success")) {
		%>
		<div style="position: absolute; top: 5%; left: 44%; color: blue;">
			<h5 id="timer"></h5>
		</div>
		<div id="successMsg" style="display: block; margin-left: 43%; margin-top: 6%"><font color="green" size="4">Book Added Successfully</font><br/>
		<font color="green" size="4" style="margin-top: 2%" >Book Id : <%=request.getParameter("bId") %></font></div>
		<%
	} else if(msg != null && msg.equals("fail")){
		%>
		<div style="margin-left: 52%; margin-top: 8%"><font color="red" size="4">Couldn't add the Book</font></div>
		<%
	}
%>
<div class="buttons" style="position: absolute; width: max-content; top: 7%; left: 77% ">
	<button type="submit" onclick="window.location.href = 'http://localhost:8080/Library/logout1'" class="btn btn-danger">Logout</button>
</div>
<div class="container"
		style="position: absolute; left: 36%; top: 20%; overflow: hidden;">
		<h1 style="margin-left: 6%;">Add new Book</h1>
		<form action="http://localhost:8080/Library/webapp/OperationManager.jsp" method="post" style="display: flex; flex-direction: column; justify-content: center; margin-top: 2%; margin-left: 5.5%;">
			<div class="form-group">
				<label for="exampleInputEmail1" style=" margin-bottom: 5px; margin-top: 2%; margin-left: 8%">Book Name</label>
				<input required="required" class="form-control w-25" id="exampleInputEmail1" name="bookName" placeholder="Name">
				<label for="exampleInputEmail1" style=" margin-bottom: 5px; margin-top: 2%; margin-left: 8%">Book Author</label> 
				<input required="required" class="form-control w-25" id="exampleInputEmail1" name="bookAuthor" placeholder="Author">
				<label for="exampleInputEmail1" style=" margin-bottom: 5px; margin-top: 2%; margin-left: 8%">Book Category</label> 
				<div class="input-group w-25">
		                	<select class="custom-select" id="inputGroupSelect04" name="bookCat">
		                    		<option value="1">History</option>
				                 <option value="5">Literature</option>
				                 <option value="2">Biography</option>
				                 <option value="3">Medical</option>
		        		         <option value="4">Comic</option>
		                	</select>
            			</div>
				<label for="exampleInputEmail1" style=" margin-bottom: 5px; margin-top: 2%; margin-left: 8%">Book Price</label> 
				<input required="required" class="form-control w-25" id="exampleInputEmail1" name="bookPrice" placeholder="Price">
			</div>
			<button type="submit" class="btn btn-primary" style="margin-top: 2%; width: 13%; margin-left: 6%;">Submit</button>
			<div style="display: none">
				<input name="operation" value="1">
			</div>
		</form>
</div>
<script>
	document.addEventListener('DOMContentLoaded', () => {
		let num = 3, myInterval;
		if(document.getElementById("successMsg").style.display == "block") {
			myInterval = setInterval(() => {
				document.getElementById("timer").innerHTML = "Redirecting in " + num-- + "...";
			}, 1000);
			setTimeout(() => {
				window.location.href = 'http://localhost:8080/Library/webapp/Users/SuperAdmin/SuperAdmin.jsp';
				clearInterval(myInterval);
			}, 4000);
		}
	});
	
</script>
</body>
</html>