package com.hhf.web.controller;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.TypeReference;
import com.hhf.common.util.CartTransferUtils;
import com.hhf.constants.order.OrderConstants;
import com.hhf.model.product.BrandShowDetail;
import com.hhf.param.cart.Cart;
import com.hhf.param.cart.CartItem;
import com.hhf.service.order.ICartService;
import com.hhf.service.product.IBrandShowService;
import com.hhf.service.product.IProductService;
import com.hhf.param.cart.CookieCartItem;
import com.hhf.common.util.RequestUtils;
import com.hhf.param.cart.MiniCart;

@Controller
@RequestMapping("/cart")
public class CartController{
	private static final Logger log = LoggerFactory
			.getLogger(CartController.class);

	@Autowired
	private IProductService productService;
	@Autowired
	private ICartService cartService;
	@Autowired
	private IBrandShowService brandShowService;

	@RequestMapping("addcart")
	@ResponseBody
	public boolean addCart(@CookieValue(value = "cart", required = false) String cookieCart,
			Long bsid, Long skuid, Long num, HttpServletResponse response, HttpServletRequest request) {
		if(null == bsid || null == skuid || null == num) {
			return false;
		}
		BrandShowDetail bsd = brandShowService.getBrandShowDetailBySkuId(bsid.intValue(), skuid.intValue());
		if(null == bsd || null == bsd.getbSDId()) {
			return false;
		}
		List<CartItem> cartItems = new ArrayList<CartItem>();
		if (!StringUtils.isBlank(cookieCart)) {
			cartItems = CartTransferUtils.cookieCartToCartItem(JSON
					.parseObject(cookieCart,
							new TypeReference<List<CookieCartItem>>() {
							}));
		}
		boolean exist = false;
		if(null == cartItems){
			cartItems = new ArrayList<CartItem>();
		}
		for(CartItem cartItem : cartItems) {
			if(cartItem.getBrandShowDetailId().equals(bsd.getbSDId().longValue())) {
				exist = true;
				cartItem.setNum(cartItem.getNum() + num);
				cartItem.setSelected(true);
				break;
			}
		}
		if(!exist) {
			CartItem cartItem = new CartItem();
			cartItem.setBrandShowDetailId(bsd.getbSDId().longValue());
			cartItem.setNum(num);
			cartItem.setSelected(true);
			cartItems.add(cartItem);
		}
		saveCart(CartTransferUtils.cartItemsToCookieCartItems(cartItems), request, response);
		return true;
	}
	
	@RequestMapping("/cart")
	public String cart(@CookieValue(value = "cart", required = false) String cookieCart,Long bsid, Long skuid,HttpServletResponse response, HttpServletRequest request) {
		if(null != bsid && null != skuid) {
			BrandShowDetail bsd = brandShowService.getBrandShowDetailBySkuId(bsid.intValue(), skuid.intValue());
			if(null != bsd && null != bsd.getbSDId()) {
				List<CartItem> cartItems = new ArrayList<CartItem>();
				if (!StringUtils.isBlank(cookieCart)) {
					cartItems = CartTransferUtils.cookieCartToCartItem(JSON
							.parseObject(cookieCart,
									new TypeReference<List<CookieCartItem>>() {
									}));
				}
				boolean exist = false;
				if(null == cartItems){
					cartItems = new ArrayList<CartItem>();
				}
				for(CartItem cartItem : cartItems) {
					if(cartItem.getBrandShowDetailId().equals(bsd.getbSDId().longValue())) {
						exist = true;
						cartItem.setNum(cartItem.getNum() + 1);
						cartItem.setSelected(true);
						break;
					}
				}
				if(!exist) {
					CartItem cartItem = new CartItem();
					cartItem.setBrandShowDetailId(bsd.getbSDId().longValue());
					cartItem.setNum(1l);
					cartItem.setSelected(true);
					cartItems.add(cartItem);
				}
				saveCart(CartTransferUtils.cartItemsToCookieCartItems(cartItems), request, response);
			}
			
		}
		
		return "/cart/cart";
	}

	/**
	 * 展示购物车
	 * 
	 * @param cookieCart
	 * @param modelMap
	 * @param response
	 * @return
	 */
	@RequestMapping("/cartContent")
	public String showCart(
			@CookieValue(value = "cart", required = false) String cookieCart,
			ModelMap modelMap, HttpServletResponse response,
			HttpServletRequest request) {
		// 展示购物车
		List<Cart> carts = cartService.showCart(cookieCart);
		// 保存购物车
		saveCart(CartTransferUtils.cartToCookieCartItems(carts), request,
				response);
		// 将carts添加到模型中
		modelMap.addAttribute("carts", carts);
		boolean isEmpty = Boolean.parseBoolean(request.getParameter("isEmpty"));
		boolean hasError = Boolean.parseBoolean(request.getParameter("hasError"));
		// 是否没有选商品结算（用户点击结算按钮）
		modelMap.addAttribute("isEmpty", isEmpty);
		// 结算商品是否有错误（点击结算按钮）
		modelMap.addAttribute("hasError", hasError);
		return "/cart/cartContent";
	}

	@RequestMapping("/miniCart")
	@ResponseBody
	public String showMiniCart(
			@CookieValue(value = "cart", required = false) String cookieCart,
			HttpServletRequest request, HttpServletResponse response) {
		MiniCart miniCart = this.cartService.showMiniCart(cookieCart);
		response.setContentType("text/plain;charset=UTF-8");
		return JSON.toJSONString(miniCart);
	}

	@RequestMapping("/delMiniCart")
	@ResponseBody
	public String delMiniCart(
			@CookieValue(value = "cart", required = false) String cookieCart,
			@RequestParam Long bsdid,
			HttpServletRequest request, HttpServletResponse response) {
		if (bsdid != null && bsdid > 0) {
			Set<Long> bsdIds = new HashSet<Long>();
			bsdIds.add(bsdid);
			// 删除商品
			List<CartItem> cartItems = this.cartService.deleteCartItems(cookieCart, bsdIds);
			this.saveCart(
					CartTransferUtils.cartItemsToCookieCartItems(cartItems),
					request, response);
		}
		return "";
	}

	/**
	 * 修改购物车商品数量
	 * 
	 * @param cookieCart
	 * @param skuId
	 * @param newQuantity
	 * @return
	 */
	@ResponseBody
	@RequestMapping("/modify")
	public CartItem modifyQuantity(
			@CookieValue(value = "cart", required = false) String cookieCart,
			long bsDetailId, long newQuantity, long oldQuantity,
			HttpServletRequest request, HttpServletResponse response) {
		// 修改商品数量
		List<CartItem> cartItems = this.cartService.modifyQuantity(cookieCart, bsDetailId,
				newQuantity, oldQuantity);
		
		this.saveCart(
				CartTransferUtils.cartItemsToCookieCartItems(cartItems),
				request, response);
		CartItem cartItem = new CartItem();
		if (cartItems != null && cartItems.size() > 0) {
			for (CartItem ci : cartItems) {
				if (ci.getBrandShowDetailId().equals(bsDetailId)) {
					cartItem = ci;
				}
			}
		}

		return cartItem;
	}
	
	/**
	 * 删除商品
	 * 
	 * @param cookieCart
	 * @param skuId
	 * @param response
	 * @return
	 */
	@RequestMapping("/delete")
	public String delete(
			@CookieValue(value = "cart", required = false) String cookieCart,
			HttpServletRequest request, Long bsDetailId, HttpServletResponse response) {
		if (bsDetailId != null && bsDetailId > 0) {
			Set<Long> bsDetailIds = new HashSet<Long>();
			bsDetailIds.add(bsDetailId);
			// 删除商品
			List<CartItem> cartItems = this.cartService.deleteCartItems(cookieCart, bsDetailIds);
			saveCart(CartTransferUtils.cartItemsToCookieCartItems(cartItems),
					request, response);
		}
		// 跳回购物车
		return "redirect:/cart/cartContent.action";
	}

	/**
	 * 删除选中商品
	 * 
	 * @param cookieCart
	 * @param skuIds
	 * @param response
	 * @return
	 */
	@RequestMapping("/deleteSelected")
	public String deleteSelected(
			@CookieValue(value = "cart", required = false) String cookieCart,
			HttpServletRequest request, @RequestParam("bsDetailIds") String bsDetailIds,
			HttpServletResponse response) {
		if (StringUtils.isNotBlank(bsDetailIds)) {
			Set<Long> setBsDetailIds = new HashSet<Long>();
			for (String bsDetailId : bsDetailIds.split(",")) {
				setBsDetailIds.add(Long.parseLong(bsDetailId));
			}
			// 批量删除商品
			List<CartItem> cartItems = this.cartService.deleteCartItems(cookieCart, setBsDetailIds);
			saveCart(
					CartTransferUtils.cartItemsToCookieCartItems(cartItems),
					request, response);
		}
		// 跳回购物车
		return "redirect:/cart/cartContent.action";
	}

	/**
	 * 清除失效商品
	 * 
	 * @param cookieCart
	 * @param response
	 * @return
	 */
	@RequestMapping("/clearFailure")
	public String clearFailure(
			@CookieValue(value = "cart", required = false) String cookieCart,
			HttpServletRequest request, HttpServletResponse response) {
		// 清除失效商品
		List<CartItem> cartItems = this.cartService.clearFailureProduct(cookieCart);
		this.saveCart(CartTransferUtils.cartItemsToCookieCartItems(cartItems),
				request, response);
		// 跳回购物车
		return "redirect:/cart/cartContent.action";
	}

	/**
	 * 验证结算商品(用于异步调用，返回json)
	 * 
	 * @param cookieCart
	 * @return
	 */
	@ResponseBody
	@RequestMapping("/validCartConfirm")
	public String validCartConfirm(HttpServletRequest request,
			HttpServletResponse response,
			@CookieValue(value = "cart", required = false) String cookieCart) {
		// 将cookie转化成carts
		List<CartItem> cartItems = this.cartService.getCartItemsByCookie(cookieCart);
		// 选中的商品组合成购物车
		cartItems = this.cartService.filterSelectedCart(cartItems);
		Map<String, Boolean> rtnMap = new HashMap<String, Boolean>();
		// 设置结算商品是否为空
		if (cartItems.isEmpty()) {
			rtnMap.put("isEmpty", true);
		} else {
			rtnMap.put("isEmpty", false);
		}
		// 设置结算商品是否有误
		if (this.cartService.hasErrorOnSelectedCart(cartItems)) {
			rtnMap.put("hasError", true);
		} else {
			rtnMap.put("hasError", false);
		}
		// 返回json
		return JSON.toJSONString(rtnMap);
	}

	@RequestMapping("/chgChecked")
	@ResponseBody
	public void chgChecked(
			@CookieValue(value = "cart", required = false) String cookieCart,
			@RequestParam("bsDetailIds") String bsDetailIds, @RequestParam("checked") boolean checked,
			HttpServletRequest request, HttpServletResponse response) {
		Set<Long> setBsDetailsIds = new HashSet<Long>();
		for (String bsDetailId : bsDetailIds.split(",")) {
			setBsDetailsIds.add(Long.parseLong(bsDetailId));
		}
		List<CartItem> cartItems = this.cartService.chgChecked(cookieCart, setBsDetailsIds, checked);
		this.saveCart(CartTransferUtils.cartItemsToCookieCartItems(cartItems),
				request, response);
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
