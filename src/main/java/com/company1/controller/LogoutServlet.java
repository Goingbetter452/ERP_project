package java.com.company1.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


/**
 * 로그아웃 기능을 처리하는 서블릿입니다.
 * URL 매핑: /logout
 */
public class LogoutServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	public LogoutServlet() {
		super();
	}
	
	
	protected void doGet(jakarta.servlet.http.HttpServletRequest request, jakarta.servlet.http.HttpServletResponse response) throws ServletException, IOException {
		// 1. 현재 사용자의 세션을 가져옵니다.
		// getSession(false)는 세션이 없으면 새로 만들지 않고 null을 반환합니다.
		jakarta.servlet.http.HttpSession session = request.getSession(false);
		
		// 2. 세션이 존재하는 겨우, 세션을 무효화(invalidate)합니다.
		// invalidate() 메소드가 호출되면, 세션에 저장된 모든 정보가 사라집니다.
		if(session != null) {
		   session.invalidate();
		}
		
		// 3. 로그아웃 후 로그인 페이지로 리다이렉트(redirect) 시킵니다.
		// getContextPath()는 현재 웹 애플리케이션의 컨텍스트 경로를 반환합니다. (예: /erp_project)
		// 클라이언트의 URL을 직접 변경하여 새로운 페이지로 이동시키는 방식입니다.
		response.sendRedirect(request.getContextPath() + "/login.jsp");
		
	}
	
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// POST 요청이 와도 동일하게 doGet() 메소드를 호출하여 처리합니다.
		doGet(request, response);
	}

}
