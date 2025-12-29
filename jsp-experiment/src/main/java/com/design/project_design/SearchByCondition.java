package com.design.project_design;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SearchByCondition extends HttpServlet {
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
    }

    public void service(HttpServletRequest request,
                        HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("utf-8");
        HttpSession session = request.getSession(true);
        String searchMess = request.getParameter("searchMess");
        String radioMess = request.getParameter("radio");

        if (searchMess == null || searchMess.trim().isEmpty()) {
            response.setContentType("text/html;charset=utf-8");
            response.getWriter().print("<script>alert('请输入查询信息');window.location='searchMobile.jsp';</script>");
            return;
        }

        if (radioMess == null) {
            radioMess = "mobile_name";
        }

        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        // 构建基础 SQL
        StringBuilder sqlBuilder = new StringBuilder();
        sqlBuilder.append("SELECT mobile_version, mobile_name, mobile_made, mobile_price, mobile_pic FROM mobileForm WHERE 1=1 ");

        List<Object> params = new ArrayList<>();

        // 根据条件动态构建 SQL
        try {
            if (radioMess.contains("mobile_version")) {
                sqlBuilder.append("AND mobile_version = ?");
                params.add(searchMess.trim());
            } else if (radioMess.contains("mobile_name")) {
                sqlBuilder.append("AND mobile_name LIKE ?");
                params.add("%" + searchMess.trim() + "%");
            } else if (radioMess.contains("mobile_price")) {
                String[] priceMess = searchMess.split("[- ]+");
                if (priceMess.length >= 2) {
                    float min = Float.parseFloat(priceMess[0]);
                    float max = Float.parseFloat(priceMess[1]);
                    sqlBuilder.append("AND mobile_price >= ? AND mobile_price <= ?");
                    params.add(min);
                    params.add(max);
                } else {
                    throw new NumberFormatException("价格格式不正确");
                }
            }
        } catch (NumberFormatException e) {
            response.setContentType("text/html;charset=utf-8");
            response.getWriter().print("<script>alert('价格格式错误，请输入如 1000-2000');window.location='searchMobile.jsp';</script>");
            return;
        }

        Record_Bean dataBean = null;
        try {
            dataBean = (Record_Bean) session.getAttribute("dataBean");
            if (dataBean == null) {
                dataBean = new Record_Bean();
                session.setAttribute("dataBean", dataBean);
            }
        } catch (Exception exp) {
            dataBean = new Record_Bean();
            session.setAttribute("dataBean", dataBean);
        }

        try {
            Context context = new InitialContext();
            Context contextNeeded = (Context) context.lookup("java:comp/env");
            DataSource ds = (DataSource) contextNeeded.lookup("mobileConn");
            con = ds.getConnection();

            // 使用 PreparedStatement (安全)
            pstmt = con.prepareStatement(sqlBuilder.toString(), ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);

            // 填充参数
            for (int i = 0; i < params.size(); i++) {
                pstmt.setObject(i + 1, params.get(i));
            }

            rs = pstmt.executeQuery();
            ResultSetMetaData metaData = rs.getMetaData();
            int columnCount = metaData.getColumnCount();

            rs.last();
            int rows = rs.getRow();

            // 如果没有查到数据
            if (rows == 0) {
                dataBean.setTableRecord(null);
            } else {
                String[][] tableRecord = new String[rows][columnCount];
                rs.beforeFirst();
                int i = 0;
                while (rs.next()) {
                    for (int k = 0; k < columnCount; k++)
                        tableRecord[i][k] = rs.getString(k + 1);
                    i++;
                }
                dataBean.setTableRecord(tableRecord);
            }

            con.close();
            response.sendRedirect("byPageShow.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().print("查询出错: " + e.getMessage());
        } finally {
            // 标准资源关闭写法
            try { if(rs != null) rs.close(); } catch (Exception e) {}
            try { if(pstmt != null) pstmt.close(); } catch (Exception e) {}
            try { if(con != null) con.close(); } catch (Exception e) {}
        }
    }
}
