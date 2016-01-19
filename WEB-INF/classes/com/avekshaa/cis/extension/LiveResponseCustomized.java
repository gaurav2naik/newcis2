package com.avekshaa.cis.extension;

import java.util.List;
import java.util.TreeMap;

import com.avekshaa.cis.commonutil.Convertor;
import com.avekshaa.cis.database.CommonDB;
import com.mongodb.BasicDBObject;
import com.mongodb.DB;
import com.mongodb.DBCollection;
import com.mongodb.DBCursor;
import com.mongodb.DBObject;

public class LiveResponseCustomized {

	public static DB db;
	static {
		db = CommonDB.getExtensionDataConnection();
	}

	public TreeMap<Long, String> getIPandURI(String startTime, String endTime,
			String uri, String ip) {
		DBCursor alertData = null;
		long t1 = Convertor.timeInMilisecond(startTime);
		long t2 = Convertor.timeInMilisecond(endTime);
		BasicDBObject gtQuery = new BasicDBObject();
		;
		TreeMap<Long, String> rexecandresp = new TreeMap<Long, String>();
		DBObject exectime = null;
		String aqw = "-1";
		System.out
				.println("Uri value is:wwefrgjrdgio;rg0   " + uri + "  " + ip);

		try {

			DBCollection cisresponse = db.getCollection("mycollection1");
			if (uri.equals(aqw) && (ip.equals(aqw))) {
				System.out.println("uri is null no data can be calculated");
				gtQuery.put("exectime",
						new BasicDBObject("$gt", t1).append("$lt", t2));
				System.out.println("gtquery 0 is  :" + gtQuery);
			} else if (uri.equals(aqw) && (!ip.equals(aqw))) {
				gtQuery.put("exectime",
						new BasicDBObject("$gt", t1).append("$lt", t2));
				gtQuery.put("IP_Address", ip);
				System.out.println("gtquery 1 is  :" + gtQuery);
				System.out
						.println("uri is present data can now be seen properly"
								+ uri);
			} else {
				gtQuery.put("exectime",
						new BasicDBObject("$gt", t1).append("$lt", t2));
				gtQuery.put("IP_Address", ip);
				gtQuery.put("URI", uri);
				System.out.println("gtquery 2 is  :" + gtQuery);
				System.out
						.println("uri & ip both are present data can now be seen properly"
								+ ip + "   " + uri);
			}

			alertData = cisresponse.find(gtQuery).sort(exectime);
			System.out.println("alertData is " + alertData);
			alertData.sort(new BasicDBObject("$natural", -1));
			System.out.println("alert d daata" + alertData);
			// alertData.limit(205);
			List<DBObject> dbObjs = alertData.toArray();
			// //System.out.println("dbo object  " + dbObjs.size() );

			if (dbObjs.size() > 200) {
				// //System.out.println("LOOP 1");
				for (int i = dbObjs.size() - 1; i >= dbObjs.size() - 200; i--) {
					DBObject txnDataObject = dbObjs.get(i);
					String IP = (String) txnDataObject.get("IP_Address");
					String URI = (String) txnDataObject.get("URI");
					Long execTime = (Long) txnDataObject.get("exectime");
					double responseTi = Double.parseDouble(txnDataObject.get(
							"response_time").toString());
					int responseTime = (int) responseTi;
					rexecandresp.put(execTime, IP + "&&" + URI + "&&"
							+ responseTime);
				}
			}

			else {
				System.out.println("size of the object is   :" + dbObjs.size());
				for (int i = dbObjs.size() - 1; i >= 0; i--) {
					DBObject txnDataObject = dbObjs.get(i);
					String IP = (String) txnDataObject.get("IP_Address");
					// System.out.println("IP inside loop is:" +IP);
					String URI = (String) txnDataObject.get("URI");
					// System.out.println("URI inside loop is:" +URI);

					Long execTime = (Long) txnDataObject.get("exectime");
					// System.out.println("Exec inside loop is:" +execTime);

					double responseTi = Double.parseDouble(txnDataObject.get(
							"response_time").toString());
					int responseTime = (int) responseTi;
					// System.out.println("resp inside loop is:" +responseTime);

					rexecandresp.put(execTime, IP + "&&" + URI + "&&"
							+ responseTime);
				}
			}

		} catch (Exception e) {
			// e.printStackTrace();

		} finally {
			alertData.close();
		}
		System.out.println("rexecandraaaaa is:  " + rexecandresp);

		return rexecandresp;
	}
}