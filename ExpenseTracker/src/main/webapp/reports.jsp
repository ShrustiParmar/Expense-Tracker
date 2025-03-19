<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Expense Reports</title>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<style>
/* General styling */
body {
	font-family: 'Arial', sans-serif;
	background-color: #f4f7fc;
	color: #333;
	margin: 0;
	padding: 0;
	display: flex;
	flex-direction: column;
	align-items: center;
	justify-content: flex-start;
	min-height: 100vh;
}

/* Heading styling */
h1 {
	font-size: 36px;
	font-weight: 700;
	color: #0056b3;
	margin-bottom: 20px;
	text-align: center;
	padding: 20px;
	border-bottom: 3px solid #0056b3;
	width: 100%;
	background-color: #f8f9fa;
}

/* Form and filters styling */
.report-section {
	background-color: #ffffff;
	width: 90%;
	max-width: 1000px;
	padding: 25px;
	border-radius: 8px;
	box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
	margin-bottom: 40px;
	text-align: center;
}

form {
	display: flex;
	align-items: center;
	justify-content: center;
	gap: 20px;
	margin-bottom: 30px;
	flex-wrap: wrap;
}

label {
	font-size: 16px;
	font-weight: 600;
}

select, button {
	font-size: 16px;
	padding: 12px;
	border-radius: 5px;
	border: 1px solid #ccc;
	width: 180px;
	transition: all 0.3s ease;
}

select:focus, button:focus {
	outline: none;
	border-color: #0056b3;
}

button {
	background-color: #007bff;
	color: white;
	cursor: pointer;
}

button:hover {
	background-color: #0056b3;
}

/* Table Styling */
table {
	width: 100%;
	border-collapse: collapse;
	margin-top: 30px;
	background-color: #fff;
	box-shadow: 0 4px 8px rgba(0, 0, 0, 0.05);
}

th, td {
	padding: 14px 20px;
	text-align: center;
	font-size: 16px;
}

th {
	background-color: #f2f2f2;
	color: #333;
}

td {
	color: #555;
}

/* Table row highlighting */
tr.total-row {
	background-color: #ffeeba;
	font-weight: bold;
}

/* Color coding for percentage columns */
.percentage-low {
	color: green;
	font-weight: bold;
}

.percentage-medium {
	color: orange;
	font-weight: bold;
}

.percentage-high {
	color: red;
	font-weight: bold;
}

/* Enhancing table borders */
table, th, td {
	border: 1px solid #ddd;
	border-radius: 5px;
}

/* Adding chart container with padding and border radius */
.report-section canvas {
	max-width: 100%;
	border-radius: 8px;
	margin-top: 20px;
}

/* Responsive adjustments */
@media ( max-width : 768px) {
	body {
		padding: 20px;
	}
	form {
		flex-direction: column;
	}
	select, button {
		width: 100%;
		margin-bottom: 15px;
	}
	table {
		font-size: 14px;
	}
	h1 {
		font-size: 30px;
	}
}

@media ( max-width : 480px) {
	h1 {
		font-size: 24px;
	}
	table {
		font-size: 12px;
	}
}
</style>
</head>
<body>
	<%@ include file="navbar.jsp"%>
	<h1>Expense Reports</h1>

	<!-- Select Month and Year for the Report -->
	<div class="report-section">
		<form method="get" action="reports">
			<label for="month">Month:</label> <select name="month" id="month">
				<option value="1" ${selectedMonth == 1 ? 'selected' : ''}>January</option>
				<option value="2" ${selectedMonth == 2 ? 'selected' : ''}>February</option>
				<option value="3" ${selectedMonth == 3 ? 'selected' : ''}>March</option>
				<option value="4" ${selectedMonth == 4 ? 'selected' : ''}>April</option>
				<option value="5" ${selectedMonth == 5 ? 'selected' : ''}>May</option>
				<option value="6" ${selectedMonth == 6 ? 'selected' : ''}>June</option>
				<option value="7" ${selectedMonth == 7 ? 'selected' : ''}>July</option>
				<option value="8" ${selectedMonth == 8 ? 'selected' : ''}>August</option>
				<option value="9" ${selectedMonth == 9 ? 'selected' : ''}>September</option>
				<option value="10" ${selectedMonth == 10 ? 'selected' : ''}>October</option>
				<option value="11" ${selectedMonth == 11 ? 'selected' : ''}>November</option>
				<option value="12" ${selectedMonth == 12 ? 'selected' : ''}>December</option>
			</select> <label for="year">Year:</label> <select name="year" id="year">
				<c:forEach var="yearValue" begin="${selectedYear - 1}"
					end="${selectedYear + 1}" step="1">
					<option value="${yearValue}"
						${selectedYear == yearValue ? 'selected' : ''}>${yearValue}</option>
				</c:forEach>
			</select>


			<button type="submit">Generate Report</button>
		</form>
	</div>

	<!-- Weekly Expense Report -->
	<div class="report-section">
		<h2>Weekly Expense Report</h2>
		<table>
			<thead>
				<tr>
					<th>Week</th>
					<th>Amount</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="week" items="${weeklyReport}">
					<tr
						<c:if test="${week.key == 'Total'}">style="font-weight: bold;"</c:if>>
						<td>${week.key}</td>
						<td>$${week.value}</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>

	</div>

	<!-- Monthly Expense Report -->
	<div class="report-section">
		<h2>Monthly Expense Report</h2>
		<table>
			<thead>
				<tr>
					<th>Month</th>
					<th>Amount</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="month" items="${monthlyReport}">
					<tr
						<c:if test="${month.key == 'Total'}">style="font-weight: bold;"</c:if>>
						<td>${month.key}</td>
						<td>$${month.value}</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>

	</div>

	<!-- Category Breakdown -->
	<div class="report-section">
		<h2>Category Breakdown</h2>
		<table>
			<thead>
				<tr>
					<th>Category</th>
					<th>Amount</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="category" items="${categoryBreakdown}">
					<tr>
						<td>${category.key}</td>
						<td>$${category.value}</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
	</div>

	<!-- Expense vs Budget Comparison Table -->
	<div class="report-section">
		<h2>Expense vs Budget</h2>
		<table>
			<thead>
				<tr>
					<th>Category</th>
					<th>Monthly Budget Limit</th>
					<th>Expenses for the Month</th>
					<th>Percentage</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="data" items="${expenseVsBudgetTable}">
					<tr class="${data.category == 'Total' ? 'total-row' : ''}">
						<td>${data.category}</td>
						<td>$${data.budgetAmount}</td>
						<td>$${data.totalExpense}</td>
						<td><span
							class="
                                <c:choose>
                                    <c:when test="${(data.totalExpense / data.budgetAmount) * 100 < 50}">percentage-low</c:when>
                                    <c:when test="${(data.totalExpense / data.budgetAmount) * 100 >= 50 and (data.totalExpense / data.budgetAmount) * 100 < 100}">percentage-medium</c:when>
                                    <c:when test="${(data.totalExpense / data.budgetAmount) * 100 >= 100}">percentage-high</c:when>
                                </c:choose>
                            ">
								${(data.totalExpense / data.budgetAmount) * 100}% </span></td>
					</tr>
				</c:forEach>
			</tbody>
		</table>


	</div>
	<%@ include file="footer.jsp"%>
</body>
</html>