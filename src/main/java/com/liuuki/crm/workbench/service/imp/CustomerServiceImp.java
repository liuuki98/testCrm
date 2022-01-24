package com.liuuki.crm.workbench.service.imp;

import com.liuuki.crm.util.SqlSessionUtil;
import com.liuuki.crm.workbench.dao.CustomerDao;
import com.liuuki.crm.workbench.service.CustomerService;

import java.util.List;

/**
 * @ClassName CustomerServiceImp
 * @Description TOOD
 * @AuTHor 726465198
 * @Date 2022/1/19 21:50
 * @Version 1.0
 **/
public class CustomerServiceImp implements CustomerService {

    @Override
    public List<String> getCustomerName(String name) {
        CustomerDao customerDao = SqlSessionUtil.getSqlSession().getMapper(CustomerDao.class);
        List<String> strings= customerDao.getCustomerName(name);
        return strings;
    }

}
