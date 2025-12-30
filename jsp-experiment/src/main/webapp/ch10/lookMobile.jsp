<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="javax.sql.DataSource" %>
<%@ page import="javax.naming.Context" %>
<%@ page import="javax.naming.InitialContext" %>
<!DOCTYPE html>
<html>
<head>
    <%@ include file="head.txt" %>
    <title>品牌长廊</title>
    <style>
        body { background-color: #ffffff; } /* 纯白背景更显高级 */

        /* 头部样式 */
        .browse-header {
            text-align: center;
            padding: 70px 0 50px;
            background: #fafafa; /* 头部稍微给一点点灰，区分正文 */
            margin-bottom: 40px;
            border-bottom: 1px solid #eee;
        }
        .browse-title {
            font-size: 48px;
            font-weight: 800;
            margin-bottom: 12px;
            color: #1d1d1f;
            letter-spacing: -1px;
        }
        .browse-subtitle {
            font-size: 16px;
            color: #86868b;
            font-weight: 400;
            max-width: 600px;
            margin: 0 auto;
        }

        /* 品牌楼层容器 */
        .brand-floor {
            padding: 50px 0;
            border-bottom: 1px solid #f5f5f7; /* 极淡的分割线 */
            display: flex;
            flex-direction: column;
            gap: 25px;
        }
        .brand-floor:last-child { border-bottom: none; }

        /* 楼层头部：左侧大标题+文案，右侧查看更多 */
        .floor-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-end;
            margin-bottom: 10px;
        }

        .floor-info h3 {
            font-size: 32px;
            font-weight: 700;
            color: #1d1d1f;
            margin: 0 0 8px 0;
        }

        .floor-slogan {
            font-size: 14px;
            color: #6e6e73;
            font-weight: 500;
            letter-spacing: 0.5px;
            position: relative;
            padding-left: 12px;
        }
        /* 装饰线 */
        .floor-slogan::before {
            content: '';
            position: absolute;
            left: 0; top: 50%; transform: translateY(-50%);
            width: 3px; height: 12px;
            background: #1d1d1f; /* 默认黑条 */
        }

        /* 不同品牌的装饰色 */
        .theme-apple .floor-slogan::before { background: #000; }
        .theme-huawei .floor-slogan::before { background: #cf0a2c; }
        .theme-xiaomi .floor-slogan::before { background: #ff6900; }

        /* 楼层内的商品展示带 - 微缩版 */
        .mini-goods-row {
            display: flex;
            gap: 20px;
            overflow-x: auto; /* 允许横向滚动如果屏幕太小 */
            padding: 5px; /* 留出阴影空间 */
        }

        /* 微缩商品卡片 */
        .mini-card {
            flex: 0 0 200px; /* 固定宽度，小巧一点 */
            background: #fff;
            border: 1px solid #f0f0f0;
            border-radius: 16px;
            padding: 20px;
            text-align: center;
            transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
            position: relative;
        }

        .mini-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.06);
            border-color: transparent;
        }

        .mini-img {
            width: 120px;
            height: 120px;
            object-fit: contain;
            margin-bottom: 15px;
            mix-blend-mode: multiply;
        }

        .mini-name {
            font-size: 14px;
            font-weight: 600;
            color: #1d1d1f;
            margin-bottom: 5px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .mini-price {
            font-size: 13px;
            color: #666;
        }

        /* 查看更多按钮样式 */
        .btn-link-more {
            color: #0071e3;
            font-size: 14px;
            font-weight: 600;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 4px;
            transition: gap 0.2s;
            background: none;
            border: none;
            cursor: pointer;
            padding: 0;
        }
        .btn-link-more:hover { gap: 8px; text-decoration: underline; }

        /* 底部浏览全部 */
        .explore-all-section {
            text-align: center;
            padding: 80px 0;
            background: #fbfbfd;
            margin-top: 40px;
        }

        .btn-big-explore {
            background: #1d1d1f;
            color: white;
            padding: 18px 45px;
            border-radius: 40px;
            font-size: 16px;
            font-weight: 600;
            text-decoration: none;
            box-shadow: 0 10px 30px rgba(0,0,0,0.15);
            transition: all 0.3s;
        }
        .btn-big-explore:hover {
            transform: scale(1.05);
            box-shadow: 0 15px 40px rgba(0,0,0,0.25);
        }
    </style>
</head>
<body>

<div class="browse-header">
    <div class="container">
        <h1 class="browse-title">汇聚全球顶尖科技</h1>
        <p class="browse-subtitle">从芯片到像素的极致打磨，每一个品牌，都代表一种对未来的思考。</p>
    </div>
</div>

<div class="container" style="max-width: 960px;"> <%
    Connection con = null;
    Statement stmtCat = null;
    ResultSet rsCat = null;

    try {
        Context context = new InitialContext();
        Context contextNeeded = (Context) context.lookup("java:comp/env");
        DataSource ds = (DataSource) contextNeeded.lookup("mobileConn");
        con = ds.getConnection();

        stmtCat = con.createStatement();
        String catSql = "SELECT * FROM mobileClassify";
        rsCat = stmtCat.executeQuery(catSql);

        while (rsCat.next()) {
            int id = rsCat.getInt("id");
            String category = rsCat.getString("name");

            // --- 核心逻辑：文案与样式匹配 ---
            String slogan = "探索无限可能，触手可及的科技美学。"; // 默认文案
            String themeClass = "";

            if(category.toLowerCase().contains("apple") || category.toLowerCase().contains("ios")) {
                slogan = "独一无二的 iOS 体验，强悍性能，优雅呈现。";
                themeClass = "theme-apple";
            } else if(category.toLowerCase().contains("huawei") || category.contains("华为")) {
                slogan = "构建万物互联的智能世界，更懂你的智慧伙伴。";
                themeClass = "theme-huawei";
            } else if(category.contains("小米")) {
                slogan = "让每个人都能享受科技的乐趣，为发烧而生。";
                themeClass = "theme-xiaomi";
            } else if(category.toLowerCase().contains("android")) {
                slogan = "开放自由，定义属于你的移动生活方式。";
            }
%>

    <div class="brand-floor <%=themeClass%>">
        <div class="floor-header">
            <div class="floor-info">
                <h3><%=category%></h3>
                <div class="floor-slogan"><%=slogan%></div>
            </div>

            <form action="queryServlet" method="post" style="margin:0;">
                <input type="hidden" name="fenleiNumber" value="<%=id%>">
                <button type="submit" class="btn-link-more">
                    浏览全部 <%=category%> &rarr;
                </button>
            </form>
        </div>

        <div class="mini-goods-row">
            <%
                // 查询该分类下的前 4 个商品，用于预览
                Statement stmtProd = con.createStatement();
                String prodSql = "SELECT * FROM mobileForm WHERE id=" + id + " LIMIT 4";
                ResultSet rsProd = stmtProd.executeQuery(prodSql);

                boolean hasItem = false;
                while(rsProd.next()){
                    hasItem = true;
                    String pId = rsProd.getString("mobile_version");
                    String pName = rsProd.getString("mobile_name");
                    String pPic = rsProd.getString("mobile_pic");
                    float pPrice = rsProd.getFloat("mobile_price");
            %>
            <a href="showDetail.jsp?mobileID=<%=pId%>" style="text-decoration: none;">
                <div class="mini-card">
                    <img src="image/<%=pPic%>" onerror="this.src='image/default.png'" class="mini-img">
                    <div class="mini-name"><%=pName%></div>
                    <div class="mini-price">¥ <%=pPrice%></div>
                </div>
            </a>
            <%
                }
                if(!hasItem) {
            %>
            <div style="color:#999; font-size:14px; padding: 20px;">该系列暂无展示机型</div>
            <%
                }
                rsProd.close();
                stmtProd.close();
            %>
        </div>
    </div>

    <%
            }
        } catch (Exception e) {
            out.print("Error: " + e.getMessage());
        } finally {
            try { if(rsCat!=null) rsCat.close(); if(stmtCat!=null) stmtCat.close(); if(con!=null) con.close(); } catch(Exception e){}
        }
    %>

</div>

<div class="explore-all-section">
    <div class="container">
        <h2 style="font-size: 28px; margin-bottom: 15px;">未找到心仪之选？</h2>
        <p style="color: #666; margin-bottom: 30px;">我们的库中还有更多惊喜等待发现。</p>
        <a href="byPageShow.jsp" class="btn-big-explore">浏览全部机型</a>
    </div>
</div>

<div class="container" style="border-top: 1px solid #eee; margin-top: 0; padding-top: 50px;">
    <h3 style="font-size: 20px; font-weight: 600; margin-bottom: 25px;">猜你喜欢</h3>
    <jsp:include page="hotGoods.jsp" />
</div>

</body>
</html>
