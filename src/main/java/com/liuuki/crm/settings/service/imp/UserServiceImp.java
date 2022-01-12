package com.liuuki.crm.settings.service.imp;

import com.liuuki.crm.Exception.LoginException;
import com.liuuki.crm.settings.dao.UserDao;
import com.liuuki.crm.settings.domain.User;
import com.liuuki.crm.settings.service.UserService;
import com.liuuki.crm.util.DateTimeUtil;
import com.liuuki.crm.util.SqlSessionUtil;


import java.util.HashMap;
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
}
