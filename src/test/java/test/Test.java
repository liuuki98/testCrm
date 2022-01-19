package test;

import com.liuuki.crm.settings.dao.DictypeDao;
import com.liuuki.crm.settings.domain.Dictype;
import com.liuuki.crm.util.MD5Util;
import com.liuuki.crm.util.SqlSessionUtil;

import java.util.List;

/**
 * @ClassName Test
 * @Description TOOD
 * @AuTHor 726465198
 * @Date 2022/1/11 14:35
 * @Version 1.0
 **/
public class Test {
    public static void main(String[] args) {
        DictypeDao dic = SqlSessionUtil.getSqlSession().getMapper(DictypeDao.class);
        List<Dictype> dictypeList= dic.getTypes();
    }


//    Map<String,String> map1=new HashMap<>();
////        ResourceBundle rb =ResourceBundle.getBundle("Stage2Possibility");
////        Enumeration<String> keys = rb.getKeys();
////        while(keys.hasMoreElements()){
////            String key=keys.nextElement();
////
////            String value=rb.getString(key);
////            map1.put(key,value);
////        }
////
////        servletContext.setAttribute("map",map1);

}
