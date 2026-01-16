<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>LoveBridge</title>
    <style>
        body {
            background-color: #ffeaf4;
            font-family: 'Arial', sans-serif;
            margin: 0;
            padding: 0;
        }

        h2 {
            margin-top: 40px;
            margin-bottom: 30px;
            margin-left: 60px;
            font-size: 22px;
            color: #222;
        }

        .match-container {
            padding: 0 60px 60px 60px;
        }

        .card {
            width: 120px;
            border: 1px solid #ccc;
            text-align: center;
            padding: 10px;
            margin: 12px;
            display: inline-block;
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 2px 2px 5px rgba(0,0,0,0.1);
            transition: transform 0.2s ease-in-out;
        }

        .card:hover {
            transform: translateY(-5px);
            box-shadow: 4px 4px 10px rgba(0,0,0,0.15);
        }

        .heart-btn {
            background: none;
            border: none;
            font-size: 20px;
            cursor: pointer;
            margin-top: 8px;
        }

        .heart-btn.filled {
            color: #ff5e99;
        }
    </style>
    <script>
        function toggleHeart(button) {
            button.classList.toggle('filled');
            button.innerText = button.classList.contains('filled') ? '❤️' : '♡';
        }
    </script>
</head>
<body>

<%@ include file="loginheader.jsp" %>


<h2>Your Matches</h2>

<div class="match-container">
    <c:forEach var="match" items="${matches}">
        <div class="card">
            <a href="/match/${match.id}">
                <img src="/img/profile-icon.png" alt="profile" style="width: 80px;">
                <p>${match.name}</p>
                <p>${match.age}세</p>
            </a>
            <button class="heart-btn" onclick="toggleHeart(this)">♡</button>
        </div>
    </c:forEach>
</div>

</body>
</html>
