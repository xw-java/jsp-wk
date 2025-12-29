<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <%@ include file="head.txt" %>
    <title>注册新账号</title>
    <style>
        .navbar { border-bottom: none; }
        /* 复用 login.jsp 的样式容器，但稍微宽一点以容纳更多字段 */
        .login-container {
            max-width: 400px;
            margin: 60px auto;
            text-align: center;
        }
        .login-container h2 { font-size: 32px; font-weight: 600; margin-bottom: 8px; }
        .login-container p { color: var(--text-secondary); font-size: 14px; margin-bottom: 30px; }

        .input-group { margin-bottom: 12px; text-align: left; }
        .input-group label { display: block; font-size: 13px; color: var(--text-secondary); margin-bottom: 4px; margin-left: 2px;}

        .input-group input {
            width: 100%;
            padding: 12px 14px; border: 1px solid #d2d2d7;
            border-radius: 8px; box-sizing: border-box; font-size: 15px;
            background: #fbfbfd; outline: none; transition: all 0.3s;
        }
        .input-group input:focus { border-color: #0071e3; background: #fff; }

        .btn-submit {
            width: 100%;
            padding: 14px; background: #1d1d1f; color: white;
            border: none; border-radius: 8px; font-size: 16px; font-weight: 600;
            cursor: pointer; margin-top: 20px; transition: background 0.3s;
        }
        .btn-submit:hover { background: #333; }

        .error-msg {
            color: #ee4444; font-size: 13px; margin-bottom: 20px;
            background: #fff5f5; padding: 10px; border-radius: 6px; text-align: left;
        }

        .footer-link { margin-top: 20px; font-size: 14px; }
        .footer-link a { color: #0071e3; text-decoration: none; }
    </style>
</head>
<body>

<div class="login-container">
    <h2>创建账号</h2>
    <p>注册以开启您的购物之旅</p>

    <%-- 错误提示区域 --%>
    <%
        String error = (String)request.getAttribute("registerError");
        if(error != null) {
    %>
    <div class="error-msg">⚠️ <%= error %></div>
    <% } %>

    <form action="registerServlet" method="post">
        <div class="input-group">
            <label>用户名 (登录账号)</label>
            <input type="text" name="logname" required
                   value="<%= request.getAttribute("old_logname")==null?"":request.getAttribute("old_logname") %>">
        </div>

        <div class="input-group">
            <label>设置密码</label>
            <input type="password" name="password" required>
        </div>

        <div class="input-group">
            <label>真实姓名</label>
            <input type="text" name="realname"
                   value="<%= request.getAttribute("old_realname")==null?"":request.getAttribute("old_realname") %>">
        </div>

        <div class="input-group">
            <label>联系电话</label>
            <input type="text" name="phone"
                   value="<%= request.getAttribute("old_phone")==null?"":request.getAttribute("old_phone") %>">
        </div>

        <div class="input-group">
            <label>收货地址</label>
            <input type="text" name="address"
                   value="<%= request.getAttribute("old_address")==null?"":request.getAttribute("old_address") %>">
        </div>

        <button type="submit" class="btn-submit">立即注册</button>
    </form>

    <div class="footer-link">
        已有账号？ <a href="login.jsp">直接登录</a>
    </div>
</div>

</body>
</html>