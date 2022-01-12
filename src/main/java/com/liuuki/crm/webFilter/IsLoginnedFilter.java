package com.liuuki.crm.webFilter;

import com.liuuki.crm.settings.domain.User;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * @ClassName IsLoginnedFilter
 * @Description TOOD
 * @AuTHor 726465198
 * @Date 2022/1/12 10:10
 * @Version 1.0
 **/
public class IsLoginnedFilter implements Filter {
    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest)servletRequest;
        HttpServletResponse response = (HttpServletResponse)servletResponse;

        System.out.println(request.getContextPath()+"/login.jsp");
        System.out.println(request.getServletPath());
        String path = request.getServletPath();
        if("/login.jsp".equals(path) || "/settings/user/login.do".equals(path) ){
            filterChain.doFilter(request,response);

        }else {
            HttpSession session = request.getSession();
            User user =(User) session.getAttribute("user");
            if (user!=null){
                filterChain.doFilter(request,response);
            }else {
                response.sendRedirect(request.getContextPath()+"/login.jsp");
            }


        }

    }
}
