<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="com.company1.DBManager" %>
<%
	/* java코드 넣는 부분 */
	
	// jsp에서는 내장객체로 요청객체(request)랑 응답객체(response)를 사용
	String searchKeyword = request.getParameter("searchKeyword");
	System.out.println("searchKeyword: " + searchKeyword);
	
	// DB 접속 객체 가져오기
	Connection conn = DBManager.getDBConnection();
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
    		<div class="news_sch_wrap">
	    		<div class="sch_items">
	    			<input type="text" id="sch_bar" placeholder="검색어를 입력해 주세요." 
    					value="<%= searchKeyword != null ? searchKeyword : "" %>" />
	    			<a href="#" class="new-board-search-btn" id="search-keyword">검색</a>
	    		</div>
	    	</div>
    	</div>
    </section>
    
    <!-- notice list -->
    <section>
    	<div class="inner notice__list">
    		<div class="notice__header">
    			<div class="notice__no">NO</div>
    			<div class="notice__title">제목</div>
    			<div class="notice__hit">조회수</div>
    			<div class="notice__regdate">날짜</div>
    		</div>
    		<div class="notice__list__items">
<%
  		String noticeListSql = ""
  			+ "SELECT sno, stitle, sdate, scount "
  			+ "FROM STARBUCKS_NOTICE "
  			;
		if(searchKeyword != null && !searchKeyword.equals("")) {
			noticeListSql += "WHERE stitle LIKE '%" + searchKeyword + "%' ";
		}
		noticeListSql += "ORDER BY sdate DESC ";
			
 		//PreparedStatement 얻기 및 값 지정
 		PreparedStatement pstmt = conn.prepareStatement(noticeListSql);
 		ResultSet rs = pstmt.executeQuery();	// SQL문 실행
 		while(rs.next()) {	// row수만큼 html코드 추가
%>
		<ul>
	 		<li><%= rs.getInt("sno") %></li>
	 		<li><a href="./notice_detail.jsp?sno=<%= rs.getInt("sno") %>" /><%= rs.getString("stitle") %></a></li>
	 		<li><%= rs.getInt("scount") %></li>
	 		<li><%= rs.getDate("sdate") %></li>
 		</ul>				      
<%
		}
 		rs.close();
 		pstmt.close();
%>			
    		</div>
    	</div>
    </section>
  </div>
  
  <script>
  	// 텍스트 검색 버튼 클릭시 동작
  	const searchKeyword = document.getElementById('search-keyword');
  	searchKeyword.addEventListener('click', function() {
  		// 텍스트 박스에 적힌 글자를 가져오기
  		const searchText = document.getElementById('sch_bar').value;
  		// searchText텍스트로 다시 notice.jsp로 조회
  		location.href = './notice.jsp?searchKeyword=' + searchText;
  	});
  	
  	// 텍스트 박스 Enter시에 동작
  	const searchKeywordTextBox = document.getElementById('sch_bar');
  	searchKeywordTextBox.addEventListener('keydown', function(e) {
  		if(e.key === 'Enter') {
  			// 텍스트 박스에 적힌 글자를 가져오기
  			const searchText = searchKeywordTextBox.value;
 	 		// searchText텍스트로 다시 notice.jsp로 조회
  	  		location.href = './notice.jsp?searchKeyword=' + searchText;
  		}
  	});
  </script>
</body>
</html>