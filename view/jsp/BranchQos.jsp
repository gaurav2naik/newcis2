<%@page import="java.util.Map"%>
<%@page import="com.avekshaa.cis.Java.AndroidMap"%>
<%@page import="com.avekshaa.cis.database.CommonThreshold"%>
<%@page import="com.avekshaa.cis.jio.GetChartDataForBranchQos"%>
<%@page import="com.mongodb.DBObject"%>
<%@page import="com.avekshaa.cis.engine.get_Fatal_data"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.TreeMap"%>
<%@page import="com.avekshaa.cis.engine.one_day_hits_data"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.avekshaa.cis.engine.GetChartDataForBranch"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.avekshaa.cis.jio.GetChartData"%>
<%@page import="java.util.List"%>
<%@page import="com.avekshaa.cis.database.CommonUtils"%>


<%

	String role = (String) session.getAttribute("Role");
String IpAddress=request.getParameter("Device");
if(IpAddress==""||IpAddress==null){
	IpAddress="127.0.0.1";
}
System.out.println("IpAddress :"+IpAddress);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="icon" href="../image/title.png" type="image/png">
<link href="../css/index.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" href="../css/button.css">
<script src="../script/jquery.min.js"></script>
<script src="../script/jquery.js"></script>
<script src="../script/highcharts.js"></script>
<script src="../script/exporting.js"></script>

<title>Customer Experience|CIS</title>
<style type="text/css">
#graph1 {
	height: 27%;
	width: 42%;
	background: white;
	color: white;
	margin-left: 5%;
	margin-top: 23%;
	float: left;
	background-color: white;
	position: absolute;
}

#graph2 {
	height: 27%;
	width: 42%%;
	background: white;
	color: white;
	margin-left: 51%;
	margin-top: 23%;
	float: left;
	background-color: white;
	position: absolute;
}
#graph3 {
	height: 34%;
	width: 42%;
	background: white;
	color: white;
	margin-left: 5%;
	margin-top: 4%;
	float: left;
	background-color: white;
	position: absolute;
}

#graph4 {
	height: 34%;
	width: 42%;
	background: white;
	color: white;
	margin-left: 51%;
	margin-top: 4%;
	float: left;
	background-color: white;
	position: absolute;
}
</style>
<script type="text/javascript">
	function loadGraph() {
		console.log("loadGraph is called");
		//$('#graph3').load('../dashboardgraph/branchResponse.jsp');
		//$('#graph4').load('TopFiveUrl.jsp');
		loadResponseAcrossApplicationVer();
		loadResponseAcrossAndroidVer()
	}

</script>
<script type="text/javascript">
		
		//=----------------------------critical errors----------------------//
		$(function () {
    $('#graph1').highcharts({
        chart: {																																											
            type: 'column'
        },
        title: {                                
            text: 'Critical Incidents',
            style: {
                fontSize: '14px',
              /*   fontWeight : 'bold', */
                fontFamily: 'Verdana, sans-serif'
            }
        },
        subtitle: {
            text: ''
           <%-- text: '<a href = "http://avekshaa.com">1 Day Data</a>' --%>
            	},
        exporting :  {
              enabled:false
              
               },
               
               credits: { 
               	
               	enabled: false
               	
               },
                    
                  	
            	xAxis: {
            		 categories: [<%=GetChartDataForBranchQos.CrashCategoryData%>],
             type: 'category',
            labels: {
                rotation: -45,
                /* style: {
                    fontSize: '13px',
                    fontFamily: 'Verdana, sans-serif'
                } */
            } 
        },
        yAxis: {
            min: 0,
            title: {
                text: 'Crash Count'
            }
        },
        legend: {
            enabled: false
        },
        tooltip: {
        	/*  headerFormat: 'Time:<b>{point.x}</b><br/>',
            pointFormat: 'Crash Count : <b>{point.y} </b>' */
        	formatter : function() {
				return 'Time: <b>' + this.point.extra
						+ '</b><br>Crash Count :<b>'
						+ this.y + '</b>';
			},
			valueSuffix : ''
            
        },
        series: [
                 {
                	 name: 'Web',
                	 data:[
                	       <%
                	       String branchCrashData = GetChartDataForBranchQos.getBranchCrashData(1,IpAddress ); 
                	       out.print(branchCrashData);
                	       %>
                	       ]
                 },
                 
                 
                 ]
    });
});
		
//--------------top five url---------------------------//

$(function () {
	<%
	String data="";
	data=GetChartDataForBranchQos.getBranchTopFiveURL(1, IpAddress);
%>
    $('#graph4').highcharts({
        chart: {
            type: 'bar'
        },
        title: {
            text: 'TOP URLs AND PERFORMANCE',
            style: {
                fontSize: '14px',
              /*   fontWeight : 'bold', */
                fontFamily: 'Verdana, sans-serif'
            },
        },
        exporting : {
			enabled : false
		},
        subtitle: {
            text: ''
        },
        xAxis: {
            categories: [''],
            title: {
                text: ''
            },
            labels:{
            	enabled:false
            }
        },
        yAxis: {
            min: 0,
            title: {
                text: 'Avg Response Time (ms)',
                align: 'high'
            },
            labels: {
                overflow: 'justify'
            }
        },
        tooltip : {
        	formatter : function() {
				return 'URI: <b>' + this.point.extra
						+ '</b><br>Avg:<b>'
						+ this.y + ' ms </b>';
			},
			valueSuffix : 'ms',
			
		},
        plotOptions: {
            bar: {
                dataLabels: {
                    enabled: true
                }
            }
        },
        legend: {
            layout: 'vertical',
            align: 'right',
            verticalAlign: 'top',
            x: -40,
            y: 80,
            floating: true,
            borderWidth: 1,
            backgroundColor: ((Highcharts.theme && Highcharts.theme.legendBackgroundColor) || '#FFFFFF'),
            shadow: true,
          enabled:false
        },
        credits: {
            enabled: false
        },
        series: [{
           	name:'Avg',
            data: [<%=data%>]
        }]
    });
});

//-------------------------------------------------------AVG RESPONSE----------------

$(function() {
		<% 
	String responseAppData = GetChartDataForBranchQos.getBranchResposeData(1, IpAddress); 
		%>
		$('#graph3')
				.highcharts(
						{
							chart:{
								type:'spline',
								zoomType: 'x'
							},
							title : {
								text : 'Avg Response per Hour (one day)',
								 style: {
				                     fontSize: '14px',
				                   /*   fontWeight : 'bold', */
				                     fontFamily: 'Verdana, sans-serif'
				                 },
								x : -20
							//center
							},
							subtitle : {
								text : '',
								x : -20
							},

							exporting : {
								enabled : false
							},
							legend:{
								enabled : false,
								layout:'vertical',
								verticalAlign:'midil',
								y:25,x:-200,
								itemStyle:{
									fontSize:'10px',
									font:'10pt'
								}
							},
							xAxis : {

								labels : {
									enabled : true
								},

								categories : [<%=GetChartDataForBranchQos.CrashCategoryData%>],
								labels : {
									rotation : -45,
								/* style: {
								    fontSize: '13px',
								    fontFamily: 'Verdana, sans-serif'
								} */
								}
							},
							yAxis : {
								title : {
									text : 'Avg response<b>(ms)</b>'
								},
								min : 0,
								plotLines : [ {
									value : <%=CommonThreshold.getWebThreshold()%>,
									//width : 1,
									color : 'red',
									width : 2,
									label : {
										text : 'Web Threshold',
										x : 0,
										y : 15,
										style : {
											fontSize : '10px',
											color : 'red'
										}
									},
									dashStyle : 'ShortDash'
								} 
							]
							},
							tooltip : {

								formatter : function() {
									return 'Time: <b>' + this.point.extra
											+ '</b><br>Response Time :<b>'
											+ this.y + '</b> ms';
								},
								valueSuffix : ''
							},
							credits : {
								enabled : false
							},
							series : [ {
								name:'Web Response',
								showInLegend : true,
								threshold :<%=CommonThreshold.getWebThreshold()%>,
								negativeColor : 'green',
								color : 'red',
								 marker: {
						                symbol: 'triangle'
						            },
								data :
								[ <%out.print(responseAppData);%> ]

							}
							]
						});
	});

//peak branch hits

$(function(){
	$(function () {
	    $('#graph2').highcharts({
	        chart: {
	            type: 'line',
	            zoomType: 'x'
	        },
	        
	        exporting :
	        {
	            enabled:false
	        },
	        title: {
	            text: 'Number Of Hits Per Hour (one day)',
	            style: {
                    fontSize: '14px',
                  /*   fontWeight : 'bold', */
                    fontFamily: 'Verdana, sans-serif'
                }
	        },
	        subtitle: {
	            text:''
	        },
	        credits: { 
	        	
	        	enabled: false
	        	
	        },
	        tooltip: {
	        	/*  headerFormat: 'Time:<b>{point.x}</b><br/>',
	            pointFormat: 'Hits : <b>{point.y} </b>' */
	            
	            	formatter : function() {
						return 'Time: <b>' + this.point.extra
								+ '</b><br>Hits :<b>'
								+ this.y + '</b>';
					},
					valueSuffix : ''
	        },
	        	        
	        xAxis: {
	        	
	           categories: [<%=GetChartDataForBranchQos.CrashCategoryData%>],
	           labels: {
              rotation: -45,
              /* style: {
                  fontSize: '13px',
                  fontFamily: 'Verdana, sans-serif'
              } */
          } 
	        },
	        yAxis: {
	            title: {
	                text:''
	            },
	            min:0
	        
	        },
	        plotOptions: {
	            line: {
	                dataLabels: {
	                    enabled: false
	                },
	                enableMouseTracking: true
	            }
	        },
	        series: [
	                 {
	     	        	name:'Web Hits',
	     		           
	     		         showInLegend: false,  
	     		         enabled : false,
	     		           data: [<%out.print(GetChartDataForBranchQos.getBranchHitsData(1, IpAddress));%>]
	     	    },
	             
	        ]
	    });
	});
});
		
		

	
</script>
</head>
<body onload="loadGraph()" id="br_qos">
	<%@include file="BranchHeader.jsp"%>
	<div id="container" style="margin-top: 5%">
	<!-- <div style="margin-top: 2%; width: 100%;float: left">
		<div class="abd"
			style="width: 10%; display: inline; border-right: 1px solid black; padding-right: 1%; padding-left: 1%;"
			id="1daysdata">
			Branch
		</div>
	</div> -->
	<div style="margin-left: 2%;float:left;padding-top: 5px">Branch Name: <%=GetChartDataForBranchQos.GetBranchName(IpAddress) %></div>
		<form action="#" method="post" 
			style="float: right; padding-right: 10px; padding-top: 5px;"
			name="CustexpDeviceSelectionForm">
			Select Branch : <select name='Device' id='Device'
				onclick="javascript:$('#err').html('');">

				<%
					List<DBObject> BranchName = CommonUtils.getBranches();
					//System.out.println("BranchName device"+BranchName);
					if (BranchName.size() < 1) {
				%>
				<option value="noDevice" selected="selected">No Device</option>
				<%
					} else {
				%>
				<option value="select" selected="selected">Select</option>
				<%
					}
					for (int i = 0; i < BranchName.size(); i++) {

						String IP = (String) BranchName.get(i).get("IP_Address");
						String branchName=(String) BranchName.get(i).get("Branch_Name");
						////System.out.println("IPPPPPPPPPPPPPPP"+IP);
						//String endpointDesc = (String) alertData.get(IP);
				%>
				<option value="<%out.println(IP);%>">
					<%
						out.println(branchName);
					%>
				</option>
				<%
					}
				%>

			</select> <input type="submit" value="Submit" id="submit"
				onclick=" return checkFormSubmitData(); " />

			<div id="err" style="color: red; text-align: right; padding: 2px;"></div>
		</form>

		<div id="container">
			<div id="graph1"></div>
			<div id="graph2"></div>
			<div id="graph3"></div>
			<div id="graph4"></div>

		</div>
	</div>
	<%@include file="Footer.jsp"%>
	<script>
		function checkFormSubmitData() {
			//alert("hello");
			var status = document.CustexpDeviceSelectionForm.Device.value;

			if (status == "noDevice") {
				$("#err").html(
						"<h6 style='color:#0A29B0'>No Branch Selected</h6>");
				//alert("No new Devices to Add!!!")
				return false;
			} else if (status == "select") {
				$("#err")
						.html(
								"<h5 style='color:red;margin-top:0'>Please Select Some Branch</h5>");
				//alert("Please Select Some Device!!!");
				return false;
			} else {
				return true;
			}
		}
		/* function SetData() {
			//	alert("hello")
			var select = document.getElementById('Device');
			var uuid = select.options[select.selectedIndex].value;
			document.CustexpDeviceSelectionForm.action = "Hotuser.jsp?Device="
					+ uuid;
			myform.submit();
		} */
	</script>
</body>
</html>