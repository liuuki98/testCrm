package com.liuuki.crm.workbench.dao;

import com.liuuki.crm.workbench.domain.Contacts;

import java.util.List;
import java.util.Map;

public interface ContactsDao {

    int saveContacts(Contacts contacts);



    List<Contacts> searchContactsByName(String name);

    List<Contacts> selectByCondition(Map<String, Object> map);

    int getTotalPages();

    int deleteClue(String[] id);

    Contacts getContactsByid(String id);
}
