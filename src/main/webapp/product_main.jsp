<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상품관리 시스템</title>
<link rel="stylesheet" type="text/css" href="css/main.css">
</head>
<body>

<!-- 헤더 포함 -->
<%@ include file="common-jsp/header.jsp" %>

<div class="container">
    <h1>상품관리 시스템</h1>
    
    <div class="welcome-box">
        <h2>환영합니다!</h2>
        <p>상품관리 시스템에 오신 것을 환영합니다.</p>
        <p>헤더 메뉴 또는 아래 버튼을 통해 상품을 관리하실 수 있습니다.</p>
    </div>
    
    <div class="menu">
        <a href="product_list.jsp" class="btn">상품 목록</a>
        <a href="product_add.jsp" class="btn">상품 추가</a>
    </div>
</div>
</body>
</html>
