<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:useBean id="loginBean" class="com.design.project_design.Login" scope="session"/>
<!DOCTYPE html>
<html>
<head>
    <%@ include file="head.txt" %>
    <title>登录 - 小蜜蜂手机网</title>
    <style>
        body {
            background-color: #f5f5f7; /* 统一背景色 */
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }

        /* 覆盖 navbar 样式，使其在登录页更通透 */
        .navbar {
            background: rgba(255,255,255,0.7);
            border-bottom: none;
        }

        .login-wrapper {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px 20px;
        }

        .login-card {
            background: #ffffff;
            width: 100%;
            max-width: 400px;
            padding: 40px;
            border-radius: 24px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.08); /* 柔和的高级阴影 */
            text-align: center;
            transition: transform 0.3s ease;
        }

        .brand-icon {
            font-size: 48px;
            margin-bottom: 20px;
            display: inline-block;
        }

        .login-title {
            font-size: 28px;
            font-weight: 700;
            color: #1d1d1f;
            margin-bottom: 10px;
        }

        .login-subtitle {
            color: #86868b;
            font-size: 15px;
            margin-bottom: 35px;
        }

        .form-group {
            margin-bottom: 20px;
            text-align: left;
        }

        .form-input {
            width: 100%;
            padding: 16px;
            border: 1px solid transparent; /* 默认无边框 */
            border-radius: 12px;
            background: #f5f5f7; /* 浅灰背景 */
            font-size: 16px;
            box-sizing: border-box;
            outline: none;
            transition: all 0.3s ease;
            color: #1d1d1f;
        }

        .form-input:focus {
            background: #fff;
            border-color: #0071e3;
            box-shadow: 0 0 0 4px rgba(0, 113, 227, 0.1); /* 聚焦时的光晕 */
        }

        .submit-btn {
            width: 100%;
            padding: 16px;
            background: #0071e3;
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 17px;
            font-weight: 600;
            cursor: pointer;
            margin-top: 10px;
            transition: all 0.2s;
        }

        .submit-btn:hover {
            background: #0077ed;
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(0, 113, 227, 0.3);
        }

        .footer-actions {
            margin-top: 30px;
            font-size: 14px;
            color: #86868b;
        }

        .footer-actions a {
            color: #0071e3;
            text-decoration: none;
            font-weight: 500;
            margin-left: 5px;
        }

        .footer-actions a:hover {
            text-decoration: underline;
        }

        .error-toast {
            background: #fff2f2;
            color: #ff3b30;
            padding: 12px;
            border-radius: 8px;
            font-size: 13px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            border: 1px solid rgba(255, 59, 48, 0.1);
        }
    </style>
</head>
<body>

<div class="login-wrapper">
    <div class="login-card">
        <div class="brand-icon">🐝</div>
        <h2 class="login-title">欢迎回来</h2>
        <p class="login-subtitle">请登录您的小蜜蜂账号以继续</p>

        <%-- 错误提示逻辑 --%>
        <%
            String errorMsg = (String) request.getAttribute("loginError");
            if (errorMsg == null && loginBean != null) {
                if (loginBean.getBackNews() != null && !loginBean.getBackNews().contains("未登录")) {
                    errorMsg = loginBean.getBackNews();
                }
            }
        %>
        <% if (errorMsg != null && !errorMsg.trim().isEmpty()) { %>
        <div class="error-toast">
            <span style="font-size: 16px">⚠️</span> <%= errorMsg %>
        </div>
        <% } %>

        <form action="loginServlet" method="post">
            <div class="form-group">
                <input type="text" name="logname" class="form-input" placeholder="用户名 / 账号" required>
            </div>
            <div class="form-group">
                <input type="password" name="password" class="form-input" placeholder="密码" required>
            </div>
            <button type="submit" class="submit-btn">立即登录</button>
        </form>

        <div class="footer-actions">
            还没有账号？<a href="inputRegisterMess.jsp">免费注册</a>
        </div>
    </div>
</div>

</body>
</html>
