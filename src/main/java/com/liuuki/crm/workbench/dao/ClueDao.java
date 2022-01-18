package com.liuuki.crm.workbench.dao;

import com.liuuki.crm.workbench.domain.Clue;

import java.util.List;
import java.util.Map;

public interface ClueDao {
    int saveClue(Clue clue);

    int getTotalPages();

    List<Clue> selectByCondition(Map<String, Object> map);

    Clue getClueById(String id);

    int deleteClueById(String clueId);
}
