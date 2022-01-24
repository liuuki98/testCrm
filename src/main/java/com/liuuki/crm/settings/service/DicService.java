package com.liuuki.crm.settings.service;

import com.liuuki.crm.settings.domain.DicValue;
import com.liuuki.crm.settings.domain.Dictype;
import com.liuuki.crm.vo.ActivityVo;

import java.util.List;
import java.util.Map;

public interface DicService {
    List<Dictype> getTypes();

    List<DicValue> getvalues(String code);

    ActivityVo<Dictype> getPageTypes(Map<String, Object> map);

    boolean saveDicType(Dictype dictype);

    boolean deleteDicType(String[] ids);

    Dictype getTypeByCode(String code);

    boolean updateType(Dictype dictype);

    ActivityVo<DicValue> DicValPageList(Map<String, Object> map);

    List<String> enterSave();

    boolean saveDicValue(DicValue dicValue);

    boolean deleteDicValue(String[] ids);

    DicValue Valueedit(String id);

    boolean updateValue(DicValue dicValue);
}
