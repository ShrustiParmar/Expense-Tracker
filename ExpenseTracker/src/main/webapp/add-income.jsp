<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add Expense</title>
    <style>
        /* Add your CSS styles here */
        form {
            max-width: 400px;
            margin: 0 auto;
        }
        label {
            display: block;
            margin-top: 10px;
        }
        input, select {
            width: 100%;
            padding: 8px;
            margin-top: 5px;
        }
        button {
            margin-top: 20px;
            padding: 10px 20px;
            background-color: #4CAF50;
            color: white;
            border: none;
            cursor: pointer;
        }
        button:hover {
            background-color: #45a049;
        }
    </style>
</head>
<body>
    <h1>Add Expense</h1>

    <form action="expenses" method="post">
        <input type="hidden" name="action" value="add">

        <label for="amount">Amount:</label>
        <input type="number" id="amount" name="amount" step="0.01" required>

        <label for="category">Category:</label>
        <select id="category" name="category" required>
            <option value="FOOD">Food</option>
            <option value="TRANSPORT">Transport</option>
            <option value="ENTERTAINMENT">Entertainment</option>
            <option value="OTHERS">Others</option>
        </select>

        <label for="expense_date">Date:</label>
        <input type="date" id="expense_date" name="expense_date" required>

        <label for="notes">Notes:</label>
        <input type="text" id="notes" name="notes">

        <button type="submit">Add Expense</button>
    </form>

    <c:if test="${not empty error}">
        <p style="color: red;">${error}</p>
    </c:if>
</body>
</html>