<%@page import="java.text.DecimalFormat"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.TreeMap"%>
<%@page import="java.util.Map"%>
<%@page import="com.avekshaa.cis.engine.ExceptionDataCalculate"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.avekshaa.cis.jio.GetChartData"%>
<%@page import="java.util.List"%>
<%@page import="com.avekshaa.cis.engine.get_Fatal_data"%>
<%@page import="com.avekshaa.cis.engine.one_day_hits_data"%>
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
System.out.println("day is"+day);
	if(day==null){
		day = "1";
	}
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
<link rel="stylesheet" href="http://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.4.0/css/font-awesome.min.css">
<script src="../script/jquery.min.js"></script>
<script src="../script/jquery.js"></script>
<script src="../script/highcharts.js"></script>
<script src="../script/exporting.js"></script>

<title>Incidents |CIS</title>
<style type="text/css">
#topDiv1 {
	height: 35 %;
	width: 47%;
	margin-left: 1%;
	margin-top: 1%;
}
#topDiv2 {
	height: 35 %;
	width: 46%;
	margin-left: 51%;
	margin-top: -8%;
}


#graph1 {
	height: 34%;
	width: 20%;
	background: white;
	color: white;
	margin-left: 0%;
	margin-top: 0%;
	float: left;
	position: absolute;
}

#graph2 {
	height: 34%;
	width: 20%;
	background: white;
	color: white;
	margin-left: 16%;
	margin-top: 0%;
	float: left;
	position: absolute;
}

#graph3 {
	height: 34%;
	width: 20%;
	background: white;
	color: white;
	margin-left: 33%;
	margin-top: 0%;
	float: left;
	position: absolute;
}

#graph4 {
	height: 34%;
	width: 20%;
	background: white;
	color: white;
	margin-left: 60%;
	margin-top: 0%;
	float: left;
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
	// for applicartion sersion response 

	$(function() {
		$('#graph1')
				.highcharts(
						{
							chart : {
								plotBackgroundColor : null,
								plotBorderWidth : null,
								plotShadow : false,
								type : 'pie'
							},
							exporting : {
								enabled : false
							},
							title : {
								text : 'Exception'
							},
							credits : {
								enabled : false

							},
							tooltip : {
								headerFormat : '<span style="font-size:10px;color:{series.color}">Excep: </span><b>{point.key}</b><br>',
								pointFormat : '{series.name}: <b>{point.percentage:.1f}%</b>'
							},
							plotOptions : {
								pie : {
									allowPointSelect : true,
									cursor : 'pointer',
									dataLabels : {
										enabled : false,
										/* format : '<b>{point.name}</b>: {point.percentage:.1f} %',
										style : {
											color : (Highcharts.theme && Highcharts.theme.contrastTextColor)
													|| 'black'
										} */
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
										return Math.round(this.percentage) + ' %';
										//return this.percentage;
									}
								},
								data : [
<%ExceptionDataCalculate edc1 = new ExceptionDataCalculate();

			String webExcp1 = edc1.Exception("$Exception", day);
			out.print(webExcp1);%>
	]
							} ]
						});
	});

	$(function() {
		$('#graph2')
				.highcharts(
						{
							chart : {
								renderTo : 'graph2',
								plotBackgroundColor : null,
								plotBorderWidth : null,
								plotShadow : false,
								type : 'pie'
							},
							title : {
								text : 'Application'
							},
							exporting : {
								enabled : false
							},
							credits : {
								enabled : false

							},
							tooltip : {
								/* pointFormat : '' */
								headerFormat : '<span style="font-size:10px;color:{series.color}">App Ver: </span><b>{point.key}</b><br>',
								pointFormat : '{series.name}: <b>{point.percentage:.1f}%</b>'
							},
							plotOptions : {
								pie : {
									allowPointSelect : true,
									cursor : 'pointer',
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
<%ExceptionDataCalculate edc2 = new ExceptionDataCalculate();
String webExcp2 = edc2.Exception("$App_ver", day);
			out.print(webExcp2);%>
			]
							} ]
						});
	});

	$(function() {
		$('#graph3')
				.highcharts(
						{
							chart : {
								plotBackgroundColor : null,
								plotBorderWidth : null,
								plotShadow : false,
								type : 'pie'
							},
							exporting : {
								enabled : false
							},
							credits : {
								enabled : false

							},
							title : {
								text : 'Android Version'
							},
							tooltip : {
								headerFormat : '<span style="font-size:10px;color:{series.color}">Android Ver: </span><b>{point.key}</b><br>',
								pointFormat : '{series.name}: <b>{point.percentage:.1f}%</b>'
							},
							plotOptions : {
								pie : {
									allowPointSelect : true,
									cursor : 'pointer',
									dataLabels : {
										enabled : false,
										/* format : '<b>{point.name}</b>: {point.percentage:.1f} %',
										style : {
											color : (Highcharts.theme && Highcharts.theme.contrastTextColor)
													|| 'black'
										} */
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
<%ExceptionDataCalculate edc3 = new ExceptionDataCalculate();
			String webExcp3 = edc3.Exception("$Android_ver", day);
			out.print(webExcp3);%>
	]
							} ]
						});
	});

	$(function() {
		$('#graph4')
				.highcharts(
						{
							chart : {
								plotBackgroundColor : null,
								plotBorderWidth : null,
								plotShadow : false,
								type : 'pie'
							},
							title : {
								text : 'Http Errors'
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
<%
			String webExcp = ExceptionDataCalculate.WebException(day);
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
<body id="eg">

	<%@include file="CombinedHeader.jsp"%>
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
<!-- change on 4 jan 2016 -->
	<div id="alert"
			style="width: 10%; display: inline; padding-right: 1%; padding-left: 1%;">
			<div id="abc"
			style='color: #0A29B0; font-family: "Lucida Grande", "Lucida Sans Unicode", 
			                  Arial, Helvetica, sans-serif;
			                        font-size: xx-large;padding-left: 78%;margin-top: -1.5%;'>
				<%try{
				int count1 = ExceptionDataCalculate.ExceptionCount(day);
				int thresholdbreach1 = ExceptionDataCalculate.Alerts(day);
					int total1 = count1+thresholdbreach1;
					out.println("Total Alerts- "+total1);
				%>
			</div>
			</div>
	</div>
	<div id="topDiv1">
		<div style=' font-family: "Lucida Grande", "Lucida Sans Unicode", 
			Arial, Helvetica, sans-serif;font-size: 58px; padding-left: 13%;padding-bottom: 1%;'>
			<%
			int prev=0; 
			int present=0; 
			int diff=  0;
			GetChartData ch = new GetChartData();
			if(day.equals("1")){
			String count = ExceptionDataCalculate.CompareExceptionCount_mobile(day);
			String[] values=count.split(";");
			prev= Integer.parseInt(values[0]); 
			present= Integer.parseInt(values[1]); 
			
			}
			else if(day.equals("7")){
				prev = ch.getDataForCrash_prev_week(7);
				present = ch.getDataForCrash_intType(7);
				
			}
			else if(day.equals("30")){
				double present_double = ch.getDataForCrash_DoubleType(30);
				System.out.println(present_double+"present doubel");
				present=(int)present_double;
				prev=ch.getDataForCrash_PreviousWeek(30);
			}
			diff=  prev-present ;
			double cal_perc=0;
			if(diff==0){
				out.println(cal_perc);
			}
			else 
				if(diff>0){
				out.println(diff);
				if(present==0){
					 cal_perc=100;
				}
				else{
				 cal_perc=(diff*100)/prev;
				}	
				%>
				 <i class="fa fa-long-arrow-down" style="font-size:48px;color:green"></i>
				<%
			}
			else {
				int new_value=Math.abs(diff);
				System.out.println(new_value+"new value");
				
				out.println(new_value);
				if(prev==0){
					cal_perc=100;
				}
				else{
					if(prev!=0)
					cal_perc=(new_value*100)/prev;
				}
				%>
				<i class="fa fa-long-arrow-up" style="font-size:48px;color:red"></i>
				<%
				} 
				%>
								<div
			style='font-family: "Lucida Grande", "Lucida Sans Unicode", Arial, Helvetica, sans-serif;font-size: 22px; padding-left: 0.5%; display : inline;'>
				<%
				out.println(cal_perc+"% (previous)");
				%>
				</div>
		</div>
		<div style='padding-left: 13%;font-family: "Lucida Grande", "Lucida Sans Unicode", Arial, Helvetica,
		 sans-serif; font-size: 18px;'>Application Crashes</div>
		<div style='padding-left: 13%;font-family: "Lucida Grande", "Lucida Sans Unicode",
		 Arial, Helvetica, sans-serif; font-size: 18px;'>
		 <%
		 if(day.equals("1")){
		 get_Fatal_data resp = new get_Fatal_data();
         TreeMap<Long, Integer> data = resp.Fatal_Detail_current();
         int count_app_error=0;
         for (Iterator iterator = data.keySet().iterator(); iterator.hasNext();) {
            
             Long hrs = (Long) iterator.next();
             count_app_error+= data.get(hrs);
            
         }
         one_day_hits_data app_success=new one_day_hits_data();	
      	TreeMap<Long, Integer> data1 = app_success.hits_detail();
      	int count_success_app=0;
      	for (Iterator iterator = data1.keySet().iterator(); iterator.hasNext();)
		{
			Long hrs = (Long)iterator.next();//key
			count_success_app+=data1.get(hrs);
		}
      	int total_app_interaction=count_app_error+count_success_app;
      	if(total_app_interaction!=0){
      	double err_perc=(count_app_error*100)/total_app_interaction;
		 
         out.println(err_perc+"% of "+total_app_interaction+" interaction");
		 }
		 }
		 else if(day.equals("7")){
         int count_app_error = ch.getDataForCrash_intType(7);
         int count_success_app = ch.getDataForHits_intType(7);
         int total_app_interaction=count_app_error+count_success_app;
     	if(total_app_interaction!=0){
       	double err_perc=(count_app_error*100)/total_app_interaction;
        out.println(err_perc+"% of "+total_app_interaction+" interaction");
		 }
		 }
		 else if(day.equals("30")){
				double count_success_app = ch.getAppDataForResponce_doubleType(30);
				double count_app_error = ch.getDataForCrash_DoubleType(30);
				double total_app_interaction=count_app_error+count_success_app;
				if(total_app_interaction!=0){
				double err_perc=(count_app_error*100)/total_app_interaction;
		       	int app_count=(int)total_app_interaction;
		       	DecimalFormat df = new DecimalFormat("#.##");
		       	err_perc = Double.valueOf(df.format(err_perc));
		     
		        out.println(err_perc+"% of "+app_count+" interaction");
		 }
		 }
         %>
		 </div>
		
		</div>
		<div id="topDiv2">
		<div id="alert"
		style='font-family: "Lucida Grande", "Lucida Sans Unicode", Arial, Helvetica, 
		          sans-serif;font-size: 58px; padding-left:18.5%;padding-top: 3%'>

			<div
				style='font-family: "Lucida Grande", "Lucida Sans Unicode", 
				              Arial, Helvetica, sans-serif; padding-left: 16%;margin-top: -4.5%;'>
				<%
				int prev01=0;
				int present01=0;
				 int day_click=Integer.parseInt(day);
				if(day.equals("1")){
				String count01 = ExceptionDataCalculate.CompareExceptionCount_Web(day);
			String[] values01=count01.split(";");
			 prev01= Integer.parseInt(values01[0]); 
			 present01= Integer.parseInt(values01[1]); 
				}
				else if(day.equals("7")){
					 present01 = ch.getWebCrashData_intType(day_click);
					 prev01=ch.getWebCrashData_prevWeek(day_click);
				}
				else if(day.equals("30")){
					present01 = ch.getWebCrashData_intType(day_click);
					prev01=ch.getWebCrashData_prevWeek(day_click);
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
				<i class="fa fa-long-arrow-down" style="font-size:48px;color:green"></i>
				<%
			}
			else{
				int new_value=Math.abs(diff01);
				out.println(new_value);
				if(prev01==0){
					cal_perf_web=100;
				}
				else{
					if(prev01!=0)
				cal_perf_web=(new_value*100)/prev01;
				}
				%>
				<i class="fa fa-long-arrow-up" style="font-size:48px;color:red"></i>
				<%} %>
				<div
			style='font-family: "Lucida Grande", "Lucida Sans Unicode", 
			          Arial, Helvetica, sans-serif;font-size: 22px; padding-left: 0.5%;margin-top: 0%; margin-bottom : 1.8%; display : inline;'>
				<%
				out.println(cal_perf_web+"% (previous)");
				%>
				</div>
			</div>
			<div style='padding-left: 18.5%; font-family: "Lucida Grande", "Lucida Sans Unicode",
			   Arial, Helvetica, sans-serif;  font-size: 18px; padding-top: 1.5%'>Http Errors</div>
			<div style='padding-left: 18.5%;font-family: "Lucida Grande", "Lucida Sans Unicode",
			 Arial, Helvetica, sans-serif;  font-size: 18px;'>
			 <%
  	       int webCrashData = ch.getWebCrashData_intType(day_click);
  	       System.out.println(webCrashData+"webcreshdata");
          int hitsData_Success = ch.getWebHitsData_intType(day_click);
          int total_web_interaction=hitsData_Success+webCrashData;
      	if(total_web_interaction!=0){
          double err_perc_web=(webCrashData*100)/total_web_interaction;
          out.println(err_perc_web+"% of "+total_web_interaction+" interaction");
  	       }}catch(Exception e){e.printStackTrace();}%>
			 </div>
		</div>
	</div>

	<div id="container2" style="margin-top: 3%">
		<p style="margin-left: 2%">
			<span
				style='color: #6c7fc6;font-family: "Lucida Grande", 
				"Lucida Sans Unicode", Arial, Helvetica, sans-serif; font-weight: bold; font-size: 24px'>Distribution </span> <span
				style='margin-left: 56%; color: #6c7fc6; font-family: "Lucida Grande", 
				"Lucida Sans Unicode", Arial, Helvetica, sans-serif; font-weight: bold; font-size: 24px'>Distribution</span>
		</p>
		<div
			style="width: 30%; margin-left: 1.5%; border-top-color: #f2f2f2; border-top-style: solid;"></div>
		<div id="graph1"></div>
		<div id="graph2"></div>
		<div id="graph3"></div>
		<div id="graph4"></div>
	</div>
	<div
		style="width: 99%; height: 10%; margin-top: 17%">
		<span style="color: #6c7fc6; font-size: 15px; margin-left:8%"><a
			href="ExceptionGraph.jsp?day=<%=day%>">See Details</a> </span> <span
			style="margin-left: 65%; color: #6c7fc6; font-size: 15px"><a
			href="IncidentDetail.jsp?day=<%=day%>">See Details</a> </span>
	</div>
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