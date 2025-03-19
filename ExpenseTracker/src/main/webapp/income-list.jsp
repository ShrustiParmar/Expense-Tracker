<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<!-- Link to Font Awesome CDN for icons -->
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">

<title>Income List</title>
<style>
/* Basic styling */
body {
	font-family: Arial, sans-serif;
	background-color: #f4f4f9;
	margin: 0;
	padding: 0;
	display: flex;
	flex-direction: column;
	align-items: center;
	min-height: 100vh; /* Ensure body takes full height of viewport */
}

h1, h2, h3 {
	color: #333;
}

/* Form Styling */
form {
	margin: 20px 0;
	text-align: center;
}

input[type="text"], input[type="submit"] {
	padding: 8px;
	margin: 5px;
}

input[type="submit"] {
	background-color: #4CAF50;
	color: white;
	border: none;
	border-radius: 5px;
}

input[type="submit"]:hover {
	background-color: #45a049;
}

/* Table Styling */
table {
	width: 80%;
	border-collapse: collapse;
	margin-bottom: 20px;
}

th, td {
	padding: 12px 15px;
	text-align: left;
	border: 1px solid #ddd;
}

th {
	background-color: #4CAF50;
	color: white;
}

tr:nth-child(even) {
	background-color: #f2f2f2;
}

/* Pagination Styling */
.pagination {
	margin-top: 20px;
	margin-bottom: 20px;
	text-align: center;
}

.pagination a {
	padding: 5px 10px;
	margin: 5px 5px;
	background-color: #4CAF50;
	color: white;
	text-decoration: none;
	border-radius: 5px;
}

.pagination a:hover {
	background-color: #45a049;
}

/* Link styling */
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

th a {
	background-color: #4CAF50;
	color: white;
}

/* Active Page Styling */
.pagination a.active {
	background-color: #333;
	color: white;
	font-weight: bold;
}

/* Your existing styles */
.actions a {
	font-size: 18px;
	margin-right: 10px;
	color: #4CAF50;
	text-decoration: none;
}

.actions a:hover {
	color: #45a049;
}

button {
    background-color: #4CAF50;
    color: white;
    border: none;
    padding: 8px 16px;
    border-radius: 5px;
    cursor: pointer;
}

button:hover {
    background-color: #45a049;
}

</style>
</head>
<body>
	<%@ include file="navbar.jsp"%>

	<h1>Income List</h1>

	<!-- Filter Form -->
	<form method="get" action="income">
		<label for="filter">Filter by Source:</label> <input type="text"
			name="filter" value="${filter}">
		<button type="submit" title="Filter">
			<i class="fas fa-filter"></i>
			<!-- Filter Icon -->
		</button>
	</form>


	<!-- Income Table -->
	<table>
		<tr>
			<th><a href="income?sort=source&filter=${filter}">Source</a></th>
			<th><a href="income?sort=amount&filter=${filter}">Amount</a></th>
			<th><a href="income?sort=incomeDate&filter=${filter}">Date</a></th>
			<th>Actions</th>
		</tr>
		<c:forEach var="income" items="${incomes}">
			<tr>
				<td>${income.source}</td>
				<td>${income.amount}</td>
				<td>${income.incomeDate}</td>
				<td class="actions"><a
					href="income?action=edit&incomeId=${income.incomeId}"> <i
						class="fas fa-edit"></i> <!-- Edit icon -->
				</a> <a href="income?action=delete&incomeId=${income.incomeId}"
					onclick="return confirm('Are you sure?')"> <i
						class="fas fa-trash-alt"></i> <!-- Delete icon -->
				</a></td>
			</tr>
		</c:forEach>
	</table>

	<!-- Pagination -->
	<div class="pagination">
		<c:if test="${currentPage > 1}">
			<a href="income?page=${currentPage - 1}&filter=${filter}">Previous</a>
		</c:if>

		<c:forEach begin="1" end="${totalPages}" var="i">
			<a href="income?page=${i}&filter=${filter}"
				class="${i == currentPage ? 'active' : ''}">${i}</a>
		</c:forEach>

		<c:if test="${currentPage < totalPages}">
			<a href="income?page=${currentPage + 1}&filter=${filter}">Next</a>
		</c:if>
	</div>

	<!-- Add New Income Link -->
	<a href="add-income.jsp">Add New Income</a>

	<%@ include file="footer.jsp"%>

</body>
</html>
