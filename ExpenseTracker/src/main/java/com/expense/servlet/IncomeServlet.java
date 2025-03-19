package com.expense.servlet;

import com.expense.dao.IncomeDAO;
import com.expense.model.Income;
import com.expense.model.User;
import com.expense.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class IncomeServlet extends HttpServlet {
	private IncomeDAO incomeDAO = new IncomeDAO();

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String action = request.getParameter("action");

		if (action != null) {
			switch (action) {
			case "add":
				addIncome(request, response);
				break;
			case "edit":
				editIncome(request, response);
				break;
			case "delete":
				deleteIncome(request, response);
				break;
			}
		}
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String action = request.getParameter("action");
		if (action != null && action.equals("edit")) {
			getIncome(request, response);
		} else if (action != null && action.equals("delete")) {
			deleteIncome(request, response);
		} else {
			listIncome(request, response);
		}
	}

	private void addIncome(HttpServletRequest request, HttpServletResponse response) throws IOException {

		HttpSession session = request.getSession(false);

		if (session == null || session.getAttribute("user") == null) {
			response.sendRedirect("login.jsp");
			return;
		}

		User user = (User) session.getAttribute("user");
		int userId = user.getUserId();
		// int userId = Integer.parseInt(request.getParameter("userId"));

		String source = request.getParameter("source");
		double amount = Double.parseDouble(request.getParameter("amount"));
		String incomeDate = request.getParameter("incomeDate");

		Income income = new Income();
		income.setSource(source);
		income.setAmount(amount);
		income.setIncomeDate(java.sql.Date.valueOf(incomeDate));
		income.setUser(user);
		incomeDAO.addIncome(income);
		response.sendRedirect("income");
	}

	private void editIncome(HttpServletRequest request, HttpServletResponse response) throws IOException {
		int incomeId = Integer.parseInt(request.getParameter("incomeId"));
		String source = request.getParameter("source");
		double amount = Double.parseDouble(request.getParameter("amount"));
		String incomeDate = request.getParameter("incomeDate");

		Income income = incomeDAO.getIncomeById(incomeId);
		if (income != null) {
			income.setSource(source);
			income.setAmount(amount);
			income.setIncomeDate(java.sql.Date.valueOf(incomeDate));
			incomeDAO.updateIncome(income);
		}
		response.sendRedirect("income");
	}

	private void deleteIncome(HttpServletRequest request, HttpServletResponse response) throws IOException {
		String incomeIdStr = request.getParameter("incomeId");

		if (incomeIdStr != null) {
			try {
				int incomeId = Integer.parseInt(incomeIdStr);
				incomeDAO.deleteIncome(incomeId);
			} catch (NumberFormatException e) {
				e.printStackTrace();
			}
		} else {
			System.out.println("Income ID is null!");
		}

		response.sendRedirect("income");
	}

	private void getIncome(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		int incomeId = Integer.parseInt(request.getParameter("incomeId"));
		Income income = incomeDAO.getIncomeById(incomeId);
		request.setAttribute("income", income);
		request.getRequestDispatcher("edit-income.jsp").forward(request, response);
	}

	private void listIncome(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		HttpSession session = request.getSession(false);
		if (session == null || session.getAttribute("user") == null) {
			response.sendRedirect("login.jsp");
			return;
		}

		User user = (User) session.getAttribute("user");
		int userId = user.getUserId();

		// Get filter and sort parameters from the request
		String filter = request.getParameter("filter");
		String sort = request.getParameter("sort");
		int page = request.getParameter("page") != null ? Integer.parseInt(request.getParameter("page")) : 1;
		int pageSize = 5; // Define page size

		// Fetch filtered and sorted incomes
		List<Income> incomes = incomeDAO.getFilteredAndSortedIncomes(userId, filter, sort, page, pageSize);

		// Calculate total pages for pagination
		int totalRecords = incomeDAO.getTotalIncomeCount(userId, filter);
		int totalPages = (int) Math.ceil((double) totalRecords / pageSize);

		// Set attributes for the JSP page
		request.setAttribute("incomes", incomes);
		request.setAttribute("filter", filter); // Send the filter value back to the JSP
		request.setAttribute("currentPage", page);
		request.setAttribute("totalPages", totalPages);

		request.getRequestDispatcher("income-list.jsp").forward(request, response);
	}
}