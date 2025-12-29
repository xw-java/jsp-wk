package com.design.project_design;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.sql.DataSource;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class HandleRegister extends HttpServlet {
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
    }

    public void service(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("utf-8");

        // 获取表单数据
        String logname = request.getParameter("logname");
        String password = request.getParameter("password");
        String realname = request.getParameter("realname");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");

        // 简单的数据校验
        if (logname == null || logname.trim().length() == 0 ||
                password == null || password.trim().length() == 0) {
            fail(request, response, "用户名或密码不能为空");
            return;
        }

        // 密码加密
        String encryptedPassword = Encrypt.encrypt(password.trim(), "javajsp");

        Connection con = null;
        PreparedStatement pstmt = null;

        try {
            Context context = new InitialContext();
            Context contextNeeded = (Context) context.lookup("java:comp/env");
            DataSource ds = (DataSource) contextNeeded.lookup("mobileConn");
            con = ds.getConnection();

            // 1. 使用 PreparedStatement 插入数据 (防止SQL注入)
            String insertSQL = "insert into user(logname, password, realname, phone, address) values(?,?,?,?,?)";
            pstmt = con.prepareStatement(insertSQL);
            pstmt.setString(1, logname.trim());
            pstmt.setString(2, encryptedPassword);
            pstmt.setString(3, realname);
            pstmt.setString(4, phone);
            pstmt.setString(5, address);

            int result = pstmt.executeUpdate();
            if (result > 0) {
                // 2. 注册成功 -> 重定向到登录页面 (带上成功消息)
                // 也可以把成功消息存入 session
                request.getSession().setAttribute("loginBean", new Login()); // 初始化bean防止空指针
                Login loginBean = (Login) request.getSession().getAttribute("loginBean");
                loginBean.setBackNews("注册成功，请直接登录");

                response.sendRedirect("login.jsp");
            } else {
                fail(request, response, "注册失败，请重试");
            }

        } catch (SQLException exp) {
            // 捕获主键冲突（用户名重复）
            if (exp.getErrorCode() == 1062 || exp.getMessage().contains("Duplicate")) {
                fail(request, response, "该用户名已被使用，请更换一个");
            } else {
                fail(request, response, "数据库错误：" + exp.getMessage());
            }
        } catch (NamingException exp) {
            fail(request, response, "数据源配置错误：" + exp.getMessage());
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (con != null) con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    // 统一的错误处理方法 (MVC模式：转发回JSP显示)
    private void fail(HttpServletRequest request, HttpServletResponse response, String msg)
            throws ServletException, IOException {
        request.setAttribute("registerError", msg);
        // 回填用户输入的数据，提升体验 (密码除外)
        request.setAttribute("old_logname", request.getParameter("logname"));
        request.setAttribute("old_realname", request.getParameter("realname"));
        request.setAttribute("old_phone", request.getParameter("phone"));
        request.setAttribute("old_address", request.getParameter("address"));

        RequestDispatcher dispatcher = request.getRequestDispatcher("inputRegisterMess.jsp");
        dispatcher.forward(request, response);
    }
}