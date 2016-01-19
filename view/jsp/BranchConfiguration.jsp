<%@page import="com.mongodb.MongoClient"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@page import="com.avekshaa.cis.database.CommonUtils"%>
<%@page import="com.avekshaa.cis.database.CommonDB"%>
<%@page import="com.avekshaa.cis.engine.Live"%>
<%@page import="com.avekshaa.cis.engine.LiveResponseCustomized"%>
<%@page import="java.util.*"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.mongodb.BasicDBObject"%>
<%@page import="com.mongodb.DBObject"%>
<%@page import="com.mongodb.DB"%>
<%@page import="com.mongodb.DBCollection"%>
<%@page import="com.mongodb.DBCursor"%>
<%@page import="com.mongodb.Mongo"%>
<html>
<head>
<script type='text/javascript' src='view/script/getState.js'></script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Branch Configuration Page</title>
<link rel="stylesheet" type="text/css" href="css/style1.css" />
<link href="../css/button.css" rel="stylesheet" type="text/css" />
<script src="../script/jquery.min.js"></script>
<style type="text/css">
body{
margin: 0px;
}
table {
	color: #333;
	font-family: Helvetica, Arial, sans-serif;
	width: 640px;
	border-collapse: collapse;
	border-spacing: 0;
}

td, th {
	border: 1px solid transparent; /* No more visible border */
	height: 30px;
	transition: all 0.3s; /* Simple transition for hover effect */
}

th {
	background: #DFDFDF; /* Darken header a bit */
	font-weight: bold;
}

td {
	background: #FAFAFA;
	text-align: center;
}

/* Cells in even rows (2,4,6...) are one color */
tr:nth-child(even) td {
	background: #F1F1F1;
}

/* Cells in odd rows (1,3,5...) are another (excludes header cells)  */
tr:nth-child(odd) td {
	background: #FEFEFE;
}

tr td:hover {
	background: #666;
	color: #FFF;
} /* Hover cell effect! */
</style>
</head>
<body>
	<%@include file="BranchHeader.jsp"%>
	<div style="text-align: center; font-size: 20px;">
		<h1 style="margin: 0px">Configuration Page</h1>
	</div>
	<div id="box"
		style="width: 100%; position: relative; margin-top: 50px;"
		align="center">

		<%
			DB db=CommonDB.getConnection();
			DBCollection colls1 = db.getCollection("XLsheet");
			BasicDBObject obj = new BasicDBObject();

			DBCursor value = colls1.find();
			System.out.println("cursor " + value.count());
			List<DBObject> dbObjss1 = value.toArray();
			System.out.println("List Size" + dbObjss1.size());
		%>
		<center>
			<form method="post" action="../../UploadServlet"
				enctype="multipart/form-data"
				style="padding-bottom: 2%; width: 100%;">
				Select file to upload: <input type="file" name="uploadFile" /><br />
				<br /> 
  					<input type="submit" value="EditFileUpload"/>
  				
			</form>
		</center>
				
		<hr>
		<center>
			<form method="post" action="../../BranchActivation" style="padding-top: 5%;padding-bottom: 5%">

				<table id="myTable">
					<thead>
						<tr>
						<th>Identification Code</th>
							<th>Branch Name</th>
							<th>Branch Ip Address</th>
							<th>Enable/disable monitoring</th>
						</tr>
					</thead>
					<tbody>
						<%
							// List alertData1 = CommonUtils.getState();
							for (int j = 0; j < dbObjss1.size(); j++) {
								DBObject txnDataObject = dbObjss1.get(j);

								StringBuffer sb = new StringBuffer();
						%>

						<tr>
							<td align="left"><%=txnDataObject.get("Branch_Name")%></td>
							<td align="left"><%=txnDataObject.get("Identification_code")%></td>
							<td align="left"><%=txnDataObject.get("IP_address")%></td>
							<td align="left"><input type="checkbox" name="checkbox"
								value="<%=txnDataObject.get("IP_address")+";"+txnDataObject.get("Branch_Name")+";"+txnDataObject.get("Identification_code")%>" id="checkbox<%=j%>"></td>

						</tr>

						<%
							}
						%>

					</tbody>

				</table>

		<input type="submit" name="Submit" value="Submit"
			style="border-radius: 5px; width: 70px; right: 750px; position: absolute;" />
			
		</form>
		</center>
		 <%if(request.getParameter("status")!=""||request.getParameter("status")!=null) {%> 
		<div style="color: red;padding-top:1%;padding-bottom:2%"><%=request.getParameter("status") %></div>
		 <%} %>

	</div>

	<%@include file="Footer.jsp"%>

</body>
</html>