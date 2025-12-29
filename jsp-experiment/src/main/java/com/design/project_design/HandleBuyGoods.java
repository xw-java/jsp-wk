package com.design.project_design;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import java.sql.*;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class HandleBuyGoods extends HttpServlet {
    public void service(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("utf-8");

        HttpSession session = request.getSession();
        Login loginBean = (Login) session.getAttribute("loginBean");
        if (loginBean == null || loginBean.getLogname() == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String logname = loginBean.getLogname();
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            Context context = new InitialContext();
            Context contextNeeded = (Context) context.lookup("java:comp/env");
            DataSource ds = (DataSource) contextNeeded.lookup("mobileConn");
            con = ds.getConnection();

            // 【关键】开启事务，确保“生成订单”和“清空购物车”原子性操作
            con.setAutoCommit(false);

            // 1. 查询购物车内容，拼接订单详情字符串
            String sqlSelect = "SELECT goodsName, goodsPrice, goodsAmount FROM shoppingForm WHERE logname = ?";
            pstmt = con.prepareStatement(sqlSelect);
            pstmt.setString(1, logname);
            rs = pstmt.executeQuery();

            StringBuilder orderDetail = new StringBuilder();
            orderDetail.append("订单详情：\n");
            float total = 0;
            boolean hasItems = false;

            while (rs.next()) {
                hasItems = true;
                String name = rs.getString(1);
                float price = rs.getFloat(2);
                int amount = rs.getInt(3);
                float subTotal = price * amount;

                total += subTotal;
                orderDetail.append(name)
                        .append(" (¥").append(price).append(") x ")
                        .append(amount).append("\n");
            }
            orderDetail.append("----------------\n总金额：¥").append(total);
            rs.close();
            pstmt.close();

            if (!hasItems) {
                con.rollback(); // 购物车是空的，回滚
                response.sendRedirect("lookShoppingCar.jsp");
                return;
            }

            // 2. 插入订单表
            String sqlOrder = "INSERT INTO orderForm(logname, mess) VALUES(?, ?)";
            pstmt = con.prepareStatement(sqlOrder);
            pstmt.setString(1, logname);
            pstmt.setString(2, orderDetail.toString());
            pstmt.executeUpdate();
            pstmt.close();

            // 3. 清空该用户的购物车
            String sqlDelete = "DELETE FROM shoppingForm WHERE logname = ?";
            pstmt = con.prepareStatement(sqlDelete);
            pstmt.setString(1, logname);
            pstmt.executeUpdate();

            // 4. 提交事务
            con.commit();

            // 下单成功，跳转到我的订单页
            response.sendRedirect("lookOrderForm.jsp");

        } catch (Exception e) {
            try { if(con!=null) con.rollback(); } catch(Exception rollbackEx){} // 出错回滚
            response.getWriter().print("下单失败：" + e.getMessage());
            e.printStackTrace();
        } finally {
            try { if(con!=null) con.setAutoCommit(true); } catch(Exception e){} // 恢复默认设置
            try { if(rs!=null)rs.close(); if(pstmt!=null)pstmt.close(); if(con!=null)con.close(); } catch(Exception e){}
        }
    }
}