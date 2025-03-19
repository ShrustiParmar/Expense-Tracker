<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Error</title>
<style>
    /* Basic reset */
    body, html {
        margin: 0;
        padding: 0;
        height: 100%;
    }

    /* Flexbox layout to make the footer stick to the bottom */
    body {
        display: flex;
        flex-direction: column;
        justify-content: space-between;
        min-height: 100vh;
        font-family: Arial, sans-serif;
    }

    /* Content section styles */
    .content {
        flex-grow: 1;
        padding: 20px;
        text-align: center;
    }

    h1 {
        color: #e74c3c;
    }

    h2 {
        color: #555;
    }

    p {
        font-size: 16px;
    }

    a {
        color: #3498db;
        text-decoration: none;
        font-weight: bold;
    }

    a:hover {
        text-decoration: underline;
    }

    /* Footer styles */
    footer {
        background-color: #2c3e50;
        color: white;
        text-align: center;
        padding: 10px;
        position: relative;
        width: 100%;
    }
</style>
</head>
<body>
    <div class="content">
        <h1>Invalid Route</h1>
        <h2>Sorry, the page you are looking for does not exist.</h2>
        <p><a href="dashboard">Go back to Dashboard</a></p>
    </div>
    
    <%@ include file="footer.jsp"%>
</body>
</html>
