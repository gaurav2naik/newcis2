package com.avekshaa.cis.servlet;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.avekshaa.cis.database.CommonDB;
import com.mongodb.BasicDBObject;
import com.mongodb.DB;
import com.mongodb.DBCollection;
import com.mongodb.DBObject;

/**
 * Servlet implementation class BranchActivation
 */
public class BranchActivation extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public BranchActivation() {
		super();
		// TODO Auto-generated constructor stub
	}

	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	}

	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		String status = "";
		try {
			String[] branchArray = request.getParameterValues("checkbox");

			System.out.println("branchArray" + Arrays.toString(branchArray));
			int size = branchArray.length;

			ArrayList<String> lil = new ArrayList<String>();
			for (int i = 0; i < size; i++) {
				lil.add(branchArray[i]);
			}
			DB db = CommonDB.getConnection();
			DBCollection activatedBranch = db.getCollection("ActivatedBranch");
			int dbsize = (int) activatedBranch.count();
			System.out.println("dbsize" + dbsize);
			if (dbsize > 0) {
				activatedBranch.drop();
				activatedBranch = db.getCollection("ActivatedBranch");
			}

			for (int j = 0; j < lil.size(); j++) {
				DBObject doc = new BasicDBObject();
				String data[] = lil.get(j).split(";");
				doc.put("IP_Address", data[0]);
				doc.put("Branch_Name", data[2]);
				doc.put("Branch_Code", data[1]);
				activatedBranch.insert(doc);
			}
			System.out.println("branch activated data :");
			status = "Branch Added Successfully!!!";
		} catch (Exception e) {
			e.printStackTrace();
			status = "problem occurs while submitting data";

		}
		response.sendRedirect("view/jsp/BranchConfiguration.jsp?status="
				+ status);
	}
}
