package com.avekshaa.cis.servlet;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import com.avekshaa.cis.Java.BranchConfigurationBean;
import com.avekshaa.cis.database.CommonDB;
import com.mongodb.BasicDBObject;
import com.mongodb.DB;
import com.mongodb.DBCollection;
import com.mongodb.DBObject;

public class UploadServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;

	private static final String UPLOAD_DIRECTORY = "upload";
	private static final int THRESHOLD_SIZE = 1024 * 1024 * 3; // 3MB
	private static final int MAX_FILE_SIZE = 1024 * 1024 * 40; // 40MB
	private static final int MAX_REQUEST_SIZE = 1024 * 1024 * 50; // 50MB

	/**
	 * handles file upload via HTTP POST method
	 */
	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		System.out.println("do post from upload servlet");
		String status = "";
		// checks if the request actually contains upload file
		if (!ServletFileUpload.isMultipartContent(request)) {
			PrintWriter writer = response.getWriter();
			writer.println("Request does not contain upload data");
			writer.flush();
			return;
		}

		// configures upload settings
		DiskFileItemFactory factory = new DiskFileItemFactory();
		factory.setSizeThreshold(THRESHOLD_SIZE);
		factory.setRepository(new File(System.getProperty("java.io.tmpdir")));
		// System.out.println((System.getProperty("java.io.tmpdir")));

		ServletFileUpload upload = new ServletFileUpload(factory);
		upload.setFileSizeMax(MAX_FILE_SIZE);
		upload.setSizeMax(MAX_REQUEST_SIZE);

		// constructs the directory path to store upload file
		String uploadPath = getServletContext().getRealPath("")
				+ File.separator + UPLOAD_DIRECTORY;
		// upload="/home/dushyant"
		// creates the directory if it does not exist
		File uploadDir = new File(uploadPath);
		if (!uploadDir.exists()) {
			uploadDir.mkdir();
		}
		// System.out.println("uploadPath" +uploadPath);
		try {
			// parses the request's content to extract file data
			List formItems = upload.parseRequest(request);
			Iterator iter = formItems.iterator();

			// iterates over form's fields
			while (iter.hasNext()) {
				FileItem item = (FileItem) iter.next();
				// processes only fields that are not form fields
				if (!item.isFormField()) {
					String fileName = new File(item.getName()).getName();
					String filePath = uploadPath + File.separator + fileName;
					File storeFile = new File(filePath);

					// saves the file on disk
					item.write(storeFile);

					List<BranchConfigurationBean> list = processRequest(storeFile);// storeFile
					System.out.println("ABC List\n" + list);

				}
			}
			status = "Upload has been done successfully!";
		} catch (Exception ex) {
			status = "There was an error: " + ex.getMessage();
		}

		response.sendRedirect("view/jsp/BranchConfiguration.jsp?status="
				+ status);
	}

	protected List processRequest(File storeFile)// File storeFile
	{
		List<BranchConfigurationBean> counList = new ArrayList<BranchConfigurationBean>();

		try {
			// FileInputStream file = new
			// FileInputStream("/home/dushyant/Desktop/example/howtodoinjava_demo.xlsx");
			FileInputStream file = new FileInputStream(storeFile);
			Workbook workbook = new XSSFWorkbook(file);
			int numberOfSheets = workbook.getNumberOfSheets();

			// loop through each of the sheets
			for (int i = 0; i < numberOfSheets; i++) {

				// Get the nth sheet from the workbook
				Sheet sheet = workbook.getSheetAt(i);

				// every sheet has rows, iterate over them
				Iterator<Row> rowIterator = sheet.iterator();
				// int cou = 0;
				rowIterator.next();
				BranchConfigurationBean a = null;
				DB db = CommonDB.getConnection();
				DBCollection coll = db.getCollection("XLsheet");
				coll.drop();
				coll = db.getCollection("XLsheet");
				while (rowIterator.hasNext()) {
					a = new BranchConfigurationBean();
					// cou++;
					/*
					 * ID = 0d; String NAME = ""; String LASTNAME = "";
					 */
					double ID = 0d;
					String Identification_code = "";
					String Branch_Name = "";
					String IP_address = "";

					// Get the row object
					Row row = rowIterator.next();

					// Every row has columns, get the column iterator and
					// iterate over them
					Iterator<Cell> cellIterator = row.cellIterator();
					int i1 = 1;

					while (cellIterator.hasNext()) {
						// Get the Cell object
						Cell cell = cellIterator.next();
						System.out.println(i1++ + " cell type "
								+ cell.getCellType());
						// check the cell type and process accordingly
						switch (cell.getCellType()) {
						case Cell.CELL_TYPE_STRING:

							if (Identification_code.equalsIgnoreCase("")) {
								// 1st column
								Identification_code = cell.getStringCellValue()
										.trim();
							} else if (Branch_Name.equalsIgnoreCase("")) {
								// 2nd column
								Branch_Name = cell.getStringCellValue().trim();
							} else if (IP_address.equalsIgnoreCase("")) {
								// 3rd column
								IP_address = cell.getStringCellValue().trim();
							}

							break;
						case Cell.CELL_TYPE_NUMERIC:
							ID = cell.getNumericCellValue();
							System.out.println("Random data::"
									+ cell.getNumericCellValue());
							break;
						}
					} // end of cell iterator

					BranchConfigurationBean c = new BranchConfigurationBean();

					DBObject obj = new BasicDBObject();

					obj.put("Branch_Name", Branch_Name);
					obj.put("Identification_code", Identification_code);
					obj.put("IP_address", IP_address);
					coll.insert(obj);

					c.setBranch_Name(Branch_Name);
					c.setIdentification_code(Identification_code);
					c.setIP_address(IP_address);

					counList.add(c);

				} // end of rows iterator

			} // end of sheets for loop

			// close file input stream
			file.close();

		} catch (IOException e) {
			e.printStackTrace();
		}

		System.out.println(counList);
		return counList;

	}
}