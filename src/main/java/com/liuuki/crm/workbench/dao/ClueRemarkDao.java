package com.liuuki.crm.workbench.dao;

import com.liuuki.crm.workbench.domain.ClueRemark;

import java.util.List;

public interface ClueRemarkDao {
    List<ClueRemark> getClueRemarkByClueId(String clueId);

    int deleteClueRemark(String clueId);

    List<ClueRemark> getRemarkList(String id);

    int deleteClueRemarkByid(String id);

    ClueRemark getClueRemarkByid(String id);

    int updateRemark(ClueRemark clueRemark);

    int saveRemark(ClueRemark clueRemark);

    int deleteRemarkByCIds(String[] id);

    int getClueRemarkByClueIds(String[] id);
}
