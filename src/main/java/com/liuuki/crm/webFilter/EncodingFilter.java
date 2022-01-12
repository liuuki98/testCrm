package com.liuuki.crm.webFilter;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * @ClassName EncodingFilter
 * @Description TOOD
 * @AuTHor 726465198
 * @Date 2022/1/11 18:43
 * @Version 1.0
 **/
public class EncodingFilter implements Filter {
    private String encoding = null;

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
        System.out.println("进入到编码过滤器");
        HttpServletRequest request = (HttpServletRequest)servletRequest;
        HttpServletResponse response =(HttpServletResponse)servletResponse;
        request.setCharacterEncoding(encoding);
        response.setCharacterEncoding(encoding);
        filterChain.doFilter(request,response);

    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        encoding = filterConfig.getInitParameter("encoding");
    }
}
