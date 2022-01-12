package com.liuuki.crm.workbench.service;

import com.liuuki.crm.Exception.AddActivityException;
import com.liuuki.crm.settings.domain.User;
import com.liuuki.crm.workbench.domain.Activity;

import java.util.List;

public interface ActivityService {
    //查询数据库中的user信息
   public List<User> userList();
    //添加市场活动
   public boolean saveActivity(Activity activity)throws AddActivityException;
}
