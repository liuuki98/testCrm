package com.liuuki.crm.workbench.dao;

public interface ActivityRemarkDao {

    int selectAllRemarkById(String[] ids);

    int deleteRemark(String[] ids);
}
