<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <%@ include file="head.txt" %>
    <title>小蜜蜂手机 | 极简选物</title>
    <style>
        .hero {
            padding: 100px 0;
            text-align: center;
            max-width: 700px;
            margin: 0 auto;
        }
        .hero h1 { font-size: 56px; font-weight: 600; margin-bottom: 24px; letter-spacing: -1.5px; }
        .hero p { color: var(--text-secondary); font-size: 21px; margin-bottom: 40px; }

        .section-label {
            font-size: 12px; font-weight: 700; color: var(--text-secondary);
            text-transform: uppercase; letter-spacing: 2px; margin-bottom: 10px; display: block;
        }
    </style>

</head>
<body>

<div class="hero">
    <span class="section-label">New Arrival</span>
    <h1>简单的科技，<br>不简单的体验。</h1>
    <p>我们筛选全球优秀的移动设备，只为提供纯粹的数字生活。</p>
    <div style="display:flex; gap:16px; justify-content:center;">
        <a href="lookMobile.jsp" class="btn btn-primary">立即选购</a>
        <a href="searchMobile.jsp" class="btn btn-outline">搜索型号</a>
    </div>
</div>

<div class="container">
    <span class="section-label">Curated Collection</span>
    <h2 style="font-size: 32px; margin-bottom: 40px;">精选推荐</h2>
    <jsp:include page="hotGoods.jsp" />
</div>

<div class="footer" style="padding: 100px 0; border-top: 1px solid #eee; text-align: center;">
    <p style="color: #888; font-size: 14px;">&copy; 2025 Mobile Shop System. 让科技回归简约。</p>
</div>

</body>
</html>
