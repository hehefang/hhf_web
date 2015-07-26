package com.hhf.web.controller;

import com.alibaba.fastjson.JSON;
import com.unionpay.PaymentRequestVO;
import com.unionpay.PaymentResponseVO;
import com.hhf.constants.order.OrderConstants;
import com.hhf.constants.order.PayModeEnum;
import com.hhf.model.order.OrderLog;
import com.hhf.model.order.Payment;
import com.hhf.model.order.PaymentDetail;
import com.hhf.model.order.PaymentOrder;
import com.hhf.model.payment.vo.ResultVO;
import com.hhf.web.controller.AliPayController;
import com.hhf.service.payment.IPaymentServices;
import com.hhf.common.util.DateUtils;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.util.Date;
import java.util.List;

/**
 * Created with Liu Yong
 * User: melnnyy
 * Date: 2014/6/20
 * Time: 15:54
 */
@Controller
@RequestMapping("/unionpay")
public class UnionPayController {
    
    @Autowired
    private IPaymentServices paymentServices;
    private static final Logger log = LoggerFactory
			.getLogger(UnionPayController.class);
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
            , @RequestParam(value="a",required=false) String paymentIdStr
            , @RequestParam(value="b",required=false) String orderAmtStr
            , @RequestParam(value="c",required=false) String gateId,HttpServletRequest request,HttpServletResponse response) {
        ResultVO result;
        Long paymentId;
        BigDecimal orderAmt;
//        Long uid = LoginUtil.getUserIdIsLogin(response, request);
//        if(uid<1l){
//        	return "redirect:http://passport.yiwang.com/member/login/";
//        }
        try {
        	paymentId = Long.parseLong(paymentIdStr);
            orderAmt = new BigDecimal(orderAmtStr);
        } catch (Exception e) {
            map.put("result", ResultVO.getFailure("数据非法！").getInfo());
            return "unionpay/payError";
        }

        String pyId;
        String transAmt;
        try {
        	pyId = getPaymentId(paymentId);
            transAmt = getTransAmt(orderAmt);
        } catch (Exception e) {
            map.put("result", ResultVO.getFailure(e.getMessage()).getInfo());
            return "unionpay/payError";
        }
        result =this.paymentServices.checkAmountIsValid(paymentId,orderAmt);
        if (!result.getResult()) {
            map.put("result", result.getInfo());
            return "unionpay/payError";
        }
        
        PaymentRequestVO vo = new PaymentRequestVO();
        vo.setPaymentId(pyId);
        vo.setTransAmt(transAmt);
        PayModeEnum pme = PayModeEnum.get(gateId);
        if(null != pme) {
        	 vo.setGateId(pme.getGateId());
        }else{
        	 vo.setGateId("");
        }
       
        vo.setTransDate(DateUtils.formatDate(new Date(), "yyyyMMdd"));
        map.addAttribute("vo", vo);
        
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
		
//        String pay_domain="http://localhost:8888/hhf_web";//TODO
//		String active_str=System.getProperty("spring.profiles.active","product");
//		if("test".equalsIgnoreCase(active_str)){
//			pay_domain="http://web.test.hhf.com";//TODO
//		}
//		if("beta".equalsIgnoreCase(active_str)){
//			pay_domain="http://web.beta.hhf.com";//TODO
//		}
        
		map.addAttribute("paydomain", pay_domain);

        return "unionpay/pay";
    }

    @RequestMapping("/bussCallback")
    public String callback(HttpServletRequest request) {
        // ................................................. 验证交易合法性 ...
        PaymentResponseVO pay = new PaymentResponseVO();
        pay.init(request);
        verifyTrans(request, pay);      
        log.error("--------unionpay callback-------"+ JSON.toJSONString(pay)+"------------");
        if(!pay.getResult() || null == pay.getPaymentId()) {
        	log.error("--------unionpay callbackpage fail-------------------");
            return "unionpay/null";
        }

       Payment payment= this.paymentServices.getPaymentInfo(pay.getPaymentId());
       
       if( null == payment) {
           return "unionpay/null";
       }
       payment.setStatus(OrderConstants.PAY_STATUS_PAYED);
       payment.setRealPayDate(new Date());
       
       PayModeEnum pme = PayModeEnum.getByGateId(pay.getGateId());
       if(null != pme){
    	   payment.setRealPayGw(pme.getValue());
       }else{
    	   payment.setRealPayGw("1z");
       }
      payment.setTradeNo(pay.getOrderno());
      this.paymentServices.updatePayment(payment);
      List<PaymentDetail> pds =  this.paymentServices.getPaymentDetailByPamentId(payment.getPaymentId());
      
      if(null!=pds&&pds.size()>0){
    	  for (PaymentDetail pd : pds) {
    		  this.updateOrder(
    	                pd.getOrderId()
    	                , pay.getResult()
    	                , pay.getGateId()
    	                , pay.getInfo()
    	                ,OrderConstants.PAY_STATUS_PAYED
    	        );
    	  }
      }
        log.error("--------unionpay callback success-------------------");
        return "unionpay/null";
    }

    @RequestMapping("/pageCallback")
    public String callback2(HttpServletRequest request) {
        // ................................................. 验证交易合法性 ...
        PaymentResponseVO pay = new PaymentResponseVO();
        pay.init(request);
        verifyTrans(request, pay);
        log.error("--------unionpay callbackpage-------"+ JSON.toJSONString(pay)+"------------");
        if(!pay.getResult() || null == pay.getPaymentId()) {
        	log.error("--------unionpay callbackpage fail-------------------");
            return "unionpay/fail";//TODO
        }
        
        Payment payment= this.paymentServices.getPaymentInfo(pay.getPaymentId());
        
        if( null == payment) {
        	 return "redirect:http://www.yiwang.com";//TODO
        }
       payment.setTradeNo(pay.getOrderno()); 
       payment.setStatus(OrderConstants.PAY_STATUS_PAYING);
       payment.setCallbackDate(new Date());      
       this.paymentServices.updatePaymentpaying(payment);
       List<PaymentDetail> pds =  this.paymentServices.getPaymentDetailByPamentId(payment.getPaymentId());
       
       if(null!=pds&&pds.size()>0){
     	  for (PaymentDetail pd : pds) {
     		  this.updateOrder(
     	                pd.getOrderId()
     	                , pay.getResult()
     	                , pay.getGateId()
     	                , pay.getInfo()
     	                ,OrderConstants.PAY_STATUS_PAYING
     	        );
     	  }
       }
       log.error("--------unionpay callbackpage success-------------------");
        return "unionpay/success";//todo
    }

    // --------------------------------------------------------------------

    private void verifyTrans(HttpServletRequest request, PaymentResponseVO pay) {
        String baseDiskPath = request.getSession().getServletContext().getRealPath("/");
        try {
            pay.setPaymentId(getOriginPaymentId(pay.getOrderno()));
//            if(true) return;

            chinapay.PrivateKey key = new chinapay.PrivateKey();
            chinapay.SecureLink t;
            boolean flag;

            flag = key.buildKey("999999999999999", 0, baseDiskPath + "/WEB-INF/key/PgPubk.key");//TODO
            if (!flag) {
                pay.setInfo("response build key error!");
                return;
            }

            t = new chinapay.SecureLink(key);
            flag = t.verifyTransResponse(pay.getMerid(), pay.getOrderno(), pay.getTransamt(), pay.getCurrencycode(), pay.getTransdate(), pay.getTranstype(), pay.getStatus(), pay.getCheckvalue());
            if (!flag) {
                pay.setInfo("交易验证失败!");
                return;
            }
            if(pay.getStatus().equals("1001")){
            log.error("交易成功流水号:" + pay.getOrderno());
            log.error("----交易成功----");
            pay.setResult(true);
            }

        } catch (Exception e) {
            pay.setInfo(e.getMessage());
        }
    }

    // 根据银联返回的数据，得到我们自己的订单ID
    private Long getOriginPaymentId(String orderno) throws Exception {
        if(null == orderno || 16 != orderno.length())
            throw new Exception("银联传递过来的订单ID字符串有问题！("+orderno+")");

//        String s1 = orderno.substring(9);
//        String s2 = orderno.substring(0,4);
//        Long part1=Long.parseLong(s1);
//        Long part2=Long.parseLong(s2);
//        String part1_string=part1.toString();
//        String part2_string=part2.toString();
//        return Long.parseLong(part2_string.concat(part1_string));
        return Long.parseLong(orderno);
    }

    /**
     * 得到发送给银联的订单ID字符串
     *  1、16位的订单ID字符串，不够左补零
     *  2、二级商户，订单号从第5位到第9位必须和商户号的第11位到第15位相同
     */
    private String getPaymentId(Long paymentId) throws Exception {
//        String prefix = PaymentRequestVO.MER_ID_SUFFIX;
//        String pre_prefix="0000";
//        String payment_str = paymentId.toString();
//        int size1 = 7 - payment_str.length();
//        int size2 = payment_str.length()-7;
//        String res="";
//        if (4 < size2) throw new Exception("支付ID长度错误！");
//        
//        if (0 <= size1){
//        	for (int i = 0; i < size1; i++){
//        		payment_str = "0" + payment_str;
//        		}  	
//        	res = pre_prefix.concat(prefix).concat(payment_str);
//        }
//        	if(0 < size2){
//        		String result1=payment_str.substring(0, size2);        		
//        		String result2=payment_str.substring(size2);
//        		int subLength=4-size2;
//        		for (int i = 0; i < subLength; i++) {
//        			result1 = "0" + result1;
//        			}
//        		 res=result1.concat(prefix).concat(result2); 
//        	}
            String res="";
    	    String payment_str = paymentId.toString();
    	    int size = 16 - payment_str.length();
    	    if (0 <= size){
            	for (int i = 0; i < size; i++){
            		payment_str = "0" + payment_str;
            		}  	
            	res = payment_str;
            }
        	return res;
    }

    // 得到12位的订单交易金额，单位：分，不够左补零
    private String getTransAmt(BigDecimal orderAmt) throws Exception {
        DecimalFormat df = new DecimalFormat("##0");
        String result = df.format(orderAmt.multiply(new BigDecimal(100)));
        int size = 12 - result.length();

        if (0 == size) return result;
        if (0 > size) throw new Exception("订单交易金额错误！");

        for (int i = 0; i < size; i++) result = "0" + result;

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
        PayModeEnum pme = PayModeEnum.getByGateId(gateId);
        if(null != pme) {
        	paymentorder.setReceiptMode(pme.getValue());
        }else{
        	paymentorder.setReceiptMode("1z");
        }
        paymentorder.setReceiptType("1");
        paymentorder.setLastUpdateDate(new Date());
        paymentorder.setReceiptDate(new Date());
        paymentorder.setLastUpdateByName("银联在线支付");

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
            orderLog.setOptByName("银联在线支付");
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
            orderLog.setOptByName("银联在线支付");
            orderLog.setOptTime(DateUtils.currentDate());
            orderLog.setOrderId(order.getOrderId());
            orderLog.setToOrderStatus(order.getOrderStatus());
            this.paymentServices.addLog(orderLog);
        }
    }
}
