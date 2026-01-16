<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>LoveBridge</title>
    <style>
        .card {
            width: 120px;
            border: 1px solid #ccc;
            text-align: center;
            padding: 10px;
            margin: 5px;
            display: inline-block;
        }
    </style>
</head>
<body>

<div>
    <h1 style="display:inline">LoveBridge</h1>
    <a href="/home" style="margin-left:30px;">Home</a>
    <a href="/profile">Profile</a>
    <a href="/logout">Logout</a>
    <a href="/chat"><img src="/img/chat.png" alt="chat" style="width: 20px;"></a>
</div>

<h2>Your Matches</h2>

<div>
    <c:forEach var="match" items="${matches}">
        <div class="card">
            <a href="/match/${match.id}">
                <img src="/img/profile-icon.png" alt="profile" style="width: 80px;">
                <p>${match.name}</p>
                <p>${match.age}세</p>
                <span>❤️</span>
            </a>
        </div>
    </c:forEach>
</div>

</body>
</html>
