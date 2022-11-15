<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Search Book</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.1.3/dist/css/bootstrap.min.css" integrity="sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO" crossorigin="anonymous">
</head>
<body style="overflow: hidden;">
	<%
	response.addHeader("Pragma", "no-cache");
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.addHeader("Cache-Control", "pre-check=0, post-check=0");
    response.setDateHeader("Expires", 0);
	String msg = request.getParameter("msg");
	String user = (String)request.getSession().getAttribute("user");
	if (msg != null && msg.equals("success")) {
	%>
	<div style="margin-left: 7%;">
		<font color="green" size="4">Book(s) Found</font>
	</div>
	<%
	} else if (msg != null && msg.equals("fail")) {
	%>
	<div style="margin-left: 11%;">
		<font color="red" size="4">Couldn't complete the search</font>
	</div>
	<%
	} else if (msg != null && msg.equals("invalidId")) {
	%>
	<div style="margin-left: 11%;">
		<font color="red" size="4">Book not found</font>
	</div>
	<%
	}
	%>
	<div class="buttons" style="position: absolute; width: max-content; top: 7%; left: 77% ">
		<button type="submit" onclick="window.location.href = 'http://localhost:8080/Library/userLogin'" class="btn btn-info mr-3">Home</button>
		<button type="submit" onclick="window.location.href = 'http://localhost:8080/Library/logout1'" class="btn btn-danger">Logout</button>
	</div>
	<div id="idForm" style="margin-top: 18%; margin-left: 38%; overflow: hidden;">
		<div class="container" style="position: absolute; left: 35%; top: 20%; overflow: hidden;">
			<h1 style="margin-left: 8%;">Search Book</h1>
			<form action="http://localhost:8080/Library/webapp/OperationManager.jsp" method="post" id="form" style="display: flex; flex-direction: column; justify-content: center; margin-top: 2%; margin-left: 5.5%;">
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
					<div class="form-group" id='inputVal2' style="display: none">
						<label style="margin-bottom: 5px; margin-top: 2%; margin-left: 10%">Min. Price</label>
						<input class="form-control w-25" id="value2" name="price1" type="number" placeholder="Minimum Price"> 
						<label style="margin-bottom: 5px; margin-top: 2%; margin-left: 10%">Max. Price</label>
						<input class="form-control w-25" id="value2" name="price2" type="number" placeholder="Maximum Price">
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
					<input name="operation" value="4">
				</div>
			</form>
		</div>
	</div>
	<script>
		const ele = document.getElementById('bookProp');
		const ele2 = document.getElementById('bookId');
		ele.addEventListener("click", () => {
			if(ele.value === '3') {
				document.getElementById('catForm').style.display = 'block';
				document.getElementById('inputVal').style.display = 'none';
				document.getElementById('inputVal2').style.display = 'none';
			} else if(ele.value === '4') {
				document.getElementById('catForm').style.display = 'none';
				document.getElementById('inputVal').style.display = 'none';
				document.getElementById('inputVal2').style.display = 'block';
			} else {
				document.getElementById('catForm').style.display = 'none';
				document.getElementById('inputVal').style.display = 'block';
				document.getElementById('inputVal2').style.display = 'none';

			}
		});
		console.log(document.getElementById('value').value);
	</script>
	<style>
		input::-webkit-outer-spin-button,
		input::-webkit-inner-spin-button {
			-webkit-appearance: none;
			margin: 0;
		}
	</style>
</body>
</html>