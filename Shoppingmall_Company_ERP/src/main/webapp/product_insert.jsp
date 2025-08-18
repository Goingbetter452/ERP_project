<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.company1.DBManager" %>
<%
request.setCharacterEncoding("UTF-8");

// 파라미터 받기
String pname = request.getParameter("pname");
String priceParam = request.getParameter("price");
String stockParam = request.getParameter("stock");

// 유효성 검사
if (pname == null || priceParam == null || stockParam == null ||
    pname.trim().isEmpty()) {
    response.sendRedirect("product_add.jsp?error=invalid");
    return;
}

try {
    int price = Integer.parseInt(priceParam);
    int stock = Integer.parseInt(stockParam);
    
    Connection conn = null;
    PreparedStatement pstmt = null;
    
    try {
        conn = DBManager.getDBConnection();
        // 트리거가 자동으로 PID를 설정하므로 PID는 제외
        String sql = "INSERT INTO PRODUCTS (PNAME, PRICE, STOCK) VALUES (?, ?, ?)";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, pname.trim());
        pstmt.setInt(2, price);
        pstmt.setInt(3, stock);
        
        int result = pstmt.executeUpdate();
        
        if (result > 0) {
            // 등록 성공
            response.sendRedirect("product_list.jsp?message=added");
        } else {
            // 등록 실패
            response.sendRedirect("product_add.jsp?error=insert");
        }
        
    } catch(SQLException e) {
        e.printStackTrace();
        response.sendRedirect("product_add.jsp?error=db");
    } finally {
        try {
            if(pstmt != null) pstmt.close();
            if(conn != null) conn.close();
        } catch(SQLException e) {
            e.printStackTrace();
        }
    }
    
} catch(NumberFormatException e) {
    // 숫자 형변환 오류
    response.sendRedirect("product_add.jsp?error=invalid");
}
%>
