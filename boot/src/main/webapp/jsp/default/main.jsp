	<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<title>LoveBridge</title>
	<style>
		body {
			background-color: #ffeaf4;
			text-align: center;
			padding-top: 100px;
		}

		.main_div {
			display: inline-block;
			background-color: #fff0f7;
			border: 4px dotted #ff6db3;
			border-radius: 30px;
			padding: 50px;
			box-shadow: 0 0 20px #ffcce6;
		}

		.cute-button {
			display: inline-block;
			background: linear-gradient(to bottom, #ff80b5, #ff4d94);
			color: white;
			font-size: 20px;
			padding: 12px 32px;
			margin: 10px;
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
	</style>
</head>
<body>
	<div class="main_div">
		<a href="${context}regist" class="cute-button">💌 회원가입</a><br>
		<a href="${context}login" class="cute-button">💌 로그인 </a>
	</div>
</body>
</html>
