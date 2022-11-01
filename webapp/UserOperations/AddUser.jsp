<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Add User</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.1.3/dist/css/bootstrap.min.css" integrity="sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO" crossorigin="anonymous">
</head>
<body style="overflow: hidden">
	<%
	response.addHeader("Pragma", "no-cache");
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.addHeader("Cache-Control", "pre-check=0, post-check=0");
    response.setDateHeader("Expires", 0);
	String msg = request.getParameter("msg"), pass = request.getParameter("pass");
	if (msg != null && msg.equals("success")) {
	%>
	<div style="position: absolute; top: 5%; left: 44%; color: blue;">
		<h5 id="timer"></h5>
	</div>
	<div id="successMsg" style="display: block; margin-left: 42%; margin-top: 8%">
		<font color="green" size="4">User Added Successfully</font><br/>
		<font color="green" size="4" style="margin-top: 2%" >User Id : <%=request.getParameter("cId") %></font>
	</div>
	<%
	} else if (msg != null && msg.equals("fail")) {
		if(pass.equals("succ")) {
	%>
	<div style="margin-left: 43%; margin-top: 8%">
		<font color="red" size="4">Username already exists!</font>
	</div>
	<%
		} else if(pass.equals("err")) {
	%>
	<div style="margin-left: 38%; margin-top: 8%">
		<font color="red" size="4">Password length has to be greater than 4!</font>
	</div>
	<%
		}
	}
	%>
	<div class="buttons" style="position: absolute; width: max-content; top: 7%; left: 75% ">
		<button type="submit" onclick="window.location.href = 'http://localhost:8080/Library/webapp/Users/SuperAdmin/SuperAdmin.jsp'" class="btn btn-primary mr-3">Home</button>
		<button type="submit" onclick="window.location.href = 'http://localhost:8080/Library/logout1'" class="btn btn-danger">Logout</button>
	</div>
	<div class="container" style="position: absolute; left: 35%; top: 22%; overflow: hidden;">
		<h1 style="margin-left: 6%;">Add new User</h1>
		<form action="http://localhost:8080/Library/webapp/OperationManager.jsp" method="post" style="display: flex; flex-direction: column; justify-content: center; margin-top: 2%; margin-left: 5.5%;">
			<div class="form-group">
				<label style="margin-bottom: 5px; margin-top: 2%; margin-left: 9%">UserName</label> 
				<input class="form-control w-25" id="name" name="uName" placeholder="UserName"> 
				<label style="margin-bottom: 5px; margin-top: 2%; margin-left: 9%">Password</label> 
				<input class="form-control w-25" id="password" type="password" name="password" placeholder="Password"> 
				<label style="margin-bottom: 5px; margin-top: 2%; margin-left: 11%">Role</label>
				<div class="input-group w-25">
					<select class="custom-select" id="role" name="role">
						<option value="superadmin">SuperAdmin</option>
						<option value="admin">Admin</option>
						<option value="customer">Customer</option>
					</select>
				</div>
			</div>
			<button onclick="handleSubmit()" class="btn btn-primary col-xs-1" style="margin-top: 2%; margin-left: 5%; width: 15%">Submit</button>
			<div style="display: none">
				<input name="operation" value="7">
			</div>
		</form>
	</div>
	<script>
		window.addEventListener('load', () => {
			let num = 3, myInterval;
			if (document.getElementById("successMsg").style.display == "block") {
				myInterval = setInterval(() => {
					document.getElementById("timer").innerHTML = "Redirecting in " + num-- + "...";
				}, 1000);
				setTimeout(() => {
					window.location.href = 'http://localhost:8080/Library/webapp/Users/SuperAdmin/UserSection.jsp';
					clearInterval(myInterval);
				}, 4000);
			}
		});

		const handleSubmit = () => {
			var url = "https://localhost:9443/scim2/Users";

			var xhr = new XMLHttpRequest();
			xhr.open("POST", url);

			xhr.setRequestHeader("Content-Type", "application/json");
			xhr.setRequestHeader("Authorization", "Basic YWRtaW46YWRtaW4=");
			xhr.setRequestHeader('Access-Control-Allow-Origin', '*');
			xhr.setRequestHeader('Access-Control-Allow-Methods', 'GET,POST,PUT,PATCH,DELETE');
			xhr.setRequestHeader('Access-Control-Allow-Methods', 'Content-Type', 'Authorization');

			var data = "{userName:" + document.getElementById("name").value + ",password:" + document.getElementById("password").value + "}";
			// var data = "{userName:ragnar,password:Vikings@123}";
			if (document.getElementById("role").value === 'customer') {
				xhr.send(data);
				console.log(xhr.responseText);
			}
		}
	</script>
</body>
</html>