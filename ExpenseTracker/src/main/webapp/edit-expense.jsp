<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Edit Expense</title>
    <style type="text/css">
    /* General Page Styling */
body {
    font-family: Arial, sans-serif;
    background-color: #f4f4f9;
    margin: 0;
    padding: 0;
    display: flex;
    flex-direction: column;
    align-items: center;
}

h2 {
    color: #333;
    margin-top: 20px;
}

/* Form Styling */
form {
    background: white;
    padding: 20px;
    border-radius: 8px;
    box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
    display: flex;
    flex-direction: column;
    width: 300px;
}

label {
    font-weight: bold;
    margin-top: 10px;
    color: #333;
}

input, select, textarea {
    width: 100%;
    padding: 8px;
    margin-top: 5px;
    border: 1px solid #ccc;
    border-radius: 5px;
}

/* Submit Button Styling */
button {
    background-color: #4CAF50;
    color: white;
    padding: 10px;
    border: none;
    border-radius: 5px;
    cursor: pointer;
    margin-top: 15px;
}

button:hover {
    background-color: #45a049;
}

/* Responsive Design */
@media (max-width: 768px) {
    form {
        width: 80%;
    }
}
    </style>
</head>
<body>
    <h2>Edit Expense</h2>
    <form action="ExpenseServlet" method="post">
        <input type="hidden" name="action" value="edit">
        <input type="hidden" name="expense_id" value="${expense.expenseId}">
        <label>Amount:</label>
        <input type="text" name="amount" value="${expense.amount}" required>
        <label>Category:</label>
        <select name="category">
            <option value="Food" <c:if test="${expense.category == 'Food'}">selected</c:if>>Food</option>
            <option value="Transport" <c:if test="${expense.category == 'Transport'}">selected</c:if>>Transport</option>
            <option value="Entertainment" <c:if test="${expense.category == 'Entertainment'}">selected</c:if>>Entertainment</option>
            <option value="Others" <c:if test="${expense.category == 'Others'}">selected</c:if>>Others</option>
        </select>
        <label>Date:</label>
        <input type="date" name="expense_date" value="${expense.expenseDate}" required>
        <label>Notes:</label>
        <textarea name="notes">${expense.notes}</textarea>
        <button type="submit">Update Expense</button>
    </form>
</body>
</html>
