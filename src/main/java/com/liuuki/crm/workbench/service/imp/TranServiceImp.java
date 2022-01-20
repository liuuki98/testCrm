package com.liuuki.crm.workbench.service.imp;

import com.liuuki.crm.util.SqlSessionUtil;
import com.liuuki.crm.util.UUIDUtil;
import com.liuuki.crm.workbench.dao.ContactsDao;
import com.liuuki.crm.workbench.dao.CustomerDao;
import com.liuuki.crm.workbench.dao.TranDao;
import com.liuuki.crm.workbench.dao.TranHistoryDao;
import com.liuuki.crm.workbench.domain.Contacts;
import com.liuuki.crm.workbench.domain.Customer;
import com.liuuki.crm.workbench.domain.Tran;
import com.liuuki.crm.workbench.domain.TranHistory;
import com.liuuki.crm.workbench.service.TranService;

/**
 * @ClassName TranServiceImp
 * @Description TOOD
 * @AuTHor 726465198
 * @Date 2022/1/20 12:07
 * @Version 1.0
 **/
public class TranServiceImp implements TranService {
    @Override
    public boolean saveTrans(Tran tran, String customerName) {
        boolean flag=true;
        CustomerDao customerDao = SqlSessionUtil.getSqlSession().getMapper(CustomerDao.class);
        TranDao tranDao=SqlSessionUtil.getSqlSession().getMapper(TranDao.class);
        TranHistoryDao tranHistoryDao = SqlSessionUtil.getSqlSession().getMapper(TranHistoryDao.class);


        Customer customer = customerDao.getSingleCusByName(customerName);

        if(customer==null){
            customer=new Customer();
            customer.setId(UUIDUtil.getUUID());
            customer.setName(customerName);
            customer.setCreateBy(tran.getCreateBy());
            customer.setCreateTime(tran.getCreateTime());
            customer.setContactSummary(tran.getContactSummary());
            customer.setNextContactTime(tran.getNextContactTime());
            customer.setOwner(tran.getOwner());

            int i2=customerDao.saveCustomer(customer);
            if(i2!=1){
                flag=false;
            }

        }
        tran.setCustomerId(customer.getId());
        int i=tranDao.saveTran(tran);
        if(i!=1){
            flag=false;
        }
        TranHistory tranHistory = new TranHistory();
        tranHistory.setId(UUIDUtil.getUUID());
        tranHistory.setTranId(tran.getId());
        tranHistory.setCreateBy(tran.getCreateBy());
        tranHistory.setCreateTime(tran.getCreateTime());
        tranHistory.setMoney(tran.getMoney());
        tranHistory.setExpectedDate(tran.getExpectedDate());
        tranHistory.setStage(tran.getStage());

        int i2=tranHistoryDao.saveTranHistory(tranHistory);
        if(i2!=1){
            flag=false;
        }

        return flag;
    }
}
