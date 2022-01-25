package com.liuuki.crm.settings.service;

import com.liuuki.crm.settings.domain.User;
import com.liuuki.crm.vo.ActivityVo;

import java.util.Map;

public interface UserService {
    public User login(String username,String password,String ip) throws Exception;

    boolean updatePwd(String currentPwd, String newPwd,String id);

    ActivityVo<User> getUserPages(Map<String, Object> map);
}
