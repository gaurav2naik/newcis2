<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<!-- <meta content="25" http-equiv="refresh"> -->
<title>Insert title here</title>
<%@page import="com.avekshaa.cis.Java.DistinctUser"%>
<%@page import="com.avekshaa.cis.Java.WebResponseCount"%>
<%@page import="com.avekshaa.cis.Java.AndroidResponseCount"%>
<%@page import="com.avekshaa.cis.Java.CpuPercentLineGraph"%>
<%@page import="com.avekshaa.cis.Java.DurationBar"%>
<%@page import="com.avekshaa.cis.Java.LiveWebMap"%>
<%@page import="com.avekshaa.cis.Java.AndroidMap"%>
<%@page import="com.avekshaa.cis.Java.Perc"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.avekshaa.cis.Java.Live"%>
<%@page import="com.avekshaa.cis.Java.Incident"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.*"%>
<%@page import="com.avekshaa.cis.Java.AndroidLive"%>
<%@page import="com.avekshaa.cis.database.CommonDB"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.mongodb.BasicDBObject"%>
<%@page import="com.mongodb.DBObject"%>
<%@page import="com.mongodb.DB"%>
<%@page import="com.mongodb.DBCollection"%>
<%@page import="com.mongodb.DBCursor"%>
<%@page import="com.mongodb.Mongo"%>
<%-- <%@page import="com.avekshaa.cis.Java.COUNT"%>
<%@page import="com.avekshaa.cis.Java.CPU"%>
<%@page import="java.text.SimpleDateFormat"%> --%>


<%@page import="com.avekshaa.cis.Java.OneHourWeb"%>
<%@page import="com.avekshaa.cis.Java.OneHourAndroid"%>

<%@page import="com.avekshaa.cis.Java.AndroidLive"%>
<!-- <script src="../script/jquery.min.js"></script>
<script src="../script/jquery.js"></script>
<script src="../script/highcharts.js"></script>
<script src="../script/exporting.js"></script>
<link href="../css/header.css" rel="stylesheet" type="text/css" /> -->
<script>
	$(function() {
		$('#container1')
				.highcharts(
						{
							title : {
								text : 'Avg Response per Hour (one day)',
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

							xAxis : {
								/* tickPositions: [3,6,9],
								
								 tickColor: '#5A5E5E',
								 tickWidth: 3, */

								/* tickPositioner: function(min, max){
															    return [Math.round(min), (min + max) / 2, Math.round(max)];  
															}, */

								labels : {
									enabled : true
								},

								categories : [

								//  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
<%try{

                    StringBuilder desktopdat = new StringBuilder();
                    String data1="";
                             StringBuilder sb1 = new StringBuilder();
                             AndroidMap l =new  AndroidMap();
                             Map<Long, Double> data =l.mtd();


                            for (Iterator iterator =data.keySet().iterator(); iterator.hasNext();)
                            {
                                Long timeInMillis = (Long)iterator.next();//key
                                 //  String IPURIRES = (String)data.get(timeInMillis);//val                                        //


                                            SimpleDateFormat sdf = new SimpleDateFormat(" HH:mm");
                                            String timeInDateFormat = sdf.format(timeInMillis);
                                            sb1.append("'"+timeInDateFormat+ "',");
      }


                data1 = sb1.toString();
                out.println(data1);
                //System.out.println("y axis ["+data1+"]");
                }
                   catch(Exception ex)
                   {
                       ex.printStackTrace();
                       }

                finally
                {
                    ////System.out.println("");
                    }%>
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
									text : 'Avg response<b>(ms)</b>per Hour'
								},
								min : 0,
								plotLines : [ {

									value :
<%DBCursor alertData = null;
               
                try {
                  
                    DB db=CommonDB.getBankConnection();
                    //System.out.println("DB Name:"+db.getName());
                  
                    //3.select the collection
                    DBCollection coll=db.getCollection("ThresholdDB");
                    //System.out.println("IN threshold DAO"+coll.getName());
                  
                  
                  
            //fetch name
                    BasicDBObject findObj = new BasicDBObject();
                    alertData = coll.find(findObj);
                    alertData.sort(new BasicDBObject("_id", -1));
                  
                    alertData.limit(1);
                    List<DBObject> dbObjs = alertData.toArray();

                    for (int i = dbObjs.size() - 1; i >= 0; i--)

                    {
                        DBObject txnDataObject = dbObjs.get(i);
                        Integer res = (Integer) txnDataObject.get("Android_threshold");
                       
                        //System.out.println("THRES:"+res);
                      
                        out.println(res);%>
	,

									width : 1,
									//  color: '#808080',
									color : 'red',
									width : 2,

									label : {
										text : 'Threshold',
										x : 0,
										y : 15,

										style : {
											fontSize : '17px',
											//    fontFamily : 'Verdana, sans-serif'
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
								layout : 'vertical',
								align : 'right',
								verticalAlign : 'middle',
								borderWidth : 0
							},
							credits : {

								enabled : false

							},
							series : [
									{
										// name: 'tokyo',
										showInLegend : false,

										//YELLOW
										threshold :

										//1200,
<%Double perc=0.7;  //70%
        Integer yellow1=res;
        
        Double yellow2=perc*yellow1;
      
        
        //System.out.println("monishaaa"+yellow2);
        out.println(yellow2);%>
	,

										negativeColor : 'green',
										color : 'orange',

										data :

										[
										// 7.0, 6.9
<%try{

                    StringBuilder sb2 = new StringBuilder();
                    String data2="";
                             StringBuilder sb22 = new StringBuilder();
                             AndroidMap l1 =new  AndroidMap();
                             Map<Long, Double> data =l1.mtd();


                            for (Iterator iterator =data.keySet().iterator(); iterator.hasNext();)
                            {
                                Long timeInMillis = (Long)iterator.next();//key
                                   Double avgResp = (Double)data.get(timeInMillis);//val                                        //



                                   SimpleDateFormat sdf = new SimpleDateFormat(" HH:mm");
                                   String timeInDateFormat = sdf.format(timeInMillis);
                                 
                               
                                   sb22.append("{y:"+avgResp+ ",extra:'"+timeInDateFormat+"'},");
      }


                data2 = sb22.toString();
              //  out.println(data2);
                //System.out.println("x axis ["+data2+"]");
                }
                   catch(Exception ex)
                   {
                       ex.printStackTrace();
                       }

                finally
                {
                    ////System.out.println("");
                    }%>
	]

									},

									//-------------------   

									{
										// name: 'tokyo',
										showInLegend : false,

										//RED
										threshold :
<%out.println(res);
              
                
        }
    } catch (Exception e) {
        e.printStackTrace();
      
    } finally {
        alertData.close();
    }%>
	,

										//THRESSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSHHHHH-1

										negativeColor : 'transparent',
										color : 'red',

										data :

										[
										// 7.0, 6.9
<%try{

                     StringBuilder sb2 = new StringBuilder();
                     String data2="";
                              StringBuilder sb22 = new StringBuilder();
                              AndroidMap l1 =new  AndroidMap();
                              Map<Long, Double> data =l1.mtd();


                             for (Iterator iterator =data.keySet().iterator(); iterator.hasNext();)
                             {
                                 Long timeInMillis = (Long)iterator.next();//key
                                    Double avgResp = (Double)data.get(timeInMillis);//val                                        //



                                    SimpleDateFormat sdf = new SimpleDateFormat("dd-MMM-yyyy HH:mm:ss");
                                    String timeInDateFormat = sdf.format(timeInMillis);
                                  
                                
                                    sb22.append("{y:"+avgResp+ ",extra:'"+timeInDateFormat+"'},");
       }


                 data2 = sb22.toString();
                 out.println(data2);
                 //System.out.println("x axis ["+data2+"]");
                 }
                    catch(Exception ex)
                    {
                        ex.printStackTrace();
                        }

                 finally
                 {
                     ////System.out.println("");
                     }%>
	]

									},

							]
						});
	});
</script>
<style>
body {
	height: 100%;
	width: 100%;
	margin: 0;
	padding: 0;
	position: relative;
}

html {
	height: 100%;
	width: 100%;
	margin: 0;
	padding: 0;
}
</style>
</head>
<body>
	<div id="container1" style="width: 100%; height: 100%;"></div>
</body>
</html>