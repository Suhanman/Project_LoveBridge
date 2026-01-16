<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <title>나의 이상형</title>
  <style>
    body {
      background-color: #ffeaf4;
      text-align: center;
      padding-top: 80px;
    }

    h1 {
      color: #ff3399;
      font-size: 32px;
      margin-bottom: 40px;
    }

    .button-container {
      display: flex;
      flex-direction: column;
      align-items: center;
      gap: 20px;
    }

    .button-row {
      display: flex;
      flex-direction: row;
      justify-content: center;
      gap: 20px;
    }

    .tag-button {
      background: linear-gradient(to bottom, #ffb3dd, #ff66aa);
      color: white;
      border: 3px solid white;
      border-radius: 40px;
      padding: 12px 40px;
      font-size: 20px;
      box-shadow: 0 5px 15px rgba(255, 105, 180, 0.4);
      cursor: pointer;
      transition: all 0.2s ease;
      width: 220px;
      text-align: center;
    }

    .tag-button:hover {
      transform: scale(1.05);
      background: linear-gradient(to bottom, #ffc2e0, #ff80bf);
    }

    .tag-button.selected {
      background: linear-gradient(to bottom, #fff0fb, #ff99cc);
      color: #ff3399;
      box-shadow: 0 0 20px rgba(255, 105, 180, 0.8);
      border: 3px solid #ff66aa;
      font-weight: bold;
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
  </style>

  <script>
    function toggleButton(btn) {
      const group = btn.parentElement;
      const isSelected = btn.classList.contains("selected");

      if (isSelected) {
        btn.classList.remove("selected");
      } else {
        const buttons = group.querySelectorAll(".tag-button");
        buttons.forEach(b => b.classList.remove("selected"));
        btn.classList.add("selected");
      }
    }

    function submitIdealForm() {
      const form = document.getElementById("idealForm");

      // 1. 세션스토리지에서 회원가입/프로필 정보 꺼내기
      const keys = ['id', 'pw', 'confirm', 'userName', 'mobile', 'gender', 'imageUrl',
                    'my_mbti', 'my_smoke', 'my_body', 'my_style'];

      keys.forEach(key => {
        const value = sessionStorage.getItem(key);
        if (value !== null) {
          const input = document.createElement("input");
          input.type = "hidden";
          input.name = key;
          input.value = value;
          form.appendChild(input);
        }
      });

      // 2. 이상형 버튼에서 선택된 것만 추가로 저장
      const idealLabels = ['ideal_mbti', 'ideal_smoke', 'ideal_body', 'ideal_style'];
      const buttonRows = document.querySelectorAll('.button-row');

      buttonRows.forEach((row, idx) => {
        const selected = row.querySelector('.tag-button.selected');
        if (selected) {
          const input = document.createElement("input");
          input.type = "hidden";
          input.name = idealLabels[idx];
          input.value = selected.innerText;
          form.appendChild(input);
        }
      });

      // 3. 제출
      form.submit();
    }
  </script>
</head>
<body>

  <h1>나의 이상형 프로필 만들기</h1>

  <form id="idealForm" action="registProc" method="post">
    <div class="button-container">
      <div class="button-row">
        <button type="button" class="tag-button" onclick="toggleButton(this)">MBTI=I</button>
        <button type="button" class="tag-button" onclick="toggleButton(this)">MBTI=E</button>
      </div>

      <div class="button-row">
        <button type="button" class="tag-button" onclick="toggleButton(this)">흡연자</button>
        <button type="button" class="tag-button" onclick="toggleButton(this)">비흡연자</button>
      </div>

      <div class="button-row">
        <button type="button" class="tag-button" onclick="toggleButton(this)">마름</button>
        <button type="button" class="tag-button" onclick="toggleButton(this)">보통</button>
        <button type="button" class="tag-button" onclick="toggleButton(this)">통통</button>
      </div>

      <div class="button-row">
        <button type="button" class="tag-button" onclick="toggleButton(this)">캐쥬얼</button>
        <button type="button" class="tag-button" onclick="toggleButton(this)">러블리</button>
        <button type="button" class="tag-button" onclick="toggleButton(this)">힙</button>
      </div>

      <input type="button" value="완료" class="cute-button" onclick="submitIdealForm()">
    </div>
  </form>

</body>
</html>
