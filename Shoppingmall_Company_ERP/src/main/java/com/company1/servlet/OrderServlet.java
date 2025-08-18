package com.company1.servlet;
import java.io.IOException;
import java.sql.*;

import com.company1.DBManager;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/OrderServlet")
public class OrderServlet extends HttpServlet {
	// 1. GET 요청 처리
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if(action == null) action = "list";//아무 값도 없으면 주문 목록 조회 실행

        switch(action) {
            case "list":
                listOrders(request, response);
                break;
            case "delete":
                deleteOrder(request, response);
                break;
            default:
                listOrders(request, response);
        }
    }
    
    
    
//2. POST 요청 처리 
protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    request.setCharacterEncoding("UTF-8");
    String action = request.getParameter("action");
    switch(action) {
    case "insert":    // 새로운 주문 추가
        insertOrder(request, response);
        break;
    case "update":    // 주문 수정 (필요시)
        updateOrder(request, response);
        break;
    default:
        doGet(request, response); // GET 처리로 위임
}
}

// 3.주문 목록 조회 메서드 정의
	private void listOrders(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBManager.getDBConnection();
            String sql = "SELECT * FROM orders ORDER BY order_date DESC";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            // JSP로 전달할 때 request에 저장
            request.setAttribute("orderList", rs);

            // order_list.jsp로 forward
            RequestDispatcher rd = request.getRequestDispatcher("order_list.jsp");
            rd.forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBManager.close(rs, pstmt, conn);
        }
    }
	
	// 4. 주문 삭제 메서드
	private void deleteOrder(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            int oid = Integer.parseInt(request.getParameter("oid"));
            conn = DBManager.getDBConnection();
            String sql = "DELETE FROM orders WHERE oid=?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, oid);
            pstmt.executeUpdate();

        } catch(Exception e) {
            e.printStackTrace();
        } finally {
            DBManager.close(null, pstmt, conn);
        }

        // 삭제 후 목록 조회
        listOrders(request, response);
    }
	
	// 5. 주문 추가 메서드
	private void insertOrder(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            int productId = Integer.parseInt(request.getParameter("productId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            int cid = Integer.parseInt(request.getParameter("cid")); // 로그인한 회원 ID

            conn = DBManager.getDBConnection();
            conn.setAutoCommit(false);

            // 1. 상품 가격 조회
            pstmt = conn.prepareStatement("SELECT price, stock FROM products WHERE pid=?");
            pstmt.setInt(1, productId);
            ResultSet rs = pstmt.executeQuery();
            if(!rs.next()) throw new Exception("상품 없음");
            int price = rs.getInt("price");
            int stock = rs.getInt("stock");
            rs.close(); pstmt.close();

            if(stock < quantity) throw new Exception("재고 부족");

            // 2. 주문 등록
            pstmt = conn.prepareStatement("INSERT INTO orders(oid, cid, order_date) VALUES(orders_seq.NEXTVAL, ?, SYSDATE)");
            pstmt.setInt(1, cid);
            pstmt.executeUpdate();
            pstmt.close();
         // 3. order_items 등록
            pstmt = conn.prepareStatement(
                "INSERT INTO order_items(order_item_id, order_id, product_id, quantity, price) " +
                "VALUES(order_items_seq.NEXTVAL, orders_seq.CURRVAL, ?, ?, ?)");
            pstmt.setInt(1, productId);
            pstmt.setInt(2, quantity);
            pstmt.setInt(3, price * quantity);
            pstmt.executeUpdate();
            pstmt.close();

            // 4. 재고 차감
            pstmt = conn.prepareStatement("UPDATE products SET stock=stock-? WHERE pid=?");
            pstmt.setInt(1, quantity);
            pstmt.setInt(2, productId);
            pstmt.executeUpdate();

            conn.commit();

        } catch(Exception e) {
            try { if(conn != null) conn.rollback(); } catch(Exception ex) { ex.printStackTrace(); }
            e.printStackTrace();
        } finally {
            DBManager.close(null, pstmt, conn);
        }

        // 주문 완료 후 목록 조회
        listOrders(request, response);
    }
	// 6. 주문 수정 메서드 (필요시)
	private void updateOrder(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 필요시 구현
    }
}