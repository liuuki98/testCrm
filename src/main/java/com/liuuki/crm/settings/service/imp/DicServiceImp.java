package com.liuuki.crm.settings.service.imp;
import com.liuuki.crm.settings.dao.DictypeDao;
import com.liuuki.crm.settings.dao.DicvalueDao;
import com.liuuki.crm.settings.domain.DicValue;
import com.liuuki.crm.settings.domain.Dictype;
import com.liuuki.crm.settings.service.DicService;
import com.liuuki.crm.util.SqlSessionUtil;

import java.util.List;

/**
 * @ClassName DicServiceImp
 * @Description TOOD
 * @AuTHor 726465198
 * @Date 2022/1/17 9:26
 * @Version 1.0
 **/
public class DicServiceImp implements DicService {
    @Override
    public List<Dictype> getTypes() {
        DictypeDao dic = SqlSessionUtil.getSqlSession().getMapper(DictypeDao.class);
        List<Dictype> dictypeList= dic.getTypes();
        return dictypeList;
    }

    @Override
    public List<DicValue> getvalues(String code) {
        DicvalueDao dicvalueDao = SqlSessionUtil.getSqlSession().getMapper(DicvalueDao.class);
        List<DicValue> dicValueList= dicvalueDao.getvalues(code);
        return dicValueList;
    }
}
