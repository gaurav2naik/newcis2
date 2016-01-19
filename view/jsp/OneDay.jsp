<%@page import="com.avekshaa.cis.engine.GetChartDataForBranch"%>
<%@page import="com.avekshaa.cis.commonutil.Convertor"%>
<%@page import="com.avekshaa.cis.jio.GetChartData"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="com.avekshaa.cis.engine.city_avg_data"%>
<%@page import="com.avekshaa.cis.engine.get_Fatal_data"%>
<%@page import="com.avekshaa.cis.engine.one_day_hits_data"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.TreeMap"%>
<%@page import="com.avekshaa.cis.engine.top_city_resp"%>
<%@page import="java.text.SimpleDateFormat"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>One Day</title>
<!--  <script src="../script/jquery.js"></script>
<script src="../script/jquery.min.js"></script>

<script src="../script//highcharts.js"></script>
<script src="../script/exporting.js"></script>
<script src="../script/in-all-disputed.js"></script>
<script src="../script/highmaps.js"></script>
 -->
<script type="text/javascript">
$(function () {
	$('#container4').load('../dashboardgraph/AverageAndroForDashBoard.jsp');
	
});

//------------------------------------------------------------------------------------------------

$(function () {
    $('#container1').highcharts({
        chart: {																																											
            type: 'column'
        },
        title: {                                
            text: 'Critical Incidents and Crashes',
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
            		 categories: [
            		              
            		              <%try {
            		                          String data2 = "";
            		                          StringBuilder xais = new StringBuilder();
            		                          get_Fatal_data resp = new get_Fatal_data();
            		                          TreeMap<Long, Integer> data = resp.Fatal_Detail_current();
            		                         // System.out.println("sata" + data);
            		                          for (Iterator iterator = data.keySet().iterator(); iterator.hasNext();) {
            		                              //System.out.println((Double)iterator.next()+"iterator");
            		                              Long hrs = (Long) iterator.next();
            		                              //SimpleDateFormat sdf = new SimpleDateFormat("HH:mm");
            		                              String timeInDateFormat = Convertor.timeInHourMin(hrs);
            		                              int count = data.get(hrs);
            		                              // System.out.println(city_name);
            		                              xais.append("'" + timeInDateFormat + "',");
            		                          }
            		                          data2 = xais.toString();
            		                          out.println(data2);
            		                      } catch (Exception e) {

            		                      }%>
            		                                 
            		                                   ],
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
                text: 'Count'
            }
        },
        legend: {
            enabled: true
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
                	       <%GetChartData crashChartData = new GetChartData();
                	       String webCrashData = crashChartData.getWebCrashData(1); 
                	       out.print(webCrashData);%>
                	       ]
                 },
                 
                 
                 {
            name: 'App',
            data: [
<%try{
	
	
		String data2="";
  	StringBuilder xais = new StringBuilder();
		get_Fatal_data resp=new get_Fatal_data();	
 	TreeMap<Long, Integer> data = resp.Fatal_Detail_current();
//  	System.out.println("sata"+data);
	  	for (Iterator iterator = data.keySet().iterator(); iterator.hasNext();)
		{
	  		//System.out.println((Double)iterator.next()+"iterator");
			//String hrs = (String) iterator.next();
			Long hrs = (Long)iterator.next();//key
                                 //  String IPURIRES = (String)data.get(timeInMillis);//val                                        //


                                            //SimpleDateFormat sdf = new SimpleDateFormat(" HH:mm");
                                            String timeInDateFormat = Convertor.timeInDefaultFormat(hrs);
			int count=data.get(hrs);
// 			System.out.println("key : "+hrs+"value"+data.get(hrs));
			//int crach =(Integer) iterator.next();
			//System.out.println(hrs+"   "+crach);
			//xais.append("'"+enter_value+ "',");
			xais.append("{y:"+count+",extra:'"+timeInDateFormat+"'},");
	//	System.out.println("xaxis"+xais);   			
			}
	  	data2 = xais.toString();
// 	  	System.out.println("app crash report graph"+data2);
	out.println(data2);

    }
catch(Exception e){
    }%> 
                ],
            dataLabels: {
                enabled: false,
                rotation: -90,
                color: '#FFFFFF',
                align: 'right',
                format: '{point.y}', // one decimal
                y: 10, // 10 pixels down from the top
                style: {
                    fontSize: '13px',
                    fontFamily: 'Verdana, sans-serif'
                }
            }
        }]
    });
});

//-------------------------Workload-----------------------------------------------------------------
 $(function () {
    $(document).ready(function () {
        $('#container').highcharts({
            chart: {
                type: 'bar'
            },
            title: {
                text: 'Top 5 Cities with Highest Workload %',
                style: {
                    fontSize: '14px',
                    fontFamily: 'Verdana, sans-serif'
                }
            },
            exporting :
            {
                enabled:false
            },
            credits: { 
            	
            	enabled: false
            	
            },
            xAxis: {categories:[],
            	 labels: {
                     step: 1,
                     enabled:false
                 }	
            },
            yAxis: {
              /*   title: {
                    text: null
                },
                labels: {
                    formatter: function () {
                        return Math.abs(this.value) + 'ms';
                    }
                } */
            },

            plotOptions: {
                series:{
            	pointWidth:15,
            	 events: {
                     legendItemClick: function () {
//                      alert(this.index);
                            if (!this.visible){
                            	var seriesIndex = this.index;
     							var series = this.chart.series;
     							for (var i = 0; i < series.length; i++){
     								if (series[i].index != seriesIndex){
     									series[i].visible ?
     											series[i].hide() :
     												series[i].show();
     											}
     								}
     							return true;
                            }
                            else{
                            	return false;
                            	}
                     	}
                 	},
             		showInLegend: true
            	},
            	
            },

            tooltip: {
            	formatter : function() {
    				return 'City: <b>' + this.point.extra
    						+ '</b><br>Response :<b>'
    						+ Math.abs(this.y) + '</b>';
    			},
            },

            series: [
                     {
                     	name:'Web Respone',
                     	showInLegend: true,
                     	data:[<%top_city_resp webData = new top_city_resp();
                     	String webWorkLoad = webData.getCityWorkloadForWeb(1);
                     	out.print(webWorkLoad);%>],
                     	dataLabels:{
                     		enabled:true,
                     		align:'right',
                     		format:'{point.extra} <br>{point.y} %',
                     		color:'black',
                     		/* style:{
                     			fontSize:'10px',
                     		} */
                     		
                     		
                     	},
                      },
                      
                      {
               
                 name:'App Response ',
                 visible: false,
             	data: [

<%top_city_resp appData = new top_city_resp();
	String appWorkLoad = webData.getCityWorkloadForApplication(1);
	out.print(appWorkLoad);%>
         ],
      	dataLabels:{
     		enabled:true,
     		align:'right',
     		format:'{point.extra} <br>{point.y} %',
     		color:'#ffffff',
     		/* style:{
     			fontSize:'10px',
     		} */
     		
     		
     	},
                 }]
        });
    });

});

//-----------------------------------------------------------------------------------------------
$(function(){
	$(function () {
	    $('#container3').highcharts({
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
	        	
	           categories: [
   <%try{
	
	
		String data2="";
  	StringBuilder xais = new StringBuilder();
		one_day_hits_data resp=new one_day_hits_data();	
 	TreeMap<Long, Integer> data = resp.hits_detail();
//  	System.out.println("sata"+data);
	 	for (Iterator iterator = data.keySet().iterator(); iterator.hasNext();)
		{
	 		//System.out.println((Double)iterator.next()+"iterator");
			//String hrs = (String) iterator.next();
			Long hrs = (Long)iterator.next();//key
                                 //  String IPURIRES = (String)data.get(timeInMillis);//val                                        //


                                            SimpleDateFormat sdf = new SimpleDateFormat(" HH:mm");
                                            String timeInDateFormat = sdf.format(hrs);
			int count=data.get(hrs);
			//DateFormat format = new SimpleDateFormat("dd/MM");
			//String formatted = format.format(hrs);
            
// 			System.out.println("key : "+hrs+"value"+data.get(hrs));
			//int crach =(Integer) iterator.next();
			//System.out.println(hrs+"   "+crach);
			//xais.append("'"+enter_value+ "',");
			xais.append("'"+timeInDateFormat+ "',");
			//System.out.println("x-axis "+timeInDateFormat);   			
			}
	 	data2 = xais.toString();
	 	//System.out.println("fsdgshssjsj"+data2);
	out.println(data2);

    }
catch(Exception e){
    }%> 
	                          
	      ],labels: {
              rotation: -45,
              /* style: {
                  fontSize: '13px',
                  fontFamily: 'Verdana, sans-serif'
              } */
          } 
	        },
	        yAxis: {
	            title: {
	                text:'Hits Count'
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
	     		           
	     		         //showInLegend: false,  
	     		         enabled : false,
	     		           data: [<%GetChartData hitsChartData = new GetChartData();
	     		           String hitsData = hitsChartData.getWebHitsData(1);
	     		           out.print(hitsData);%>]
	     	    },
	                 {
			name:'App Hits',	           
	         showInLegend: true,  
	         enabled : false,
	           data: [
<%try{
	
	
		String data2="";
      	StringBuilder xais = new StringBuilder();
		one_day_hits_data resp=new one_day_hits_data();	
 	    TreeMap<Long, Integer> data = resp.hits_detail();
	  	for (Iterator iterator = data.keySet().iterator(); iterator.hasNext();)
		{
			Long hrs = (Long)iterator.next();//key
          //  String IPURIRES = (String)data.get(timeInMillis);//val                                        //
          //     SimpleDateFormat sdf = new SimpleDateFormat(" HH:mm");
            String timeInDateFormat = Convertor.timeInDefaultFormat(hrs);
			int count=data.get(hrs);
// 			System.out.println("key:"+hrs+"value"+data.get(hrs));
			//int crach =(Integer) iterator.next();
			//System.out.println(hrs+"   "+crach);
			//xais.append("'"+enter_value+ "',");
			/* xais.append("['"+timeInDateFormat+"',"+count+"],"); */
			xais.append("{y:"+count+",extra:'"+timeInDateFormat+"'},");
			}
	  	data2 = xais.toString();
	    out.println(data2);
    }
catch(Exception e){
    }%> 
		   	            ]
	        }
	        ]
	    });
	});
});
//------------------------------------------------------------------------------------------------
 $(function () {
    // Age categories
    
    $(document).ready(function () {
        $('#container5').highcharts({
            chart: {
                type: 'bar'
            },
            title: {
                text: 'Top 5 Cities with Highest Response Time',
                style: {
                    fontSize: '14px',
                  /*   fontWeight : 'bold', */
                    fontFamily: 'Verdana, sans-serif'
                }
            },
            exporting :
            {
                enabled:false
            },
            credits: { 
            	
            	enabled: false
            	
            },
            xAxis: {categories:[],
            	 labels: {
                     step: 1,
                     enabled:false
                 }	},
            yAxis: {
                title: {
                    text: null
                },
                labels: {
                    formatter: function () {
                        return Math.abs(this.value) + 'ms';
                    }
                }
            },

            plotOptions: {
                series: {
                	pointWidth:15,
                	 events: {
                         legendItemClick: function () {
//                          alert(this.index);
                                if (!this.visible){
                                	var seriesIndex = this.index;
         							var series = this.chart.series;
         							for (var i = 0; i < series.length; i++){
         								if (series[i].index != seriesIndex){
         									series[i].visible ?
         											series[i].hide() :
         												series[i].show();
         											}
         								}
         							return true;
                                }
                                else{
                                	return false;
                                	}
                         	}
                     	},
                 		showInLegend: true
                },
               /*  series:
            	{
            	pointWidth:20
            	} */
            },

            tooltip: {
            	formatter : function() {
    				return 'City: <b>' + this.point.extra
    						+ '</b><br>Response :<b>'
    						+ Math.abs(this.y) + '</b>';
    			},
            },

            series: [
                     {
                     	name:'Web Respone',
                     	showInLegend: true,
                     	data:[<%top_city_resp t = new top_city_resp();
                     	String cityData = t.getWebTopCities(1);
                     	out.print(cityData);%>],
                     	dataLabels:{
                     		enabled:true,
                     		align:'right',
                     		format:'{point.extra}',
                     		color:'black',
                     		/* style:{
                     			fontSize:'10px',
                     		} */
                     		
                     		
                     	},
                      },
                      
                      {
               
                 name:'App Response ',
                 visible: false,
             	data: [

                        <%try{
         						
         						top_city_resp resp=new top_city_resp();	
                             
                             	String data = resp.countryTopFivaMaxAvgResponse(1);
                              
         					out.println(data);
         				
                                }
                            catch(Exception e){
                                }%>
         ],
      	dataLabels:{
     		enabled:true,
     		align:'right',
     		format:'{point.extra}',
     		color:'#ffffff',
     		/* style:{
     			fontSize:'10px',
     		} */
     		
     		
     	},
                 }]
        });
    });

});
 $('.cssload-container').hide();
</script>
</head>
<body>
	
	<%
		GetChartDataForBranch getApdexScore = new GetChartDataForBranch();
		double apdexScore = getApdexScore.getApdexScore();
		//double apdexScore = 0.96;
		double apdexScore_mobile = getApdexScore.getApdexScore_mobile();
	%>
	<!-- <p style="margin-left:84%">WEB</p> -->
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
		}
		if (apdexScore >= 0.85) {
	%>
	<div
		style="float: right; margin-left: 35%; text-align: center; width: 60px; height: 60px; border-radius: 60px; background-color: green; margin-right: 5%;">
		<p style="text-align: center; padding-top: 6px;"><%=apdexScore%></p>
	</div>
	<%
		}
	%>
	<%-- <%=apdexScore%></p> --%>
	<!-- </div> -->
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
		}
		if (apdexScore_mobile >= 0.85) {
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
	</div>
	
	<div style="width: 99%;  color : red;">
		<!-- 		<br> -->
		
		<div id="container3"
			style="width: 50%; margin-right: 2.5%; height: 250px; margin-left: 2.5%; float: left; align: left">
		</div>
		<div id="container4"
			style="width: 45%; height: 250px; margin: 0 auto; float: left; align: left">
		</div>
		<br></br>
		<div id="container1"
			style="align: left; width: 50%; float: left; padding-top: 0px; margin-right: 2.5%; height: 260px; margin-left: 2.5%;"></div>
		<div id="container5"
			style="max-width: 50%; height: 260px; margin: 0 auto; float: left"
			align="left"></div>
		<iframe src="map.jsp" id="container6"
			style="width: 100%; border-style: solid; border-color: red; height: 470px; border: 0; min-width: 600px; max-width: 550px; margin: 0 auto; float: left;"></iframe>
		<div id="container"
			style="align: left; padding-top: 2%; max-width: 50%; height: 400px; float: left; margin-left: 9%;"></div>
	</div>
</body>
</html>