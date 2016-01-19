<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.mongodb.DBCursor"%>
<%@page import="com.mongodb.DBObject"%>
<%@page import="com.mongodb.BasicDBObject"%>
<%@page import="com.mongodb.DBCollection"%>
<%@page import="com.mongodb.DB"%>
<%@page import="com.mongodb.MongoClient"%>
<%@page import="com.avekshaa.cis.database.CommonUtils"%>
<%@page import="com.avekshaa.cis.database.CommonDB"%>
<%@page import="java.util.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>UserExperience |CIS</title>
		<link rel="stylesheet" type="text/css" href="css/style1.css" />
		<link rel="stylesheet" type="text/css" href="css/style.css" />
		<link href="../css/button.css" rel="stylesheet" type="text/css" />
		<script src="http://code.jquery.com/jquery-1.9.1.js" type="text/javascript"></script>
		<script src="http://code.highcharts.com/highcharts.js"></script>
		<script src="http://code.highcharts.com/modules/exporting.js"></script>
	   	<script type="text/javascript" src="js/modernizr-1.5.min.js"></script>
		<style type="text/css">
		body{
			margin:0px;
		}
			#sidecontainer
			{
				width: 1355px; 
				height: 70px; 
				text-align:center;
				background-color:black;
				color:white;
				margin-top : 2%;
				border-radius:8px;
				font-family:times new roman;
				font-size:20px;
			}
			#sidecontainer p 
			{
    			display: none;
    			color: #000000;
				font-size:15px;
				height:50px;
			}
			#sidecontainer:hover p {
    			background-color: rgba(135, 206, 250, 0.9);
    			display: block;
			}
			div.hr {
  				height: 5px;
				background-color:black;
			}
			div.hr hr {
  				display: none;
			}
		</style>
	</head>

	<body>
		
		<%@include file="Header.jsp" %>
	<%@include file="BranchMenu.jsp" %>
		<!-- <form action="LiveResponseCustomized.jsp">
       		<button name="Back" style="border-radius:5px;width:80px;height:35px;right:0px;position:absolute;top:115px;"><B>Back</B></button>
       	</form> -->
		<%
		String ipAddress = request.getHeader("X-FORWARDED-FOR");
		if (ipAddress == null) 
		{  
	   		ipAddress = request.getRemoteAddr();  
		}
		System.out.println(ipAddress);
		DateFormat dF = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss:SSS");
		DBCursor exectime = null;
		String start=null;
		String[] splitExec_time=null;
		DBCollection coll=null;
		String Epoch_Time=null;
		String IP_user=null;
		String URL_user=null;
		String[] indSplit=null;
		String firstSplit=null;
		int k=0;
		try{
 			start=request.getParameter("start"); 
			System.out.println(start);
		}
		catch(Exception e){
			System.out.println("Error at getParameter request");
		}
		int cont=100;
		try{
			
			//MongoClient mongo = new MongoClient("52.24.170.28",27017);
			//MongoClient mongo = new MongoClient("127.0.0.1",27017);
			DB db = CommonDB.getExtensionDataConnection();
 			coll = db.getCollection("mycollection1");
 		}
		catch(Exception e){
			System.out.println("Mongo connection problem"+e);
		}
		splitExec_time=start.split(",");
		for(int z=0;z<splitExec_time.length;z++){
			firstSplit=splitExec_time[z];
			System.out.println("firstSplit= "+firstSplit);
			indSplit=firstSplit.split("__");
			IP_user=indSplit[0];
			URL_user=indSplit[1];
			Epoch_Time=indSplit[2];
			System.out.println(IP_user);
			System.out.println(Epoch_Time);
			System.out.println(URL_user);
			cont=cont+1;
	 		Date date1 = dF.parse(Epoch_Time);
	 		long epoch=date1.getTime();
			System.out.println(epoch); 
			String s = String.valueOf(epoch);
			String kb="NumberLong("+"\""+s+"\""+")";
			System.out.println(kb+"gfgf");
			int countExec=0;
			long a2b=Long.parseLong(s);
			//long oo=epoch;
			try{
				BasicDBObject bdb=new BasicDBObject("exectime",a2b);
				System.out.println("fgefuiaeioijdoiaewuguiwe");
				exectime =coll.find(bdb);
 				countExec=exectime.size();
				System.out.println("count first is= "+countExec);
				if(countExec>1)
				{
				
					BasicDBObject bdb1=new BasicDBObject("exectime",kb).append("IP_Address",IP_user);
					exectime=coll.find(bdb1);
					countExec=exectime.size();
				}
				
				exectime.sort(new BasicDBObject("Start_Time", -1));		
				String url;
				BasicDBObject h = (BasicDBObject)exectime.next();
				System.out.println("next"+h);
				url = h.getString("URI");
				System.out.println(url);
				String tym = h.getString("response_time");
				System.out.println(tym);
				String ld = h.getString("Start_Time");
				System.out.println(ld);
				String fb = h.getString("TTFB");
				System.out.println(fb);
				String ip = h.getString("IP");
				System.out.println(ip);
				String num =(h.getString("Total_res"));
				String browser = h.getString("Browser");
				String platform = h.getString("OS");
				String domelement = h.getString("DOMELEMENT");
				int count = Integer.parseInt(num);
				count=count*5;
				
            	%> 
				<script type="text/javascript">
				$(function () 
				{
    				$('#<%=cont%>').highcharts({
        				chart: {
            				type: 'column',
            				zoomType: 'x',
            				panning: true,
            				panKey: 'shift'
        				},
        				title: {
            				text: 'Web Performance'
        				},
        				subtitle: {
            				text: 'Click and drag to zoom in. Hold down shift key to pan.'
        				},
        				xAxis: {
            				categories: [<%
          		
            					String wrk=h.getString("Resources");
            					
            					int x=0;
            					String data="";
            					String[] temp = wrk.split("\"");
            					System.out.println(temp[4]);
            					StringBuilder xaxis = new StringBuilder();
            					for(x=1;x<(count/5)*2;x=x+2)
            					{
            						xaxis.append("'"+temp[x]+ "',");
            					}
            					data=xaxis.toString();
								out.println(data);	
                        	%> ]
        				},
        				yAxis: {
            				min: 0,
            				title: {
                				text: 'Time (msec)'
            				},
            				stackLabels: {
                				enabled: true,
                				style: {
                    				fontWeight: 'bold',
                    				color: (Highcharts.theme && Highcharts.theme.textColor) || 'gray'
                				}
            				}
        				},
        				legend: {
            				align: 'right',
            				x: -30,
            				verticalAlign: 'top',
            				y: 25,
            				floating: true,
            				backgroundColor: (Highcharts.theme && Highcharts.theme.background2) || 'white',
            				borderColor: '#CCC',
            				borderWidth: 1,
            				shadow: false
        				},
        				tooltip: {
            				formatter: function () {
                				return '<b>' + this.x + '</b><br/>' +
                    			this.series.name + ': ' + this.y + '<br/>' +
                    			'Total: ' + this.point.stackTotal;
            				}
        				},
        				plotOptions: {
            				column: {
                				stacking: 'normal',
                				dataLabels: {
                    				enabled: true,
                    				color: (Highcharts.theme && Highcharts.theme.dataLabelsColor) || 'white',
                    				style: {
                        				textShadow: '0 0 3px black'
                    				}
                				}
            				}
        				},
        				series: [{
            				name: 'Duration',
            				data: [ <%
                   				int q=0;
            					float[] net = new float[500];
            					float[] resp = new float[500]; 
                   				float[] duration=  new float[500];
                   				String wrk1=h.getString("Resources");
    							String data1="";
    							StringBuilder df = new StringBuilder();
    							StringBuilder df1 = new StringBuilder();
    							StringBuilder df2 = new StringBuilder();
    							for(x=2;x<(count/5)*2;x=x+2)
    							{
    								String[] temp1= temp[x].split(",");
    								duration[q]=Float.parseFloat(temp1[1]);
    								net[q]=Float.parseFloat(temp1[2]);
    								resp[q]=Float.parseFloat(temp1[4]);
    								df.append(duration[q]+ ",");
    								df1.append(resp[q]+ ",");
    								df2.append(net[q]+ ",");
    								q++;
    							}
    							data1=df.toString();
								out.println(data1);
        					%> ]
        				}, 
        				{
            				name: 'Response',
            				data: [ <%
                    			String data2="";
                  				data2=df1.toString();
								out.println(data2);
            				%> ]
        				}, 
        				{
            				name: 'Network',
            				data: [ <% 
                  				
    							String data3="";
    							data3=df2.toString();
								out.println(data3);
            				%> ]
        				}]
    				});
				});

				</script>
				<script type="text/javascript" src="js/modernizr-1.5.min.js"></script>
			</head>
			<body>
 			<ul>
			</ul>
			
 			<div style="top:50px;">
   				<div id="sidecontainer" >
 					<span>URL:<%=url %></span>
 					<p><b>Start Time: <%=ld %>&nbsp;&nbsp;&nbsp; Load Time: <%=tym %>msec&nbsp;&nbsp;&nbsp; 
 					Time to First Byte: <%=fb %>msec
 					&nbsp;&nbsp;&nbsp;Browser Name:<%=browser %>&nbsp;&nbsp;&nbsp;Platform Name:<%=platform %>
 					&nbsp;&nbsp;&nbsp;Dom Element:<%=domelement%>&nbsp;&nbsp;&nbsp; Number of connection:<%=num %>
 					</b> </p>
 				</div>  
				<div id=<%=cont%> style="width: 1355px; right:20px;"></div>
			</div>
			<div class="hr"><hr /></div>
			<br>       </br>
			<div id="display"></div>
   			
	  		<% 
			}
			catch(Exception e){
				System.out.println("Data for selected point not found "+e);
			}
		}%>
		
		<%@include file="Footer.jsp" %>
	</body>
</html>