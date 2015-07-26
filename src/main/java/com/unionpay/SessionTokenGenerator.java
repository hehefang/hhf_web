package com.unionpay;

import javax.servlet.http.HttpSession;
import java.util.Random;

/**
 * Created with Liu Yong
 * User: melnnyy
 * Date: 2014/6/30
 * Time: 16:03
 */
public class SessionTokenGenerator {
    private static final Random random = new Random(System.currentTimeMillis());
    public static final String TOKENPARAM = "session-token";

    public static boolean isExist(HttpSession session) {
        Object o = session.getAttribute(TOKENPARAM);
        return (null != o && 0 != ((String)o).length());
    }

    public static String getToken(HttpSession session) {
        Object o = session.getAttribute(TOKENPARAM);
        return (null == o) ? null : (String) o;
    }

    public static synchronized String generateToken(HttpSession session) {
        String s = String.valueOf(random.nextLong());
        session.setAttribute(TOKENPARAM, s);
        return s;
    }

    public static synchronized void removeToken(HttpSession session) {
        session.removeAttribute(TOKENPARAM);
        session.invalidate();
    }
}
