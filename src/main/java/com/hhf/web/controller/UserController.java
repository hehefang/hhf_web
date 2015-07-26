package com.hhf.web.controller;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.codec.digest.DigestUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.ServletRequestDataBinder;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.context.request.WebRequest;

import com.hhf.constants.SystemConstants;
import com.hhf.constants.user.UserConstants;
import com.hhf.model.user.Geo;
import com.hhf.model.user.User;
import com.hhf.model.user.UserAddress;
import com.hhf.model.user.UserExt;
import com.hhf.param.cart.Cart;
import com.hhf.service.order.ICartService;
import com.hhf.service.user.IAddressService;
import com.hhf.service.user.IGeoService;
import com.hhf.service.user.IUserService;
import com.hhf.web.service.impl.LoginServiceImpl;
import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.TypeReference;

@Controller
@RequestMapping("/user")
public class UserController {
	@InitBinder  
    protected void initBinder(HttpServletRequest request,  
        ServletRequestDataBinder binder) throws Exception {  
        DateFormat df = new SimpleDateFormat("yyyy-MM-dd");  
        CustomDateEditor editor = new CustomDateEditor(df, true);  
        binder.registerCustomEditor(Date.class, editor);  
    }
	
	@Autowired
	private IUserService userService;
	@Autowired
	private IAddressService addrService;
	@Autowired
	private IGeoService geoService;
	@Autowired
	private ICartService cartService;
	@Autowired
	private RedisTemplate<String, Object> redis;
	
	@RequestMapping("/userInfo")
	public String userInfo(HttpServletRequest request,ModelMap map){
		String userId = LoginServiceImpl.getUserIdByCookie(request);
		User user = this.userService.getUserInfoById(Long.parseLong(userId));
		map.addAttribute("user", user);
		String success = request.getParameter("success");
		map.addAttribute("success", success);
		return "user/userInfo";
	}
	
	@RequestMapping("/userCenter")
	public String userCenter(HttpServletRequest request,ModelMap map,@CookieValue(value = "cart", required = false) String cookieCart){
		String userId = LoginServiceImpl.getUserIdByCookie(request);
		User user = this.userService.getUserInfoById(Long.parseLong(userId));
		map.addAttribute("user", user);
		List<Cart> carts = cartService.showCart(cookieCart);
		if(carts==null||carts.size()<1){
			map.addAttribute("hasproduct", 0);
		}else{
			int nums=carts.size();
			carts.subList(0,nums>2?3:nums);
			map.addAttribute("hasproduct", 1);
			map.addAttribute("carts", carts);
		}
		
		return "user/userCenter";
	}
	
	@RequestMapping("/saveUserInfo")
	public String saveUserInfo(User user){
		if(user!=null){
			this.userService.updateUser(user);
			if(user.getUserExt()!=null){
				UserExt userExt = user.getUserExt();
				userExt.setUserId(user.getUserId());
				this.userService.updateUserExt(userExt);
			}
		}
		return "redirect:/user/userInfo.action?success=true";
	}
	
	@RequestMapping("/userAddress")
	public String userAddress(HttpServletRequest request,ModelMap map){
		String userId = LoginServiceImpl.getUserIdByCookie(request);
		List<UserAddress> addresses = this.addrService.getAddressesByUserId(Long.parseLong(userId));
		map.addAttribute("addrs", addresses);
		int count = (addresses!=null)?addresses.size():0;
		map.addAttribute("addrCount", count);
		List<Geo> provinces = this.geoService.getGeoProvince();
		map.addAttribute("provinces", provinces);
		
		return "user/address";
	}
	
	@ResponseBody
	@RequestMapping("/getNextGeo")
	public String getNextGeo(@RequestParam Long geoId){
		List<Geo> cities = this.geoService.getGeoByFId(geoId);
		return JSON.toJSONString(cities);
	}
	
	@RequestMapping("/addAddress")
	public String addAddress(UserAddress address,HttpServletRequest request){
		String userId = LoginServiceImpl.getUserIdByCookie(request);
		if("on".equals(address.getIsDefault())){
			address.setIsDefault(UserConstants.ADDRESS_IS_DEFAULT);
		}else{
			address.setIsDefault(UserConstants.ADDRESS_IS_NOT_DEFAULT);
		}
		
		String telArea = request.getParameter("telArea");
		String telNum = request.getParameter("telNum");
		String telExt = request.getParameter("telExt");
		
		StringBuilder sb = new StringBuilder();
		if(StringUtils.isNotBlank(telArea)){
			sb.append(telArea).append("-");
		}
		sb.append(telNum);
		if(StringUtils.isNotBlank(telExt)){
			sb.append("-").append(telExt);
		}
		address.setTel(sb.toString());
		
		if(address.getAddrId()!=null){
			this.addrService.updateAddress(address);
		}else{
			address.setUserId(Long.parseLong(userId));
			this.addrService.addAddress(address);
		}
		return "redirect:/user/userAddress.action";
	}
	
	@RequestMapping("/setDefault")
	public String setDefault(@RequestParam String addrId,HttpServletRequest request){
		String userId = LoginServiceImpl.getUserIdByCookie(request);
		this.addrService.setDefault(addrId,userId);
		
		return "redirect:/user/userAddress.action";
	}
	
	@RequestMapping("/delAddr")
	public String delAddr(@RequestParam Long addrId,HttpServletRequest request){
		String userId = LoginServiceImpl.getUserIdByCookie(request);
		this.addrService.delAddr(addrId,Long.parseLong(userId));
		
		return "redirect:/user/userAddress.action";
	}
	
	@ResponseBody
	@RequestMapping("/getAddr")
	public String getAddr(@RequestParam Long addrId,HttpServletRequest request){
		String userId = LoginServiceImpl.getUserIdByCookie(request);
		UserAddress addr = this.addrService.getAddressByIdUid(addrId,Long.parseLong(userId));
		if(addr!=null){
			return JSON.toJSONString(addr);
		}
		return null;
	}
	
	@ResponseBody
	@RequestMapping("/canAdd")
	public String canAdd(HttpServletRequest request){
		String userId = LoginServiceImpl.getUserIdByCookie(request);
		List<UserAddress> addrs = this.addrService.getAddressesByUserId(Long.parseLong(userId));
		Map<String,Boolean> map = new HashMap<String,Boolean>();
		if(addrs!=null&&addrs.size()>=20){
			map.put("status", false);
		}else{
			map.put("status", true);
		}
		return JSON.toJSONString(map);
	}
	
	@RequestMapping("/safeSet")
	public String safeSet(HttpServletRequest request,ModelMap map){
		String userId = LoginServiceImpl.getUserIdByCookie(request);
		User user = this.userService.getUserInfoById(Long.parseLong(userId));
		map.addAttribute("user", user);
		return "/user/safe";
	}
	
	@RequestMapping("/modifyPwd1")
	public String modifyPwd1(HttpServletRequest request,ModelMap map){
		String userId = LoginServiceImpl.getUserIdByCookie(request);
		User user = this.userService.getUserById(Long.parseLong(userId));
		if(user == null){
			return "redirect:/register.action";
		}
		String mobile = user.getMobile();
		mobile = mobile.substring(0, 3)+"****"+mobile.substring(7);
		map.addAttribute("mobile", mobile);
		String k = DigestUtils.md5Hex(user.getMobile()+System.currentTimeMillis());
		this.redis.opsForValue().set(SystemConstants.CACHE_PREFIX+UserConstants.FIND_PWD_U+k, user.getMobile(), 10, TimeUnit.MINUTES);
		map.addAttribute("k", k);
		return "user/modifyPwd1";
	}
	
	@RequestMapping("/modifyPwd2")
	public String modifyPwd2(@RequestParam String k,ModelMap map){
		String mobile=(String)this.redis.opsForValue().get(SystemConstants.CACHE_PREFIX+UserConstants.FIND_PWD_U+k);
		User user = this.userService.getUserByMobile(mobile);
		if(user == null){
			return "redirect:/register.action";
		}
		mobile = mobile.substring(0, 3)+"****"+mobile.substring(7);
		map.addAttribute("userName", user.getUserName());
		map.addAttribute("mobile", mobile);
		map.addAttribute("k", k);
		
		return "user/modifyPwd2";
	}
	
	@ResponseBody
	@RequestMapping("/validModifyPwd1")
	public String validModifyPwd1(WebRequest request){
		Map<String,Object> map = new HashMap<String, Object>();
		String k = request.getParameter("k");
		map.put("k", k);
		String code = request.getParameter("code");
		String mobile = (String)this.redis.opsForValue().get(SystemConstants.CACHE_PREFIX+UserConstants.FIND_PWD_U+k);
		if(StringUtils.isBlank(mobile)){
			map.put("mobileStatus", 1);
		}else{
			map.put("mobileStatus", 0);
		}
		
		if(StringUtils.isBlank(code)){
			map.put("codeStatus", 1);
		}else{
			String temp = this.validCode(code, mobile);
			Map<String,Boolean> mapTemp = JSON.parseObject(temp, new TypeReference<Map<String,Boolean>>(){});
			boolean status = mapTemp.get("status");
			if(!status){
				map.put("codeStatus", 2);
			}else{
				map.put("codeStatus", 0);
			}
		}
		
		return JSON.toJSONString(map);
	}
	
	private String validCode(String code,String mobile){
		String validCode = (String)this.redis.opsForValue().get(SystemConstants.CACHE_PREFIX+UserConstants.VALID_CODE+mobile);
		Map<String,Boolean> map = new HashMap<String, Boolean>();
		if(code.equals(validCode)){
			map.put("status", true);
		}else{
			map.put("status", false);
		}
		
		return JSON.toJSONString(map);
	}
	
	@ResponseBody
	@RequestMapping("/validModifyPwd2")
	public String validModifyPwd2(WebRequest request){
		Map<String,Object> map = new HashMap<String, Object>();
		boolean mobileOk = false;
		boolean pwdOk = false;
		boolean repwdOk = false;
		String k = request.getParameter("k");
		map.put("k", k);
		String pwd = request.getParameter("pwd");
		String repwd = request.getParameter("repwd");
		String mobile = (String)this.redis.opsForValue().get(SystemConstants.CACHE_PREFIX+UserConstants.FIND_PWD_U+k);
		if(StringUtils.isBlank(mobile)){
			map.put("mobileStatus", 1);
		}else{
			map.put("mobileStatus", 0);
			mobileOk = true;
		}
		
		if(StringUtils.isBlank(pwd)){
			map.put("pwdStatus", 1);
		}else if(pwd.length()>20||pwd.length()<6){
			map.put("pwdStatus", 2);
		}else{
			map.put("pwdStatus", 0);
			pwdOk = true;
		}
		
		if(StringUtils.isBlank(repwd)){
			map.put("repwdStatus", 1);
		}else if(!repwd.equals(pwd)){
			map.put("repwdStatus", 2);
		}else{
			map.put("repwdStatus", 0);
			repwdOk = true;
		}
		
		if(mobileOk&&repwdOk&&pwdOk){
			this.userService.chgPwd(mobile, pwd);
		}
		
		return JSON.toJSONString(map);
	}
	
	@RequestMapping("/modifyPwd3")
	public String modifyPwd3(){
		return "user/modifyPwd3";
	}
}
