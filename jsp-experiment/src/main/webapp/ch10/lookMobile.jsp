<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="javax.sql.DataSource" %>
<%@ page import="javax.naming.Context" %>
<%@ page import="javax.naming.InitialContext" %>
<!DOCTYPE html>
<html>
<head>
    <%@ include file="head.txt" %>
    <title>手机分类馆</title>
</head>
<body>
<div class="container">
    <div class="card">
        <h2 class="card-title">📱 品牌分类馆</h2>
        <p style="color: #666; margin-bottom: 30px;">汇聚全球顶尖科技，点击品牌探索更多</p>

        <div class="category-grid">
            <%
                Connection con = null;
                Statement sql = null;
                ResultSet rs = null;
                try {
                    Context context = new InitialContext();
                    Context contextNeeded = (Context) context.lookup("java:comp/env");
                    DataSource ds = (DataSource) contextNeeded.lookup("mobileConn");
                    con = ds.getConnection();
                    sql = con.createStatement();

                    // 【新功能】SQL子查询：直接查出分类名 + 该分类下的手机数量
                    String query = "SELECT mc.id, mc.name, (SELECT COUNT(*) FROM mobileForm mf WHERE mf.id = mc.id) as count FROM mobileClassify mc";
                    rs = sql.executeQuery(query);

                    while (rs.next()) {
                        int id = rs.getInt(1);
                        String category = rs.getString(2);
                        int count = rs.getInt(3);

                        // 简单的图标映射逻辑
                        String icon = "📱";
                        String bgClass = "linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%)";

                        if(category.toLowerCase().contains("apple") || category.contains("iOS")) {
                            icon = "🍎";
                        } else if(category.toLowerCase().contains("huawei") || category.contains("android")) {
                            icon = "🏵️";
                        } else if(category.contains("小米")) {
                            icon = "⚡";
                        }
            %>
            <form action="queryServlet" method="post" id="form_<%=id%>" style="margin:0; display: contents;">
                <input type="hidden" name="fenleiNumber" value="<%=id%>">
                <div class="category-card" onclick="document.getElementById('form_<%=id%>').submit()">
                    <div class="category-icon"><%=icon%></div>
                    <h3 style="margin: 0 0 10px 0; font-size: 20px; color: var(--text-main);"><%=category%></h3>
                    <div style="color: #888; font-size: 14px; background: #f0f2f5; display: inline-block; padding: 4px 12px; border-radius: 20px;">
                        共 <b><%=count%></b> 款机型
                    </div>
                    <div style="margin-top: 20px; color: var(--primary-color); font-weight: bold; font-size: 14px; opacity: 0.8;">
                        立即浏览 &rarr;
                    </div>
                </div>
            </form>
            <%
                    }
                } catch (Exception e) {
                    out.print("<div class='alert alert-warning'>数据加载异常: " + e + "</div>");
                } finally {
                    try { if(rs!=null) rs.close(); if(sql!=null) sql.close(); if(con!=null) con.close(); } catch(Exception e){}
                }
            %>
        </div>
    </div>

    <jsp:include page="hotGoods.jsp" />
</div>
</body>
</html>
