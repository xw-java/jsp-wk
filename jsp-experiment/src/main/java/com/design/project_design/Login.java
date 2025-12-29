package com.design.project_design;

public class Login {
    String logname = "",
            backNews = "未登录";

    public void setLogname(String lognname) {
        this.logname = lognname;
    }

    public String getLogname() {
        return logname;
    }

    public void setBackNews(String s) {
        backNews = s;
    }

    public String getBackNews() {
        return backNews;
    }
}
