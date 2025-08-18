<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.com.company1.dao.EmployeeDAO" %>
<%@ page import="java.com.company1.dto.EmployeeDTO" %>
<%
	// --- 1. 페이지 모드(등록/수정)를 결정하는 Java코드 ---
	String empId = request.getParameter("empId"); // URL에 empId가 있는지 확인

    String pageTitle = "직원 신규 등록";
    String buttonText = "등록하기";
    String formAction = "insert"; // 서블릿에 보낼 action 값 기본은 'insert'

    EmployeeDTO emp = new EmployeeDTO(); // 빈 DTO 객체 준비
	
    // URL에 empId가 있다면, '수정 모드'로 변경
    if (empId != null && !empId.isEmpty()) {
        pageTitle = "직원 정보 수정";
        buttonText = "수정하기";
        formAction = "update"; // 서블릿에 보낼 action 값을 'update'로 변경

        EmployeeDAO dao = new EmployeeDAO();
        emp = dao.selectEmployeeById(empId); // DB에서 해당 직원 정보를 가져옴
    }
%>
	<!DOCTYPE html>
	<html>
	<head>
	<meta charset="UTF-8">
	<title><%= pageTitle %></title> <%-- 2. 페이지 제목 동적 변경 --%>
	<link rel="stylesheet" type="text/css" href="css/main.css">
	<style>
    /* 간단한 스타일 예시 */
    body {
        padding-top: 80px; /* 헤더 공간 확보 */
    }
    .form-container { width: 400px; margin: 20px auto; padding: 20px; border: 1px solid #ccc; }
    .form-container h1 { text-align: center; }
    .form-container input { width: 100%; padding: 8px; margin-bottom: 10px; box-sizing: border-box; }
    .form-container button { width: 100%; padding: 10px; background-color: #007bff; color: white; border: none; }
	</style>
	</head>
	<body>

	<!-- 헤더 포함 -->
	<%@ include file="common-jsp/header.jsp" %>

    <div class="form-container">
        <h1><%= pageTitle %></h1> <%-- 2. 페이지 제목 동적 변경 --%>
        
        <%-- 3. EmployeeServlet으로 데이터를 보내는 form --%>
        <form action="../EmployeeServlet" method="post">
            
            <%-- 4. 서블릿에게 '등록'인지 '수정'인지 알려주는 비밀 정보 --%>
            <input type="hidden" name="action" value="<%= formAction %>">
            
            <label>직원 아이디</label>
            <%-- 5. 수정 모드일 때 아이디는 변경 못하게 readonly 처리 --%>
            <input type="text" name="empId" value="<%= (emp.getEmpId() != null) ? emp.getEmpId() : "" %>" 
                   <%= (formAction.equals("update")) ? "readonly" : "" %>>

            <label>비밀번호</label>
            <input type="password" name="empPw" placeholder="새 비밀번호 또는 변경할 비밀번호 입력">

            <label>이름</label>
            <input type="text" name="empName" value="<%= (emp.getEmpName() != null) ? emp.getEmpName() : "" %>">

            <label>직급</label>
            <input type="text" name="position" value="<%= (emp.getPosition() != null) ? emp.getPosition() : "" %>">

            <label>권한</label>
            <select name="auth">
                <%-- 6. 수정 모드일 때 기존 권한을 선택된 상태(selected)로 표시 --%>
                <option value="user" <%= ("user".equals(emp.getAuth())) ? "selected" : "" %>>일반사용자</option>
                <option value="admin" <%= ("admin".equals(emp.getAuth())) ? "selected" : "" %>>관리자</option>
            </select>
            <br><br>
            
            <%-- 7. 버튼 텍스트 동적 변경 --%>
            <button type="submit"><%= buttonText %></button>
        </form>
    </div>

	</body>
	</html>
