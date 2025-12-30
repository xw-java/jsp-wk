<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <%@ include file="head.txt" %>
    <title>创建账号 - 小蜜蜂手机网</title>
    <style>
        body {
            background-color: #f5f5f7;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }

        .navbar { background: rgba(255,255,255,0.7); border-bottom: none; }

        .register-wrapper {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 60px 20px;
        }

        .register-card {
            background: #ffffff;
            width: 100%;
            max-width: 480px; /* 比登录页稍宽 */
            padding: 40px;
            border-radius: 24px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.08);
        }

        .header-section {
            text-align: center;
            margin-bottom: 30px;
        }

        .page-title {
            font-size: 28px;
            font-weight: 700;
            color: #1d1d1f;
            margin: 0 0 10px 0;
        }

        .page-desc {
            color: #86868b;
            font-size: 15px;
            margin: 0;
        }

        .form-label {
            display: block;
            font-size: 13px;
            font-weight: 600;
            color: #424245;
            margin-bottom: 8px;
            margin-left: 4px;
        }

        .form-input {
            width: 100%;
            padding: 14px 16px;
            border: 1px solid transparent;
            border-radius: 12px;
            background: #f5f5f7;
            font-size: 15px;
            box-sizing: border-box;
            outline: none;
            transition: all 0.3s;
            color: #1d1d1f;
            margin-bottom: 20px;
        }

        .form-input:focus {
            background: #fff;
            border-color: #0071e3;
            box-shadow: 0 0 0 4px rgba(0, 113, 227, 0.1);
        }

        .btn-register {
            width: 100%;
            padding: 16px;
            background: #1d1d1f; /* 注册按钮使用黑色，与登录区分，显得更稳重 */
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
            margin-top: 10px;
        }

        .btn-register:hover {
            background: #333;
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.15);
        }

        .error-banner {
            background: #fff2f2;
            border-left: 4px solid #ff3b30;
            color: #cd2c24;
            padding: 12px 16px;
            border-radius: 8px;
            font-size: 13px;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .login-link {
            text-align: center;
            margin-top: 25px;
            font-size: 14px;
            color: #86868b;
        }
        .login-link a {
            color: #0071e3;
            text-decoration: none;
            font-weight: 600;
        }
    </style>
</head>
<body>

<div class="register-wrapper">
    <div class="register-card">
        <div class="header-section">
            <h2 class="page-title">创建新账号</h2>
            <p class="page-desc">只需几步，开启您的极简购物之旅</p>
        </div>

        <%
            String error = (String)request.getAttribute("registerError");
            if(error != null) {
        %>
        <div class="error-banner">
            <span style="font-size: 18px">🚫</span>
            <span><%= error %></span>
        </div>
        <% } %>

        <form action="registerServlet" method="post">
            <div>
                <label class="form-label">用户名</label>
                <input type="text" name="logname" class="form-input" placeholder="设置您的登录账号" required
                       value="<%= request.getAttribute("old_logname")==null?"":request.getAttribute("old_logname") %>">
            </div>

            <div>
                <label class="form-label">登录密码</label>
                <input type="password" name="password" class="form-input" placeholder="设置一个安全的密码" required>
            </div>

            <div style="display: flex; gap: 15px;">
                <div style="flex: 1;">
                    <label class="form-label">真实姓名</label>
                    <input type="text" name="realname" class="form-input" placeholder="您的姓名"
                           value="<%= request.getAttribute("old_realname")==null?"":request.getAttribute("old_realname") %>">
                </div>
                <div style="flex: 1;">
                    <label class="form-label">联系电话</label>
                    <input type="text" name="phone" class="form-input" placeholder="手机号码"
                           value="<%= request.getAttribute("old_phone")==null?"":request.getAttribute("old_phone") %>">
                </div>
            </div>

            <div>
                <label class="form-label">收货地址</label>
                <input type="text" name="address" class="form-input" placeholder="用于接收商品的详细地址"
                       value="<%= request.getAttribute("old_address")==null?"":request.getAttribute("old_address") %>">
            </div>

            <button type="submit" class="btn-register">同意协议并注册</button>
        </form>

        <div class="login-link">
            已有账号？ <a href="login.jsp">直接登录 &rarr;</a>
        </div>
    </div>
</div>

</body>
</html>
