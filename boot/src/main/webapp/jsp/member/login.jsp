<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
	<title>LoveBridge - 로그인</title>
	<style>
		body {
			background-color: #ffeaf4;
			text-align: center;
			padding-top: 80px;
		}

		.form-wrapper {
			display: inline-block;
			background-color: #fff0f7;
			border: 4px dotted #ff6db3;
			border-radius: 30px;
			padding: 40px 50px;
			box-shadow: 0 0 20px #ffcce6;
		}

		h1 {
			color: #ff3399;
			margin-bottom: 30px;
		}

		input[type="text"],
		input[type="password"] {
			width: 250px;
			padding: 10px;
			margin: 8px 0;
			border: 2px solid #ffaad4;
			border-radius: 15px;
			background-color: #fff;
			font-size: 16px;
		}

		.cute-button {
			display: inline-block;
			background: linear-gradient(to bottom, #ff80b5, #ff4d94);
			color: white;
			font-size: 18px;
			padding: 10px 24px;
			margin: 10px 5px;
			border: 3px solid white;
			border-radius: 20px;
			box-shadow: 0 5px 15px rgba(255, 105, 180, 0.4);
			cursor: pointer;
			text-decoration: none;
			transition: all 0.2s ease;
		}

		.cute-button:hover {
			transform: scale(1.05);
			background: linear-gradient(to bottom, #ff99c8, #ff66a3);
			box-shadow: 0 5px 20px rgba(255, 105, 180, 0.6);
		}

		.kakao-login img {
			margin-top: 20px;
			width: 200px;
			border-radius: 10px;
			box-shadow: 0 0 10px rgba(0,0,0,0.1);
			cursor: pointer;
		}

		.error-msg {
			color: red;
			margin-bottom: 10px;
			font-size: 14px;
		}
	</style>

	<script>
		function loginCheck() {
			const id = document.getElementById("id").value;
			const pw = document.getElementById("pw").value;
			if (id.trim() === "" || pw.trim() === "") {
				alert("아이디와 비밀번호를 모두 입력해주세요.");
				return;
			}
			document.getElementById("f").submit();
		}
	</script>
</head>

<body>

	<div class="form-wrapper">
		<h1>🎀 로그인</h1>

		<c:if test="${not empty msg}">
			<div class="error-msg">${msg}</div>
		</c:if>

		<form action="loginProc" method="post" id="f">
			<input type="text" name="id" placeholder="아이디" id="id"><br>
			<input type="password" name="pw" placeholder="비밀번호" id="pw"><br>
			<input type="button" value="로그인" class="cute-button" onclick="loginCheck()">
			<input type="button" value="취소" class="cute-button" onclick="location.href='index'"><br>
		</form>

		<div class="kakao-login">
			<a href="https://kauth.kakao.com/oauth/authorize?response_type=code
				&client_id=537943e9031cf074f79c9818f4fd5af1
				&redirect_uri=http://localhost:8086/dbQuiz/kakaoLogin">
				<img src="https://k.kakaocdn.net/14/dn/btroDszwNrM/I6efHub1SN5KCJqLm1Ovx1/o.jpg" alt="카카오 로그인" />
			</a>
		</div>
	</div>

	<c:import url="/footer" />
</body>
</html>
