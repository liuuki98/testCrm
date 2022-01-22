package com.liuuki.crm.workbench.dao;

import com.liuuki.crm.workbench.domain.ClueRemark;

import java.util.List;

public interface ClueRemarkDao {
    List<ClueRemark> getClueRemarkByClueId(String clueId);

    int deleteClueRemark(String clueId);

    List<ClueRemark> getRemarkList(String id);

    int deleteClueRemarkByid(String id);
}
