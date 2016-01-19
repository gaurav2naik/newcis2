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

	} else if (session.getAttribute("Role").equals("Branch")) {
		response.sendRedirect("/view/jsp/BranchDashboard.jsp");
	}
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="icon" href="../image/title.png" type="image/png">
<link href="../css/header.css" rel="stylesheet" type="text/css" />
<style type="text/css">
body#home div#home_nav, body#ce div#ce_nav, body#eg div#eg_nav, body#cg div#cg_nav,
	body#lm div#lm_nav, body#logout div#logout_nav, body#contact div#contact_nav
	{
	background-color: #25aae1;
	/* border: 2px solid #25aae1; */
}
</style>

</head>

<body>
	<div id="note">
		<%
			
		%>
		Welcome
		<%
			out.print(session.getAttribute("UN"));
		%>
		&nbsp;|&nbsp;&nbsp;<span
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
				<a href="NewWebAndAppDashbord.jsp" id="a1" class="active">DashBoard</a>
			</div>
			<div class="menudata" id="ce_nav">
				<a href="CustomerExperience.jsp" id="a2">Customer Experience</a>
			</div>
			<div class="menudata" id="lm_nav">
				<a href="LiveMonitoring.jsp" id="a3">Live Monitoring</a>
			</div>
			<div class="menudata" id="eg_nav">
				<a href="Exception.jsp" id="a4">Incidents</a>
			</div>

		</div>
		<div class="rmenudatar" id="logout_nav">
			<div class="rmenudatafirst" id="nobar">
				<a href="Logout.jsp" id="a1">Logout</a>
			</div>
			<div class="rmenudata" id="contact_nav">
				<a href="http://www.avekshaa.com/contact-us/" id="a1">Contact</a>
			</div>
			<div class="rmenudata" id="cg_nav">
				<a href="Configuration.jsp" id="a1">Settings</a>
			</div>
			<div class="rmenudata" id="home_nav">
				<a href="NewWebAndAppDashbord.jsp" id="a1">Home</a>
			</div>
		</div>
	</div>

</body>
</html>