package com.liuuki.crm.vo;

import java.util.List;

/**
 * @ClassName ActivityVo
 * @Description TOOD
 * @AuTHor 726465198
 * @Date 2022/1/13 9:49
 * @Version 1.0
 **/
public class ActivityVo<T> {
    private int pagesTotal;
    private List<T> datalist;

    public int getPagesTotal() {
        return pagesTotal;
    }

    public void setPagesTotal(int pagesTotal) {
        this.pagesTotal = pagesTotal;
    }

    public List<T> getDatalist() {
        return datalist;
    }

    public void setDatalist(List<T> datalist) {
        this.datalist = datalist;
    }
}
