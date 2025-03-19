<%@ page contentType="text/html;charset=UTF-8" language="java"%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Footer</title>
<style>
.footer {
	background-color: #333;
	color: white;
	text-align: center;
	padding: 10px 0;
	position: relative;
	width: 100%;
	box-sizing: border-box;
	border-top: 1px solid #ccc;
    margin-top: auto; /* Push footer to the bottom */
}


.footer p {
	margin: 0;
	font-size: 14px;
}
</style>
</head>
<body>
	<footer class="footer" aria-label="Website Footer">
		<p>
			&copy; <span id="yearf"></span> Expense Tracker - by Kalwala
			Siddhartha Reddy, Sameeha Shaik, Urja Tej Behmat, Shrusti, Shreya
		</p>
	</footer>

	<script>
		// Get the current year dynamically
		document.getElementById("yearf").textContent = new Date().getFullYear();
	</script>
</body>
</html>
