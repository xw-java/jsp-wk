<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <%@ include file="head.txt" %>
    <title>小蜜蜂手机 | 极简选物</title>
</head>
<body>

<%-- 注意：banner.jsp 被移到了 container 内部 --%>
<div class="container">

    <%-- 1. 顶部轮播图 --%>
    <jsp:include page="banner.jsp" />

    <%-- 2. 精品推荐 --%>
    <jsp:include page="hotGoods.jsp" />

    <%-- 3. 低价推荐 --%>
    <jsp:include page="lowPriceGoods.jsp" />

    <%-- 4. 高档奢侈 --%>
    <jsp:include page="luxuryGoods.jsp" />

    <div style="margin-top: 80px; text-align: center;">
        <a href="lookMobile.jsp" class="btn btn-primary" style="padding: 15px 40px; font-size: 16px;">浏览全部机型</a>
    </div>
</div>

<div class="footer" style="padding: 60px 0; margin-top: 60px; border-top: 1px solid #eee; text-align: center;">
    <p style="color: #888; font-size: 14px;">&copy; 2025 Mobile Shop System. 让科技回归简约。</p>
</div>

</body>
</html>
