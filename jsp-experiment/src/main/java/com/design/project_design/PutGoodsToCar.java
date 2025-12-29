package com.design.project_design;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import java.sql.*;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class PutGoodsToCar extends HttpServlet {
    public void service(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("utf-8");

        // 1. 检查登录
        HttpSession session = request.getSession();
        Login loginBean = (Login) session.getAttribute("loginBean");
        if (loginBean == null || loginBean.getLogname() == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String mobileID = request.getParameter("mobileID");
        String logname = loginBean.getLogname();

        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            Context context = new InitialContext();
            Context contextNeeded = (Context) context.lookup("java:comp/env");
            DataSource ds = (DataSource) contextNeeded.lookup("mobileConn");
            con = ds.getConnection();

            // 2. 先查询该商品的信息（价格、名称）
            String sqlInfo = "SELECT mobile_name, mobile_price FROM mobileForm WHERE mobile_version = ?";
            pstmt = con.prepareStatement(sqlInfo);
            pstmt.setString(1, mobileID);
            rs = pstmt.executeQuery();

            String goodsName = "";
            float goodsPrice = 0;

            if (rs.next()) {
                goodsName = rs.getString(1);
                goodsPrice = rs.getFloat(2);
            } else {
                // 商品不存在
                response.sendRedirect("index.jsp");
                return;
            }
            rs.close();
            pstmt.close();

            // 3. 检查购物车里是否已经有该用户的该商品
            String sqlCheck = "SELECT * FROM shoppingForm WHERE logname = ? AND goodsId = ?";
            pstmt = con.prepareStatement(sqlCheck);
            pstmt.setString(1, logname);
            pstmt.setString(2, mobileID);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                // A. 如果有，更新数量 (数量 + 1)
                // 注意：这里需要确保你的 shoppingForm 表里有 goodsAmount 字段
                String sqlUpdate = "UPDATE shoppingForm SET goodsAmount = goodsAmount + 1 WHERE logname = ? AND goodsId = ?";
                // 关闭之前的 ResultSet 和 Statement 以便复用
                rs.close();
                pstmt.close();

                pstmt = con.prepareStatement(sqlUpdate);
                pstmt.setString(1, logname);
                pstmt.setString(2, mobileID);
                pstmt.executeUpdate();
            } else {
                // B. 如果没有，插入新记录
                // 关闭资源
                rs.close();
                pstmt.close();

                String sqlInsert = "INSERT INTO shoppingForm(logname, goodsId, goodsName, goodsPrice, goodsAmount) VALUES(?, ?, ?, ?, 1)";
                pstmt = con.prepareStatement(sqlInsert);
                pstmt.setString(1, logname);
                pstmt.setString(2, mobileID);
                pstmt.setString(3, goodsName);
                pstmt.setFloat(4, goodsPrice);
                pstmt.executeUpdate();
            }

            // 4. 处理完成，跳转到购物车页面查看
            response.sendRedirect("lookShoppingCar.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().print("Error: " + e.getMessage());
        } finally {
            try { if(rs!=null)rs.close(); if(pstmt!=null)pstmt.close(); if(con!=null)con.close(); } catch(Exception e){}
        }
    }
}