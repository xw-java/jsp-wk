package com.design.project_design;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import java.sql.*;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class HandleDelete extends HttpServlet {
    public void service(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("utf-8");

        // 获取要删除的购物车记录ID (主键)
        String cartIdStr = request.getParameter("cartId");

        // 校验登录
        HttpSession session = request.getSession();
        Login loginBean = (Login) session.getAttribute("loginBean");
        if (loginBean == null || loginBean.getLogname() == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        if (cartIdStr == null || cartIdStr.trim().isEmpty()) {
            response.sendRedirect("lookShoppingCar.jsp");
            return;
        }

        Connection con = null;
        PreparedStatement pstmt = null;

        try {
            Context context = new InitialContext();
            Context contextNeeded = (Context) context.lookup("java:comp/env");
            DataSource ds = (DataSource) contextNeeded.lookup("mobileConn");
            con = ds.getConnection();

            // 使用 cartId 精准删除
            String sql = "DELETE FROM shoppingForm WHERE cartId = ?";
            pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, Integer.parseInt(cartIdStr));

            pstmt.executeUpdate();

            // 删除完成后，跳回购物车页面
            response.sendRedirect("lookShoppingCar.jsp");

        } catch (Exception e) {
            response.getWriter().print("删除失败：" + e.getMessage());
        } finally {
            try { if(pstmt!=null)pstmt.close(); if(con!=null)con.close(); } catch(Exception e){}
        }
    }
}