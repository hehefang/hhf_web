package com.hhf.web.controller;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.math.NumberUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import com.hhf.model.order.Order;
import com.hhf.model.order.Payment;
import com.hhf.model.order.PaymentDetail;
import com.hhf.service.order.IOrderService;
import com.hhf.service.payment.IPaymentServices;
import com.hhf.service.user.IUserService;
import com.hhf.web.service.impl.LoginServiceImpl;


/**
 * @author xiaotao
 * 
 */


@Controller
public class PaymentController {
	@Autowired
	private IUserService userService;
	@Autowired
	private IOrderService orderService;
	@Autowired
	private IPaymentServices paymentServices;
	
	@RequestMapping(value = "/payment")
	public String  payment(HttpServletRequest request, ModelMap modelMap,
			HttpServletResponse response){
		boolean isLogin = LoginServiceImpl.isLogin(request, response);
		if(!isLogin) {
			return "redirect:http://www.hehefang.com";
		}
		String orderid = request.getParameter("orderid");
		String uid = request.getParameter("uid");
		String paymentid = request.getParameter("paymentid");
		Long userid=NumberUtils.toLong(uid);
		if (StringUtils.isBlank(uid)) {
			return "payfail";
		}
		if (StringUtils.isBlank(orderid)&&StringUtils.isBlank(paymentid)) {
			return "payfail";
		}
		if(!StringUtils.isBlank(paymentid)){
			
			Long paymentId=NumberUtils.toLong(paymentid);
			Payment payment=this.paymentServices.getPaymentInfo(paymentId);
			if(null!=payment){
				Long paymentUid=payment.getUserId();
				if(paymentUid.compareTo(userid)!=0){
					return "payfail";
				}
				BigDecimal orderFee = payment.getPayAmount();
				String payGw=payment.getPayGw();
				String payurl="";
				List<PaymentDetail> PaymentDetails = this.paymentServices.getPaymentDetailByPamentId(paymentId);
				Long[] ids_list;
				if (PaymentDetails != null && PaymentDetails.size() > 0) {
					ids_list = new Long[PaymentDetails.size()];
					int i=0;
					for (PaymentDetail pd : PaymentDetails) {
						ids_list[i] = (new Long(pd.getOrderId()));
						i++;
					}
				}else{
					return "payfail";
				}
				 List<Order> orderlist = this.orderService.getOrdersByIdsAndUserId(ids_list,userid);
				if(payGw.equals("20")){
					payurl="/alipay/pay.action?a="+paymentId+"&b="+orderFee.toString();
				}
				if(payGw.equals("1z")){
					payurl="/unionpay/pay.action?a="+paymentId+"&b="+orderFee.toString()+"&c=";
				}
				
				if(payGw.substring(0, 1).equals("1")){
					payurl="/unionpay/pay.action?a="+paymentId+"&b="+orderFee.toString()+"&c="+payGw;
				}
				
				long ordernums=orderlist.size();
				modelMap.addAttribute("ordernums", ordernums);
				modelMap.addAttribute("paymentId", paymentId);
				modelMap.addAttribute("payMode", payGw);
				modelMap.addAttribute("total", orderFee);
				modelMap.addAttribute("payurl", payurl);
				modelMap.addAttribute("orderlist",orderlist);
				return "payment_n";
			}
		}
		if (!StringUtils.isBlank(orderid)) {			
			Long[] ids_list;
			ids_list = new Long[1];
			List<Long> orderids_list =new ArrayList<Long>();
			ids_list[0] = (new Long(orderid));		
			orderids_list.add(new Long(orderid));
			String payGw="";
			BigDecimal orderFee = new BigDecimal(0);
			List<Order> orderlist = this.orderService.getOrdersByIds(ids_list);
			if (orderlist != null && orderlist.size() > 0) {
				for (Order order : orderlist) {
					payGw=order.getPayMode();
					
						Long orderuserId=order.getUserId();
						if(orderuserId.compareTo(userid)!=0){
							return "payfail";						
					}
					orderFee=orderFee.add(order.getOrderFee());
				}
			}
			orderlist = this.orderService.getOrdersByIdsAndUserId(ids_list, userid);
			String paymentType="1";
			if(orderlist.size() > 1){
				paymentType="2";
			}
			String ip = request.getRemoteAddr();//返回发出请求的IP地址
			Long paymentId=this.paymentServices.savePaymentId(orderids_list, "1", ip, userid, payGw, paymentType);
			if(paymentId.compareTo(0L)<0){
				return "payfail";
			}
			String payurl="";
			if(payGw.equals("20")){
				payurl="/alipay/pay.action?a="+paymentId+"&b="+orderFee.toString();
			}
			if(payGw.equals("1z")){
				payurl="/unionpay/pay.action?a="+paymentId+"&b="+orderFee.toString()+"&c=";
			}			
			if(payGw.substring(0, 1).equals("1")){
				payurl="/unionpay/pay.action?a="+paymentId+"&b="+orderFee.toString()+"&c="+payGw;
			}			
			long ordernums=orderlist.size();
			modelMap.addAttribute("ordernums", ordernums);
			modelMap.addAttribute("paymentId", paymentId);
			modelMap.addAttribute("payMode", payGw);
			modelMap.addAttribute("total", orderFee);
			modelMap.addAttribute("payurl", payurl);
			modelMap.addAttribute("orderlist",orderlist);
			return "payment_n";
		}	
		return "payfail";
		
	}
}
