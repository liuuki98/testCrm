package com.liuuki.crm.settings.web.controller;

import com.liuuki.crm.settings.domain.DicValue;
import com.liuuki.crm.settings.domain.User;
import com.liuuki.crm.settings.service.DicService;
import com.liuuki.crm.settings.service.UserService;
import com.liuuki.crm.settings.service.imp.DicServiceImp;
import com.liuuki.crm.settings.service.imp.UserServiceImp;
import com.liuuki.crm.util.MD5Util;
import com.liuuki.crm.util.PrintJson;
import com.liuuki.crm.util.ServiceFactory;
import com.liuuki.crm.vo.ActivityVo;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

/**
 * @ClassName UserControllor
 * @Description TOOD
 * @AuTHor 726465198
 * @Date 2022/1/11 10:00
 * @Version 1.0
 **/
public class UserController extends HttpServlet {

    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("进入到控制器");
        String path = request.getServletPath();
        if ("/settings/user/login.do".equals(path)) {
            login(request,response);
        }else if("/settings/user/updatePwd.do".equals(path)){
            updatePwd(request,response);
        }else if("/settings/user/exit.do".equals(path)){
            exit(request,response);
        }else if("/settings/qx/getUserPages.do".equals(path)){
            getUserPages(request,response);
        }



    }

    private void getUserPages(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到getUserPages的控制器方法");
        UserService userService=(UserService)ServiceFactory.getService(new UserServiceImp()) ;
        String pageSize=request.getParameter("pageSize");
        String pageNum=request.getParameter("pageNum");

        int pageStart=(Integer.parseInt(pageNum)-1)*(Integer.parseInt(pageSize));
        int pageEnd=Integer.parseInt(pageSize);
        Map<String,Object> map = new HashMap<>();
        map.put("pageStart",pageStart);
        map.put("pageEnd",pageEnd);

        ActivityVo<User> userActivityVo=userService.getUserPages(map);
        PrintJson.printJsonObj(response,userActivityVo);
    }

    private void exit(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getSession().removeAttribute("user");
        response.sendRedirect("/crm/login.jsp");

    }

    private void updatePwd(HttpServletRequest request, HttpServletResponse response) {
        UserService userService=(UserService)ServiceFactory.getService(new UserServiceImp()) ;
        String currentPwd=request.getParameter("currentPwd");
        String newPwd=request.getParameter("newPwd");
        String  id=((User)request.getSession().getAttribute("user")).getId();
        boolean flag=userService.updatePwd(currentPwd,newPwd,id);
        if (flag){
            System.out.println("修改密码成功");
            request.getSession().removeAttribute("user");
            PrintJson.printJsonFlag(response,flag);
        }else {
            PrintJson.printJsonFlag(response,flag);
        }



    }

    private void login(HttpServletRequest request,HttpServletResponse response){
        System.out.println("进入到了控制器的login方法");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        //转换为加密的密码
        password = MD5Util.getMD5(password);
        String ip = request.getRemoteAddr();
        //使用代理类
        UserService us = (UserService) ServiceFactory.getService(new UserServiceImp());



        try {
            System.out.println("准备进行DAO方法调用");
            User user = us.login(username, password, ip);
            request.getSession().setAttribute("user", user);
            PrintJson.printJsonFlag(response, true);
            System.out.println("已发送到login"+user.getLevel());

        }catch (Exception e){
            e.printStackTrace();
            String msg =e.getMessage();
            System.out.println("msg");
            Map<String,Object> map = new HashMap<String,Object>();
            map.put("success",false);
            map.put("msg",msg);
            PrintJson.printJsonObj(response,map);

        }


    }

}
