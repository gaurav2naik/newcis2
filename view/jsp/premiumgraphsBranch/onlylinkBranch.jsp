<%@page import="com.avekshaa.cis.premiumusers.GetBandwidthPremiumUser"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.avekshaa.cis.premiumusers.*"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="com.mongodb.DB"%>
<%@page import="com.mongodb.DBCollection"%>
<%@page import="com.mongodb.BasicDBObject"%>
<%@page import="com.mongodb.DBCursor"%>
<%@page import="com.mongodb.DBObject"%>
<%@page import="java.util.*"%>
<%@page import="com.avekshaa.cis.database.*"%>
<%@page import="java.text.NumberFormat"%>

<style>
#averespcircle {
	width: 80px;
	height: 80px;
	border-radius: 80px;
	margin-left: 28%;
	position: absolute;
	display: relative;
}

#appcrashcircle {
	width: 80px;
	height: 80px;
	border-radius: 80px;
	margin-left: 53%;
	position: absolute;
	display: relative;
}

#buffercircle {
	width: 80px;
	height: 80px;
	border-radius: 80px;
	margin-left: 79%;
	margin-top: -7%;
}


#circleText {
	padding-top: 40%;
}


.button {
 
 /*Step 2: Basic Button Styles*/
 display: block;
 height: 15px;
 width: 150px;
 background: #34696f;
 border: 2px solid rgba(33, 68, 72, 0.59);
 
 /*Step 3: Text Styles*/
 color: white;
 text-align: center;
 /* font: bold 3.2em/100px "Helvetica Neue", Arial, Helvetica, Geneva, sans-serif; */
 
 /*Step 4: Fancy CSS3 Styles*/
 background: -moz-linear-gradient(bottom, #000000 0%, #222222 50%, #3c3c3c 51%,
		#393939 78%, #888888 100%);
	background: -webkit-linear-gradient(bottom, #000000 0%, #222222 50%, #3c3c3c 51%,
		#393939 78%, #888888 100%);
	background: -o-linear-gradient(bottom, #000000 0%, #222222 50%, #3c3c3c 51%, #393939
		78%, #888888 100%);
	background: -ms-linear-gradient(bottom, #000000 0%, #222222 50%, #3c3c3c 51%,
		#393939 78%, #888888 100%);
	background: linear-gradient(to top, #000000 0%, #222222 50%, #3c3c3c 51%, #393939
		78%, #888888 100%);
 
 -webkit-border-radius: 50px;
 -khtml-border-radius: 50px;
 -moz-border-radius: 50px;
 border-radius: 50px;
 
 -webkit-box-shadow: 0 8px 0 #1b383b;
 -moz-box-shadow: 0 8px 0 #1b383b;
 box-shadow: 0 0px 0 #1b383b;
 
 text-shadow: 0 2px 2px rgba(255, 255, 255, 0.2);
 
}
 
/*Step 3: Link Styling*/
a.button {
 text-decoration: none;
}
</style>


<%


System.out.println("errrrrrrrrrrrrrrrrrrrrrrrrrrrorrrrrrrrrrrr here");
		
		long value=0l;

        int count_error=0;
	
        StringBuilder Sb_responsetime =new StringBuilder();
        StringBuilder Sb_time =new StringBuilder();        
        
        String ip_address=request.getParameter("IP");
        ip_address=ip_address.trim();
        
        long value_gt=Long.parseLong(request.getParameter("VALUE_gt"));
        
        long value_lt=Long.parseLong(request.getParameter("VALUE_lt"));
        
        long average_response=0l;
		//DecimalFormat df_cpu = new DecimalFormat("###.##");
		
		
		DB dbs = CommonDB.getConnection();
		
		try
		{
		DBCollection colls = dbs.getCollection("CISResponse");
	
		BasicDBObject andQuery = new BasicDBObject();
		
		
		if(value_lt==0)
		{
		
			andQuery.put("exectime", new BasicDBObject("$gt",value_gt));
			andQuery.put("IP_Address", ip_address);
		}
		else
		{
			
			andQuery.put("exectime", new BasicDBObject("$gt",value_lt));	
			andQuery.put("exectime", new BasicDBObject("$lt",value_gt));
			andQuery.put("IP_Address", ip_address);
			
		}
		
		
		DBCursor cursor = colls.find(andQuery).limit(24);
	
		List<DBObject> link1_list = cursor.toArray();
		
		//System.out.println(link1_list.size());
		
		for(int i = link1_list.size()-1;i >=0 ; i--)
		{
			
			DBObject obj1 = link1_list.get(i);
			
			//String response_time = obj1.get("response_time").toString();
			//String time= new SimpleDateFormat("HH:mm:ss").format(obj1.get("request_time"));
			
			Sb_responsetime.append(obj1.get("response_time").toString()).append(",");
			
			Sb_time.append("\"").append(new SimpleDateFormat("HH:mm:ss").format(obj1.get("exectime"))).append("\",");
			
			
			average_response+=Long.parseLong(obj1.get("response_time").toString());
			
			if(Long.parseLong(obj1.get("status_Code").toString())>399)
			{
				count_error++;
			}
			
		} 
		
		average_response=average_response/link1_list.size();
	
		
		
%>


<script>
	

	$(function() {
		$('#Responsegraph').highcharts({
			exporting : {
				enabled : false
			},
			chart : {
				type : 'line',
				zoomType : 'x'
			},
			title : {
				text : 'Response time (ms)',
				x : -20
			//center
			},
			/* subtitle: {
			    text: 'Source: WorldClimate.com',
			    x: -20
			}, */
			credits : {
				enabled : false

			},
			xAxis : {
				categories : [<%=Sb_time%>],
				labels : {
					enabled : true
				},
			},
			yAxis : {
				title : {
					text : 'RAM Usage'
				},
				min : 0,
				plotLines : [ {
					value : 0,
					width : 1,
					color : '#0441ff'
				} ]
			},
			tooltip : {
				/* valueSuffix : ' MB', */
				headerFormat: '<span style="font-size:10px;color:{series.color}">Time:</span><b>{point.key}</b><table>',
	            pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
	                '<td style="padding:0"><b>{point.y:.1f}ms </b></td></tr>',
	            footerFormat: '</table>',
	            shared: true,
	            useHTML: true
			},
			legend : {
				layout : 'vertical',
				align : 'right',
				verticalAlign : 'middle',
				borderWidth : 0
			},

			series : [

			{

				showInLegend : false,
				name : 'Response Time',
				data : [<%=Sb_responsetime%>],
				color : '#0441ff'

			},

			]
		});
	});
	
 $('.cssload-container').hide();
  
</script>

<p style="margin-left: 15%; margin-top: -1%; color: #001966;float: left">
	<b>User Experience on <%out.println(new SimpleDateFormat("dd MMM yyyy").format(value_gt)+" at "+new SimpleDateFormat("HH:mm").format(value_gt));%></b>
</p>
<p style=" margin-left:22%;margin-top: -1%; color: #001966;float: left">
	<b> <a href="LiveResponseCustomized.jsp" class="button" style="border:1px blue;">Detailed Analysis</a></b>
</p>
<%String clr_av="green"; if (average_response>=1){clr_av="red"; }%>
<div id="averespcircle"
	style="text-align: center; background: <%=clr_av%>;margin-top:1%"><br>
	<p style="text-aling: center;  color: white"><%=average_response%>
		(ms)
	</p>
	<p id="circleText">Average Response Time</p>
</div>

<%String clr_c="green"; if (count_error>=1){clr_c="red"; }%>
<div id="appcrashcircle"
	style="text-align: center;  background: <%=clr_c%>;margin-top:1%"><br>
	<p style="text-aling: center;  color: white"><%=count_error%></p>
	<p id="circleText">Critical Web Errors</p>
</div><br><br><br><br>

<%String clr="green"; if (10>=5){clr="red"; }%>



<div
	style="height: 68%; width: 73%; background-color: white; color: black; margin-left: 20%; float: left; margin-top: 7%; position: absolute; padding-bottom: 6%">

	<div id="Responsegraph"
		style="height: 40%; width: 100%; background-color: white; color: black; margin-left: 1%; float: left; margin-top: 4%; /* border-style: solid; border-width: medium; border-color: red ;*/ position: absolute;"></div>

    <div id="ScrollTable"
		style="height: 40%; width: 100%; background-color: white; color: black; margin-left: 3%; float: left; margin-top: 30%; /* border-style: solid; border-width: medium; border-color: red; */ position: absolute;">
		
	
	<table style="width: 100%" cellpadding="0" cellspacing="0" border="1" bgcolor="#006BB2" >
	<tr>
	  <td align="center" width="200px">User Name</td>
	  <td  width="200px">URL</td>
	  <td align="center" width="200px">Response Time</td>
	  <td align="center" width="200px">State</td>
	  <td align="center" width="200px">City</td>
	</tr>
	</table>

	<div style="overflow: auto;height: 150px; width: 100%;">

		  <table style="width: 100%;" cellpadding="0" cellspacing="0" >
		 
		 
		<%  for(int i = link1_list.size()-1;i >=0 ; i--)
		{
			
			DBObject obj1 = link1_list.get(i);
			
			//String response_time = obj1.get("response_time").toString();
			//String time= new SimpleDateFormat("HH:mm:ss").format(obj1.get("request_time"));
			
			
		%>
		 
		  
		 
 		  <tr>
		    <td align="center" width="200px"><%=obj1.get("IP_Address").toString()%></td>
		    <td  width="200px"><%=obj1.get("URI").toString()%></td>
		    <td align="center" width="200px"><%=obj1.get("response_time").toString()%></td>
		    <td align="center" width="200px"><%=obj1.get("State").toString()%></td>
		    <td align="center" width="200px"><%=obj1.get("City").toString()%></td>
		  </tr>
	
	
	     <%} %>
		  
		  </table>

    </div>



	</div>




</div>



</body>
</html>
		



<%}catch(Exception e){
		e.printStackTrace();
	
} %>

