package com.liuuki.crm.settings.dao;

import com.liuuki.crm.settings.domain.Dictype;

import java.util.List;
import java.util.Map;

public interface DictypeDao {
    List<Dictype> getTypes();

    int getTotalPages();

    List<Dictype> getTypesByPage(Map<String, Object> map);

    int saveDicType(Dictype dictype);

    int deleteDicTypeNumber(String[] ids);

    int deleteDicTypes(String[] ids);

    Dictype getTypeByCode(String code);

    int updateType(Dictype dictype);
}
