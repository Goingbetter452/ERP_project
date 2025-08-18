// Source code is decompiled from a .class file using FernFlower decompiler.
package com.company1;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class DBManager {
   public DBManager() {
   }

   public static Connection getDBConnection() {
      Connection conn = null;

      try {
         Class.forName("oracle.jdbc.OracleDriver");
         conn = DriverManager.getConnection("jdbc:oracle:thin:@1.220.247.78:1522/orcl", "project2_2504_team3", "1234");
      } catch (Exception var2) {
         var2.printStackTrace();
      }

      return conn;
   }



   /**
	* DB 연결을 종료하는 메서드입니다.
	* ResultSet, PreparedStatement, Connection 객체를 순서대로 닫습니다.
	* @param rs ResultSet 객체
	* @param pstmt PreparedStatement 객체
	* @param conn Connection 객체
	*/
   public static void close(ResultSet rs, PreparedStatement pstmt, Connection conn) {
      try {
         if (rs != null) rs.close();
      } catch (Exception e) {
         e.printStackTrace();
      }
      try {
         if (pstmt != null) pstmt.close();
      } catch (Exception e) {
         e.printStackTrace();
      }
      try {
         if (conn != null) conn.close();
      } catch (Exception e) {
         e.printStackTrace();
      }
   }
}