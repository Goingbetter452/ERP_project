<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.company1.dto.EmployeeDTO" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>직원 목록</title>
<link rel="stylesheet" type="text/css" href="css/main.css">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/employee/employee_list.css">
</head>
<body>
	<!-- 헤더 포함 -->
	<%@ include file="common-jsp/header.jsp" %>
	
	<div class="table-container">
		<div class="page-header">
			<h1>직원 목록</h1>
		</div>
		
		<main>
			<div class="table-container">
				<table>
					<thead>
						<tr>
							<th>사원번호</th>
							<th>이름</th>
							<th>부서</th>
							<th>직급</th>
							<th>입사일</th>
							<th>관리</th>
						</tr>
					</thead>								
					<tbody>
						<%-- 
                            핵심로직!!!!!(서블릿에서 받은 데이터를 화면에 보이게 함)
                        --%>
                        <%
                            List<EmployeeDTO> employeeList = (List<EmployeeDTO>) request.getAttribute("employeeList");
                            if (employeeList == null || employeeList.isEmpty()) {
                        %>
                            <tr>
                                <td>EMP001</td>
                                <td>김직원</td>
                                <td>개발팀</td>
                                <td>사원</td>
                                <td>2024-01-15</td>
                                <td>
                                    <a href="employee_form.jsp?empId=EMP001" class="btn btn-edit">수정</a>
                                    <a href="EmployeeServlet?action=delete&empId=EMP001" class="btn btn-delete" onclick="return confirm('정말 삭제하시겠습니까?');">삭제</a>
                                </td>
                            </tr>
                            <tr>
                                <td>EMP002</td>
                                <td>이관리</td>
                                <td>관리팀</td>
                                <td>대리</td>
                                <td>2023-05-10</td>
                                <td>
                                    <a href="employee_form.jsp?empId=EMP002" class="btn btn-edit">수정</a>
                                    <a href="EmployeeServlet?action=delete&empId=EMP002" class="btn btn-delete" onclick="return confirm('정말 삭제하시겠습니까?');">삭제</a>
                                </td>
                            </tr>
                        <%
                            } else {
                                for (EmployeeDTO emp : employeeList) {
                        %>
                            <tr>
                                <td><%= emp.getEmpId() %></td>
                                <td><%= emp.getEmpName() %></td>
                                <td><%= emp.getPosition() != null ? emp.getPosition() : "미지정" %></td>
                                <td><%= emp.getPosition() %></td>
                                <td>입사일</td>
                                <td>
                                    <%-- 각 직원을 수정하거나 삭제하는 페이지로 이동하는 링크입니다. --%>
                                    <%-- 어떤 직원을 선택했는지 알려주기 위해 URL에 사원번호(empId)를 파라미터로 넘겨줍니다. --%>
                                    <a href="employee_form.jsp?empId=<%= emp.getEmpId() %>" class="btn btn-edit">수정</a>
                                    <a href="EmployeeServlet?action=delete&empId=<%= emp.getEmpId() %>" class="btn btn-delete" onclick="return confirm('정말 삭제하시겠습니까?');">삭제</a>
                                </td>
                            </tr>
                        <%
                                }
                            }
                        %>
                        
                    </tbody>
                </table>
            </div>
            
            <div class="action-buttons">
                <%-- 직원 등록 페이지(employee_form.jsp)로 이동하는 버튼입니다. --%>
                <a href="employee_form.jsp" class="btn btn-primary">신규 직원 등록</a>
            </div>
        </main>
        
        <footer>
            <p>&copy; 2025 Company1 ERP Project. All Rights Reserved.</p>
        </footer>
    </div>

</body>
</html>
					