package com.liuuki.crm.workbench.dao;

import com.liuuki.crm.workbench.domain.Contacts;

import java.util.List;

public interface ContactsDao {

    int saveContacts(Contacts contacts);



    List<Contacts> searchContactsByName(String name);
}
