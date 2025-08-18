<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.DBManager" %>
    
<!DOCTYPE html>
<html>
<head>
<!-- 밑의 링크는 css 연결을 위한 코드 -->
<Link rel="stylesheet" type="text/css" href="css/login.css">  
<meta charset="UTF-8">
<title>로그인</title>
</head>
<body>
       <div class="login-container">
        <div class="logo">
            <h1>로그인</h1>
        </div>

   <form action="LoginServlet" method="post">
    ID: <input type="text" name="username" /><br>
    PW: <input type="password" name="password" /><br>
    <input type="submit" value="로그인" />
</form>
   
</body>
</html>