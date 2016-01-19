<%@page import="com.avekshaa.cis.engine.GetChartDataForBranch"%>
<%@page import="com.avekshaa.cis.database.CommonThreshold"%>
<%@page import="com.avekshaa.cis.jio.GetChartData"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="com.avekshaa.cis.engine.city_avg_data"%>
<%@page import="com.avekshaa.cis.engine.get_Fatal_data"%>
<%@page import="com.avekshaa.cis.engine.one_day_hits_data"%>
<%@page import="com.avekshaa.cis.database.CommonDB"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.TreeMap"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="com.mongodb.DBObject"%>
<%@page import="com.avekshaa.cis.engine.top_city_resp"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.avekshaa.cis.Java.AndroidMap"%>
<%@page import="com.mongodb.BasicDBObject"%>
<%@page import="com.mongodb.DB"%>
<%@page import="com.mongodb.DBCollection"%>
<%@page import="com.mongodb.DBCursor"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<!-- <script src="../script/jquery.js"></script>
<script src="../script/jquery.min.js"></script>

<script src="../script//highcharts.js"></script>
<script src="../script/exporting.js"></script>
<script src="../script/in-all-disputed.js"></script>
<script src="../script/highmaps.js"></script> -->
<title>ThirtyDay</title>
<script type="text/javascript">
	//--------------Avg Response chart----------------------------------------
	$(function() {
<%GetChartData responceCh = new GetChartData();
			String appResponceData = responceCh.getAppDataForResponce(30);
			String webResponseData = responceCh.getWebResposeData(30);%>
	$('#container4')
				.highcharts(
						{
							chart : {
								type : 'column'
							},
							title : {
								text : 'Avg Response (1 Month)',
								style : {
									fontSize : '14px',
									/* fontWeight : 'bold', */
									fontFamily : 'Verdana, sans-serif'
								}
							//center
							},
							subtitle : {
								text : '',
								x : -20
							},
							exporting : {
								enabled : false
							},
							xAxis : {
								labels : {
									enabled : true
								},
								categories : [
<%out.print(GetChartData.ThirtyDayCategoryData);%>
	],
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
									text : 'Avg Response <b>(ms)</b>'
								},
								min : 0,
								plotLines : [
										{
											value :
<%=CommonThreshold.getWebThreshold()%>
	,
											color : 'red',
											width : 2,
											zIndex : 4,
											label : {
												text : 'Web Threshold',
												style : {
													fontSize : '10px',
													color : 'red'
												}
											},
											dashStyle : 'ShortDash'
										},
										{
											value :
<%=CommonThreshold.getAndroidThreshold()%>
	,
											color : 'red',
											width : 2,
											zIndex : 4,
											label : {
												text : 'App Threshold',
												style : {
													fontSize : '10px',
													color : 'red'
												}
											},
											dashStyle : 'ShortDash'
										} ]

							},
							tooltip : {
								formatter : function() {
									return 'Time: <b>' + this.point.extra
											+ '</b><br>Response Time :<b>'
											+ this.y + '</b> ms';
								},
								valueSuffix : ''
							},
							legend : {
							//	layout : 'vertical',
							//align : 'right',
							//verticalAlign : 'middle',
							//borderWidth : 0
							},
							credits : {

								enabled : false
							},
							series : [ {
								name : 'Web Response',
								showInLegend : true,
								data : [
<%out.print(webResponseData);%>
	]
							}, {
								name : 'App Response',
								showInLegend : true,
								data : [
<%out.print(appResponceData);%>
	]
							}, ]
						});
	});

	//----------------------App Crash-----------------------------

	$(function() {
<%GetChartData crashChartData = new GetChartData();
			String appCrashData = crashChartData.getDataForCrash(30);
			String webCrashData = crashChartData.getWebCrashData(30);%>
	$('#container1')
				.highcharts(
						{
							chart : {
								type : 'column'
							},
							title : {
								text : 'Critical Incidents',
								style : {
									fontSize : '14px',
									/* fontWeight : 'bold', */
									fontFamily : 'Verdana, sans-serif'
								}
							},
							subtitle : {
								text : ''
							},
							exporting : {
								enabled : false
							},
							credits : {
								enabled : false
							},
							xAxis : {
								categories : [
<%out.print(GetChartData.ThirtyDayCategoryData);%>
	],
								type : 'category',
								labels : {
									rotation : -45,
								/* style: {
								    fontSize: '13px',
								    fontFamily: 'Verdana, sans-serif'
								} */
								}
							},
							yAxis : {
								min : 0,
								title : {
									text : 'Crash Count'
								}
							},
							legend : {
								enabled : true
							},
							tooltip : {
								/* headerFormat: 'Time:<b>{point.x}</b><br/>',
								pointFormat: 'Crash Count : <b>{point.y} </b>' */

								formatter : function() {
									return 'Time: <b>' + this.point.extra
											+ '</b><br>Crach count :<b>'
											+ this.y + '</b>';
								},
								valueSuffix : ''
							},
							series : [ {
								name : 'Web',
								data : [
<%out.print(webCrashData);%>
	]
							}, {
								name : 'App',
								data : [
<%out.print(appCrashData);%>
	],
								dataLabels : {
									enabled : false,
									rotation : -90,
									color : '#FFFFFF',
									align : 'right',
									format : '{point.y}', // one decimal
									y : 10, // 10 pixels down from the top
									style : {
										fontSize : '13px',
										fontFamily : 'Verdana, sans-serif'
									}
								}
							} ]
						});
	});
	//---------------------Hits Chart--------------------
	$(function() {
<%GetChartData ch = new GetChartData();
			String appHitsData = ch.getDataForHits(30);
			String webHitsData = ch.getWebHitsData(30);%>
	$(function() {
			$('#container3')
					.highcharts(
							{
								chart : {
									type : 'column'
								},
								exporting : {
									enabled : false
								},
								title : {
									text : 'Number Of Hits (1 Month)',
									style : {
										fontSize : '14px',
										/* fontWeight : 'bold', */
										fontFamily : 'Verdana, sans-serif'
									}
								},
								subtitle : {
									text : ''
								},
								credits : {

									enabled : false

								},
								tooltip : {
									/* 	        	 headerFormat: 'Time:<b>{point.aa}</b><br/>',
									 pointFormat: 'Hits : <b>{point.y} </b>' */
									formatter : function() {
										return 'Time: <b>' + this.point.extra
												+ '</b><br>Hits :<b>' + this.y
												+ '</b>';
									},
									valueSuffix : ''
								},

								xAxis : {
									categories : [
<%out.print(GetChartData.ThirtyDayCategoryData);%>
	],
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
										text : ''
									},
									min : 0

								},
								plotOptions : {
									line : {
										dataLabels : {
											enabled : false
										},
										enableMouseTracking : true
									}
								},
								series : [ {
									name : 'Web Hits',
									showInLegend : true,
									data : [
<%out.print(webHitsData);%>
	]
								}, {
									name : 'App Hits',
									showInLegend : true,
									enabled : false,
									data : [
<%out.print(appHitsData);%>
	// 	                  {y:10,extra:'kkkk'}           
									]
								} ]
							});
		});
	});

	//-------------------------Workload-----------------------------------------------------------------
	$(function() {
		$(document)
				.ready(
						function() {
							$('#container')
									.highcharts(
											{
												chart : {
													type : 'bar'
												},
												title : {
													text : 'Top 5 Cities with Highest Workload %',
													style : {
														fontSize : '14px',
														fontFamily : 'Verdana, sans-serif'
													}
												},
												exporting : {
													enabled : false
												},
												credits : {

													enabled : false

												},
												xAxis : {
													categories : [],
													labels : {
														step : 1,
														enabled : false
													}
												},
												yAxis : {
												/*   title: {
												      text: null
												  },
												  labels: {
												      formatter: function () {
												          return Math.abs(this.value) + 'ms';
												      }
												  } */
												},

												plotOptions : {

													series : {
														pointWidth : 15,
														events : {
															legendItemClick : function() {
																//                         alert(this.index);
																if (!this.visible) {
																	var seriesIndex = this.index;
																	var series = this.chart.series;
																	for (var i = 0; i < series.length; i++) {
																		if (series[i].index != seriesIndex) {
																			series[i].visible ? series[i]
																					.hide()
																					: series[i]
																							.show();
																		}
																	}
																	return true;
																} else {
																	return false;
																}
															}
														},
														showInLegend : true
													}
												},

												tooltip : {
													formatter : function() {
														return 'City: <b>'
																+ this.point.extra
																+ '</b><br>Response :<b>'
																+ Math
																		.abs(this.y)
																+ '</b>';
													},
												},

												series : [
														{
															name : 'Web Respone',
															showInLegend : true,
															data : [
<%top_city_resp webData = new top_city_resp();
			String webWorkLoad = webData.getCityWorkloadForWeb(30);
			out.print(webWorkLoad);%>
	],
															dataLabels : {
																enabled : true,
																align : 'right',
																format : '{point.extra} <br>{point.y} %',
																color : 'black',
															/* style:{
																fontSize:'10px',
															} */

															},
														},

														{

															name : 'App Response ',
															visible : false,
															data : [
<%top_city_resp appData = new top_city_resp();
			String appWorkLoad = webData.getCityWorkloadForApplication(30);
			out.print(appWorkLoad);%>
	],
															dataLabels : {
																enabled : true,
																align : 'right',
																format : '{point.extra} <br>{point.y} %',
																color : '#ffffff',
															/* style:{
																fontSize:'10px',
															} */

															},
														} ]
											});
						});

	});
	//-----------------------Top 5 Cities Chart--------------------
	$(function() {
		// Age categories

		$(document)
				.ready(
						function() {
							$('#container5')
									.highcharts(
											{
												chart : {
													type : 'bar'
												},
												title : {
													text : 'Top 5 Cities with Highest Response Time',
													style : {
														fontSize : '14px',
														/*   fontWeight : 'bold', */
														fontFamily : 'Verdana, sans-serif'
													}
												},
												exporting : {
													enabled : false
												},
												credits : {

													enabled : false

												},
												xAxis : {
													categories : [],
													labels : {
														step : 1,
														enabled : false
													}
												},
												yAxis : {
													title : {
														text : null
													},
													labels : {
														formatter : function() {
															return Math
																	.abs(this.value)
																	+ 'ms';
														}
													}
												},

												plotOptions : {
													series : {
														pointWidth : 15,
														events : {
															legendItemClick : function() {
																//                            alert(this.index);
																if (!this.visible) {
																	var seriesIndex = this.index;
																	var series = this.chart.series;
																	for (var i = 0; i < series.length; i++) {
																		if (series[i].index != seriesIndex) {
																			series[i].visible ? series[i]
																					.hide()
																					: series[i]
																							.show();
																		}
																	}
																	return true;
																} else {
																	return false;
																}
															}
														},
														showInLegend : true
													},

												},

												tooltip : {
													formatter : function() {
														return 'City: <b>'
																+ this.point.extra
																+ '</b><br>Response :<b>'
																+ Math
																		.abs(this.y)
																+ '</b>';
													},
												},

												series : [
														{
															name : 'Web Response',
															showInLegend : true,
															data : [
<%top_city_resp t = new top_city_resp();
			String cityData = t.getWebTopCities(7);
			out.print(cityData);%>
	],
															dataLabels : {
																enabled : true,
																align : 'right',
																format : '{point.extra}',
																color : 'black',
															/* style:{
																fontSize:'10px',
															} */

															},
														},

														{

															name : 'App Response ',
															visible : false,
															data : [
<%try {

				top_city_resp resp = new top_city_resp();

				String data = resp.countryTopFivaMaxAvgResponse(30);

				out.println(data);

			} catch (Exception e) {
			}%>
	],
															dataLabels : {
																enabled : true,
																align : 'right',
																format : '{point.extra}',
																color : '#ffffff',
															/* style:{
																fontSize:'10px',
															} */

															},
														} ]
											});
						});

	});
	$('.cssload-container').hide();
</script>
</head>
<body>

	<%
		GetChartDataForBranch getApdexScore = new GetChartDataForBranch();
		double apdexScore = getApdexScore.getDayApdexScore_web(30);
		//double apdexScore = 0.84;
		double apdexScore_mobile = getApdexScore
				.getDayApdexScore_mobile(30);
	%>
	<%
		if (apdexScore <= 0.7) {
	%>
	<div
		style="float: right; margin-left: 35%; text-align: center; width: 60px; height: 60px; border-radius: 60px; background-color: red; margin-right: 5%;">
		<p style="text-align: center; padding-top: 6px;"><%=apdexScore%></p>
	</div>
	<%
		}
		if (apdexScore > 0.7 && apdexScore < 0.85) {
	%>
	<div
		style="float: right; margin-left: 35%; text-align: center; width: 60px; height: 60px; border-radius: 60px; background-color: orange; margin-right: 5%;">
		<p style="text-align: center; padding-top: 6px;"><%=apdexScore%></p>
	</div>
	<%
		} else if (apdexScore >= 0.85) {
	%>
	<div
		style="float: right; margin-left: 35%; text-align: center; width: 60px; height: 60px; border-radius: 60px; background-color: green; margin-right: 5%;">
		<p style="text-align: center; padding-top: 6px;"><%=apdexScore%></p>
	</div>
	<%
		}
	%>
	<%
		if (apdexScore_mobile <= 0.7) {
	%>
	<div
		style="float: right; width: 60px; height: 60px; border-radius: 60px; margin-left: 37%; margin-right: -33%; background-color: red;">
		<p style="text-align: center; padding-top: 6px;"><%=apdexScore_mobile%>
		</p>
	</div>
	<%
		}
		if (apdexScore_mobile > 0.7 && apdexScore_mobile < 0.85) {
	%>
	<div
		style="float: right; width: 60px; height: 60px; border-radius: 60px; margin-left: 37%; margin-right: -33%; background-color: orange;">
		<p style="text-align: center; padding-top: 6px;"><%=apdexScore_mobile%>
		</p>
	</div>
	<%
		} else if (apdexScore_mobile >= 0.85) {
	%>
	<div
		style="float: right; width: 60px; height: 60px; border-radius: 60px; margin-left: 37%; margin-right: -33%; background-color: green;">
		<p style="text-align: center; padding-top: 6px;"><%=apdexScore_mobile%>
		</p>
	</div>
	<%
		}
	%>
		<div style = "width : 40%; text-align : center; margin-left : 60%; margin-right : 0%;  height : 60px; text-align : center;">
		<div style = "width : 20%; margin-left : 7%; padding-top : 1.5%; color : #1691D8; float : left; text-align : center; align : center; display : inline; position : absolute;">APDEX SCORE</div>
	</div>	<div style="width: 99%; color: red;">
		<!-- 		<br> -->
		<br>
		<div id="container3"
			style="width: 45%; margin-right: 2.5%; margin-left: 2.5%; height: 250px; float: left; align: left">
		</div>
		<div id="container4"
			style="width: 50%; height: 250px; margin: 0 auto; float: left; align: left">
		</div>
		<br></br>
		<div id="container1"
			style="align: left; width: 45%; margin-right: 2.5%; margin-left: 2.5%; height: 260px; float: left; padding-top: 0px;"></div>
		<div id="container5"
			style="width: 50%; height: 260px; margin: 0 auto; float: left"
			align="left"></div>
		<iframe src="sevenDayMap.jsp" id="container6"
			style="width: 100%; border-style: solid; border-color: red; height: 470px; border: 0; min-width: 600px; max-width: 550px; margin: 0 auto; float: left;"></iframe>
		<div id="container"
			style="align: left; padding-top: 2%; max-width: 50%; height: 400px; float: left; margin-left: 9%;"></div>
	</div>
</body>
</html>