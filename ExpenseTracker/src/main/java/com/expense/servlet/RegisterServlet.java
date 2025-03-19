package com.expense.servlet;

import com.expense.dao.UserDAO;
import com.expense.model.User;
import com.expense.util.HibernateUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;

public class RegisterServlet extends HttpServlet {
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// Simply forward to the register.jsp page when the user visits the register
		// URL.
		request.getRequestDispatcher("/register.jsp").forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// Retrieve form data
		String fullName = request.getParameter("fullName");
		String email = request.getParameter("email");
		String password = request.getParameter("password");
		String confirmPassword = request.getParameter("confirmPassword");

		// Check if passwords match
		if (!password.equals(confirmPassword)) {
			request.setAttribute("errorMessage", "Passwords do not match.");
			request.getRequestDispatcher("/register.jsp").forward(request, response);
			return;
		}

		if (!isValidPassword(password)) {
			request.setAttribute("errorMessage",
					"Password must be at least 8 characters long, contain one uppercase letter, and one number.");
			request.getRequestDispatcher("/register.jsp").forward(request, response);
			return;
		}

		// Hash the password using BCrypt
		String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

		// Save user to the database
		User user = new User();
		user.setName(fullName);
		user.setUsername(email); // Using email as username
		user.setPassword(hashedPassword);

		UserDAO userDAO = new UserDAO();
		boolean isRegistered = userDAO.registerUser(user); // Implement this method in your DAO

		if (isRegistered) {
			request.setAttribute("successMessage", "Registration successful. Please login.");
			request.getRequestDispatcher("/login.jsp").forward(request, response);
		} else {
			request.setAttribute("errorMessage", "An error occurred. Please try again.");
			request.getRequestDispatcher("/register.jsp").forward(request, response);
		}
	}

	private boolean isValidEmail(String email) {
		// Basic email validation regex
		return email.matches("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,6}$");
	}

	private boolean isValidPassword(String password) {
		// Password validation (at least 8 characters, 1 uppercase, 1 number)
		return password.matches("^(?=.*[A-Z])(?=.*\\d).{8,}$");
	}
}
