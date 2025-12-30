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
    <title>我的购物车</title>
    <style>
        .cart-header {
            display: flex;
            justify-content: space-between; align-items: center;
            margin-bottom: 30px; padding-bottom: 20px; border-bottom: 1px solid #eee;
        }
        .cart-table {
            width: 100%;
            border-collapse: collapse; background: #fff;
            box-shadow: 0 4px 20px rgba(0,0,0,0.05); border-radius: 12px; overflow: hidden;
        }
        .cart-table th {
            background: #f8f9fa;
            text-align: left; padding: 15px 20px;
            color: #666; font-weight: 600; font-size: 14px;
        }
        .cart-table td {
            padding: 20px;
            border-bottom: 1px solid #f0f0f0;
            vertical-align: middle;
        }
        .cart-table tr:last-child td { border-bottom: none; }

        .goods-info { display: flex; align-items: center; gap: 15px; }

        /* 这里的样式是专门给默认图片用的 */
        .goods-img-box {
            width: 60px;
            height: 60px;
            background: #fff;
            border: 1px solid #eee;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
            padding: 5px;
        }
        .goods-img-box img {
            max-width: 100%;
            max-height: 100%;
            object-fit: contain;
        }

        .price-tag { font-weight: bold; color: #333; }
        .amount-badge {
            background: #f0f2f5;
            padding: 4px 12px; border-radius: 12px; font-size: 13px; font-weight: bold;
        }

        .btn-delete {
            color: #ff3b30;
            text-decoration: none; font-size: 14px;
            border: 1px solid rgba(255, 59, 48, 0.3); padding: 6px 14px; border-radius: 16px;
            transition: all 0.2s;
        }
        .btn-delete:hover { background: #ff3b30; color: white; border-color: #ff3b30; }

        .cart-footer {
            margin-top: 30px;
            display: flex; justify-content: flex-end; align-items: center; gap: 30px;
            background: #fff;
            padding: 20px 30px;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.05);
        }
        .total-price { font-size: 24px; font-weight: 800; color: #0071e3; }
        .btn-checkout {
            background: #0071e3;
            color: white; padding: 14px 40px;
            border-radius: 30px; text-decoration: none; font-weight: 600;
            box-shadow: 0 4px 15px rgba(0,113,227,0.3); transition: transform 0.2s;
            border: none; cursor: pointer; font-size: 16px;
        }
        .btn-checkout:hover { transform: translateY(-2px); }

        /* 猜你喜欢分割线 */
        .guess-like-section {
            margin-top: 60px;
            padding-top: 40px;
            border-top: 1px solid #e5e5ea;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="cart-header">
        <h2>🛒 我的购物车</h2>
        <span style="color: #666;">请核对您的商品信息</span>
    </div>

    <%
        if(loginBean == null || loginBean.getLogname() == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        float total = 0;
        boolean isEmpty = true;
        try {
            Context context = new InitialContext();
            Context contextNeeded = (Context) context.lookup("java:comp/env");
            DataSource ds = (DataSource) contextNeeded.lookup("mobileConn");
            con = ds.getConnection();

            // 保持原有的简单查询，不查图片字段
            String sql = "SELECT * FROM shoppingForm WHERE logname = ?";
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, loginBean.getLogname());
            rs = pstmt.executeQuery();
    %>

    <table class="cart-table">
        <thead>
        <tr>
            <th width="45%">商品信息</th>
            <th width="15%">单价</th>
            <th width="10%">数量</th>
            <th width="15%">小计</th>
            <th width="15%">操作</th>
        </tr>
        </thead>
        <tbody>
        <%
            while(rs.next()) {
                isEmpty = false;
                int id = rs.getInt("cartId");
                String goodsId = rs.getString("goodsId");
                String goodsName = rs.getString("goodsName");
                float price = rs.getFloat("goodsPrice");
                int amount = rs.getInt("goodsAmount");

                float subTotal = price * amount;
                total += subTotal;
        %>
        <tr>
            <td>
                <div class="goods-info">
                    <%-- 修改点：直接显示写死的 default.png --%>
                    <div class="goods-img-box">
                        <img src="image/default.png" alt="商品默认图">
                    </div>
                    <div>
                        <div style="font-weight: 600; color: #1d1d1f;"><%=goodsName%></div>
                        <div style="font-size: 12px; color: #86868b; margin-top: 4px;">型号: <%=goodsId%></div>
                    </div>
                </div>
            </td>
            <td class="price-tag">¥<%=price%></td>
            <td><span class="amount-badge">x <%=amount%></span></td>
            <td style="color: #0071e3; font-weight: 600;">¥<%=subTotal%></td>
            <td>
                <a href="deleteServlet?cartId=<%=id%>" class="btn-delete" onclick="return confirm('确定要移出购物车吗？')">移除</a>
            </td>
        </tr>
        <%
                }
            } catch(Exception e) {
                out.print("<tr><td colspan='5'>加载失败：" + e.getMessage() + "</td></tr>");
            } finally {
                try { if(rs!=null)rs.close(); if(pstmt!=null)pstmt.close(); if(con!=null)con.close(); } catch(Exception e){}
            }
        %>
        </tbody>
    </table>

    <%-- 找到空状态判断区域，修改 href --%>
    <% if(isEmpty) { %>
    <div style="text-align: center; padding: 80px; color: #999;">
        <div style="font-size: 64px; margin-bottom: 20px; opacity: 0.3;">🛒</div>
        <p style="font-size: 18px;">购物车空空如也</p>
        <a href="byPageShow.jsp" style="display: inline-block; margin-top: 15px; color: #0071e3; text-decoration: none; font-weight: 500;">去逛逛选购心仪商品 &rarr;</a>
    </div>
    <% } else { %>
    <div class="cart-footer">
        <div style="text-align: right;">
            <div style="color: #666; font-size: 14px; margin-bottom: 5px;">总计金额</div>
            <div class="total-price">¥<%=total%></div>
        </div>
        <form action="buyServlet" method="post" style="margin: 0;">
            <button type="submit" class="btn-checkout">立即结算</button>
        </form>
    </div>
    <% } %>

    <%-- 底部增加猜你喜欢模块 --%>
    <div class="guess-like-section">
        <jsp:include page="hotGoods.jsp" />
    </div>

</div>
<div class="footer"><p>Copyright © 2025 Mobile Shop System.</p></div>
</body>
</html>
