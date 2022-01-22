package com.liuuki.crm.workbench.web.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.liuuki.crm.settings.domain.User;
import com.liuuki.crm.util.DateTimeUtil;
import com.liuuki.crm.util.PrintJson;
import com.liuuki.crm.util.ServiceFactory;
import com.liuuki.crm.util.UUIDUtil;
import com.liuuki.crm.vo.ActivityVo;
import com.liuuki.crm.workbench.domain.Activity;
import com.liuuki.crm.workbench.domain.Clue;
import com.liuuki.crm.workbench.domain.ClueRemark;
import com.liuuki.crm.workbench.domain.Tran;
import com.liuuki.crm.workbench.service.ActivityService;
import com.liuuki.crm.workbench.service.ClueService;
import com.liuuki.crm.workbench.service.imp.ActivityServiceImp;
import com.liuuki.crm.workbench.service.imp.ClueServiceImp;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

/**
 * @ClassName ClueController
 * @Description TOOD
 * @AuTHor 726465198
 * @Date 2022/1/15 18:14
 * @Version 1.0
 **/
public class ClueController extends HttpServlet {
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        if("/workbench/clue/getUserList.do".equals(path)){
            getUserList(request,response);
        }else if("/workbench/clue/saveClue.do".equals(path)){
            saveClue(request,response);
        }else if("/workbench/clue/pageList.do".equals(path)){
            pageList(request,response);
        }else if("/workbench/clue/detail.do".equals(path)){
            detail(request,response);
        }else if("/workbench/clue/showActivityList.do".equals(path)){
            showActivityList(request,response);
        }else if("/workbench/clue/deleteCar.do".equals(path)){
            deleteCar(request,response);
        }else if("/workbench/clue/searchActivityByClue.do".equals(path)){
            searchActivityByClue(request,response);
        }else if("/workbench/clue/bindClueAndAc.do".equals(path)){
            bindClueAndAc(request,response);
        }else if("/workbench/clue/searchActivityByName.do".equals(path)){
            searchActivityByName(request,response);
        }else if("/workbench/clue/convert.do".equals(path)){
            convert(request,response);
        }else if("/workbench/clue/editInit.do".equals(path)){
            editInit(request,response);
        }else if("/workbench/clue/updateClue.do".equals(path)){
            updateClue(request,response);
        }else if("/workbench/clue/deleteClue.do".equals(path)){
            deleteClue(request,response);
        }else if("/workbench/clue/deleteClueById.do".equals(path)){
            deleteClueById(request,response);
        }else if("/workbench/clue/getRemarkList.do".equals(path)){
            getRemarkList(request,response);
        }else if("/workbench/clue/deleteRemarkById.do".equals(path)){
            deleteRemarkById(request,response);
        }else if("/workbench/clue/editClueRemark.do".equals(path)){
            editClueRemark(request,response);

        }else if("/workbench/clue/updateRemark.do".equals(path)){
            updateRemark(request,response);
        }else if("/workbench/clue/saveRemark.do".equals(path)){
            saveRemark(request,response);
        }

    }

    private void saveRemark(HttpServletRequest request, HttpServletResponse response) {
        ClueService clueService = (ClueService)ServiceFactory.getService(new ClueServiceImp());
        String clueId=request.getParameter("clueId");
        String noteContent=request.getParameter("noteContent");
        ClueRemark clueRemark = new ClueRemark();
        clueRemark.setId(UUIDUtil.getUUID());
        clueRemark.setClueId(clueId);
        clueRemark.setNoteContent(noteContent);
        clueRemark.setEditFlag("0");
        clueRemark.setCreateBy(((User)request.getSession().getAttribute("user")).getName());
        clueRemark.setCreateTime(DateTimeUtil.getSysTime());
        boolean flag =clueService.saveRemark(clueRemark);
        PrintJson.printJsonFlag(response,flag);
    }

    private void updateRemark(HttpServletRequest request, HttpServletResponse response) {
        ClueService clueService = (ClueService)ServiceFactory.getService(new ClueServiceImp());
        String noteContent =request.getParameter("text");
        String id=request.getParameter("id");
        ClueRemark clueRemark = new ClueRemark();


        clueRemark.setId(id);
        clueRemark.setEditFlag("1");
        clueRemark.setEditTime(DateTimeUtil.getSysTime());
        clueRemark.setNoteContent(noteContent);
        clueRemark.setEditBy(((User)request.getSession().getAttribute("user")).getName());

        boolean flag=clueService.updateRemark(clueRemark);
        PrintJson.printJsonFlag(response,flag);

    }

    private void editClueRemark(HttpServletRequest request, HttpServletResponse response) {
        ClueService clueService = (ClueService)ServiceFactory.getService(new ClueServiceImp());
        String id=request.getParameter("id");
        ClueRemark clueRemark=clueService.getClueRemarkByid(id);
        PrintJson.printJsonObj(response,clueRemark);
    }

    private void deleteRemarkById(HttpServletRequest request, HttpServletResponse response) {
        ClueService clueService = (ClueService)ServiceFactory.getService(new ClueServiceImp());
        String id=request.getParameter("id");
        boolean flag=clueService.deleteClueRemarkByid(id);
        PrintJson.printJsonFlag(response,flag);
    }
    private void getRemarkList(HttpServletRequest request, HttpServletResponse response) {
        ClueService clueService = (ClueService)ServiceFactory.getService(new ClueServiceImp());
        String id=request.getParameter("id");
        List<ClueRemark> clueRemarkList = clueService.getRemarkList(id);
        PrintJson.printJsonObj(response,clueRemarkList);

    }

    private void deleteClueById(HttpServletRequest request, HttpServletResponse response) {
        ClueService clueService=(ClueService)ServiceFactory.getService(new ClueServiceImp());
        String id=request.getParameter("id");
        boolean flag=clueService.deleteClueById(id);
        PrintJson.printJsonFlag(response,flag);

    }

    private void deleteClue(HttpServletRequest request, HttpServletResponse response) {
        String id[] =request.getParameterValues("id");
        ClueService clueService=(ClueService)ServiceFactory.getService(new ClueServiceImp());
        boolean flag = clueService.deleteClue(id);
        PrintJson.printJsonFlag(response,flag);
    }

    private void updateClue(HttpServletRequest request, HttpServletResponse response) {
     ClueService clueService=(ClueService)ServiceFactory.getService(new ClueServiceImp());
        String id =request.getParameter("id");
        String owner = request.getParameter("owner");
        String fullname =request.getParameter("fullname");
        String appellation =request.getParameter("appellation");
        String company =request.getParameter("company");
        String job =request.getParameter("job");
        String email =request.getParameter("email");
        String phone =request.getParameter("phone");
        String website =request.getParameter("website");
        String mphone =request.getParameter("mphone");
        String state =request.getParameter("state");
        String source =request.getParameter("source");
        String editBy =((User)request.getSession().getAttribute("user")).getName();
        String editTime =DateTimeUtil.getSysTime();
        String description =request.getParameter("description");
        String contactSummary =request.getParameter("contactSummary");
        String nextContactTime =request.getParameter("nextContactTime");
        String address =request.getParameter("address");
        Clue clue = new Clue();
        clue.setOwner(owner);
        clue.setId(id);
        clue.setFullname(fullname);
        clue.setAppellation(appellation);
        clue.setCompany(company);
        clue.setJob(job);
        clue.setEmail(email);
        clue.setPhone(phone);
        clue.setWebsite(website);
        clue.setMphone(mphone);
        clue.setState(state);
        clue.setSource(source);
        clue.setEditBy(editBy);
        clue.setEditTime(editTime);
        clue.setDescription(description);
        clue.setContactSummary(contactSummary);
        clue.setNextContactTime(nextContactTime);
        clue.setAddress(address);

        boolean flag = clueService.updateClue(clue);
        System.out.println(flag);
        PrintJson.printJsonFlag(response,flag);


    }

    private void editInit(HttpServletRequest request, HttpServletResponse response) {
        String id=request.getParameter("clueId");
        ActivityService activityService = (ActivityService)ServiceFactory.getService(new ActivityServiceImp());

        List<User> userList=activityService.userList();
        ClueService clueService=(ClueService)ServiceFactory.getService(new ClueServiceImp());
        Clue clue =clueService.getClueById2(id);
        Map<String,Object> map=new HashMap<>();
        map.put("userList",userList);
        map.put("clue",clue);
        PrintJson.printJsonObj(response,map);
    }

    private void convert(HttpServletRequest request, HttpServletResponse response) {
        String clueId=request.getParameter("clueId");
        Tran trans=null;
        String createBy=((User)request.getSession().getAttribute("user")).getName();
        if("a".equals(request.getParameter("flag"))){

            trans = new Tran();
            String name=request.getParameter("name");
            String money=request.getParameter("money");
            String stage = request.getParameter("stage");
            String expectedDate=request.getParameter("expectedDate");
            String activityId=request.getParameter("activityId");
            String id= UUIDUtil.getUUID();
            trans.setId(id);
            trans.setActivityId(activityId);
            trans.setCreateBy(createBy);
            trans.setMoney(money);
            trans.setName(name);
            trans.setStage(stage);
            trans.setExpectedDate(expectedDate);
        }
        ClueService activityService = (ClueService)ServiceFactory.getService(new ClueServiceImp());
        boolean flag = activityService.convert(trans,clueId,createBy);
        if(flag){
            try {
                response.sendRedirect(request.getContextPath()+"/workbench/clue/index.jsp");
            } catch (IOException e) {
                e.printStackTrace();
            }
        }

    }

    private void searchActivityByName(HttpServletRequest request, HttpServletResponse response) {
        ActivityService activityService=(ActivityService)ServiceFactory.getService(new ActivityServiceImp());
        String name=request.getParameter("name");
        List<Activity> activityList = activityService.searchActivityByName(name);
        PrintJson.printJsonObj(response,activityList)   ;
    }


    private void bindClueAndAc(HttpServletRequest request, HttpServletResponse response) {
        String aIds[] =request.getParameterValues("aid");
        String cid = request.getParameter("cid");
        ClueService clueService = (ClueService)ServiceFactory.getService(new ClueServiceImp());
        boolean flag =clueService.bindClueAndAc(aIds,cid);
        PrintJson.printJsonFlag(response,flag);
    }

    private void searchActivityByClue(HttpServletRequest request, HttpServletResponse response) {

        String name=request.getParameter("name");
        String clueId=request.getParameter("clueId");
        Map<String,String> map=new HashMap<>();
        map.put("name",name);
        map.put("clueId",clueId);
        ActivityService activityService=(ActivityService)ServiceFactory.getService(new ActivityServiceImp());
        List<Activity> activityList = activityService.searchActivityByClue(map);
        PrintJson.printJsonObj(response,activityList);

    }

    private void showActivityList(HttpServletRequest request, HttpServletResponse response) {
        ActivityService activityService=(ActivityService)ServiceFactory.getService(new ActivityServiceImp());
        String id =request.getParameter("id");
        List<Activity> activityList = activityService.showActivityList(id);
        PrintJson.printJsonObj(response,activityList);
    }

    //跳转到detail页面，并返回clue对象到requestScope中
    private void detail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id = request.getParameter("id");
        ClueService clueService = (ClueService)ServiceFactory.getService(new ClueServiceImp());
        Clue clue = clueService.getClueById(id);
        request.setAttribute("clue",clue);
        request.getRequestDispatcher("/workbench/clue/detail.jsp").forward(request,response);


    }

    //保存线索
    private void saveClue(HttpServletRequest request, HttpServletResponse response) {
        ClueService clueService =(ClueService) ServiceFactory.getService(new ClueServiceImp());
        String id = UUIDUtil.getUUID();
        String fullname=request.getParameter("fullname");
        String appellation=request.getParameter("appellation");
        String  owner=request.getParameter("owner");
        String company=request.getParameter("company");
        String job=request.getParameter("job");
        String email=request.getParameter("email");
        String phone=request.getParameter("phone");
        String website=request.getParameter("website");
        String mphone=request.getParameter("mphone");
        String state=request.getParameter("state");
        String  source=request.getParameter("source");
        String createBy=((User)request.getSession().getAttribute("user")).getName();
        String createTime= DateTimeUtil.getSysTime();

        String description=request.getParameter("description");
        String contactSummary=request.getParameter("contactSummary");
        String nextContactTime=request.getParameter("nextContactTime");
        String address=request.getParameter("address");
        Clue clue = new Clue();
        clue.setId(id);
        clue.setFullname(fullname);
        clue.setAppellation(appellation);
        clue.setOwner(owner);
        clue.setCompany(company);
        clue.setJob(job);
        clue.setEmail(email);
        clue.setPhone(phone);
        clue.setWebsite(website);
        clue.setMphone(mphone);
        clue.setState(state);
        clue.setSource(source);
        clue.setCreateBy(createBy);
        clue.setCreateTime(createTime);
        clue.setDescription(description);
        clue.setContactSummary(contactSummary);
        clue.setNextContactTime(nextContactTime);
        clue.setAddress(address);

        boolean flag=clueService.saveClue(clue);
        PrintJson.printJsonFlag(response,flag);
    }


    //获取用户列表，完成模态初始化
    private void getUserList(HttpServletRequest request, HttpServletResponse response) {
        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImp());
        List<User> usersList= activityService.userList();
        PrintJson.printJsonObj(response,usersList);
    }

    public void pageList(HttpServletRequest request,HttpServletResponse response){
        ClueService clueService =(ClueService) ServiceFactory.getService(new ClueServiceImp());
        String pageNum = request.getParameter("pageNum");
        String pageSize =request.getParameter("pageSize");
        String fullname=request.getParameter("fullname");
        String company=request.getParameter("company");
        String phone=request.getParameter("phone");
        String mphone=request.getParameter("mphone");
        String owner=request.getParameter("owner");
        String source =request.getParameter("source");
        String state=request.getParameter("state");
        //设置开始页和结束页的值
        int pageStart=(Integer.parseInt(pageNum)-1)*(Integer.parseInt(pageSize));
        int pageEnd=Integer.parseInt(pageSize);
        Map<String,Object> map = new HashMap<>();
        map.put("pageStart",pageStart);
        map.put("pageEnd",pageEnd);
        map.put("fullname",fullname);
        map.put("company",company);
        map.put("phone",phone);
        map.put("mphone",mphone);
        map.put("owner",owner);
        map.put("source",source);
        map.put("state",state);
        ActivityVo<Clue> vo= clueService.pageList(map);
        PrintJson.printJsonObj(response,vo);

    }

    public void deleteCar(HttpServletRequest request,HttpServletResponse response){
        String id = request.getParameter("id");
        ClueService clueService =(ClueService) ServiceFactory.getService(new ClueServiceImp());
        boolean flag=clueService.deleteCar(id);
        Map<String,Boolean> map = new HashMap<>();
        map.put("success",flag);
        ObjectMapper om =new ObjectMapper();
        try {
            String json=om.writeValueAsString(map);
            response.getWriter().print(json);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }


}
