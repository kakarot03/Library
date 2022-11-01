<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Library</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.1.3/dist/css/bootstrap.min.css" integrity="sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO" crossorigin="anonymous">
</head>

<% 
	response.addHeader("Pragma", "no-cache");
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.addHeader("Cache-Control", "pre-check=0, post-check=0");
    response.setDateHeader("Expires", 0);
%>

<body style="overflow: hidden;">
	<div class="buttons" style="position: absolute; text-align: center; width: max-content; top: 24%; left: 35% ">
        <h2>User Panel</h2>
        <h5 style="margin-top: 15%; margin-bottom: 15%;">Choose your role and login with your credentials</h5>
        <div>
            <form method="post" action="http://localhost:8080/Library/userLogin">
                <button type="submit" value="superadmin" name="role" onclick="window.location.href = 'http://localhost:8080/Library/webapp/Users/SuperAdmin/SuperAdmin.jsp'" class="btn btn-primary mr-3">SuperAdmin</button>
                <button type="submit" value="admin" name="role" onclick="window.location.href = 'http://localhost:8080/Library/webapp/Users/Admin/Admin.jsp'" class="btn btn-primary mr-3">Admin</button>
                <button type="submit" value="customer" name="role" onclick="window.location.href = 'http://localhost:8080/Library/webapp/Users/Customer/Customer.jsp'" class="btn btn-primary mr-3">Customer</button>
            </form>
        </div>
    </div>  
</body>
</html>