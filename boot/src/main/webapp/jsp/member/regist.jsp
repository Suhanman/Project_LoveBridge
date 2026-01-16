<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<title>LoveBridge - 회원가입</title>
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
		label {
			display: block;
			font-size: 14px;
			color: #ff3399;
			margin-bottom: 10px;
		}
		.cute-button {
			display: inline-block;
			background: linear-gradient(to bottom, #ff80b5, #ff4d94);
			color: white;
			font-size: 18px;
			padding: 10px 24px;
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
		#label {
			margin-top: 4px;
			font-size: 13px;
			color: red;
		}
		select {
 			width: 270px;
  			padding: 10px;
  			margin: 8px 0;
  			border: 2px solid #ffaad4;
  			border-radius: 15px;
  			background-color: #fff;
  			font-size: 16px;
  			color: #ff3399;
  			appearance: none;
  			background-image: url('data:image/svg+xml;charset=US-ASCII,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 4 5"><path fill="%23ff66aa" d="M2 0L0 2h4L2 0z"/></svg>');
  			background-repeat: no-repeat;
  			background-position: right 12px center;
  			background-size: 12px;
		}
	</style>
</head>
<body>
	<div class="form-wrapper">
		<h1>💌 회원가입</h1>
		<font color="red">${msg}</font>

		<form id="f">
			<input type="text" name="id" placeholder="아이디" required><br>
			<input type="password" name="pw" placeholder="비밀번호" required><br>
			<input type="password" name="confirm" placeholder="비밀번호 확인" required><br>
			<input type="text" name="userName" placeholder="이름" required><br>
			<input type="text" name="mobile" placeholder="전화번호" required><br>
			<select name="gender" required>
				<option value="">성별 선택</option>
				<option value="남성">남</option>
				<option value="여성">여</option>
			</select><br>
			<input type="text" name="imageUrl" placeholder="이미지 업로드" required><br>

			<input type="button" value="다음" class="cute-button" onclick="goProfile()">
			<input type="button" value="취소" class="cute-button" onclick="location.href='index'"><br>
		</form>
	</div>

	<script>
		function goProfile() {
			const form = document.getElementById("f");
			const data = new FormData(form);

			for (const [key, value] of data.entries()) {
				sessionStorage.setItem(key, value);
			}
			location.href = 'profile';
		}
	</script>
</body>
</html>
