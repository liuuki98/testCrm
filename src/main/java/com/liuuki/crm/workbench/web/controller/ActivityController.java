package com.liuuki.crm.workbench.web.controller;

import com.liuuki.crm.settings.domain.User;
import com.liuuki.crm.util.DateTimeUtil;
import com.liuuki.crm.util.PrintJson;
import com.liuuki.crm.util.ServiceFactory;
import com.liuuki.crm.util.UUIDUtil;
import com.liuuki.crm.workbench.domain.Activity;
import com.liuuki.crm.workbench.service.ActivityService;
import com.liuuki.crm.workbench.service.imp.ActivityServiceImp;
import org.apache.ibatis.session.SqlSession;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @ClassName ActivityController
 * @Description TOOD
 * @AuTHor 726465198
 * @Date 2022/1/12 19:10
 * @Version 1.0
 **/
public class ActivityController extends HttpServlet {
    private ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImp());
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String path = request.getServletPath();
        if("/workbench/activity/getUserList.do".equals(path)){
            userList(request,response);
        }

        if("/workbench/activity/saveActivity.do".equals(path)){
            saveActivity(request,response);
        }
    }

    /**
     * 查找数据库中的User信息并返回给前端workbench/activity/index.jsp
     * @param request 请求
     * @param response 返回
     */
    public void userList(HttpServletRequest request,HttpServletResponse response){

       List<User> usersList= activityService.userList();
        PrintJson.printJsonObj(response,usersList);
        System.out.println("已发送");
        for(User user :usersList){
            System.out.println(user.getName());
        }
    }

    /**
     * 添加市场活动到数据库中的activity表中
     * @param request
     * @param response
     */
    public void saveActivity(HttpServletRequest request,HttpServletResponse response){

        String id = UUIDUtil.getUUID();
        String owner =request.getParameter("owner");
        String name = request.getParameter("name");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String cost = request.getParameter("cost");
        String description = request.getParameter("description");
        String createTime = DateTimeUtil.getSysTime();
        String createBy =((User)request.getSession().getAttribute("user")).getName();
        Activity activity = new Activity(id,owner,name,startDate,endDate,cost,description,createTime,createBy,null,null);

        try {

            boolean flag=activityService.saveActivity(activity);
            PrintJson.printJsonFlag(response,flag);
        }catch (Exception e){
            System.out.println("该方法之星");
            e.printStackTrace();
            PrintJson.printJsonFlag(response,false);
        }


    }

}
