<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>DashBoard|CIS</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script src="../script/jquery.js"></script>
<script src="../script/jquery.min.js"></script>
<script src="../script//highcharts.js"></script>
<script src="../script/exporting.js"></script>
<script src="../script/in-all-disputed.js"></script>
<script src="../script/highmaps.js"></script>
<style type="text/css">
.myButton {
	margin-top: 0%;
	padding-top: 0%;
	margin-bottom: 0%;
	padding-bottom: 0%;
	background-color: white;
	text-decoration: none;
	border-bottom: 4px solid lightblue;
	cursor: pointer;
	color: black;
	font-family: Arial;
	font-size: 17px;
	/* 	font-weight:bold; */
	text-decoration: none;
}
.myButton:hover {
	color: #1691D8;
	border-bottom: 4px solid black;
}
#active {
	position: relative;
	top: 0;
}
.abd:hover {
	border-bottom-color: 4px solid black;
}
</style>
<script>
	function showDiv(option) {
		$('.cssload-container').hide();
	}
</script>
<link rel="stylesheet" type="text/css" href="../css/index.css" />
<script type="text/javascript" src="../script/styleswitcher.js"></script>
<link rel="stylesheet" href="../css/button.css">
<link rel="stylesheet" type="text/css" href="../css/treeMenu.css" />
<link rel="stylesheet" type="text/css" href="../css/loading.css">
</head>
<body id="home" onload="showDiv()">
	<%@include file="CombinedHeader.jsp"%>
	<div style="margin-top: 2%; width: 100%;">
		<div class="abd"
			style="width: 10%; display: inline; border-right: 1px solid black; padding-right: 1%; padding-left: 1%;"
			id="1daysdata">
			<a id="1d" href="#" title="" class="myButton" style="color: #1691D8;" page="OneDay.jsp">1 Day</a>
		</div>
		<div class="abd"
			style="width: 10%; display: inline; border-right: 1px solid black; padding-right: 1%; padding-left: 1%;">
			<a id="2d" href="#" title="" class="myButton" page="SevenDay.jsp">1
				Week</a>
		</div>
		<div class="abd"
			style="width: 10%; display: inline; padding-left: 1%; color: #1691D8;">
			<a href="#" title="" class="myButton" page="ThirtyDay.jsp" id="3d">1
				Month</a>
		</div>
		<div style = "width : 35%;float : right; text-align : center;">
		<div class="abd"
			style="width: 8.6%; margin-left : 10%; margin-right : 17%; text-align : center; display: inline; color: #1691D8; font-size: 10px; float: right; font-size: 15px;">
			Web</div>
		<div class="abd"
			style="width: 6%; display: inline; color: #1691D8; font-size: 10px; float: right; margin-left : 5%; font-size: 15px">
			App</div></div>
			<!-- Report Generation button  -->
			<!-- <div style="display: inline; float: left;padding-right: 1%;"><input id="report_btn" type="button" value="Generate Report"></div> -->
	</div>
	<div class="cssload-container">
		<div class="cssload-whirlpool"></div>
	</div>
	
	<div id="loader"><%@include file="OneDay.jsp"%></div>
	<%@include file="Footer.jsp"%>
	
	<script type="text/javascript">
		$(document).ready(function() {
				//alert("hhh");
			/* $("#loader").load(); */
			var linkId = "1d";
			$("#1d").css("border-bottom-color", "black");
			$(".myButton").on("click", function() {
				linkId = this.id;
				$(".myButton").css("color", "black");
				//$(".myButton").css("border-bottom-color", "lightblue");
				//$(this).css("border-bottom", " 4px solid black");
				//$("#loader").hide();
				$(this).css("color", "#1691D8");
				$(".myButton").css("border-color", "lightblue");
				$(this).css("border-bottom-color", "black");
				//$("#1b").fadeIn("slow");
				$("#loader").empty();
				$('.cssload-container').show();
				$("#loader").load($(this).attr("page"));
				//$('#1b').fadeIn('slow').delay(2500).hide(0);
				return false;

			});
			/* $("#report_btn").click(function() {
				console.log(linkId);
				alert(linkId);
				data = $.parseJSON($.ajax({
					url : '../../CISReport?day=' + linkId,
					dataType : "json",
					async : false
				}).responseText);
				var text = "link";
				console.log(data.path);
			}); */
		});
	</script>
</body>
</html>