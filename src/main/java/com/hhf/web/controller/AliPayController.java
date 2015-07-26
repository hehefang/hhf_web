package com.hhf.web.controller;

import java.io.UnsupportedEncodingException;
import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.alibaba.dubbo.common.utils.StringUtils;
import com.alibaba.fastjson.JSON;
import com.alipay.util.AlipayNotify;
import com.hhf.constants.order.OrderConstants;
import com.hhf.model.order.OrderLog;
import com.hhf.model.order.Payment;
import com.hhf.model.order.PaymentDetail;
import com.hhf.model.order.PaymentOrder;
import com.hhf.model.payment.vo.ResultVO;
import com.hhf.service.payment.IPaymentServices;
import com.hhf.common.util.DateUtils;

/**
 * Created with xiaotao
 * User: xiaotao
 * Date: 2014/8/20
 * Time: 15:54
 */
@Controller
@RequestMapping("/alipay")
public class AliPayController {
	  @Autowired
	    private IPaymentServices paymentServices;
	    private static final Logger log = LoggerFactory
				.getLogger(AliPayController.class);
	  /**
	     * 支付请求处理
	     *
	     * @param map
	     * @param orderIdStr
	     * @param orderAmtStr
	     * @param gateId
	     * @return
	     */
	    @RequestMapping("/pay")
	    public String pay(ModelMap map
	            , @RequestParam("a") String paymentIdStr
	            , @RequestParam("b") String orderAmtStr
	            ,HttpServletRequest request,HttpServletResponse response) {
	        ResultVO result;
	        Long paymentId;
	        BigDecimal orderAmt;

//	        Long uid = LoginUtil.getUserIdIsLogin(response, request);
//	        if(uid<1l){
//	        	return "redirect:http://passport.yiwang.com/member/login/";
//	        }
	        try {
	        	paymentId = Long.parseLong(paymentIdStr);
	            orderAmt = new BigDecimal(orderAmtStr);
	        } catch (Exception e) {
	            map.put("result", ResultVO.getFailure("数据非法！").getInfo());
	            return "alipay/payError";
	        }

	        String pyId;
	        String transAmt;
	        try {
	        	pyId = getPaymentId(paymentId);
	            transAmt = getTransAmt(orderAmt);
	        } catch (Exception e) {
	            map.put("result", ResultVO.getFailure(e.getMessage()).getJson());
	            return "alipay/payError";
	        }
	        result =this.paymentServices.checkAmountIsValid(paymentId,orderAmt);
	        if (!result.getResult()) {
	            map.put("result", result.getInfo());
	            return "alipay/payError";
	        }

			String serverName = request.getServerName();
			int port = request.getServerPort();
			String ctx = request.getContextPath();
			StringBuilder domain = new StringBuilder();
			if(80 == port){
				domain = domain.append(serverName).append(ctx);
			} else {
				domain = domain.append(serverName).append(":").append(port).append(ctx);
			}
			
			String pay_domain = domain.toString();
			
//	        String pay_domain="http://localhost:8888/hhf_web";//TODO
//			String active_str=System.getProperty("spring.profiles.active","product");
//			if("test".equalsIgnoreCase(active_str)){
//				pay_domain="http://web.test.hhf.com";//TODO
//			}
//			if("beta".equalsIgnoreCase(active_str)){
//				pay_domain="http://web.beta.hhf.com";//TODO
//			}
	        map.addAttribute("pyId", pyId);
	        map.addAttribute("transAmt", transAmt);
	        map.addAttribute("paydomain", pay_domain);
	        return "alipay/pay";
	    }

	    @RequestMapping("/bussCallback")
	    public String callback( @RequestParam("out_trade_no")String out_trade_no,  @RequestParam("trade_no")String trade_no,  @RequestParam("trade_status")String trade_status,ModelMap modelMap, HttpServletRequest request) {
	        // ................................................. 验证交易合法性 ...
	    	//获取支付宝POST过来反馈信息
	    	String refund_status =request.getParameter("refund_status");
	    	Map<String,String> params = new HashMap<String,String>();
	    	Map requestParams = request.getParameterMap();
	    	for (Iterator iter = requestParams.keySet().iterator(); iter.hasNext();) {
	    		String name = (String) iter.next();
	    		String[] values = (String[]) requestParams.get(name);
	    		String valueStr = "";
	    		for (int i = 0; i < values.length; i++) {
	    			valueStr = (i == values.length - 1) ? valueStr + values[i]
	    					: valueStr + values[i] + ",";
	    		}
	    		params.put(name, valueStr);
	    	}

	        log.error("--------alipay callback-------"+ JSON.toJSONString(params)+"------------");
	        
	    	if(AlipayNotify.verify(params)){
	    		if((trade_status.equals("TRADE_FINISHED") || trade_status.equals("TRADE_SUCCESS"))&&(StringUtils.isBlank(refund_status))){
	    			
	    		Long paymentId=new Long(out_trade_no);
	    		Payment payment= this.paymentServices.getPaymentInfo(paymentId);
	    	       payment.setStatus(OrderConstants.PAY_STATUS_PAYED);
	    	       payment.setRealPayDate(new Date());
	    	       payment.setRealPayGw("20");
	    	       payment.setTradeNo(trade_no);
	    	      this.paymentServices.updatePayment(payment);
	    	      List<PaymentDetail> pds =  this.paymentServices.getPaymentDetailByPamentId(payment.getPaymentId());
	    	      
	    	      if(null!=pds&&pds.size()>0){
	    	    	  for (PaymentDetail pd : pds) {
	    	    		  this.updateOrder(
	    	    	                pd.getOrderId()
	    	    	                ,  true
	    	    	                , "20"
	    	    	                , "支付宝支付成功"
	    	    	                ,OrderConstants.PAY_STATUS_PAYED
	    	    	        );
	    	    	  }
	    	      }
	    		}
	    		
	    	      log.error("--------alipay callback success-------------------");
	    	      return "alipay/callbacksuccess";
           }else{//验证失败
        	      log.error("-------- alipay callback fail-------------------");
	    		modelMap.addAttribute("msg", "fail");
	    	}
	    	return "alipay/callbackfail";
	    }

	    @RequestMapping("/pageCallback")
	    public String callback2(HttpServletRequest request) throws UnsupportedEncodingException {
	    	Map<String,String> params = new HashMap<String,String>();
	    	Map requestParams = request.getParameterMap();
	    	for (Iterator iter = requestParams.keySet().iterator(); iter.hasNext();) {
	    		String name = (String) iter.next();
	    		String[] values = (String[]) requestParams.get(name);
	    		String valueStr = "";
	    		for (int i = 0; i < values.length; i++) {
	    			valueStr = (i == values.length - 1) ? valueStr + values[i]
	    					: valueStr + values[i] + ",";
	    		}
	    		//乱码解决，这段代码在出现乱码时使用。如果mysign和sign不相等也可以使用这段代码转化
	    		//valueStr = new String(valueStr.getBytes("ISO-8859-1"), "utf-8");
	    		params.put(name, valueStr);
	    	}
	    	
	    	//获取支付宝的通知返回参数，可参考技术文档中页面跳转同步通知参数列表(以下仅供参考)//
	    	//商户订单号

	    	String out_trade_no = new String(request.getParameter("out_trade_no").getBytes("ISO-8859-1"),"UTF-8");

	    	//支付宝交易号

	    	String trade_no = new String(request.getParameter("trade_no").getBytes("ISO-8859-1"),"UTF-8");
	    	String refund_status =request.getParameter("refund_status");
	    	//交易状态
	    	String trade_status = new String(request.getParameter("trade_status").getBytes("ISO-8859-1"),"UTF-8");
	    	//计算得出通知验证结果
	    	boolean verify_result = AlipayNotify.verify(params);
	    	log.error("--------alipay callbackpage-------"+ JSON.toJSONString(params)+"------------");
	    	log.error("trade_status:"+trade_status+"----------");
	    	if(verify_result){
	    		
	    		if((trade_status.equals("TRADE_FINISHED") || trade_status.equals("TRADE_SUCCESS"))&&(StringUtils.isBlank(refund_status))){

	    			    Long paymentId=new Long(out_trade_no);
	    		        Payment payment= this.paymentServices.getPaymentInfo(paymentId);
	    		        
	    		        if( null == payment) {
	    		        	return "alipay/fail";
	    		        }
	    		       payment.setTradeNo(trade_no);
	    		       payment.setStatus(OrderConstants.PAY_STATUS_PAYING);
	    		       payment.setCallbackDate(new Date());      
	    		       this.paymentServices.updatePaymentpaying(payment);
	    		       List<PaymentDetail> pds =  this.paymentServices.getPaymentDetailByPamentId(payment.getPaymentId());
	    		       
	    		       if(null!=pds&&pds.size()>0){
	    		     	  for (PaymentDetail pd : pds) {
	    		     		  this.updateOrder(
	    		     	                pd.getOrderId()
	    		     	                , true
	    		     	                , "20"
	    		     	                , "支付宝支付成功"
	    		     	                ,OrderConstants.PAY_STATUS_PAYING
	    		     	        );
	    		     	  }
	    		       }
	    		}
	    		log.error("--------alipay callbackpage success-------------------");
	    		//该页面可做页面美工编辑
	    		return "alipay/success";
	    		
	    	}else{
	    		log.error("--------alipay callbackpage fail-------------------");
	    		//该页面可做页面美工编辑
	    		return "alipay/fail";
	    	}
	    }

	    // --------------------------------------------------------------------


	    private String getPaymentId(Long paymentId) throws Exception {
	        return paymentId.toString();
	    }

	    private String getTransAmt(BigDecimal orderAmt) throws Exception {
	        DecimalFormat df = new DecimalFormat("0.00");
	        String result = df.format(orderAmt);
	        return result;
	    }
	    
	    private ResultVO updateOrder(Long orderId, boolean flag, String gateId, String info,String paystatus) {
	        ResultVO result = ResultVO.getFailure();
	        PaymentOrder paymentorder = this.paymentServices.getOrderByOrderId(orderId);
	        if(null == paymentorder) {
	            result.setInfo("数据非法！");
	            return result;
	        }

	        paymentorder.setInfo(info);
	        paymentorder.setReceiptMode(gateId);	        
	        paymentorder.setReceiptType("1");
	        paymentorder.setLastUpdateDate(new Date());
	        paymentorder.setReceiptDate(new Date());
	        paymentorder.setLastUpdateByName("支付宝支付");

	        try {
	            if(flag){ 
	            	this.paySuccess(paymentorder,paystatus);
	            	}
	            else{
	            	this.payFailure(paymentorder,paystatus);
	            	}

	            result.setResult(true);
	            result.setInfo("更新成功！");
	        } catch (Exception e) {
	            result.setInfo("更新失败！" + e.getMessage());
	        }

	        return result;
	    }

	    private void paySuccess(PaymentOrder order,String paystatus) throws Exception {
	        if(paystatus.equals(OrderConstants.PAY_STATUS_PAYED)){
	        	order.setOrderStatus(OrderConstants.ORDER_STATUS_WAITDELIVERED);
	        }    	
	        order.setPayStatus(paystatus);
	        order.setReceiptDate(order.getLastUpdateDate());
	        int result=0;
	        if(paystatus.equals(OrderConstants.PAY_STATUS_PAYED)){
	        	result= this.paymentServices.updatePaySuccessOrder(order);
	        }else{
	        	result= this.paymentServices.updatePayingOrder(order);
	        }
	        

	        if(0 != result) {
	            OrderLog orderLog = new OrderLog();
	            orderLog.setFromOrderStatus(OrderConstants.ORDER_STATUS_WAITPAYMENT);
	            orderLog.setOptContent("订单支付成功！");
	            orderLog.setOptByName("支付宝支付");
	            orderLog.setOptTime(DateUtils.currentDate());
	            orderLog.setOrderId(order.getOrderId());
	            orderLog.setToOrderStatus(order.getOrderStatus());
	            this.paymentServices.addLog(orderLog);
	        }
	    }

	    private void payFailure(PaymentOrder order,String paystatus) throws Exception {
	    	if(paystatus.equals(OrderConstants.PAY_STATUS_PAYING)){
	    		return ;
	    	}
	        order.setPayStatus(OrderConstants.PAY_STATUS_FAILURE);
	        int result = this.paymentServices.updatePayFailureOrder(order);

	        if(0 != result) {
	            OrderLog orderLog = new OrderLog();
	            orderLog.setFromOrderStatus(order.getOrderStatus());
	            orderLog.setOptContent("订单支付失败！(" + order.getInfo() + ")");
	            orderLog.setOptByName("支付宝支付");
	            orderLog.setOptTime(DateUtils.currentDate());
	            orderLog.setOrderId(order.getOrderId());
	            orderLog.setToOrderStatus(order.getOrderStatus());
	            this.paymentServices.addLog(orderLog);
	        }
	    }
}
