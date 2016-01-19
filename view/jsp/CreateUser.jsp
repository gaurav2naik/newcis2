<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%-- <%
	if (session.getAttribute("currentSessionUser") == null
			|| session.getAttribute("currentSessionUser").equals("")) {
		response.sendRedirect("../../index.jsp?err=You are not Logged In !!!");
	}
%> --%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="../css/admin.css" />
<!-- <link href="../css/index.css" rel="stylesheet" type="text/css" /> -->

<script src="../script/getURL.js"></script>
<title>Customer Experience | Create User</title>
<style type="text/css">
body{
	margin:0
}

</style>
</head>
<body id="home">
	<%@include file="AdminHeader.jsp"%>

		<form name="passGeneration" action="../../CreateUserServlet"
		method="post" style="margin-top:0px">

		<h1>Create User</h1>
		<label for="name">User-Name:</label> <input type="text" name="name">
		<label for="password">Password</label> <input type="text" name="pwd">
		<input type="button" value="Generate password "
			onClick="passGenerator()"> <br> <br> <label
			for="mail">E-mail:</label> <input type="text" name="mail"> <br>
		
		<center>
			<button type="submit" value="submit" />
			Create
		</center>
	</form>
<%@include file="Footer.jsp" %>
</body>
</html>

