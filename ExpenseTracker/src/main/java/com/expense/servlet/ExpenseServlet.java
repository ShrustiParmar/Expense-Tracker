package com.expense.servlet;

import com.expense.dao.ExpenseDAO;
import com.expense.model.Expense;
import com.expense.model.User;
import com.expense.model.Category;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.util.List;

//@WebServlet("/expenses")
public class ExpenseServlet extends HttpServlet {
    private ExpenseDAO expenseDAO;

    @Override
    public void init() throws ServletException {
        expenseDAO = new ExpenseDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if (action != null) {
            switch (action) {
                case "add":
                    addExpense(request, response);
                    break;
                case "edit":
                    editExpense(request, response);
                    break;
                case "delete":
                    deleteExpense(request, response);
                    break;
                default:
                    response.sendRedirect("error.jsp?message=Invalid Action");
                    break;
            }
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if (action != null) {
            switch (action) {
                case "edit":
                    int expenseId = Integer.parseInt(request.getParameter("expense_id"));
                    Expense expense = expenseDAO.getExpenseById(expenseId);
                    request.setAttribute("expense", expense);
                    request.getRequestDispatcher("edit-expense.jsp").forward(request, response);
                    break;
                case "delete":
                    deleteExpense(request, response);
                    break;
                case "list":
                default:
                    listExpenses(request, response);
                    break;
            }
        } else {
            listExpenses(request, response);
        }
    }

    private void addExpense(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");

        try {
            double amount = Double.parseDouble(request.getParameter("amount"));
            Category category = Category.valueOf(request.getParameter("category"));
            Date expenseDate = Date.valueOf(request.getParameter("expense_date"));
            String notes = request.getParameter("notes");

            Expense expense = new Expense();
            expense.setAmount(amount);
            expense.setCategory(category);
            expense.setExpenseDate(expenseDate);
            expense.setNotes(notes);
            expense.setUser(user);

            expenseDAO.addExpense(expense);
            response.sendRedirect("expenses?action=list");
        } catch (Exception e) {
            request.setAttribute("error", "Invalid input. Please check your entries.");
            request.getRequestDispatcher("add-expense.jsp").forward(request, response);
        }
    }

    private void editExpense(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int expenseId = Integer.parseInt(request.getParameter("expense_id"));
            double amount = Double.parseDouble(request.getParameter("amount"));
            Category category = Category.valueOf(request.getParameter("category"));
            Date expenseDate = Date.valueOf(request.getParameter("expense_date"));
            String notes = request.getParameter("notes");

            Expense expense = new Expense();
            expense.setExpenseId(expenseId);
            expense.setAmount(amount);
            expense.setCategory(category);
            expense.setExpenseDate(expenseDate);
            expense.setNotes(notes);

            expenseDAO.updateExpense(expense);
            response.sendRedirect("expenses?action=list");
        } catch (Exception e) {
            request.setAttribute("error", "Invalid input. Please check your entries.");
            request.getRequestDispatcher("edit-expense.jsp").forward(request, response);
        }
    }

    private void deleteExpense(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int expenseId = Integer.parseInt(request.getParameter("expense_id"));
            expenseDAO.deleteExpense(expenseId);
        } catch (NumberFormatException e) {
            response.sendRedirect("error.jsp?message=Invalid Expense ID");
        }
        response.sendRedirect("expenses?action=list");
    }

    private void listExpenses(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");

        // Get filter and sort parameters from the request
        String filter = request.getParameter("filter");
        String sort = request.getParameter("sort");
        int page = request.getParameter("page") != null ? Integer.parseInt(request.getParameter("page")) : 1;
        int pageSize = 5; // Define page size

        // Fetch filtered and sorted expenses
        List<Expense> expenses = expenseDAO.getFilteredAndSortedExpenses(user.getUserId(), filter, sort, page, pageSize);

        // Calculate total pages for pagination
        int totalRecords = expenseDAO.getTotalExpenseCount(user.getUserId(), filter);
        int totalPages = (int) Math.ceil((double) totalRecords / pageSize);

        // Set attributes for the JSP page
        request.setAttribute("expenses", expenses);
        request.setAttribute("filter", filter);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);

        request.getRequestDispatcher("list-expenses.jsp").forward(request, response);
    }
}