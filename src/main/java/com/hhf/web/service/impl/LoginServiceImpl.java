package com.hhf.web.service.impl;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.util.Calendar;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.codec.digest.DigestUtils;
import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.hhf.common.util.DateUtils;
import com.hhf.common.util.RequestUtils;
import com.hhf.constants.SystemConstants;
import com.hhf.model.user.User;
import com.hhf.service.user.IUserService;

@Service("loginService")
public class LoginServiceImpl {
	private static final Logger log = LoggerFactory.getLogger(LoginServiceImpl.class);
	@Autowired
	private IUserService userServcie;

	/**
	 * 用户登录
	 * @param req
	 * @param resp
	 * @return
	 */
	public boolean login(HttpServletRequest req, HttpServletResponse resp) {
		String userName = req.getParameter("userName");
		String pwd = req.getParameter("pwd");
		if (StringUtils.isBlank(userName) || StringUtils.isBlank(pwd)) {
			return false;
		}

		User user = this.userServcie.getUserByUserName(userName);
		if (user == null) {
			return false;
		}

		String userKey = user.getPwdKey();
		String validPwd = DigestUtils.md5Hex(DigestUtils.md5Hex(userKey
				+ SystemConstants.WEB_KEY)
				+ pwd);
		if (validPwd.equals(user.getPwd())) {
			//设置_u
			String _u = user.getUserId() + "|" + user.getUserName() + "|"
					+ user.getNickname();
			RequestUtils.setCookie(req, resp, "_u", _u,
					SystemConstants.COOKIE_U_PERIOD);
			
			//设置_um
			String _um = DigestUtils.md5Hex(user.getUserId()
					+ SystemConstants.WEB_KEY + RequestUtils.getUserAgent(req));
			RequestUtils.setCookie(req, resp, "_um", _um,-1);
			
			//设置_ut
			//当前时间
			Date now = new Date();
			//登录过期时间
			long expireTime = DateUtils.dateAdd(now, Calendar.SECOND, SystemConstants.USER_LOGIN_TIME).getTime();
			//客户端时间
			String clientTime = req.getParameter("clientTime");
			long cliTime = StringUtils.isBlank(clientTime)?now.getTime():Long.parseLong(clientTime);
			//客户端与服务器端的时间差
			long timeDiff = cliTime - now.getTime();
			String _ut=expireTime+"|"+timeDiff;
			RequestUtils.setCookie(req, resp, "_ut", _ut,SystemConstants.COOKIE_UT_PERIOD);
			
			user.setLastLoginDate(DateUtils.currentDate());
			user.setLastLoginIp(RequestUtils.getRemoteAddr(req));
			this.userServcie.updateUser(user);
			
			return true;
		}

		return false;
	}
	
	/**
	 * 用户登录认证
	 * @param req
	 * @param resp
	 * @return
	 */
	public static boolean isLogin(HttpServletRequest req,HttpServletResponse resp){
		String _u = RequestUtils.getCookieValue(req, SystemConstants.COOKIE_U);
		String _um = RequestUtils.getCookieValue(req, SystemConstants.COOKIE_UM);
		String _ut = RequestUtils.getCookieValue(req, SystemConstants.COOKIE_UT);
		//认证信息不全
		if(StringUtils.isBlank(_u) || StringUtils.isBlank(_ut) || StringUtils.isBlank(_um)){
			return false;
		}
		//用户id
		String userId = getUserIdByCookie(req);
		//密码验证
		String encrypt = DigestUtils.md5Hex(userId + SystemConstants.WEB_KEY + RequestUtils.getUserAgent(req));
		//密码不正确
		if(!encrypt.equals(_um)){
			return false;
		}
		//登录过期时间
		String expireTime = getExpireTimeByCookie(req);
		Date expire = DateUtils.parseDate(Long.parseLong(expireTime));
		//当前时间
		Date now = DateUtils.currentDate();
		//时间过期
		if(now.after(expire)){
			return false;
		}
		//警戒时间
		Date warnTime = DateUtils.dateAdd(expire, Calendar.MINUTE, -SystemConstants.WARN_TIME_DIFF);
		if(now.after(warnTime)){
			expireTime = DateUtils.dateAdd(now, Calendar.SECOND, SystemConstants.USER_LOGIN_TIME).getTime()+"";
			String timeDiff = getTimeDiffByCookie(req);
			RequestUtils.setCookie(req, resp, "_ut", expireTime+"|"+timeDiff, SystemConstants.COOKIE_UT_PERIOD);
		}
		
		return true;
	}
	
	/**
	 * 从cookie中获取用户id
	 * @param req
	 * @return
	 */
	public static String getUserIdByCookie(HttpServletRequest req){
		String userId = null;
		String _u = RequestUtils.getCookieValue(req, SystemConstants.COOKIE_U);
		if(StringUtils.isNotBlank(_u)){
			try {
				_u = URLDecoder.decode(_u,"utf-8");
				String[] userInfo = _u.split("\\|");
				if(userInfo.length>=2){
					userId = userInfo[0];
				}
			} catch (UnsupportedEncodingException e) {
				log.error(e.getMessage(), e);
			}
		}
		return userId;
	}
	
	/**
	 * 从cookie中获取登录的失效时间
	 * @param req
	 * @return
	 */
	public static String getExpireTimeByCookie(HttpServletRequest req){
		String expireTime = null;
		String _ut = RequestUtils.getCookieValue(req, SystemConstants.COOKIE_UT);
		if(StringUtils.isNotBlank(_ut)){
			try {
				_ut = URLDecoder.decode(_ut,"utf-8");
				String[] utInfo = _ut.split("\\|");
				if(utInfo.length==2){
					expireTime = utInfo[0];
				}
			} catch (UnsupportedEncodingException e) {
				log.error(e.getMessage(), e);
			}
		}
		return expireTime;
	}
	
	/**
	 * 从cookie中获取客户端与服务器端的时间差
	 * @param req
	 * @return
	 */
	public static String getTimeDiffByCookie(HttpServletRequest req){
		String timeDiff = null;
		String _ut = RequestUtils.getCookieValue(req, SystemConstants.COOKIE_UT);
		if(StringUtils.isNotBlank(_ut)){
			try {
				_ut = URLDecoder.decode(_ut,"utf-8");
				String[] utInfo = _ut.split("\\|");
				if(utInfo.length==2){
					timeDiff = utInfo[1];
				}
			} catch (UnsupportedEncodingException e) {
				log.error(e.getMessage(), e);
			}
		}
		return timeDiff;
	}
	
	public static void main(String[] args) {
		System.out.println(DateUtils.dateAdd(new Date(), Calendar.SECOND, SystemConstants.USER_LOGIN_TIME));
	}
}
