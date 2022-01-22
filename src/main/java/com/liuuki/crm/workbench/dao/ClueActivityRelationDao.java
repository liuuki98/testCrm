package com.liuuki.crm.workbench.dao;

import com.liuuki.crm.workbench.domain.ClueActivityRelation;

import java.util.List;

public interface ClueActivityRelationDao {
    int deleteCar(String id);

    int bindClueAndAc(ClueActivityRelation activityRelation);

    List<ClueActivityRelation> getClueActivityRelationList(String clueId);

    int deleteCarByClueId(String clueId);

    int getCarByClueIds(String[] id);

    int deleteCarByClueIds(String[] id);
}
