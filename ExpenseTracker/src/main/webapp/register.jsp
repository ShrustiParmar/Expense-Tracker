<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page session="true"%>
<%@ page import="java.util.regex.*"%>

<%
    String errorMessage = (String) request.getAttribute("errorMessage");
    String successMessage = (String) request.getAttribute("successMessage");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Register - Expense Tracker</title>
<link rel="stylesheet" href="css/style.css">
<script>
        function validateForm() {
            let email = document.getElementById('email').value;
            let password = document.getElementById('password').value;
            let confirmPassword = document.getElementById('confirmPassword').value;



            // Password strength validation (at least 8 characters, 1 uppercase, 1 number)
            let passwordPattern = /^(?=.*[A-Z])(?=.*\d).{8,}$/;
            if (!passwordPattern.test(password)) {
                alert("Password must be at least 8 characters long, contain at least one uppercase letter and one number.");
                return false;
            }

            // Confirm password validation
            if (password !== confirmPassword) {
                alert("Passwords do not match.");
                return false;
            }

            return true;
        }
    </script>
</head>
<body>
	<div class="register-container">
	
		<h2>Register</h2>

		<% if (errorMessage != null) { %>
		<p class="error-message"><%= errorMessage %></p>
		<% } %>

		<% if (successMessage != null) { %>
		<p class="success-message"><%= successMessage %></p>
		<% } %>

		<form action="register" method="post" onsubmit="return validateForm()">
			<label for="fullName">Full Name:</label> <input type="text"
				id="fullName" name="fullName" required> <label for="email">Username:</label>
			<input type="text" id="email" name="email" required> <label
				for="password">Password:</label> <input type="password"
				id="password" name="password" required> <label
				for="confirmPassword">Confirm Password:</label> <input
				type="password" id="confirmPassword" name="confirmPassword" required>

			<button type="submit">Register</button>
		</form>

		<div class="links">
			<a href="login.jsp">Already have an account? Login</a>
		</div>
	</div>
</body>
</html>
