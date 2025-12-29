package com.design.project_design;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.servlet.http.HttpSession;
import javax.sql.DataSource;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement; // 新增：引入PreparedStatement
import java.sql.ResultSet;
import java.sql.SQLException;

public class HandleLogin extends HttpServlet {
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
    }

    public void service(HttpServletRequest request,
                        HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("utf-8");
        Connection con = null;
        PreparedStatement pstmt = null; // 修改：使用PreparedStatement

        String logname = request.getParameter("logname").trim();
        String password = request.getParameter("password").trim();

        // 依然保留加密逻辑
        String encryptedPassword = Encrypt.encrypt(password, "javajsp");

        boolean boo = (logname.length() > 0) && (password.length() > 0);
        try {
            Context context = new InitialContext();
            Context contextNeeded = (Context) context.lookup("java:comp/env");
            DataSource ds = (DataSource) contextNeeded.lookup("mobileConn");
            con = ds.getConnection();

            // 【修改点1】改用 ? 占位符，防止SQL注入
            String sqlStr = "select * from user where logname = ? and password = ?";
            pstmt = con.prepareStatement(sqlStr);
            pstmt.setString(1, logname);
            pstmt.setString(2, encryptedPassword); // 注意这里用加密后的密码

            if (boo) {
                ResultSet rs = pstmt.executeQuery();
                if (rs.next()) {
                    // 登录成功
                    success(request, response, logname, password);
                    response.sendRedirect("index.jsp"); // 登录成功跳转首页
                } else {
                    String backNews = "您输入的用户名不存在,或密码不匹配";
                    fail(request, response, logname, backNews);
                }
            } else {
                String backNews = "请输入用户名和密码";
                fail(request, response, logname, backNews);
            }
        } catch (SQLException exp) {
            String backNews = "数据库操作失败：" + exp;
            fail(request, response, logname, backNews);
        } catch (NamingException exp) {
            String backNews = "没有设置连接池：" + exp;
            fail(request, response, logname, backNews);
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (con != null) con.close();
            } catch (Exception ee) {
                ee.printStackTrace();
            }
        }
    }

    public void success(HttpServletRequest request,
                        HttpServletResponse response,
                        String logname, String password) {
        Login loginBean = null;
        HttpSession session = request.getSession(true);
        try {
            loginBean = (Login) session.getAttribute("loginBean");
            if (loginBean == null) {
                loginBean = new Login();
                session.setAttribute("loginBean", loginBean);
            }
            loginBean.setLogname(logname);
            loginBean.setBackNews(logname + "登录成功");
        } catch (Exception ee) {
            loginBean = new Login();
            session.setAttribute("loginBean", loginBean);
            loginBean.setLogname(logname);
        }
    }

    // 【修改点2】fail方法不再输出HTML，而是转发回login.jsp
    public void fail(HttpServletRequest request,
                     HttpServletResponse response,
                     String logname, String backNews)
            throws ServletException, IOException {

        // 1. 把错误信息存入 request 域（而不是直接打印）
        request.setAttribute("loginError", backNews);

        // 2. 转发回 login.jsp (URL不会变，request数据会带过去)
        // 注意路径：根据你的web.xml，login.jsp在ch10目录下，
        // 但如果Servlet映射在/ch10/下，直接转发文件名即可，或者写绝对路径 /ch10/login.jsp
        RequestDispatcher dispatcher = request.getRequestDispatcher("login.jsp");
        dispatcher.forward(request, response);
    }
}