<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.company1.DBManager" %>

<%
request.setCharacterEncoding("UTF-8");

// 페이지네이션 및 검색 기능을 위한 변수 설정
int currentPage = 1;
int pageSize = 10; // 한 페이지당 표시 수
String search = request.getParameter("search");

if(request.getParameter("page") != null) {
    currentPage = Integer.parseInt(request.getParameter("page"));
}
int startRow = (currentPage - 1) * pageSize;

Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;
PreparedStatement pstmtCount = null;
ResultSet rsCount = null;

int totalRows = 0;
boolean hasData = false;

try {
    conn = DBManager.getDBConnection();

    // 총 상품 수 (검색 포함) - Oracle 문법 사용
    String countSql = "SELECT COUNT(*) FROM PRODUCTS";
    if(search != null && !search.isEmpty()) {
        countSql += " WHERE PNAME LIKE ?";
    }
    pstmtCount = conn.prepareStatement(countSql);
    if(search != null && !search.isEmpty()) {
        pstmtCount.setString(1, "%" + search + "%");
    }
    rsCount = pstmtCount.executeQuery();
    if(rsCount.next()) totalRows = rsCount.getInt(1);
    
    // 첫 번째 PreparedStatement 정리
    if(rsCount != null) rsCount.close();
    if(pstmtCount != null) pstmtCount.close();

    // 상품 조회 (검색 + 페이징) - Oracle 문법 사용
    String sql = "SELECT * FROM (SELECT ROWNUM rnum, p.* FROM (SELECT * FROM PRODUCTS";
    if(search != null && !search.isEmpty()) {
        sql += " WHERE PNAME LIKE ?";
    }
    sql += " ORDER BY PID ASC) p WHERE ROWNUM <= ?) WHERE rnum > ?";

    pstmt = conn.prepareStatement(sql);
    int idx = 1;
    if(search != null && !search.isEmpty()) {
        pstmt.setString(idx++, "%" + search + "%");
    }
    pstmt.setInt(idx++, startRow + pageSize);
    pstmt.setInt(idx++, startRow);

    rs = pstmt.executeQuery();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상품 목록</title>
<link rel="stylesheet" type="text/css" href="css/main.css">
</head>
<body>

<!-- 헤더 포함 -->
<%@ include file="common-jsp/header.jsp" %>

<div class="container">
    <h1>상품 목록</h1>

    <!-- 메시지 표시 -->
    <%
    String message = request.getParameter("message");
    String error = request.getParameter("error");
    if (message != null) {
        if ("updated".equals(message)) {
            out.println("<div class='message success'>상품이 성공적으로 수정되었습니다.</div>");
        } else if ("deleted".equals(message)) {
            out.println("<div class='message success'>상품이 성공적으로 삭제되었습니다.</div>");
        } else if ("added".equals(message)) {
            out.println("<div class='message success'>상품이 성공적으로 추가되었습니다.</div>");
        }
    }
    if (error != null) {
        if ("notfound".equals(error)) {
            out.println("<div class='message error'>해당 상품을 찾을 수 없습니다.</div>");
        } else if ("hasorders".equals(error)) {
            String pid = request.getParameter("pid");
            out.println("<div class='message error'>⚠️ 해당 상품은 주문 내역이 있어 삭제할 수 없습니다.</div>");
            out.println("<div class='message error' style='font-size: 12px; margin-top: 5px;'>주문 내역을 먼저 처리한 후 삭제해주세요. (상품번호: " + pid + ")</div>");
        } else if ("db".equals(error)) {
            String detail = request.getParameter("detail");
            out.println("<div class='message error'>데이터베이스 오류가 발생했습니다.</div>");
            if (detail != null) {
                out.println("<div class='message error' style='font-size: 12px; margin-top: 5px;'>상세 오류: " + detail + "</div>");
            }
        } else if ("invalid".equals(error)) {
            out.println("<div class='message error'>잘못된 요청입니다.</div>");
        }
    }
    %>

    <!-- 검색 -->
    <form method="get" action="product_list.jsp" style="text-align:center; margin-bottom:10px;">
        <input type="text" name="search" value="<%= (search!=null)?search:"" %>" placeholder="상품명 검색">
        <input type="submit" value="검색">
        <% if(search != null && !search.isEmpty()) { %>
            <a href="product_list.jsp">전체보기</a>
        <% } %>
    </form>

    <table class="product-table">
    <thead>
    <tr>
        <th>상품번호</th>
        <th>상품명</th>
        <th>가격</th>
        <th>재고</th>
        <th>관리</th>
    </tr>
    </thead>
    <tbody>
    <%
    int displayNumber = (currentPage - 1) * pageSize; // 페이징을 고려한 시작 번호
    while(rs.next()) {
        hasData = true;
        displayNumber++; // 1부터 시작하는 연속 번호
    %>
    <tr>
        <td><%= displayNumber %></td>
        <td><%= rs.getString("PNAME") %></td>
        <td><%= String.format("%,d", rs.getInt("PRICE")) %>원</td>
        <td><%= rs.getInt("STOCK") %>개</td>
        <td>
            <a href="product_edit.jsp?pid=<%= rs.getInt("PID") %>" class="btn-small">수정</a>
            <a href="product_delete.jsp?pid=<%= rs.getInt("PID") %>" 
               class="btn-small btn-danger" 
               onclick="return confirm('정말 삭제하시겠습니까?')">삭제</a>
        </td>
    </tr>
    <%
    }
    
    if(!hasData) {
    %>
    <tr>
        <td colspan="5">
            <% if(search != null && !search.isEmpty()) { %>
                검색 결과가 없습니다.
            <% } else { %>
                등록된 상품이 없습니다. <a href="product_add.jsp" class="btn">첫 번째 상품 추가하기</a>
            <% } %>
        </td>
    </tr>
    <%
    }
    %>
    </tbody>
    </table>

    <!-- 페이징 -->
    <% if(hasData && totalRows > pageSize) { %>
    <div class="pagination">
    <%
    int totalPages = (int)Math.ceil((double)totalRows / pageSize);
    for(int i=1; i<=totalPages; i++) {
        if(i==currentPage) {
            out.print("<b>"+i+"</b>");
        } else {
            out.print("<a href='product_list.jsp?page="+i+(search!=null?"&search="+search:"")+"'>"+i+"</a>");
        }
    }
    %>
    </div>
    <% } %>
</div>
</body>
</html>
<%
} catch(Exception e) {
    e.printStackTrace();
    out.println("<div class='error-message'>데이터베이스 오류가 발생했습니다: " + e.getMessage() + "</div>");
} finally {
    try {
        if(rs != null) rs.close();
        if(pstmt != null) pstmt.close();
        if(rsCount != null) rsCount.close();
        if(pstmtCount != null) pstmtCount.close();
        if(conn != null) conn.close();
    } catch(SQLException e) {
        e.printStackTrace();
    }
}
%>
