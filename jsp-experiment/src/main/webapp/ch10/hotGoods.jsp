<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="javax.sql.DataSource" %>
<%@ page import="javax.naming.Context" %>
<%@ page import="javax.naming.InitialContext" %>

<div style="margin-top: 50px;">
    <h3 style="border-left: 5px solid var(--secondary-color); padding-left: 15px; margin-bottom: 25px;">🔥 猜你喜欢</h3>
    <div class="goods-grid">
        <%
            Connection hotCon = null;
            Statement hotSql = null;
            ResultSet hotRs = null;
            try {
                Context context = new InitialContext();
                Context contextNeeded = (Context) context.lookup("java:comp/env");
                DataSource ds = (DataSource) contextNeeded.lookup("mobileConn");
                hotCon = ds.getConnection();
                hotSql = hotCon.createStatement();
                String hotQuery = "SELECT * FROM mobileForm ORDER BY RAND() LIMIT 4";
                hotRs = hotSql.executeQuery(hotQuery);
                while (hotRs.next()) {
                    String h_id = hotRs.getString("mobile_version");
                    String h_name = hotRs.getString("mobile_name");
                    String h_pic = hotRs.getString("mobile_pic");
                    float h_price = hotRs.getFloat("mobile_price");
        %>
        <div class="product-card">
            <div class="product-img">
                <a href="showDetail.jsp?mobileID=<%=h_id%>">
                    <img src="image/<%=h_pic%>" onerror="this.src='image/default.png'" alt="<%=h_name%>">
                </a>
            </div>
            <div class="product-body">
                <div style="font-weight: bold; margin-bottom: 5px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;"><%=h_name%></div>
                <div class="product-price">¥ <%=h_price%></div>
                <a href="showDetail.jsp?mobileID=<%=h_id%>" class="btn btn-outline" style="width: 100%; margin-top: 10px; box-sizing: border-box;">查看详情</a>
            </div>
        </div>
        <%
                }
            } catch (Exception e) {
            } finally {
                try { if(hotRs!=null) hotRs.close(); if(hotSql!=null) hotSql.close(); if(hotCon!=null) hotCon.close(); } catch(Exception e){}
            }
        %>
    </div>
</div>
