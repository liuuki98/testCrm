package com.liuuki.crm.workbench.service;

import com.liuuki.crm.workbench.domain.Tran;

import java.util.List;
import java.util.Map;

public interface TranService {
    boolean saveTrans(Tran tran, String customerName);

    List<Tran> pageList(Map<String, Object> map);

    int getTotalPages(Map<String, Object> map);

    Tran detail(String id);
}
