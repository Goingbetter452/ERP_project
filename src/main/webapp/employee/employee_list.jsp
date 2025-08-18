<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>직원 목록</title>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/employee/employee_list.css">
</head>
<body>
	<div class="table-container">
		<header>
			<h1>직원 목록</h1>
		</header>
		
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
                        <c:if test="${empty employeeList}">
                            <tr>
                                <td colspan="6" class="no-data">등록된 직원이 없습니다.</td>
                            </tr>
                        </c:if>

                        <%-- employeeList가 비어있지 않다면, 목록을 하나씩 꺼내서(var="emp") 화면에 출력합니다. --%>
                        <c:forEach var="emp" items="${employeeList}">
                            <tr>
                                <td>${emp.employeeId}</td>
                                <td>${emp.name}</td>
                                <td>${emp.department}</td>
                                <td>${emp.position}</td>
                                <td>${emp.hireDate}</td>
                                <td>
                                    <%-- 각 직원을 수정하거나 삭제하는 페이지로 이동하는 링크입니다. --%>
                                    <%-- 어떤 직원을 선택했는지 알려주기 위해 URL에 사원번호(employeeId)를 파라미터로 넘겨줍니다. --%>
                                    <a href="employee?command=editForm&employeeId=${emp.employeeId}" class="btn btn-edit">수정</a>
                                    <a href="employee?command=delete&employeeId=${emp.employeeId}" class="btn btn-delete" onclick="return confirm('정말 삭제하시겠습니까?');">삭제</a>
                                	</td>
                            </tr>
                        </c:forEach>
                        
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
					