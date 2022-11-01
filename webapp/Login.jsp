<!DOCTYPE html>
<html>
<head>
<title>User Panel</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
</head>
	<body style="overflow: hidden;">
		<div class="container" style="position: absolute; left: 36%; top: 25%">
			<h1 style="margin-left: 9%;">Login Form</h1>
			<form action='j_security_check' autocomplete="off" method="post" style="display: flex; flex-direction: column; justify-content: center; margin-top: 4%;">
                <label style="margin-left: 9%; margin-bottom: 2%;">Login with your credentials</label>
                <div class="form-group col-xs-4">
					<input class="form-control" id="username" name="j_username" required="required" placeholder="Enter your Username" style="margin-bottom: 4%; margin-left: 15%; width: 70%;">
                    <input class="form-control" id="password" name="j_password" type="password" required="required" placeholder="Enter your Password" style=" width: 70%; margin-left: 15%;">
				</div>
				<button type="submit" class="btn btn-primary col-xs-2" style="margin-top: 2%; margin-left: 10.5%; width: 12%;">Submit</button>
			</form>
		</div>
	</body>
</html>