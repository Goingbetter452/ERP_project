
	package com.company1;

	import java.sql.*;

	public class DBManager {
		public static Connection getDBConnection() {
			//java코드 넣는 부분
			Connection conn = null;
			try {
				//JDBC Driver 등록
				Class.forName("oracle.jdbc.OracleDriver");
				//연결하기
				conn = DriverManager.getConnection(
					"jdbc:oracle:thin:@1.220.247.78:1522/orcl", // oracle 접속정보 
					"project2_2504_team3",		// oracle 본인계정 이름
					"1234"			// oracle 본인계정 암호
				);
				
				//System.out.println("DB 연결 성공");
			} catch(Exception e) {
				e.printStackTrace();
			}
			
			return conn;
		}
	}
