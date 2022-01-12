package com.liuuki.crm.workbench.service.imp;

import com.liuuki.crm.Exception.AddActivityException;
import com.liuuki.crm.settings.domain.User;
import com.liuuki.crm.util.SqlSessionUtil;
import com.liuuki.crm.workbench.dao.ActivityDao;
import com.liuuki.crm.workbench.domain.Activity;
import com.liuuki.crm.workbench.service.ActivityService;

import java.util.List;

/**
 * @ClassName ActivityServiceImp
 * @Description TOOD
 * @AuTHor 726465198
 * @Date 2022/1/12 19:08
 * @Version 1.0
 **/
public class ActivityServiceImp implements ActivityService {

    @Override
    public List<User> userList() {
        ActivityDao activityDao = SqlSessionUtil.getSqlSession().getMapper(ActivityDao.class);
        List<User> users = activityDao.userList();

        return users;
    }

    /**
     * 添加市场活动
     * @param activity
     */
    @Override
    public boolean saveActivity(Activity activity) throws AddActivityException  {
        ActivityDao activityDao = SqlSessionUtil.getSqlSession().getMapper(ActivityDao.class);
        boolean flag=true;


        //向数据库中执行添加操作，信息封装在activity实体类中
        int i = activityDao.saveActivity(activity);

        if(i!=1){
            flag=false;

        }


        return flag;
    }
}
