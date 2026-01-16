<!-- traits.jsp -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>내 특징/성향 설정</title>
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

        form {
            background-color: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.1);
            max-width: 500px;
        }

        label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }

        select {
            width: 100%;
            padding: 8px;
            margin-bottom: 20px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }

        button {
            padding: 10px 20px;
            background-color: #ff88aa;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }

        button:hover {
            background-color: #ff6699;
        }
    </style>
</head>
<body>

<%@ include file="../match/loginheader.jsp" %>


<h1>내 특징 / 성향 설정</h1>

<form action="/profile/traits" method="post">
    <label>체형:</label>
    <select name="bodyType">
        <option value="마름">마름</option>
        <option value="보통">보통</option>
        <option value="통통">통통</option>
    </select>

    <label>성격:</label>
    <select name="personality">
        <option value="외향">외향</option>
        <option value="내향">내향</option>
    </select>

    <label>패션 스타일:</label>
    <select name="fashionStyle">
        <option value="카주얼">캐주얼</option>
        <option value="러블리">러블리</option>
        <option value="히프">힙</option>
    </select>

    <button type="submit">저장하기</button>
</form>

</body>
</html>
