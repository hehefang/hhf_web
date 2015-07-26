package com.hhf.web.controller;

import java.io.UnsupportedEncodingException;
import java.math.BigDecimal;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringEscapeUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.math.NumberUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSON;
import com.hhf.constants.order.OrderConstants;
import com.hhf.constants.user.UserConstants;
import com.hhf.model.order.Order;
import com.hhf.model.user.Geo;
import com.hhf.model.user.User;
import com.hhf.model.user.UserAddress;
import com.hhf.param.cart.Cart;
import com.hhf.param.cart.CartItem;
import com.hhf.param.cart.CookieCartItem;
import com.hhf.param.cart.Trade;
import com.hhf.param.cart.TradeItem;
import com.hhf.param.cart.TradesInfo;
import com.hhf.param.order.OrderInfo;
import com.hhf.service.order.ICartService;
import com.hhf.service.order.IOrderService;
import com.hhf.service.payment.IPaymentServices;
import com.hhf.service.product.IProductService;
import com.hhf.service.user.IAddressService;
import com.hhf.service.user.IGeoService;
import com.hhf.service.user.IUserService;
import com.hhf.common.util.CartTransferUtils;
import com.hhf.common.util.RequestUtils;
import com.hhf.web.service.impl.LoginServiceImpl;

/**
 * @author wxp
 * 
 */
@Controller
public class TradeController{

	@Autowired
	private IAddressService addressService;
	@Autowired
	private IGeoService geoService;
	@Autowired
	private ICartService cartService;
	@Autowired
	private IProductService productService;
	@Autowired
	private IUserService userService;
	@Autowired
	private IOrderService orderService;
	@Autowired
	private IPaymentServices paymentServices;

	private static final Logger log = LoggerFactory
			.getLogger(TradeController.class);

	@RequestMapping(value = "/trade")
	public String tradeinfo(
			@CookieValue(value = "cart", required = true, defaultValue = "") String cookieCart,
			Model model, HttpServletRequest request, HttpServletResponse response) {
		boolean isLogin = LoginServiceImpl.isLogin(request, response);
		if(!isLogin) {
			String ctx = request.getContextPath();
			return "redirect:/login.action?rtnUrl=" + ctx + "/trade.action";
		}
		List<Cart> carts_confirm=new ArrayList<Cart>();
		carts_confirm = this.cartService.showCart(cookieCart);
		//保存购物车
		this.saveCart(CartTransferUtils.cartToCookieCartItems(carts_confirm), request, response);
		List<Cart> selectedCarts = this.getGoods(carts_confirm);
		if (selectedCarts == null || selectedCarts.size() == 0) {
			return "redirect:/cart/cart.action";
		}
		
		List<CookieCartItem> cartItems = CartTransferUtils.cartToCookieCartItems(carts_confirm);
		
		RequestUtils.setCookie(request, response, OrderConstants.COOKIE_CART_CONFIRM, 
				JSON.toJSONString(cartItems), OrderConstants.COOKIE_CART_PERIOD);

		boolean isEmpty = Boolean.parseBoolean(request.getParameter("isEmpty"));
		boolean isAddrEmpty = Boolean.parseBoolean(request.getParameter("isAddrEmpty"));
		boolean hasError = Boolean.parseBoolean(request.getParameter("hasError"));
		model.addAttribute("isEmpty", isEmpty);
		model.addAttribute("isAddrEmpty", isAddrEmpty);
		model.addAttribute("hasError", hasError);
		
		return "/cart/trade";
	}

	/**
	 * create order
	 */
	@RequestMapping(value = "/tradecomfirm")
	public String tradeConfirm(@CookieValue(value = "cartconfirm", required = true, defaultValue = "") String cookieCart_confirm, 
			@CookieValue(value = "cart", required = true, defaultValue = "") String cookieCart, 
			TradesInfo tradesInfo, ModelMap modelMap, HttpServletRequest request, HttpServletResponse response) {
		boolean isLogin = LoginServiceImpl.isLogin(request, response);
		Long uid = 0l;
		String userId = LoginServiceImpl.getUserIdByCookie(request);
		if(!StringUtils.isEmpty(userId)) {
			uid = Long.parseLong(userId);
		}
		if(!isLogin) {
			String ctx = request.getContextPath();
			return "redirect:/login.action?rtnUrl=" + ctx + "/trade.action";
		}
		String submitcookie = RequestUtils.getCookieValue(request, "tradesubmit");
		if(StringUtils.isNumeric(submitcookie) && NumberUtils.toInt(submitcookie)>1){
			return "redirect:/cart/cart.action";
		}
		String ip = request.getRemoteAddr();//返回发出请求的IP地址
		if (StringUtils.isEmpty(cookieCart_confirm)) {//no cart_confirm cookie
			log.error("---------------create oreder info:cookie_null------------");
			modelMap.put("isEmpty", true);
			return "redirect:/trade.action";
		}
		List<Cart> carts_confirm = this.cartService.showCart(cookieCart_confirm);
		
		if (carts_confirm == null || carts_confirm.size() == 0) {
			modelMap.put("isEmpty", true);
			return "redirect:/trade.action";
		}
//		Cookie[] cookies = request.getCookies();
//		String cookieCart = "";
//		try {
//			for(Cookie cookie : cookies) {
//				 if("cart".equals(cookie.getName())) {
//					 cookieCart = URLDecoder.decode(cookie.getValue(),"UTF-8");
//				 }
//			}
//		} catch (UnsupportedEncodingException e1) {
//			// TODO Auto-generated catch block
//			e1.printStackTrace();
//		}
		List<Cart> carts = this.cartService.showCart(cookieCart);
		List<CartItem> cartItems = this.getNoChoosedCartItem(carts);
		carts_confirm = this.getGoods(carts_confirm);
		UserAddress address = this.addressService.getAddressById(tradesInfo.getPayAddrId());		
		if(null == address){
			log.error("---------------address is null------------addressId:"+tradesInfo.getPayAddrId());
			modelMap.put("isAddrEmpty", true);
			return "redirect:/trade.action";
		}

		Iterator<Cart> it = carts_confirm.iterator();
		boolean hasError = false;
		while (it.hasNext()) {
			Cart cart = it.next();
			if (this.cartService.hasErrorOnSelectedCart(cart.getCartItems())) {
				hasError = true;
				break;
			}
		}
		if (hasError) {
			log.error("---------------create oreder info:hasError------------");
			modelMap.put("hasError", true);
			return "redirect:/trade.action";
		}
		List<Trade> tradelist = this.getTradeInfo(carts_confirm, tradesInfo, uid);
		if (tradelist == null) {
			log.error("---------------create oreder info:tradelist==null------------");
			modelMap.put("hasError", true);
			return "redirect:/trade.action";
		}
		StringBuffer orderids = new StringBuffer();
		String orderids_str = "";
		try {
			List<OrderInfo> orderlist = this.orderService.batchSaveOrders(tradelist);
			if (orderlist == null || orderlist.size() < 1) {
				log.error("---------------orderlist == null------------");
				modelMap.put("hasError", true);
				return "redirect:/trade.action";
			}
			List<CookieCartItem> combimeCartItems = CartTransferUtils
					.cartItemsToCookieCartItems(cartItems);
			
			this.saveCart(combimeCartItems, request, response);
			
			log.error("---------------create oreder info0 "
					+ JSON.toJSONString(cartItems) + "------------");
			log.error("---------------create oreder info1 "
					+ JSON.toJSONString(combimeCartItems) + "------------");
			log.error("---------------create oreder info2 "
					+ JSON.toJSONString(orderlist) + "------------");
			
			for (OrderInfo in : orderlist) {
				log.error("success:"+in.getCode());
				if(in.getCode() > 0){
					orderids.append(in.getOrder().getOrderId()).append("_");
				}
			}
			
			log.error("orderids:"+orderids);
			if("".equals(orderids.toString())){
				log.error("---------------create oreder orderids_str empty-------- ");
				modelMap.put("hasError", true);
				return "redirect:/trade.action";
			}
			
			orderids_str = orderids.substring(0, orderids.length() - 1);
			RequestUtils.deleteCookie(request, response, OrderConstants.COOKIE_CART_CONFIRM, true);
		} catch (Exception e) {
			log.error("---------------create oreder error"
					+ JSON.toJSONString(tradelist) + "------------");
			log.error(e.getMessage(),e);
			modelMap.put("hasError", true);
			return "redirect:/trade.action";
		}
		
		String[] ids = orderids_str.split("_");			
		List<Long> orderids_list =new ArrayList<Long>();
		
		for (int i = 0; i < ids.length; i++) {			
			orderids_list.add(new Long(ids[i]));
		}			
		String paymentType="1";
		if(orderids_list.size() > 1){
			paymentType="2";
		}
		String paymode=tradesInfo.getPayMode();
//		if(tradesInfo.getPayMode().substring(0, 1).equals("2")){
//			paymode=OrderConstants.PAY_MODE_APIPAY;
//		}
//		if(tradesInfo.getPayMode().substring(0, 1).equals("1")){
//			paymode=OrderConstants.PAY_MODE_CHINAPAY;
//		}
		Long paymentId=this.paymentServices.savePaymentId(orderids_list, "1", ip, uid, paymode, paymentType);
		if(null==paymentId||paymentId<0l){
			return "payfail";
		}
		return "redirect:/payment.action?uid=" + uid + "&paymentid="
				+ paymentId;
	}

	@RequestMapping(value = "/tradesucceed")
	public String tradesucceed(HttpServletRequest request, ModelMap modelMap,
			HttpServletResponse response) {
		String orderids = request.getParameter("orderids");
		Long uid = 0l;
		String userId = LoginServiceImpl.getUserIdByCookie(request);
		if(!StringUtils.isEmpty(userId)) {
			uid = Long.parseLong(userId);
		}
		if (StringUtils.isBlank(orderids)||userId.equals(0l)) {
			return "redirect:/cart.jsp";
		}
		String[] ids = orderids.split("_");
		Long[] ids_list;
		ids_list = new Long[ids.length];
		for (int i = 0; i < ids.length; i++) {
			ids_list[i] = (new Long(ids[i]));
		}
		//TODO
		List<Order> orderlist = this.orderService.getOrdersByIdsAndUserId(ids_list, uid);
		modelMap.addAttribute("orderlist", orderlist);
		return "tradesucceed_n";
	}

	/**
	 * area operations
	 */
	@RequestMapping(value = "/geo")
	@ResponseBody
	public List<Geo> viewGeo(@RequestParam(value = "fid") Long fid) {
		return this.geoService.getGeoByFId(fid);
	}

	@RequestMapping(value = "/tradeGoods")
	public String goods(@CookieValue(value = "cartconfirm", required = true, defaultValue = "") String cookieCart,
			ModelMap modelMap, HttpServletRequest request, HttpServletResponse response) {
		String addressId = request.getParameter("addressId");
		
		if(StringUtils.isNotBlank(addressId)){
			UserAddress address = this.addressService.getAddressById(Integer.parseInt(addressId));
			if(address!=null){
				modelMap.addAttribute("addr", address);
			}
		}
		List<Cart> carts = this.cartService.showCart(cookieCart);
		
		if(this.isCartEmpty(carts)){
			modelMap.addAttribute("carts", carts);
		}
		List<Cart> selectedCarts = this.getGoods(carts);

		modelMap.addAttribute("carts", selectedCarts);

		return "/cart/tradeGoods";
	}

	/**
	 * get address
	 */
	@RequestMapping(value = "/getAddr")
	@ResponseBody
	public List<UserAddress> getAddrinfo(HttpServletRequest request, HttpServletResponse response) {
		Long uid = 0l;
		String userId = LoginServiceImpl.getUserIdByCookie(request);
		if(!StringUtils.isEmpty(userId)) {
			uid = Long.parseLong(userId);
		}
		if(!StringUtils.isEmpty(userId)){
			uid = Long.parseLong(userId);	
		}
		List<UserAddress> addrs = new ArrayList<UserAddress>();
		if (uid != 0l) {
			addrs = this.addressService.getAddressesByUserId(uid);
		}
		return addrs;
	}
	
	/**
	 * add address
	 */
	@RequestMapping(value = "/addAddr")
	@ResponseBody
	public int addAddr(UserAddress addr, HttpServletRequest request, HttpServletResponse response) {
		Long uid = 0l;
		String userId = LoginServiceImpl.getUserIdByCookie(request);
		if(!StringUtils.isEmpty(userId)) {
			uid = Long.parseLong(userId);
		}
		int res = -10;
		if (uid != 0l) {
			addr.setUserId(uid);
			addr.setStatus(UserConstants.ADDRESS_STATUS_VALID);
			res = this.addressService.addAddress(addr);
		}
		return res;
	}
	
	/**
	 * update address
	 */
	@RequestMapping(value = "/updateAddr")
	@ResponseBody
	public int updateAddr(UserAddress addr, HttpServletRequest request, HttpServletResponse response) {
		//TODO uid效验
		Long uid = 0l;
		String userId = LoginServiceImpl.getUserIdByCookie(request);
		if(!StringUtils.isEmpty(userId)) {
			uid = Long.parseLong(userId);
		}
		int res = 0;
		res = this.addressService.updateAddress(addr);
		return res;
	}
	
	/**
	 * delete address
	 */
	@RequestMapping(value = "/deleteAddr")
	@ResponseBody
	public int deleteAddr(int addrId, HttpServletRequest request, HttpServletResponse response) {
		//TODO uid效验
		Long uid = 0l;
		String userId = LoginServiceImpl.getUserIdByCookie(request);
		if(!StringUtils.isEmpty(userId)) {
			uid = Long.parseLong(userId);
		}
		int res = 0;
		res = this.addressService.delAddress(addrId);
		return res;
	}

	/**
	 * get TradeInfo
	 * 
	 * @param cats
	 * @return TradeInfo
	 */
	private List<Trade> getTradeInfo(List<Cart> cats, TradesInfo tradesInfo, Long userId) {
		List<Trade> trades = new ArrayList<Trade>();
		Iterator<Cart> it = cats.iterator();
		User user = this.userService.getUserById(userId);
		while (it.hasNext()) {
			Cart cartTemp = it.next();
			List<TradeItem> tradeItems = this.getTradeItem(cartTemp);
			if (tradeItems.size() == 0) {
				continue;
			}
			Trade trade = new Trade();
			trade.setUserId(userId);
			trade.setSellerId(cartTemp.getSellerId());
			trade.setBrandShowId(cartTemp.getBrandShowId());
			trade.setBrandShowTitle(cartTemp.getBrandShowTitle());
			trade.setTradeItems(tradeItems);
			trade.setAddressId(tradesInfo.getPayAddrId());
			
			trade.setPayType("1");
			trade.setPayMode(tradesInfo.getPayMode());

			trade.setOrderType("1");
			trade.setOrderSource("1");
			trade.setDeliverFee(BigDecimal.ZERO);

			trade.setDeliverDiscountFee(BigDecimal.ZERO);
			trade.setOptName(user.getUserName());

			trades.add(trade);
		}

		return trades;
	}

	/**
	 * get TradeItem Info
	 * 
	 * @param cartItems
	 * @return TradeItem Info
	 */
	private List<TradeItem> getTradeItem(Cart cart) {
		List<TradeItem> tradeItems = new ArrayList<TradeItem>();
		Iterator<CartItem> it = cart.getCartItems().iterator();

		while (it.hasNext()) {
			CartItem cartItemTemp = it.next();
			if (cartItemTemp.isSelected()) {
				TradeItem tradeItem = new TradeItem();
				tradeItem.setProdId(cartItemTemp.getProdId());
				tradeItem.setNum(cartItemTemp.getNum());
				tradeItem.setMarketPrice(cartItemTemp.getMaketPrice());
				tradeItem.setShowPrice(cartItemTemp.getShowPrice());
				tradeItem.setSellerId(cart.getSellerId());
				tradeItem.setSkuId(cartItemTemp.getSkuId());
				tradeItem.setProdSpecId(cartItemTemp.getSpecId());
				tradeItem.setProdSpecName(cartItemTemp.getSpecName());
				tradeItem.setProdTitle(cartItemTemp.getProdName());
				tradeItem.setProdImg(cartItemTemp.getProdImgUrl());
				tradeItem.setBcId(cartItemTemp.getBcId().longValue());
				tradeItem.setProdCode(cartItemTemp.getProdCode());
				tradeItem.setSkuCode(cartItemTemp.getSkuCode());
				tradeItem.setBrandShowId(cart.getBrandShowId());
				tradeItem.setBrandShowTitle(cart.getBrandShowTitle());
				tradeItem.setBrandShowDetailId(cartItemTemp.getBrandShowDetailId());
				
				tradeItems.add(tradeItem);
			}
		}
		return tradeItems;
	}

	
	private boolean isCartEmpty(List<Cart> carts) {
		boolean ret = true;
		Iterator<Cart> it = carts.iterator();
		while (it.hasNext()) {
			Cart cart = it.next();
			for (int j = 0; j < cart.getCartItems().size(); j++) {
				CartItem cartItem = cart.getCartItems().get(j);
				if (cartItem.isSelected()) {	
					return false;
				}
			}			
		}
		return ret;
	}
	
	/*
	 * 购物车中选中的商品
	 * 
	 * @param carts
	 * 
	 * @param ids
	 * 
	 * @param response
	 */
	private List<Cart> getGoods(List<Cart> carts) {
		carts = new ArrayList<Cart>(carts);
		Set<Cart> cleanShopids = new HashSet<Cart>();
		Set<CartItem> cleanIds = new HashSet<CartItem>();
		Iterator<Cart> it = carts.iterator();
		while (it.hasNext()) {
			Cart cart = it.next();
			for (int j = 0; j < cart.getCartItems().size(); j++) {
				CartItem cartItem = cart.getCartItems().get(j);
				if (!cartItem.isSelected()) {
					cleanIds.add(cartItem);
				}
			}
			cart.getCartItems().removeAll(cleanIds);
			if (cart.getCartItems().size() == 0) {
				cleanShopids.add(cart);
			}
		}
		carts.removeAll(cleanShopids);
		return carts;
	}

	private List<CartItem> getNoChoosedCartItem(List<Cart> carts) {
		List<CartItem> cartItems = new ArrayList<CartItem>();
		Iterator<Cart> it = carts.iterator();
		while (it.hasNext()) {
			Cart cart = it.next();
			for (int j = 0; j < cart.getCartItems().size(); j++) {
				CartItem cartItem = cart.getCartItems().get(j);
				if (!cartItem.isSelected()) {
					cartItems.add(cartItem);
				}
			}
		}
		return cartItems;
	}
	
	private void saveCart(List<CookieCartItem> combineCartItems,
			HttpServletRequest request,
			HttpServletResponse response
			){
		if(combineCartItems == null){
			combineCartItems = new ArrayList<CookieCartItem>();
		}
		RequestUtils.setCookie(request, response, OrderConstants.COOKIE_CART, 
					JSON.toJSONString(combineCartItems), OrderConstants.COOKIE_CART_PERIOD);
	}
}
