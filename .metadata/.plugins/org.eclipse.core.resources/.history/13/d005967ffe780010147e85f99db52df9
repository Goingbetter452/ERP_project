<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.company1.DBManager" %>
<%
	// out 내장객체로 웹 페이지 출력
	out.println("<h1>등록 처리중입니다</h1>");

	// post로 요청한 파라미터 조회
	String writer = request.getParameter("writer"); // 작성자
	String title = request.getParameter("title"); // 제목
	String content = request.getParameter("content"); // 내용
	
	//out.println("작성자: " + writer);
	//out.println("제목: " + title);
	//out.println("내용: " + content);
	
	// 파라미터로 전달받은 데이터들을 DB에 저장
	Connection conn = DBManager.getDBConnection();
	Exception ex1 = null;
	try {
		String insertSql = "INSERT INTO STARBUCKS_NOTICE(sno, stitle, scontent, swriter) "
			+ "VALUES (SEQ_SNO.NEXTVAL, ?, ?, ?) ";
		
		//PreparedStatement 얻기 및 값 지정
		PreparedStatement pstmt = conn.prepareStatement(insertSql);
		pstmt.setString(1, title);
		pstmt.setString(2, content);
		pstmt.setString(3, writer);
		
		pstmt.executeUpdate();
		
		out.println("글이 성공적으로 등록됨");
		
		// tomcat 내장 session객체에 작성자 값을 저장
		session.setAttribute("writer", writer);
	} catch(Exception e) {
		ex1 = e;
		System.out.println("공지사항 등록 쿼리 실행 오류: " + e.getMessage());
	}
	
	if (ex1 != null) {		// 글 등록시 오류일 때 처리
%>
공지사항 글 등록이 실패하였습니다. 시스템 관리자에게 문의하세요.<br>
오류내용: <%= ex1.getMessage() %><br>
<a href="./admin_notice_list.jsp">리스트로 이동하기</a>
<%
	} else {
%>
<script>
	location.href='<%= request.getContextPath() %>' + '/admin_notice_list.jsp';
</script>
<%
	}
%>


