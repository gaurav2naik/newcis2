package com.avekshaa.cis.jio;

import java.text.DateFormat;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.bson.types.ObjectId;
import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

import com.avekshaa.cis.database.CommonDB;
import com.mongodb.BasicDBObject;
import com.mongodb.DB;
import com.mongodb.DBCollection;
import com.mongodb.DBCursor;
import com.mongodb.DBObject;

public class DashBoardQuartz implements Job {
	static int cal_size = 0;
	static int coll_entry = 1;// increment of this var after every 1 day
	static int doc_entry = 1; // increment after every document is inserted
	static DB db;
	static int red = 0;
	static {
		db = CommonDB.getBankConnection();
	}

	@Override
	public void execute(JobExecutionContext arg0) throws JobExecutionException {
		System.out.println("DashBoardQuartz called at"
				+ new SimpleDateFormat("HH:mm:ss").format(new Date()));
		// TODO Auto-generated method stub

		// One Day (Number of Hits)
		DBCursor regularData = null;
		DBCollection coll = db.getCollection("Regular");
		long end_time = System.currentTimeMillis();
		long strt_time = end_time - (60 * 60 * 1000);

		Date date = new Date(end_time);
		DateFormat format = new SimpleDateFormat("dd/MM/yyyy HH:mm");
		DateFormat format1 = new SimpleDateFormat("dd/MM/yyyy");
		String formatted = format.format(date);
		String formatted1 = format1.format(date);
		// System.out.println(formatted);

		DBObject search = new BasicDBObject();
		search.put("request_time", new BasicDBObject("$gt", strt_time));

		// System.out.println(search);
		regularData = coll.find(search);
		int count = regularData.size();
		// System.out.println(count);
		String value = "day" + String.valueOf(coll_entry);
		String doc_value = String.valueOf(doc_entry);

		DBCollection hitsColl = db.getCollection("hits");
		BasicDBObject insertObj = new BasicDBObject();
		insertObj.put("Day", value);
		insertObj.put("hour", doc_value);
		insertObj.put("hits", count);
		insertObj.put("exec_time", end_time);
		insertObj.put("Start_time", formatted);
		insertObj.put("Start_date", formatted1);
		hitsColl.insert(insertObj);
		doc_entry++;
		System.out.println("hits:" + insertObj);
		// end of one day

		// Fatal Error(Crash report)
		DBCursor errorCursor = null;
		DBCollection errorColl = db.getCollection("Error");

		DBObject findQ = new BasicDBObject("_id", new BasicDBObject("$gt",
				new ObjectId(new Date(strt_time))));
		errorCursor = errorColl.find(findQ);
		int size = errorCursor.size();
		DBCollection cal_errorColl = db.getCollection("cal_error");
		BasicDBObject insertObj2 = new BasicDBObject();
		insertObj2.put("Day", value);
		insertObj2.put("hours", size);
		insertObj2.put("exec_time", end_time);
		insertObj2.put("Start_time", formatted);
		insertObj2.put("Start_date", formatted1);
		cal_errorColl.insert(insertObj2);
		System.out.println("Cal_error : " + insertObj2);
		doc_entry++;

		// /APDEX calculation for mobile//////////////////////////

		DBCollection thresholdColl = db.getCollection("ThresholdDB");
		DBObject sortObj = new BasicDBObject("_id", -1);
		List<DBObject> thList = thresholdColl.find().sort(sortObj).limit(1)
				.toArray();
		int thresholdValue = 0;
		if (thList.size() > 0) {
			DBObject obj = thList.get(0);

			thresholdValue = Integer.parseInt(obj.get("Android_threshold")
					.toString());
		}

		List<DBObject> dbObjs = regularData.toArray();
		double decimal_Apdex = 0d;
		if (dbObjs.size() == 0) {
			decimal_Apdex = 0;
			System.out.println("data is here");
		} else {
			int green = 0;
			int yellow = 0;
			int red = 0;
			double alpha = 0.2;// value to be taken from DB
			double beta = 0.4;// value to be taken from DB
			long max_reach = 4500;// value to be taken from DB
			for (int i = 0; i < dbObjs.size(); i++) {
				DBObject apdex = dbObjs.get(i);
				System.out.println("before duration");
				String dur = String.valueOf(apdex.get("duration"));
				long apdex_value = Long.parseLong(dur);
				long str = (Long) apdex.get("StartTime");
				System.out.println("apdexval: " + apdex_value);
				System.out.println("starttime: " + str);
				if (apdex_value <= thresholdValue) {
					green++;
				} else if ((apdex_value >= thresholdValue)
						|| (apdex_value <= max_reach)) {
					yellow++;
				} else {
					red++;
				}
			}
			double cal_apdex_value = (green + (0.5 * yellow) - (alpha * size))
					/ count;
			System.out.println("apdex value calculated is: " + cal_apdex_value);
			decimal_Apdex = Double.parseDouble(new DecimalFormat("##.##")
					.format(cal_apdex_value));
		}
		DBCollection cal_APDEX = db.getCollection("mobile_APDEX");
		BasicDBObject insertObj3 = new BasicDBObject();
		// insertObj3.put("Day", value);
		insertObj3.put("Apdex", decimal_Apdex);
		insertObj3.put("exec_time", end_time);

		insertObj3.put("Start_time", formatted);
		insertObj3.put("Start_date", formatted1);
		cal_APDEX.insert(insertObj3);
		System.out.println("Cal_APDEX : " + insertObj3);
	}

	// /////////////////////////////////////////////////////////////////////////////////////////////////////////////

	public static void main(String[] args) throws Exception {
		new DashBoardQuartz().execute(null);
	}
}
