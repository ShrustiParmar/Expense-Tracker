package com.expense.servlet;

import com.expense.dao.BudgetDAO;
import com.expense.model.Budget;
import com.expense.model.User;
import com.expense.model.Category;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

//@WebServlet("/budget")
public class BudgetServlet extends HttpServlet {
    private BudgetDAO budgetDAO;

    @Override
    public void init() throws ServletException {
        budgetDAO = new BudgetDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        // Check if the user is logged in
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");

        // Get form data
        String category = request.getParameter("category");
        double monthlyBudget = Double.parseDouble(request.getParameter("monthlyBudget"));

        // Create a new Budget object
        Budget budget = new Budget();
        budget.setUser(user);
        budget.setCategory(Category.valueOf(category));
        budget.setMonthlyBudget(monthlyBudget);

        // Add the budget to the database
        if (budgetDAO.addBudget(budget)) {
            session.setAttribute("message", "Budget added successfully!");
        } else {
            session.setAttribute("error", "Failed to add budget. Please try again.");
        }

        // Redirect to the dashboard
        response.sendRedirect("dashboard");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        // Check if the user is logged in
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");

        // Fetch all budgets for the user
        List<Budget> budgets = budgetDAO.getBudgetsByUser(user);

        // Calculate total budget
        double totalBudget = budgets.stream().mapToDouble(Budget::getMonthlyBudget).sum();

        // Set attributes for the JSP page
        request.setAttribute("budgets", budgets);
        request.setAttribute("totalBudget", totalBudget);

        // Forward to the dashboard JSP
        request.getRequestDispatcher("dashboard.jsp").forward(request, response);
    }
}