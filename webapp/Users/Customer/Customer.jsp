<%@page import="lib.DBOperations" %>
    <%@page import="java.sql.ResultSet" %>

        <!DOCTYPE html>

        <head>
            <title>Customer Panel</title>
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.1.3/dist/css/bootstrap.min.css"
                integrity="sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO"
                crossorigin="anonymous">
        </head>

        <% response.addHeader("Pragma", "no-cache" );
            response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate" );
            response.addHeader("Cache-Control", "pre-check=0, post-check=0" ); response.setDateHeader("Expires", 0);
            String user=(String)request.getSession().getAttribute("user"); %>

            <body style="overflow: hidden;">
                <div class="container">
                    <div class="buttons" style="position: absolute; width: max-content; top: 7%; left: 9% ">
                        <button type="submit"
                            onclick="window.location.href = 'http://localhost:8080/Library/webapp/BookOperations/FilterBook.jsp'"
                            class="btn btn-info ml-3">Search Book</button>
                        <button type="submit"
                            onclick="window.location.href = 'http://localhost:8080/Library/dropBox/authStart'"
                            class="btn btn-primary ml-3">DropBox</button>
                    </div>
                    <h1 style="text-align: center; margin-top: 5%;">Customer Panel</h1>
                    <% boolean flag=true; int custId=DBOperations.getUserId(user); try { ResultSet
                        rs=DBOperations.allOrders(custId); %>
                        <h5 style="text-align: center; margin-top: 2%;">Customer Id = <%=custId%>
                        </h5>
                        <h4 style="text-align: center; margin-top: 5%;">Welcome <%=DBOperations.titleCase(user)%>,
                                Here's your previous Order(s)</h4>
                        <div class="buttons" style="position: absolute; width: max-content; top: 7%; left: 80% ">
                            <button type="submit"
                                onclick="window.location.href = 'http://localhost:8080/Library/logout1'"
                                class="btn btn-danger">Logout</button>
                        </div>
                        <table class="table table-striped"
                            style="position: absolute; width: 80%; margin-top: 4%; margin-left: -4%">
                            <thead class="thead-dark">
                                <tr>
                                    <th scope="col">Book Id</th>
                                    <th scope="col">Book Name</th>
                                    <th scope="col">Book Author</th>
                                    <th scope="col">Book Category</th>
                                    <th scope="col">Book Price</th>
                                    <th scope="col">Order Date</th>
                                    <th scope="col">Return Date</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <% while (rs.next()) { if (flag) flag=!flag; %>
                                        <td scope="row">
                                            <%=rs.getInt(1)%>
                                        </td>
                                        <td scope="row">
                                            <%=rs.getString(4)%>
                                        </td>
                                        <td scope="row">
                                            <%=rs.getString(5)%>
                                        </td>
                                        <td scope="row">
                                            <%=rs.getString(6)%>
                                        </td>
                                        <td scope="row">
                                            <%=rs.getFloat(7)%>
                                        </td>
                                        <td scope="row">
                                            <%=rs.getDate(8)%>
                                        </td>
                                        <td scope="row">
                                            <%=rs.getDate(9)%>
                                        </td>
                                </tr>
                                <% } if (flag) { %>
                                    <h5 style="position: absolute; margin-top: 13%; color: red; left: 43%">Oops, there
                                        are No Orders!</h5>
                                    <% } %>
                            </tbody>
                        </table>
                        <% } catch (Exception e) { e.printStackTrace(); } %>
                </div>
            </body>

            </html>