<%@page import="lib.DBOperations" %>
<%@page import="java.sql.ResultSet" %>

<!DOCTYPE html>
<head>
    <title>Super Admin Panel</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.1.3/dist/css/bootstrap.min.css"integrity="sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO" crossorigin="anonymous">
</head>

<%
  response.addHeader("Pragma", "no-cache");
  response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
  response.addHeader("Cache-Control", "pre-check=0, post-check=0");
  response.setDateHeader("Expires", 0);
%>

<body style="overflow: hidden;">
    <div class="container">
        <div class="buttons" style="position: absolute; width: max-content; top: 7%; left: 5% ">
            <button type="submit" class="btn btn-primary mr-3" onclick="window.location.href = 'http://localhost:8080/Library/webapp/Users/SuperAdmin/SuperAdmin.jsp'">Book Section</button>
            <button type="submit" onclick="window.location.href = 'http://localhost:8080/Library/webapp/Users/SuperAdmin/OrderSection.jsp'" class="btn btn-primary">Order Section</button>
        </div>
        <h1 style="text-align: center; margin-top: 5%;">Super Admin Panel</h1>
        <h3 style="text-align: center; margin-top: 7%;">User Section</h3>
        <%
            boolean flag = true;
            try {
            ResultSet rs = DBOperations.allUsers();
        %>
            <div class="buttons" style="position: absolute; width: max-content; top: 7%; left: 75% ">
                <button type="submit" class="btn btn-success mr-3" onclick="window.location.href = 'http://localhost:8080/Library/webapp/UserOperations/AddUser.jsp'">Add User</button>
                <button type="submit" onclick="window.location.href = 'http://localhost:8080/Library/logout1'" class="btn btn-danger">Logout</button>
            </div>
            <table class="table table-striped" style="position: absolute; width: 50%; margin-top: 2%; left: 25%">
                <thead class="thead-dark" style="text-align: center;">
                    <tr>
                        <th scope="col">User Id</th>
                        <th scope="col">Username</th>
                        <th scope="col">Role</th>
                        <th scope="col">Action</th>
                    </tr>
                </thead>
                <tbody style="text-align: center;">
                    <tr>
                        <%
                        while (rs.next()) {
                            if (flag)
                                flag = !flag;
                        %>
                        <td scope="row" id="bookListId"><%=rs.getInt(1)%></td>
                        <td scope="row"><%=rs.getString(2)%></td>
                        <td scope="row"><%=rs.getString(3)%></td>
                        <td scope="row">
                            <a href="http://localhost:8080/Library/webapp/UserOperations/DeleteUser.jsp?id=<%=rs.getInt(1)%>" class="btn btn-danger btn-sm">Delete</a>
                        </td>
                    </tr>	
                <%
                    }
                    if (flag) {
                    %>
                        <h4 style="position: absolute; margin-top: 15%; color: red; left: 46%">No Users!</h4>
                    <%
                    }
                %>
                </tbody>
            </table>
            <%
            } catch (Exception e) {
                e.printStackTrace();
            }
            %>
    </div>
</body>

</html>