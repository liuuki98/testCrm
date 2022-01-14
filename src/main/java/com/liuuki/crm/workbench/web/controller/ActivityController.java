package com.liuuki.crm.workbench.web.controller;

import com.liuuki.crm.settings.domain.User;
import com.liuuki.crm.util.DateTimeUtil;
import com.liuuki.crm.util.PrintJson;
import com.liuuki.crm.util.ServiceFactory;
import com.liuuki.crm.util.UUIDUtil;
import com.liuuki.crm.vo.ActivityVo;
import com.liuuki.crm.workbench.domain.Activity;
import com.liuuki.crm.workbench.domain.Remark;
import com.liuuki.crm.workbench.service.ActivityService;
import com.liuuki.crm.workbench.service.imp.ActivityServiceImp;

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
        System.out.println("进入到可控制器"+ path);
        if("/workbench/activity/getUserList.do".equals(path)){
            userList(request,response);
        }

        if("/workbench/activity/saveActivity.do".equals(path)){
            saveActivity(request,response);
        }
        if("/workbench/activity/selectActivity.do".equals(path)){
            selectActivity(request,response);
        }
        if("/workbench/activity/deleteActivity.do".equals(path)){
            deleteActivity(request,response);
        }
        if("/workbench/activity/getUserAndActivity.do".equals(path)){
            selectActivityById(request,response);
        }
        if("/workbench/activity/saveEditActivity.do".equals(path)){
            saveEditActivity(request,response);
        }
        //初始化detail界面，返回一个activity用于初始化界面
        if("/workbench/activity/detail.do".equals(path)){
            openDetail(request,response);
        }
        //获取备注信息列表，返回给前端用于备注的初始化
        if("/workbench/activity/getRemarkList.do".equals(path)){
            getRemarkList(request,response);
        }
        //根据备注ID删除该备注
        if("/workbench/activity/deleteRemarkById.do".equals(path)){
            deleteRemarkById(request,response);
        }
        //获取单个备注的内容
        if("/workbench/activity/getRemarkNoteContent.do".equals(path)){
            getRemarkNoteContent(request,response);
        }
        if("/workbench/activity/saveRemark.do".equals(path)){
            saveRemark(request,response);
        }
        if("/workbench/activity/addRemark.do".equals(path)){
            addRemark(request,response);
        }
        if("/workbench/activity/deleteSActivity.do".equals(path)){
            deleteSActivity(request,response);
        }
    }

    private void deleteSActivity(HttpServletRequest request, HttpServletResponse response) {
        String id=request.getParameter("id");
        boolean flag =activityService.deleteSActivity(id);
        PrintJson.printJsonFlag(response,flag);
    }

    private void addRemark(HttpServletRequest request, HttpServletResponse response) {
        String content=request.getParameter("content");
        String id=UUIDUtil.getUUID();
        String name=((User)request.getSession().getAttribute("user")).getName();
        String editFlag="0";
        String createDate=DateTimeUtil.getSysTime();
        String activityId=request.getParameter("id");
        Map<String,String> map = new HashMap<>();
        map.put("content",content);
        map.put("id",id);
        map.put("name",name);
        map.put("editFlag",editFlag);
        map.put("createDate",createDate);
        map.put("activityId",activityId);

        boolean flag = activityService.addRemark(map);
        System.out.println("---------------"+flag);
        PrintJson.printJsonFlag(response,flag);


    }


    /**
     * 查找数据库中的User信息并返回给前端workbench/activity/index.jsp
     * @param request 请求
     * @param response 返回
     */
    public void userList(HttpServletRequest request,HttpServletResponse response){

       List<User> usersList= activityService.userList();
        PrintJson.printJsonObj(response,usersList);

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
            e.printStackTrace();
            PrintJson.printJsonFlag(response,false);
        }


    }

    public void selectActivity(HttpServletRequest request,HttpServletResponse response){
        String pageNum=request.getParameter("pageNum");
        String pageSize=request.getParameter("pageSize");
        String selectName=request.getParameter("selectName");
        String selectOwner=request.getParameter("selectOwner");
        String selectStartTime=request.getParameter("selectStartTime");
        String selectEndTime=request.getParameter("selectEndTime");

       int pageStart=(Integer.parseInt(pageNum)-1)*(Integer.parseInt(pageSize));
       int pageEnd=Integer.parseInt(pageSize);

       Map<String,Object> map = new HashMap<>();
       map.put("pageStart",pageStart);
        map.put("pageEnd",pageEnd);
        map.put("selectName",selectName);
        map.put("selectOwner",selectOwner);
        map.put("selectStartTime",selectStartTime);
        map.put("selectEndTime",selectEndTime);

        ActivityVo<Activity> activityVo=activityService.selectActivity(map);
        PrintJson.printJsonObj(response,activityVo);

    }

    /**
     * 对市场活动进行删除操作
     */
    public void deleteActivity(HttpServletRequest request,HttpServletResponse response){
        System.out.println("进入到删除市场活动的控制器");
        String[] ids = request.getParameterValues("id");
        boolean flag =activityService.deleteActivityRemark(ids);

        PrintJson.printJsonFlag(response,flag);
    }

    public void selectActivityById(HttpServletRequest request,HttpServletResponse response){
        String id=request.getParameter("id");
        List<User> userList=activityService.userList();
        Activity activity=activityService.selectActivityById(id);
        System.out.println(userList.size());

        Map<String,Object> map = new HashMap<>();
        map.put("userList",userList);
        map.put("activity",activity);
        PrintJson.printJsonObj(response,map);


    }

    public void saveEditActivity(HttpServletRequest request,HttpServletResponse response){

        String id=request.getParameter("id");
        String owner=request.getParameter("owner");
        String name=request.getParameter("name");
        String startDate=request.getParameter("startDate");
        String endDate=request.getParameter("endDate");
        String cost=request.getParameter("cost");
        String description=request.getParameter("description");
        String editTime=((User)request.getSession().getAttribute("user")).getName();
        String editBy=DateTimeUtil.getSysTime();
        Activity activity = new Activity(id,owner,name,startDate,endDate,cost,description,null,null,editTime,editBy);
        boolean flag=activityService.updateActivity(activity);
        if(flag){
            PrintJson.printJsonFlag(response,true);
        }else {
            PrintJson.printJsonFlag(response,false);
        }



    }

    /**
     * 初始化detail界面，返回一个activity用于初始化界面
     * @param request
     * @param response
     */
    public void openDetail(HttpServletRequest request,HttpServletResponse response) throws ServletException, IOException {
        String id=request.getParameter("id");
        Activity activity = activityService.selectActivityByAId(id);
        request.setAttribute("activity",activity);
        request.getRequestDispatcher("/workbench/activity/detail.jsp").forward(request,response);
    }

    /**获取备注信息列表，返回给前端用于备注的初始化
     *
     * @param request
     * @param response
     */
    public void getRemarkList(HttpServletRequest request,HttpServletResponse response){
        String id =request.getParameter("id");
        List<Remark> remarkList=activityService.getRemarkList(id);
        PrintJson.printJsonObj(response,remarkList);
    }

    /**
     * 根据备注ID删除该备注
     */
    public void deleteRemarkById(HttpServletRequest request,HttpServletResponse response){
        String id = request.getParameter("id");
        boolean flag = activityService.deleteRemarkById(id);
        PrintJson.printJsonFlag(response,flag);
    }
    //获取单个备注的内容
    public void getRemarkNoteContent(HttpServletRequest request,HttpServletResponse response){
        String id=request.getParameter("id");
        String note= activityService.getRemarkNoteContent(id);
        Map<String,String> map=new HashMap<>();
        map.put("noteContent",note);
        PrintJson.printJsonObj(response,map);
    }

    private void saveRemark(HttpServletRequest request, HttpServletResponse response) {

        String id=request.getParameter("id");
        String noteContent=request.getParameter("noteContent");
        String editTime=DateTimeUtil.getSysTime();
        String editBy=((User)request.getSession().getAttribute("user")).getName();


        Map<String,String> map = new HashMap<>();
        map.put("id",id);
        map.put("noteContent",noteContent);
        map.put("editFlag","1");
        map.put("editTime",editTime);
        map.put("editBy",editBy);

        boolean flag=activityService.saveRemark(map);
        System.out.println(flag);
        PrintJson.printJsonFlag(response,flag);
    }

}
