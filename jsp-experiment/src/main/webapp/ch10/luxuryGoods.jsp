<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="javax.sql.DataSource" %>
<%@ page import="javax.naming.Context" %>
<%@ page import="javax.naming.InitialContext" %>

<div style="margin-top: 60px;">
    <h3 style="border-left: 5px solid #ffcc00; padding-left: 15px; margin-bottom: 25px; color: #1d1d1f;">💎 高档奢侈甄选</h3>
    <div class="goods-grid">
        <%
            Connection luxCon = null;
            Statement luxSql = null;
            ResultSet luxRs = null;
            try {
                Context context = new InitialContext();
                Context contextNeeded = (Context) context.lookup("java:comp/env");
                DataSource ds = (DataSource) contextNeeded.lookup("mobileConn");
                luxCon = ds.getConnection();
                luxSql = luxCon.createStatement();
                // 查询价格最高的4款
                String luxQuery = "SELECT * FROM mobileForm ORDER BY mobile_price DESC LIMIT 4";
                luxRs = luxSql.executeQuery(luxQuery);
                while (luxRs.next()) {
                    String id = luxRs.getString("mobile_version");
                    String name = luxRs.getString("mobile_name");
                    String pic = luxRs.getString("mobile_pic");
                    float price = luxRs.getFloat("mobile_price");
        %>
        <div class="product-card" style="border: 1px solid rgba(212, 175, 55, 0.2);">
            <div class="product-img">
                <a href="showDetail.jsp?mobileID=<%=id%>">
                    <img src="image/<%=pic%>" onerror="this.src='image/default.png'" alt="<%=name%>">
                </a>
            </div>
            <div class="product-body">
                <div style="font-weight: bold; margin-bottom: 5px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;"><%=name%></div>
                <div class="product-price" style="color: #d4af37;">¥ <%=price%></div>
                <a href="showDetail.jsp?mobileID=<%=id%>" class="btn btn-outline" style="width: 100%; margin-top: 10px; border-color: #d4af37; color: #998a00;">尊享详情</a>
            </div>
        </div>
        <%
                }
            } catch (Exception e) {
            } finally {
                try { if(luxRs!=null) luxRs.close(); if(luxSql!=null) luxSql.close(); if(luxCon!=null) luxCon.close(); } catch(Exception e){}
            }
        %>
    </div>
</div>
