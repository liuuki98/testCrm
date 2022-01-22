package com.liuuki.crm.workbench.service;

import com.liuuki.crm.vo.ActivityVo;
import com.liuuki.crm.workbench.domain.Clue;
import com.liuuki.crm.workbench.domain.ClueRemark;
import com.liuuki.crm.workbench.domain.Tran;

import java.util.List;
import java.util.Map;

public interface ClueService {

    boolean saveClue(Clue clue);

    ActivityVo<Clue> pageList(Map<String, Object> map);

    Clue getClueById(String id);
    //删除市场活动和线索的关联
    boolean deleteCar(String id);

    boolean bindClueAndAc(String[] aIds, String cid);

    boolean convert(Tran trans, String clueId, String createBy);

    Clue getClueById2(String id);

    boolean updateClue(Clue clue);

    boolean deleteClue(String[] id);

    boolean deleteClueById(String id);

    List<ClueRemark> getRemarkList(String id);

    boolean deleteClueRemarkByid(String id);

    ClueRemark getClueRemarkByid(String id);


    boolean updateRemark(ClueRemark clueRemark);

    boolean saveRemark(ClueRemark clueRemark);
}
