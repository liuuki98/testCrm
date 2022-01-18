package com.liuuki.crm.settings.domain;

/**
 * @ClassName DictypeDao
 * @Description TOOD
 * @AuTHor 726465198
 * @Date 2022/1/17 9:53
 * @Version 1.0
 **/
public class Dictype {
    private String code;
    private String name;
    private String description;


    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}
