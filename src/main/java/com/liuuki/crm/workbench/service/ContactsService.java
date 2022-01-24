package com.liuuki.crm.workbench.service;

import com.liuuki.crm.vo.ActivityVo;
import com.liuuki.crm.workbench.domain.Contacts;

import java.util.List;
import java.util.Map;

public interface ContactsService {


    List<Contacts> searchContactsByName(String name);

    boolean saveCustomer(Contacts contacts);

    ActivityVo<Contacts> pageList(Map<String, Object> map);

    boolean deleteContacts(String[] id);

    Contacts getContactsByid(String id);
}
