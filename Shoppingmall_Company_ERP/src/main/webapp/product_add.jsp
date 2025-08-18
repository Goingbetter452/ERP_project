<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상품 등록</title>
<link rel="stylesheet" type="text/css" href="css/main.css">
</head>
<body>

<!-- 헤더 포함 -->
<%@ include file="common-jsp/header.jsp" %>

<div class="container">
    <h2>상품 등록</h2>
    <form action="product_insert.jsp" method="post">
        <div class="form-group">
            <label for="pname">상품명:</label>
            <input type="text" id="pname" name="pname" required>
        </div>
        
        <div class="form-group">
            <label for="price">가격:</label>
            <input type="number" id="price" name="price" required min="0">
        </div>
        
        <div class="form-group">
            <label for="stock">재고:</label>
            <input type="number" id="stock" name="stock" required min="0">
        </div>
        
        <input type="submit" value="등록하기" class="btn">
        <a href="product_list.jsp" class="btn btn-secondary">취소</a>
    </form>
</div>
</body>
</html>