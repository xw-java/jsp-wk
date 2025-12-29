<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.design.project_design.Login" %>
<%@ page import="javax.sql.DataSource" %>
<%@ page import="javax.naming.Context" %>
<%@ page import="javax.naming.InitialContext" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<jsp:useBean id="loginBean" class="com.design.project_design.Login" scope="session"/>
<!DOCTYPE html>
<html>
<head>
    <%@ include file="head.txt" %>
    <title>商品详情</title>
    <style>
        /* 评论区专用样式 */
        .comment-section { margin-top: 40px; background: #fff; padding: 30px; border-radius: 12px; box-shadow: 0 4px 24px rgba(0, 0, 0, 0.04); }
        .comment-list { margin-top: 20px; }
        .comment-item { border-bottom: 1px solid #f0f0f0; padding: 20px 0; display: flex; gap: 15px; }
        .comment-avatar { width: 40px; height: 40px; background: #f0f2f5; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 20px; }
        .comment-content { flex: 1; }
        .comment-user { font-weight: 600; font-size: 14px; color: #333; }
        .comment-time { font-size: 12px; color: #999; margin-left: 10px; }
        .comment-text { margin-top: 8px; color: #555; line-height: 1.6; }

        .comment-form textarea { width: 100%; padding: 15px; border: 1px solid #ddd; border-radius: 8px; resize: vertical; min-height: 100px; font-family: inherit; margin-bottom: 10px; box-sizing: border-box;}
        .comment-form textarea:focus { border-color: var(--accent-color); outline: none; }
    </style>
</head>
<body>
<div class="container">
    <%
        // 1. 获取 mobileID
        String mobileID = request.getParameter("mobileID");
        if (mobileID == null) {
            out.print("<div class='container'><div class='card'>无效的商品ID</div></div>");
            return;
        }

        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            Context context = new InitialContext();
            Context contextNeeded = (Context) context.lookup("java:comp/env");
            DataSource ds = (DataSource) contextNeeded.lookup("mobileConn");
            con = ds.getConnection();

            // 2. 查询商品详情 (使用 PreparedStatement 防止 SQL 注入)
            String sql = "SELECT * FROM mobileForm where mobile_version = ?";
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, mobileID);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                String name = rs.getString(2);
                String maker = rs.getString(3);
                float price = rs.getFloat(4);
                String msg = rs.getString(5);
                String pic = rs.getString(6);
    %>

    <div class="card">
        <div style="display: flex; gap: 50px; flex-wrap: wrap;">
            <div style="flex: 1; min-width: 300px; display: flex; justify-content: center; align-items: center; background: #fafafa; border-radius: 20px; padding: 40px; position: relative;">
                <div style="position: absolute; top: 20px; left: 20px; background: #333; color: white; padding: 4px 12px; border-radius: 4px; font-size: 12px; font-weight: bold;">自营</div>
                <img src="image/<%=pic%>" onerror="this.src='image/default.png'"
                     style="max-width: 100%; max-height: 400px; object-fit: contain; filter: drop-shadow(0 15px 30px rgba(0,0,0,0.1)); transition: transform 0.3s;"
                     onmouseover="this.style.transform='scale(1.1)'" onmouseout="this.style.transform='scale(1.0)'">
            </div>

            <div style="flex: 1; min-width: 300px; display: flex; flex-direction: column; justify-content: center;">
                <div style="margin-bottom: 15px;">
                    <span style="color: #999; font-size: 14px; background: #eee; padding: 2px 8px; border-radius: 4px;">型号: <%=mobileID%></span>
                </div>
                <h1 style="font-size: 36px; margin: 0 0 15px 0; line-height: 1.2; font-weight: 800; color: #1d1d1f;"><%=name%></h1>
                <div style="color: #666; margin-bottom: 25px; font-size: 16px;">
                    制造商: <b><%=maker%></b>
                </div>

                <div style="background: linear-gradient(90deg, #f8f9fa 0%, #fff 100%); padding: 25px; border-radius: 12px; margin-bottom: 30px; border: 1px solid #eee; border-left: 4px solid #333;">
                    <div style="font-size: 14px; color: #86868b; margin-bottom: 5px;">官方活动价</div>
                    <div style="font-size: 48px; color: #333; font-weight: 800; display: flex; align-items: baseline;">
                        <span style="font-size: 24px; margin-right: 5px;">¥</span><%=price%>
                    </div>
                </div>

                <div style="margin-bottom: 40px;">
                    <h4 style="margin: 0 0 10px 0; font-size: 18px; color: #1d1d1f;">📋 商品简介</h4>
                    <p style="color: #666; line-height: 1.8; font-size: 15px; text-align: justify;"><%=msg%></p>
                </div>

                <div style="display: flex; gap: 20px;">
                    <%--
                        【重要修改】使用 POST 表单提交“加入购物车”，
                        彻底解决中文参数乱码导致“加入失败”的问题
                    --%>
                    <form action="putGoodsServlet" method="post" style="display: inline; flex: 2;">
                        <input type="hidden" name="mobileID" value="<%=mobileID%>">
                        <button type="submit" class="btn btn-primary" style="width: 100%; padding: 18px; font-size: 18px; display: flex; align-items: center; justify-content: center; gap: 10px; border: none; cursor: pointer;">
                            🛒 立即加入购物车
                        </button>
                    </form>

                    <a href="javascript:history.back()" class="btn btn-outline" style="flex: 1; padding: 18px; font-size: 18px; text-align: center; display: flex; align-items: center; justify-content: center; text-decoration: none;">
                        返回
                    </a>
                </div>
            </div>
        </div>
    </div>

    <div class="comment-section">
        <h3 style="margin-bottom: 20px;">📝 用户评价</h3>

        <div class="comment-form">
            <% if (loginBean != null && loginBean.getLogname() != null) { %>
            <form action="commentServlet" method="post">
                <input type="hidden" name="mobileID" value="<%=mobileID%>">
                <textarea name="content" placeholder="分享您的使用体验..." required></textarea>
                <button type="submit" class="btn btn-primary" style="float: right; border: none;">发表评价</button>
                <div style="clear: both;"></div>
            </form>
            <% } else { %>
            <div style="background: #f9f9f9; padding: 15px; text-align: center; border-radius: 8px; color: #666;">
                请 <a href="login.jsp" style="color: #333; font-weight: bold;">登录</a> 后参与评论
            </div>
            <% } %>
        </div>

        <div class="comment-list">
            <%
                // 查询该商品的所有评论
                String commentSql = "SELECT * FROM comments WHERE goodsId = ? ORDER BY commentDate DESC";
                PreparedStatement commentStmt = con.prepareStatement(commentSql);
                commentStmt.setString(1, mobileID);
                ResultSet commentRs = commentStmt.executeQuery();

                boolean hasComments = false;
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");

                while(commentRs.next()) {
                    hasComments = true;
                    String cUser = commentRs.getString("logname");
                    String cContent = commentRs.getString("content");
                    Timestamp cDate = commentRs.getTimestamp("commentDate");
            %>
            <div class="comment-item">
                <div class="comment-avatar">👤</div>
                <div class="comment-content">
                    <div class="comment-user">
                        <%=cUser%>
                        <span class="comment-time"><%=sdf.format(cDate)%></span>
                    </div>
                    <div class="comment-text"><%=cContent%></div>
                </div>
            </div>
            <%
                }
                if(!hasComments) {
            %>
            <div style="text-align: center; color: #999; padding: 40px 0;">
                暂无评价，快来抢沙发吧！
            </div>
            <%
                }
                if(commentStmt != null) commentStmt.close();
            %>
        </div>
    </div>

    <jsp:include page="hotGoods.jsp" />

    <%
            } else {
                out.print("<div class='card'>商品不存在</div>");
            }
        } catch (Exception e) {
            out.print("<div class='card'>系统繁忙: " + e.getMessage() + "</div>");
        } finally {
            try{if(rs!=null)rs.close(); if(pstmt!=null)pstmt.close(); if(con!=null)con.close();}catch(Exception e){}
        }
    %>
</div>
<div class="footer"><p>Copyright © 2025 Mobile Shop System.</p></div>
</body>
</html>