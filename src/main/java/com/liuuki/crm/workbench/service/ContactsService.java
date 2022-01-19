package com.liuuki.crm.workbench.service;

import com.liuuki.crm.workbench.domain.Contacts;

import java.util.List;

public interface ContactsService {


    List<Contacts> searchContactsByName(String name);
}
