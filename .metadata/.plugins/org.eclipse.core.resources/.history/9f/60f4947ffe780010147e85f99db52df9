<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="com.company1.DBManager" %>
<%
	/* java코드 넣는 부분 */
	
	// 상세 내용을 보여줄 공지사항 번호를 가져옴
	String sno = request.getParameter("sno");
	String param2 = request.getParameter("param2");
	System.out.println("param2 " + param2);
	/* System.out.println("sno: " + sno);
	System.out.println(sno == null);
	System.out.println(sno.isEmpty());
	System.out.println(sno.equals(" ")); */
	
	Integer iSno = null;
	boolean isProcess = true;	// 정상적인 파라미터일 경우 true
	try {
		iSno = Integer.parseInt(sno);
	} catch(Exception e) {
		isProcess = false;
%>
<script>
	alert('비정상적인 상태로 접근하였습니다.\n공지사항 목록 페이지로 이동합니다.');
	location.href = './notice.jsp';
</script>
<%
	}
	String sTitle = null;
	String sContent = null;
	Integer sCount = null;
	
	String prevNoticeTitle = null;		// 이전 공지사항 제목
	Integer prevNoticeSno = null;		// 이전 공지사항 번호
	String nextNoticeTitle = null;		// 다음 공지사항 제목
	Integer nextNoticeSno = null;		// 다음 공지사항 번호
	
	if (sno == null || sno.equals("") || !isProcess) {	// sno값이 없거나 혹은 비어있다면
%>
<script>
	alert('비정상적인 상태로 접근하였습니다.\n공지사항 목록 페이지로 이동합니다.');
	location.href = './notice.jsp';
</script>
<%		
	} else {
		// DB 접속 객체 가져오기
		Connection conn = DBManager.getDBConnection();
		
		// 1. 공지사항 번호에 맞는 데이터 조회
		String noticeDetailSql = ""
			+ "SELECT sno, stitle, scontent, scount "
			+ "FROM STARBUCKS_NOTICE "
			+ "WHERE sno = " + sno;
		
		//PreparedStatement 얻기 및 값 지정
		PreparedStatement pstmt = conn.prepareStatement(noticeDetailSql);
		ResultSet rs = pstmt.executeQuery();	// SQL문 실행
		
		if(rs.next()) {
			iSno = rs.getInt("sno");			// 공지사항 번호
			sTitle = rs.getString("stitle");	// 공지사항 제목
			sContent = rs.getString("scontent"); // 공지사항 내용	
			sCount = rs.getInt("scount");		// 공지사항 조회수
		}
		
		// 2. 선택된 공지사항에서 다음 공지사항과 이전 공지사항 데이터 조회
		String prevNextNoticeSql = ""
				+ "SELECT "
				+ "(SELECT sno FROM starbucks_notice WHERE sno < " + sno + " ORDER BY sno DESC FETCH FIRST 1 ROWS ONLY) AS prev_id, "
				+ "(SELECT stitle FROM starbucks_notice WHERE sno < " + sno + " ORDER BY sno DESC FETCH FIRST 1 ROWS ONLY) AS prev_title, "
				+ "(SELECT sno FROM starbucks_notice WHERE sno > " + sno + " ORDER BY sno ASC FETCH FIRST 1 ROWS ONLY) AS next_id, "
				+ "(SELECT stitle FROM starbucks_notice WHERE sno > " + sno + " ORDER BY sno ASC FETCH FIRST 1 ROWS ONLY) AS next_title "
				+ "FROM dual "
			;
		pstmt = conn.prepareStatement(prevNextNoticeSql);
		rs = pstmt.executeQuery();	// SQL문 실행
		if(rs.next()) {
			prevNoticeSno = rs.getInt("prev_id");			
			prevNoticeTitle = rs.getString("prev_title");	
			nextNoticeSno = rs.getInt("next_id"); 
			nextNoticeTitle = rs.getString("next_title"); 
		}
		
		// 3. 현재 페이지를 조회를 할 scount값을 1 증가시키는 작업
		sCount++; // 조회수 1증가
		String updateNoticeScountSql = ""
			+ " UPDATE starbucks_notice SET scount = " + sCount 
			+ " WHERE sno = " + sno;
		pstmt = conn.prepareStatement(updateNoticeScountSql);
		pstmt.executeUpdate();		// 실제 DB에서 조회수 1 증가 실해
	}
%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <!-- 타이틀 세팅 -->
  <title>Starbucks Coffee Korea</title>
  <!-- 파비콘 세팅 -->
  <link rel="icon" href="./favicon.png" />
  <!-- 브라우저 스타일 초기화 -->
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/reset-css@5.0.2/reset.min.css">
  <!-- Google Fonts - 나눔고딕 -->
  <link rel="preconnect" href="https://fonts.gstatic.com" />
  <link href="https://fonts.googleapis.com/css2?family=Nanum+Gothic:wght@400;700&display=swap" rel="stylesheet" />
  <!-- Google Material Icons -->
  <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons" />
  <!-- custom css -->
  <link rel="stylesheet" href="./css/main.css" />

  <!-- lodash 자바스크립트 유용한 유틸리티 함수 -->
  <script src="https://cdnjs.cloudflare.com/ajax/libs/lodash.js/4.17.21/lodash.min.js"></script>
  <!-- javascript -->
  <script defer src="./js/main.js"></script>
</head>
<body>
  <!-- mobile -->
  <div class="mobile">
    <div class="header-mobile">

    </div>
  </div>

  <!-- pc -->
  <div class="desktop">
    <!-- HEADER -->
    <jsp:include page="./common-jsp/header-menu-pc.jsp" /> 
	
	<!-- notice top -->
    <section class="notice-top">
    	<div class="inner sub_tit_wrap">
    		<h2>
    			<a href="./notice.jsp"><img src="https://www.starbucks.co.kr/common/img/whatsnew/notice_tit.jpg" alt="공지사항" /></a>
   			</h2>
    		<ul class="smap">
    		    <li><a href="#"><img src="https://image.istarbucks.co.kr/common/img/common/icon_home.png" alt="홈으로"></a></li>
	            <li><img class="arrow" src="https://image.istarbucks.co.kr/common/img/common/icon_arrow.png" alt="하위메뉴"></li>
	            <li class="en"><a href="#">WHAT'S NEW</a></li>
	            <li><img class="arrow" src="https://image.istarbucks.co.kr/common/img/common/icon_arrow.png" alt="하위메뉴"></li>
	            <li><a href="#" class="this">공지사항</a></li>
    		</ul>
    	</div>
    </section>
    
    <!-- notice list -->
    <section>
    	<div class="inner notice__list">
    		<div class="notice__header">
    			<div class="notice__detail_title"><%= sTitle %></div>
    		</div>
    		<div class="notice__detail__content">
    		    <%= sContent %>
    		</div>
    		<div class="notice__detail__bottom">
    			
    		</div>
    	</div>
   	</section>
   	
   	<!-- notice prev next -->
   	<section style="margin-top: 50px;">
   		<div class="inner notice__prev__next">
   			<div>이전글: <%= prevNoticeTitle == null ? "해당 글이 없습니다." : prevNoticeTitle  %></div>
   			<div>다음글: <%= nextNoticeTitle == null ? "해당 글이 없습니다." : nextNoticeTitle  %></div>
   		</div>
   	</section>
  </div>
</body>
</html>