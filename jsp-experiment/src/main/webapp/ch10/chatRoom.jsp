<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.design.project_design.Login" %>
<jsp:useBean id="loginBean" class="com.design.project_design.Login" scope="session"/>
<!DOCTYPE html>
<html>
<head>
    <%@ include file="head.txt" %>
    <title>即时交流大厅</title>
    <style>
        /* 整体布局：左右分栏 */
        .chat-layout {
            display: flex; gap: 20px; max-width: 1000px; margin: 40px auto; height: 70vh;
        }

        /* 左侧聊天主窗口 */
        .chat-main {
            flex: 3; display: flex; flex-direction: column;
            background: #fff; border-radius: 12px; box-shadow: 0 4px 20px rgba(0,0,0,0.08);
        }
        .chat-header { padding: 15px 20px; border-bottom: 1px solid #eee; background: #f8f9fa; border-radius: 12px 12px 0 0; font-weight: bold; }

        .chat-window {
            flex: 1; padding: 20px; overflow-y: auto; background: #fcfcfc;
            scroll-behavior: smooth; /* 平滑滚动 */
        }

        .chat-input-area {
            padding: 15px; border-top: 1px solid #eee; display: flex; gap: 10px;
        }

        /* 右侧用户列表 */
        .chat-sidebar {
            flex: 1; background: #fff; border-radius: 12px; box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            display: flex; flex-direction: column;
        }
        .user-list { flex: 1; padding: 10px; overflow-y: auto; }
        .user-item {
            padding: 8px 12px; border-bottom: 1px solid #f5f5f5;
            font-size: 14px; color: #555; display: flex; align-items: center;
        }
        .user-item:before {
            content: ''; display: inline-block; width: 8px; height: 8px;
            background: #4cd964; border-radius: 50%; margin-right: 8px;
        }

        /* 消息气泡样式 */
        .msg-item { margin-bottom: 15px; animation: slideIn 0.3s ease; }
        .msg-user { font-weight: bold; color: #0071e3; margin-right: 5px; font-size: 13px; }
        .msg-time { font-size: 12px; color: #999; }
        .msg-content {
            margin-top: 4px; padding: 10px 15px;
            background: #f0f2f5; border-radius: 0 12px 12px 12px;
            display: inline-block; max-width: 85%; line-height: 1.5; color: #333;
        }

        input[type="text"] { flex: 1; padding: 12px; border: 1px solid #ddd; border-radius: 20px; outline: none; }
        .btn-send { padding: 0 25px; border-radius: 20px; background: #0071e3; color: white; border: none; cursor: pointer; }
        .btn-send:hover { opacity: 0.9; }

        @keyframes slideIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }
    </style>
</head>
<body>

<div class="container">
    <% if (loginBean == null || loginBean.getLogname() == null) { %>
    <script>alert("请先登录！"); location.href="login.jsp";</script>
    <% } else { %>

    <div class="chat-layout">
        <div class="chat-main">
            <div class="chat-header">
                💬 公共聊天室 (当前用户: <%=loginBean.getLogname()%>)
            </div>

            <div id="chatWindow" class="chat-window">
            </div>

            <div class="chat-input-area">
                <input type="text" id="msgInput" placeholder="请输入消息..." onkeypress="handleEnter(event)" autocomplete="off">
                <button class="btn-send" onclick="sendMsg()">发送</button>
            </div>
        </div>

        <div class="chat-sidebar">
            <div class="chat-header" style="background: #fff; border-bottom: 2px solid #f5f5f5;">
                👥 在线名单
            </div>
            <div id="userList" class="user-list">
            </div>
        </div>
    </div>

    <% } %>
</div>

<script>
    // 页面加载完成后启动定时器
    window.onload = function() {
        loadMessages(); // 立即加载一次
        loadUsers();    // 立即加载用户
        setInterval(loadMessages, 2000); // 2秒刷一次消息
        setInterval(loadUsers, 5000);    // 5秒刷一次用户列表
    };

    // 1. 发送消息
    function sendMsg() {
        var input = document.getElementById("msgInput");
        var content = input.value;
        if(content.trim() === "") return;

        var xhr = new XMLHttpRequest();
        xhr.open("POST", "chatServlet", true);
        xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4 && xhr.status === 200) {
                input.value = ""; // 清空输入框
                loadMessages();   // 发送后立即刷新
            }
        };
        xhr.send("content=" + encodeURIComponent(content));
    }

    // 2. 加载消息 (核心防闪烁逻辑)
    function loadMessages() {
        // 找出当前页面上最后一条消息的ID
        var lastId = 0;
        var msgItems = document.getElementsByClassName("msg-item");
        if(msgItems.length > 0) {
            lastId = msgItems[msgItems.length - 1].getAttribute("data-id");
        }

        var xhr = new XMLHttpRequest();
        // 传入 lastID，告诉服务器：我只要比这个ID更新的消息
        xhr.open("GET", "chatServlet?action=getMsg&lastID=" + lastId + "&t=" + new Date().getTime(), true);
        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4 && xhr.status === 200) {
                var newContent = xhr.responseText.trim();
                // 只有当有新内容时，才追加 (append) 到末尾
                if(newContent.length > 0) {
                    var chatWindow = document.getElementById("chatWindow");
                    chatWindow.insertAdjacentHTML('beforeend', newContent);
                    // 平滑滚动到底部
                    chatWindow.scrollTop = chatWindow.scrollHeight;
                }
            }
        };
        xhr.send();
    }

    // 3. 加载在线用户列表
    function loadUsers() {
        var xhr = new XMLHttpRequest();
        xhr.open("GET", "chatServlet?action=getUsers&t=" + new Date().getTime(), true);
        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4 && xhr.status === 200) {
                document.getElementById("userList").innerHTML = xhr.responseText;
            }
        };
        xhr.send();
    }

    function handleEnter(e) {
        if(e.keyCode === 13) sendMsg();
    }
</script>

</body>
</html>