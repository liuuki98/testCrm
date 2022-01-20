package com.liuuki.crm.workbench.service;

import com.liuuki.crm.workbench.domain.Tran;

public interface TranService {
    boolean saveTrans(Tran tran, String customerName);
}
