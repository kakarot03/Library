<%@ page import="io.asgardeo.java.saml.sdk.bean.LoggedInSessionBean" %>
<%@ page import="io.asgardeo.java.saml.sdk.util.SSOAgentConstants" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>Home</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" type="text/css" href="theme.css">
</head>
<%
    LoggedInSessionBean sessionBean = (LoggedInSessionBean) session.getAttribute(SSOAgentConstants.SESSION_BEAN_NAME);
    String subjectId = sessionBean.getSAML2SSO().getSubjectId();
%>
<body>
	<script>
		window.location.href = 'http://localhost:8080/Library/webapp/Users/Customer/Customer.jsp';
	</script>
</body>
</html>
