<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Header</title>
<link rel="stylesheet" type="text/css" href="css/main.css">
</head>
<body>

    <header>
        <nav>
            <ul class="main-menu">
                <li><a href="index.jsp">메인 페이지</a></li>
                <li><a href="#">사용자 관리</a></li>
                <li>
                    <a href="#">상품 관리</a>
                    <ul class="dropdown-menu">
                        <li><a href="product_list.jsp">상품 목록</a></li>
                        <li><a href="product_add.jsp">상품 추가</a></li>
                        <li><a href="product_main.jsp">상품 메인</a></li>
                    </ul>
                </li>
                <li><a href="order_list.jsp">주문 관리</a></li>
                <li><a href="#">그룹웨어</a></li>
            </ul>
        </nav>
    </header>

</body>
</html>