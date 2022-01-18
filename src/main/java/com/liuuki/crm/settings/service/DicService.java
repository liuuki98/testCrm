package com.liuuki.crm.settings.service;

import com.liuuki.crm.settings.domain.DicValue;
import com.liuuki.crm.settings.domain.Dictype;

import java.util.List;

public interface DicService {
    List<Dictype> getTypes();

    List<DicValue> getvalues(String code);
}
