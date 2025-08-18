<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
ResultSet rs = (ResultSet) request.getAttribute("orderList");

// 고객 목록 조회
Connection conn = com.company1.DBManager.getDBConnection();
PreparedStatement customerStmt = conn.prepareStatement("SELECT cid, cname FROM customers");
ResultSet customers = customerStmt.executeQuery();

// 상품 목록 조회
PreparedStatement productStmt = conn.prepareStatement("SELECT pid, pname FROM products");
ResultSet products = productStmt.executeQuery();
%>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>주문관리</title>
</head>
<body>
  <h2>주문 관리</h2>
<!-- <a href="dashboard.jsp">대시보드</a><br><br> -->
 <h3>주문등록</h3>
 <form action="OrderServlet" method="post" >
  <input type="hidden" name="action" value="insert"/>
 고객:
 <select name="cid" id="" required>
  <option value=""></option>
 </select>
  
 상품:
 <select name="pid" id="" required>
  <option value=""></option>
 </select>

  수량:
  <input type="number" name=""quantity min="1" required />

  <input type="submit" value="주문" />

  <h3>주문 목록</h3>
  <table>
    <tr>
      <th>주문번호</th>
        <th>고객명</th>
        <th>상품명</th>
        <th>수량</th>
        <th>주문일</th>
        <th>삭제</th>
    </tr>
    <tr>
      <td></td>
      <td></td>
      <td></td>
      <td></td>
      <td></td>
      <td></td>
    </tr>
  </table>
</form>
</body>
</html>