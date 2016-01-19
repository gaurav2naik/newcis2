package com.avekshaa.cis.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.avekshaa.cis.database.CommonDB;
import com.mongodb.BasicDBObject;
import com.mongodb.DB;
import com.mongodb.DBCollection;
import com.mongodb.MongoException;

/**
 * Servlet implementation class EmailConfiguration
 */
public class EmailConfiguration extends HttpServlet {
	private static final long serialVersionUID = 1L;

	static DB db;
	static {
		db = CommonDB.getConnection();
	}

	public EmailConfiguration() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub

		String status = request.getParameter("onoffswitch");
		if (status == null) {
			status = "disabled";
		}
		String email = request.getParameter("email");
		String cc_email = request.getParameter("cc-email");

		System.out.println("status ::" + status + "::" + email + "::"
				+ cc_email);
		DBCollection emailColl = db.getCollection("EmailConfig");
		try {
			int emailCollSize = emailColl.find().count();
			if (emailCollSize > 0) {
				String alertStatus = (String) emailColl.findOne().get(
						"Alerting_Status");
				BasicDBObject doc = new BasicDBObject();
				doc.put("Alerting_Status", status);
				doc.put("email", email);
				doc.put("cc", cc_email);
				BasicDBObject updateQuery = new BasicDBObject(
						"Alerting_Status", alertStatus);
				emailColl.update(updateQuery, doc);
			} else {
				BasicDBObject bdo = new BasicDBObject();
				bdo.put("Alerting_Status", status);
				bdo.put("email", email);
				bdo.put("cc", cc_email);

				emailColl.insert(bdo);
			}
			response.sendRedirect("view/jsp/EmailConfiguration.jsp?status="
					+ "successfully Applied!!!");
		} catch (MongoException me) {
			response.sendRedirect("view/jsp/EmailConfiguration.jsp?status="
					+ "There is some Problem!!!");
		}
	}
}
