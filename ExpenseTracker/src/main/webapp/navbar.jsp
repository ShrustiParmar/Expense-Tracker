<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page session="true"%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Navigation Bar</title>
<style>
.navbar {
	background-color: #333;
	padding: 10px 20px;
	color: white;
	display: flex;
	justify-content: space-between;
	align-items: center;
	width: 100%;
	position: relative;
	box-sizing: border-box;
}

body {
	margin: 0;
	padding-top: 0;
}

.nav-links {
	list-style: none;
	display: flex;
	gap: 20px;
	margin: 0;
}

.nav-links li {
	display: inline;
}

.nav-links a {
	color: white;
	text-decoration: none;
	font-size: 16px;
	transition: color 0.3s ease;
}

.nav-links a:hover {
	color: #4CAF50;
}

.nav-right {
	display: flex;
	align-items: center;
}

.nav-right a {
	color: white;
	text-decoration: none;
	font-size: 16px;
	transition: color 0.3s ease;
}

.nav-right a:hover {
	color: #4CAF50;
}

@media screen and (max-width: 768px) {
	.navbar {
		flex-direction: column;
		align-items: flex-start;
		padding: 15px 10px;
	}
	.nav-links {
		flex-direction: column;
		gap: 10px;
		width: 100%;
		padding-left: 0;
	}
	.nav-links a {
		padding: 10px 20px;
		width: 100%;
		text-align: left;
	}
	.nav-right {
		margin-top: 10px;
	}
}
</style>
</head>
<body>
	<nav class="navbar">
		<ul class="nav-links">
			<li><a href="dashboard">Dashboard</a></li>
			<li><a href="expenses">Expenses</a></li>
			<li><a href="budget">Set Budget</a></li>
			<li><a href="income">Income</a></li>
			<li><a href="reports">Reports</a></li>
		</ul>
		<div class="nav-right">
			<a href="logout">Logout</a>
		</div>
	</nav>
</body>
</html>
