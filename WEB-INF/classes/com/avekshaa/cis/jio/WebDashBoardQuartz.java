package com.avekshaa.cis.jio;

import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

import com.avekshaa.cis.database.CommonDB;
import com.avekshaa.cis.predict.LinReg;
import com.avekshaa.cis.quartzjob.MapCode;
import com.mongodb.AggregationOutput;
import com.mongodb.BasicDBObject;
import com.mongodb.DB;
import com.mongodb.DBCollection;
import com.mongodb.DBCursor;
import com.mongodb.DBObject;

public class WebDashBoardQuartz implements Job {
	static DB db;
	static DB db1;
	static {
		db = CommonDB.getConnection();
		db1 = CommonDB.getBankConnection();
	}

	@Override
	public void execute(JobExecutionContext arg0) throws JobExecutionException {
		// TODO Auto-generated method stub
		System.out.println("In side WebDashBoardQuartz");
		long startTime = System.currentTimeMillis();
		long endTime = startTime - (60 * 60 * 1000);
		int OneHourTotalCount = 0;
		int OneHourErrorCount = 0;
		double OneHourTotalSum = 0d;
		double OneHourAvg = 0d;
		double value = 0d;

		DBCursor apdex_cursor = null;

		DBCollection CISResponse = db.getCollection("CISResponse");
		DBCollection oneHourWebAvg = db.getCollection("OneHourWebAvg");

		// match obj
		DBObject match = new BasicDBObject("$match", new BasicDBObject(
				"exectime", new BasicDBObject("$gte", endTime)));
		DBObject group = new BasicDBObject("$group", new BasicDBObject("_id",
				"").append("OneHourTotalSum",
				new BasicDBObject("$sum", "$response_time")).append(
				"OneHourTotalcount", new BasicDBObject("$sum", 1)));
		AggregationOutput output1 = CISResponse.aggregate(match, group);
		System.out.println("output" + output1.toString());

		BasicDBObject innerdoc = new BasicDBObject();
		BasicDBObject doc = new BasicDBObject();
		boolean dataFlag = true;
		for (DBObject results1 : output1.results()) {
			dataFlag = false;
			System.out.println("hhhhhhhh");
			OneHourTotalCount = Integer.parseInt(results1.get(
					"OneHourTotalcount").toString());
			OneHourTotalSum = Double.valueOf(results1.get("OneHourTotalSum")
					.toString());

			if (OneHourTotalCount != 0)
				OneHourAvg = OneHourTotalSum / OneHourTotalCount;
			System.out.println("OneDayTotalSum " + OneHourTotalSum + " ::"
					+ " OneDayTotalcount :" + OneHourTotalCount
					+ ":: OneDayAvg :" + OneHourAvg);

			innerdoc.put("OneHourTotalSum", OneHourTotalSum);
			innerdoc.put("OneHourTotalcount", OneHourTotalCount);
			innerdoc.put("OneHourAvg", OneHourAvg);
			doc.put("time", new Date().getTime());
			doc.put("OneHourAvgResponseTime", innerdoc);

			// ------------------------------OneHourHits--------------------------------------//
			doc.put("OneHourHits", OneHourTotalCount);

			// ---------------------web APDEX
			// value------------------------------------------//
			DBObject apdex_object = new BasicDBObject();
			apdex_object.put("exectime", new BasicDBObject("$gt", endTime));
			apdex_cursor = CISResponse.find(apdex_object);
			int count = apdex_cursor.size();
			DBCollection thresholdColl = db1.getCollection("ThresholdDB");
			DBObject sortObj = new BasicDBObject("_id", -1);
			List<DBObject> thList = thresholdColl.find().sort(sortObj).limit(1)
					.toArray();
			int thresholdValue = 0;
			if (thList.size() > 0) {
				DBObject obj = thList.get(0);

				thresholdValue = Integer.parseInt(obj.get("Web_threshold")
						.toString());
				System.out.println("threshold value is :" + thresholdValue);
			}
			List<DBObject> dbObjs = apdex_cursor.toArray();
			int green = 0;
			int yellow = 0;
			int red = 0;
			int max_reach = 300;
			thresholdValue = 100;
			for (int i = 0; i < dbObjs.size(); i++) {
				DBObject apdex = dbObjs.get(i);
				int apdex_value = (Integer) apdex.get("response_time");
				// System.out.println("value for all response time is"+apdex_value);
				if (apdex_value <= thresholdValue) {
					green++;
				} else if ((apdex_value >= thresholdValue)
						&& (apdex_value <= max_reach)) {
					yellow++;
				} else {
					red++;
				}
			}
			try {
				System.out.println("total count" + green);
				System.out.println("total count" + yellow);
				System.out.println("total count" + red);
				double cal_apdex_value = (green + (0.5 * yellow)) / count;
				System.out.println("Web apdex value calculated is: "
						+ cal_apdex_value);
				value = Double.parseDouble(new DecimalFormat("##.##")
						.format(cal_apdex_value));
				doc.put("OneHourApdex", value);

				System.out.println("Cal_APDEX : " + value);

			} catch (Exception e) {
				System.out.println("exception found" + e);
			}

			// ------------------------------OneHourErrorCount--------------------------------------//
			DBObject errorSearch = new BasicDBObject();
			errorSearch.put("exectime", new BasicDBObject("$gte", endTime));
			errorSearch.put("status_Code", new BasicDBObject("$gt", 399));
			OneHourErrorCount = CISResponse.find(errorSearch).count();
			doc.put("OneHourErrorCount", OneHourErrorCount);

			// --------------------OneHourAvgResponseTimeForMap----------------------//

			BasicDBObject document = new BasicDBObject();
			BasicDBObject innerdocument = new BasicDBObject();
			DBObject match11 = new BasicDBObject("$match", new BasicDBObject(
					"exectime", new BasicDBObject("$gt", endTime)));
			DBObject group11 = new BasicDBObject("$group", new BasicDBObject(
					"_id", "$State")
					.append("AvgResponseTime",
							new BasicDBObject("$avg", "$response_time"))
					.append("TotalCount", new BasicDBObject("$sum", 1))
					.append("TotalSum",
							new BasicDBObject("$sum", "$response_time")));

			AggregationOutput mapoutput11 = CISResponse.aggregate(match11,
					group11);
			boolean flagIfOutputNull = false;
			for (DBObject results11 : mapoutput11.results()) {
				flagIfOutputNull = true;
				int TotalCount = Integer.parseInt(results11.get("TotalCount")
						.toString());
				Double TotalSum = Double.valueOf(results11.get("TotalSum")
						.toString());
				String stateName = results11.get("_id").toString();
				String stateCode = MapCode.GetStateCode(stateName);
				if (!stateCode.startsWith("INVA")) {
					double avgResponseTime = Double.parseDouble(results11.get(
							"AvgResponseTime").toString());
					System.out.println("one Day AvgResponseTime forMAp : "
							+ stateName + "->" + stateCode + " ->"
							+ avgResponseTime);
					System.out.println("Total Count:" + TotalCount
							+ " :: TotalSum :" + TotalSum);
					innerdocument.put("OneHouravg", avgResponseTime);
					innerdocument.put("OneHourSum", TotalSum);
					innerdocument.put("OneHourCount", TotalCount);
					document.put(stateCode, innerdocument);
				}

			}
			if (flagIfOutputNull)
				doc.put("OneHourAvgResponseForMap", document);
			else {
				System.out.println("no data found:JIOMAp Schedular");
			}

			oneHourWebAvg.insert(doc);
			System.out.println("doc : " + doc);

			// calculating prediction
			DBObject sort = new BasicDBObject("_id", -1);
			List<DBObject> list = oneHourWebAvg.find().sort(sort).limit(10)
					.toArray();
			if (list.size() >= 10) {
				LinReg predictObj = new LinReg();
				List<Double> avgList = new ArrayList<Double>();
				for (DBObject obj : list) {
					DBObject subObj = (DBObject) obj
							.get("OneHourAvgResponseTime");
					double avg = Double.parseDouble(subObj.get("OneHourAvg")
							.toString());
					avgList.add(avg);

				}
				double predictValue = predictObj.predict(avgList.get(0),
						avgList.get(1), avgList.get(2), avgList.get(3),
						avgList.get(4), avgList.get(5), avgList.get(6),
						avgList.get(7), avgList.get(8), avgList.get(9));
				DBCollection predictColl = db.getCollection("PredictedData");
				DBObject predictInsert = new BasicDBObject();
				long time = startTime;
				long predictedTime = startTime + (60 * 60 * 1000);
				predictInsert.put("time", time);
				predictInsert.put("PredictedTime", predictedTime);
				predictInsert.put("PredictedValue", predictValue);
				predictColl.insert(predictInsert);
				System.out.println("Predicted inserted Value : "
						+ predictInsert);
			}

		}
		if (dataFlag) {
			innerdoc.put("OneHourTotalSum", OneHourTotalSum);
			innerdoc.put("OneHourTotalcount", OneHourTotalCount);
			innerdoc.put("OneHourAvg", OneHourAvg);
			doc.put("time", new Date().getTime());
			doc.put("OneHourAvgResponseTime", innerdoc);
			doc.put("OneHourErrorCount", OneHourErrorCount);
			doc.put("OneHourHits", OneHourTotalCount);
			doc.put("OneHourApdex", value);
			oneHourWebAvg.insert(doc);
			System.out.println("inside else doc :" + doc);
		}

	}

	public static void main(String[] args) throws Exception {
		// TODO Auto-generated method stub
		new WebDashBoardQuartz().execute(null);
	}

}
