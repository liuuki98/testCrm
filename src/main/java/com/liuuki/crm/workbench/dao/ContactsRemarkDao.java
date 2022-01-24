package com.liuuki.crm.workbench.dao;

import com.liuuki.crm.workbench.domain.ContactsRemark;

public interface ContactsRemarkDao {
    int saveContactsRemark(ContactsRemark contactsRemark);

    int getConRemarkByClueIds(String[] id);

    int deleteRemarkByCIds(String[] id);
}
