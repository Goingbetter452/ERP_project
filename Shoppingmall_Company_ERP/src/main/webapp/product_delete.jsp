<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.company1.DBManager" %>
<%
request.setCharacterEncoding("UTF-8");

// 파라미터 받기
String pidParam = request.getParameter("pid");

if (pidParam == null) {
    response.sendRedirect("product_list.jsp");
    return;
}

try {
    int pid = Integer.parseInt(pidParam);
    
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    
    try {
        conn = DBManager.getDBConnection();
        
        // 삭제 전 상품 정보 확인 (디버깅용)
        String selectSql = "SELECT PID, PNAME, PRICE, STOCK FROM PRODUCTS WHERE PID=?";
        pstmt = conn.prepareStatement(selectSql);
        pstmt.setInt(1, pid);
        rs = pstmt.executeQuery();
        
        if (rs.next()) {
            System.out.println("삭제 대상 상품 정보:");
            System.out.println("PID: " + rs.getInt("PID"));
            System.out.println("상품명: " + rs.getString("PNAME"));
            System.out.println("가격: " + rs.getInt("PRICE"));
            System.out.println("재고: " + rs.getInt("STOCK"));
        } else {
            System.out.println("삭제 대상 상품을 찾을 수 없음 - PID: " + pid);
            response.sendRedirect("product_list.jsp?error=notfound");
            return;
        }
        
        // PreparedStatement 정리
        if (rs != null) rs.close();
        if (pstmt != null) pstmt.close();
        
        // 실제 삭제 실행
        String sql = "DELETE FROM PRODUCTS WHERE PID=?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, pid);
        
        int result = pstmt.executeUpdate();
        
        if (result > 0) {
            // 삭제 성공
            System.out.println("상품 삭제 성공 - PID: " + pid);
            response.sendRedirect("product_list.jsp?message=deleted");
        } else {
            // 삭제 실패 (해당 상품 없음)
            System.out.println("상품 삭제 실패 - PID: " + pid);
            response.sendRedirect("product_list.jsp?error=notfound");
        }
        
    } catch(SQLException e) {
        // 외래키 제약조건 오류 처리
        if (e.getErrorCode() == 2292) { // ORA-02292: 외래키 제약조건 위배
            System.out.println("외래키 제약조건 오류 - PID: " + pid + " (주문이 있는 상품)");
            response.sendRedirect("product_list.jsp?error=hasorders&pid=" + pid);
        } else {
            // 기타 데이터베이스 오류
            System.out.println("삭제 오류 - PID: " + pid);
            System.out.println("SQL State: " + e.getSQLState());
            System.out.println("Error Code: " + e.getErrorCode());
            System.out.println("Message: " + e.getMessage());
            e.printStackTrace();
            
            response.sendRedirect("product_list.jsp?error=db&detail=" + java.net.URLEncoder.encode(e.getMessage(), "UTF-8"));
        } finally {
        try {
            if(rs != null) rs.close();
            if(pstmt != null) pstmt.close();
            if(conn != null) conn.close();
        } catch(SQLException e) {
            e.printStackTrace();
        }
    }
    
} catch(NumberFormatException e) {
    // 잘못된 PID
    response.sendRedirect("product_list.jsp?error=invalid");
}
%>
