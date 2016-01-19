<%@page import="com.avekshaa.cis.engine.ExceptionDataCalculate"%>
<%@page import="com.avekshaa.cis.servlet.CreateTableRecentTen"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.avekshaa.cis.jio.GetChartData"%>
<%@page import="java.util.List"%>
<%@page import="com.avekshaa.cis.database.CommonUtils"%>
<%@page import="com.mongodb.BasicDBObject"%>
<%@page import="com.mongodb.DBObject"%>
<%@page import="com.mongodb.DB"%>
<%@page import="com.mongodb.DBCollection"%>
<%@page import="com.mongodb.DBCursor"%>
<%@page import="com.mongodb.Mongo"%>
<%@page import="com.avekshaa.cis.database.CommonDB"%>
<%@page import="com.avekshaa.cis.login.UserBean"%>

<%
	String day = request.getParameter("day");
	if(day==null){
		day = "1";
	}
	long dateOnly=ExceptionDataCalculate.CalculateDay(day);
	String Error_Detail="No more Details Available";
	DB db1=CommonDB.getConnection();
	List<DBObject> dbObjss1 = CreateTableRecentTen.getIncidentTableData(dateOnly);
	System.out.println("List Size" + dbObjss1.size());
	//String role = (String) session.getAttribute("Role");
	UserBean currUser = (UserBean) session.getAttribute("currentSessionUser");
	/* System.out.println("----------------???????????????????????????????"+session.getAttribute("currentSessionUser")); */
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="icon" href="../image/title.png" type="image/png">
<link href="../css/index.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" href="../css/button.css">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
<script src="../script/highcharts.js"></script>
<script src="../script/exporting.js"></script>
<link rel="stylesheet" type="text/css"
	href="../css/table_css/pop-up.css" />
<link href="../css/jquery.dataTables.min.css" rel="stylesheet"
	type="text/css" />
<link rel="stylesheet"
	href="http://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.4.0/css/font-awesome.min.css">
<link rel="icon" href="../image/title.png" type="image/png">
<link href="../css/index.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" href="../css/button.css">
<link rel="stylesheet" href="../css/bootstrap.min.css">
<script
	src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>
<script type="text/javascript" src="../script/jquery.dataTables.min.js"></script>


<script type="text/javascript">
	$(document).ready(function() {
		$('#myTable').DataTable({
			"aaSorting" : [ [ 1, 'desc' ] ],/* "paging":false,"scrollY":"350px","scrollCollapse":true, */
		});

	});
</script>

<title>Incidents |CIS</title>
<style type="text/css">
#
#topDiv1 {
	height: 35%;
	width: 45%;
	margin-left: 1%;
	margin-top: 1%;
}

#topDiv2 {
	height: 35%;
	width: 40%;
	margin-left: 51%;
	margin-top: 3%;
}

#g1 {
	height: 50%;
	width: 30%;
	background: white;
	color: white;
	margin-left: 1%;
	margin-top: -5%;
	float: left;
}

#g2 {
	height: 90%;
	width: 22%;
	background: white;
	color: white;
	margin-left: 1%;
	margin-top: 1%;
	float: left;
	display: inline;
}

#g3 {
	height: 90%;
	width: 22%;
	background: white;
	color: white;
	margin-left: 1%;
	margin-top: 1%;
	float: left;
	display: inline;
}

#g4 {
	height: 90%;
	width: 22%;
	background: white;
	color: white;
	margin-left: 1%;
	margin-top: 1%;
	float: left;
	display: inline;
}

/* #BottomDiv {
	height: 30%;
	width: 97%;
	margin-left: 1%;
	margin-top: 0%;
	/* border-style: solid;
	border-width: medium;
	border-color: yellow */
}
#graph1 {
	height: 34%;
	width: 20%;
	background: white;
	color: white;
	margin-left: 1%;
	margin-top: 0%;
	float: left;
	position: absolute;
}

#graph2 {
	height: 34%;
	width: 20%;
	background: white;
	color: white;
	margin-left: 28%;
	margin-top: 0%;
	float: left;
	position: absolute;
}

#graph3 {
	height: 34%;
	width: 20%;
	background: white;
	color: white;
	margin-left: 50%;
	margin-top: 0%;
	float: left;
	position: absolute;
}

#graph4 {
	height: 40%;
	width: 25%;
	background: white;
	color: white;
	margin-top: 0%;
	float: left;
	/* margin-right: 1%; */
	border-style: solid;
	border-width: medium;
	border-color: yellow;
	position: absolute;
}
.myButton {
	margin-top: 0%;
	padding-top: 0%;
	margin-bottom: 0%;
	padding-bottom: 0%;
	background-color: white;
	text-decoration: none;
	border-bottom: 4px solid lightblue;
	cursor: pointer;
	color: black;
	font-family: Arial;
	font-size: 17px;
	/* 	font-weight:bold; */
	text-decoration: none;
}

.myButton:hover {
	color: #1691D8;
	border-bottom: 4px solid black;
}

#active {
	position: relative;
	top: 0;
}

.abd:hover {
	border-bottom-color: 4px solid black;
}
</style>


<script type="text/javascript">
	$(function() {

		$('#container2').load('IncidentDetail.jsp');
	});
</script>
<script type="text/javascript">
	// for applicartion sersion response 

	$(function() {
		$('#g1')
				.highcharts(
						{
							chart : {
								plotBackgroundColor : null,
								plotBorderWidth : null,
								plotShadow : false,
								type : 'pie',
								x : 100,
								y : 100,
							},
							title : {
								text : 'Exception Distribution'
							},
							exporting : {
								enabled : false
							},
							credits : {
								enabled : false

							},
							tooltip : {
								headerFormat : '<span style="font-size:10px;color:{series.color}">Web Exception:</span><b>{point.key}</b><br>',
								pointFormat : '{series.name}: <b>{point.percentage:.1f}%</b>'
							},
							plotOptions : {
								pie : {
									allowPointSelect : true,
									cursor : 'pointer',
									size : 120,
									dataLabels : {
										enabled : false,
									}
								}
							},
							series : [ {
								name : "Percentage",
								colorByPoint : true,
								dataLabels : {
									enabled : true,
									verticalAlign : 'top',
									connectorWidth : 1,
									distance : -30,
									formatter : function() {
										//return Math.round(this.percentage) + ' %';
										return this.point.name;
									}
								},
								data : [
<%String webExcp = ExceptionDataCalculate.WebException(day);
			out.print(webExcp);%>
	]
							} ]
						});
	});
</script>
</head>

<script>
	function PassDaysNumber(days) {
		/* alert("here"); */
		var s = document.getElementById(days.id).getAttribute("id");
		var url = window.location.href;
		var param = '?day=' + days.id
		if (url.indexOf('?') > -1) {
			url = url.replace(url.substring(url.indexOf('?')), param)
		} else {
			//	alert("inside else")
			url += param
			//alert(url)
		}
		window.location.href = url;
	}
</script>
<body id=bi>


	<%@include file="BranchHeader.jsp"%>
	<div style="margin-left: 2%; margin-top: 1%">
		<div
			class="abd"
			style="width: 10%; display: inline; border-right: 1px solid black; padding-right: 1%; padding-left: 1%;"
			id="1daysdata"">
			<a id="1" href="#" title="" class="myButton" style="color: #1691D8;"
				onclick="PassDaysNumber(this)">1 Day</a>
		</div>
		<div
			class="abd"
			style="width: 10%; display: inline; border-right: 1px solid black; padding-right: 1%; padding-left: 1%;">
			<a id="7" href="#" title="" class="myButton"
				onclick="PassDaysNumber(this)">1 Week</a>
		</div>
		<div
			class="abd"
			style="width: 10%; display: inline; padding-left: 1%; color: #1691D8;">
			<a href="#" title="" class="myButton" id="30"
				onclick="PassDaysNumber(this)">1 Month</a>
		</div>
		<div id="alert"
			style="width: 10%; display: inline; padding-right: 1%; padding-left: 1%;">
			<div id="abc"
				style='color: #0A29B0; font-family: "Lucida Grande", "Lucida Sans Unicode", Arial, Helvetica, sans-serif; font-size: 29px; padding-left: 80%; margin-top: -1.5%;'>
				<%
					int count1 = ExceptionDataCalculate.ExceptionCount(day);
						int thresholdbreach1 = ExceptionDataCalculate.Alerts(day);
							int total1 = count1+thresholdbreach1;
							out.println("Total Alerts- "+total1);
				%>
			</div>
		</div>
	</div>
	<div id="topDiv1">

		<div id="g1" style="min-width: 310px; height: 230px; margin: 0 auto">
		</div>
	</div>


	<!--  7 jan changesss............................ -->

	<div id="topDiv2">
		<div id="alert"
			style='font-family: "Lucida Grande", "Lucida Sans Unicode", Arial, Helvetica, sans-serif; font-size: 58px; padding-left: 18.5%; padding-top: 3%'>

			<div
				style='font-family: "Lucida Grande", "Lucida Sans Unicode", Arial, Helvetica, sans-serif; padding-left: 16%; margin-top: 0.5%;'>
				<%
					int prev01=0;
						int present01=0;
						GetChartData crashChartData = new GetChartData();
						 int day_click=Integer.parseInt(day);
						if(day.equals("1")){
						String count01 = ExceptionDataCalculate.CompareExceptionCount_Web(day);
					String[] values01=count01.split(";");
					 prev01= Integer.parseInt(values01[0]); 
					 present01= Integer.parseInt(values01[1]); 
						}
						else if(day.equals("7")){
							 present01 = crashChartData.getWebCrashData_intType(day_click);
							 prev01=crashChartData.getWebCrashData_prevWeek(day_click);
						}
						else if(day.equals("30")){
							present01 = crashChartData.getWebCrashData_intType(day_click);
							prev01=crashChartData.getWebCrashData_prevWeek(day_click);
						}
					
					int diff01=prev01-present01;
					double cal_perf_web=0;
					if(diff01==0){
						out.println(cal_perf_web);
					}
					else if(diff01>0){
						out.println(diff01);
						if(prev01==0){
							 cal_perf_web=100;
						}
						else{
						 cal_perf_web=(diff01*100)/prev01;
						 System.out.println(prev01+"olol");
						 System.out.println(diff01+"olol");
						 System.out.println(present01+"olol");
						}
				%>
				<i class="fa fa-long-arrow-down"
					style="font-size: 48px; color: green"></i>
				<%
					}
					else{
						int new_value=Math.abs(diff01);
						out.println(new_value);
						if(prev01==0){
							cal_perf_web=100;
						}
						else{
						cal_perf_web=(new_value*100)/prev01;
						}
				%>
				<i class="fa fa-long-arrow-up" style="font-size: 48px; color: red"></i>
				<%
					}
				%>
				<div
					style='font-family: "Lucida Grande", "Lucida Sans Unicode", Arial, Helvetica, sans-serif; font-size: 22px; padding-left: 0.5%; margin-top: 0%; margin-bottom: 1.8%; display: inline;'>
					<%
						out.println(cal_perf_web+"% (previous)");
					%>
				</div>
			</div>
			<div
				style='padding-left: 18.5%; font-family: "Lucida Grande", "Lucida Sans Unicode", Arial, Helvetica, sans-serif; font-size: 18px; padding-top: 1.5%'>Http
				Errors</div>
			<div
				style='padding-left: 18.5%; font-family: "Lucida Grande", "Lucida Sans Unicode", Arial, Helvetica, sans-serif; font-size: 18px;'>
				<%
					int webCrashData = crashChartData.getWebCrashData_intType(day_click);
				  	       System.out.println(webCrashData+"webcreshdata");
				  	     GetChartData hitsChartData = new GetChartData();
				          int hitsData_Success = hitsChartData.getWebHitsData_intType(day_click);
				          int total_web_interaction=hitsData_Success+webCrashData;
				          double err_perc_web=(webCrashData*100)/total_web_interaction;
				          out.println(err_perc_web+"% of "+total_web_interaction+" interaction");
				%>
			</div>
		</div>
	</div>




	<div class="container2" style="margin-top: 3%">

		<table id="myTable" align="center" class="display" cellspacing="0"
			style="width: 100%; font-size: 12px;">
			<thead>
				<tr>
					<th><h3>Time</h3></th>
					<th><h3>IP Address</h3></th>
					<th><h3>URI</h3></th>
					<th><h3>Device</h3></th>
					<th><h3>Browser</h3></th>
					<th><h3>OS</h3></th>
					<th><h3>Status Code</h3></th>
					<th></th>
				</tr>
			</thead>


			<tbody>
				<%
					for (int i = 0; i < dbObjss1.size(); i++) {
									DBObject txnDataObject = dbObjss1.get(i);

									double status = Double.parseDouble(txnDataObject.get(
											"status_Code").toString());
									int responseTime = (int) status;
									String errorstatus = Integer.toString(responseTime);
									DBCollection errorlist = db1.getCollection("Errorlist");
									BasicDBObject err = new BasicDBObject();
									DBCursor dd = errorlist.find(err);
									List<DBObject> dbObjs1 = dd.toArray();
									// //System.out.println("error detail"+dbObjs1);
									for (int j = dbObjs1.size() - 1; j > dbObjs1.size() - 2; j--) {
										try {

											DBObject txnDataOb = dbObjs1.get(j);
											Error_Detail = (String) txnDataOb.get(errorstatus);
											// //System.out.println(Error_Detail+"  "+errorstatur);

										} catch (Exception e) {
											e.printStackTrace();
										}
									}
				%>

				<tr>
					<td><%=txnDataObject.get("Date")%></td>
					<td><%=txnDataObject.get("IP_Address")%></td>
					<td class="short"><%=txnDataObject.get("URI")%></td>
					<td class="short"><%=txnDataObject.get("Device")%></td>
					<td><%=txnDataObject.get("Browser")%></td>
					<td class="long"><%=txnDataObject.get("OS")%></td>
					<td class="short"><%=txnDataObject.get("status_Code")%></td>

					<td><button type="button" class="btn btn-info btn-lg"
							data-toggle="modal" data-target="#myModal<%=i%>">more</button>
						<div class="modal fade" id="myModal<%=i%>" role="dialog">
							<div class="modal-dialog">

								<!-- Modal content-->
								<div class="modal-content">
									<div class="modal-header">
										<button type="button" class="close" data-dismiss="modal">&times;</button>
										<h4 class="modal-title">Detail Report</h4>
									</div>
									<div class="modal-body">
										<p>
											<%=Error_Detail%></p>
									</div>
									<div class="modal-footer">
										<button type="button" class="btn btn-default"
											data-dismiss="modal">Close</button>
									</div>
								</div>

							</div>
						</div></td>


				</tr>

				<%
					}
				%>

			</tbody>

		</table>
	</div>

	</center>



	<!-- <div id="container2"  style="width: 99%;  margin-top:-8%;">
	 </div> -->
	<%@include file="Footer.jsp"%>
	<script type="text/javascript">
		$(document).ready(function() {
			//alert("hhh");
		//$("#loader").load("OneDay.jsp");
		var vars = [], hash;
	    var hashes = window.location.href.slice(window.location.href.indexOf('?') + 1);
	 	//alert(hashes);
	 	document.getElementById("1").style.borderBottomColor = "black";
	 	if(hashes == "day=30")
	 	{
	 			document.getElementById("1").style.borderBottomColor = "lightblue";
	 			document.getElementById("1").style.color = "black";
	 			document.getElementById("7").style.borderBottomColor = "lightblue";
	 			document.getElementById("7").style.color = "black";
	 			document.getElementById("30").style.borderBottomColor = "black";
	 			document.getElementById("30").style.color = "#1691D8";
	 	}
	 	if(hashes == "day=1")
 		{
 			document.getElementById("30").style.borderBottomColor = "lightblue";
 			document.getElementById("30").style.color = "black";
 			document.getElementById("7").style.borderBottomColor = "lightblue";
 			document.getElementById("7").style.color = "black";
 			document.getElementById("1").style.borderBottomColor = "black";
 			document.getElementById("1").style.color = "#1691D8";
 		}
	 	if(hashes == "day=7")
 		{
 			document.getElementById("1").style.borderBottomColor = "lightblue";
 			document.getElementById("1").style.color = "black";
 			document.getElementById("30").style.borderBottomColor = "lightblue";
 			document.getElementById("30").style.color = "black";
 			document.getElementById("7").style.borderBottomColor = "black";
 			document.getElementById("7").style.color = "#1691D8";
 		}
	    	//string ab = vars.split(',');
	    	//string b = ab[0];
	    	//alert("hhh" + b);
			$("#1d").css("border-bottom-color", "black");
			$(".myButton").on("click", function() {
				
				$(".myButton").css("color", "black");
				//$(".myButton").css("border-bottom-color", "lightblue");
				//$(this).css("border-bottom", " 4px solid black");
				$(this).css("color", "#1691D8");
				//$(".myButton").css("border-color", "lightblue");
				$(this).css("border-bottom-color", "black");
				//$("#1b").fadeIn("slow");
				//$("#loader").empty();
				//$('.cssload-container').show();
				//$("#loader").load($(this).attr("page"));
				//$('#1b').fadeIn('slow').delay(2500).hide(0);
				return true;

			});
		});
	</script>
</body>
</html>