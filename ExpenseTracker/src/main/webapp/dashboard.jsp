<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Dashboard</title>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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
}

h1, h2, h3 {
    color: #333;
}

/* Container for the dashboard summary */
.dashboard-summary {
    margin: 20px 0;
    text-align: center;
}

/* Table styling */
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

.btn {
    background-color: #4CAF50;
    color: white;
    padding: 10px 15px;
    text-decoration: none;
    border-radius: 5px;
    margin-top: 10px;
    display: inline-block;
}

.btn:hover {
    background-color: #45a049;
}

.filter-container {
    margin-bottom: 20px;
}

/* Chart container */
.chart-container {
    width: 80%;
    margin-bottom: 40px;
    text-align: center;
    display: flex;
    justify-content: space-around; /* Space the charts out */
    gap: 40px; /* Add space between charts */
    flex-wrap: wrap; /* Allow the charts to wrap on smaller screens */
}

.chart-box {
    width: 45%; /* Ensure both charts take up 45% of the width */
    max-width: 600px; /* Prevent charts from becoming too wide */
    text-align: center;
}

canvas {
    width: 400px !important;
    /* Make the canvas take up the full width of the container */
    height: 400px !important; /* Ensure equal height for both charts */
}

/* Responsive adjustment for smaller screens */
@media (max-width: 768px) {
    .chart-container {
        flex-direction: column; /* Stack charts vertically on smaller screens */
        align-items: center;
    }
    .chart-box {
        width: 80%; /* Increase width on smaller screens */
    }
}

/* Budget progress bar */
.progress-bar {
    width: 100%;
    background-color: #f3f3f3;
    border-radius: 5px;
    margin-bottom: 10px;
}

.progress {
    height: 20px;
    background-color: #4caf50;
    border-radius: 5px;
    text-align: center;
    line-height: 20px;
    color: white;
}

.warning {
    color: red;
    font-weight: bold;
}
</style>
</head>
<body>
    <%@ include file="navbar.jsp"%>
    <h1>Welcome, ${user.name}</h1>

    <div class="dashboard-summary">
        <h2>Total Income: $${totalIncome}</h2>
        <h2>Total Expenses: $${totalExpenses}</h2>
        <h2>Total Budget: $${totalBudget}</h2>
    </div>

    <!-- Display budget warnings -->
    <h3>Budget Warnings</h3>
    <c:forEach var="budget" items="${budgets}">
        <c:if test="${budget.spentAmount > budget.monthlyBudget}">
            <p class="warning">Warning: You have exceeded your budget for ${budget.category}!</p>
        </c:if>
    </c:forEach>

    <!-- Budget Progress Bars -->
    <h3>Budget Progress</h3>
    <c:forEach var="budget" items="${budgets}">
        <div>
            <strong>${budget.category}</strong>
            <div class="progress-bar">
                <div class="progress" style="width: ${(budget.spentAmount / budget.monthlyBudget) * 100}%">
                    $${budget.spentAmount} / $${budget.monthlyBudget}
                </div>
            </div>
        </div>
    </c:forEach>

    <!-- Income vs Expenses Pie Chart -->
    <div class="chart-container">
        <div class="chart-box">
            <h3>Income vs Expenses (Pie Chart)</h3>
            <canvas id="pieChart"></canvas>
        </div>

        <!-- Income vs Expenses Bar Chart -->
        <div class="chart-box">
            <h3>Income vs Expenses (Bar Chart)</h3>
            <canvas id="barChart"></canvas>
        </div>
    </div>

    <!-- Filtering Section -->
    <div class="filter-container">
        <label for="transactionFilter">Filter Transactions: </label> 
        <select id="transactionFilter" onchange="filterTransactions()">
            <option value="all">All</option>
            <option value="income">Income</option>
            <option value="expense">Expense</option>
        </select>
    </div>

    <h3>Transactions</h3>
    <table id="transactionsTable" border="1">
        <thead>
            <tr>
                <th>Category</th>
                <th>Amount</th>
                <th>Date</th>
                <th>Notes</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="transaction" items="${transactions}">
                <c:if test="${transaction.type == 'expense'}">
                    <tr class="expense-row">
                        <td>${transaction.transaction.category}</td>
                        <td style="color: red;">-${transaction.transaction.amount}</td>
                        <td>${transaction.transaction.expenseDate}</td>
                        <td>${transaction.transaction.notes}</td>
                    </tr>
                </c:if>
                <c:if test="${transaction.type == 'income'}">
                    <tr class="income-row">
                        <td>${transaction.transaction.source}</td>
                        <td style="color: green;">+${transaction.transaction.amount}</td>
                        <td>${transaction.transaction.incomeDate}</td>
                        <td>N/A</td>
                    </tr>
                </c:if>
            </c:forEach>
        </tbody>
    </table>

    <h3>Budgets</h3>
    <table border="1">
        <thead>
            <tr>
                <th>Category</th>
                <th>Monthly Budget</th>
                <th>Spent Amount</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="budget" items="${budgets}">
                <tr>
                    <td>${budget.category}</td>
                    <td>${budget.monthlyBudget}</td>
                    <td>${budget.spentAmount}</td>
                </tr>
            </c:forEach>
        </tbody>
    </table>

    <!-- Add Budget Button -->
    <a href="set-budget.jsp" class="btn">Set Budget</a>

    <%@ include file="footer.jsp"%>
    <script>
        // Data for the charts
        const income = ${totalIncome};
        const expenses = ${totalExpenses};

        // Pie Chart
        const ctxPie = document.getElementById('pieChart').getContext('2d');
        const pieChart = new Chart(ctxPie, {
            type: 'pie',
            data: {
                labels: ['Income', 'Expenses'],
                datasets: [{
                    data: [income, expenses],
                    backgroundColor: ['#4CAF50', '#FF6347'], // Green for income, Red for expenses
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: {
                        position: 'top',
                    },
                    tooltip: {
                        callbacks: {
                            label: function(tooltipItem) {
                                return tooltipItem.label + ': $' + tooltipItem.raw.toFixed(2);
                            }
                        }
                    }
                }
            }
        });

        // Bar Chart
        const ctxBar = document.getElementById('barChart').getContext('2d');
        const barChart = new Chart(ctxBar, {
            type: 'bar',
            data: {
                labels: ['Income', 'Expenses'],
                datasets: [{
                    label: 'Amount',
                    data: [income, expenses],
                    backgroundColor: ['#4CAF50', '#FF6347'], // Green for income, Red for expenses
                    borderColor: ['#388E3C', '#D32F2F'], // Darker shades for borders
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                scales: {
                    y: {
                        beginAtZero: true
                    }
                },
                plugins: {
                    tooltip: {
                        callbacks: {
                            label: function(tooltipItem) {
                                return tooltipItem.label + ': $' + tooltipItem.raw.toFixed(2);
                            }
                        }
                    }
                }
            }
        });

        // Function to filter transactions
        function filterTransactions() {
            const filterValue = document.getElementById('transactionFilter').value;
            const allRows = document.querySelectorAll('#transactionsTable tbody tr');

            allRows.forEach(row => {
                if (filterValue === 'all') {
                    row.style.display = '';
                } else if (filterValue === 'income' && row.classList.contains('income-row')) {
                    row.style.display = '';
                } else if (filterValue === 'expense' && row.classList.contains('expense-row')) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
        }
    </script>
</body>
</html>