<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="javax.sql.DataSource" %>
<%@ page import="javax.naming.Context" %>
<%@ page import="javax.naming.InitialContext" %>
<%@ page import="javax.sql.rowset.CachedRowSet" %>
<%@ page import="javax.sql.rowset.RowSetProvider" %>
<%@ page import="javax.sql.rowset.RowSetFactory" %>
<jsp:useBean id="loginBean" class="com.design.project_design.Login" scope="session"/>
<!DOCTYPE html>
<html>
<head>
    <%@ include file="head.txt" %>
    <title>全部机型 - 小蜜蜂手机网</title>
    <style>
        body { background-color: #f5f5f7; }

        .page-hero {
            text-align: center;
            padding: 50px 0;
            background: #fff;
            margin-bottom: 40px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.03);
        }
        .page-title {
            font-size: 36px;
            font-weight: 800;
            color: #1d1d1f;
            margin-bottom: 10px;
        }
        .page-subtitle { color: #86868b; }

        .goods-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
            gap: 30px;
            margin-bottom: 60px;
        }

        .product-card {
            background: #fff;
            border-radius: 20px;
            overflow: hidden;
            transition: all 0.3s ease;
            position: relative;
            border: 1px solid rgba(0,0,0,0.04);
            display: flex;
            flex-direction: column;
        }
        .product-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 15px 30px rgba(0,0,0,0.1);
        }

        .img-wrapper {
            padding: 30px;
            background: #fbfbfd;
            height: 220px;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .img-wrapper img {
            max-width: 100%;
            max-height: 100%;
            object-fit: contain;
            mix-blend-mode: multiply;
            transition: transform 0.3s;
        }
        .product-card:hover .img-wrapper img { transform: scale(1.08); }

        .card-body {
            padding: 20px;
            flex: 1;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        .goods-name {
            font-size: 16px;
            font-weight: 600;
            color: #1d1d1f;
            margin-bottom: 8px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .goods-price {
            font-size: 18px;
            color: #e4393c;
            font-weight: 700;
            margin-bottom: 15px;
        }

        .action-row {
            display: flex;
            gap: 10px;
            margin-top: auto;
        }

        .btn-detail {
            flex: 1;
            text-align: center;
            padding: 10px;
            border: 1px solid #e5e5ea;
            border-radius: 12px;
            color: #1d1d1f;
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.2s;
        }
        .btn-detail:hover { background: #f5f5f7; border-color: #d1d1d6; }

        .btn-add-cart {
            padding: 10px 16px;
            background: #0071e3;
            color: white;
            border: none;
            border-radius: 12px;
            cursor: pointer;
            transition: all 0.2s;
            font-size: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .btn-add-cart:hover { background: #0077ed; transform: scale(1.05); }

        .pagination {
            display: flex;
            justify-content: center;
            gap: 10px;
            margin-bottom: 60px;
        }
        .page-link {
            padding: 10px 20px;
            background: #fff;
            border: 1px solid #e5e5ea;
            border-radius: 10px;
            color: #1d1d1f;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.2s;
        }
        .page-link:hover { background: #f5f5f7; }
        .page-info {
            display: flex;
            align-items: center;
            color: #86868b;
            font-size: 14px;
        }
    </style>
</head>
<body>

<div class="page-hero">
    <div class="container">
        <h1 class="page-title">全部机型</h1>
        <p class="page-subtitle">精心甄选，总有一款适合你</p>
    </div>
</div>

<div class="container">
    <div class="goods-grid">
        <%
            // 定义分页参数
            int pageSize = 8; // 每页显示8个
            int currentPage = 1;
            String pageStr = request.getParameter("showPage");
            if (pageStr != null && !pageStr.isEmpty()) {
                try { currentPage = Integer.parseInt(pageStr); } catch (NumberFormatException e) {}
            }

            CachedRowSet rowSet = null;
            int totalPages = 1;

            try {
                Context context = new InitialContext();
                Context contextNeeded = (Context) context.lookup("java:comp/env");
                DataSource ds = (DataSource) contextNeeded.lookup("mobileConn");
                Connection con = ds.getConnection();

                Statement stmt = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet rs = stmt.executeQuery("SELECT * FROM mobileForm ORDER BY mobile_price ASC");

                RowSetFactory factory = RowSetProvider.newFactory();
                rowSet = factory.createCachedRowSet();

                rowSet.populate(rs);
                con.close(); // 数据缓存后关闭连接

                // 【修复点：删除了 rowSet.pageSize = pageSize; 这一行】
                int totalRows = rowSet.size();
                totalPages = (int) Math.ceil((double) totalRows / pageSize);

                if (currentPage > totalPages) currentPage = totalPages;
                if (currentPage < 1) currentPage = 1;

                if (totalPages > 0) {
                    // 移动游标到当前页的第一条
                    if(rowSet.absolute((currentPage - 1) * pageSize + 1)) {
                        // 循环输出当前页的数据
                        rowSet.previous();

                        int count = 0;
                        while (rowSet.next() && count < pageSize) {
                            count++;
                            String id = rowSet.getString("mobile_version");
                            String name = rowSet.getString("mobile_name");
                            float price = rowSet.getFloat("mobile_price");
                            String pic = rowSet.getString("mobile_pic");
        %>

        <div class="product-card">
            <div class="img-wrapper">
                <a href="showDetail.jsp?mobileID=<%=id%>">
                    <img src="image/<%=pic%>" onerror="this.src='image/default.png'" alt="<%=name%>">
                </a>
            </div>
            <div class="card-body">
                <div>
                    <div class="goods-name" title="<%=name%>"><%=name%></div>
                    <div class="goods-price">¥ <%=price%></div>
                </div>

                <div class="action-row">
                    <a href="showDetail.jsp?mobileID=<%=id%>" class="btn-detail">查看详情</a>

                    <%-- 加入购物车表单 --%>
                    <form action="putGoodsToCarServlet" method="post" style="margin:0;">
                        <input type="hidden" name="mobileID" value="<%=id%>">
                        <button type="submit" class="btn-add-cart" title="加入购物车">
                            🛒
                        </button>
                    </form>
                </div>
            </div>
        </div>

        <%
                        }
                    }
                }
            } catch (Exception e) {
                out.print("<div style='grid-column: 1/-1; padding: 20px; background: #fff2f2; color: red; border-radius: 10px;'>");
                out.print("<h3>⚠️ 抱歉，加载数据时出现问题</h3>");
                out.print("<p>错误信息: " + e.toString() + "</p>");
                e.printStackTrace(new java.io.PrintWriter(out));
                out.print("</div>");
            }
        %>
    </div>

    <% if (totalPages > 1) { %>
    <div class="pagination">
        <% if (currentPage > 1) { %>
        <a href="byPageShow.jsp?showPage=<%=currentPage-1%>" class="page-link">&larr; 上一页</a>
        <% } %>

        <span class="page-info">第 <%=currentPage%> / <%=totalPages%> 页</span>

        <% if (currentPage < totalPages) { %>
        <a href="byPageShow.jsp?showPage=<%=currentPage+1%>" class="page-link">下一页 &rarr;</a>
        <% } %>
    </div>
    <% } %>

</div>

<div class="footer" style="padding: 60px 0; border-top: 1px solid #eee; text-align: center;">
    <p style="color: #888; font-size: 14px;">&copy; 2025 Mobile Shop System. 让科技回归简约。</p>
</div>

</body>
</html>
