<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Download File</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.1.3/dist/css/bootstrap.min.css" integrity="sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO" crossorigin="anonymous">
</head>
<body style="overflow: hidden">
<%
	if(request.getSession().getAttribute("accessToken") == null) {
		response.sendRedirect("http://localhost:8080/Library/dropBox/authStart");
		request.getSession().setAttribute("requestedURI",request.getRequestURI());
		return;
	}
    response.addHeader("Pragma", "no-cache");
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.addHeader("Cache-Control", "pre-check=0, post-check=0");
    response.setDateHeader("Expires", 0);
	String status = request.getParameter("status");
	if(status != null && status.equals("success")) {
			%>
		<div style="position: absolute; top: 5%; left: 44%; color: blue;">
			<h5 id="timer"></h5>
		</div>
		<div id="successMsg" style="display: block; margin-left: 42%; margin-top: 6%"><font color="green" size="4">File Downloaded Successfully</font><br/>
		<%
	} else if(status != null && status.equals("fail")){
		%>
		<div style="margin-left: 43%; margin-top: 5%"><font color="red" size="4"><%=request.getParameter("msg")%></font></div>
		<%
	}
%>
<div class="buttons" style="position: absolute; width: max-content; top: 7%; left: 72% ">
	<button type="submit" onclick="window.location.href = 'http://localhost:8080/Library/webapp/Users/Customer/DropBox/dropBox.jsp'" class="btn btn-warning mr-3">Home</button>
	<button type="submit" onclick="window.location.href = 'http://localhost:8080/Library/dropBox/logout'" class="btn btn-danger">Logout</button>
</div>
<div class="container"
		style="position: absolute; left: 37%; top: 20%; overflow: hidden;">
		<h1 style="margin-left: 6%;">Download File</h1>
		<form action="http://localhost:8080/Library/dropBox/manage" method="post" style="display: flex; flex-direction: column; justify-content: center; margin-top: 2%; margin-left: 5.5%;">
			<div class="form-group">
				<label style=" margin-bottom: 5px; margin-top: 2%; margin-left: 9%">File Path</label>
				<input required="required" class="form-control w-25" name="path1" placeholder="Path of the file in DropBox">
				<label style=" margin-bottom: 5px; margin-top: 2%; margin-left: 7%">Destionation Path</label>
				<input required="required" class="form-control w-25" name="path2" placeholder="Path to store the File">
			</div>
			<div style="display: none">
				<input name="action" value="3">
			</div>
            <button type="submit" class="btn btn-primary" style="margin-top: 2%; width: 13%; margin-left: 6%;">Download</button>
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
				window.location.href = 'http://localhost:8080/Library/webapp/Users/Customer/DropBox/dropBox.jsp';
				clearInterval(myInterval);
			}, 4000);
		}
	});
	
</script>
</body>
</html>