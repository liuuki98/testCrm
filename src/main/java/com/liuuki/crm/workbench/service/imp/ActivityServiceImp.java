package com.liuuki.crm.workbench.service.imp;

import com.liuuki.crm.Exception.AddActivityException;
import com.liuuki.crm.settings.domain.User;
import com.liuuki.crm.util.SqlSessionUtil;
import com.liuuki.crm.vo.ActivityVo;
import com.liuuki.crm.workbench.dao.ActivityDao;
import com.liuuki.crm.workbench.dao.ActivityRemarkDao;
import com.liuuki.crm.workbench.domain.Activity;
import com.liuuki.crm.workbench.domain.Remark;
import com.liuuki.crm.workbench.domain.Tran;
import com.liuuki.crm.workbench.service.ActivityService;
import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;

import java.io.IOException;
import java.io.InputStream;
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

    /**
     * 获取activity中的信息以及对应的user的name
     * @param id
     * @return
     */
    @Override
    public Activity selectActivityByAId(String id) {
        ActivityDao activityDao = SqlSessionUtil.getSqlSession().getMapper(ActivityDao.class);
        Activity activity=activityDao.selectActivityByAId(id);
        return activity;
    }

    /**
     * 获取备注信息列表，返回给前端用于备注的初始化
     * @param id
     * @return
     */
    @Override
    public List<Remark> getRemarkList(String id) {
        ActivityRemarkDao activityRemarkDao = SqlSessionUtil.getSqlSession().getMapper(ActivityRemarkDao.class);
        List<Remark> remarkList = activityRemarkDao.getRemarkList(id);
        return remarkList;
    }

    /**
     * 根据id删除备注
     * @param id
     * @return
     */
    @Override
    public boolean deleteRemarkById(String id) {
        boolean flag = true;
        ActivityRemarkDao activityRemarkDao = SqlSessionUtil.getSqlSession().getMapper(ActivityRemarkDao.class);
        int i = activityRemarkDao.deleteRemarkById(id);
        if(i!=1){
            flag=false;
        }
        return flag;
    }

    /**
     * //获取单个备注的内容
     * @param id
     * @return
     */
    @Override
    public String getRemarkNoteContent(String id) {

        ActivityRemarkDao activityRemarkDao = SqlSessionUtil.getSqlSession().getMapper(ActivityRemarkDao.class);
        String note = activityRemarkDao.getRemarkNoteContent(id);

        return note;
    }

    @Override
    public boolean saveRemark(Map<String, String> map) {
        boolean flag = true;
        ActivityRemarkDao activityRemarkDao = SqlSessionUtil.getSqlSession().getMapper(ActivityRemarkDao.class);
        int i = activityRemarkDao.saveRemark(map);
        if(i!=1){
            flag=false;
        }
        return flag;
    }

    @Override
    public boolean addRemark(Map<String, String> map) {
        boolean flag = true;
        ActivityRemarkDao activityRemarkDao = SqlSessionUtil.getSqlSession().getMapper(ActivityRemarkDao.class);
        int i = activityRemarkDao.addRemark(map);
        if(i!=1){
            flag=false;
        }

        return flag;
    }

    @Override
    public boolean deleteSActivity(String id) {
        boolean flag=true;
        ActivityDao activityDao = SqlSessionUtil.getSqlSession().getMapper(ActivityDao.class);
        int i = activityDao.deleteSActivity(id);
        if(i!=1){
            flag=false;
        }
        return flag;
    }
    //查找activity，返回list
    @Override
    public List<Activity> showActivityList(String id) {
        ActivityDao activityDao = SqlSessionUtil.getSqlSession().getMapper(ActivityDao.class);
        List<Activity> activityList = activityDao.showActivityList(id);

        return activityList;
    }

    @Override
    public List<Activity> searchActivityByClue(Map<String, String> map) {
        ActivityDao activityDao = SqlSessionUtil.getSqlSession().getMapper(ActivityDao.class);
        List<Activity> activityList = activityDao.searchActivityByClue(map);
        return activityList;
    }

    @Override
    public List<Activity> searchActivityByName(String name) {
        String path="mybatis.xml";
        InputStream inputStream=null;
        SqlSession session=null;

        try {
            inputStream= Resources.getResourceAsStream(path);
            SqlSessionFactory factory = new SqlSessionFactoryBuilder().build(inputStream);
             session=factory.openSession();
        } catch (IOException e) {
            e.printStackTrace();
        }
        ActivityDao activityDao = session.getMapper(ActivityDao.class);

       List<Activity> activityList= activityDao.searchActivityByName(name);
        return activityList;
    }


}
