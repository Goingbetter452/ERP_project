<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.Connection" %>
<%@ page import = "java.sql.DriverManager" %>
<%@ page import = "java.sql.PreparedStatement" %>
<%@ page import = "java.sql.ResultSet" %>
<%@ page import = "java.sql.SQLException" %>
<%@ page import = "com.company1.DBManager" %>    
<%
	// sno값을 토대로 수정할 공지사항 데이터 가져오기
	String sno = request.getParameter("sno");
	/* 
	 * DB에서 수정할 공지사항의 정보를 가져옴.
	 */
	String writer = null;
	String title = null;
	String content = null;
	
	//DB접속 객체 가져오기
	Connection conn = DBManager.getDBConnection();

	//DB조회쿼리 실행하여 DB에 있는 데이터 값 가져오기
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	try {
		String selectSql = "SELECT * FROM starbucks_notice WHERE sno = " + sno;
		
		pstmt = conn.prepareStatement(selectSql);
		rs = pstmt.executeQuery(); // sql실행
		
		if (rs.next()) {
			writer = rs.getString("SWRITER");
			title = rs.getString("STITLE");
			content = rs.getString("SCONTENT");
		}
	} catch (SQLException se) {
		System.out.println("공지사항 조회 쿼리 실행 오류: " + se.getMessage());
	}
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Starbucks 공지사항 어드민 페이지</title>
    <link rel="shortcut icon" href="./favicon.ico" />
    <link rel="icon" href="./favicon.png" />
    <link href="https://cdn.jsdelivr.net/npm/reset-css@5.0.2/reset.min.css" rel="stylesheet">
    <link rel="preconnect" href="https://fonts.gstatic.com" />
    <link href="https://fonts.googleapis.com/css2?family=Nanum+Gothic:wght@400;700&display=swap" rel="stylesheet" />
    <link re="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />
    <!-- <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script> -->
    <script src="./js/jquery-3.7.1.js"></script>
    <!-- lodash -->
    <script src="https://cdn.jsdelivr.net/npm/lodash@4.17.21/lodash.min.js"></script>
    <!-- <script src="https://cdnjs.cloudflare.com/ajax/libs/lodash.js/4.17.21/lodash.min.js" integrity="sha512-WFN04846sdKMIP5LKNphMaWzU7YpMyCU245etK3g/2ARYbPK9Ub18eG+ljU96qKRCWh+quCY7yefSmlkQw1ANQ==" crossorigin="anonymous" referrerpolicy="no-referrer"></script> -->
    
    <link href="./css/notice_admin.css" rel="stylesheet">
    <script defer src="./js/notice_admin.js"></script>
</head>
<body>
	<div class="card">
		<div class="card-header">
			<h1>스타벅스 공지사항 수정</h1>	
		</div>
		<form action="./admin_notice_update.jsp" method="post" id="form1" onSubmit="return false">
			<input type="hidden" name="sno" value="<%= sno %>" />
			<div class="card-write"> 
				<div class="info info-writer">
					<div>작성자</div>
					<input type="text" name="writer" value="<%= writer == null ? "" : writer %>" />
				</div>
				<div class="info info-title">
					<div>제목</div>
					<input type="text" name="title" value="<%= title == null ? "" : title %>" />
				</div>
				<div class="info info-content">
					<div>내용</div>
					<textarea name="content"><%= content == null ? "" : content %></textarea>
				</div>
			</div>
			<div class="card-bottom-btns">
				<a href="javascript: updateSubmit();" class="btn">수정</a>
				<a href="./admin_notice_list.jsp" class="btn">취소</a>
			</div>
		</form>
	</div>
</body>
</html>