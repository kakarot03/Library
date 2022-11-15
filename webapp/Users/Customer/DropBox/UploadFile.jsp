<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Upload File</title>
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
		<div style="position: absolute; top: 5%; left: 45%; color: blue;">
			<h5 id="timer"></h5>
		</div>
		<div id="successMsg" style="display: block; text-align: center; margin-top: 6%"><font color="green" size="4"><%=request.getParameter("msg")%></font><br/>
			<% 
				if(request.getParameter("path") != null) {
			%>
				<div style="margin-left: 43%; margin-top: 2%">
					<font color="green" size="4">
						File Path = <%=request.getParameter("path")%>
					</font>
				</div>
			<%
				}
	} else if(status != null && status.equals("fail")){
		%>
		<div id="errorMsg" style="margin-top: 7%; text-align: center;"><font color="red" size="4"><%=request.getParameter("msg")%></font></div>		
		<%
	}
%>
	</div>
<div class="buttons" style="display: block; position: absolute; width: max-content; top: 7%; left: 70% ">
	<button type="submit" onclick="window.location.href = 'http://localhost:8080/Library/webapp/Users/Customer/DropBox/dropBox.jsp'" class="btn btn-primary mr-4">Home</button>
	<button type="submit" onclick="window.location.href = 'http://localhost:8080/Library/dropBox/logout'" class="btn btn-danger">Logout</button>
</div>
<div class="container"
		style="position: absolute; left: 37%; top: 20%; overflow: hidden;">
		<div id="header1">
			<h1 style="margin-left: 3%;">Upload a new File</h1>
			<h4 style="margin-left: 1%; margin-top: 2%;" id="bookProp1">Or click <a href="#">here</a> to upload your Books</h4>
		</div>
		<div id="header2" style="display: none;">
			<h1 style="margin-left: 2%;">Upload your Books</h1>
			<h4 style="margin-left: 0%; margin-top: 3%;" id="bookProp2">Or click <a href="#">here</a> to upload a new File</h4>
		</div>
		<form action="http://localhost:8080/Library/dropBox/manage" id="uploadForm" method="post" style="display: flex; flex-direction: column; justify-content: center; margin-top: 2%; margin-left: 5.5%;">
			<div class="form-group">
				<div id="input1">
					<label style=" margin-bottom: 5px; margin-top: 2%; margin-left: 8%">File Path</label>
					<input required="required" class="form-control w-25" name="path1" placeholder="Path of the file in Local System">
					<label style=" margin-bottom: 5px; margin-top: 2%; margin-left: 6%">Destionation Path</label> 
					<input required="required" class="form-control w-25" name="path2" placeholder="DropBox destionation path">
				</div>
				<div style="display: none" id="input2">
					<label for="bookElement" style="margin-bottom: 10px; margin-top: 2%; margin-left: 5%">Choose an Operation</label>
					<div class="input-group w-25">
						<select class="custom-select" id="bookProp" name="bookProp">
							<option value="1">Upload All Your Books</option>
							<option value="2">Upload a Specific Book</option>
						</select>
					</div>
					<div id="exp" style="display: none">
						<label for="inputId" style="margin-bottom: 5px; margin-top: 2%; margin-left: 9%;">Book Id</label>
						<input class="form-control w-25" required name="bookId" id="bookId" placeholder="Id">
					</div>
				</div>
			</div>
			<div style="display: none" >
				<input name="action" value="1">
			</div>
            <button type="button" onclick="document.getElementById('uploadForm').submit()" class="btn btn-primary" style="margin-top: 2%; width: 13%; margin-left: 6%;">Submit</button>
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
		if (document.getElementById("errorMsg").style.display == "block") {
			myInterval = setInterval(() => {
			}, 1000);
			setTimeout(() => {
				document.getElementById("errorMsg").innerHTML = "&nbsp;";
				clearInterval(myInterval);
			}, 4000);
		}
	});
	const ele1 = document.getElementById('bookProp1');	
	ele1.addEventListener("click", () => {		
		document.getElementById('input2').style.display = 'block';		
		document.getElementById('input1').style.display = 'none';	
		document.getElementById('header2').style.display = 'block';	
		document.getElementById('header1').style.display = 'none';	
	});	
	const ele2 = document.getElementById('bookProp2');	
	ele2.addEventListener("click", () => {		
		document.getElementById('input2').style.display = 'none';		
		document.getElementById('input1').style.display = 'block';	
		document.getElementById('header2').style.display = 'none';		
		document.getElementById('header1').style.display = 'block';	
	});	
	const ele3 = document.getElementById('bookProp');
		ele3.addEventListener("click", () => {
			if (ele3.value === '2') {
				document.getElementById('exp').style.display = 'block';
			} else {
				document.getElementById('exp').style.display = 'none';
			}
		});	
</script>
</body>
</html>