<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="javax.sql.DataSource" %>
<%@ page import="javax.naming.Context" %>
<%@ page import="javax.naming.InitialContext" %>
<jsp:useBean id="loginBean" class="com.design.project_design.Login" scope="session"/>
<!DOCTYPE html>
<html>
<head>
    <%@ include file="head.txt" %>
    <title>我的订单</title>
    <style>
        body { background-color: #f5f5f7; }
        .order-container { max-width: 800px; margin: 60px auto; padding: 0 20px; }

        .page-header { margin-bottom: 40px; text-align: center; }
        .page-header h2 { font-size: 32px; font-weight: 700; color: #1d1d1f; margin-bottom: 10px; }
        .page-header p { color: #86868b; font-size: 16px; }

        .order-card {
            background: #fff; border-radius: 18px; box-shadow: 0 4px 20px rgba(0, 0, 0, 0.04);
            margin-bottom: 30px; overflow: hidden; border: 1px solid rgba(0,0,0,0.02);
            transition: transform 0.2s;
        }
        .order-card:hover { transform: translateY(-2px); box-shadow: 0 8px 30px rgba(0, 0, 0, 0.08); }

        .card-header {
            padding: 20px 30px; border-bottom: 1px solid #f0f0f0;
            display: flex; justify-content: space-between; align-items: center; background: #fafafc;
        }
        .order-id { font-size: 16px; font-weight: 600; color: #1d1d1f; }
        .order-badge {
            background: #e4fbf0; color: #0f8750; padding: 6px 12px; border-radius: 20px;
            font-size: 13px; font-weight: 600;
        }

        .card-body { padding: 30px; }
        .receipt-box {
            background: #fbfbfd; border: 1px dashed #d2d2d7; border-radius: 12px;
            padding: 20px; font-family: 'Menlo', monospace; font-size: 14px;
            color: #424245; line-height: 1.8; white-space: pre-wrap;
        }

        .empty-state { text-align: center; padding: 100px 0; color: #86868b; }
        .btn-go-shop {
            display: inline-block; margin-top: 20px; padding: 12px 30px;
            background: #0071e3; color: white; border-radius: 20px; text-decoration: none; font-weight: 600;
        }
    </style>
</head>
<body>

<div class="container">
    <div class="order-container">
        <div class="page-header">
            <h2>📦 我的订单历史</h2>
            <p>查看您所有的购买记录和交易详情</p>
        </div>

        <%
            if(loginBean == null || loginBean.getLogname() == null) {
                response.sendRedirect("login.jsp");
                return;
            }

            Connection con = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            boolean hasOrders = false;

            try {
                Context context = new InitialContext();
                Context contextNeeded = (Context) context.lookup("java:comp/env");
                DataSource ds = (DataSource) contextNeeded.lookup("mobileConn");
                con = ds.getConnection();

                String sql = "SELECT * FROM orderForm WHERE logname = ? ORDER BY orderNumber DESC";
                pstmt = con.prepareStatement(sql);
                pstmt.setString(1, loginBean.getLogname());
                rs = pstmt.executeQuery();

                while(rs.next()) {
                    hasOrders = true;
                    int orderId = rs.getInt("orderNumber");
                    String mess = rs.getString("mess");
        %>
        <div class="order-card">
            <div class="card-header">
                <span class="order-id"># 订单号: 20250<%=orderId%></span>
                <span class="order-badge">✅ 已完成</span>
            </div>
            <div class="card-body">
                <div class="receipt-box"><%=mess%></div>
            </div>
        </div>
        <%
            }
            if(!hasOrders) {
        %>
        <div class="empty-state">
            <span style="font-size: 64px; display: block; margin-bottom: 20px;">🍃</span>
            <h3>您还没有产生过订单</h3>
            <a href="index.jsp" class="btn-go-shop">去逛逛</a>
        </div>
        <%
                }
            } catch(Exception e) {
                out.print("<div style='text-align:center; color:red;'>加载失败：" + e.getMessage() + "</div>");
            } finally {
                try { if(rs!=null)rs.close(); if(pstmt!=null)pstmt.close(); if(con!=null)con.close(); } catch(Exception e){}
            }
        %>
    </div>
</div>

<div class="footer" style="padding: 100px 0; border-top: 1px solid #eee; text-align: center;">
    <p style="color: #888; font-size: 14px;">&copy; 2025 Mobile Shop System. 让科技回归简约。</p>
</div>

</body>
</html>