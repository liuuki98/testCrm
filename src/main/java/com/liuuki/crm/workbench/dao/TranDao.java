package com.liuuki.crm.workbench.dao;

import com.liuuki.crm.workbench.domain.Tran;

import java.util.List;
import java.util.Map;

public interface TranDao {
    int saveTran(Tran trans);

    List<Tran> pageList(Map<String, Object> map);

    int getTotalPages(Map<String, Object> map);

    Tran getTranbyId(String id);
}
