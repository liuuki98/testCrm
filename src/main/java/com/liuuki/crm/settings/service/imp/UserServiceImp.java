package com.liuuki.crm.settings.service.imp;

import com.liuuki.crm.Exception.LoginException;
import com.liuuki.crm.settings.dao.DicvalueDao;
import com.liuuki.crm.settings.dao.UserDao;
import com.liuuki.crm.settings.domain.DicValue;
import com.liuuki.crm.settings.domain.User;
import com.liuuki.crm.settings.service.UserService;
import com.liuuki.crm.util.DateTimeUtil;
import com.liuuki.crm.util.MD5Util;
import com.liuuki.crm.util.SqlSessionUtil;
import com.liuuki.crm.vo.ActivityVo;


import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @ClassName UserServiceImp
 * @Description TOOD
 * @AuTHor 726465198
 * @Date 2022/1/11 9:50
 * @Version 1.0
 **/
public class UserServiceImp implements UserService  {
    private UserDao userDao=SqlSessionUtil.getSqlSession().getMapper(UserDao.class);

    @Override
    public User login(String username, String password, String ip)throws Exception {
        System.out.println("进入到userservice方法");
        Map<String,String> map = new HashMap <String,String>();
        map.put("username",username);
        map.put("password",password);

        User user = userDao.login(map);

        if(user==null){

            System.out.println("user为空");
            throw new LoginException("账号或密码错误！请重新输入");
        }
        String userDate = user.getExpireTime();
        String currentDate = DateTimeUtil.getSysTime();
        if(currentDate.compareTo(userDate)>0){

            throw  new LoginException("该账号使用权限已过期，请联系管理员！");
        }

        if (!user.getAllowIps().contains(ip)){

            throw new LoginException("该地址禁止访问！");
        }

        if ("0".equals(user.getLockState())){
            throw new LoginException("该账号已被冻结，请联系管理员！");
        }


        return user;
    }

    @Override
    public boolean updatePwd(String currentPwd, String newPwd,String id) {
        boolean flag=true;
        String userPwd=userDao.getPwd(id);
        currentPwd = MD5Util.getMD5(currentPwd);
        if(userPwd.equals(currentPwd)){
            newPwd=MD5Util.getMD5(newPwd);
            Map<String,String> map =new HashMap<>();
            map.put("id",id);
            map.put("newPwd",newPwd);
            int i =userDao.updatePwd(map);
            if(i!=1){
                flag=false;
            }
            return flag;
        }else {
            flag=false;
            return flag;
        }
    }

    @Override
    public ActivityVo<User> getUserPages(Map<String, Object> map) {
        System.out.println("进入到getUserPages方法");

        int totalPage=userDao.getTotalPages();
        System.out.println(totalPage);
        List<User> userList =userDao.getUsersByPage(map);
        System.out.println(userList.size());
        ActivityVo<User> userActivityVo=new ActivityVo<>();
        userActivityVo.setPagesTotal(totalPage);
        userActivityVo.setDatalist(userList);
        return userActivityVo;
    }
}
