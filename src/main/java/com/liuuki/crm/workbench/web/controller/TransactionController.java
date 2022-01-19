package com.liuuki.crm.workbench.web.controller;
import com.liuuki.crm.settings.domain.User;
import com.liuuki.crm.util.PrintJson;
import com.liuuki.crm.util.ServiceFactory;

import com.liuuki.crm.workbench.domain.Activity;
import com.liuuki.crm.workbench.domain.Contacts;
import com.liuuki.crm.workbench.service.ActivityService;
import com.liuuki.crm.workbench.service.ContactsService;
import com.liuuki.crm.workbench.service.CustomerService;
import com.liuuki.crm.workbench.service.imp.ActivityServiceImp;
import com.liuuki.crm.workbench.service.imp.ContactsServiceImp;
import com.liuuki.crm.workbench.service.imp.CustomerServiceImp;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

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
