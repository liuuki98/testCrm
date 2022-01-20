package com.liuuki.crm.workbench.web.controller;
import com.liuuki.crm.settings.domain.User;
import com.liuuki.crm.util.DateTimeUtil;
import com.liuuki.crm.util.PrintJson;
import com.liuuki.crm.util.ServiceFactory;

import com.liuuki.crm.util.UUIDUtil;
import com.liuuki.crm.vo.ActivityVo;
import com.liuuki.crm.workbench.domain.Activity;
import com.liuuki.crm.workbench.domain.Contacts;
import com.liuuki.crm.workbench.domain.Tran;
import com.liuuki.crm.workbench.service.ActivityService;
import com.liuuki.crm.workbench.service.ContactsService;
import com.liuuki.crm.workbench.service.CustomerService;
import com.liuuki.crm.workbench.service.TranService;
import com.liuuki.crm.workbench.service.imp.ActivityServiceImp;
import com.liuuki.crm.workbench.service.imp.ContactsServiceImp;
import com.liuuki.crm.workbench.service.imp.CustomerServiceImp;
import com.liuuki.crm.workbench.service.imp.TranServiceImp;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * @ClassName TransactionController
 * @Description TOOD
 * @AuTHor 726465198
 * @Date 2022/1/19 11:22
 * @Version 1.0
 **/
public class TransactionController extends HttpServlet {
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path=request.getServletPath();
        if("/workbench/transaction/create.do".equals(path)){
            create(request,response);
        }else if("/workbench/transaction/getCustomerName.do".equals(path)){
            getCustomerName(request,response);
        }else if("/workbench/transaction/getActivityByName.do".equals(path)){
            getActivityByName(request,response);
        }else if("/workbench/transaction/searchContactsByName.do".equals(path)){
            searchContactsByName(request,response);
        }else if("/workbench/transaction/saveTrans.do".equals(path)){
            saveTrans(request,response);
        }else if("/workbench/transaction/pageList.do".equals(path)){
            pageList(request,response);
        }else if("/workbench/transaction/detail.do".equals(path)){
            detail(request,response);

        }
    }

    /**
     * 处理请求跳转到detail页面
     * @param request
     * @param response
     */
    private void detail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id=request.getParameter("id");

        TranService tranService=(TranService)ServiceFactory.getService(new TranServiceImp());
        Tran tran=tranService.detail(id);
        System.out.println("客户的名字是（ID）"+tran.getCustomerId());
        String stage=tran.getStage();
        Map<String,String> map =(Map<String, String>) request.getServletContext().getAttribute("map");
        String posibility = map.get(stage);
        request.setAttribute("posibility",posibility);
        request.setAttribute("tran",tran);
        request.getRequestDispatcher("/workbench/transaction/detail.jsp").forward(request,response);

    }

    private void pageList(HttpServletRequest request, HttpServletResponse response) {
        TranService tranService=(TranService)ServiceFactory.getService(new TranServiceImp());
        String pageNum=request.getParameter("pageNum");
        String pageSize=request.getParameter("pageSize");
        String owner=request.getParameter("owner");
        String name=request.getParameter("name");
        String customerName=request.getParameter("customerName");
        String stage=request.getParameter("stage");
        String type=request.getParameter("type");
        String source=request.getParameter("source");
        String contactsName=request.getParameter("contactsName");
        //设置开始页和结束页的值
        int pageStart=(Integer.parseInt(pageNum)-1)*(Integer.parseInt(pageSize));
        int pageEnd=Integer.parseInt(pageSize);
        Map<String,Object> map = new HashMap<>();

        map.put("pageStart",pageStart);
        map.put("pageEnd",pageEnd);
        map.put("owner",owner);
        map.put("name",name);
        map.put("customerName",customerName);
        map.put("stage",stage);
        map.put("type",type);
        map.put("source",source);
        map.put("contactsName",contactsName);
        int count=tranService.getTotalPages(map);
        List<Tran> tranList =tranService.pageList(map);
        ActivityVo<Tran> vo = new ActivityVo<>();
        vo.setPagesTotal(count);
        vo.setDatalist(tranList);
        PrintJson.printJsonObj(response,vo);
    }

    private void saveTrans(HttpServletRequest request, HttpServletResponse response) throws IOException {
        System.out.println("进入到Tran控制器的saveTrans方法");
        System.out.println("contactsId:"+request.getParameter("contactsId"));
        TranService transervice =(TranService)ServiceFactory.getService(new TranServiceImp());

        String id = UUIDUtil.getUUID();
        String owner =request.getParameter("owner");
        String money =request.getParameter("money");
        String name =request.getParameter("name");
        String expectedDate =request.getParameter("expectedDate");
        String customerName =request.getParameter("customerName");
        String stage =request.getParameter("stage");
        String type =request.getParameter("type");
        String source =request.getParameter("source");
        String activityId =request.getParameter("activityId");
        String contactsId =request.getParameter("contactsId");
        String createBy =((User)request.getSession().getAttribute("user")).getName();
        String createTime = DateTimeUtil.getSysTime();
        String description =request.getParameter("description");
        String contactSummary =request.getParameter("contactSummary");
        String nextContactTime =request.getParameter("nextContactTime");

        Tran tran = new Tran();
        tran.setId(id);
        tran.setOwner(owner);
        tran.setMoney(money);
        tran.setName(name);
        tran.setExpectedDate(expectedDate);
        tran.setStage(stage);
        tran.setType(type);
        tran.setSource(source);
        tran.setActivityId(activityId);
        tran.setContactsId(contactsId);
        tran.setCreateBy(createBy);
        tran.setCreateTime(createTime);
        tran.setDescription(description);
        tran.setContactSummary(contactSummary);
        tran.setNextContactTime(nextContactTime);
       boolean flag=transervice.saveTrans(tran,customerName);
       if(flag){
           System.out.println(request.getContextPath());
           response.sendRedirect(request.getContextPath()+"/workbench/transaction/index.jsp");
       }

    }

    private void searchContactsByName(HttpServletRequest request, HttpServletResponse response) {
        String name=request.getParameter("name");
        ContactsService contactsService=(ContactsService)ServiceFactory.getService(new ContactsServiceImp());
        List<Contacts> contacts = contactsService.searchContactsByName(name);
        PrintJson.printJsonObj(response,contacts);
    }

    private void getActivityByName(HttpServletRequest request, HttpServletResponse response) {

        String name=request.getParameter("name");
        ActivityService activityService=(ActivityService)ServiceFactory.getService(new ActivityServiceImp());
        List<Activity> activity = activityService.searchActivityByName(name);
        PrintJson.printJsonObj(response,activity);
    }

    private void getCustomerName(HttpServletRequest request, HttpServletResponse response) {
        String name=request.getParameter("name");
        CustomerService customerService =(CustomerService) ServiceFactory.getService(new CustomerServiceImp());
        List<String> list=customerService.getCustomerName(name);
        PrintJson.printJsonObj(response,list);
    }

    private void create(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImp());
        List<User> userList= activityService.userList();
        request.setAttribute("users",userList);
        request.getRequestDispatcher("/workbench/transaction/save.jsp").forward(request,response);

    }
}
