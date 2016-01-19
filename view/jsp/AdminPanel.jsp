<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>User Management |CIS</title>
<style type="text/css">
body {
	margin: 0px;
}

.sidebar {
	float: left;
	width: 15%;
	padding: 5px;
	/* background-color: yellow; */
	/* height:100%; */
	margin-top: 1%;
}

#sub-content {
	float: left;
	width: 70%;
	/* height:100%; */
	padding: 5px;
	margin: 1% 1% 1% 5%;
	/* background-color: lightgrey */
}
</style>
<script type="text/javascript" src="../script/jquery.js"></script>
<link href="../css/sidebar.css" rel="stylesheet" type="text/css" />
</head>
<body>
	<%
		System.out
				.print("EMail session check:"
						+ session.getAttribute("Role")
						+ session.getAttribute("UN"));
		if (session.getAttribute("UN") == null
				|| session.getAttribute("UN").equals("")
				|| session.getAttribute("Role") == null
				|| session.getAttribute("Role") == "") {
			System.out.println("Header After Login case: user Null");
			response.sendRedirect("../../index.jsp?err=You are not Logged In!!!");

		} else if (session.getAttribute("Role").equals("Combined")) {
	%><!-- checking which header to be included when admin login -->
	<%@include file="CombinedHeader.jsp"%>
	<%
		} else if (session.getAttribute("Role").equals("Branch")) {
	%>
	<%@include file="BranchHeader.jsp"%>
	<%
		}
	%>
	<%
		String status = request.getParameter("status");
		if (status == null || status == "") {
			//System.out.println("hello;;");
			status = "&nbsp;";

		}
	%>
	<div id='cssmenu' class="sidebar">
		<ul>
			<li id="menu-item-1"><a href='#'><span>Threshold
						Configuration</span></a></li>
			<li id="menu-item-2" class='active has-sub'><a href='#'><span>User
						Settings</span></a>
				<ul>
					<li id="menu-item-2a"><a href='#'><span>Manage
								Users</span></a></li>
					<li id="menu-item-2b"><a href='#'><span>Create New
								User</span></a></li>
				</ul></li>
			<li id="menu-item-3"><a href='#'><span>Email
						Configuration</span></a></li>
			<!--    <li class='last'><a href='#'><span>Contact</span></a></li> -->
		</ul>
	</div>
	<div id="sub-content"></div>
	<script>
		$(document).ready(function() {

			$('#sub-content').load("EmailConfiguration.jsp");

		});
		$('#menu-item-1').on('click', function() {

			$('#sub-content').load("ConfigThreshold.jsp");

		});
		$('#menu-item-2a').on('click', function() {

			$('#sub-content').load("UserManagement.jsp");

		});
		$('#menu-item-2b').on('click', function() {

			$('#sub-content').load("CreateUser.jsp");

		});
		$('#menu-item-3').on('click', function() {

			$('#sub-content').load("EmailConfiguration.jsp");

		});
	</script>
	<%@include file="Footer.jsp"%>
</body>
</html>