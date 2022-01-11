package com.liuuki.crm.webFilter;

import javax.servlet.*;
import java.io.IOException;

/**
 * @ClassName EncodingFilter
 * @Description TOOD
 * @AuTHor 726465198
 * @Date 2022/1/11 18:43
 * @Version 1.0
 **/
public class EncodingFilter implements Filter {
    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
        System.out.println("进入到编码过滤器");

    }
}
