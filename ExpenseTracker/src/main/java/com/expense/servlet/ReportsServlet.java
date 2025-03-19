package com.expense.servlet;

import com.expense.dao.ExpenseDAO;
import com.expense.dao.BudgetDAO;
import com.expense.model.Expense;
import com.expense.model.Budget;
import com.expense.model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.time.LocalDate;
import java.util.*;
import java.util.stream.Collectors;

public class ReportsServlet extends HttpServlet {

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// Get the logged-in user
		User user = (User) request.getSession().getAttribute("user");

		if (user == null) {
			response.sendRedirect("login.jsp");
			return;
		}

		ExpenseDAO expenseDAO = new ExpenseDAO();
		BudgetDAO budgetDAO = new BudgetDAO();
		List<Expense> expenses = expenseDAO.getExpensesByUser(user);
		List<Budget> budgets = budgetDAO.getBudgetsByUser(user);

		// Get month and year from request parameters
		String monthParam = request.getParameter("month");
		String yearParam = request.getParameter("year");
		int month = (monthParam != null) ? Integer.parseInt(monthParam)
				: Calendar.getInstance().get(Calendar.MONTH) + 1;
		int year = (yearParam != null) ? Integer.parseInt(yearParam) : Calendar.getInstance().get(Calendar.YEAR);

		// Filter expenses by the selected month and year
		List<Expense> filteredExpenses = expenses.stream().filter(expense -> isExpenseInMonth(expense, month, year))
				.collect(Collectors.toList());

		// Generate reports
		Map<String, Double> weeklyReport = generateExpenseReport(filteredExpenses, "weekly", month, year);
		Map<String, Double> monthlyReport = generateMonthlyReport(expenses, year);
		Map<String, Double> categoryBreakdown = generateCategoryBreakdown(filteredExpenses);

		// Set attributes for JSP
		request.setAttribute("weeklyReport", weeklyReport);
		request.setAttribute("monthlyReport", monthlyReport);
		request.setAttribute("categoryBreakdown", categoryBreakdown);
		request.setAttribute("budgets", budgets);
		request.setAttribute("selectedMonth", month);

		// Ensure the year is set from the request or default to the current year
		int selectedYear = (yearParam != null) ? year : LocalDate.now().getYear();

		System.out.println("Selected Year: " + selectedYear); // Add this to check if the value is correct
		request.setAttribute("selectedYear", selectedYear);

		// Calculate Expense vs Budget Table Data
		List<Map<String, Object>> expenseVsBudgetTable = new ArrayList<>();
		for (Budget budget : budgets) {
			String category = budget.getCategory().toString();
			double budgetAmount = budget.getMonthlyBudget();
			double totalExpenseForCategory = filteredExpenses.stream().filter(
					expense -> expense.getCategory() != null && expense.getCategory().toString().equals(category))
					.mapToDouble(Expense::getAmount).sum();

			Map<String, Object> data = new HashMap<>();
			data.put("category", category);
			data.put("budgetAmount", budgetAmount);
			data.put("totalExpense", totalExpenseForCategory);
			expenseVsBudgetTable.add(data);
		}

		// Pass the table data as an attribute to the JSP
		request.setAttribute("expenseVsBudgetTable", expenseVsBudgetTable);

		request.getRequestDispatcher("reports.jsp").forward(request, response);
	}

	private Map<String, Double> generateExpenseReport(List<Expense> expenses, String period, int month, int year) {
		Map<String, Double> report = new LinkedHashMap<>();
		double total = 0;

		if ("weekly".equals(period)) {
			int numOfWeeks = getWeeksInMonth(month, year);
			for (int week = 1; week <= numOfWeeks; week++) {
				final int currentWeek = week;
				double weeklyTotal = expenses.stream()
						.filter(expense -> isExpenseInWeek(expense, currentWeek, month, year))
						.mapToDouble(Expense::getAmount).sum();
				report.put("Week " + currentWeek, weeklyTotal);
				total += weeklyTotal;
			}
		}

		// Add total field
		report.put("Total", total);
		return report;
	}

	private boolean isExpenseInWeek(Expense expense, int week, int month, int year) {
		if (expense.getExpenseDate() == null)
			return false;
		Calendar cal = Calendar.getInstance();
		cal.setTime(expense.getExpenseDate());
		return cal.get(Calendar.WEEK_OF_MONTH) == week && cal.get(Calendar.MONTH) + 1 == month
				&& cal.get(Calendar.YEAR) == year;
	}

	private boolean isExpenseInMonth(Expense expense, int month, int year) {
		if (expense.getExpenseDate() == null)
			return false;
		Calendar cal = Calendar.getInstance();
		cal.setTime(expense.getExpenseDate());
		return cal.get(Calendar.MONTH) + 1 == month && cal.get(Calendar.YEAR) == year;
	}

	private int getWeeksInMonth(int month, int year) {
		Calendar calendar = Calendar.getInstance();
		calendar.set(year, month - 1, 1);
		return calendar.getActualMaximum(Calendar.WEEK_OF_MONTH);
	}

	private Map<String, Double> generateMonthlyReport(List<Expense> expenses, int year) {
		Map<String, Double> report = new LinkedHashMap<>();

		// Ensure all months are included even if there are no expenses
		String[] monthNames = { "January", "February", "March", "April", "May", "June", "July", "August", "September",
				"October", "November", "December" };

		for (String month : monthNames) {
			report.put(month, 0.0);
		}

		// Populate the report with actual expenses
		for (Expense expense : expenses) {
			if (expense.getExpenseDate() != null) {
				Calendar calendar = Calendar.getInstance();
				calendar.setTime(expense.getExpenseDate());
				String monthName = monthNames[calendar.get(Calendar.MONTH)];
				report.put(monthName, report.get(monthName) + expense.getAmount());
			}
		}

		// Add total field
		double total = report.values().stream().mapToDouble(Double::doubleValue).sum();
		report.put("Total", total);

		return report;
	}

	private String getMonthName(Date date) {
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(date);
		String[] monthNames = { "January", "February", "March", "April", "May", "June", "July", "August", "September",
				"October", "November", "December" };
		return monthNames[calendar.get(Calendar.MONTH)];
	}

	private Map<String, Double> generateCategoryBreakdown(List<Expense> expenses) {
		return expenses.stream().filter(expense -> expense.getCategory() != null).collect(
				Collectors.groupingBy(e -> e.getCategory().toString(), Collectors.summingDouble(Expense::getAmount)));
	}
}
