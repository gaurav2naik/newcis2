package com.avekshaa.cis.quartzjob.branch;

import java.util.Date;

import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

import com.avekshaa.cis.database.CommonDB;
import com.mongodb.AggregationOutput;
import com.mongodb.BasicDBObject;
import com.mongodb.DB;
import com.mongodb.DBCollection;
import com.mongodb.DBObject;

public class OneDayAggregationBranch implements Job {
	static DB db;
	static {
		db = CommonDB.getConnection();
	}

	@Override
	public void execute(JobExecutionContext arg0) throws JobExecutionException {
		// TODO Auto-generated method stub
		System.out.println("OneDayAggregationBranch called");
		long startTime = System.currentTimeMillis();
		long endTime = startTime - (60 * 60 * 1000);
		int OneHourTotalCount = 0;
		int OneHourErrorCount = 0;
		double OneHourTotalSum = 0d;
		double OneHourAvg = 0d;
		String IP_Address = "";

		DBCollection CISResponse = db.getCollection("CISResponse");
		DBCollection oneHourBranchAvg = db.getCollection("OneHourBranchAvg");

		// match obj
		DBObject match = new BasicDBObject("$match", new BasicDBObject(
				"exectime", new BasicDBObject("$gte", endTime)));
		DBObject group = new BasicDBObject("$group", new BasicDBObject("_id",
				"$IP_Address").append("OneHourTotalSum",
				new BasicDBObject("$sum", "$response_time")).append(
				"OneHourTotalcount", new BasicDBObject("$sum", 1)));
		AggregationOutput output1 = CISResponse.aggregate(match, group);

		System.out.println("output" + output1.toString());

		boolean dataFlag = true;
		for (DBObject results1 : output1.results()) {
			BasicDBObject innerdoc = new BasicDBObject();
			BasicDBObject doc = new BasicDBObject();
			dataFlag = false;
			System.out.println("One day Aggregation branch : inside for");
			IP_Address = (String) results1.get("_id");
			OneHourTotalCount = Integer.parseInt(results1.get(
					"OneHourTotalcount").toString());
			OneHourTotalSum = Double.valueOf(results1.get("OneHourTotalSum")
					.toString());

			if (OneHourTotalCount != 0)
				OneHourAvg = OneHourTotalSum / OneHourTotalCount;
			System.out.println("IP :" + IP_Address + " OneHourTotalSum "
					+ OneHourTotalSum + " ::" + " OneHourTotalcount :"
					+ OneHourTotalCount + ":: OneHourAvg :" + OneHourAvg);

			innerdoc.put("OneHourTotalSum", OneHourTotalSum);
			innerdoc.put("OneHourTotalcount", OneHourTotalCount);
			innerdoc.put("OneHourAvg", OneHourAvg);
			doc.put("IP_Address", IP_Address);
			doc.put("time", new Date().getTime());
			doc.put("OneHourAvgResponseTime", innerdoc);

			// ------------------------------OneHourHits--------------------------------------//
			doc.put("OneHourHits", OneHourTotalCount);

			// ------------------------------OneHourErrorCount--------------------------------------//
			DBObject errorSearch = new BasicDBObject();
			errorSearch.put("exectime", new BasicDBObject("$gte", endTime));
			errorSearch.put("IP_Address", IP_Address);
			errorSearch.put("status_Code", new BasicDBObject("$gt", 399));
			OneHourErrorCount = CISResponse.find(errorSearch).count();
			doc.put("OneHourErrorCount", OneHourErrorCount);

			oneHourBranchAvg.insert(doc);
			System.out.println("doc : " + doc);

		}

		/*
		 * if (dataFlag) { innerdoc.put("IP_Address", IP_Address);
		 * innerdoc.put("OneHourTotalSum", OneHourTotalSum);
		 * innerdoc.put("OneHourTotalcount", OneHourTotalCount);
		 * innerdoc.put("OneHourAvg", OneHourAvg); doc.put("time", new
		 * Date().getTime()); doc.put("OneHourAvgResponseTime", innerdoc);
		 * doc.put("OneHourErrorCount", OneHourErrorCount);
		 * doc.put("OneHourHits", OneHourTotalCount);
		 * oneHourBranchAvg.insert(doc); System.out.println("inside else doc :"
		 * + doc); }
		 */

	}

	public static void main(String[] args) throws Exception {
		// TODO Auto-generated method stub
		new OneDayAggregationBranch().execute(null);
	}

}
