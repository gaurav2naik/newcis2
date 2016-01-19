<%@page import="java.text.DateFormat"%>
<%@page import="com.avekshaa.cis.premiumusers.GetBandwidthPremiumUser"%>
<%@page
	import="com.avekshaa.cis.premiumusers.AveragePremiumResponseData"%>
<%@page import="java.lang.reflect.Array"%>
<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@page import="com.avekshaa.cis.database.*"%>
<%@page import="com.mongodb.*"%>
<%@page import="com.mongodb.DBCollection"%>
<%@page import="com.mongodb.BasicDBObject"%>
<%@page import="com.mongodb.DBCursor"%>
<%@page import="java.util.*"%>
<%@page import="com.mongodb.DBObject"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DecimalFormat"%>
<%
	String role = (String) session.getAttribute("Role");
	DB db = CommonDB.getBankConnection();
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<title>Customer Experience | Premium User</title>
<link
	href="http://code.jquery.com/ui/1.10.4/themes/ui-lightness/jquery-ui.css"
	rel="stylesheet">
<script src="../script/jquery.min.js"></script>
<script src="../script/jquery.js"></script>
<script src="http://code.jquery.com/ui/1.10.4/jquery-ui.js"></script>
<script src="../script/highcharts.js"></script>
<script src="../script/exporting.js"></script>
<script language="javascript" type="text/javascript">
    $(function() {
   	 //alert("hello");
    	$( "#datepicker1" ).datepicker({maxDate: 0});
        $( "#datepicker2" ).datepicker({maxDate: 0});
    });
    
    
    function CheckDateValue()
    {
    	 var Date1 = document.getElementById("datepicker1").value;
    	 var Date2 = document.getElementById("datepicker2").value;
     	 
    	    if (Date1==null || Date1=="" || Date2==null || Date2=="") 
    	    {
    	        return false;
    	    }
    }
    </script>
<link rel="stylesheet" type="text/css" href="../css/index.css" />
<script type="text/javascript" src="../script/styleswitcher.js"></script>
<link rel="stylesheet" type="text/css" href="../css/treeMenu.css" />
<link rel="icon" href="../image/title.png" type="image/png">
<link href="../css/header.css" rel="stylesheet" type="text/css" />
<script type='text/javascript' src='../script/treeMenu.js'></script>

<link rel="stylesheet" type="text/css" href="../css/index.css" />
<!-- <script type="text/javascript" src="../script/styleswitcher.js"></script> -->
<link rel="stylesheet" href="../css/button.css">
<link rel="stylesheet" type="text/css" href="../css/treeMenu.css" />
<link rel="stylesheet" type="text/css" href="../css/loading.css">
<style>
.body1 {
	height: 550px;
	width: 1100px;
	/* margin: 5%; */
	/* margin-top: 5%; */
	margin-left: 15%;
	background-image: url('../image/tablet_1.png');
	background-size: 1000px 500px;
	background-repeat: no-repeat;
}

#premiumUserSelect {
	margin-top: 20px;
	padding: 5px;
}

#container {
	background-color: white;
	height: 100%;
	width: 100%;
}

#daterange {
	margin-left: 25%;
	/* border-style: solid; */
	width: 40%;
	height: 4%;
	/* border-color: #000; */
	margin-top: 1%;
}
</style>
</head>
<%
	String str;
	String Device = request.getParameter("Device");
	//System.out.println("-------------------------"+Device);
	String from = request.getParameter("from");
	String to = request.getParameter("to");
	System.out.println(from + "-----=============================----------" + to);
	BasicDBObject findobj1 = null;
	List alertData1 = null;
	if (Device == null || Device == "") {
		//System.out.println("hello;;");
		response.sendRedirect("CustomerExperience.jsp");
		return;
	}
	long from_timestamp = 0l;
	long to_timestamp = 0l;

	//DB androidconn = CommonDB.getBankConnection();
	DBCollection coll = db.getCollection("IOSData");
	if (from != null && to != null && from != "" && to != "") {		
		System.out.println("inside if cond");
		DateFormat formatter;
		formatter = new SimpleDateFormat("MM/dd/yyyy");
		Date date1 = (Date) formatter.parse(from);
		Date date2 = (Date) formatter.parse(to);
		from_timestamp = date1.getTime();
		to_timestamp = date2.getTime();
		findobj1 = new BasicDBObject("UUID", Device.trim());
		findobj1.append("StartTime", new BasicDBObject("$gt", from_timestamp + 19800000).append("$lt",
				to_timestamp + 19800000 + 43200000));
		System.out.println("YYYYYYYYYYYYYYYYYYYYYYYYYYYYY"+from_timestamp + 19800000);
		System.out.println("---------------------------------------"+to_timestamp + 19800000 + 43200000);
		
		alertData1 = coll.distinct("StartTime", findobj1);
	} else {
		System.out.println("inside else cond");
		findobj1 = new BasicDBObject("UUID", Device.trim());
		alertData1 = coll.distinct("StartTime", findobj1);
		//List<Long> arr = new ArrayList<Long>();
	} //List<Long> arr = new ArrayList<Long>();

	long arr[] = new long[5];

	arr[0] = 0l;
	arr[1] = 0l;
	arr[2] = 0l;
	arr[3] = 0l;
	arr[4] = 0l;

	if (alertData1.size() > 5) {
		for (int i = alertData1.size() - 1, x = 0; i >= alertData1.size() - 5; i--, x++) {
			long l = (Long) alertData1.get(i);
			if (l != 0) {
				long s = Long.parseLong(alertData1.get(i).toString());
				//arr.add(s);

				arr[x] = s;
			}
		}
	} else {
		for (int i = alertData1.size() - 1, x = 0; i >= 0; i--, x++) {
			long l = (Long) alertData1.get(i);
			if (l != 0) {
				long s = Long.parseLong(alertData1.get(i).toString());
				//arr.add(s);

				arr[x] = s;
			}
		}
	}
	//arr.add(Device);
	//new AveragePremiumResponseData(arr);
%>


<script>
$(document).ready(function() {
	
	
	$("#0").click(function() {
		//alert("CLICKED");
		$("#LINKS").empty();
		$('.cssload-container').show();
		$("#LINKS").load("PremiumgraphsIOS/onlylink_ios.jsp?DEVICE="+"<%=Device%>"+"&VALUE="+"<%=arr[0]%>");	
	});
	

	$("#1").click(function() {
		//alert("CLICKED");
		$("#LINKS").empty();
		$('.cssload-container').show();
		$("#LINKS").load("PremiumgraphsIOS/onlylink_ios.jsp?DEVICE="+"<%=Device%>"+"&VALUE="+"<%=arr[1]%>");	
	});
	

	$("#2").click(function() {
		//alert("CLICKED");
		$("#LINKS").empty();
		$('.cssload-container').show();
		$("#LINKS").load("PremiumgraphsIOS/onlylink_ios.jsp?DEVICE="+"<%=Device%>"+"&VALUE="+"<%=arr[2]%>");	
	});
	

	$("#3").click(function() {
		//alert("CLICKED");
		$("#LINKS").empty();
		$('.cssload-container').show();
		$("#LINKS").load("PremiumgraphsIOS/onlylink_ios.jsp?DEVICE="+"<%=Device%>"+"&VALUE="+"<%=arr[3]%>");	
	});
	

	$("#4").click(function() {
		//alert("CLICKED");
		$("#LINKS").empty();
		$('.cssload-container').show();
		$("#LINKS").load("PremiumgraphsIOS/onlylink_ios.jsp?DEVICE="+"<%=Device%>"+"&VALUE="+"<%=arr[4]%>");
						});

			});

	function showDiv(option) {

		$('.cssload-container').hide();

	}
</script>

<body onload="showDiv()" id="ce">
	<%@include file="CombinedHeader.jsp"%>
	<div class="cssload-container">
		<div class="cssload-whirlpool"></div>
	</div>

	<div id="container" style="margin-top: 5%">
		<%
			long firstvalue[] = new long[5];
			if (alertData1.size() != 0) {
		%>
		<div id="digitaljourney"
			style="height: 46%; width: 22%; background-color: white; color: black; margin-left: 1%; float: left; margin-top: 1%;">
			<b style="color: #001966">LAST 5 DIGITAL JOURNEY'S</b>
			<div class="cell">
				<%
					for (int i = 0; i < arr.length; i++) {

							if (arr[i] != 0l) {
				%><font size="2"><p>

						<%
							str = new SimpleDateFormat("dd MMM yyyy - HH:mm").format(arr[i]);
						%>
						<%=str%>
						<%
							System.out.println(arr[i]);
										String path = GetBandwidthPremiumUser.SelectPicturePathIOS(Device, arr[i]);
										System.out.println(path);
						%>
					</font>
				<button id=<%=i%>>view</button>

				<img src=<%=path%> style="width: 6%; padding-top: 1%" align="top">
				</p>

				<%
					}
						}
				%>
			</div>
		</div>

		<div id="devicedetails"
			style="height: 26%; width: 22%; background-color: white; margin-left: 1%; float: left; margin-top: 20%; position: absolute; float: left;">
			<b style="color: #001966">DEVICE DETAILS</b>
			<p>
				<font size="2"> Device Name - <b> <%
 	//MongoClient mongoClient = new MongoClient( "52.24.170.28" , 27017 );
 		//DB con1 = mongoClient.getDB( "NewJIOData" );
 		//DB con1 = CommonDB.JIOConnection();
 		DBCollection collection = db.getCollection("IOSData");
 		String uuid = request.getParameter("Device").trim();
 		System.out.println(uuid);
 		BasicDBObject bdb = new BasicDBObject();
 		bdb.put("UUID", uuid);
 		DBObject curso = collection.findOne(bdb);
 		String name = String.valueOf(curso.get("Mobilename"));
 		String andrver = String.valueOf(curso.get("os_version"));
 		String appver = String.valueOf(curso.get("App_ver"));
 		out.println(name);
 %>
				</b></font>
			</p>
			<p>
				<font size="2">IOS Version - <%=andrver%></font>
			</p>
			<p>
				<font size="2">Application Version - <%=appver%></font>
			</p>
		</div>
		<%
			}
		%>
		<div id="daterange">
			<form action="HotuserIOS.jsp?Device=<%=Device%>" method="post"
				onsubmit="return CheckDateValue()">
				<p style="display: inline;">
					&nbsp;&nbsp;&nbsp; <span style="color: #001966;"><b>From:&nbsp;&nbsp;</b>
						<input type="text" id="datepicker1" name="from"
						style="width: 30%;" readonly="true" placeholder="mm/dd/yyyy"> </span> &nbsp;&nbsp;&nbsp; <span
						style="color: #001966;"><b>To:&nbsp;&nbsp;</b> <input
						type="text" id="datepicker2" name="to" style="width: 30%;" readonly="true" placeholder="mm/dd/yyyy">
					</span>
					<%-- <input type="hidden" name="Device" value=<%=Device%> /> --%>
				</p>
				<input type="submit" value="Find" width="5%">
			</form>
		</div>
		<%
			if (alertData1.size() != 0) {
		%>
		<div id="LINKS" style="padding-top: 2%">


			<%-- 	<%@include file="premiumgraphs/onlylink.jsp"%> --%>
			<jsp:include page="PremiumgraphsIOS/onlylink_ios.jsp">
				<jsp:param name="DEVICE" value="<%=Device%>" />
				<jsp:param name="VALUE" value="<%=arr[0]%>" />

			</jsp:include>

		</div>
		<%
			} else {
		%>
		<div id="nodata" style="margin-top: 6%; text-align: center;">
			<b>No Data on this Date</b>
		</div>
		<%
			}
		%>

	</div>
	<%@include file="Footer.jsp"%>
</body>
</html>