package com.liuuki.crm.workbench.service.imp;

import com.liuuki.crm.util.DateTimeUtil;
import com.liuuki.crm.util.SqlSessionUtil;
import com.liuuki.crm.util.UUIDUtil;
import com.liuuki.crm.vo.ActivityVo;
import com.liuuki.crm.workbench.dao.*;
import com.liuuki.crm.workbench.domain.*;
import com.liuuki.crm.workbench.service.ClueService;
import com.mysql.cj.util.TimeUtil;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;

import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.TimeUnit;

/**
 * @ClassName ClueServiceImp
 * @Description TOOD
 * @AuTHor 726465198
 * @Date 2022/1/15 18:14
 * @Version 1.0
 **/
public class ClueServiceImp implements ClueService {
    private ClueDao clueDao = SqlSessionUtil.getSqlSession().getMapper(ClueDao.class);

    @Override
    public boolean saveClue(Clue clue) {
        boolean flag=true;

        int i=clueDao.saveClue(clue);
        if(i!=1){
            flag=false;
        }
        return flag;
    }

    @Override
    public ActivityVo<Clue> pageList(Map<String, Object> map) {
        int i =clueDao.getTotalPages();
       List<Clue> clueList= clueDao.selectByCondition(map);

       ActivityVo<Clue> vo = new ActivityVo<>();
       vo.setDatalist(clueList);
       vo.setPagesTotal(i);

        return vo;
    }

    @Override
    public Clue getClueById(String id) {
        ClueDao clueDao2 = SqlSessionUtil.getSqlSession().getMapper(ClueDao.class);
        Clue clue=clueDao2.getClueById(id);
        return clue;
    }

    @Override
    public Clue getClueById2(String id) {
        Clue clue=clueDao.getClueById2(id);
        return clue;
    }

    @Override
    public boolean deleteCar(String id) {
        boolean flag = true;
        ClueActivityRelationDao activityRelationDao=SqlSessionUtil.getSqlSession().getMapper(ClueActivityRelationDao.class);
        int i =activityRelationDao.deleteCar(id);
        if(i!=1){
            flag=false;
        }
        return flag;
    }

    @Override
    public boolean bindClueAndAc(String[] aIds, String cid) {
        boolean flag =true;
        ClueActivityRelationDao activityRelationDao=SqlSessionUtil.getSqlSession().getMapper(ClueActivityRelationDao.class);
        for (String aid :aIds){
            ClueActivityRelation activityRelation = new ClueActivityRelation();
            activityRelation.setId(UUIDUtil.getUUID());
            activityRelation.setActivityId(aid);
            activityRelation.setClueId(cid);
            int i = activityRelationDao.bindClueAndAc(activityRelation);
            if(i!=1){
                flag=false;
            }
        }


        return flag;
    }

    @Override
    public boolean convert(Tran trans, String clueId, String createBy) {
        //创建相关表连接
        //线索相关
        ClueDao clueDao = SqlSessionUtil.getSqlSession().getMapper(ClueDao.class);
        ClueRemarkDao clueRemarkDao =SqlSessionUtil.getSqlSession().getMapper(ClueRemarkDao.class);
        ClueActivityRelationDao clueActivityRelationDao = SqlSessionUtil.getSqlSession().getMapper(ClueActivityRelationDao.class);

        //客户相关表
        CustomerDao customerDao=SqlSessionUtil.getSqlSession().getMapper(CustomerDao.class);
        CustomerRemarkDao customerRemarkDao = SqlSessionUtil.getSqlSession().getMapper(CustomerRemarkDao.class);

        //联系人相关表
        ContactsDao contactsDao = SqlSessionUtil.getSqlSession().getMapper(ContactsDao.class);
        ContactsRemarkDao contactsRemarkDao = SqlSessionUtil.getSqlSession().getMapper(ContactsRemarkDao.class);
        ContactsActivityRelationDao contactsActivityRelationDao = SqlSessionUtil.getSqlSession().getMapper(ContactsActivityRelationDao.class);
        //交易相关表
        TranDao tranDao = SqlSessionUtil.getSqlSession().getMapper(TranDao.class);
        TranHistoryDao tranHistoryDao = SqlSessionUtil.getSqlSession().getMapper(TranHistoryDao.class);
        //市场活动表
        ActivityDao activityDao =SqlSessionUtil.getSqlSession().getMapper(ActivityDao.class);

        //创建公用时间
        String time = DateTimeUtil.getSysTime();



        boolean flag=true;
        //(1) 获取到线索id，通过线索id获取线索对象（线索对象当中封装了线索的信息）
        Clue clue = clueDao.getClueById(clueId);

        //(2) 通过线索对象提取客户信息，当该客户不存在的时候，新建客户（根据公司的名称精确匹配，判断该客户是否存在！）

        Customer customer= customerDao.getCustomerByName(clue.getCompany());
        if(customer==null){
            customer=new Customer();
            customer.setId(UUIDUtil.getUUID());
            customer.setOwner(clue.getOwner());
            customer.setName(clue.getCompany());
            customer.setWebsite(clue.getWebsite());
            customer.setPhone(clue.getPhone());
            customer.setCreateBy(createBy);
            customer.setCreateTime(time);
            customer.setContactSummary(clue.getContactSummary());
            customer.setNextContactTime(clue.getNextContactTime());
            customer.setDescription(clue.getDescription());
            customer.setAddress(clue.getAddress());

            int i =customerDao.saveCustomer(customer);
            if(i!=1){
                flag=false;
            }

        }

        //(3) 通过线索对象提取联系人信息，保存联系人
        Contacts contacts=new Contacts();
        contacts.setId(UUIDUtil.getUUID());
        contacts.setOwner(clue.getOwner());
        contacts.setSource(clue.getSource());
        contacts.setCustomerId(customer.getId());
        contacts.setFullname(clue.getFullname());
        contacts.setAppellation(clue.getAppellation());
        contacts.setEmail(clue.getEmail());
        contacts.setMphone(clue.getMphone());
        contacts.setJob(clue.getJob());
        contacts.setCreateBy(createBy);
        contacts.setCreateTime(time);
        contacts.setDescription(clue.getDescription());
        contacts.setContactSummary(clue.getContactSummary());
        contacts.setNextContactTime(clue.getNextContactTime());
        contacts.setAddress(clue.getAddress());
        int i =contactsDao.saveContacts(contacts);
        if(i!=1){
            flag=false;
        }

        //(4) 线索备注转换到客户备注以及联系人备注
        //根据clueID查找相应的线索备注
        List<ClueRemark> clueRemarkList=clueRemarkDao.getClueRemarkByClueId(clueId);
        for (ClueRemark clueRemark:clueRemarkList){
            //转换到客户备注
            CustomerRemark customerRemark = new CustomerRemark();
            customerRemark.setId(UUIDUtil.getUUID());
            customerRemark.setNoteContent(clueRemark.getNoteContent());
            customerRemark.setCreateBy(createBy);
            customerRemark.setCreateTime(time);
            customerRemark.setCustomerId(customer.getId());
            customerRemark.setEditFlag("0");
            int i1 =customerRemarkDao.saveCustomerRemark(customerRemark);
            if(i1!=1){
                flag=false;
            }

            //转换到联系人备注
            ContactsRemark contactsRemark = new ContactsRemark();
            contactsRemark.setId(UUIDUtil.getUUID());
            contactsRemark.setNoteContent(clueRemark.getNoteContent());
            contactsRemark.setCreateBy(createBy);
            contactsRemark.setCreateTime(time);
            contactsRemark.setContactsId(contacts.getId());
            contactsRemark.setEditFlag("0");

            int i2 =contactsRemarkDao.saveContactsRemark(contactsRemark);
            if(i2!=1){
                flag=false;
            }

        }

        //5) “线索和市场活动”的关系转换到“联系人和市场活动”的关系

        List<ClueActivityRelation> clueActivityRelationList = clueActivityRelationDao.getClueActivityRelationList(clueId);
        for(ClueActivityRelation clueActivityRelation :clueActivityRelationList){
            ContactsActivityRelation contactsActivityRelation = new ContactsActivityRelation();
            contactsActivityRelation.setId(UUIDUtil.getUUID());
            contactsActivityRelation.setActivityId(clueActivityRelation.getActivityId());
            contactsActivityRelation.setContactsId(contacts.getId());
            int i3 = contactsActivityRelationDao.saveContactsActivityRelation(contactsActivityRelation);
            if(i3!=1){
                flag=false;
            }
        }

        //(6)如果有创建交易需求，创建一条交易
        if(trans!=null){


            trans.setOwner(clue.getOwner());
            trans.setCustomerId(customer.getId());
            trans.setSource(clue.getSource());
            trans.setDescription(clue.getDescription());
            trans.setContactSummary(clue.getContactSummary());
            trans.setNextContactTime(clue.getNextContactTime());
            trans.setContactsId(contacts.getId());
            trans.setCreateTime(time);
            int i4 = tranDao.saveTran(trans);
            if(i4!=1){
                flag=false;
            }
            //如果创建了交易，则创建一条该交易下的交易历史
            TranHistory tranHistory= new TranHistory();
            tranHistory.setId(UUIDUtil.getUUID());
            tranHistory.setStage(clue.getState());
            tranHistory.setMoney(trans.getMoney());
            tranHistory.setExpectedDate(trans.getExpectedDate());
            tranHistory.setCreateTime(time);
            tranHistory.setCreateBy(createBy);
            tranHistory.setTranId(trans.getId());
            int i5 =tranHistoryDao.saveTranHistory(tranHistory);
            if(i5!=1){
                flag=false;
            }

        }

        //(8) 删除线索备注
        int i5=clueRemarkDao.deleteClueRemark(clueId);
        if(i5!=1){
            flag=false;
        }
        //(9) 删除线索和市场活动的关系
        int i6=clueActivityRelationDao.deleteCarByClueId(clueId);
        if(i6!=1){
            flag=false;
        }
        //(10) 删除线索
        int i7=clueDao.deleteClueById(clueId);
        if(i7!=1){
            flag=false;
        }

        return flag;
    }

    @Override
    public boolean updateClue(Clue clue) {
        boolean flag=true;
        int i =clueDao.updateClue(clue);
        if(i!=1){
            flag=false;
        }
        return flag;
    }

    @Override
    public boolean deleteClue(String[] id) {
        boolean flag=true;
        int i =clueDao.deleteClue(id);
        if(i!=1){
            flag=false;
        }
        return flag;
    }

    @Override
    public boolean deleteClueById(String id) {
        boolean flag=true;
        int i =clueDao.deleteClueById(id);
        if(i!=1){
            flag=false;
        }
        return flag;
    }

    @Override
    public List<ClueRemark> getRemarkList(String id) {
        ClueRemarkDao clueRemarkDao = SqlSessionUtil.getSqlSession().getMapper(ClueRemarkDao.class);
        List<ClueRemark> clueRemarkList = clueRemarkDao.getRemarkList(id);
        return clueRemarkList;
    }

    @Override
    public boolean deleteClueRemarkByid(String id) {
        ClueRemarkDao clueRemarkDao = SqlSessionUtil.getSqlSession().getMapper(ClueRemarkDao.class);
        boolean flag=true;
        int i =clueRemarkDao.deleteClueRemarkByid(id);
        if(i!=1){
            flag=false;
        }
        return flag;
    }
}
