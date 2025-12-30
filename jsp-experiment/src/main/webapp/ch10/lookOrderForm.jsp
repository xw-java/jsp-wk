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

        /* 订单卡片样式 */
        .order-card {
            background: #fff;
            border-radius: 18px;
            box-shadow: 0 8px 30px rgba(0, 0, 0, 0.06);
            margin-bottom: 30px;
            overflow: hidden;
            border: 1px solid rgba(0,0,0,0.02);
            transition: transform 0.2s;
            position: relative;
        }

        .order-card::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0;
            height: 6px;
            background: linear-gradient(90deg, #0071e3, #4cd964);
        }

        .order-card:hover { transform: translateY(-3px); }

        .card-header {
            padding: 25px 30px 20px;
            border-bottom: 1px solid #f0f0f0;
            display: flex; justify-content: space-between; align-items: center;
            background: #fff;
        }
        .order-id { font-size: 18px; font-weight: 700; color: #1d1d1f; letter-spacing: -0.5px; }
        .order-badge {
            background: #e4fbf0;
            color: #0f8750; padding: 6px 14px; border-radius: 20px;
            font-size: 13px; font-weight: 600;
            display: flex; align-items: center; gap: 5px;
        }

        .card-body { padding: 30px; background: #fafafc; }

        .receipt-box {
            background: #fffcf0;
            border: 1px solid #e6dbb8;
            border-radius: 12px;
            padding: 25px;
            font-family: 'Menlo', 'Monaco', 'Courier New', monospace;
            font-size: 14px;
            color: #5c5c5c;
            line-height: 1.8;
            white-space: pre-wrap;
            position: relative;
            box-shadow: inset 0 2px 10px rgba(0,0,0,0.02);
        }

        .receipt-box::before {
            content: '';
            display: block;
            border-top: 2px dashed #e6dbb8;
            margin-bottom: 15px;
            opacity: 0.5;
        }

        .empty-state { text-align: center; padding: 100px 0; color: #86868b; }
        .btn-go-shop {
            display: inline-block;
            margin-top: 20px; padding: 12px 30px;
            background: #1d1d1f; color: white; border-radius: 20px; text-decoration: none; font-weight: 600;
            transition: all 0.2s;
        }
        .btn-go-shop:hover { background: #333; transform: scale(1.05); }

        /* 新增：猜你喜欢分割区域 */
        .guess-like-section {
            margin-top: 80px;
            padding-top: 40px;
            border-top: 1px solid #e5e5ea;
        }
    </style>
</head>
<body>

<div class="container">
    <div class="order-container">
        <div class="page-header">
            <h2>📦 订单历史</h2>
            <p>查看您的数字消费凭证</p>
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
                <span class="order-id">ORDER #2025<%=String.format("%04d", orderId)%></span>
                <span class="order-badge"><span>✓</span> 已完成交易</span>
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
            <div style="font-size: 64px; margin-bottom: 20px; opacity: 0.3;">📭</div>
            <h3>您还没有产生过订单</h3>
            <p style="margin: 10px 0 30px;">去挑选几件心仪的科技产品吧</p>
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

    <%-- 底部增加猜你喜欢模块 --%>
    <div class="guess-like-section">
        <jsp:include page="hotGoods.jsp" />
    </div>
</div>

<div class="footer" style="padding: 100px 0; border-top: 1px solid #eee; text-align: center;">
    <p style="color: #888; font-size: 14px;">&copy; 2025 Mobile Shop System. 让科技回归简约。</p>
</div>

</body>
</html>
