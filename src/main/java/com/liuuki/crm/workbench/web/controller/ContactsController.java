package com.liuuki.crm.workbench.web.controller;

import com.liuuki.crm.settings.domain.User;
import com.liuuki.crm.settings.service.UserService;
import com.liuuki.crm.settings.service.imp.UserServiceImp;
import com.liuuki.crm.util.DateTimeUtil;
import com.liuuki.crm.util.PrintJson;
import com.liuuki.crm.util.ServiceFactory;
import com.liuuki.crm.util.UUIDUtil;
import com.liuuki.crm.vo.ActivityVo;
import com.liuuki.crm.workbench.domain.Clue;
import com.liuuki.crm.workbench.domain.Contacts;
import com.liuuki.crm.workbench.service.ActivityService;
import com.liuuki.crm.workbench.service.ClueService;
import com.liuuki.crm.workbench.service.ContactsService;
import com.liuuki.crm.workbench.service.CustomerService;
import com.liuuki.crm.workbench.service.imp.ActivityServiceImp;
import com.liuuki.crm.workbench.service.imp.ClueServiceImp;
import com.liuuki.crm.workbench.service.imp.ContactsServiceImp;
import com.liuuki.crm.workbench.service.imp.CustomerServiceImp;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @ClassName ContactsController
 * @Description TOOD
 * @AuTHor 726465198
 * @Date 2022/1/24 10:19
 * @Version 1.0
 **/
public class ContactsController extends HttpServlet {
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path=request.getServletPath();
        if("/workbench/contacts/getUserList.do".equals(path)){
            getUserList(request,response);
        }else if("/workbench/contacts/getCustomerByName.do".equals(path)){
            getCustomerByName(request,response);
        }else if("/workbench/contacts/saveCustomer.do".equals(path)){
            saveCustomer(request,response);
        }else if("/workbench/contacts/pageList.do".equals(path)){
            pageList(request,response);
        }else if("/workbench/contacts/deleteContacts.do".equals(path)){
            deleteContacts(request,response);
        }else if("/workbench/contacts/detail.do".equals(path)){
            detail(request,response);
        }
    }

    private void detail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id=request.getParameter("id");
        ContactsService contactsService=(ContactsService)ServiceFactory.getService(new ContactsServiceImp());
        Contacts contacts =contactsService.getContactsByid(id);
        request.setAttribute("c",contacts);
        request.getRequestDispatcher("/workbench/contacts/detail.jsp").forward(request,response);

    }

    private void deleteContacts(HttpServletRequest request, HttpServletResponse response) {
        String id[] =request.getParameterValues("id");
        ContactsService contactsService=(ContactsService)ServiceFactory.getService(new ContactsServiceImp());

        boolean flag = contactsService.deleteContacts(id);
        PrintJson.printJsonFlag(response,flag);
    }

    private void pageList(HttpServletRequest request, HttpServletResponse response) {
        ContactsService contactsService=(ContactsService)ServiceFactory.getService(new ContactsServiceImp());
        String pageSize=request.getParameter("pageSize");
        String pageNum=request.getParameter("pageNum");
        String fullname=request.getParameter("fullname");
        String owner = request.getParameter("owner");
        String birth=request.getParameter("birth");
        String source =request.getParameter("source");
        String customerName=request.getParameter("customerName");

        int pageStart=(Integer.parseInt(pageNum)-1)*(Integer.parseInt(pageSize));
        int pageEnd=Integer.parseInt(pageSize);
        Map<String,Object> map = new HashMap<>();
        map.put("pageStart",pageStart);
        map.put("pageEnd",pageEnd);
        map.put("fullname",fullname);
        map.put("owner",owner);
        map.put("birth",birth);
        map.put("source",source);
        map.put("customerName",customerName);
        System.out.println(map.toString());
        ActivityVo<Contacts> vo= contactsService.pageList(map);
        PrintJson.printJsonObj(response,vo);
    }

    private void saveCustomer(HttpServletRequest request, HttpServletResponse response) {
        ContactsService contactsService=(ContactsService)ServiceFactory.getService(new ContactsServiceImp());
        String id = UUIDUtil.getUUID();
        String owner = request.getParameter("owner");
        String source = request.getParameter("source");
        String customerName = request.getParameter("customerId");
        String fullname = request.getParameter("fullname");
        String appellation = request.getParameter("appellation");
        String email  = request.getParameter("email");
        String mphone = request.getParameter("mphone");
        String job = request.getParameter("job");
        String birth = request.getParameter("birth");
        String createBy =((User)request.getSession().getAttribute("user")).getName();
        String createTime = DateTimeUtil.getSysTime();
        String description  = request.getParameter("description");
        String contactSummary = request.getParameter("contactSummary");
        String nextContactTime = request.getParameter("nextContactTime");
        String address = request.getParameter("address");

        Contacts contacts = new Contacts();
        contacts.setId(id);
        contacts.setOwner(owner);
        contacts.setSource(source);
        contacts.setCustomerId(customerName);
        contacts.setFullname(fullname);
        contacts.setAppellation(appellation);
        contacts.setEmail(email);
        contacts.setMphone(mphone);
        contacts.setJob(job);
        contacts.setBirth(birth);
        contacts.setCreateBy(createBy);
        contacts.setCreateTime(createTime);
        contacts.setDescription(description);
        contacts.setContactSummary(contactSummary);
        contacts.setNextContactTime(nextContactTime);
        contacts.setAddress(address);
        boolean flag = contactsService.saveCustomer(contacts);
        PrintJson.printJsonFlag(response,flag);

    }

    private void getCustomerByName(HttpServletRequest request, HttpServletResponse response) {
        String name = request.getParameter("name");
        CustomerService customerService =(CustomerService)ServiceFactory.getService(new CustomerServiceImp());
        List<String> nameList=customerService.getCustomerName(name);
        PrintJson.printJsonObj(response,nameList);
    }

    private void getUserList(HttpServletRequest request, HttpServletResponse response) {
        ActivityService userService = (ActivityService) ServiceFactory.getService(new ActivityServiceImp());
        List<User> userList = userService.userList();
        PrintJson.printJsonObj(response,userList);
    }
}
