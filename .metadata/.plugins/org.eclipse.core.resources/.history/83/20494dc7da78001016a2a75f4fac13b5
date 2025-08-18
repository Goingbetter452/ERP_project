<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.company1.DBManager" %>
<%
    // Initialize variables for login status
    String errorMessage = null;
    boolean isLoggedIn = false;

    // Handle login form submission
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String userId = request.getParameter("user_id");
        String userPw = request.getParameter("user_pw");

        // Validate input
        if (userId != null && userPw != null && !userId.isEmpty() && !userPw.isEmpty()) {
            Connection conn = DBManager.getDBConnection();
            try {
                String loginSql = "SELECT * FROM STARBUCKS_BO_USERS WHERE user_id = ? AND user_pw = ?";
                PreparedStatement pstmt = conn.prepareStatement(loginSql);
                pstmt.setString(1, userId);
                pstmt.setString(2, userPw);

                ResultSet rs = pstmt.executeQuery();
                if (rs.next()) {
                    isLoggedIn = true;
                    session.setAttribute("user_name", rs.getString("user_name"));
                    session.setAttribute("user_email", rs.getString("user_email"));
                } else {
                    errorMessage = "Invalid username or password.";
                }
                rs.close();
                pstmt.close();
            } catch (SQLException e) {
                errorMessage = "Database error: " + e.getMessage();
            } finally {
                conn.close();
            }
        } else {
            errorMessage = "Please enter both username and password.";
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Starbucks Login</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/reset-css@5.0.2/reset.min.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .login-container {
            background: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            width: 300px;
        }
        .login-container h1 {
            text-align: center;
            margin-bottom: 20px;
        }
        .login-container form {
            display: flex;
            flex-direction: column;
        }
        .login-container input {
            margin-bottom: 15px;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        .login-container button {
            padding: 10px;
            background-color: #00704a;
            color: #fff;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        .login-container button:hover {
            background-color: #005a37;
        }
        .error-message {
            color: red;
            text-align: center;
            margin-bottom: 15px;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <h1>Login</h1>
        <% if (isLoggedIn) { %>
<script>
  //alert("Welcome, " + session.getAttribute("user_name") + "!");
  window.location.href = "./admin_notice_list.jsp"; // Redirect to admin notice list    
</script>                      
        <% } else { %>
            <% if (errorMessage != null) { %>
                <p class="error-message"><%= errorMessage %></p>
            <% } %>
            <form method="POST" action="./login.jsp">
                <input type="text" name="user_id" placeholder="Username" required />
                <input type="password" name="user_pw" placeholder="Password" required />
                <button type="submit">Login</button>
            </form>
        <% } %>
    </div>
</body>
</html>