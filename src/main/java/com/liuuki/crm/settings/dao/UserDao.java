package com.liuuki.crm.settings.dao;

import com.liuuki.crm.settings.domain.User;

import java.util.Map;

public interface UserDao {
    public User login(Map<String,String> map);
}
