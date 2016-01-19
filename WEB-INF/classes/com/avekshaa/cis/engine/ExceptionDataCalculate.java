package com.avekshaa.cis.engine;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import com.avekshaa.cis.database.CommonDB;
import com.mongodb.AggregationOutput;
import com.mongodb.BasicDBObject;
import com.mongodb.DB;
import com.mongodb.DBCollection;
import com.mongodb.DBCursor;
import com.mongodb.DBObject;

public class ExceptionDataCalculate {
	static DB databaseName;
	static DB database_CIS;
	// static MongoClient mc;
	// static DB threshold;

	static {
		// mc = CommonDB.generalConnection();
		databaseName = CommonDB.getBankConnection();
		database_CIS = CommonDB.getConnection();
		// threshold = CommonDB.getBankConnection();
	}

	public static long CalculateDay(String day) {
		long l = 0L;
		long millisInDay = 60 * 60 * 24 * 1000;
		long currentTime = new Date().getTime();
		long dateOnly = ((currentTime / millisInDay) * millisInDay) - 330 * 60 * 1000;
		if (day == null) {
			return dateOnly;
		}
		int i = Integer.parseInt(day);
		if (i == 1) {
			return dateOnly;
		} else if (i == 7) {
			System.out.println("for 7 match");
			DateFormat dateFormat = new java.text.SimpleDateFormat(
					"dd MMM yyyy - HH:mm");
			String todate = dateFormat.format(dateOnly);
			Calendar cal = Calendar.getInstance();
			cal.add(Calendar.DATE, -7);
			Date todate1 = cal.getTime();
			return todate1.getTime();
		} else if (i == 30) {
			System.out.println("for 30 match");
			DateFormat dateFormat = new java.text.SimpleDateFormat(
					"dd MMM yyyy - HH:mm");
			String todate = dateFormat.format(dateOnly);
			Calendar cal = Calendar.getInstance();
			cal.add(Calendar.DATE, -30);
			Date todate1 = cal.getTime();
			return todate1.getTime();
		} else {
			System.out.println("for no match");
			return dateOnly;
		}
	}

	public static int ExceptionCount(String day) {
		// System.out.println("inside count crashes");
		try {
			long l = CalculateDay(day);
			DBCollection collectionName = databaseName.getCollection("Error");
			DBObject findObj = new BasicDBObject("StartTime",
					new BasicDBObject("$gt", l));
			int Count = collectionName.find(findObj).count();
			return Count;
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return 0;
	}

	// / calculate mobile incident data compare with previous date data

	public static String CompareExceptionCount_mobile(String day) {
		try {

			// date1 end
			long l1 = System.currentTimeMillis();
			SimpleDateFormat df = new SimpleDateFormat(
					"yyyy-MM-dd HH:mm:ss.SSS");
			// date 1 start
			Calendar cal = Calendar.getInstance();
			DateFormat dateFormat2 = new SimpleDateFormat(
					"yyyy-MM-dd 00:00:01.001");
			String date_now2 = dateFormat2.format(cal.getTime());
			Date date2 = df.parse(date_now2);
			long l2 = date2.getTime();
			// System.out.println(l2+"l2");

			// date 2 end
			DateFormat dateFormat3 = new SimpleDateFormat(
					"yyyy-MM-dd 23:59:30.989");
			cal.add(Calendar.DATE, -1);
			String date_3 = dateFormat3.format(cal.getTime());
			Date date3 = df.parse(date_3);
			long l3 = date3.getTime();
			// System.out.println(l3+"l3");

			// date 2 start
			DateFormat dateFormat4 = new SimpleDateFormat(
					"yyyy-MM-dd 00:00:01.875");
			String date_4 = dateFormat4.format(cal.getTime());
			// System.out.println("QQQQQQ "+dateFormat4.parse(date_4));
			Date date4 = df.parse(date_4);
			long l4 = date4.getTime();
			// System.out.println(l4+"l4");

			DBCollection collectionName = databaseName.getCollection("Error");
			DBObject findObj = new BasicDBObject("StartTime",
					new BasicDBObject("$gt", l2).append("$lt", l1));
			int Count_present_day = collectionName.find(findObj).count();
			DBObject findObj_01 = new BasicDBObject("StartTime",
					new BasicDBObject("$gt", l4).append("$lt", l3));
			int Count_previous_day = collectionName.find(findObj_01).count();
			String overall = Count_previous_day + ";" + Count_present_day;
			return overall;
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return null;
	}

	// ////////////////Calculate incident for web comparison with previous date
	// data
	public static String CompareExceptionCount_Web(String day) {
		// System.out.println("inside count crashes");
		try {
			int Count_present_day = 0;
			int Count_previous_day = 0;

			// date1 end
			long l1 = System.currentTimeMillis();
			SimpleDateFormat df = new SimpleDateFormat(
					"yyyy-MM-dd HH:mm:ss.SSS");
			// date 1 start
			Calendar cal = Calendar.getInstance();
			DateFormat dateFormat2 = new SimpleDateFormat(
					"yyyy-MM-dd 00:00:01.001");
			String date_now2 = dateFormat2.format(cal.getTime());
			Date date2 = df.parse(date_now2);
			long l2 = date2.getTime();
			// System.out.println(l2+"l2");

			// date 2 end
			DateFormat dateFormat3 = new SimpleDateFormat(
					"yyyy-MM-dd 23:59:30.989");
			cal.add(Calendar.DATE, -1);
			String date_3 = dateFormat3.format(cal.getTime());
			Date date3 = df.parse(date_3);
			long l3 = date3.getTime();
			// System.out.println(l3+"l3");

			// date 2 start
			DateFormat dateFormat4 = new SimpleDateFormat(
					"yyyy-MM-dd 00:00:01.875");
			String date_4 = dateFormat4.format(cal.getTime());
			// System.out.println("QQQQQQ "+dateFormat4.parse(date_4));
			Date date4 = df.parse(date_4);
			long l4 = date4.getTime();
			// System.out.println(l4+"l4");

			DBCollection collectionName = database_CIS
					.getCollection("CISResponse");
			// present day
			DBObject match1 = new BasicDBObject("$match",
					new BasicDBObject("exectime", new BasicDBObject("$gte", l2)
							.append("$lt", l1)).append("status_Code",
							new BasicDBObject("$gt", 399)));
			DBObject group1 = new BasicDBObject("$group", new BasicDBObject(
					"_id", "$status_Code").append("count", new BasicDBObject(
					"$sum", 1)));
			AggregationOutput output1 = collectionName
					.aggregate(match1, group1);
			StringBuilder sb = new StringBuilder();
			// System.out.println("p1a"+output1.toString());
			// System.out.println("output" + output1.toString());
			for (DBObject results1 : output1.results()) {
				String s = results1.get("_id").toString();
				Count_present_day += (int) results1.get("count");
			}
			// past day
			DBObject match2 = new BasicDBObject("$match",
					new BasicDBObject("exectime", new BasicDBObject("$gt", l4)
							.append("$lt", l3)).append("status_Code",
							new BasicDBObject("$gt", 399)));
			DBObject group2 = new BasicDBObject("$group", new BasicDBObject(
					"_id", "$status_Code").append("count", new BasicDBObject(
					"$sum", 1)));
			AggregationOutput output2 = collectionName
					.aggregate(match2, group2);
			StringBuilder sb2 = new StringBuilder();
			// System.out.println("p2s"+output2.toString());

			// System.out.println("output" + output1.toString());
			for (DBObject results2 : output2.results()) {
				// System.out.println("p1");

				String s2 = results2.get("_id").toString();
				Count_previous_day += (int) results2.get("count");

			}
			String overall = Count_previous_day + ";" + Count_present_day;
			// System.out.println("present=: "+Count_present_day+"prev: "+Count_previous_day);
			return overall;

		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return null;
	}

	// /////////////////////////////////////////////////

	public String Exception(String value, String day) {

		try {
			long l = CalculateDay(day);
			DBCollection andavg = databaseName.getCollection("Error");
			DBObject match1 = new BasicDBObject("$match", new BasicDBObject(
					"StartTime", new BasicDBObject("$gte", l)));
			DBObject group1 = new BasicDBObject("$group", new BasicDBObject(
					"_id", value).append("count", new BasicDBObject("$sum", 1)));
			AggregationOutput output1 = andavg.aggregate(match1, group1);
			StringBuilder sb = new StringBuilder();
			// System.out.println("output" + output1.toString());
			for (DBObject results1 : output1.results()) {
				// if(results1.get("_id").toString().trim())
				String s = results1.get("_id").toString();
				s = s.replaceAll(":", " ");
				s = s.replaceAll("'", " ");
				sb.append("{name:'" + s + "','y':"
						+ results1.get("count").toString() + "},");
			}
			return sb.toString();
		} catch (Exception exe) {
			exe.printStackTrace();
		}
		return null;
	}

	public static String WebException(String day) {
		try {
			long l = CalculateDay(day);

			DBCollection andavg = database_CIS.getCollection("CISResponse");
			DBObject match1 = new BasicDBObject("$match", new BasicDBObject(
					"exectime", new BasicDBObject("$gte", l)).append(
					"status_Code", new BasicDBObject("$gt", 399)));
			DBObject group1 = new BasicDBObject("$group", new BasicDBObject(
					"_id", "$status_Code").append("count", new BasicDBObject(
					"$sum", 1)));
			AggregationOutput output1 = andavg.aggregate(match1, group1);
			StringBuilder sb = new StringBuilder();
			// System.out.println("output" + output1.toString());
			for (DBObject results1 : output1.results()) {
				String s = results1.get("_id").toString();
				sb.append("{name:'" + s + "','y':"
						+ results1.get("count").toString() + "},");
			}
			System.out.println("--------------" + sb.toString());
			return sb.toString();
		} catch (Exception exe) {
			exe.printStackTrace();
		}
		return null;
	}

	/*
	 * public static void main(String[] args) {
	 * ExceptionDataCalculate.Alerts("7"); }
	 */

	public static int WebException_count(String day) {
		try {
			int counter = 0;
			long l = CalculateDay(day);

			DBCollection andavg = database_CIS.getCollection("CISResponse");
			DBObject match1 = new BasicDBObject("$match", new BasicDBObject(
					"exectime", new BasicDBObject("$gte", l)).append(
					"status_Code", new BasicDBObject("$gt", 399)));
			DBObject group1 = new BasicDBObject("$group", new BasicDBObject(
					"_id", "$status_Code").append("count", new BasicDBObject(
					"$sum", 1)));
			AggregationOutput output1 = andavg.aggregate(match1, group1);
			StringBuilder sb = new StringBuilder();
			// System.out.println("output" + output1.toString());
			for (DBObject results1 : output1.results()) {
				String s = results1.get("_id").toString();
				counter += (int) results1.get("count");
				// sb.append("{name:'" + s + "','y':" +
				// results1.get("count").toString() + "},");
			}
			System.out.println("--------------" + sb.toString());
			return counter;
		} catch (Exception exe) {
			exe.printStackTrace();
		}
		return 0;
	}

	public static int Alerts(String day) {
		try {
			// ---------------------**----------------------
			long numday = CalculateDay(day);
			// -------------------****
			DBCollection collection3 = databaseName
					.getCollection("ThresholdDB");
			DBCursor cursor3 = collection3.find();
			cursor3.sort(new BasicDBObject("_id", -1)).limit(1);
			DBObject resp_thres_obj = cursor3.next();
			long l = Long.parseLong(resp_thres_obj.get("Android_threshold")
					.toString());
			System.out.println(l);
			// -------------------------------------

			DBCollection andavg = databaseName.getCollection("Regular");
			DBObject match1 = new BasicDBObject("$match", new BasicDBObject(
					"StartTime", new BasicDBObject("$gte", numday)).append(
					"duration", new BasicDBObject("$gt", l)));
			// System.out.println(match1);
			DBObject group1 = new BasicDBObject("$group", new BasicDBObject(
					"_id", "$duration").append("count", new BasicDBObject(
					"$sum", 1)));
			// System.out.println(group1);
			AggregationOutput output1 = andavg.aggregate(match1, group1);
			// System.out.println(output1);
			int k = 0;
			for (DBObject results1 : output1.results()) {
				k += Integer.parseInt(results1.get("count").toString());
			}
			// System.out.println(k);
			return k;
		} catch (Exception exe) {
			exe.printStackTrace();
		}
		return 0;
	}

	public static int Web_Alerts(String day) {
		try {
			// ---------------------**----------------------
			long numday = CalculateDay(day);
			// -------------------****
			DBCollection collection3 = databaseName
					.getCollection("ThresholdDB");
			DBCursor cursor3 = collection3.find();
			cursor3.sort(new BasicDBObject("_id", -1)).limit(1);
			DBObject resp_thres_obj = cursor3.next();
			long l = Long.parseLong(resp_thres_obj.get("Android_threshold")
					.toString());
			System.out.println(l);
			// -------------------------------------

			DBCollection andavg = database_CIS.getCollection("CISResponse");
			DBObject match1 = new BasicDBObject("$match", new BasicDBObject(
					"exectime", new BasicDBObject("$gte", numday)).append(
					"response_time", new BasicDBObject("$gt", l)));
			// System.out.println("first print"+match1);
			DBObject group1 = new BasicDBObject("$group", new BasicDBObject(
					"_id", "$response_time").append("count", new BasicDBObject(
					"$sum", 1)));
			// System.out.println("second print"+group1);
			AggregationOutput output1 = andavg.aggregate(match1, group1);
			// System.out.println("third print"+output1);
			int k = 0;
			for (DBObject results1 : output1.results()) {
				k += Integer.parseInt(results1.get("count").toString());
				// System.out.println("fourth print"+k);
			}
			// System.out.println(k);
			return k;
		} catch (Exception exe) {
			exe.printStackTrace();
		}
		return 0;
	}

}
