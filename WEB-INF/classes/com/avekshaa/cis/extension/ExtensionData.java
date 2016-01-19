package com.avekshaa.cis.extension;

import java.util.List;
import java.util.Map;
import java.util.TreeMap;

import com.avekshaa.cis.database.CommonDB;
import com.mongodb.BasicDBObject;
import com.mongodb.DB;
import com.mongodb.DBCollection;
import com.mongodb.DBCursor;
import com.mongodb.DBObject;

public class ExtensionData {

	public static DB db;
	static {
		db = CommonDB.getExtensionDataConnection();
	}

	public Map<Long, String> getResponseTimesForScatterGraph(String startTime,
			String endTime, String sourceEndpointInp, String targetEndpointInp) {
		DBCursor alertData = null;
		DBObject exectime = null;
		TreeMap<Long, String> rexecandresp = new TreeMap<Long, String>();
		try {
			DBCollection cisresponse = db.getCollection("mycollection1");
			// BasicDBObject findObj = new BasicDBObject();
			alertData = cisresponse.find();
			alertData.sort(new BasicDBObject("_id", -1));
			// //System.out.println("alert d daata" + alertData);
			alertData.limit(40);
			List<DBObject> dbObjs = alertData.toArray();
			// System.out.println(dbObjs);

			for (int i = dbObjs.size() - 1; i >= 0 && dbObjs.size() > 0; i--)

			{
				DBObject txnDataObject = dbObjs.get(i);
				String IP = (String) txnDataObject.get("IP_Address");
				String URI = (String) txnDataObject.get("URI");
				Long execTime = (Long) txnDataObject.get("exectime");
				/*
				 * Integer responseTime = (Integer) txnDataObject
				 * .get("response_time");
				 */
				double responseTi = Double.parseDouble(txnDataObject.get(
						"response_time").toString());
				int responseTime = (int) responseTi;
				rexecandresp.put(execTime, IP + "&&" + URI + "&&"
						+ responseTime);
			}
		} catch (Exception e) {
			e.printStackTrace();
			// logger.error("Unexpected error", e);
		} finally {
			alertData.close();
		}
		// System.out.println(rexecandresp);x
		return rexecandresp;
	}

}