<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@page import="com.avekshaa.cis.login.UserBean"%>
<%
	System.out.println("Role :" + session.getAttribute("Role"));
	if (session.getAttribute("UN") == null
			|| session.getAttribute("UN").equals("")
			|| session.getAttribute("Role") == null
			|| session.getAttribute("Role") == "") {
		System.out.println("Header After Login case: user Null");
		response.sendRedirect("../../index.jsp?err=You are not Logged In!!!");

	} else if(!session.getAttribute("UN").equals("admin")){
		System.out.println("User is not a valid admin!!!");
		session.invalidate();
		response.sendRedirect("../../index.jsp?err=You are not authorized!!!");
		return;
	}
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="icon" href="../image/title.png" type="image/png">
<link href="../css/header.css" rel="stylesheet" type="text/css" />
<style type="text/css">
body#home div#home_nav, body#ec div#ec_nav, body#um div#um_nav, body#cg div#cg_nav, body#ms div#ms_nav
	 {
	background-color : #25aae1;
}
</style>
</head>

<body>
	<div id="note">
		
		Welcome
		<%
			out.print(session.getAttribute("UN"));
		%>
		&nbsp;|&nbsp;&nbsp; <span
			style="padding-right: 1%; padding-left: 0%; padding-top: 0%;">
			<%
				out.print(session.getAttribute("Role"));
			%>
		</span>

	</div>
	<div id="b">
		<div id="b1">
			<img src="../image/logo.png"
				style="background-color: white; padding: 5px; width: 100%" />

		</div>
		<div id="b2">
			<div id="welcomenote">CustExp</div>
			<div class="menudata" id="home_nav">
				<a href="CreateUser.jsp" id="a1" class="active">User Management</a>
			</div>
			<div class="menudata" id="cg_nav">
				<a href="ConfigThreshold.jsp" id="a2">Threshold Configuration</a>
			</div>
			<div class="menudata" id="ec_nav">
				<a href="EmailConfiguration.jsp" id="a3">Email Configuration</a>
			</div>
			<div class="menudata" id="ms_nav">
				<a href="NewWebAndAppDashbord.jsp" id="a4">Monitoring Screen</a>
			</div>
			
		</div>
		<div class="rmenudatar">
			<div class="rmenudatafirst nobar"  id="logout_nav">
				<a href="Logout.jsp" id="a1">Logout</a>
			</div>
			<div class="rmenudata" id="contact_nav">
				<a href="http://www.avekshaa.com/contact-us/" id="a1">Contact</a>
			</div>
			<div class="rmenudata" id="home_nav">
				<a href="CreateUser.jsp" id="a1">Home</a>
			</div>
		</div>
	</div>


</body>
</html>