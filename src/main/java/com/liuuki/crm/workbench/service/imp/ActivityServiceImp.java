package com.liuuki.crm.workbench.service.imp;

import com.liuuki.crm.Exception.AddActivityException;
import com.liuuki.crm.settings.domain.User;
import com.liuuki.crm.util.SqlSessionUtil;
import com.liuuki.crm.vo.ActivityVo;
import com.liuuki.crm.workbench.dao.ActivityDao;
import com.liuuki.crm.workbench.dao.ActivityRemarkDao;
import com.liuuki.crm.workbench.domain.Activity;
import com.liuuki.crm.workbench.service.ActivityService;

import java.util.List;
import java.util.Map;

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

    /**
     * 查询市场活动，添加到列表中
     * @param map
     * @return
     */
    @Override
    public ActivityVo selectActivity(Map<String, Object> map) {
        ActivityDao activityDao = SqlSessionUtil.getSqlSession().getMapper(ActivityDao.class);

        List<Activity> activityList = activityDao.selectActivity(map);
        int pageNum=activityDao.getTotalPages();
        ActivityVo<Activity> activityVo = new ActivityVo<>();
        activityVo.setPagesTotal(pageNum);
        activityVo.setDatalist(activityList);

        return activityVo;


    }

    /**
     * 删除市场活动以及关联的备注信息
     * @param ids
     * @return
     */
    @Override
    public boolean deleteActivityRemark(String[] ids) {
        ActivityRemarkDao activityRemarkDao = SqlSessionUtil.getSqlSession().getMapper(ActivityRemarkDao.class);
        ActivityDao activityDao = SqlSessionUtil.getSqlSession().getMapper(ActivityDao.class);
        boolean flag = true;

        //查询备注信息的数量
        int remark = activityRemarkDao.selectAllRemarkById(ids);
        //删除的备注的数量
        int deleteRemark=activityRemarkDao.deleteRemark(ids);
        if(remark!=deleteRemark){

            flag=false; //值不一样，表示删除失败
        }

        //删除activity表
        int i =activityDao.deleteActivity(ids);
        if (i!=ids.length){

            flag=false;
        }

        return flag;
    }

    @Override
    public Activity selectActivityById(String id) {
        ActivityDao activityDao = SqlSessionUtil.getSqlSession().getMapper(ActivityDao.class);
        Activity activity=activityDao.selectActivityById(id);

        return activity;
    }

    @Override
    public boolean updateActivity(Activity activity) {
        boolean flag=true;
        ActivityDao activityDao=SqlSessionUtil.getSqlSession().getMapper(ActivityDao.class);
        int i =activityDao.updateActivity(activity);
        if(i!=1){
            flag=false;
        }
        return flag;
    }
}
