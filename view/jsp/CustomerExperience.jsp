<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.avekshaa.cis.jio.GetChartData"%>
<%@page import="com.avekshaa.cis.engine.GetChartDataForBranch"%>
<%@page import="java.util.List"%>
<%@page import="com.avekshaa.cis.database.CommonUtils"%>
<%
	String role = (String) session.getAttribute("Role");
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
	height: 30%;
	width: 17%;
	background: white;
	color: white;
	margin-left: 55%;
	margin-top: 4%;
	float: left;
	background-color: white;
	position: absolute;
}

#graph2 {
	height: 30%;
	width: 17%;
	background: white;
	color: white;
	margin-left: 77%;
	margin-top: 4%;
	float: left;
	background-color: white;
	position: absolute;
}

#graph3 {
	height: 31%;
	width: 20%;
	background: white;
	color: white;
	margin-left: 54%;
	margin-top: 21%;
	float: left;
	background-color: white;
	position: absolute;
}

#graph4 {
	height: 32%;
	width: 20%;
	background: white;
	color: white;
	margin-left: 76%;
	margin-top: 21%;
	float: left;
	background-color: white;
	position: absolute;
}

#graph5 {
	height: 34%;
	width: 42%;
	background: white;
	color: white;
	margin-left: 5%;
	margin-top: 7%;
	float: left;
	background-color: white;
	position: absolute;
}

#graph6 {
	height: 34%;
	width: 42%;
	background: white;
	color: white;
	margin-left: 4%;
	margin-top: 39%;
	float: left;
	background-color: white;
	position: absolute;
	padding-bottom: 2%;
}

#graph7 {
	height: 34%;
	width: 42%;
	background: white;
	color: white;
	margin-left: 5%;
	margin-top: 21%;
	float: left;
	/* margin-right: 1%; 
	border-style: solid;
	border-width: medium;
	border-color: yellow; */
	background-color: white;
	position: absolute;
}
</style>
<script type="text/javascript">
	function loadGraph() {
		console.log("loadGraph is called");
		$('#graph5').load('../Graph/avgResponsePerMin.jsp');
		$('#graph7').load('../Graph/avgResponsePerMinForApp.jsp');
		$('#graph6').load('networkBarGraph.jsp');
		loadResponseAcrossApplicationVer();
		loadResponseAcrossAndroidVer()
		loadResponseAcrossIOSApplicationVer();
		loadResponseAcrossIOSVer();

		// 		loadHitsCount();
	}

	var data = setInterval(function() {
		$('#graph5').load('../Graph/avgResponsePerMin.jsp');
	}, 50000);
</script>
<script type="text/javascript">
	// for applicartion sersion response 
	function loadResponseAcrossApplicationVer() {
		var chart;
		console.log(" loadResponseAcrossAndroid is called");
		$(function() {
			setInterval(function() {
				data = $.parseJSON($.ajax({
					url : '../../GetPieChartData?type=ApplicationResponse',
					dataType : "json",
					async : false
				}).responseText);
				console.log(data);
				chart.series[0].setData(data, true);

			}, 60000);
		});

		// Build the chart
		var chart = new Highcharts.Chart(
				{
					chart : {
						renderTo : 'graph1',
						plotBackgroundColor : null,
						plotBorderWidth : null,
						plotShadow : false,
						type : 'pie'
					},
					title : {
						text : 'Response Time',
						style : {
							fontSize : '14px',
							/*   fontWeight : 'bold', */
							fontFamily : 'Verdana, sans-serif'
						}

					},
					subtitle : {
						text : '(Application Ver Based) <br>Last 1 Hour',
					/* style : {
						foutSize : '10px',
					} */
					},

					credits : {
						enabled : false
					},

					exporting : {
						enabled : false
					},

					tooltip : {
						pointFormat : ''
					},
					plotOptions : {
						pie : {
							allowPointSelect : true,
							cursor : 'pointer',
							size : 120,
							dataLabels : {
								enabled : false
							},
							showInLegend : false
						},
						series : {
							cursor : 'pointer',
							point : {
								events : {
									click : function() {
										location.href = this.options.url;
									}
								}
							}
						}
					},
					series : [ {
						name : "Response Share",
						colorByPoint : true,
						dataLabels : {
							verticalAlign : 'top',
							enabled : true,
							color : '#000000',
							connectorWidth : 1,
							distance : -30,
							connectorColor : '#000000',
							formatter : function() {
								return Math.round(this.percentage) + ' %';
							}
						},
						data :
<%GetChartData chData = new GetChartData();
			out.print(chData.getApplicationVersionResponse());%>
	} ]
				});

	};

	// For android version response 
	function loadResponseAcrossAndroidVer() {
		var chart;
		console.log("loadResponseAcrossAndroidVer");
		$(function() {
			setInterval(function() {
				//var x = 100, // current time
				data = $.parseJSON($.ajax({
					url : '../../GetPieChartData?type=AndroidResponse',
					dataType : "json",
					async : false
				}).responseText);
				console.log(data);
				chart.series[0].setData(data, true);

			}, 60000);
		});

		// Build the chart
		var chart = new Highcharts.Chart(
				{
					chart : {
						renderTo : 'graph2',
						plotBackgroundColor : null,
						plotBorderWidth : null,
						plotShadow : false,
						type : 'pie'
					},
					title : {
						text : 'Response Time',

						style : {
							fontSize : '14px',
							/*   fontWeight : 'bold', */
							fontFamily : 'Verdana, sans-serif'
						}

					},
					subtitle : {
						text : '(Android Ver Based) <br>Last 1 Hour',
					/* style : {
						fontSize : '10px',
					} */
					},

					credits : {
						enabled : false
					},

					exporting : {
						enabled : false
					},

					tooltip : {
						pointFormat : ''//{series.name}: <b>{point.percentage:.1f}%</b>
					},
					plotOptions : {
						pie : {
							allowPointSelect : true,
							cursor : 'pointer',
							size : 120,
							dataLabels : {
								enabled : false
							},
							showInLegend : false
						},
						series : {
							//  cursor: 'pointer',
							point : {
								events : {
									click : function() {
										location.href = this.options.url;
									}
								}
							}
						}
					},
					series : [ {
						name : "Android Share",
						colorByPoint : true,
						dataLabels : {
							verticalAlign : 'top',
							enabled : true,
							color : '#000000',
							connectorWidth : 1,
							distance : -30,
							connectorColor : '#000000',
							formatter : function() {
								return Math.round(this.percentage) + ' %';
							}
						},
						data :
<%GetChartData chDataForAndroid = new GetChartData();
			out.print(chDataForAndroid.getAndroidVersionResponse());%>
	} ]
				});

	};

	function loadResponseAcrossIOSApplicationVer() {
		var chart;

		$(function() {
			setInterval(function() {
				//var x = 100, // current time
				data = $.parseJSON($.ajax({
					url : '../../GetPieChartData?type=IOSApplicationResponse',
					dataType : "json",
					async : false
				}).responseText);
				console.log(data);
				chart.series[0].setData(data, true);

			}, 60000);
		});

		// Build the chart
		var chart = new Highcharts.Chart(
				{
					chart : {
						renderTo : 'graph3',
						plotBackgroundColor : null,
						plotBorderWidth : null,
						plotShadow : false,
						type : 'pie'
					},
					title : {
						text : 'Response Time',
						style : {
							fontSize : '14px',
							/*   fontWeight : 'bold', */
							fontFamily : 'Verdana, sans-serif'
						}
					},
					subtitle : {
						text : '(IOS\'Application Ver Based) <br>Last 1 Hour',
					/* style : {
						foutSize : '10px',
					} */
					},

					credits : {
						enabled : false
					},

					exporting : {
						enabled : false
					},

					tooltip : {
						pointFormat : ''
					},
					plotOptions : {
						pie : {
							allowPointSelect : true,
							cursor : 'pointer',
							size : 120,
							dataLabels : {
								enabled : false
							},
							showInLegend : false
						},
						series : {
							cursor : 'pointer',
							point : {
								events : {
									click : function() {
										location.href = this.options.url;
									}
								}
							}
						}
					},
					series : [ {
						name : "Buffer Share",
						colorByPoint : true,
						dataLabels : {
							verticalAlign : 'top',
							enabled : true,
							color : '#000000',
							connectorWidth : 1,
							distance : -30,
							connectorColor : '#000000',
							formatter : function() {
								return Math.round(this.percentage) + ' %';
							}
						},
						data :
<%GetChartData chData1 = new GetChartData();
			out.print(chData1.getIOSAppVerResponse());%>
	} ]
				});

	};

	function loadResponseAcrossIOSVer() {
		var chart;
		$(function() {
			setInterval(function() {
				//var x = 100, // current time
				data = $.parseJSON($.ajax({
					url : '../../GetPieChartData?type=IOSVerResponse',
					dataType : "json",
					async : false
				}).responseText);
				console.log(data);
				chart.series[0].setData(data, true);

			}, 60000);
		});

		// Build the chart
		var chart = new Highcharts.Chart(
				{
					chart : {
						renderTo : 'graph4',
						plotBackgroundColor : null,
						plotBorderWidth : null,
						plotShadow : false,
						type : 'pie'
					},
					title : {
						text : 'Response Time',

						style : {
							fontSize : '14px',
							/*   fontWeight : 'bold', */
							fontFamily : 'Verdana, sans-serif'
						}

					},
					subtitle : {
						text : '(IOS Ver Based) <br>Last 1 Hour',
					/* style : {
						foutSize : '10px',
					} */
					},

					credits : {
						enabled : false
					},

					exporting : {
						enabled : false
					},

					tooltip : {
						pointFormat : ''//{series.name}: <b>{point.percentage:.1f}%</b>
					},
					plotOptions : {
						pie : {
							allowPointSelect : true,
							cursor : 'pointer',
							size : 120,
							dataLabels : {
								enabled : false
							},
							showInLegend : false
						},
						series : {
							//  cursor: 'pointer',
							point : {
								events : {
									click : function() {
										location.href = this.options.url;
									}
								}
							}
						}
					},
					series : [ {
						name : "Android Share",
						colorByPoint : true,
						dataLabels : {
							verticalAlign : 'top',
							enabled : true,
							color : '#000000',
							connectorWidth : 1,
							distance : -30,
							connectorColor : '#000000',
							formatter : function() {
								return Math.round(this.percentage) + ' %';
							}
						},
						data :
<%GetChartData chDataForAndroid1 = new GetChartData();
			out.print(chDataForAndroid1.getIOSVersionResponse());%>
	} ]
				});

	};
</script>
</head>
<body onload="loadGraph()" id="ce">
	<%@include file="CombinedHeader.jsp"%>
		
	<div id="container" style="margin-top: 7%">
		<div style = "width : 10%;  padding-top : 3%; color : #1691D8; float : left; text-align : left; padding-left : 9%; display : inline; position : relative;">APDEX SCORE</div>
		<%
			GetChartDataForBranch getApdexScore = new GetChartDataForBranch();
			 double apdexScore = getApdexScore.getApdexScore(); 
			//double apdexScore = 0.96;
			double apdexScore_mobile = getApdexScore.getApdexScore_mobile();
		%>
		<!-- <p style="margin-left : 25%;">Web&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Mobile</p> -->
		<%
			if (apdexScore <= 0.7) {
		%>
		<div  style = "width : 13%; margin-left : 21%;"><div style = "width : 10%; display : inline; margin-right : 56%;">Web</div><div style = "width : 10%; display : inline;">App</div></div>
		<div
			style="float: left; margin-left: 1%; text-align: center; width: 60px; height: 60px; border-radius: 60px; background-color: red; margin-right: 5%;">
			<p style="text-align: center; padding-top: 6px;"><%=apdexScore%></p>
		</div>
		<%
			}
			if (apdexScore > 0.7 && apdexScore < 0.85) {
		%>
		<div
			style="float: left; margin-left: 1%; text-align: center; width: 60px; height: 60px; border-radius: 60px; background-color: orange; margin-right: 5%;">
			<p style="text-align: center; padding-top: 6px;"><%=apdexScore%></p>
		</div>
		<%
			} else if (apdexScore >= 0.85) {
		%>
		<div
			style="float: left; margin-left: 1%; text-align: center; width: 60px; height: 60px; border-radius: 60px; background-color: green; margin-right: 5%;">
			<p style="text-align: center; padding-top: 6px;"><%=apdexScore%></p>
		</div>
		<%
			}
		%>
		<%
			if (apdexScore_mobile <= 0.7) {
		%>
		<div
			style="float: left; text-align: center; width: 60px; height: 60px; border-radius: 60px; background-color: red; margin-right: 5%;">
			<p style="text-align: center; padding-top: 6px;"><%=apdexScore_mobile%>
			</p>
		</div>
		<%
			}
			if (apdexScore_mobile > 0.7 && apdexScore_mobile < 0.85) {
		%>
		<div
			style="float: left; text-align: center; width: 60px; height: 60px; border-radius: 60px; background-color: orange; margin-right: 5%;">
			<p style="text-align: center; padding-top: 6px;"><%=apdexScore_mobile%>
			</p>
		</div>
		<%
			} else if (apdexScore_mobile >= 0.85) {
		%>
		<div
			style="float: left; text-align: center; width: 60px; height: 60px; border-radius: 60px; background-color: green; margin-right: 5%;">
			<p style="text-align: center; padding-top: 6px;"><%=apdexScore_mobile%>
			</p>
		</div>
		<%
			}
		%>
	</div>
	
	<form action="Hotuser.jsp" method="post" onsubmit="SetData()"
		style="float: right; padding-right: 10px; padding-top: 5px;"
		name="CustexpDeviceSelectionForm">
		Select Premium user : <select name='Device' id='Device'
			onclick="javascript:$('#err').html('');">
			<%
				List Devicename = CommonUtils.getPremiumdevice();
				//System.out.println("Premium device"+Devicename);
				if (Devicename.size() < 1) {
			%>
			<option value="noDevice" selected="selected">No Device</option>
			<%
				} else {
			%>
			<option value="select" selected="selected">Select</option>
			<%
				}
				for (int i = 0; i < Devicename.size(); i++) {

					String IP = (String) Devicename.get(i);
					////System.out.println("IPPPPPPPPPPPPPPP"+IP);
					//String endpointDesc = (String) alertData.get(IP);
			%>
			<option value="<%out.println(IP);%>">
				<%
					out.println(IP);
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
		<div id="graph5"></div>
		<div id="graph6"></div>
		<div id="graph7"></div>
	</div>
	
	<%@include file="Footer.jsp"%>
	<script>
		function checkFormSubmitData() {
			//alert("hello");
			var status = document.CustexpDeviceSelectionForm.Device.value;

			if (status == "noDevice") {
				$("#err").html(
						"<h6 style='color:#0A29B0'>No Device Selected</h6>");
				//alert("No new Devices to Add!!!")
				return false;
			} else if (status == "select") {
				$("#err")
						.html(
								"<h5 style='color:red;margin-top:0'>Please Select Some Device</h5>");
				//alert("Please Select Some Device!!!");
				return false;
			} else {
				return true;
			}
		}
		function SetData() {
			//	alert("hello")
			var select = document.getElementById('Device');
			var uuid = select.options[select.selectedIndex].value;

			if (uuid.indexOf("-") > -1) {
				// alert("yes conatins -");
				document.CustexpDeviceSelectionForm.action = "HotuserIOS.jsp?Device="
						+ uuid;
				myform.submit();
			} else

				document.CustexpDeviceSelectionForm.action = "Hotuser.jsp?Device="
						+ uuid;
			myform.submit();
		}
	</script>
</body>
</html>