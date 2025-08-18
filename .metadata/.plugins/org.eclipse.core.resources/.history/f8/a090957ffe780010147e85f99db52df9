<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	// 세션 객체에서 작성자가 입력한 값이 있는지 체크
	//String sessionWriter = (String)session.getAttribute("writer");
	String sessionWriter = (String)session.getAttribute("user_name");
	System.out.println("sessionWriter: " + sessionWriter);
	
	// 클라이언트 ip주소 조회
	String ipAddress = request.getRemoteAddr();
	System.out.println("ip: " + ipAddress);
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
			<h1>스타벅스 공지사항 등록</h1>	
		</div>
		<form action="./admin_notice_insert.jsp" method="post" id="form1" onSubmit="return false">
			<div class="card-write">
				<div class="info info-writer">
					<div>작성자</div>
					<input type="text" name="writer" value="<%= sessionWriter == null ? "" : sessionWriter %>" readonly/>
				</div>
				<div class="info info-title">
					<div>제목</div>
					<input type="text" name="title"/>
				</div>
				<div class="info info-content">
					<div>내용</div>
					<textarea name="content"></textarea>
				</div>
			</div>
			<div class="card-bottom-btns">
				<!-- <input type="submit" value="등록" /> -->
				<a href="javascript: regSubmit();" class="btn">등록</a>
				<a href="./admin_notice_list.jsp" class="btn">취소</a>
			</div>
		</form>
	</div>
</body>
</html>