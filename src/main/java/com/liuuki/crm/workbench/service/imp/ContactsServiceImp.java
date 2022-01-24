package com.liuuki.crm.workbench.service.imp;

import com.liuuki.crm.util.SqlSessionUtil;
import com.liuuki.crm.util.UUIDUtil;
import com.liuuki.crm.vo.ActivityVo;
import com.liuuki.crm.workbench.dao.*;
import com.liuuki.crm.workbench.domain.Clue;
import com.liuuki.crm.workbench.domain.Contacts;
import com.liuuki.crm.workbench.domain.ContactsRemark;
import com.liuuki.crm.workbench.domain.Customer;
import com.liuuki.crm.workbench.service.ContactsService;

import java.util.List;
import java.util.Map;

/**
 * @ClassName ContactsServiceImp
 * @Description TOOD
 * @AuTHor 726465198
 * @Date 2022/1/19 12:33
 * @Version 1.0
 **/
public class ContactsServiceImp implements ContactsService {


    @Override
    public List<Contacts> searchContactsByName(String name) {
        ContactsDao contactsDao = SqlSessionUtil.getSqlSession().getMapper(ContactsDao.class);
        List<Contacts> contacts = contactsDao.searchContactsByName(name);
        return contacts;

    }

    @Override
    public boolean saveCustomer(Contacts contacts) {
        boolean flag=true;
        ContactsDao contactsDao = SqlSessionUtil.getSqlSession().getMapper(ContactsDao.class);
        CustomerDao customerDao = SqlSessionUtil.getSqlSession().getMapper(CustomerDao.class);
        Customer customer=customerDao.getCustomerByName(contacts.getCustomerId());


        if(customer==null){

            customer=new Customer();
            customer.setId(UUIDUtil.getUUID());
            customer.setName(contacts.getCustomerId());
            customer.setCreateBy(contacts.getCreateBy());
            customer.setCreateTime(contacts.getCreateTime());
            customer.setContactSummary(contacts.getContactSummary());
            customer.setNextContactTime(contacts.getNextContactTime());
            customer.setOwner(contacts.getOwner());

            int i = customerDao.saveCustomer(customer);
            if(i!=1){
                flag=false;
            }
        }
        System.out.println(flag);
        contacts.setCustomerId(customer.getId());

        int i2=contactsDao.saveContacts(contacts);
        if(i2!=1){
            flag=false;
        }
        System.out.println(flag);

        return flag;
    }

    @Override
    public ActivityVo<Contacts> pageList(Map<String, Object> map) {
        ContactsDao contactsDao = SqlSessionUtil.getSqlSession().getMapper(ContactsDao.class);
        int i =contactsDao.getTotalPages();
        List<Contacts> contactsList= contactsDao.selectByCondition(map);

        ActivityVo<Contacts> vo = new ActivityVo<>();
        vo.setDatalist(contactsList);
        vo.setPagesTotal(i);

        return vo;
    }

    @Override
    public boolean deleteContacts(String[] id) {
        boolean flag=true;
        ContactsRemarkDao contactsRemarkDao=SqlSessionUtil.getSqlSession().getMapper(ContactsRemarkDao.class);

        int remark = contactsRemarkDao.getConRemarkByClueIds(id);
        int deleteRemark=contactsRemarkDao.deleteRemarkByCIds(id);

        if(deleteRemark!=remark){
            flag=false;
        }
        System.out.println(flag);
        System.out.println(deleteRemark);
        System.out.println(remark);
        ContactsActivityRelationDao contactsActivityRelationDao=SqlSessionUtil.getSqlSession().getMapper(ContactsActivityRelationDao.class);
        int remark3=contactsActivityRelationDao.getCarByClueIds(id);
        int remark2=contactsActivityRelationDao.deleteCarByClueIds(id);

        if(remark2!=remark3){
            flag=false;
        }
        System.out.println(flag);
        System.out.println(remark2);
        System.out.println(remark3);
        ContactsDao contactsDao = SqlSessionUtil.getSqlSession().getMapper(ContactsDao.class);
        int i =contactsDao.deleteClue(id);
        if(i!=id.length){
            flag=false;
        }
        System.out.println(flag);
        return flag;
    }

    @Override
    public Contacts getContactsByid(String id) {
        ContactsDao contactsDao = SqlSessionUtil.getSqlSession().getMapper(ContactsDao.class);
        Contacts contacts = contactsDao.getContactsByid(id);
        return contacts;
    }
}
