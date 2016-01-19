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
	 DB db=CommonDB.getConnection();
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
	String str=null;
    
    //String IPAddres = "115.99.230.219";///passfrom input box in get request
	
	String IPAddres=request.getParameter("Device");
	if (IPAddres == null || IPAddres == "") {
		//System.out.println("hello;;");
		response.sendRedirect("BranchCustomerExperience.jsp");
		return;
	}
    IPAddres=IPAddres.trim();
	
	//System.out.println("-----------------"+IPAddres);
	String from = request.getParameter("from");
	String to = request.getParameter("to");
	//System.out.println(from + "-----=============================----------" + to);
	List Data1 = null;
	
	long from_timestamp = 0l;
	long to_timestamp = 0l;
	//DB androidconn = CommonDB.getBankConnection();
	DBCollection coll = db.getCollection("CISResponse");
	BasicDBObject Query = new BasicDBObject();
	if (from != null && to != null && from != "" && to != "") {
		DateFormat formatter;
        formatter = new SimpleDateFormat("MM/dd/yyyy");
        Date date1 = (Date) formatter.parse(from);
        Date date2 = (Date) formatter.parse(to);
        from_timestamp = date1.getTime();
        to_timestamp = date2.getTime();
        Query.put("IP_Address", IPAddres);
		Query.put("URI", "/Banking/index.jsp");
        //findobj1 = new BasicDBObject("UUID", IPAddres);
        Query.append("exectime", new BasicDBObject("$gt",from_timestamp+19800000).append("$lt", to_timestamp+19800000+43200000));
        Data1 = coll.distinct("exectime", Query);
	}
	else{
		Query.put("IP_Address", IPAddres);
		Query.put("URI", "/Banking/index.jsp");
		 Data1 = coll.distinct("exectime", Query);
	}
	System.out.println("_______________________"+(from_timestamp+19800000));
	System.out.println("======================="+(to_timestamp+19800000+43200000));
	System.out.println("Data1 size:: "+Data1.size());
	//List<String> arr = new ArrayList<String>();
	
	
	long arr[]=new long[5];
	
	arr[0]=0l;arr[1]=0l;arr[2]=0l;arr[3]=0l;arr[4]=0l;
	
	if(Data1.size()>5){

		for (int i = Data1.size() - 1 ,x=0; i >= Data1.size() - 5; i--,x++) 
		{
			long l = (Long) Data1.get(i);
			if (l != 0) 
			{
				long s = Long.parseLong(Data1.get(i).toString());
				arr[x]=s;
			}
		}
	}
	else{
		for (int i = Data1.size() - 1 ,x=0; i >= 0; i--,x++) 
		{
			long l = (Long) Data1.get(i);
			if (l != 0) 
			{
				long s = Long.parseLong(Data1.get(i).toString());
				arr[x]=s;
			}
		}
	}
	//arr.add(IPAddres);
	//new AveragePremiumResponseData(arr);
%>


<script>
$(document).ready(function() {
	$("#0").click(function() {
		//alert("CLICKED");
		$("#LINKS").empty();
		$('.cssload-container').show();
		$("#LINKS").load("premiumgraphsBranch/onlylinkBranch.jsp?IP="+"<%=IPAddres%>"+"&VALUE_gt="+"<%=arr[0]%>"+"&VALUE_lt="+"<%=0%>");
	});

		$("#1").click(function() {
			$("#LINKS").empty();
			$('.cssload-container').show();
			$("#LINKS").load("premiumgraphsBranch/onlylinkBranch.jsp?IP="+"<%=IPAddres%>"+"&VALUE_gt="+"<%=arr[1]%>"+"&VALUE_lt="+"<%=arr[0]%>");
		});
		$("#2").click(function() {
			$("#LINKS").empty();
			$('.cssload-container').show();
			$("#LINKS").load("premiumgraphsBranch/onlylinkBranch.jsp?IP="+"<%=IPAddres%>"+"&VALUE_gt="+"<%=arr[2]%>"+"&VALUE_lt="+"<%=arr[1]%>");
		});

		$("#3").click(function() {
			$("#LINKS").empty();
			$('.cssload-container').show();
			$("#LINKS").load("premiumgraphsBranch/onlylinkBranch.jsp?IP="+"<%=IPAddres%>"+"&VALUE_gt="+"<%=arr[3]%>"+"&VALUE_lt="+"<%=arr[2]%>");
		});

		$("#4").click(function() {
			$("#LINKS").empty();
			$('.cssload-container').show();
			$("#LINKS").load("premiumgraphsBranch/onlylinkBranch.jsp?IP="+"<%=IPAddres%>"+"&VALUE_gt="+"<%=arr[4]%>"+"&VALUE_lt="+"<%=arr[3]%>");
		});

	});

	function showDiv(option) {

		$('.cssload-container').hide();

	}
</script>

<body onload="showDiv()" id="bce">
	<%@include file="BranchHeader.jsp"%>
	<div class="cssload-container">
		<div class="cssload-whirlpool"></div>
	</div>

	<div id="container" style="margin-top: 5%">
	<%
	long firstvalue[] = new long[5];
	if(Data1.size()!=0){ %>
		<div id="digitaljourney"
			style="height: 46%; width: 22%; background-color: white; color: black; margin-left: 1%; float: left; margin-top: 1%;">
			<b style="color: #001966">LAST 5 DIGITAL JOURNEY'S</b>
			<div class="cell">
				<%
					for (int i = 0; i < arr.length; i++) {
						
						if(arr[i]!=0l)
						{	
				%><font size="2"><p>

						<%
						   str = new SimpleDateFormat("dd MMM yyyy - HH:mm").format(arr[i]);
						%>
						<%=str%>
						<%
						//System.out.println(arr.get(i));
						String path = GetBandwidthPremiumUser.SelectPicturePathBranch(IPAddres, arr[i]);
						System.out.println(path);
						%>
					</font>
				<button id=<%=i%>>view</button>
				
				<img src=<%=path%> style="width: 6%; padding-top: 1%" align="top">
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
 	DBCollection collection = db.getCollection("CISResponse");
 	
 
 	BasicDBObject bdb = new BasicDBObject();
 	bdb.put("IP_Address", IPAddres);
 	DBObject curso = collection.findOne(bdb);
 	String name = String.valueOf(curso.get("Browser"));
 	String city = String.valueOf(curso.get("City"));
 	String branch = "Branch_NUll";//String.valueOf(curso.get("App_ver"));

 	out.println(IPAddres);
 %>
				</b></font>
			</p>
			
			<p>
				<font size="2">Browser Detasils - <%=name%></font>
			</p>
			
			<p>
				<font size="2">Location - <%=city%></font>
			</p>
			
			<p>
				<font size="2">Branch Name - <%=branch%></font>
			</p>
			
		</div>
<%} %>
<div id="daterange" >
		<form action="HotuserBranch.jsp?Device=<%=IPAddres %>" method="post" onsubmit="return CheckDateValue()">
		<p style="display: inline;">
		    &nbsp;&nbsp;&nbsp;
			<span style="color: #001966;" ><b>From:&nbsp;&nbsp;</b> <input type="text" id="datepicker1" name="from" style="width: 30%; " readonly="true" placeholder="mm/dd/yyyy"> </span>
			&nbsp;&nbsp;&nbsp;
			<span style="color: #001966; "><b>To:&nbsp;&nbsp;</b>  <input type="text" id="datepicker2" name="to" style="width: 30%;" readonly="true" placeholder="mm/dd/yyyy">       </span> 
			<%-- <input type="hidden" name="Device" value=<%=Device%> /> --%> 
		</p>
		<input type="submit" value="Find" width="5%">
	    </form>
		</div>
<%if(Data1.size()!=0){ %>
		<div id="LINKS" style="padding-top: 2%">
			<%-- <%@include file="premiumgraphsBranch/link1.jsp"%> --%>
		
		    <jsp:include page="premiumgraphsBranch/onlylinkBranch.jsp" >
				 <jsp:param name="IP" value="<%=IPAddres%>" />
				 <jsp:param name="VALUE_gt" value="<%=arr[0]%>"/>
				 <jsp:param name="VALUE_lt" value="<%=0%>"/>
				 
        </jsp:include>
		</div>
<%} else{%>
			<div id="nodata" style="margin-top: 6%;text-align: center;"><b>No Data on this Date</b></div>
		<%} %>
	</div>
	<%@include file="Footer.jsp" %>
</body>
</html>