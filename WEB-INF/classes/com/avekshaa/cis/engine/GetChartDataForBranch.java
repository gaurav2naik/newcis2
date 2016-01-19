package com.avekshaa.cis.engine;

import java.text.DecimalFormat;
import java.util.Date;
import java.util.List;

import com.avekshaa.cis.database.CommonDB;
import com.mongodb.AggregationOutput;
import com.mongodb.BasicDBObject;
import com.mongodb.DB;
import com.mongodb.DBCollection;
import com.mongodb.DBCursor;
import com.mongodb.DBObject;

public class GetChartDataForBranch {
	static DB db = null;
	static DB bankDb = null;
	static {
		db = CommonDB.getConnection();
		bankDb = CommonDB.getBankConnection();
	}

	public String getTopFiveUsersWithHighestResponse() {
		System.out.println("getTopFiveUsersWithHighestResponse called");
		String data = "";
		StringBuilder sb = new StringBuilder();
		try {

			long time = System.currentTimeMillis();
			long beforetime = time - (60 * 60 * 1000);

			DBCollection cisResponse = db.getCollection("CISResponse");
			// System.out.println("count: " + cisResponse.count());
			DBObject match = new BasicDBObject("$match", new BasicDBObject(
					"exectime", new BasicDBObject("$gt", beforetime)));
			DBObject groupFields = new BasicDBObject("_id", "$IP_Address");
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
				String branchUser = (String) result.get("_id");
				double avgResponseTimeForBranchUser = (Double) result
						.get("averageresponse");
				double formattedAvg = Double.parseDouble(new DecimalFormat(
						"##.##").format(avgResponseTimeForBranchUser));
				// System.out.println("User :" + branchUser +
				// " :: Avg Response :"
				// + avgResponseTimeForBranchUser);

				sb.append("{\"name\":\"<b>Users :</b>" + branchUser
						+ "<br><b>Avg Response :</b>" + formattedAvg
						+ "\", \"y\":" + formattedAvg + "},");

			}
		} catch (Exception e)

		{
			e.printStackTrace();
		}

		// DBCursor cur = bufferUsage.find(findObj);

		data = sb.toString();
		if (!data.equals("")) {
			data = data.substring(0, data.length() - 1);
		}
		data = "[" + data + "]";
		// System.out.println(data);
		return data;
	}

	// Top five user with highest error
	public String getTopFiveUsersWithHighestError() {
		System.out.println("getTopFiveUsersWithHighestError called");
		String data = "";
		StringBuilder sb = new StringBuilder();
		try {
			long time = System.currentTimeMillis();
			long beforetime = time - (60 * 60 * 1000);

			DBCollection cisResponse = db.getCollection("CISResponse");
			// System.out.println("count: " + cisResponse.count());
			DBObject match = new BasicDBObject("$match", new BasicDBObject(
					"exectime", new BasicDBObject("$gt", beforetime)).append(
					"status_Code", new BasicDBObject("$gt", 399)));
			DBObject groupFields = new BasicDBObject("_id", "$IP_Address");
			groupFields.put("Count", new BasicDBObject("$sum", 1));
			DBObject group = new BasicDBObject("$group", groupFields);
			// group.put("$sort", new BasicDBObject("totalhit",-1));
			DBObject sort = new BasicDBObject("$sort", new BasicDBObject(
					"Count", -1));
			DBObject limit = new BasicDBObject("$limit", 5);
			AggregationOutput output = cisResponse.aggregate(match, group,
					sort, limit);

			for (DBObject result : output.results()) {
				String branchUser = (String) result.get("_id");
				int errorCount = (int) result.get("Count");

				// System.out.println("User :" + branchUser
				// + " :: Total Error Count :" + errorCount);

				sb.append("{\"name\":\"<b>Users :</b>" + branchUser
						+ "<br><b>Error Count :</b>" + errorCount
						+ "\", \"y\":" + errorCount + "},");

			}
		} catch (Exception e)

		{
			e.printStackTrace();
		}
		System.out.println("sb capacity :" + sb.capacity());

		data = sb.toString();
		if (!data.equals("")) {
			System.out.println("^^^^^^^^^" + data);
			data = data.substring(0, data.length() - 1);
		}
		data = "[" + data + "]";

		// System.out.println(data);
		return data;
	}

	public String getTopFiveURL() {
		String data = "";
		try {
			DB db = CommonDB.getConnection();
			long time = System.currentTimeMillis();
			long beforetime = time - (60 * 60 * 1000);

			StringBuilder sb = new StringBuilder();
			DBCollection cisResponse = db.getCollection("CISResponse");
			DBObject match = new BasicDBObject("$match", new BasicDBObject(
					"exectime", new BasicDBObject("$gt", beforetime)));
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

	public double getApdexScore() {
		
		double CurrentDayApdexAvg = 0d;
		long millisInDay = 60 * 60 * 24 * 1000;
		long currentTime = new Date().getTime();
		long dateOnly = ((currentTime / millisInDay) * millisInDay) - 330 * 60 * 1000;

		try {
			DBCollection coll = db.getCollection("OneHourWebAvg");
			////////////////////////////////
			DBObject match1 = new BasicDBObject("$match", new BasicDBObject("time",
					new BasicDBObject("$gte", dateOnly)));
			DBObject group1 = new BasicDBObject("$group", new BasicDBObject("_id",
					"").append("CurrentDayApdexAvg", new BasicDBObject("$avg",
					"$OneHourApdex")));
			AggregationOutput output1 = coll.aggregate(match1, group1);
			
			for (DBObject results2 : output1.results()) {
				CurrentDayApdexAvg = Double.valueOf(results2.get("CurrentDayApdexAvg")
						.toString());
				CurrentDayApdexAvg = Double.parseDouble(new DecimalFormat("##.##")
						.format(CurrentDayApdexAvg));
			}
		///////////////////////////////	

		} catch (Exception e) {
			e.printStackTrace();
		}
		System.out.println("Apdex Score :" + CurrentDayApdexAvg);
		return CurrentDayApdexAvg;

	}

	public double getDayApdexScore_mobile(int numberOfDay) {
		double apdex = 0;
		int size=0;
		try {
			DBCollection coll = bankDb.getCollection("OneDayAvgOfApp");
			DBObject sortObj = new BasicDBObject("_id", -1);
			List<DBObject> dataList = coll.find().sort(sortObj)
					.limit(numberOfDay).toArray();
				size=dataList.size();
			System.out.println(dataList.size() + "   >>>>>>>>>>>>>");
			System.out.println("test data after tostring"+dataList.toString());
			for (int i = 0;i<=dataList.size() - 1; i++) {
				DBObject obj = dataList.get(i);
				System.out.println("val pointer is here");
			System.out.println("parsedouble  :"+(obj.toString()));
				apdex += Double.parseDouble(obj.get("OneDayApdexAvg")
						.toString());
				System.out.println("apdex 1 :"+apdex);

			}
			
		} catch (Exception e) {
System.out.println("Exception in mobile is "+e);
		}
		try{
		apdex = apdex / size;
		apdex = Double
				.parseDouble(new DecimalFormat("##.##").format(apdex));
		System.out.println("apdex 2 :"+apdex);
		}
		catch(Exception e){
			apdex=0;
			System.out.println(e);
		}
		return apdex;
	}

	public double getDayApdexScore_web(int numberOfDay) {
		double apdex = 0;
		int size=0;
		try {
			DBCollection coll = db.getCollection("OneDayAvgOfWeb");
			DBObject sortObj = new BasicDBObject("_id", -1);
			List<DBObject> dataList = coll.find().sort(sortObj)
					.limit(numberOfDay).toArray();
			size=dataList.size();

			for (int i = 0;i<=dataList.size() - 1; i++) {
				DBObject obj = dataList.get(i);
				apdex += Double.parseDouble(obj.get("OneDayApdexAvg").toString());
			}
		} catch (Exception e) {
System.out.println("Exception is: "+e);
		}
		try{
		apdex = apdex / size;
		apdex = Double
				.parseDouble(new DecimalFormat("##.##").format(apdex));
		}catch(Exception e){
			apdex=0;
		}
		return apdex;
	}

	public double getApdexScore_mobile() {
		
		long millisInDay = 0l;
		long currentTime = 0l;
		double CurrentDayApdexAvg = 0d;
		long dateOnly = 0l;
		try {
			DBCollection coll = bankDb.getCollection("mobile_APDEX");
			/////////////////////////  !3 Jan evening//////////////////
			millisInDay = 60 * 60 * 24 * 1000;
			currentTime = new Date().getTime();
			dateOnly = (((currentTime / millisInDay) * millisInDay) - 330 * 60 * 1000)
					- (7 * 24 * 60 * 60 * 1000);
			DBObject match1 = new BasicDBObject("$match", new BasicDBObject("exec_time",
					new BasicDBObject("$gte", dateOnly)));
			DBObject group1 = new BasicDBObject("$group", new BasicDBObject("_id",
					"").append("CurrentDayApdexAvg",
					new BasicDBObject("$avg", "$Apdex")));
			AggregationOutput output1 = coll.aggregate(match1, group1);
			
			for (DBObject results1 : output1.results()) {
				CurrentDayApdexAvg= Double.valueOf(results1.get("CurrentDayApdexAvg")
						.toString());
				
			}
			CurrentDayApdexAvg = Double.parseDouble(new DecimalFormat("##.##")
			.format(CurrentDayApdexAvg));
			///////////////////////////////////////
			
			/*DBObject sortObj = new BasicDBObject("_id", -1);
			DBCursor cur = coll.find().sort(sortObj).limit(1);
			apdexScore = (double) cur.next().get("Apdex");
			apdexScore = Double.parseDouble(new DecimalFormat("##.##")
					.format(apdexScore));*/
		} catch (Exception e) {
			e.printStackTrace();
		}
		System.out.println("Apdex Score :" + CurrentDayApdexAvg);
		return CurrentDayApdexAvg;

	}

	public static void main(String[] args) {
		new GetChartDataForBranch().getTopFiveUsersWithHighestError();
	}
}
