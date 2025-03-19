package com.expense.servlet;

import java.io.IOException;
import com.expense.dao.UserDAO;
import com.expense.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class LoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String email = request.getParameter("email");
		String password = request.getParameter("password");

		UserDAO userDAO = new UserDAO();
		User user = userDAO.validateUser(email, password);

		if (user != null) {
			HttpSession session = request.getSession();
			session.setAttribute("user", user);

			response.sendRedirect("dashboard");
		} else {
			request.setAttribute("errorMessage", "Invalid email or password!");
			request.getRequestDispatcher("login.jsp").forward(request, response);
		}
	}
}
