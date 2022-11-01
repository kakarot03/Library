<%@page import="lib.DBOperations" %>
<%@page import="java.sql.ResultSet" %>
<%@page import="java.io.*" %>
<%@page import="java.util.*" %>
<%@ page import="io.asgardeo.java.saml.sdk.bean.LoggedInSessionBean" %>
<%@ page import="io.asgardeo.java.saml.sdk.util.SSOAgentConstants" %>
<%@ page import="java.util.Map" %>

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

  LoggedInSessionBean sessionBean = (LoggedInSessionBean) session.getAttribute(SSOAgentConstants.SESSION_BEAN_NAME);
  String user = sessionBean != null ? sessionBean.getSAML2SSO().getSubjectId() : "customer", name = "";
  Map<String, String> saml2SSOAttributes = null;
  if(sessionBean != null) {
	 saml2SSOAttributes = sessionBean.getSAML2SSO().getSubjectAttributes();
     user = saml2SSOAttributes.get("http://wso2.org/claims/emailaddress");
     user = DBOperations.titleCase(user).split("@")[0];
     name = saml2SSOAttributes.get("http://wso2.org/claims/givenname");
     name = name == null ? user : name;
     DBOperations.addUserIfNotExists(user.toLowerCase(), saml2SSOAttributes.get("http://wso2.org/claims/password"));
  } else {
    response.sendRedirect("http://localhost:8080/Library/webapp/UserPanel.jsp");
  }
  
  //user = sessionBean != null ? sessionBean.getSAML2SSO().getSubjectId() : "customer";

%>

<body style="overflow: hidden;">
    <div class="container">
        <div class="buttons" style="position: absolute; width: max-content; top: 7%; left: 15% ">
            <button type="submit" onclick="window.location.href = 'http://localhost:8080/Library/webapp/BookOperations/FilterBooks.jsp'" class="btn btn-primary ml-3">Search Book</button>
        </div>
        <h1 style="text-align: center; margin-top: 5%;">Customer Panel</h1>
        <h4 style="text-align: center; margin-top: 7%;">Welcome <%=DBOperations.titleCase(name)%>, Here's your previous Order(s)</h4>
        <%            
            boolean flag = true;
            int custId = DBOperations.getUserId(user);
		    try {
			    ResultSet rs = DBOperations.allOrders(custId);
            %>
            <div class="buttons" style="position: absolute; width: max-content; top: 7%; left: 77% ">
                <button type="submit" onclick="window.location.href = 'http://localhost:8080/Library/logout'" class="btn btn-danger">Logout</button>
            </div>
            <table class="table table-striped" style="position: absolute; width: 80%; margin-top: 4%; margin-left: -4%">
                <thead class="thead-dark">
                    <tr>
                        <th scope="col">Book Id</th>
                        <th scope="col">Customer Id</th>
                        <th scope="col">Customer Name</th>
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
                        <%
                        while (rs.next()) {
                            if (flag)
                                flag = !flag;
                        %>
                        <td scope="row"><%=rs.getInt(1)%></td>
                        <td scope="row"><%=rs.getInt(2)%></td>
                        <td scope="row"><%=rs.getString(3)%></td>
                        <td scope="row"><%=rs.getString(4)%></td>
                        <td scope="row"><%=rs.getString(5)%></td>
                        <td scope="row"><%=rs.getString(6)%></td>
                        <td scope="row"><%=rs.getFloat(7)%></td>
                        <td scope="row"><%=rs.getDate(8)%></td>
                        <td scope="row"><%=rs.getDate(9)%></td>
                    </tr>
                        <%
                        }
                        if (flag) {
                        %>
                            <h5 style="position: absolute; margin-top: 13%; color: red; left: 43%">Oops, there are No Orders!</h5>
                        <%
                        }
                        %>
                </tbody>
            </table>
            <!-- <div class="content">
                <ta>
                <%
                    if ((saml2SSOAttributes == null || saml2SSOAttributes.isEmpty()) ||
                    (saml2SSOAttributes.size() == 1 && saml2SSOAttributes.containsKey("isk"))) {
                %>
                    <span>There are no user attributes selected to the application at the moment.</span>
                <%
                    } else {
                %>
                    <table>
                        <tr>
                            <th>User attribute name</th>
                            <th>Value</th>
                        </tr>
                <%
                        for (Map.Entry<String, String> entry : saml2SSOAttributes.entrySet()) {
                            if (entry.getKey().equals("isk")) {
                                continue;
                            }
                %>
                        <tr>
                            <td><%=entry.getKey()%></td>
                            <td><%=entry.getValue()%></td>
                        </tr>
                <%
                        }
                %>
                    </table>
                <%
                    }
                %>
                </div> -->
            <%
            } catch (Exception e) {
                e.printStackTrace();
            }
            %>
    </div>
</body>
</html>