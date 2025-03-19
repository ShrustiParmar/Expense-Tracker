<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Expense List</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f9;
            margin: 0;
            padding: 20px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }
        th, td {
            padding: 12px;
            border: 1px solid #ddd;
            text-align: left;
        }
        th {
            background-color: #4CAF50;
            color: white;
        }
        tr:nth-child(even) {
            background-color: #f2f2f2;
        }
        .pagination {
            display: flex;
            justify-content: center;
            margin-top: 20px;
        }
        .pagination a {
            padding: 8px 16px;
            text-decoration: none;
            border: 1px solid #ddd;
            color: #333;
            margin: 0 4px;
        }
        .pagination a.active {
            background-color: #4CAF50;
            color: white;
            border: 1px solid #4CAF50;
        }
        .pagination a:hover:not(.active) {
            background-color: #ddd;
        }
        .filter-container {
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <h1>Expense List</h1>

    <!-- Filter and Sort Form -->
    <div class="filter-container">
        <form action="expenses" method="get">
            <label for="filter">Filter by Category:</label>
            <select id="filter" name="filter">
                <option value="">All</option>
                <option value="Food">Food</option>
                <option value="Transport">Transport</option>
                <option value="Entertainment">Entertainment</option>
                <option value="Others">Others</option>
            </select>

            <label for="sort">Sort by:</label>
            <select id="sort" name="sort">
                <option value="">None</option>
                <option value="amount">Amount</option>
                <option value="expenseDate">Date</option>
            </select>

            <input type="hidden" name="action" value="list">
            <button type="submit">Apply</button>
        </form>
    </div>

    <!-- Expense Table -->
    <table>
        <thead>
            <tr>
                <th>Category</th>
                <th>Amount</th>
                <th>Date</th>
                <th>Notes</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="expense" items="${expenses}">
                <tr>
                    <td>${expense.category}</td>
                    <td>${expense.amount}</td>
                    <td>${expense.expenseDate}</td>
                    <td>${expense.notes}</td>
                    <td>
                        <a href="expenses?action=edit&expense_id=${expense.expenseId}">Edit</a>
                        <a href="expenses?action=delete&expense_id=${expense.expenseId}">Delete</a>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>

    <!-- Pagination -->
    <div class="pagination">
        <c:if test="${currentPage > 1}">
            <a href="expenses?action=list&page=${currentPage - 1}&filter=${filter}&sort=${sort}">Previous</a>
        </c:if>

        <c:forEach begin="1" end="${totalPages}" var="i">
            <c:choose>
                <c:when test="${currentPage == i}">
                    <a class="active">${i}</a>
                </c:when>
                <c:otherwise>
                    <a href="expenses?action=list&page=${i}&filter=${filter}&sort=${sort}">${i}</a>
                </c:otherwise>
            </c:choose>
        </c:forEach>

        <c:if test="${currentPage < totalPages}">
            <a href="expenses?action=list&page=${currentPage + 1}&filter=${filter}&sort=${sort}">Next</a>
        </c:if>
    </div>

    <!-- Add Expense Button -->
    <a href="add-expense.jsp">Add New Expense</a>
    
    
        <a href="dashboard.jsp">Back to Dashboard</a>
</body>
</html>