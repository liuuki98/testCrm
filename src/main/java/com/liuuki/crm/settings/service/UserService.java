package com.liuuki.crm.settings.service;

import com.liuuki.crm.settings.domain.User;

public interface UserService {
    public User login(String username,String password,String ip) throws Exception;
}
