package com.avekshaa.cis.commonutil;

import java.io.IOException;
import java.util.Date;
import java.util.Properties;

import javax.mail.Message;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import com.avekshaa.cis.database.CommonDB;
import com.mongodb.DB;
import com.mongodb.DBCollection;

public class Mail {
	static ConfigurationVo vo = null;
	static DB db;
	static {
		try {
			vo = Configuration.configure();
			db = CommonDB.getConnection();
		} catch (IOException e) {

			e.printStackTrace();
		}
	}

	public static void checkStatusAndSend(String message) {
		System.out.println("checkStatusAndSend");
		DBCollection coll = db.getCollection("EmailConfig");
		String status = coll.findOne().get("Alerting_Status").toString().trim();
		if ("enabled".equals(status)) {
			String recipients = coll.findOne().get("email").toString() + ";"
					+ coll.findOne().get("cc").toString();
			System.out.println("checkStatusAndSend::" + recipients);
			new Mail().mailer(message, recipients);
		} else {
			System.out.println("Alerting Engine Disabled");
		}
	}

	public void mailer(String message, String recipients) {

		String regex = "[;]";
		System.out.println("mail.java ::" + recipients.toString());
		String[] tokens = recipients.split(regex);
		for (String recipient : tokens) {
			recipient = recipient.trim();

			if (recipient.length() > 0) {
				try {
					Properties props = new Properties();
					props.put("mail.smtp.host", "smtp.gmail.com"); // for gmail
																	// use
																	// smtp.gmail.com
					props.put("mail.smtp.auth", "true");
					props.put("mail.debug", "true");
					props.put("mail.smtp.starttls.enable", "true");
					props.put("mail.smtp.port", "465");
					props.put("mail.smtp.socketFactory.port", "465");
					props.put("mail.smtp.socketFactory.class",
							"javax.net.ssl.SSLSocketFactory");
					props.put("mail.smtp.socketFactory.fallback", "false");
					Session mailSession = Session.getInstance(props,
							new javax.mail.Authenticator() {

								protected PasswordAuthentication getPasswordAuthentication() {
									return new PasswordAuthentication(vo
											.getEmail(), vo.getPassword());
								}
							});
					mailSession.setDebug(true); // Enable the debug mode
					Message msg1 = new MimeMessage(mailSession);
					msg1.setFrom(new InternetAddress(vo.getEmail()));
					msg1.setRecipients(Message.RecipientType.TO,
							InternetAddress.parse(recipient));
					msg1.setSentDate(new Date());
					msg1.setSubject("APPLICATION ALERT");
					msg1.setContent(message, "text/html");

					// msg1.setText(message);
					Transport.send(msg1);

				} catch (Exception E) {
					E.printStackTrace();

				}
			}
		}
	}

}
