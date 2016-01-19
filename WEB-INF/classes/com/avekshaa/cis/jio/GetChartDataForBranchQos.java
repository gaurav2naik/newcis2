package com.avekshaa.cis.jio;

import java.text.DecimalFormat;
import java.util.Date;
import java.util.List;

import com.avekshaa.cis.commonutil.Convertor;
import com.avekshaa.cis.database.CommonDB;
import com.mongodb.AggregationOutput;
import com.mongodb.BasicDBObject;
import com.mongodb.DB;
import com.mongodb.DBCollection;
import com.mongodb.DBCursor;
import com.mongodb.DBObject;

public class GetChartDataForBranchQos {
	public static String CrashCategoryData;
	static DB db = null;
	static {
		if (db != null)
			db = CommonDB.getConnection();
	}

	public static String getBranchCrashData(int numberOfDay, String Branch_IP) {
		System.out.println("getBranchCrashData called :" + numberOfDay + ","
				+ Branch_IP);
		String branch_IP = Branch_IP.trim();
		String returnString = "";
		StringBuilder sb = new StringBuilder();
		StringBuilder crashCategory = new StringBuilder();
		db = CommonDB.getConnection();
		DBCursor cur = null;
		if (numberOfDay == 1) {
			long millisInDay = 60 * 60 * 24 * 1000;
			long currentTime = new Date().getTime();
			long dateOnly = ((currentTime / millisInDay) * millisInDay) - 330 * 60 * 1000;
			DBCollection coll = db.getCollection("OneHourBranchAvg");

			BasicDBObject findObj1 = new BasicDBObject();
			findObj1.put("time", new BasicDBObject("$gt", dateOnly));
			findObj1.put("IP_Address", branch_IP);
			cur = coll.find(findObj1);
			System.out.println("Branch Crash Data Count :" + cur.count());

			while (cur.hasNext()) {
				DBObject obj = cur.next();
				long longTime = Long.parseLong(obj.get("time").toString());
				String TimeforCategory = Convertor.timeInHourMin(longTime);
				String time = Convertor.timeInDefaultFormat(longTime);
				int webCrashCount = Integer.parseInt(obj.get(
						"OneHourErrorCount").toString());

				sb.append("{y:" + webCrashCount + ",extra:'" + time + "'},");
				crashCategory.append("'" + TimeforCategory + "',");
				System.out.println("branch Crash Count :" + sb.toString());
			}
		}
		if (numberOfDay >= 7) {
			DBCollection coll = db.getCollection("OneDayAvgOfWeb");
			DBObject sort = new BasicDBObject("_id", -1);
			List<DBObject> resultList = coll.find().sort(sort)
					.limit(numberOfDay).toArray();
			for (int i = resultList.size() - 1; i >= 0; i--) {
				DBObject obj = resultList.get(i);
				String time = Convertor.timeInDateFormat(Long.parseLong(obj
						.get("time").toString()));
				// System.out.println(obj.get("OneDayAvgResponseTime"));
				int crashCount = Integer.parseInt(obj.get("OneDayErrorCount")
						.toString());

				// System.out.println(avg);
				sb.append("{y:" + crashCount + ",extra:'" + time + "'},");
			}
		}

		returnString = sb.toString();
		CrashCategoryData = crashCategory.toString();
		System.out.println("getWebCrashData Return : " + returnString);
		return returnString;
	}

	// --------------------------------------------Branch Hits
	// Data-------------------//
	public static String getBranchHitsData(int numberOfDay, String Branch_IP) {
		String returnString = "";
		String branch_IP = Branch_IP.trim();

		StringBuilder sb = new StringBuilder();
		DB db = CommonDB.getConnection();
		DBCursor cur = null;
		if (numberOfDay == 1) {
			long millisInDay = 60 * 60 * 24 * 1000;
			long currentTime = new Date().getTime();
			long dateOnly = ((currentTime / millisInDay) * millisInDay) - 330 * 60 * 1000;
			DBCollection coll = db.getCollection("OneHourBranchAvg");

			BasicDBObject findObj1 = new BasicDBObject();
			findObj1.put("time", new BasicDBObject("$gt", dateOnly));
			findObj1.put("IP_Address", branch_IP);
			cur = coll.find(findObj1);
			while (cur.hasNext()) {
				DBObject obj = cur.next();

				String time = Convertor.timeInDefaultFormat(Long.parseLong(obj
						.get("time").toString()));
				int webHits = Integer.parseInt(obj.get("OneHourHits")
						.toString());

				sb.append("{y:" + webHits + ",extra:'" + time + "'},");
				// System.out.println(webHits);
			}
		}
		if (numberOfDay >= 7) {
			DBCollection coll = db.getCollection("OneDayAvgOfWeb");
			DBObject sort = new BasicDBObject("_id", -1);
			List<DBObject> resultList = coll.find().sort(sort)
					.limit(numberOfDay).toArray();
			for (int i = resultList.size() - 1; i >= 0; i--) {
				DBObject obj = resultList.get(i);
				String time = Convertor.timeInDateFormat(Long.parseLong(obj
						.get("time").toString()));
				// System.out.println(obj.get("OneDayAvgResponseTime"));
				int hitsCount = Integer.parseInt(obj.get("OneDayHits")
						.toString());

				// System.out.println(avg);
				sb.append("{y:" + hitsCount + ",extra:'" + time + "'},");
			}
		}

		returnString = sb.toString();
		System.out.println("getBranchHitsData return :" + returnString);
		return returnString;
	}

	// --------------------------------------------------------------------------------------

	public static String getBranchTopFiveURL(int numberOfDay, String Branch_IP) {
		String data = "";
		String branchIP = Branch_IP.trim();
		try {
			DB db = CommonDB.getConnection();
			long time = System.currentTimeMillis();
			long beforetime = time - (60 * 60 * 1000);

			StringBuilder sb = new StringBuilder();
			DBCollection cisResponse = db.getCollection("CISResponse");
			DBObject match = new BasicDBObject("$match", new BasicDBObject(
					"exectime", new BasicDBObject("$gt", beforetime)).append(
					"IP_Address", branchIP));
			DBObject groupFields = new BasicDBObject("_id", "$URI");
			groupFields.put("averageresponse", new BasicDBObject("$avg",
					"$response_time"));
			DBObject group = new BasicDBObject("$group", groupFields);
			// group.put("$sort", new BasicDBObject("totalhit",-1));
			DBObject sort = new BasicDBObject("$sort", new BasicDBObject(
					"averageresponse", -1));
			DBObject limit = new BasicDBObject("$limit", 5);
			AggregationOutput output = cisResponse.aggregate(match, group,
					sort, limit);

			for (DBObject result : output.results()) {
				String URI = (String) result.get("_id");
				double avgResponseTimeOfURI = (Double) result
						.get("averageresponse");
				double formattedAvg = Double.parseDouble(new DecimalFormat(
						"##.##").format(avgResponseTimeOfURI));
				// System.out.println("URI :"+URI+" :: Avg Response :"+avgResponseTimeOfURI);
				sb.append("{y:" + formattedAvg + ",extra:\"" + URI + "\"},");

			}
			data = sb.toString();
		} catch (Exception e)

		{
			e.printStackTrace();
		}
		return data;

	}

	// ---------------------------------------------------------------------------------

	public static String getBranchResposeData(int numberOfDay, String Branch_IP) {
		String branchIP = Branch_IP.trim();
		String returnString = "";
		StringBuilder sb = new StringBuilder();
		DB db = CommonDB.getConnection();
		DBCursor cur = null;
		if (numberOfDay == 1) {
			long millisInDay = 60 * 60 * 24 * 1000;
			long currentTime = new Date().getTime();
			long dateOnly = ((currentTime / millisInDay) * millisInDay) - 330 * 60 * 1000;
			DBCollection coll = db.getCollection("OneHourBranchAvg");
			// System.out.println(dateOnly);
			DBObject sort = new BasicDBObject("_id", -1);
			BasicDBObject findObj1 = new BasicDBObject();
			findObj1.put("time", new BasicDBObject("$gt", dateOnly));
			findObj1.put("IP_Address", branchIP);
			cur = coll.find(findObj1);
			while (cur.hasNext()) {
				DBObject obj = cur.next();
				// System.out.println(Long.parseLong(obj
				// .get("time").toString()));
				String time = Convertor.timeInDefaultFormat(Long.parseLong(obj
						.get("time").toString()));
				// System.out.println(time);
				DBObject subObj = (DBObject) obj.get("OneHourAvgResponseTime");

				double avg = Double.parseDouble(new DecimalFormat("##.##")
						.format(subObj.get("OneHourAvg")));
				sb.append("{y:" + avg + ",extra:'" + time + "'},");
				// System.out.println(avg);
			}
		}
		if (numberOfDay >= 7) {
			DBCollection coll = db.getCollection("OneDayAvgOfWeb");
			DBObject sort = new BasicDBObject("_id", -1);
			List<DBObject> resultList = coll.find().sort(sort)
					.limit(numberOfDay).toArray();
			// System.out.println(resultList.size());
			for (int i = resultList.size() - 1; i >= 0; i--) {
				DBObject obj = resultList.get(i);
				String time = Convertor.timeInDateFormat(Long.parseLong(obj
						.get("time").toString()));
				// System.out.println(obj.get("OneDayAvgResponseTime"));
				DBObject obj1 = (DBObject) obj.get("OneDayAvgResponseTime");
				double avg = Double.parseDouble(new DecimalFormat("##.##")
						.format(obj1.get("OneDayAvg")));
				// System.out.println(avg);
				sb.append("{y:" + avg + ",extra:'" + time + "'},");
			}
		}

		returnString = sb.toString();
		System.out.println("getWebResposeData return " + returnString);
		return returnString;
	}

	public static String GetBranchName(String Branch_IP) {
		DBCollection coll = db.getCollection("XLsheet");
		System.out.println("Get Branch Name Called " + Branch_IP);
		DBObject findObj = new BasicDBObject("IP_address", Branch_IP.trim());
		DBObject cur = coll.findOne(findObj);
		String BranchName = cur.get("Identification_code").toString();
		System.out.println("Branch Name " + BranchName);
		return BranchName;
	}

	public static void main(String[] args) {
		GetChartDataForBranchQos.getBranchCrashData(1, "127.0.0.1");
	}

}
