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
import java.io.PrintWriter;
import java.sql.*;
import java.text.SimpleDateFormat;

public class HandleChat extends HttpServlet {

    // POST: 处理发送消息
    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("utf-8");
        String content = request.getParameter("content");

        HttpSession session = request.getSession();
        Login loginBean = (Login) session.getAttribute("loginBean");

        if (loginBean == null || loginBean.getLogname() == null || content == null || content.trim().isEmpty()) {
            return;
        }

        Connection con = null;
        PreparedStatement pstmt = null;
        try {
            con = getConnection();
            // 插入消息
            String sql = "INSERT INTO chat_msg(logname, content, sendTime) VALUES(?, ?, ?)";
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, loginBean.getLogname());
            pstmt.setString(2, content);
            pstmt.setTimestamp(3, new Timestamp(System.currentTimeMillis()));
            pstmt.executeUpdate();

            // 同时更新该用户的在线状态（心跳）
            updateHeartbeat(con, loginBean.getLogname());

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            close(con, pstmt, null);
        }
    }

    // GET: 处理获取消息 & 获取用户列表
    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=utf-8");
        PrintWriter out = response.getWriter();

        String action = request.getParameter("action"); // "getMsg" 或 "getUsers"
        HttpSession session = request.getSession();
        Login loginBean = (Login) session.getAttribute("loginBean");

        // 如果未登录，不返回数据
        if (loginBean == null || loginBean.getLogname() == null) return;

        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            con = getConnection();

            // 无论做什么操作，只要前端来请求了，就视为一次“心跳”，更新在线时间
            updateHeartbeat(con, loginBean.getLogname());

            if ("getUsers".equals(action)) {
                // === 获取在线用户列表 ===
                // 逻辑：查找最近 10 秒内有活动的用户
                String sql = "SELECT logname FROM online_users WHERE last_active > NOW() - INTERVAL 10 SECOND";
                pstmt = con.prepareStatement(sql);
                rs = pstmt.executeQuery();
                while(rs.next()){
                    out.print("<div class='user-item'>👤 " + rs.getString(1) + "</div>");
                }
            }
            else {
                // === 获取最新消息 (增量更新) ===
                String lastIdStr = request.getParameter("lastID");
                int lastId = 0;
                try { lastId = Integer.parseInt(lastIdStr); } catch (Exception e) {}

                SimpleDateFormat sdf = new SimpleDateFormat("HH:mm:ss");

                // 只查询 ID 比前端传来的 lastID 大的消息
                String sql = "SELECT * FROM chat_msg WHERE id > ? ORDER BY id ASC";
                pstmt = con.prepareStatement(sql);
                pstmt.setInt(1, lastId);
                rs = pstmt.executeQuery();

                while(rs.next()) {
                    int id = rs.getInt("id");
                    String user = rs.getString("logname");
                    String msg = rs.getString("content");
                    Timestamp time = rs.getTimestamp("sendTime");

                    // 注意：我们在 div 上加了 data-id，方便前端下次知道从哪里开始查
                    out.println("<div class='msg-item' data-id='" + id + "'>");
                    out.println("  <span class='msg-user'>" + user + "</span>");
                    out.println("  <span class='msg-time'>(" + sdf.format(time) + ")</span>");
                    out.println("  <div class='msg-content'>" + msg + "</div>");
                    out.println("</div>");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            close(con, pstmt, rs);
        }
    }

    // 辅助方法：更新心跳时间
    private void updateHeartbeat(Connection con, String logname) throws SQLException {
        // 尝试更新，如果不存在则插入 (MySQL语法: ON DUPLICATE KEY UPDATE)
        String sql = "INSERT INTO online_users (logname, last_active) VALUES (?, NOW()) " +
                "ON DUPLICATE KEY UPDATE last_active = NOW()";
        PreparedStatement pstmt = con.prepareStatement(sql);
        pstmt.setString(1, logname);
        pstmt.executeUpdate();
        pstmt.close();
    }

    private Connection getConnection() throws Exception {
        Context context = new InitialContext();
        Context contextNeeded = (Context) context.lookup("java:comp/env");
        DataSource ds = (DataSource) contextNeeded.lookup("mobileConn");
        return ds.getConnection();
    }

    private void close(Connection con, Statement stmt, ResultSet rs) {
        try { if(rs!=null) rs.close(); if(stmt!=null) stmt.close(); if(con!=null) con.close(); } catch(Exception e){}
    }
}