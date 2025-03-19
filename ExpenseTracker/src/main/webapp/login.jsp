<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page session="true"%>
<%@ page import="java.sql.*"%>
<%@ page import="jakarta.servlet.http.HttpSession"%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Login - Expense Tracker</title>
<link rel="stylesheet" href="css/style.css">
</head>
<body>
	<div class="login-container">
	<h1>Expense Tracker</h1><br>
		<h2>Login</h2>

		<% 
            String errorMessage = (String) request.getAttribute("errorMessage");
            if (errorMessage != null) { 
        %>
		<p class="error-message"><%= errorMessage %></p>
		<% } %>

		<form action="login" method="post">
			<label for="email">Username:</label> <input type="text" id="email"
				name="email" required> <label for="password">Password:</label>
			<input type="password" id="password" name="password" required>

			<div class="checkbox-container">
				<input type="checkbox" id="rememberMe" name="rememberMe"> <label
					for="rememberMe">Remember Me</label>
			</div>

			<button type="submit">Login</button>
		</form>

		<div class="links">
			<a href="register.jsp">Register Now</a>
		</div>
	</div>
</body>
</html>
