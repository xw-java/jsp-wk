<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:useBean id="loginBean" class="com.design.project_design.Login" scope="session"/>
<!DOCTYPE html>
<html>
<head>
    <%@ include file="head.txt" %>
    <style>
        .navbar { border-bottom: none; }
        .login-container {
            max-width: 320px;
            margin: 120px auto;
            text-align: center;
        }
        .login-container h2 { font-size: 32px; font-weight: 600; margin-bottom: 8px; }
        .login-container p { color: var(--text-secondary); font-size: 14px; margin-bottom: 40px; }

        .input-group { margin-bottom: 12px; text-align: left; }
        .input-group input {
            width: 100%;
            padding: 14px; border: 1px solid #d2d2d7;
            border-radius: 8px; box-sizing: border-box; font-size: 16px;
            background: #fbfbfd; outline: none; transition: all 0.3s;
        }
        .input-group input:focus { border-color: #0071e3; background: #fff; }

        .login-submit {
            width: 100%;
            padding: 14px; background: #0071e3; color: white;
            border: none; border-radius: 8px; font-size: 16px; font-weight: 600;
            cursor: pointer; margin-top: 20px;
        }
        .login-submit:hover { opacity: 0.9; }

        .error-msg {
            color: #ee4444;
            font-size: 13px; margin-top: 20px;
            background: #fff5f5; padding: 10px; border-radius: 6px;
        }
    </style>
</head>
<body>

<div class="login-container">
    <h2>登录</h2>
    <p>使用您的小蜜蜂账号继续</p>

    <%-- 这里的 action 对应 web.xml 中的 url-pattern --%>
    <form action="loginServlet" method="post">
        <div class="input-group">
            <input type="text" name="logname" placeholder="账号" required>
        </div>
        <div class="input-group">
            <input type="password" name="password" placeholder="密码" required>
        </div>
        <button type="submit" class="login-submit">继续</button>
    </form>

    <div style="margin-top: 30px;">
        <a href="inputRegisterMess.jsp" style="color:#0071e3; text-decoration:none; font-size:14px;">还没有账号？现在注册 &rarr;</a>
    </div>

    <%-- 【核心修改】 优先显示 request 中的错误信息 --%>
    <%
        String errorMsg = (String) request.getAttribute("loginError");
        if (errorMsg == null && loginBean != null) {
            // 兼容旧逻辑：如果 request 没报错，看看 session 里有没有
            if (loginBean.getBackNews() != null && !loginBean.getBackNews().contains("未登录")) {
                errorMsg = loginBean.getBackNews();
            }
        }
    %>

    <% if (errorMsg != null && !errorMsg.trim().isEmpty()) { %>
    <div class="error-msg">
        <%= errorMsg %>
    </div>
    <% } %>
</div>

</body>
</html>