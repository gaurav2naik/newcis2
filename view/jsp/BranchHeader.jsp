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

	} else if (session.getAttribute("Role").equals("Combined")) {
		response.sendRedirect("/view/jsp/NewWebAndAppDashbord.jsp");
	}
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="icon" href="../image/title.png" type="image/png">
<link href="../css/header.css" rel="stylesheet" type="text/css" />
<style type="text/css">
body#home div#home_nav, body#bd div#bd_nav, body#bce div#bce_nav, body#bi div#bi_nav,
	body#bcg div#bcg_nav, body#blm div#blm_nav, body#logout div#logout_nav, body#br_qos div#br_qos_nav {
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
				<a href="BranchDashboard.jsp" id="a1" class="active">DashBoard</a>
			</div>
			<div class="menudata" id="bce_nav">
				<a href="BranchCustomerExperience.jsp" id="a2">User Experience</a>
			</div>
			<div class="menudata" id="blm_nav">
				<a href="BranchLiveMonitoring.jsp" id="a3">Live Monitoring</a>
			</div>
			<div class="menudata" id="bi_nav">
				<a href="BranchIncidents.jsp" id="a4">Incidents</a>
			</div>
			<div class="menudata" id="br_qos_nav">
				<a href="BranchQos.jsp" id="a5">Branch QoS</a>
			</div>
		</div>
		<div class="rmenudatar">
			<div class="rmenudatafirst nobar"  id="logout_nav">
				<a href="Logout.jsp" id="a1">Logout</a>
			</div>
			<div class="rmenudata" id="contact_nav">
				<a href="http://www.avekshaa.com/contact-us/" id="a1">Contact</a>
			</div>
			<div class="rmenudata" id="bcg_nav">
				<a href="BranchConfiguration.jsp?status=" id="a1">Settings</a>
			</div>
			<div class="rmenudata" id="home_nav">
				<a href="BranchDashboard.jsp" id="a1">Home</a>
			</div>
		</div>
	</div>


</body>
</html>