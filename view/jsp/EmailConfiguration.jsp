<%@page import="com.mongodb.DBObject"%>
<%@page import="com.mongodb.DBCollection"%>
<%@page import="com.avekshaa.cis.database.CommonDB"%>
<%@page import="com.mongodb.DB"%>
<%@page import="org.apache.xmlbeans.impl.xb.xsdschema.IncludeDocument.Include"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Email Configuration |CIS</title>
<link href='http://netdna.bootstrapcdn.com/bootstrap/3.0.0/css/bootstrap.min.css' rel='stylesheet' type='text/css'>
<style type="text/css">
body{
margin: 0;
}

.indent-small {
  margin-left: 5px;
}

.dialog-panel {
  margin: 10px;
}

.panel-body {
  background: #e5e5e5;
  /* Old browsers */
  background: -moz-radial-gradient(center, ellipse cover, #e5e5e5 0%, #ffffff 100%);
  /* FF3.6+ */
  background: -webkit-gradient(radial, center center, 0px, center center, 100%, color-stop(0%, #e5e5e5), color-stop(100%, #ffffff));
  /* Chrome,Safari4+ */
  background: -webkit-radial-gradient(center, ellipse cover, #e5e5e5 0%, #ffffff 100%);
  /* Chrome10+,Safari5.1+ */
  background: -o-radial-gradient(center, ellipse cover, #e5e5e5 0%, #ffffff 100%);
  /* Opera 12+ */
  background: -ms-radial-gradient(center, ellipse cover, #e5e5e5 0%, #ffffff 100%);
  /* IE10+ */
  background: radial-gradient(ellipse at center, #e5e5e5 0%, #ffffff 100%);
  /* W3C */
  filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#e5e5e5', endColorstr='#ffffff', GradientType=1);
  /* IE6-9 fallback on horizontal gradient */
  font: 600 15px "Open Sans", Arial, sans-serif;
}
label.control-label {
  font-weight: 600;
  color: #777;
}
.col-md-8 {
    width: 50%;
}
.container {
    max-width: 900px;
}
/*  */

    .onoffswitch {
        position: relative; width: 120px;
        -webkit-user-select:none; -moz-user-select:none; -ms-user-select: none;
    }
    .onoffswitch-checkbox {
        display: none;
    }
    .onoffswitch-label {
        display: block; overflow: hidden; cursor: pointer;
        border: 2px solid #999999; border-radius: 20px;
    }
    .onoffswitch-inner {
        display: block; width: 200%; margin-left: -100%;
        transition: margin 0.3s ease-in 0s;
    }
    .onoffswitch-inner:before, .onoffswitch-inner:after {
        display: block; float: left; width: 50%; height: 30px; padding: 0; line-height: 30px;
        font-size: 14px; color: white; font-family: Trebuchet, Arial, sans-serif; font-weight: bold;
        box-sizing: border-box;
    }
    .onoffswitch-inner:before {
        content: "Enabled";
        padding-left: 10px;
        background-color: #34A7C1; color: #FFFFFF;
    }
    .onoffswitch-inner:after {
        content: "Disabled";
        padding-right: 10px;
        background-color: #EEEEEE; color: #999999;
        text-align: right;
    }
    .onoffswitch-switch {
        display: block; width: 18px; margin: 6px;
        background: #FFFFFF;
        position: absolute; top: 0; bottom: 0;
        right: 86px;
        border: 2px solid #999999; border-radius: 20px;
        transition: all 0.3s ease-in 0s; 
    }
    .onoffswitch-checkbox:checked + .onoffswitch-label .onoffswitch-inner {
        margin-left: 0;
    }
    .onoffswitch-checkbox:checked + .onoffswitch-label .onoffswitch-switch {
        right: 0px; 
    }

</style>

</head>
<body id="ec">
<%@include file="AdminHeader.jsp" %>

<%DB db=CommonDB.getConnection();
DBCollection coll=db.getCollection("EmailConfig");
DBObject dbo=coll.findOne();
String emailStatus=dbo.get("Alerting_Status").toString().trim();
String email=dbo.get("email").toString();
String email_cc=dbo.get("cc").toString();
String enable_checked="";
String disable_checked="";
 if("enabled".equals(emailStatus)){
	enable_checked="checked";
}
//System.out.println("enabled: "+enable_checked+" ::disabled :"+disable_checked+"::"+emailStatus);
%>
<center>
<!-- <span style="font-size: 28px; font-family: Open Sans,Arial,sans-serif;">Email Configuration</span> -->
</center>

<!-- <form action="../../EmailConfiguration" method="post" style="float: left;margin-left: 33%;margin-top: 5%"> -->

<head>
  
</head>

  <div class='container'>
    <div class='panel panel-primary dialog-panel'>
      <div class='panel-heading'>
        <h5>Email Configuration</h5>
      </div>
      <div class='panel-body'>
        <form class='form-horizontal' role='form' action="../../EmailConfiguration" method="post">
          <div class='form-group'>
            <label class='control-label col-md-2 col-md-offset-2' for='id_accomodation'>Alerting Engine</label>
             <div class='col-md-2'>
                 <div class="onoffswitch">
       				 <input type="checkbox" name="onoffswitch" class="onoffswitch-checkbox" id="myonoffswitch" value="enabled" <%=enable_checked %>>
        				<label class="onoffswitch-label" for="myonoffswitch">
            				<span class="onoffswitch-inner"></span>
            				<span class="onoffswitch-switch"></span>
        				</label>
    			</div>
            </div> 
          </div>
          
          <div class='form-group'>
            <label class='control-label col-md-2 col-md-offset-2' for='id_email'>Email</label>
            <div class='col-md-6'>
              <div class='form-group'>
                <div class='col-md-11'>
                  <input class='form-control' id='id_email' placeholder='E-mail' type='text' name="email" value="<%=email %>">
                </div>
              </div>
              
            </div>
          </div>
          <div class='form-group'>
            <label class='control-label col-md-2 col-md-offset-2' for='id_email' >cc</label>
            <div class='col-md-8'>
              <div class='form-group'>
                <div class='col-md-11'>
                  <input class='form-control' id='id_cc' placeholder='use ; as separator for multiple emails' type='text' name="cc-email" value="<%=email_cc %>">
                </div>
              </div>
              
            </div>
          </div>
         
          <div class='form-group'>
            <div class='col-md-offset-4 col-md-3'>
              <button class='btn-lg btn-primary' type='submit'>Apply</button>
            </div>
            <div class='col-md-3'>
              <button class='btn-lg btn-danger' style='float:right' type="reset">Reset</button>
            </div>
          </div>
        </form>
      </div>
    </div>
  </div>
<!-- footer included -->
<%@include file="Footer.jsp" %>
</body>
</html>