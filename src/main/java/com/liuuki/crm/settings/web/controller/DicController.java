package com.liuuki.crm.settings.web.controller;

import com.liuuki.crm.settings.domain.DicValue;
import com.liuuki.crm.settings.domain.Dictype;
import com.liuuki.crm.settings.service.DicService;
import com.liuuki.crm.settings.service.imp.DicServiceImp;
import com.liuuki.crm.util.PrintJson;
import com.liuuki.crm.util.ServiceFactory;
import com.liuuki.crm.util.UUIDUtil;
import com.liuuki.crm.vo.ActivityVo;
import net.sf.jsqlparser.util.validation.ValidationError;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

/**
 * @ClassName DicController
 * @Description TOOD
 * @AuTHor 726465198
 * @Date 2022/1/24 16:22
 * @Version 1.0
 **/
public class DicController extends HttpServlet {
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path=request.getServletPath();
        if("/settings/dic/getDicType.do".equals(path)){
            getDicType(request,response);
        }else if("/settings/dic/saveDicType.do".equals(path)){
            saveDicType(request,response);
        }else if("/settings/dic/deleteDicType.do".equals(path)){
            deleteDicType(request,response);

        }else if("/settings/dictionary/type/edit.do".equals(path)){
            edit(request,response);
        }else if("/settings/dic/updateType.do".equals(path)){
            updateType(request,response);
        }else if("/settings/dic/getDicValue.do".equals(path)){
            getDicValue(request,response);
        }else if("/settings/dictionary/value/enterSave.do".equals(path)){
            enterSave(request,response);
        }else if("/settings/dic/saveDicValue.do".equals(path)){
            saveDicValue(request,response);
        }else if("/settings/dic/deleteDicValue.do".equals(path)){
            deleteDicValue(request,response);
        }else if("/settings/dictionary/type/Valueedit.do".equals(path)){
            Valueedit(request,response);
        }else if("/settings/dic/updateValue.do".equals(path)){
            updateValue(request,response);

        }
    }

    private void updateValue(HttpServletRequest request, HttpServletResponse response) {
        DicService dicService = (DicService) ServiceFactory.getService(new DicServiceImp());
        String value=request.getParameter("value");
        String text=request.getParameter("text");
        String id=request.getParameter("id");
        String orderNo=request.getParameter("orderNo");
        DicValue dicValue = new DicValue();
        dicValue.setId(id);
        dicValue.setValue(value);
        dicValue.setText(text);
        dicValue.setOrderNo(orderNo);
        boolean flag = dicService.updateValue(dicValue);
        PrintJson.printJsonFlag(response,flag);

    }

    private void Valueedit(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("进入到valieEdit");
        DicService dicService = (DicService) ServiceFactory.getService(new DicServiceImp());
        String id=request.getParameter("id");
        DicValue dicValue =dicService.Valueedit(id);
        request.setAttribute("d",dicValue);
        request.getRequestDispatcher("/settings/dictionary/value/edit.jsp").forward(request,response);
    }

    private void deleteDicValue(HttpServletRequest request, HttpServletResponse response) {
        DicService dicService = (DicService) ServiceFactory.getService(new DicServiceImp());
        String ids[] =request.getParameterValues("id");
        boolean flag=dicService.deleteDicValue(ids);
        PrintJson.printJsonFlag(response,flag);
    }

    private void saveDicValue(HttpServletRequest request, HttpServletResponse response) {
        DicService dicService = (DicService) ServiceFactory.getService(new DicServiceImp());
        String typeCode=request.getParameter("typeCode");
        String value=request.getParameter("value");
        String text=request.getParameter("text");
        String orderNo=request.getParameter("orderNo");
        DicValue dicValue =new DicValue();
        dicValue.setId(UUIDUtil.getUUID());
        dicValue.setOrderNo(orderNo);
        dicValue.setText(text);
        dicValue.setTypeCode(typeCode);
        dicValue.setValue(value);

        System.out.println(dicValue.toString());

        boolean flag = dicService.saveDicValue(dicValue);
        PrintJson.printJsonFlag(response,flag);
    }

    private void enterSave(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        DicService dicService = (DicService) ServiceFactory.getService(new DicServiceImp());
        List<String> typeString = dicService.enterSave();
        request.setAttribute("typeCode",typeString);
        request.getRequestDispatcher("/settings/dictionary/value/save.jsp").forward(request,response);
    }

    private void getDicValue(HttpServletRequest request, HttpServletResponse response) {
        DicService dicService = (DicService) ServiceFactory.getService(new DicServiceImp());
        String pageSize=request.getParameter("pageSize");
        String pageNum=request.getParameter("pageNum");
        System.out.println(pageNum + pageNum);


        int pageStart=(Integer.parseInt(pageNum)-1)*(Integer.parseInt(pageSize));
        int pageEnd=Integer.parseInt(pageSize);
        Map<String,Object> map = new HashMap<>();
        map.put("pageStart",pageStart);
        map.put("pageEnd",pageEnd);

        ActivityVo<DicValue> dictypeActivityVo=dicService.DicValPageList(map);
        PrintJson.printJsonObj(response,dictypeActivityVo);
    }

    private void updateType(HttpServletRequest request, HttpServletResponse response) {
        DicService dicService = (DicService) ServiceFactory.getService(new DicServiceImp());
        String code=request.getParameter("code");
        String name=request.getParameter("name");
        String description=request.getParameter("description");
        Dictype dictype =new Dictype();
        dictype.setCode(code);
        dictype.setDescription(description);
        dictype.setName(name);
        boolean flag = dicService.updateType(dictype);
        PrintJson.printJsonFlag(response,flag);
    }

    private void edit(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        DicService dicService = (DicService) ServiceFactory.getService(new DicServiceImp());
        String code=request.getParameter("code");
        Dictype dictype =dicService.getTypeByCode(code);
        request.setAttribute("d",dictype);
        request.getRequestDispatcher("/settings/dictionary/type/edit.jsp").forward(request,response);

    }

    private void deleteDicType(HttpServletRequest request, HttpServletResponse response) {
        DicService dicService = (DicService) ServiceFactory.getService(new DicServiceImp());
        String ids[] =request.getParameterValues("code");
        boolean flag=dicService.deleteDicType(ids);
        PrintJson.printJsonFlag(response,flag);

    }

    private void saveDicType(HttpServletRequest request, HttpServletResponse response) {
        DicService dicService = (DicService) ServiceFactory.getService(new DicServiceImp());
        String code=request.getParameter("code");
        String name=request.getParameter("name");
        String description=request.getParameter("description");
        Dictype dictype =new Dictype();
        dictype.setCode(code);
        dictype.setDescription(description);
        dictype.setName(name);
        boolean flag = dicService.saveDicType(dictype);
        PrintJson.printJsonFlag(response,flag);
    }

    private void getDicType(HttpServletRequest request, HttpServletResponse response) {
        DicService dicService = (DicService) ServiceFactory.getService(new DicServiceImp());
        String pageSize=request.getParameter("pageSize");
        String pageNum=request.getParameter("pageNum");
        System.out.println(pageNum + pageNum);


        int pageStart=(Integer.parseInt(pageNum)-1)*(Integer.parseInt(pageSize));
        int pageEnd=Integer.parseInt(pageSize);
        Map<String,Object> map = new HashMap<>();
        map.put("pageStart",pageStart);
        map.put("pageEnd",pageEnd);

        ActivityVo<Dictype> dictypeActivityVo=dicService.getPageTypes(map);
        PrintJson.printJsonObj(response,dictypeActivityVo);
    }
}
