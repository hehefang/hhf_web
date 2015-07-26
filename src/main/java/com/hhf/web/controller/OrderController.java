package com.hhf.web.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.hhf.common.mybatis.Page;
import com.hhf.constants.order.OrderConstants;
import com.hhf.model.order.Order;
import com.hhf.model.seller.Seller;
import com.hhf.model.user.User;
import com.hhf.service.order.IOrderService;
import com.hhf.service.seller.ISellerService;
import com.hhf.service.user.IUserService;
import com.hhf.web.service.impl.LoginServiceImpl;

@Controller
@RequestMapping("/user")
public class OrderController {
	
	@Autowired
	private IOrderService orderService;
	@Autowired
	private ISellerService sellerService;
	@Autowired
	private IUserService userService;
	
	@RequestMapping("/orders")
	public String getOrders(@RequestParam(value="status",required=false) String orderStatus, ModelMap modelMap, 
			HttpServletRequest request, HttpServletResponse response, Page<Order> page) {
		boolean isLogin = LoginServiceImpl.isLogin(request, response);
		if(!isLogin) {
			String ctx = request.getContextPath();
			return "redirect:/login.action?rtnUrl=" + ctx + "/user/orders.action";
		}
		String userId = LoginServiceImpl.getUserIdByCookie(request);
		Long uid = Long.parseLong(userId);
		Page<Order> allOrders = this.orderService.getOrdersByUserId(uid, page);
		Page<Order> waitPayOrders = this.orderService.getOrdersByUserIdAndStatus(uid, OrderConstants.ORDER_STATUS_WAITPAYMENT, page);
		Page<Order> waitDeliveredOrders = this.orderService.getOrdersByUserIdAndStatus(uid, OrderConstants.ORDER_STATUS_WAITDELIVERED, page);
		modelMap.addAttribute("allCount", allOrders.getTotalRecord());
		modelMap.addAttribute("waitPayCount", waitPayOrders.getTotalRecord());
		modelMap.addAttribute("waitDeliveredCount", waitDeliveredOrders.getTotalRecord());
		if(!StringUtils.isEmpty(orderStatus) && orderStatus.equals(OrderConstants.ORDER_STATUS_WAITPAYMENT)) {
			page = waitPayOrders;
			modelMap.addAttribute("status", OrderConstants.ORDER_STATUS_WAITPAYMENT);
		} else if(!StringUtils.isEmpty(orderStatus) && orderStatus.equals(OrderConstants.ORDER_STATUS_WAITDELIVERED)) {
			page = waitDeliveredOrders;
			modelMap.addAttribute("status", OrderConstants.ORDER_STATUS_WAITDELIVERED);
		} else {
			page = allOrders;
		}
		modelMap.addAttribute("orders", page);
		return "/order/orders";
	}
	
	@RequestMapping("/payment")
	public String payment(@RequestParam(value="orderId", required=true) String orderId, 
			HttpServletRequest request, HttpServletResponse response) {
		boolean isLogin = LoginServiceImpl.isLogin(request, response);
		if(!isLogin) {
			String ctx = request.getContextPath();
			return "redirect:/login.action?rtnUrl=" + ctx + "/user/orderDetail.action?orderId=" + orderId;
		}
		String userId = LoginServiceImpl.getUserIdByCookie(request);
		Long uid = Long.parseLong(userId);
		return "redirect:/payment.action?uid=" + uid + "&orderid="+orderId;
	}
	
	@RequestMapping("/orderDetail")
	public String getOrderDetail(@RequestParam(value="orderId",required=true) Long orderId, ModelMap modelMap,
			HttpServletRequest request, HttpServletResponse response) {
		boolean isLogin = LoginServiceImpl.isLogin(request, response);
		if(!isLogin) {
			String ctx = request.getContextPath();
			return "redirect:/login.action?rtnUrl=" + ctx + "/user/orderDetail.action?orderId=" + orderId;
		}
		String userId = LoginServiceImpl.getUserIdByCookie(request);
		Long uid = Long.parseLong(userId);
		Order order = this.orderService.getOrderByIdAndUser(orderId, uid);
		Seller seller = this.sellerService.getSellerById(order.getSellerId().intValue());
		modelMap.addAttribute("order", order);
		modelMap.addAttribute("seller", seller);
		return "order/orderDetail";
	}
	
	@RequestMapping("/cancelOrder")
	@ResponseBody
	public int cancelOrder(@RequestParam(value="orderId", required=true) Long orderId, 
			@RequestParam(value="cancelReason", required=true) String cancelReason, 
			HttpServletRequest request, HttpServletResponse response) {
		boolean isLogin = LoginServiceImpl.isLogin(request, response);
		if(!isLogin) {
			return -1;
		}
		String userId = LoginServiceImpl.getUserIdByCookie(request);
		Long uid = Long.parseLong(userId);
		User user = this.userService.getUserById(uid);
		return this.orderService.cancelOrderByIdAndUser(orderId, uid, user.getUserName(), cancelReason);
	}
	
	@RequestMapping("/confirmOrder")
	@ResponseBody
	public int confirmOrder(@RequestParam(value="orderId", required=true) Long orderId, 
			HttpServletRequest request, HttpServletResponse response) {
		boolean isLogin = LoginServiceImpl.isLogin(request, response);
		if(!isLogin) {
			return -1;
		}
		String userId = LoginServiceImpl.getUserIdByCookie(request);
		Long uid = Long.parseLong(userId);
		User user = this.userService.getUserById(uid);
		return this.orderService.confirmOrderByUser(orderId, uid, user.getUserName());
	}
	
	@RequestMapping("/deleteOrder")
	@ResponseBody
	public int deleteOrder(@RequestParam(value="orderId", required=true) Long orderId, 
			HttpServletRequest request, HttpServletResponse response) {
		boolean isLogin = LoginServiceImpl.isLogin(request, response);
		if(!isLogin) {
			return -1;
		}
		String userId = LoginServiceImpl.getUserIdByCookie(request);
		Long uid = Long.parseLong(userId);
		User user = this.userService.getUserById(uid);
		return this.orderService.deleteOrderByUser(orderId, uid, user.getUserName());
	}
}
