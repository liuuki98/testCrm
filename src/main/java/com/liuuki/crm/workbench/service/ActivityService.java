package com.liuuki.crm.workbench.service;

import com.liuuki.crm.Exception.AddActivityException;
import com.liuuki.crm.settings.domain.User;
import com.liuuki.crm.vo.ActivityVo;
import com.liuuki.crm.workbench.domain.Activity;

import java.util.List;
import java.util.Map;

public interface ActivityService {
    //查询数据库中的user信息
   List<User> userList();
    //添加市场活动
    boolean saveActivity(Activity activity)throws AddActivityException;
    //查询市场活动并添加到动态列表中
   ActivityVo<Activity> selectActivity(Map<String,Object> map);
    //删除市场活动以及关联的备注信息
    boolean deleteActivityRemark(String[] ids);

    Activity selectActivityById(String id);

    boolean updateActivity(Activity activity);
}
