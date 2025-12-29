package com.design.project_design;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
// 注意：不要改 java.sql.* 或 javax.naming.*，只改 servlet 相关的
import java.io.IOException;

public class HandleExit  extends HttpServlet {
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
    }
    public void service(HttpServletRequest request,
                        HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(true);
        session.invalidate(); //销毁用户的session对象
        response.sendRedirect("login.jsp"); //返回主页
    }
}
