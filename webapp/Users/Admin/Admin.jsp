<%@page import="lib.DBOperations" %>
<%@page import="java.sql.ResultSet" %>

<!DOCTYPE html>
<head>
    <title>Admin Panel</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.1.3/dist/css/bootstrap.min.css"integrity="sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO" crossorigin="anonymous">
</head>

<%
  response.addHeader("Pragma", "no-cache");
  response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
  response.addHeader("Cache-Control", "pre-check=0, post-check=0");
  response.setDateHeader("Expires", 0);
  String name = request.getRemoteUser();
%>

<body style="overflow: hidden;">
    <div class="container">
        <div class="buttons" style="position: absolute; width: max-content; top: 7%; left: 5% ">
            <button type="submit" class="btn btn-primary mr-3" onclick="window.location.href = 'http://localhost:8080/Library/webapp/Users/Admin/UserSection.jsp'">User Section</button>
            <button type="submit" onclick="window.location.href = 'http://localhost:8080/Library/webapp/Users/Admin/OrderSection.jsp'" class="btn btn-primary">Order Section</button>
            <button type="submit" onclick="window.location.href = 'http://localhost:8080/Library/webapp/BookOperations/FilterBooks.jsp'" class="btn btn-primary ml-3">Search Book</button>
        </div>
        <h1 style="text-align: center; margin-top: 5%;">Admin Panel</h1>
        <h6 style="text-align: center;">(<%=DBOperations.titleCase(name)%>)</h6>
        <h3 style="text-align: center; margin-top: 5%;">Book Section</h3>
        <%
            boolean flag = true;
            session.setAttribute("cust", session.getAttribute("custId"));
            try {
                ResultSet rs = DBOperations.displayAllBooks();
        %>
            <div class="buttons" style="position: absolute; width: max-content; top: 7%; left: 80% ">
                <button type="submit" onclick="logoutHandle()" class="btn btn-danger">Logout</button>
            </div>
            <table class="table table-striped" style="position: absolute; width: 65%; margin-top: 2%; left: 17%">
                <thead class="thead-dark" style="text-align: center;">
                    <tr>
                        <th scope="col">Book Id</th>
                        <th scope="col">Book Name</th>
                        <th scope="col">Book Author</th>
                        <th scope="col">Book Category</th>
                        <th scope="col">Book Price</th>
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
                        <td scope="row"><%=rs.getString(4)%></td>
                        <td scope="row"><%=rs.getFloat(5)%></td>
                    </tr>	
                <%
                    }
                    if (flag) {
                    %>
                        <h4 style="position: absolute; margin-top: 15%; color: red; left: 46%">No Books!</h4>
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
    <script>
        const logoutHandle = () => {
            window.location.href = 'http://localhost:8080/Library/logout1'
        }
    </script>
</body>
</html>