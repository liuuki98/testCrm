package com.liuuki.crm.settings.service.imp;
import com.liuuki.crm.settings.dao.DictypeDao;
import com.liuuki.crm.settings.dao.DicvalueDao;
import com.liuuki.crm.settings.domain.DicValue;
import com.liuuki.crm.settings.domain.Dictype;
import com.liuuki.crm.settings.service.DicService;
import com.liuuki.crm.util.SqlSessionUtil;
import com.liuuki.crm.vo.ActivityVo;

import java.util.List;
import java.util.Map;

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

    @Override
    public ActivityVo<Dictype> getPageTypes(Map<String, Object> map) {
        DictypeDao dic = SqlSessionUtil.getSqlSession().getMapper(DictypeDao.class);

        int totalPage=dic.getTotalPages();
        List<Dictype> dictypeList =dic.getTypesByPage(map);
        ActivityVo<Dictype> dictypeActivityVo=new ActivityVo<>();
        dictypeActivityVo.setPagesTotal(totalPage);
        dictypeActivityVo.setDatalist(dictypeList);
        return dictypeActivityVo;
    }

    @Override
    public boolean saveDicType(Dictype dictype) {
        boolean flag=true;
        DictypeDao dic = SqlSessionUtil.getSqlSession().getMapper(DictypeDao.class);
        int i = dic.saveDicType(dictype);
        if(i!=1){
            flag=false;
        }
        return flag;
    }

    @Override
    public boolean deleteDicType(String[] ids) {
        boolean flag=true;
        DictypeDao dic = SqlSessionUtil.getSqlSession().getMapper(DictypeDao.class);

        int i =dic.deleteDicTypeNumber(ids);
        int i2=dic.deleteDicTypes(ids);
        System.out.println(i + i2);
        if(i!=i2){
            flag=false;
        }
        return flag;

    }

    @Override
    public Dictype getTypeByCode(String code) {
        DictypeDao dic = SqlSessionUtil.getSqlSession().getMapper(DictypeDao.class);
        Dictype dictype=dic.getTypeByCode(code);
        return dictype;
    }

    @Override
    public boolean updateType(Dictype dictype) {
        boolean flag=true;
        DictypeDao dic = SqlSessionUtil.getSqlSession().getMapper(DictypeDao.class);
        int i = dic.updateType(dictype);
        if(i!=1){
            flag=false;
        }
        return flag;
    }

    @Override
    public ActivityVo<DicValue> DicValPageList(Map<String, Object> map) {
        DicvalueDao dic = SqlSessionUtil.getSqlSession().getMapper(DicvalueDao.class);

        int totalPage=dic.getTotalPages();
        List<DicValue> dicValueList =dic.getTypesByPage(map);
        ActivityVo<DicValue> dicValueActivityVo=new ActivityVo<>();
        dicValueActivityVo.setPagesTotal(totalPage);
        dicValueActivityVo.setDatalist(dicValueList);
        return dicValueActivityVo;
    }

    @Override
    public List<String> enterSave() {
        DicvalueDao dic = SqlSessionUtil.getSqlSession().getMapper(DicvalueDao.class);
        List<String> typeCode = dic.getTypeCOde();
        return  typeCode;
    }

    @Override
    public boolean saveDicValue(DicValue dicValue) {
        boolean flag = true;
        DicvalueDao dic = SqlSessionUtil.getSqlSession().getMapper(DicvalueDao.class);
        int i =dic.saveDicValue(dicValue);
        if(i!=1){
            flag=false;
        }
        return  flag;
    }

    @Override
    public boolean deleteDicValue(String[] ids) {
        boolean flag=true;
        DicvalueDao dic = SqlSessionUtil.getSqlSession().getMapper(DicvalueDao.class);

        int i =dic.deleteDicTypeNumber(ids);
        int i2=dic.deleteDicValues(ids);
        System.out.println(i + i2);
        if(i!=i2){
            flag=false;
        }
        return flag;
    }

    @Override
    public DicValue Valueedit(String id) {
        DicvalueDao dic = SqlSessionUtil.getSqlSession().getMapper(DicvalueDao.class);
        DicValue dicValue = dic.Valueedit(id);
        return dicValue;
    }

    @Override
    public boolean updateValue(DicValue dicValue) {
        boolean flag=true;
        DicvalueDao dic = SqlSessionUtil.getSqlSession().getMapper(DicvalueDao.class);
        int i =dic.updateValue(dicValue);
        if(i!=1){
            flag=false;
        }
        return flag;
    }
}
