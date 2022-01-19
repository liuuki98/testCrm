package com.liuuki.crm.settings.web.listener;

import com.liuuki.crm.settings.domain.DicValue;
import com.liuuki.crm.settings.domain.Dictype;
import com.liuuki.crm.settings.service.DicService;
import com.liuuki.crm.settings.service.imp.DicServiceImp;
import com.liuuki.crm.util.ServiceFactory;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * @ClassName Initlistener
 * @Description TOOD
 * @AuTHor 726465198
 * @Date 2022/1/17 9:20
 * @Version 1.0
 **/
public class Initlistener implements ServletContextListener {
    @Override
    public void contextInitialized(ServletContextEvent event) {

        ServletContext servletContext=event.getServletContext();
        Map<String,List<DicValue>> map = new HashMap<>();
        DicService dicService =(DicService)ServiceFactory.getService(new DicServiceImp());


        List<Dictype> dictypeList=dicService.getTypes();
        for(Dictype dictype:dictypeList){
            String code = dictype.getCode();
            List<DicValue> dIcValueList= dicService.getvalues(code);
            map.put(code,dIcValueList);

        }
        Set<String> set =map.keySet();
        for(String key:set){
            servletContext.setAttribute(key,map.get(key));
        }
    }
}