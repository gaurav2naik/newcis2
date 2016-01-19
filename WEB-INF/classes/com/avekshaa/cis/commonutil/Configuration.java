package com.avekshaa.cis.commonutil;

import java.io.File;
import java.io.IOException;
import java.net.UnknownHostException;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.apache.log4j.Logger;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import com.mongodb.BasicDBObject;
import com.mongodb.DB;
import com.mongodb.DBCollection;
import com.mongodb.MongoClient;

public class Configuration {
	static final Logger logger = Logger.getRootLogger();

	private static ConfigurationVo vo = null;

	public static ConfigurationVo configure() throws IOException {

		try {
			if (vo == null) {
				vo = new ConfigurationVo();
				// String path =
				// "/usr/share/tomcat8/webapps/ROOT/WEB-INF/classes";
				String path = Init.getWebInfPath();
				// String path = System.getenv("EPM_CONFIG_FILE_PATH");
				path = path == null ? "" : path;
				path = path.endsWith("/") ? path : path + "/";
				File systemResourceAsStream = new File(path + "CIS_Config.xml");

				DocumentBuilderFactory dbFactory = DocumentBuilderFactory
						.newInstance();
				DocumentBuilder dBuilder = dbFactory.newDocumentBuilder();
				Document doc = dBuilder.parse(systemResourceAsStream);

				NodeList nList = doc.getElementsByTagName("CISDatabase");

				for (int temp = 0; temp < nList.getLength(); temp++) {

					Node nNode = nList.item(temp);

					// System.out.println("\nCurrent Element :" +
					// nNode.getNodeName());

					if (nNode.getNodeType() == Node.ELEMENT_NODE) {

						Element eElement = (Element) nNode;

						vo.setDBIPAddress((eElement.getElementsByTagName(
								"IPAddress").item(0).getTextContent()));
						System.out.println("!!!!!!!!!!!!!IP Address"
								+ (eElement.getElementsByTagName("IPAddress")
										.item(0).getTextContent()));
						// vo.setDBIPAddress("52.24.170.28");
						// vo.setDBIPAddress("127.0.0.1");
						vo.setDBName("CIS");
						// vo.setDBName("CISPT");
						vo.setDBPort(27017);
						vo.setEmail("alerts@avekshaa.com");
						vo.setPassword("Aish@kulkarni");
						vo.setAndroidDBName("NewJIOData");
						vo.setJIODBName("NewJIOData");
						vo.setBankDBName("AndroidDataForBank");
						vo.setExtensionDBName("testdemo1");

						// vo.setAndroidport(27017);
						// vo.setAndroidIP("52.24.170.28");
						// vo.setAndroidIP("127.0.0.1");
					}
				}
			}

		} catch (Exception e) {
			// e.printStackTrace();
			logger.error("Unexpected error", e);
		}

		return vo;

	}

	public static void createAdminCollection() throws UnknownHostException {
		System.out.println("create admin called");
		MongoClient mc = new MongoClient("127.0.0.1");
		DB db = mc.getDB("CIS");
		DBCollection coll = db.getCollection("admin");
		int size = coll.find().count();
		System.out.println("count coll:" + size);
		if (size == 0) {
			BasicDBObject bdo = new BasicDBObject();
			bdo.put("UserName", "admin");
			bdo.put("Password", "1234");
			coll.insert(bdo);
			System.out.println("Admin coll created successfully!!!");
		} else {
			System.out.println("Admin coll is already there");
		}
	}

	public static void main(String[] args) throws IOException {
		configure();
	}
}
