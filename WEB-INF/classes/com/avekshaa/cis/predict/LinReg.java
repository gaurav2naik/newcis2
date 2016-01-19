package com.avekshaa.cis.predict;

import java.util.List;

import com.mongodb.DBObject;

public class LinReg {
	// x1, x2, ..., x10 are the previous response-time values
	private static final double BETA_0 = 12.858912470830887;
	private static final double BETA_1 = 0.08831142;
	private static final double BETA_2 = 0.07722406;
	private static final double BETA_3 = 0.08024632;
	private static final double BETA_4 = 0.0668738;
	private static final double BETA_5 = 0.09455662;
	private static final double BETA_6 = 0.07795944;
	private static final double BETA_7 = 0.10837118;
	private static final double BETA_8 = 0.09195346;
	private static final double BETA_9 = 0.16143571;
	private static final double BETA_10 = 0.13746067;

	public double predict(double x1, double x2, double x3, double x4,
			double x5, double x6, double x7, double x8, double x9, double x10) {
//		if (x1 == 0 || x2 == 0) {
//			throw new IllegalArgumentException("x1 or x2 value is 0");
//		} else {
			return BETA_0 + BETA_1 * x1 + BETA_2 * x2 + BETA_3 * x3 + BETA_4
					* x4 + BETA_5 * x5 + BETA_6 * x6 + BETA_7 * x7 + BETA_8
					* x8 + BETA_9 * x9 + BETA_10 * x10;
//		}
	}

	public double predict(List<DBObject> list) {

		return 0d;
	}

	public static void main(String[] args) {
		double value = new LinReg().predict(1000, 4563, 1, 2, 3, 4, 6, 7, 8, 9);
		System.out.println("Value : " + value);
	}
}