<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Edit Income</title>
<!-- Link to Font Awesome CDN for icons -->
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">

<style>
/* Add the same styles as the Income List page */
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

input[type="text"], input[type="number"], input[type="date"], input[type="submit"]
	{
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
	<%@ include file="navbar.jsp"%>

	<h1>Edit Income</h1>

	<!-- Edit Income Form -->
	<form action="income" method="post">
		<input type="hidden" name="action" value="edit"> <input
			type="hidden" name="incomeId" value="${income.incomeId}"> <label>Source:</label>
		<input type="text" name="source" value="${income.source}" required><br>
		<label>Amount:</label> <input type="number" name="amount" step="0.01"
			value="${income.amount}" required><br> <label>Date:</label>
		<input type="date" name="incomeDate" value="${income.incomeDate}"
			required><br> <input type="submit" value="Update Income">
	</form>

	<%@ include file="footer.jsp"%>
</body>
</html>
