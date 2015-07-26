package com.unionpay;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Created with Liu Yong
 * User: melnnyy
 * Date: 2014/6/30
 * Time: 14:59
 */
public class TokenFilter implements Filter {
//    private static final byte[] lock = new byte[0];

    public void init(FilterConfig filterConfig) throws ServletException {

    }

    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        System.out.println("tokenFilter in .....");

        String token = request.getParameter("token");

        HttpServletRequest req=(HttpServletRequest)request;
        HttpSession session = req.getSession(true);
        String tokenInSession = SessionTokenGenerator.getToken(session);

        // 如果Session中没有该Token，则为重复提交
        if(null == tokenInSession) {
            request.getRequestDispatcher("/unionpay/info.html").forward(request,response);
            return;
        }

        // 如果Session中的Token与提交上来的Token值不同
        if(!token.equals(tokenInSession)) {
            request.getRequestDispatcher("/unionpay/error.html").forward(request,response);
            return;
        }

        SessionTokenGenerator.removeToken(session);

        chain.doFilter(request, response);

        System.out.println("tokenFilter out .....");
    }

    public void destroy() {

    }
}
