<!-- info.jsp -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>개인 정보 수정</title>
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

        input, select {
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

<h1>개인 정보 수정</h1>

<form action="/profile/update" method="post">
    <label>이름:</label>
    <input type="text" name="name" value="${user.name}" required>

    <label>나이:</label>
    <input type="number" name="age" value="${user.age}" required>

    <label>성별:</label>
    <select name="gender">
        <option value="남성" ${user.gender == '남성' ? 'selected' : ''}>남성</option>
        <option value="여성" ${user.gender == '여성' ? 'selected' : ''}>여성</option>
    </select>

    <button type="submit">수정하기</button>
</form>

</body>
</html>
