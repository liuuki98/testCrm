package com.liuuki.crm.settings.dao;

import com.liuuki.crm.settings.domain.DicValue;

import java.util.List;

public interface DicvalueDao {
    List<DicValue> getvalues(String code);
}
