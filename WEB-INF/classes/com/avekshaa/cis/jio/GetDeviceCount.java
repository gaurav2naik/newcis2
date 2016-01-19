package com.avekshaa.cis.jio;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.avekshaa.cis.database.CommonDB;
import com.mongodb.BasicDBObject;
import com.mongodb.DB;
import com.mongodb.DBCollection;

/**
 * Servlet implementation class GetAndroidJsonData
 */
public class GetDeviceCount extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		System.out.println("in side servlet");
		PrintWriter out = response.getWriter();

		try {
			long time = System.currentTimeMillis() - 60000;
			DB db = CommonDB.getBankConnection();
			DB db1 = CommonDB.getConnection();
			DBCollection coll = db.getCollection("Regular");
			DBCollection coll1 = db1.getCollection("CISResponse");
			BasicDBObject objs = new BasicDBObject("response_time",
					new BasicDBObject("$gt", time));
			BasicDBObject objs1 = new BasicDBObject("exectime",
					new BasicDBObject("$gt", time));
			int webUserCount = coll1.distinct("IP_Address", objs1).size();
			/*
			 * List cityList = coll.distinct("city", objs);
			 * cityList.remove("GPS not available !!!");
			 */
			int appUserCount = coll.distinct("UUID", objs).size();
			System.out.println("count is : " + webUserCount + appUserCount);
			out.print("{\"WebUserCount\":" + webUserCount
					+ ",\"AppUserCount\":" + appUserCount + "}");

		} catch (Exception ex) {
			ex.printStackTrace();
		}

	}

}
