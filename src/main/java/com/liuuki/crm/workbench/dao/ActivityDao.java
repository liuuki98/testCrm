package com.liuuki.crm.workbench.dao;

import com.liuuki.crm.settings.domain.User;
import com.liuuki.crm.workbench.domain.Activity;

import java.util.List;

public interface ActivityDao {
    public List<User> userList();

    public int saveActivity(Activity activity);
}
