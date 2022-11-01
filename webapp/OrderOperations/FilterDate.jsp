<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Filter Orders</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.1.3/dist/css/bootstrap.min.css" integrity="sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO" crossorigin="anonymous">
</head>
<body style="width: 1260px;">
	<%
	response.addHeader("Pragma", "no-cache");
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.addHeader("Cache-Control", "pre-check=0, post-check=0");
    response.setDateHeader("Expires", 0);
	String msg = request.getParameter("msg");
	//System.out.println(request.getSession().getAttribute("currentUser"));
	if (msg != null && msg.equals("success")) {
	%>
	<div style="margin-left: 50%; margin-top: 8%">
		<font color="green" size="4">Success</font>
	</div>
	<%
	} else if (msg != null && msg.equals("fail")) {
	%>
	<div style="margin-left: 52%; margin-top: 8%">
		<font color="red" size="4">Something went wrong</font>
	</div>
	<%
	}
	%>
	<div class="buttons" style="position: absolute; width: max-content; top: 7%; left: 77% ">
		<button type="submit" class="btn btn-info mr-3" onclick="window.location.href = 'http://localhost:8080/Library/userLogin'">Home</button>
		<button type="submit" onclick="window.location.href = 'http://localhost:8080/Library/logout1'" class="btn btn-danger">Logout</button>
	</div>
	<div class="container" style="position: absolute; left: 35%; top: 20%; overflow: hidden;">
		<h1 style="margin-left: 2%;">Filter Orders By Date</h1>
		<form action="http://localhost:8080/Library/webapp/OperationManager.jsp" method="post" style="display: flex; flex-direction: column; justify-content: center; margin-top: 2%; margin-left: 5.5%;">
			<div class="form-group">
				<label for="exampleInputEmail1" style="margin-bottom: 5px; margin-left: 7%">Date Preference</label> <br>
				<select class="custom-select w-25" id="inputGroupSelect04" name="time">
					<option value="1">Before</option>
					<option value="2">After</option>
				</select>
			</div>
			<label for="exampleInputEmail1" style="margin-bottom: 5px; margin-left: 10%">Date</label> 
			<input class="form-control w-25" type="date" id="exampleInputEmail1" name="date" placeholder="Date">
			<button type="submit" class="btn btn-primary col-xs-1" style="margin-top: 2%; margin-left: 5%; width: 15%">Search</button>
			<div style="display: none">
				<input name="operation" value="10">
			</div>
		</form>
	</div>
</body>
</html>