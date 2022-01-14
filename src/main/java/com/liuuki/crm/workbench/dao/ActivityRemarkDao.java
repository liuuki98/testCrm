package com.liuuki.crm.workbench.dao;

import com.liuuki.crm.workbench.domain.Remark;

import java.util.List;
import java.util.Map;

public interface ActivityRemarkDao {

    int selectAllRemarkById(String[] ids);

    int deleteRemark(String[] ids);
    //获取备注信息列表，返回给前端用于备注的初始化
    List<Remark> getRemarkList(String id);

    int deleteRemarkById(String id);

    String getRemarkNoteContent(String id);

    int saveRemark(Map<String, String> map);

    int addRemark(Map<String, String> map);
}
