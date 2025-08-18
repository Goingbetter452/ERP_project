package com.company1.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.company1.dao.EmployeeDAO;
import com.company1.dto.EmployeeDTO;

/**
 * ==========================================
 * 로그인 처리 서블릿 클래스
 * ==========================================
 * 
 * 이 서블릿이 하는 일:
 * 1. 로그인 폼(login.jsp)에서 사용자가 입력한 ID/PW를 받음
 * 2. 데이터베이스에서 해당 정보가 맞는지 확인
 * 3. 로그인 성공하면 세션에 사용자 정보 저장하고 메인 페이지로 이동
 * 4. 로그인 실패하면 다시 로그인 페이지로 이동
 * 
 * URL 매핑: /LoginServlet
 */
@WebServlet("/LoginServlet") 	// login.jsp의 form에서 이 주소로 데이터를 보냄
public class LoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	/**
	 * POST 방식으로 로그인 요청을 처리하는 메소드
	 * 로그인 폼에서 method="post"로 전송된 데이터를 처리합니다.
	 * 
	 * @param request  클라이언트에서 보낸 요청 (ID, PW 포함)
	 * @param response 서버에서 클라이언트로 보낼 응답 (리다이렉트)
	 */
	 protected void doPost(jakarta.servlet.http.HttpServletRequest request, jakarta.servlet.http.HttpServletResponse response) 
	            throws ServletException, IOException {
		 
		 
		 // ===== 1단계: 로그인 폼에서 사용자가 입력한 데이터 받기 =====
		 request.setCharacterEncoding("UTF-8"); // 한글 깨짐 방지
		 String id = request.getParameter("username"); // <input name="username">에서 입력한 값
		 String pw = request.getParameter("password"); // <input name="password">에서 입력한 값
		 
		 System.out.println("로그인 시도 - ID: " + id); // 디버깅용 출력
		 
		 
		 // ===== 2단계: DAO 객체 생성 (데이터베이스 작업을 담당) =====
		 EmployeeDAO dao = new EmployeeDAO();
		 
		 
		 // ===== 3단계: 데이터베이스에서 로그인 정보 확인 =====
		 // DAO에게 입력받은 ID와 PW를 주고 해당 직원이 존재하는지 확인
		 // 결과: 직원이 존재하면 EmployeeDTO 객체 반환, 없으면 null 반환
		 EmployeeDTO empDTO = dao.checkLogin(id,pw);
		 
		 
		 // ===== 4단계: 로그인 결과에 따른 처리 =====
		 if(empDTO != null) { 
		    // 로그인 성공! (null이 아니면 해당 직원이 데이터베이스에 존재한다는 뜻)
		    System.out.println("로그인 성공: " + empDTO.getEmpName() + "님 환영합니다.");
		    
		    // ===== 세션(Session)에 로그인 정보 저장 =====
		    // 세션: 서버에서 각 사용자별로 제공하는 개인 저장공간
		    // 브라우저를 닫을 때까지 정보가 유지됨
		    jakarta.servlet.http.HttpSession session = request.getSession();
		    session.setAttribute("loginUser", empDTO); // "loginUser"라는 이름으로 직원 정보 저장
		    
		    // 성공하면 메인 페이지로 이동
		    response.sendRedirect("index.jsp");
		 
		 } else {	
		    // 로그인 실패! (null이면 입력한 ID/PW와 일치하는 직원이 없다는 뜻)
		    System.out.println("로그인 실패: 아이디 또는 비밀번호를 다시 확인해주세요.");
		    
		    // 실패하면 다시 로그인 페이지로 이동
		    // 추후에는 에러 메시지를 함께 전달할 수 있음
		    response.sendRedirect("login.jsp");
		 }
	 }
	 
	/**
	 * ==========================================
	 * 서블릿의 핵심 개념 정리
	 * ==========================================
	 * 
	 * 1. doGet() vs doPost()
	 *    - doGet(): 주소창에 URL 입력, <a> 링크 클릭 시 호출
	 *    - doPost(): <form method="post"> 폼 전송 시 호출
	 * 
	 * 2. request vs response
	 *    - request: 클라이언트 → 서버로 오는 정보 (파라미터, 헤더 등)
	 *    - response: 서버 → 클라이언트로 보낸 정보 (HTML, 리다이렉트 등)
	 * 
	 * 3. 포워드 vs 리다이렉트
	 *    - 포워드: 서버 내부에서 페이지 이동 (request 데이터 유지)
	 *    - 리다이렉트: 브라우저에게 새 URL로 이동하라고 지시 (새로운 요청)
	 * 
	 * 4. 세션(Session)
	 *    - 서버에서 각 사용자별로 제공하는 개인 저장공간
	 *    - 브라우저를 닫을 때까지 정보 유지
	 *    - 로그인 정보, 장바구니 등 저장에 사용
	 */

}


