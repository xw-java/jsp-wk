<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.design.project_design.Login" %>
<jsp:useBean id="loginBean" class="com.design.project_design.Login" scope="session"/>
<!DOCTYPE html>
<html>
<head>
    <%@ include file="head.txt" %>
    <title>商品搜索</title>
    <style>
        body { background-color: #fbfbfd; }

        .search-hero {
            text-align: center;
            padding: 80px 20px;
            max-width: 600px;
            margin: 0 auto;
        }
        .search-title {
            font-size: 40px; font-weight: 700;
            margin-bottom: 10px; color: #1d1d1f;
        }
        .search-subtitle {
            font-size: 16px; color: #86868b; margin-bottom: 40px;
        }

        .search-box-wrapper {
            position: relative;
            box-shadow: 0 10px 40px rgba(0,0,0,0.1);
            border-radius: 18px;
            background: #fff;
            padding: 10px;
            display: flex; align-items: center;
        }
        .search-input {
            flex: 1; border: none; padding: 16px 20px;
            font-size: 18px; outline: none; background: transparent;
        }
        .search-btn {
            background: #0071e3; color: white;
            border: none; padding: 14px 30px;
            border-radius: 12px; font-size: 16px; font-weight: 600;
            cursor: pointer; transition: all 0.2s;
        }
        .search-btn:hover { background: #0077ed; transform: scale(1.02); }

        .radio-group {
            margin-top: 25px; display: flex; justify-content: center; gap: 15px;
        }
        .radio-group input[type="radio"] { display: none; }
        .radio-label {
            padding: 10px 20px; background: #f0f0f0; border-radius: 20px;
            color: #666; font-size: 14px; cursor: pointer; transition: all 0.3s;
            border: 1px solid transparent;
        }
        .radio-group input[type="radio"]:checked + .radio-label {
            background: #eef7ff; color: #0071e3; border-color: #0071e3;
            font-weight: bold; box-shadow: 0 4px 10px rgba(0, 113, 227, 0.15);
        }

        .hot-tags {
            margin-top: 50px; display: flex; justify-content: center; gap: 10px; flex-wrap: wrap;
        }
        .tag-item {
            padding: 8px 16px; background: #fff; border: 1px solid #d2d2d7;
            border-radius: 8px; color: #1d1d1f; text-decoration: none;
            font-size: 13px; transition: all 0.2s;
        }
        .tag-item:hover { border-color: #0071e3; color: #0071e3; }
    </style>
</head>
<body>

<div class="container">
    <div class="search-hero">
        <h1 class="search-title">🔍 探索下一部手机</h1>
        <p class="search-subtitle">输入关键词，快速定位心仪好物</p>

        <form action="searchByConditionServlet" method="post" id="searchForm">
            <div class="search-box-wrapper">
                <input type="text" class="search-input" name="searchMess" id="searchInput" placeholder="请输入手机名称..." required>
                <button type="submit" class="search-btn">搜索</button>
            </div>

            <div class="radio-group">
                <label>
                    <input type="radio" name="radio" value="mobile_name" checked onclick="changeTip('name')">
                    <span class="radio-label">按名称</span>
                </label>
                <label>
                    <input type="radio" name="radio" value="mobile_version" onclick="changeTip('version')">
                    <span class="radio-label">按型号</span>
                </label>
                <label>
                    <input type="radio" name="radio" value="mobile_price" onclick="changeTip('price')">
                    <span class="radio-label">按价格范围</span>
                </label>
            </div>
        </form>

        <div class="hot-tags">
            <span style="color: #86868b; font-size: 13px; align-self: center; margin-right: 5px;">🔥 热门搜索:</span>
            <a href="javascript:quickSearch('Apple')" class="tag-item">🍎 Apple</a>
            <a href="javascript:quickSearch('Huawei')" class="tag-item">🏵️ Huawei</a>
            <a href="javascript:quickSearch('Xiaomi')" class="tag-item">📱 小米</a>
            <a href="javascript:quickSearch('5G')" class="tag-item">📡 5G手机</a>
        </div>
    </div>
</div>

<script>
    function changeTip(type) {
        var input = document.getElementById("searchInput");
        if(type === 'price') input.placeholder = "请输入价格区间，如: 3000-5000";
        else if(type === 'version') input.placeholder = "请输入具体型号，如: iPhone 15 Pro";
        else input.placeholder = "请输入手机名称...";
    }
    function quickSearch(val) {
        var input = document.getElementById("searchInput");
        input.value = val;
        document.querySelector('input[value="mobile_name"]').click();
        document.getElementById("searchForm").submit();
    }
</script>

<div class="footer" style="padding: 100px 0; border-top: 1px solid #eee; text-align: center;">
    <p style="color: #888; font-size: 14px;">&copy; 2025 Mobile Shop System. 让科技回归简约。</p>
</div>

</body>
</html>