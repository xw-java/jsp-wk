<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:useBean id="dataBean" class="com.design.project_design.Record_Bean" scope="session"/>
<!DOCTYPE html>
<html>
<head>
    <%@ include file="head.txt" %>
    <title>商品列表</title>
</head>
<body>
<div class="container">
    <jsp:setProperty name="dataBean" property="pageSize" param="pageSize"/>
    <jsp:setProperty name="dataBean" property="currentPage" param="currentPage"/>

    <div class="card">
        <h2 class="card-title">📱 商品展示列表</h2>

        <% String[][] table = dataBean.getTableRecord();
            if (table == null || table.length == 0) {
        %>
        <div style="text-align:center; padding:80px 20px; color:#999;">
            <div style="font-size: 64px; margin-bottom: 20px; opacity: 0.5;">📦</div>
            <h3 style="color: var(--text-main);">暂无符合条件的商品</h3>
            <p>换个分类或搜索词试试看吧</p>
            <a href="lookMobile.jsp" class="btn btn-primary" style="margin-top: 20px;">返回分类</a>
        </div>
        <% } else { %>

        <div class="goods-grid">
            <%
                int totalRecord = table.length;
                int pageSize = dataBean.getPageSize();
                int totalPages = dataBean.getTotalPages();

                // 计算总页数逻辑
                if (totalRecord % pageSize == 0) totalPages = totalRecord / pageSize;
                else totalPages = totalRecord / pageSize + 1;

                dataBean.setPageSize(pageSize);
                dataBean.setTotalPages(totalPages);

                // 页码越界处理
                if (totalPages >= 1) {
                    if (dataBean.getCurrentPage() < 1) dataBean.setCurrentPage(dataBean.getTotalPages());
                    if (dataBean.getCurrentPage() > dataBean.getTotalPages()) dataBean.setCurrentPage(1);
                }

                int index = (dataBean.getCurrentPage() - 1) * pageSize;

                // 遍历显示商品
                for (int i = index; i < pageSize + index; i++) {
                    if (i >= totalRecord) break;

                    String id = table[i][0];
                    String name = table[i][1];
                    String made = table[i][2];
                    String price = table[i][3];
                    String pic = "default.png";
                    // 容错处理：防止旧代码数组越界
                    if(table[i].length > 4 && table[i][4] != null) pic = table[i][4];
            %>
            <div class="product-card">
                <div class="product-img">
                    <a href="showDetail.jsp?mobileID=<%=id%>">
                        <img src="image/<%=pic%>" onerror="this.src='image/default.png'" alt="<%=name%>">
                    </a>
                </div>
                <div class="product-body">
                    <div style="font-size: 16px; font-weight: bold; margin-bottom: 5px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; color: var(--text-main);" title="<%=name%>"><%=name%></div>
                    <div style="font-size: 12px; color: #999; margin-bottom: 15px;"><%=made%></div>

                    <div style="display: flex; justify-content: space-between; align-items: center;">
                        <div class="product-price">¥ <%=price%></div>
                        <a href="putGoodsServlet?mobileID=<%=id%>" class="btn btn-primary" style="padding: 8px 15px; font-size: 12px; border-radius: 8px;">加入购物车</a>
                    </div>
                </div>
            </div>
            <% } %>
        </div>

        <div style="margin-top: 50px; display: flex; justify-content: center; align-items: center; gap: 20px;">
            <form action="" method="post" style="margin:0;">
                <input type="hidden" name="currentPage" value="<%= dataBean.getCurrentPage()-1 %>">
                <button type="submit" class="btn btn-outline" <%=dataBean.getCurrentPage()<=1?"disabled style='opacity:0.5; cursor:not-allowed;'":""%>>
                    &#10094; 上一页
                </button>
            </form>

            <div style="font-weight: bold; color: var(--text-main); background: #f0f2f5; padding: 8px 20px; border-radius: 20px;">
                <%=dataBean.getCurrentPage()%> / <%=totalPages%>
            </div>

            <form action="" method="post" style="margin:0;">
                <input type="hidden" name="currentPage" value="<%= dataBean.getCurrentPage()+1 %>">
                <button type="submit" class="btn btn-outline" <%=dataBean.getCurrentPage()>=totalPages?"disabled style='opacity:0.5; cursor:not-allowed;'":""%>>
                    下一页 &#10095;
                </button>
            </form>
        </div>
        <% } %>
    </div>

    <jsp:include page="hotGoods.jsp" />
</div>
<div class="footer"><p>Copyright © 2025 Mobile Shop System.</p></div>
</body>
</html>
