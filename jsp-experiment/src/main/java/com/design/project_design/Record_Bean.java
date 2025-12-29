package com.design.project_design;

public class Record_Bean {
    String[][] tableRecord = null; //存放查询到的记录

    // 【核心修改】 将每页显示数从 3 改为 8，大幅提升浏览体验
    int pageSize = 8;

    int totalPages; //分页后的总页数
    int currentPage = 1; //当前显示页
    int totalRecords; //全部记录

    public void setTableRecord(String[][] s) {
        tableRecord = s;
    }

    public String[][] getTableRecord() {
        return tableRecord;
    }

    public void setPageSize(int size) {
        pageSize = size;
    }

    public int getPageSize() {
        return pageSize;
    }

    public int getTotalPages() {
        return totalPages;
    }

    public void setTotalPages(int n) {
        totalPages = n;
    }

    public void setCurrentPage(int n) {
        currentPage = n;
    }

    public int getCurrentPage() {
        return currentPage;
    }

    public int getTotalRecords() {
        totalRecords = tableRecord.length;
        return totalRecords;
    }
}
