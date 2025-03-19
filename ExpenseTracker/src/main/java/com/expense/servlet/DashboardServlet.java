package com.expense.servlet;

import com.expense.dao.BudgetDAO;
import com.expense.dao.ExpenseDAO;
import com.expense.dao.IncomeDAO;
import com.expense.model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.*;

public class DashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");

        // Fetch the user's income, expenses, and budgets
        IncomeDAO incomeDAO = new IncomeDAO();
        ExpenseDAO expenseDAO = new ExpenseDAO();
        BudgetDAO budgetDAO = new BudgetDAO();

        List<Income> incomes = incomeDAO.getIncomesByUser(user);
        List<Expense> expenses = expenseDAO.getExpensesByUser(user);
        List<Budget> budgets = budgetDAO.getBudgetsByUser(user);

        double totalIncome = incomes.stream().mapToDouble(Income::getAmount).sum();
        double totalExpenses = expenses.stream().mapToDouble(Expense::getAmount).sum();
        double totalBudget = budgets.stream().mapToDouble(Budget::getMonthlyBudget).sum();

        // Check if expenses exceed the budget for each category
        Map<Category, Boolean> budgetExceededMap = new HashMap<>();
        for (Budget budget : budgets) {
            double totalExpensesForCategory = expenses.stream()
                    .filter(expense -> expense.getCategory() == budget.getCategory())
                    .mapToDouble(Expense::getAmount)
                    .sum();
            budgetExceededMap.put(budget.getCategory(), totalExpensesForCategory > budget.getMonthlyBudget());
        }

        // Set attributes for the JSP
        request.setAttribute("totalIncome", totalIncome);
        request.setAttribute("totalExpenses", totalExpenses);
        request.setAttribute("totalBudget", totalBudget);
        request.setAttribute("budgetExceededMap", budgetExceededMap);
        request.setAttribute("budgets", budgets);

        // Forward to dashboard.jsp
        request.getRequestDispatcher("dashboard.jsp").forward(request, response);
    }
}