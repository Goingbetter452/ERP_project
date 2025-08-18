<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.company1.DBManager" %>
<%
request.setCharacterEncoding("UTF-8");

// 파라미터 받기 (null 체크)
String pidParam = request.getParameter("pid");
if (pidParam == null) {
    response.sendRedirect("product_list.jsp");
    return;
}

int pid = Integer.parseInt(pidParam);
Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;
String pname = "";
int price = 0, stock = 0;
boolean found = false;

try {
    conn = DBManager.getDBConnection();
    String sql = "SELECT * FROM PRODUCTS WHERE PID=?";
    pstmt = conn.prepareStatement(sql);
    pstmt.setInt(1, pid);
    rs = pstmt.executeQuery();
    
    if(rs.next()){
        pname = rs.getString("PNAME");
        price = rs.getInt("PRICE");
        stock = rs.getInt("STOCK");
        found = true;
    }
} catch(Exception e){ 
    e.printStackTrace();
} finally { 
    try {
        if(rs != null) rs.close();
        if(pstmt != null) pstmt.close();
        if(conn != null) conn.close();
    } catch(SQLException e) {
        e.printStackTrace();
    }
}

// 상품을 찾지 못한 경우
if (!found) {
    response.sendRedirect("product_list.jsp");
    return;
}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상품 수정</title>
<link rel="stylesheet" type="text/css" href="css/main.css">
</head>
<body>

<!-- 헤더 포함 -->
<%@ include file="common-jsp/header.jsp" %>

<div class="container">
    <h2>상품 수정</h2>
    
    <form action="product_update.jsp" method="post">
        <input type="hidden" name="pid" value="<%=pid%>">
        
        <div class="form-group">
            <label for="pname">상품명:</label>
            <input type="text" id="pname" name="pname" value="<%=pname%>" required>
        </div>
        
        <div class="form-group">
            <label for="price">가격:</label>
            <input type="number" id="price" name="price" value="<%=price%>" required min="0">
        </div>
        
        <div class="form-group">
            <label for="stock">재고:</label>
            <input type="number" id="stock" name="stock" value="<%=stock%>" required min="0">
        </div>
        
        <input type="submit" value="수정하기" class="btn">
        <a href="product_list.jsp" class="btn btn-secondary">취소</a>
    </form>
</div>
</body>
</html>
