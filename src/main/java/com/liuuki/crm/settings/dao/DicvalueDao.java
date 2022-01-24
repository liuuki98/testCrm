package com.liuuki.crm.settings.dao;

import com.liuuki.crm.settings.domain.DicValue;

import java.util.List;
import java.util.Map;

public interface DicvalueDao {
    List<DicValue> getvalues(String code);

    int getTotalPages();

    List<DicValue> getTypesByPage(Map<String, Object> map);

    List<String> getTypeCOde();

    int saveDicValue(DicValue dicValue);

    int deleteDicTypeNumber(String[] ids);

    int deleteDicValues(String[] ids);

    DicValue Valueedit(String id);

    int updateValue(DicValue dicValue);
}
