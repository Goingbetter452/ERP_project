<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.company1.DBManager" %>
<%
request.setCharacterEncoding("UTF-8");

// 파라미터 받기
String pidParam = request.getParameter("pid");
String pname = request.getParameter("pname");
String priceParam = request.getParameter("price");
String stockParam = request.getParameter("stock");

// 유효성 검사
if (pidParam == null || pname == null || priceParam == null || stockParam == null ||
    pname.trim().isEmpty()) {
    response.sendRedirect("product_list.jsp");
    return;
}

try {
    int pid = Integer.parseInt(pidParam);
    int price = Integer.parseInt(priceParam);
    int stock = Integer.parseInt(stockParam);
    
    Connection conn = null;
    PreparedStatement pstmt = null;
    
    try {
        conn = DBManager.getDBConnection();
        String sql = "UPDATE PRODUCTS SET PNAME=?, PRICE=?, STOCK=? WHERE PID=?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, pname.trim());
        pstmt.setInt(2, price);
        pstmt.setInt(3, stock);
        pstmt.setInt(4, pid);
        
        int result = pstmt.executeUpdate();
        
        if (result > 0) {
            // 수정 성공
            response.sendRedirect("product_list.jsp?message=updated");
        } else {
            // 수정 실패 (해당 상품 없음)
            response.sendRedirect("product_list.jsp?error=notfound");
        }
        
    } catch(SQLException e) {
        e.printStackTrace();
        response.sendRedirect("product_list.jsp?error=db");
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
    response.sendRedirect("product_edit.jsp?pid=" + pidParam + "&error=invalid");
}
%>
