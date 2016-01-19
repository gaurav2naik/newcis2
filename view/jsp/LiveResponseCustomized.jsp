<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@page import="com.avekshaa.cis.database.CommonUtils"%>
<%@page import="com.avekshaa.cis.database.CommonDB"%>
<%@page import="com.avekshaa.cis.extension.ExtensionData"%>
<%@page import="com.avekshaa.cis.extension.LiveResponseCustomized"%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.*"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.TreeMap"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import ="com.mongodb.BasicDBObject"%>
<%@page import ="com.mongodb.DBObject"%>
<%@page import ="com.mongodb.DB"%>
<%@page import = "com.mongodb.DBCollection"%>
<%@page import ="com.mongodb.DBCursor"%>
<%@page import ="com.mongodb.Mongo"%>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<!-- <link rel="stylesheet" type="text/css" href="../css/style1.css" /> -->
		<!-- <link href=".../css/index.css" rel="stylesheet" type="text/css" /> -->
		<link href="../css/button.css" rel="stylesheet" type="text/css" />
		<script src="../script/jquery.min.js"></script>
		<script src="../script/jquery.js"></script>
		<script src="../script/highcharts.js"></script>
		<script src="../script/exporting.js"></script>
		<title> UserExperience |CIS</title>
		<!-- <link rel="stylesheet" type="text/css" href="../css/index.css" />  -->
		<style type="text/css">
		body 
		{
						margin:0px;
						height: 100%;
						width: 100%; 
		}
				
</style>
			<% SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss:SSS");																																																			
         
       			System.out.println("aaaaaaaa "+request.getParameter("startTime1"));  
       			System.out.println("aaaaaaaa "+request.getParameter("endTime1"));
       			System.out.println("gwiaaaol"+request.getParameter("IP1")+" "  +request.getParameter("URL1"));
         
         		%> 
 			<script>
					$(function my() 
					{
						var selectedPointsStr = "";
		 				var emptyArray = new Array();
		 				var iii=new Array();
		 				var points;
		 				var ii=0;
		 
						$('#graph_live')
						.highcharts(
						{

							credits : {
								enabled : false
							},

							exporting : {
								enabled : false
							},

							chart : 
							{
								type : 'line',
								zoomType : 'xy',
								backgroundColor : 'white'
							},

							title : {
								text : 'User Response Time',
								x : -20
							
							},
							subtitle : {
								   
								x : -20
							},
							xAxis : {
								

								labels : {
									rotation : -90,
									style : {
										fontSize : '13px',
										fontFamily : 'Verdana, sans-serif'
									}
								},

								categories : [
									<%try{   
                        				StringBuilder desktopdat = new StringBuilder();
                             			String data2="";
                                      	StringBuilder xais = new StringBuilder();
                                       	if(null != request.getParameter("startTime1") && null != request.getParameter("endTime1"))
                            			{
                                    		System.out.println("in x-axis live customised");
                                    	   	String  startTime ="";
                                           	String endTime="";
                                           	String uri="";
                                           	String ip="";
                                          	String location="";
                                           	String aqw="-1";
                                          	startTime = request.getParameter("startTime1").replaceAll("~", " ");
                                          	System.out.println(startTime);
                                         	endTime = request.getParameter("endTime1").replaceAll("~", " ");
                                         	System.out.println(endTime);
                                   		 	ip=request.getParameter("IP1");
                                         	uri=request.getParameter("URL1");
	                                                                              		
                                         	System.out.println("uri value is "+uri);
                                         	LiveResponseCustomized live = new LiveResponseCustomized();                             
                                         	TreeMap<Long,String> data = live.getIPandURI(startTime,endTime,uri,ip);
                                 			System.out.println("RESULT : "+data);
										  	for (Iterator iterator = data.keySet().iterator(); iterator.hasNext();)
                                 			{
                                     			Long timeInMillis = (Long) iterator.next();
                                     			String timeInDateFormat= dateFormat.format(new Date(timeInMillis));
	                                       		
                                                xais.append("'"+timeInDateFormat+ "',");                                        
                                                
                               
                                 			}
                        					data2 = xais.toString();
                       						
                      						System.out.println("x axis ["+data2+"]");
                   						}  
                                       	else {
                	   							System.out.println("in x-axis live");
                	   							ExtensionData l =new ExtensionData();
                                  				Map<Long,String> data = l.getResponseTimesForScatterGraph("","","","");
                                  				
                                				for (Iterator iterator = data.keySet().iterator(); iterator.hasNext();)
                                 				{
                                     				Long timeInMillis = (Long) iterator.next();
                                        			String IPURIRES = (String) data.get(timeInMillis);                                        //    //////System.out.println("Y VALUR RRT"+yValueRT);
                                        			String timeInDateFormat= dateFormat.format(new Date(timeInMillis));
                                                 
                                                 	xais.append("'"+timeInDateFormat+ "',");                                      
                                  				}
                     							data2 = xais.toString();
                    							
                							}
                                       	}
                           				catch(Exception ex)
                           				{
                               				ex.printStackTrace();
                               			}%>
									],
									lineWidth : 5

								},
								exporting: {
							    	buttons: {
							        	customButton: {
							            	x: -62,
							                symbol: 'square',
							                onclick: function(){
							                	getFunc();
							                }
							              			
							                
							            }
							        }
							   	}, 
							 	plotOptions: {
					            	series: {
					                	allowPointSelect: true,
					                   
					                    point: {
					                        events: {
					                        	select: function() {
						                            console.log("ahaj");
						                            var chart = $('#graph_live').highcharts();
						                            
						                            
						                          try{
						                          	var selectedPoints = chart.getSelectedPoints();
						                            selectedPoints.push(this);
						                          }
						                          catch(Exception)
						                          {
													System.out.println("Points not selected properly. Please Select again ");
							                        	}
						                          		try{
						                            	$.each(selectedPoints, function(i, value) 
						                            	{
						                            		
						                            		iii[ii]=points;
						                            	
									                    });
						                            	ii++;
														
						                          	}
						                          	catch( Exception ){
							                          console.log("Required Values not found");
							                         }
						                            
						                            
					                            }
					                        }
					                    }
					                }
					            }, 
								yAxis: {
								
					            	title: 
					            	{
					                	text: 'Response Time(ms)'
					            	},
					            	min:0,
					            	plotLines:
					            	 [
					            	 {	value:
					            	 	<%DBCursor alertData = null;
					               		try 
					               		{
					                  		DB db=CommonDB.getExtensionDataConnection();
					                    	DBCollection coll=db.getCollection("mycollection1");
					                    	BasicDBObject findObj = new BasicDBObject();
					                    	alertData = coll.find(findObj);
					                    	alertData.sort(new BasicDBObject("$natural", -1));
					                  		alertData.limit(1);
					                    	List<DBObject> dbObjs = alertData.toArray();
											for (int i = dbObjs.size() - 1; i >= 0; i--)
											{
					                        	DBObject txnDataObject = dbObjs.get(i);
					                        	Integer res = (Integer) txnDataObject.get("response_time");
					                        	out.println(res);
					                      %>
					                    	,
					            
					                		
					                     	dashStyle : 'ShortDash'                  
										}]
					        		},
					        		
									tooltip : {

										formatter : function() {
											points=this.point.myData+this.point.time;
											return 'IP and URI: <b>'
											+ this.point.myData
											+ '</b><br>Time <b>' + this.point.time
											+ '</b><br>Response Time <b>'
											+ this.y + '</b> ms';
										},
										valueSuffix : ''
									},

									legend : {
										layout : 'vertical',
										align : 'right',
										verticalAlign : 'middle',
										borderWidth : 0
									},
									
									series : [ {
										threshold :    
							    		<% out.println(res);
						    		}
								} catch (Exception e) {
									e.printStackTrace();
						      
						    		} 
									finally {
						        		alertData.close();
						    		}%>,

                         			
                        			
									showInLegend : false,
									data : [
										<%try{  
      										StringBuilder desktopdat = new StringBuilder();
                       						String data2="";
                                			StringBuilder mobiledat = new StringBuilder();
                 							if(null != request.getParameter("startTime1") && null != request.getParameter("endTime1"))
                                			{
                	 							System.out.println("in y-axis live customised");
                	 							System.out.println("hello we r here");
                                        		String  startTime ="";
                                        		String endTime="";
                                        		String uri="";
                                        		String ip="";
                                        		String location="";
                                        		String aqw="-1";
                                        		startTime = request.getParameter("startTime1").replaceAll("~", " ");
                                        		System.out.println(startTime);
                                        		endTime = request.getParameter("endTime1").replaceAll("~", " ");
                                        		System.out.println(endTime);
                                       			ip=request.getParameter("IP1");
                                        		uri=request.getParameter("URL1");
                                        		location=request.getParameter("LOCATION");                                        		
                                        		System.out.println("uri value is "+uri);
                                        		LiveResponseCustomized live = new LiveResponseCustomized();                             
                                        		TreeMap<Long,String> data = live.getIPandURI(startTime,endTime,uri,ip);
                     							System.out.println("check data flow after tree map in jsp page");
                    							for (Iterator iterator = data.keySet().iterator(); iterator.hasNext();)
                              					{
                                  					Long timeInMillis = (Long) iterator.next();
                                     				String IPURIRES = (String) data.get(timeInMillis);
                                     				String   timeInDateFormat= dateFormat.format(new Date(timeInMillis));
                                     				
                                 					String[] occurrences = IPURIRES.split("\\&\\&");
                                 					String IPURI=occurrences[0]+"__"+occurrences[1]+"__";
                                 					String Response=occurrences[2];
                                 					Double Res = Double.parseDouble(Response);
                             						
                           							mobiledat.append("{y:"+Res+",myData:'"+IPURI+"',time:'"+timeInDateFormat+"'},");
												}
                  								data2 = mobiledat.toString();
                  								out.println(data2);
              									
                  							}
    										else
                      						{
                     							System.out.println("in y-axis live ");
                     							ExtensionData l =new ExtensionData();
                      							Map<Long,String> data = l.getResponseTimesForScatterGraph("","","","");
                								
                        						for (Iterator iterator =   data.keySet().iterator(); iterator.hasNext();)
                  								{
                        	   						Long timeInMillis = (Long) iterator.next();
                        	   						String IPURIRES = (String)data.get(timeInMillis);
                        	   						String   timeInDateFormat= dateFormat.format(new Date(timeInMillis));
                        							
													String[] occurrences = IPURIRES.split("\\&\\&");
													
													String IPURI=occurrences[0]+"__"+occurrences[1]+"__";
                        		     				String Response=occurrences[2];
                        		    				Integer Res = Integer.parseInt(Response);
                        		                           
                    								
                        		            		
													mobiledat.append("{y:"+Res+",myData:'"+IPURI+"',time:'"+timeInDateFormat+"'},");
                               						
                              	     			}
												data2 = mobiledat.toString();
               									out.println(data2);
            									
           									}
   										}
										catch(Exception ex)
             							{
											ex.printStackTrace();
    	 									
										}%>
									],
									lineWidth : 3
								}
							]
						});
		 				$('#button').click(function () 
						{
							try
							{
								console.log(iii);
				    			document.location.href ="Result.jsp?start="+iii;
							}
							catch(err)
							{
								Console.log("Unable to redirect to next page");
	            			}
						});
					});
			</script> 
		</head>
		<body id="bce">
			<%
			
			String sessionId = request.getParameter("id");
			String startTime = request.getParameter("startTime");
			String endTime = request.getParameter("endTime");
			String uri= request.getParameter("URI");
			String ip= request.getParameter("IP");
			String location=request.getParameter("LOCATION");
			startTime = startTime == null ? "" : startTime;
			endTime = endTime == null ? "" : endTime;
			uri= uri==null ? "" : uri;
			ip= ip==null ? "" : ip;
			

			Boolean isOverviewLinkClicked = false;
			%>
		
			<%@include file="BranchHeader.jsp"%>
			<div id="wrap">
				
					<button id="button" class="autocompare" style="float:right;width:145px;height:25px;font-size:14px;"><B>Get selected</B></button>
					
				<div id="graph_live"></div>
			</div>
			<%@include file="Footer.jsp"%>
	</body>
</html>