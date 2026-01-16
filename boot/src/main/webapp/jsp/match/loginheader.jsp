<!-- header.jsp -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600&display=swap" rel="stylesheet">

<style>
    header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 30px 60px;
    }

    .logo a {
        font-family: 'Playfair Display', serif;
        font-size: 34px;
        font-weight: 600;
        color: #333;
        text-decoration: none;
    }

    .logo a span {
        color: #ff5e99;
        margin-left: 5px;
    }

    .nav-links {
        display: flex;
        align-items: center;
        gap: 25px;
        position: relative;
    }

    .nav-links a {
        text-decoration: none;
        color: #444;
        font-weight: bold;
        font-size: 15px;
        position: relative;
    }

    .dropdown {
        position: relative;
    }

    .dropdown-content {
        display: none;
        position: absolute;
        top: 28px;
        left: 0;
        background-color: white;
        border: 1px solid #ddd;
        border-radius: 5px;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        min-width: 200px;
        z-index: 999;
    }

    .dropdown-content a {
        display: block;
        padding: 10px 15px;
        font-size: 14px;
        color: #333;
        text-decoration: none;
    }

    .dropdown-content a:hover {
        background-color: #f8f8f8;
    }

    .dropdown:hover .dropdown-content {
        display: block;
    }

    .chat-icon {
        font-size: 20px;
    }
</style>

<header>
    <div class="logo">
        <a href="/home">LoveBridge <span>💗</span></a>
    </div>
    <div class="nav-links">
        <a href="/home">Home</a>
        <div class="dropdown">
            <a href="#">Profile ▾</a>
            <div class="dropdown-content">
                <a href="/profile/info">인적사항 수정</a>
                <a href="/profile/traits">내 특징 설정</a>
                <a href="/profile/preference">선호 특징 설정</a>
                <a href="/profile/history">매칭 이력</a>
            </div>
        </div>
        <a href="/logout">Logout</a>
        <a href="/chat" class="chat-icon">🗨️</a>
    </div>
</header>
