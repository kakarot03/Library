<%@page import="lib.DBOperations" %>
<%@page import="drop.Main" %>
<%@page import="java.io.*" %>
<%@page import="java.util.*" %>

<!DOCTYPE html>
<head>
    <title>DropBox Panel</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.1.3/dist/css/bootstrap.min.css"integrity="sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO" crossorigin="anonymous">
</head>

<%
  if(request.getSession().getAttribute("accessToken") == null) {
	response.sendRedirect("http://localhost:8080/Library/dropBox/authStart");
    return;
  }
  response.addHeader("Pragma", "no-cache");
  response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
  response.addHeader("Cache-Control", "pre-check=0, post-check=0");
  response.setDateHeader("Expires", 0);
  String name = (String)request.getSession().getAttribute("currentUser");
  name = name == null ? Main.getUserName() : name;
  Main object = new Main();
%>
<body style="overflow: hidden;">
    <%
    String status = request.getParameter("status");
	if(status != null && status.equals("success")) {
		%>
		<div id="successMsg" style="display: block; text-align: center; margin-top: 2%"><font color="green" size="4"><%=request.getParameter("msg")%></font><br/>
		<%
	} else if(status != null && status.equals("fail")){
		%>
		<div style="margin-left: 43%; margin-top: 5%"><font color="red" size="4"><%=request.getParameter("msg")%></font></div>
		<%
	}
    %>
        </div>
    <div class="container">
        <h1 style="text-align: center; margin-top: 3%;">DropBox Panel</h1>
        <h6 style="text-align: center;">(<%=DBOperations.titleCase(name)%>)</h6>
        <h3 style="text-align: center; margin-top: 5%;">Here's your Files List</h3>
        <div class="buttons" style="position: absolute; width: max-content; top: 12%; left: 17% ">
            <button type="submit" class="btn btn-success mr-3"
                onclick="window.location.href = 'http://localhost:8080/Library/webapp/Users/Customer/DropBox/UploadFile.jsp'">Upload File</button>
        </div>
        <div class="buttons" style="position: absolute; width: max-content; top: 12%; left: 77% ">
            <button onclick="window.location.href = 'http://localhost:8080/Library/dropBox/logout'" class="btn btn-danger mr-3">Logout</button>
        </div>
        <%
            boolean flag = true;
            int count = 1;
            try {
            HashMap<String, String> filesList = object.getFilesList();
        %>
            <table class="table table-striped" style="position: absolute; width: 55%; margin-top: 2%; left: 22%">
                <thead class="thead-dark" style="text-align: center;">
                    <tr>
                        <th scope="col">S No.</th>
                        <th scope="col">File Name</th>
                        <th scope="col">Path in DropBox</th>
                        <th scope="col">Action</th>
                    </tr>
                </thead>
                <tbody style="text-align: center;">
                    <tr>
                        <%
                        for (Map.Entry<String, String> entry : filesList.entrySet()) {
                            if (flag)
                                flag = !flag;
                        %>
                        <td scope="row" id="FileId"><%=count++%></td>
                        <td scope="row"><%=entry.getKey()%></td>
                        <td scope="row"><%=entry.getValue()%></td>
                        <td scope="row">
                            <a href="http://localhost:8080/Library/dropBox/manage?action=1&file=<%=entry.getValue()%>"
                                class="btn btn-info btn-sm">Download</a>&nbsp;
                            <a href="http://localhost:8080/Library/dropBox/manage?action=2&file=<%=entry.getValue()%>"
                                class="btn btn-danger btn-sm">Delete</a>
                        </td>
                    </tr>	
                <%
                    }
                    if (flag) {
                    %>
                        <h4 style="position: absolute; margin-top: 10%; color: red; left: 46%">No Files!</h4>
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
        document.addEventListener('DOMContentLoaded', () => {
            let myInterval;
            myInterval = setInterval(() => {
                if(document.getElementById("successMsg").style.display == "block") {
                    setTimeout(() => {
                        document.getElementById("successMsg").innerHTML = "&nbsp;";
                        window.history.pushState("object or string", "Title", "http://localhost:8080/Library/webapp/Users/Customer/DropBox/" + window.location.href.substring(window.location.href.lastIndexOf('/') + 1).split("?")[0]);
                        clearInterval(myInterval)
                    }, 2000);
                }
            }, 1000);
        });
    </script>
</body>

</html>