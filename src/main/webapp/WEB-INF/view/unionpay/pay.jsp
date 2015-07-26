﻿<%
    response.setHeader("Pragma", "no-cache");
    response.addHeader("Cache-Control", "must-revalidate");
    response.addHeader("Cache-Control", "no-cache");
    response.addHeader("Cache-Control", "no-store");
    response.setDateHeader("Expires", -1);
%>
<%@ page import="com.unionpay.SessionTokenGenerator" %>
<%@ page import="com.unionpay.PaymentRequestVO" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="expires" content="0">
    <title></title>
    <script type="text/javascript">
        window.onload = function () {
            var form = document.getElementById('myform');
//             form.submit(); //TODO
        };
    </script> 
</head>
<body>
<%
    PaymentRequestVO vo = (PaymentRequestVO) request.getAttribute("vo");
    String paydomain=(String)request.getAttribute("paydomain");
    vo.setBgRetUrl(paydomain+"/unionpay/bussCallback.action");
    vo.setPageRetUrl(paydomain+"/unionpay/pageCallback.action");

    String token = SessionTokenGenerator.generateToken(session);

    chinapay.PrivateKey key = new chinapay.PrivateKey();
    chinapay.SecureLink t;
    boolean flag;

    String baseDiskPath=request.getSession().getServletContext().getRealPath("/");
    flag = key.buildKey(vo.getMerId(), 0, baseDiskPath + "/WEB-INF/key/MerPrK.key");
    if (!flag) {
        out.print("build key error!");
        return;
    }
    t = new chinapay.SecureLink(key);
    vo.setChkValue(
            t.signOrder(vo.getMerId()
            , vo.getPaymentId()
            , vo.getTransAmt()
            , vo.getCuryId()
            , vo.getTransDate()
            , vo.getTransType()));
%>
<div style="display: none">
<form id="myform" name="SendToMer" action="https://payment.chinapay.com/pay/TransGet" METHOD="post">
<%--<form id="myform" name="SendToMer" action="http://payment-test.chinapay.com/pay/TransGet" METHOD="post">--%>
    <input size="50" type=text name="MerId" value="<%=vo.getMerId()%>">（MerId为ChinaPay统一分配给商户的商户号，15位长度，必填）<br/>
    <input size="50" type=text name="OrdId" value="<%=vo.getPaymentId()%>">（商户提交给ChinaPay的交易订单号，16位长度，必填）<br/>
    <input size="50" type=text name="TransAmt" value="<%=vo.getTransAmt()%>">（订单交易金额，12位长度，左补0， 必填,单位为分）<br/>
    <input size="50" type=text name="CuryId" value="<%=vo.getCuryId()%>">（订单交易币种，3位长度，固定为人民币156， 必填）<br/>
    <input size="50" type=text name="TransDate" value="<%=vo.getTransDate()%>">（订单交易日期，8位长度，必填）<br/>
    <input size="50" type=text name="TransType" value="<%=vo.getTransType()%>">（交易类型，4位长度，必填）<br/>
    <input size="50" type=text name="Version" value="<%=vo.getVersion()%>">（接口版本号）<br/>
    <input size="50" type=text name="BgRetUrl" value="<%=vo.getBgRetUrl()%>">（后台交易接收URL，长度不要超过80个字节）<br/>
    <input size="50" type=text name="PageRetUrl" value="<%=vo.getPageRetUrl()%>">（页面交易接收URL，长度不要超过80个字节）<br/>
    <input size="50" type=text name="GateId" value="<%=vo.getGateId()%>">（支付网关号，可选）<br/>
    <input size="50" type=text name="Priv1" value="">（商户私有域，可选，长度不要超过60个字节）<br/>
    <input size="50" type=text name="ChkValue" value="<%=vo.getChkValue()%>">（256字节长的ASCII码）<br/>
    <%--<input type="hidden" name="token" value="<%=token%>"/>--%>
    <input type="submit">
</form>
</div>
</body>
</html>