package com.design.project_design;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.sql.DataSource;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.Timestamp;

public class HandleComment extends HttpServlet {
    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("utf-8");

        String mobileID = request.getParameter("mobileID");
        String content = request.getParameter("content");

        // 1. 校验登录状态
        HttpSession session = request.getSession();
        Login loginBean = (Login) session.getAttribute("loginBean");
        if (loginBean == null || loginBean.getLogname() == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // 2. 校验输入
        if (content == null || content.trim().isEmpty()) {
            response.sendRedirect("showDetail.jsp?mobileID=" + mobileID);
            return;
        }

        Connection con = null;
        PreparedStatement pstmt = null;
        try {
            Context context = new InitialContext();
            Context contextNeeded = (Context) context.lookup("java:comp/env");
            DataSource ds = (DataSource) contextNeeded.lookup("mobileConn");
            con = ds.getConnection();

            // 3. 插入评论 (使用 PreparedStatement 防止注入)
            String sql = "INSERT INTO comments(logname, goodsId, content, commentDate) VALUES(?, ?, ?, ?)";
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, loginBean.getLogname());
            pstmt.setString(2, mobileID);
            pstmt.setString(3, content);
            pstmt.setTimestamp(4, new Timestamp(System.currentTimeMillis()));

            pstmt.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace(); // 实际项目中应记录日志
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (con != null) con.close();
            } catch (Exception e) {}
        }

        // 4. 跳回详情页
        response.sendRedirect("showDetail.jsp?mobileID=" + mobileID);
    }
}