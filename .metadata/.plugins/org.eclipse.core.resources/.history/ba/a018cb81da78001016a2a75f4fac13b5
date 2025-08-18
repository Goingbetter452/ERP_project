<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="com.company1.DBManager" %>
<%
	/* java코드 넣는 부분 */
	
	//DB 접속 객체 가져오기
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
  <!-- animation 처리를 위한 gsap 라이브러리 설치 -->
  <script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.5.1/gsap.min.js" integrity="sha512-IQLehpLoVS4fNzl7IfH8Iowfm5+RiMGtHykgZJl9AWMgqx0AmJ6cRWcB+GaGVtIsnC4voMfm8f2vwtY+6oPjpQ==" crossorigin="anonymous"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.5.1/ScrollToPlugin.min.js" integrity="sha512-nTHzMQK7lwWt8nL4KF6DhwLHluv6dVq/hNnj2PBN0xMl2KaMm1PM02csx57mmToPAodHmPsipoERRNn4pG7f+Q==" crossorigin="anonymous"></script>
  <!-- swiper 자바스크립트 및 css 라이브러리 설치 -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/Swiper/6.8.4/swiper-bundle.min.css" integrity="sha512-aMup4I6BUl0dG4IBb0/f32270a5XP7H1xplAJ80uVKP6ejYCgZWcBudljdsointfHxn5o302Jbnq1FXsBaMuoQ==" crossorigin="anonymous" referrerpolicy="no-referrer" />
  <script src="https://cdnjs.cloudflare.com/ajax/libs/Swiper/6.8.4/swiper-bundle.min.js" integrity="sha512-BABFxitBmYt44N6n1NIJkGOsNaVaCs/GpaJwDktrfkWIBFnMD6p5l9m+Kc/4SLJSJ4mYf+cstX98NYrsG/M9ag==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
  <!-- <link
    rel="stylesheet"
    href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css"
  />
  <script src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script> -->

  <!-- javascript -->
  <script defer src="./js/main.js"></script>
  <script defer src="./js/youtube.js"></script>
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

    <script>
    </script>

    <!-- SECTION 1-->
    <section class="visual">
      <div class="inner">
        <!-- visual title -->
        <div class="title fade-in">
          <img src="./images/visual_title.png" />
          <a href="javascript:void(0);" class="btn">자세히 보기</a>
        </div>
        <!-- visual cup1 -->
        <div class="fade-in">
          <img src="./images/visual_cup1.png" class="cup1 image" />
          <img src="./images/visual_cup1_text.png" class="cup1 text" />
        </div>
        <!-- visual cup2 -->
        <div class="fade-in">
          <img src="./images/visual_cup2.png" class="cup2 image" />
          <img src="./images/visual_cup2_text.png" class="cup2 text" />
        </div>
        <!-- visual spoon -->
        <div class="fade-in">
          <img src="./images/visual_spoon.png" class="spoon" />
        </div>
      </div>
    </section>

    <!-- SECTION 2(notice, promotion) -->
    <section class="notice">
      <div class="notice-line">
        <div class="bg-left"></div>
        <div class="bg-right"></div>
        <div class="inner">
          <div class="inner__left">
            <h2>공지사항</h2>
            <div class="swiper-container">
              <!-- Additional required wrapper -->
              <div class="swiper-wrapper">
<%
		// java코드 넣는 부분
		// 매개변수화된 SQL문 작성(최신 3개의 행만 가져오기)
		/*
		String noticeSql = ""
			+ "SELECT sno, stitle "
			+ "FROM ( "
			+ "		SELECT * "
			+ "		  FROM STARBUCKS_NOTICE "
			+ "	  ORDER BY sdate DESC "
			+ ") "
			+ "WHERE ROWNUM <= 3 "; 
			;
		*/
		String noticeSql = ""
				+ "SELECT * "
				+ "  FROM STARBUCKS_NOTICE "
				+ "ORDER BY sdate DESC "
				;
		//PreparedStatement 얻기 및 값 지정
		PreparedStatement pstmt = conn.prepareStatement(noticeSql);
		ResultSet rs = pstmt.executeQuery();	// SQL문 실행
		int count = 0;
		while(rs.next()) {	// row수만큼 html코드 추가
%>
				<div class="swiper-slide">
                  <a href="javascript:void(0);"><%= rs.getString("stitle") %></a>
                </div>      
<%
			if (count > 3) {
				break;
			} else {
				count++;
			}
		}
		rs.close();
		pstmt.close();
%>  
              </div>
            </div>
            <a href="./notice.jsp" class="notice-line__more">
              <div class="material-icons">add_circle</div>
            </a>
          </div>
          <div class="inner__right">
            <h2>스타벅스 프로모션</h2>
            <div class="toggle-promotion">
              <div class="material-icons">upload</div>
            </div>
          </div>
        </div>
      </div>
      <div class="promotion">
        <div class="swiper-container">
          <div class="swiper-wrapper">
            <div class="swiper-slide">
              <img src="./images/promotion_slide1.jpg" alt="" />
              <a href="javascript:void(0);" class="btn">자세히 보기</a>
            </div>
            <div class="swiper-slide">
              <img src="./images/promotion_slide2.jpg" alt="" />
              <a href="javascript:void(0);" class="btn">자세히 보기</a>
            </div>
            <div class="swiper-slide">
              <img src="./images/promotion_slide3.jpg" alt="" />
              <a href="javascript:void(0);" class="btn">자세히 보기</a>
            </div>
            <div class="swiper-slide">
              <img src="./images/promotion_slide4.jpg" alt="" />
              <a href="javascript:void(0);" class="btn">자세히 보기</a>
            </div>
            <div class="swiper-slide">
              <img src="./images/promotion_slide5.jpg" alt="" />
              <a href="javascript:void(0);" class="btn">자세히 보기</a>
            </div>
          </div>
        </div>

        <div class="swiper-pagination"></div>
        <div class="swiper-prev">
          <div class="material-icons">arrow_back</div>
        </div>
        <div class="swiper-next">
          <div class="material-icons">arrow_forward</div>
        </div>
      </div>
    </section>

    <!-- SECTION 4 -->
    <section class="rewards">
      <div class="bg-left"></div>
      <div class="bg-right"></div>
      <div class="inner">
        <div class="btn-group">
          <div class="btn sign-up btn--reverse">회원가입</div>
          <div class="btn sign-in">로그인</div>
          <div class="btn gift">e-Gift 선물하기</div>
        </div>
      </div>
    </section>

    <!-- SECTION 5 -->
    <section class="youtube">
      <div class="youtube__area">
        <div id="player">
        </div>
      </div>
      <div class="youtube__cover">
        <div class="inner">
          <img src="./images/floating1.png" class="floating floating1" />
          <img src="./images/floating2.png" class="floating floating2" />
        </div>
      </div>
    </section>
    
    <!-- SECTION 6 -->
    <section class="season-product">
      <div class="inner">
        <img src="./images/floating3.png" class="floating floating3" />
        <img src="./images/season_product_image.png" class="product" />
        <div class="text-group">
          <img src="./images/season_product_text1.png" class="title" />
          <img src="./images/season_product_text2.png" class="description" />
          <div class="more">
            <a href="javascript:void(0);" class="btn">자세히 보기</a>
          </div>
        </div>
      </div>
    </section>

    <!-- SECTION 7 -->
    <section class="reserve-coffee">
      <div class="inner">
        <img src="./images/reserve_logo.png" class="reserve-logo" />
        <div class="text-group">
          <img src="./images/reserve_text.png" class="description" />
          <div class="more">
            <a href="javascript:void(0);" class="btn">자세히 보기</a>
          </div>
        </div>
        <img src="./images/reserve_image.png" class="product" />
      </div>
    </section>

    <!-- SECTION 8 -->
    <section class="pick-your-favorite">
      <div class="inner">
        <div class="text-group">
          <img src="./images/favorite_text1.png" class="title" /> 
          <img src="./images/favorite_text2.png" class="description" />
          <div class="more">
            <a href="javascript:void(0);" class="btn">자세히 보기</a>
          </div>
        </div>
      </div>
    </section>

    <!-- SECTION 9 -->
    <section class="reserve-store">
      <div class="inner">
        <div class="medal">
          <div class="front">
            <img src="./images/reserve_store_medal_front.png" />
          </div>
          <div class="back">
            <img src="./images/reserve_store_medal_back.png" />
            <a href="javascript:void(0);" class="btn">매장안내</a>
          </div>
        </div>
      </div>
    </section>

    <!-- SECTION 10 -->
    <section class="find-store">
      <div class="inner">
        <img src="./images/find_store_texture1.png" class="texture1" />
        <img src="./images/find_store_texture2.png" class="texture2" />
        <img src="./images/find_store_picture1.jpg" class="picture1" />
        <img src="./images/find_store_picture2.jpg" class="picture2" />
        <div class="text-group">
          <img src="./images/find_store_text1.png" class="title" /> 
          <img src="./images/find_store_text2.png" class="description" />
          <div class="more">
            <a href="javascript:void(0);" class="btn">매장찾기</a>
          </div>
        </div>
      </div>
    </section>

    <!-- SECTION 11 -->
    <section class="awards">
      <div class="inner">
        <div class="swiper-container">
          <div class="swiper-wrapper">
            <div class="swiper-slide">
              <img src="./images/awards_slide1.jpg" alt="" />
            </div>
            <div class="swiper-slide">
              <img src="./images/awards_slide2.jpg" alt="" />
            </div>
            <div class="swiper-slide">
              <img src="./images/awards_slide3.jpg" alt="" />
            </div>
            <div class="swiper-slide">
              <img src="./images/awards_slide4.jpg" alt="" />
            </div>
            <div class="swiper-slide">
              <img src="./images/awards_slide5.jpg" alt="" />
            </div>
            <div class="swiper-slide">
              <img src="./images/awards_slide6.jpg" alt="" />
            </div>
            <div class="swiper-slide">
              <img src="./images/awards_slide7.jpg" alt="" />
            </div>
            <div class="swiper-slide">
              <img src="./images/awards_slide8.jpg" alt="" />
            </div>
            <div class="swiper-slide">
              <img src="./images/awards_slide9.jpg" alt="" />
            </div>
            <div class="swiper-slide">
              <img src="./images/awards_slide10.jpg" alt="" />
            </div>
          </div>
        </div>
        <div class="swiper-prev">
          <div class="material-icons">arrow_back</div>
        </div>
        <div class="swiper-next">
          <div class="material-icons">arrow_forward</div>
        </div>     
      </div>
    </section>

  </div> 
  
</body>
</html>