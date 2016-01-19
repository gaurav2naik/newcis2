package com.avekshaa.cis.reporting;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JRPrintPage;
import net.sf.jasperreports.engine.JasperCompileManager;
import net.sf.jasperreports.engine.JasperExportManager;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.JasperReport;
import net.sf.jasperreports.engine.data.JRBeanCollectionDataSource;

import com.avekshaa.cis.database.CommonThreshold;
import com.avekshaa.cis.engine.GetChartData;
import com.jaspersoft.mongodb.MongoDbDataSource;
import com.jaspersoft.mongodb.connection.MongoDbConnection;
import com.mongodb.util.JSON;

@SuppressWarnings({ "unchecked", "rawtypes" })
public class JasperReportFill {
	public static void main(String[] args) throws Exception {
		// System.out.println(new Boolean((10<11)&(10>11)));
		// getMapReport();
		new JasperReportFill().getReport(null, "rohit.raghoji@avekshaa.com",
				"1d");
	}

	public String getReport(String imagePath, String email, String numberOfDay) {

		String time = new SimpleDateFormat("yyyy_MMdd_hh_mm_ss_a")
				.format(new Date(System.currentTimeMillis()));
		String pdfFilePath = Constants.pdfDir + "report_" + time + ".pdf";

		long millisInDay = 60 * 60 * 24 * 1000;
		long currentTime = new Date().getTime();
		long dateOnly = ((currentTime / millisInDay) * millisInDay) - 330 * 60 * 1000;
		// getting web threshold
		int webThreshold = CommonThreshold.getWebThreshold();
		String sourceFileName = null;
		Object mongoJSONQuery = null;

		if (numberOfDay.equals("1d")) {
			System.out.println("inside if from reporting");
			sourceFileName = Constants.jrxmlDir + "one_day.jrxml";
			mongoJSONQuery = JSON
					.parse("{ 'collectionName' : 'OneHourWebAvg' , 'findQuery' : { 'time' : {$gt :"
							+ dateOnly
							+ "}, OneHourAvgResponseTime.OneHourAvg : { $gt : "
							+ webThreshold + "}}}");
		} else if (numberOfDay.equals("2d")) {
			System.out.println("inside if 2d from reporting");
			sourceFileName = Constants.jrxmlDir + "seven_day.jrxml";
			mongoJSONQuery = JSON
					.parse("{ 'collectionName' : 'OneDayAvgOfWeb','sort':{'_id':-1},'limit':7}");
		} else if (numberOfDay.equals("3d")) {
			System.out.println("inside if 3d from reporting");
			sourceFileName = Constants.jrxmlDir + "seven_day.jrxml";
			mongoJSONQuery = JSON
					.parse("{ 'collectionName' : 'OneDayAvgOfWeb','sort':{'_id':-1},'limit':30}");
		}
		try {
			JasperReport jasperReport = JasperCompileManager
					.compileReport(sourceFileName);
			MongoDbConnection connection = new MongoDbConnection(
					Constants.mongoURI, null, null);

			Map parameters = new HashMap();

			parameters.put(MongoDbDataSource.CONNECTION, connection);
			parameters.put("ReportTitle", "CIS Report");
			parameters.put("imgPath", imagePath);
			parameters.put("query", mongoJSONQuery);
			// parameters.put(key, value)
			try {

				JasperPrint jasperPrint = JasperFillManager.fillReport(
						jasperReport, parameters);
				JasperPrint jasperPrint1 = getMapReport(numberOfDay);

				List pages = jasperPrint1.getPages();
				for (int j = 0; j < pages.size(); j++) {
					JRPrintPage object = (JRPrintPage) pages.get(j);
					jasperPrint.addPage(object);
				}
				// exporting to pdf
				System.out.println("PDF:::::" + pdfFilePath);
				JasperExportManager.exportReportToPdfFile(jasperPrint,
						pdfFilePath);
				Thread.sleep(1000);
				SendAttachmentInEmail sendMail = new SendAttachmentInEmail();
				/*
				 * JasperViewer jv = new JasperViewer(jasperPrint);
				 * jv.setVisible(true);
				 */
				sendMail.sendMail(pdfFilePath, email);
				System.out.println("Done");
			} catch (JRException e) {
				e.printStackTrace();
			}
		} catch (Exception e) {

		}
		return pdfFilePath;
	}

	public static JasperPrint getMapReport(String days) throws Exception {

		GetChartData ch = new GetChartData();

		if (days.equals("1d")) {
			ch.getMapData("web", 1);
		} else if (days.equals("2d")) {
			ch.getMapData("web", 7);
		} else if (days.equals("3d")) {
			ch.getMapData("web", 30);
		}
		ArrayList<MapDataBean> dataBeanList = GetChartData.dataBeanList;
		System.out.println(dataBeanList.toString());
		JRBeanCollectionDataSource beanColDataSource = new JRBeanCollectionDataSource(
				dataBeanList);
		String sourceFileName = Constants.jrxmlDir + "exmaple.jrxml";
		JasperReport jasperReport = JasperCompileManager
				.compileReport(sourceFileName);
		Map<String, Object> parameters = new HashMap<String, Object>();
		parameters.put("mapData", "Web Map Details");
		JasperPrint jasperPrint = JasperFillManager.fillReport(jasperReport,
				parameters, beanColDataSource);
		// JasperViewer jv = new JasperViewer(jasperPrint);
		// jv.setVisible(true);
		return jasperPrint;
	}

}