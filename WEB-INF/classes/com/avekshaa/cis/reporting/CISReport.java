package com.avekshaa.cis.reporting;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.avekshaa.cis.login.UserBean;
import com.avekshaa.cis.reporting.Screen2Image;

/**
 * Servlet implementation class CISReport
 */
public class CISReport extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public CISReport() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		HttpSession session = request.getSession();
		String numberOfDay = request.getParameter("day");
		UserBean user = (UserBean)session.getAttribute("currentSessionUser");
		String email = user.getEmail();
		Screen2Image si = new Screen2Image();
		PrintWriter out = response.getWriter();
		try {
			String imgPath = si.robo();
			System.out.println(imgPath);
			JasperReportFill jr = new JasperReportFill();
			String pdfFilePath = jr.getReport(imgPath,email,numberOfDay);
			out.print("{\"path\":\""+pdfFilePath+"\"}");
		
		} catch (Exception e) {
			// TODO: handle exception
		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	      	
		     
		
	}

}
