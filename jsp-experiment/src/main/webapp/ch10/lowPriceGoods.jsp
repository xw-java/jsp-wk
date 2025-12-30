<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="javax.sql.DataSource" %>
<%@ page import="javax.naming.Context" %>
<%@ page import="javax.naming.InitialContext" %>

<div style="margin-top: 50px;">
    <h3 style="border-left: 5px solid #4cd964; padding-left: 15px; margin-bottom: 25px; color: #1d1d1f;">💰 超值低价推荐</h3>
    <div class="goods-grid">
        <%
            Connection lowCon = null;
            Statement lowSql = null;
            ResultSet lowRs = null;
            try {
                Context context = new InitialContext();
                Context contextNeeded = (Context) context.lookup("java:comp/env");
                DataSource ds = (DataSource) contextNeeded.lookup("mobileConn");
                lowCon = ds.getConnection();
                lowSql = lowCon.createStatement();
                // 查询价格最低的4款
                String lowQuery = "SELECT * FROM mobileForm ORDER BY mobile_price ASC LIMIT 4";
                lowRs = lowSql.executeQuery(lowQuery);
                while (lowRs.next()) {
                    String id = lowRs.getString("mobile_version");
                    String name = lowRs.getString("mobile_name");
                    String pic = lowRs.getString("mobile_pic");
                    float price = lowRs.getFloat("mobile_price");
        %>
        <div class="product-card">
            <div class="product-img">
                <a href="showDetail.jsp?mobileID=<%=id%>">
                    <img src="image/<%=pic%>" onerror="this.src='image/default.png'" alt="<%=name%>">
                </a>
            </div>
            <div class="product-body">
                <div style="font-weight: bold; margin-bottom: 5px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;"><%=name%></div>
                <div class="product-price" style="color: #4cd964;">¥ <%=price%></div>
                <a href="showDetail.jsp?mobileID=<%=id%>" class="btn btn-outline" style="width: 100%; margin-top: 10px; border-color: #4cd964; color: #4cd964;">查看详情</a>
            </div>
        </div>
        <%
                }
            } catch (Exception e) {
            } finally {
                try { if(lowRs!=null) lowRs.close(); if(lowSql!=null) lowSql.close(); if(lowCon!=null) lowCon.close(); } catch(Exception e){}
            }
        %>
    </div>
</div>
