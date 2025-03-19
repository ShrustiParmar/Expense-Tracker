<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Expense</title>
    <!-- Link to Font Awesome CDN for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        /* General Page Styling */
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f9;
            margin: 0;
            padding: 0;
            display: flex;
            flex-direction: column;
            align-items: center;
            min-height: 100vh;
        }

        h1, h2, h3 {
            color: #333;
        }

        /* Form Styling */
        form {
            margin: 20px 0;
            text-align: center;
        }

        input[type="text"], input[type="number"], input[type="date"], select, textarea {
            padding: 8px;
            margin: 5px;
            width: 100%;
            border: 1px solid #ccc;
            border-radius: 5px;
        }

        input[type="submit"] {
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 5px;
            padding: 10px 20px;
            cursor: pointer;
        }

        input[type="submit"]:hover {
            background-color: #45a049;
        }

        /* Link Styling */
        a {
            color: #4CAF50;
            text-decoration: none;
            padding: 5px 10px;
            border-radius: 5px;
        }

        a:hover {
            background-color: #4CAF50;
            color: white;
        }
    </style>
</head>
<body>
    <%@ include file="navbar.jsp" %>

    <h1>Edit Expense</h1>

    <!-- Edit Expense Form -->
    <form action="expenses" method="post">
        <input type="hidden" name="action" value="edit">
        <input type="hidden" name="expense_id" value="${expense.expenseId}">
        
        <label>Amount:</label>
        <input type="number" name="amount" step="0.01" value="${expense.amount}" required><br>
        
        <label>Category:</label>
        <select name="category">
            <option value="Food" <c:if test="${expense.category == 'Food'}">selected</c:if>>Food</option>
            <option value="Transport" <c:if test="${expense.category == 'Transport'}">selected</c:if>>Transport</option>
            <option value="Entertainment" <c:if test="${expense.category == 'Entertainment'}">selected</c:if>>Entertainment</option>
            <option value="Others" <c:if test="${expense.category == 'Others'}">selected</c:if>>Others</option>
        </select><br>
        
        <label>Date:</label>
        <input type="date" name="expense_date" value="${expense.expenseDate}" required><br>
        
        <label>Notes:</label>
        <textarea name="notes">${expense.notes}</textarea><br>
        
        <input type="submit" value="Update Expense">
    </form>

    <%@ include file="footer.jsp" %>
</body>
</html>