package com.liuuki.crm.settings.dao;

import com.liuuki.crm.settings.domain.User;

import java.util.List;
import java.util.Map;

public interface UserDao {
    public User login(Map<String,String> map);

    String getPwd(String id);

    int updatePwd(Map<String, String> newPwd);

    int getTotalPages();

    List<User> getUsersByPage(Map<String, Object> map);
}
