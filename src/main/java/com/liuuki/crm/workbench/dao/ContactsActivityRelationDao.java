package com.liuuki.crm.workbench.dao;

import com.liuuki.crm.workbench.domain.ContactsActivityRelation;

public interface ContactsActivityRelationDao {
    int saveContactsActivityRelation(ContactsActivityRelation contactsActivityRelation);

    int getCarByClueIds(String[] id);

    int deleteCarByClueIds(String[] id);
}
