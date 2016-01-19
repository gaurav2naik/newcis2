package com.avekshaa.cis.reporting;

import java.awt.Rectangle;
import java.awt.Robot;
import java.awt.Toolkit;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileNotFoundException;
import java.text.SimpleDateFormat;
import java.util.Calendar;

import javax.imageio.ImageIO;

public class Screen2Image {

	SimpleDateFormat formatter = new SimpleDateFormat("yyyy_MMdd_hh_mm_ss_a");
	
	public String robo() throws Exception
	{
     		
		Calendar now = Calendar.getInstance();
		Robot robot = new Robot();
		BufferedImage screenShot = robot.createScreenCapture(new Rectangle(Toolkit.getDefaultToolkit().getScreenSize()));
		String fileName = Constants.screenshotDir+"report_"+formatter.format(now.getTime())+".jpg";
		ImageIO.write(screenShot, "JPG", new File(fileName));
		System.out.println(formatter.format(now.getTime()));
		return fileName;
	}
	
	public static void main(String[] args) throws Exception {
		Screen2Image s2i = new Screen2Image();
		s2i.robo();
	}
	}
