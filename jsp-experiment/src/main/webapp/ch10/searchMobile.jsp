<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.design.project_design.Login" %>
<jsp:useBean id="loginBean" class="com.design.project_design.Login" scope="session"/>
<!DOCTYPE html>
<html>
<head>
    <%@ include file="head.txt" %>
    <title>商品搜索</title>
    <style>
        body { background-color: #f5f5f7; } /* 保持统一的浅灰背景 */

        /* 搜索区域容器 */
        .search-section {
            padding: 60px 0 40px; /* 增加顶部留白，更显大气 */
        }

        /* 核心布局容器：去掉了背景色、阴影和边框，只保留布局约束 */
        .search-hero-container {
            text-align: center;
            max-width: 700px;
            margin: 0 auto;
            position: relative;
        }

        /* 标题样式：保留渐变色，在浅灰背景上依然清晰 */
        .search-title {
            font-size: 48px; /* 稍微加大一点，作为视觉重心 */
            font-weight: 800;
            margin-bottom: 16px;
            background: linear-gradient(135deg, #1d1d1f 0%, #434344 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            letter-spacing: -1.5px;
        }

        .search-subtitle {
            font-size: 18px;
            color: #86868b;
            margin-bottom: 50px;
            font-weight: 400;
        }

        /* 搜索框包裹层：它现在是唯一的“实体”卡片，所以要给足阴影 */
        .search-box-wrapper {
            position: relative;
            box-shadow: 0 15px 40px rgba(0,0,0,0.1); /* 阴影加深，营造悬浮感 */
            border-radius: 20px; /* 更圆润 */
            background: #fff;
            padding: 10px;
            display: flex;
            align-items: center;
            transition: all 0.3s ease;
            /* 移除边框，用纯粹的阴影表达层级 */
            border: 1px solid rgba(255,255,255,0.8);
        }

        .search-box-wrapper:focus-within {
            transform: translateY(-2px);
            box-shadow: 0 20px 50px rgba(0, 113, 227, 0.15); /* 聚焦时带一点品牌色光晕 */
        }

        .search-input {
            flex: 1;
            border: none;
            padding: 16px 24px;
            font-size: 18px;
            outline: none;
            background: transparent;
            color: #1d1d1f;
        }

        .search-btn {
            background: #1d1d1f; /* 黑色按钮更显高级 */
            color: white;
            border: none;
            padding: 16px 36px;
            border-radius: 14px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
        }
        .search-btn:hover {
            background: #333;
            transform: scale(1.02);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }

        /* 单选按钮组：直接在背景上显示 */
        .radio-group {
            margin-top: 30px;
            display: flex;
            justify-content: center;
            gap: 15px;
        }
        .radio-group input[type="radio"] { display: none; }
        .radio-label {
            padding: 8px 20px;
            /* 背景设为透明或者极淡的颜色，融入大背景 */
            background: rgba(0,0,0,0.03);
            border-radius: 20px;
            color: #6e6e73;
            font-size: 14px;
            cursor: pointer;
            transition: all 0.2s;
            font-weight: 500;
        }
        .radio-group input[type="radio"]:checked + .radio-label {
            background: #fff;
            color: #0071e3;
            font-weight: 600;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05); /* 选中时微微浮起 */
        }

        /* 热门标签区域 */
        .hot-tags-container {
            margin-top: 60px;
        }
        .tags-label {
            font-size: 12px;
            color: #86868b;
            margin-bottom: 15px;
            display: block;
            text-transform: uppercase;
            letter-spacing: 1.5px;
            font-weight: 600;
            opacity: 0.8;
        }
        .hot-tags {
            display: flex;
            justify-content: center;
            gap: 12px;
            flex-wrap: wrap;
        }
        /* 标签样式：保留多彩，但去掉描边，显得更柔和 */
        .tag-item {
            padding: 10px 24px;
            border-radius: 30px;
            color: #1d1d1f;
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.2s;
            background: #fff; /* 纯白背景 */
            box-shadow: 0 2px 5px rgba(0,0,0,0.03);
        }

        /* 品牌色文字 */
        .tag-apple { color: #d42020; background: #fff; }
        .tag-huawei { color: #ff5500; background: #fff; }
        .tag-xiaomi { color: #d97706; background: #fff; }
        .tag-5g { color: #0071e3; background: #fff; }

        .tag-item:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
        }

        /* 推荐区域分隔 */
        .recommend-section {
            margin-top: 40px;
            /* 这里不需要额外的边框，直接靠间距分隔即可 */
        }
    </style>
</head>
<body>

<div class="container">
    <div class="search-section">
        <div class="search-hero-container">
            <h1 class="search-title">探索你的下一部手机</h1>
            <p class="search-subtitle">输入关键词，快速定位心仪好物。</p>

            <form action="searchByConditionServlet" method="post" id="searchForm">
                <div class="search-box-wrapper">
                    <input type="text" class="search-input" name="searchMess" id="searchInput" placeholder="搜索 iPhone 15 Pro..." required>
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

            <div class="hot-tags-container">
                <span class="tags-label">热门搜索趋势</span>
                <div class="hot-tags">
                    <a href="javascript:quickSearch('Apple')" class="tag-item tag-apple">Apple</a>
                    <a href="javascript:quickSearch('Huawei')" class="tag-item tag-huawei">Huawei</a>
                    <a href="javascript:quickSearch('Xiaomi')" class="tag-item tag-xiaomi">小米</a>
                    <a href="javascript:quickSearch('5G')" class="tag-item tag-5g">5G手机</a>
                </div>
            </div>
        </div>
    </div>

    <div class="recommend-section">
        <jsp:include page="hotGoods.jsp" />
    </div>
</div>

<script>
    function changeTip(type) {
        var input = document.getElementById("searchInput");
        if(type === 'price') input.placeholder = "请输入价格区间，如: 3000-5000";
        else if(type === 'version') input.placeholder = "请输入具体型号，如: iPhone 15 Pro";
        else input.placeholder = "搜索手机名称...";
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
