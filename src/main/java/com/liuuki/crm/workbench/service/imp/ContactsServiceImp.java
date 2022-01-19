package com.liuuki.crm.workbench.service.imp;

import com.liuuki.crm.util.SqlSessionUtil;
import com.liuuki.crm.workbench.dao.ContactsDao;
import com.liuuki.crm.workbench.domain.Contacts;
import com.liuuki.crm.workbench.service.ContactsService;

import java.util.List;

/**
 * @ClassName ContactsServiceImp
 * @Description TOOD
 * @AuTHor 726465198
 * @Date 2022/1/19 12:33
 * @Version 1.0
 **/
public class ContactsServiceImp implements ContactsService {


    @Override
    public List<Contacts> searchContactsByName(String name) {
        ContactsDao contactsDao = SqlSessionUtil.getSqlSession().getMapper(ContactsDao.class);
        List<Contacts> contacts = contactsDao.searchContactsByName(name);
        return contacts;

    }
}
