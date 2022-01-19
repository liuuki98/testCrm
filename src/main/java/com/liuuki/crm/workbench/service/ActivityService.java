package com.liuuki.crm.workbench.service;

import com.liuuki.crm.Exception.AddActivityException;
import com.liuuki.crm.settings.domain.User;
import com.liuuki.crm.vo.ActivityVo;
import com.liuuki.crm.workbench.domain.Activity;
import com.liuuki.crm.workbench.domain.Remark;
import com.liuuki.crm.workbench.domain.Tran;

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
    //获取activity中的信息以及对应的user的name
    Activity selectActivityByAId(String id);
    //获取备注信息列表，返回给前端用于备注的初始化
    List<Remark> getRemarkList(String id);
    //根据备注ID删除该备注
    boolean deleteRemarkById(String id);
   ////获取单个备注的内容
    String getRemarkNoteContent(String id);

    boolean saveRemark(Map<String, String> map);

    boolean addRemark(Map<String, String> map);

    boolean deleteSActivity(String id);

   //查找activity，返回list
   List<Activity> showActivityList(String id);
    //根据线索id条件查找相关的市场活动
    List<Activity> searchActivityByClue(Map<String, String> map);
    //根据name条件查找相关的市场活动
    List<Activity> searchActivityByName(String name);


}
