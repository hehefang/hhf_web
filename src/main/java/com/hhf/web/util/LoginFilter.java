package com.hhf.web.util;

import java.io.IOException;
import java.net.URLEncoder;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;

import com.hhf.web.service.impl.LoginServiceImpl;

public class LoginFilter implements Filter {

	@Override
	public void init(FilterConfig filterConfig) throws ServletException {
		// TODO Auto-generated method stub

	}

	@Override
	public void doFilter(ServletRequest request, ServletResponse response,
			FilterChain chain) throws IOException, ServletException {
		HttpServletRequest req = (HttpServletRequest)request;
		HttpServletResponse resp = (HttpServletResponse)response;
		//用户登录
		if(LoginServiceImpl.isLogin(req, resp)){
			chain.doFilter(request, response);
		}
		//用户未登录
		else{
			StringBuffer url = req.getRequestURL();
			String query = req.getQueryString();
			String rtnUrl = StringUtils.isBlank(query)?url.toString():url.toString()+"?"+query;
			rtnUrl = URLEncoder.encode(rtnUrl,"utf-8");
			resp.sendRedirect(req.getContextPath()+"/login.action?rtnUrl="+rtnUrl);
		}
	}

	@Override
	public void destroy() {
		// TODO Auto-generated method stub

	}

}
