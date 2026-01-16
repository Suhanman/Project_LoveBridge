<!-- history.jsp -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>매칭 이력</title>
    <style>
        body {
            background-color: #ffeaf4;
            font-family: 'Arial', sans-serif;
            margin: 0;
            padding: 60px;
        }

        h1 {
            margin-bottom: 30px;
        }

        section {
            background-color: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.1);
            max-width: 600px;
        }

        ul {
            padding-left: 20px;
        }

        li {
            margin-bottom: 10px;
        }
    </style>
</head>
<body>

<%@ include file="../match/loginheader.jsp" %>


<h1>매칭 이력</h1>

<section>
    <ul>
        <c:forEach var="match" items="${matchHistory}">
            <li>${match.name} (${match.age}세)</li>
        </c:forEach>
    </ul>
</section>

</body>
</html>