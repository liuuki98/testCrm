package com.liuuki.crm.workbench.dao;

import com.liuuki.crm.settings.domain.User;
import com.liuuki.crm.workbench.domain.Activity;

import java.util.List;
import java.util.Map;

public interface ActivityDao {
    public List<User> userList();

    public int saveActivity(Activity activity);

    public List<Activity> selectActivity(Map<String, Object> map);

    public int getTotalPages();

    int deleteActivity(String[] ids);

    Activity selectActivityById(String id);

    int updateActivity(Activity activity);

    Activity selectActivityByAId(String id);

    int deleteSActivity(String id);

    List<Activity> showActivityList(String id);

    List<Activity> searchActivityByClue(Map<String, String> map);

    List<Activity> searchActivityByName(String name);
}
