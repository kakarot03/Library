<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.1.3/dist/css/bootstrap.min.css" integrity="sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO" crossorigin="anonymous">
</head>
<body>
	<div class="buttons" style="position: absolute; width: max-content; top: 7%; left: 77% ">
		<button type="submit" class="btn btn-info mr-3" onclick="window.location.href = 'http://localhost:8080/Library/userLogin'">Home</button>
		<button type="submit" onclick="window.location.href = 'http://localhost:8080/Library/logout1'" class="btn btn-danger">Logout</button>
	</div>
	<form action="http://localhost:8080/Library/webapp/OperationManager.jsp" method="post" style="margin-top: 13%; margin-left: 42%;">
		<%
		response.addHeader("Pragma", "no-cache");
		response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
		response.addHeader("Cache-Control", "pre-check=0, post-check=0");
		response.setDateHeader("Expires", 0);		
		String msg = request.getParameter("msg");
		if (msg != null && msg.equals("success")) {
		%>
		<div style="margin-bottom: 3%">
			<font color="green" size="4">Export Deleted Successfully</font>
		</div>
		<%
		} else if (msg != null && msg.equals("invalidId")) {
		%>
		<div style="margin-bottom: 3%; margin-left: 5%">
			<font color="red" size="4">Book not found</font>
		</div>
		<%
		}
		%>
		<h1 style="margin-left: -1%;">Delete Exports</h1>
		<label for="bookElement" style="margin-bottom: 10px; margin-top: 2%; margin-left: 4%">Choose an Operation</label>
		<div class="input-group w-25">
			<select class="custom-select" id="bookProp" name="bookProp">
				<option value="1">Delete All Exports</option>
				<option value="2">Delete Specific Export</option>
			</select>
		</div>
		<div id="exp" style="display: none">
			<label for="inputId" style="margin-bottom: 5px; margin-top: 2%; margin-left: 9%;">Book Id</label> 
			<input class="form-control w-25" name="bookId" id="bookId" placeholder="Id">
		</div>
		<button type="submit" class="btn btn-primary col-xs-1" style="margin-top: 3%; margin-left: 5%; width: 15%">Delete Export</button>
		<div style="display: none">
			<input name="operation" value="6">
		</div>
	</form>
	<script>
		const ele = document.getElementById('bookProp');
		ele.addEventListener("click", () => {
			if(ele.value === '2') {
				document.getElementById('exp').style.display = 'block';
			} else {
				document.getElementById('exp').style.display = 'none';
			}
		});
		console.log(document.getElementById('value').value);
	</script>
</body>
</html>