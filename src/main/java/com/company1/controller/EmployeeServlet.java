package com.company1.controller;

import java.io.IOException;
import java.util.List;

// 서블릿 관련 import (Jakarta EE 사용)
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

// 프로젝트에서 만든 DAO와 DTO 클래스들을 import
import com.company1.dao.EmployeeDAO;
import com.company1.dto.EmployeeDTO;

// 프로젝트에서 만든 DAO와 DTO 클래스들을 import
import com.company1.dao.EmployeeDAO;
import com.company1.dto.EmployeeDTO;

/**
 * ==========================================
 * 직원(Employee) 관리 서블릿 클래스
 * ==========================================
 * 
 * 이 서블릿은 직원 관련 모든 웹 요청을 처리하는 컨트롤러입니다.
 * 
 * 서블릿이란?
 * - 웹 브라우저에서 온 요청(HTTP Request)을 받아서 처리하고
 * - 응답(HTTP Response)을 다시 브라우저로 보내는 Java 클래스입니다.
 * 
 * URL 매핑: /EmployeeServlet
 * 즉, http://localhost:8080/프로젝트명/EmployeeServlet 으로 접근 가능
 */
@WebServlet("/EmployeeServlet")
public class EmployeeServlet extends HttpServlet {
	
	// 직렬화 버전 ID (서블릿에서 필요한 고정값)
	private static final long serialVersionUID = 1L;
       
    /**
     * 기본 생성자
     */
    public EmployeeServlet() {
        super();
    }

	/**
	 * GET 방식 요청 처리 메소드
	 * 브라우저 주소창에 직접 URL을 입력하거나 <a> 링크를 클릭할 때 호출됩니다.
	 * 
	 * @param request  클라이언트에서 서버로 보낸 요청 정보 (파라미터, 헤더 등)
	 * @param response 서버에서 클라이언트로 보낼 응답 정보 (HTML, 리다이렉트 등)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) 
			throws ServletException, IOException {
		// GET과 POST 요청을 모두 같은 방식으로 처리하기 위해 actionDo() 호출
		actionDo(request, response);
	}

	/**
	 * POST 방식 요청 처리 메소드
	 * HTML 폼(<form>)에서 method="post"로 전송할 때 호출됩니다.
	 * 
	 * @param request  클라이언트에서 서버로 보낸 요청 정보
	 * @param response 서버에서 클라이언트로 보낄 응답 정보
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) 
			throws ServletException, IOException {
		// 한글 깨짐 방지를 위한 인코딩 설정
		request.setCharacterEncoding("UTF-8");
		// GET과 POST 요청을 모두 같은 방식으로 처리하기 위해 actionDo() 호출
		actionDo(request, response);
	}
	
	/**
	 * ==========================================
	 * 실제 비즈니스 로직을 처리하는 핵심 메소드
	 * ==========================================
	 * 
	 * 이 메소드가 하는 일:
	 * 1. 클라이언트에서 보낸 'action' 파라미터를 확인
	 * 2. action 값에 따라 다른 작업 수행 (조회, 등록, 수정, 삭제)
	 * 3. DAO를 통해 데이터베이스 작업 실행
	 * 4. 결과를 JSP 페이지로 전달
	 * 
	 * @param request  클라이언트 요청 정보 (파라미터, 세션 등)
	 * @param response 서버 응답 정보 (리다이렉트, 포워드 등)
	 */
	private void actionDo(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		// 1단계: 클라이언트가 어떤 작업을 원하는지 파라미터로 확인
		// 예: ?action=list, ?action=insert, ?action=update, ?action=delete
		String action = request.getParameter("action");
		
		// 2단계: DAO 객체 생성 (데이터베이스 작업을 담당하는 클래스)
		// DAO = Data Access Object (데이터 접근 객체)
		EmployeeDAO employeeDAO = new EmployeeDAO();
		
		// 3단계: 작업 완료 후 이동할 페이지 경로를 저장할 변수
		String forwardPath = "";
		
		
		// 4단계: action 값에 따라 다른 작업 수행
		if (action == null || action.equals("list")) {
			// ===== 직원 목록 조회 =====
			// action이 없거나 "list"인 경우 직원 목록을 보여줌
			
			// DAO의 메소드를 호출해서 데이터베이스에서 모든 직원 정보를 가져옴
			List<EmployeeDTO> employeeList = employeeDAO.selectAllEmployees();
			
			// 가져온 데이터를 request 객체에 저장 (JSP에서 사용할 수 있게)
			// "employeeList"라는 이름으로 저장하면 JSP에서 ${employeeList}로 접근 가능
			request.setAttribute("employeeList", employeeList);
			
			// 직원 목록을 보여줄 JSP 페이지 경로 설정
			forwardPath = "/employee_list.jsp";
			
		} else if (action.equals("insert")) {
			// ===== 직원 등록 =====
			// 폼에서 입력한 직원 정보를 데이터베이스에 저장
			
			// 폼에서 전송된 데이터 받기
			String empId = request.getParameter("empId");
			String empPw = request.getParameter("empPw");
			String empName = request.getParameter("empName");
			String position = request.getParameter("position");
			String auth = request.getParameter("auth");
			
			// DTO 객체 생성하고 데이터 설정
			EmployeeDTO emp = new EmployeeDTO();
			emp.setEmpId(empId);
			emp.setEmpPw(empPw);
			emp.setEmpName(empName);
			emp.setPosition(position);
			emp.setAuth(auth);
			
			// DAO를 통해 데이터베이스에 저장
			employeeDAO.insertEmployee(emp);
			
			System.out.println("직원 등록 완료: " + empName);
			
			// 등록 완료 후 목록 페이지로 리다이렉트
			// 리다이렉트: 브라우저에게 새로운 URL로 다시 요청하라고 지시
			response.sendRedirect("EmployeeServlet?action=list");
			return; // 메소드 종료
			
		} else if (action.equals("update")) {
			// ===== 직원 정보 수정 =====
			
			// 수정할 직원 정보 받기
			String empId = request.getParameter("empId");
			String empPw = request.getParameter("empPw");
			String empName = request.getParameter("empName");
			String position = request.getParameter("position");
			String auth = request.getParameter("auth");
			
			// DTO 객체 생성하고 데이터 설정
			EmployeeDTO emp = new EmployeeDTO();
			emp.setEmpId(empId);
			emp.setEmpPw(empPw);
			emp.setEmpName(empName);
			emp.setPosition(position);
			emp.setAuth(auth);
			
			// DAO를 통해 데이터베이스에서 정보 수정
			employeeDAO.updateEmployee(emp);
			
			System.out.println("직원 정보 수정 완료: " + empName);
			
			// 수정 완료 후 목록 페이지로 리다이렉트
			response.sendRedirect("EmployeeServlet?action=list");
			return; // 메소드 종료
			
		} else if (action.equals("delete")) {
			// ===== 직원 삭제 =====
			
			// 삭제할 직원 ID 받기
			String empId = request.getParameter("empId");
			
			// DAO를 통해 데이터베이스에서 해당 직원 삭제
			employeeDAO.deleteEmployee(empId);
			
			System.out.println("직원 삭제 완료: " + empId);
			
			// 삭제 완료 후 목록 페이지로 리다이렉트
			response.sendRedirect("EmployeeServlet?action=list");
			return; // 메소드 종료
		}
		
		// 5단계: JSP 페이지로 포워드
		// 포워드: 서버 내부에서 다른 페이지로 요청을 전달 (브라우저는 모름)
		// 리다이렉트와 달리 request 객체의 데이터가 유지됨
		RequestDispatcher dispatcher = request.getRequestDispatcher(forwardPath);
		dispatcher.forward(request, response);
	}

}
