package com.unionpay;

import javax.servlet.http.HttpServletRequest;

/**
 * 接收银联返回的信息
 * User: melnnyy
 * Date: 2014/6/30
 * Time: 11:08
 */
public class PaymentResponseVO {
    private String merid;
    private String orderno;
    private String transdate;
    private String currencycode;
    private String transtype;
    private String transamt;
    private String status;
    private String checkvalue;
    private String GateId;
    private String Priv1;

    private boolean result = false;
    private String info;
    private Long paymentId;

    public void init(HttpServletRequest request)
    {
        setMerid(request.getParameter("merid"));
        setOrderno(request.getParameter("orderno"));
        setTransdate(request.getParameter("transdate"));
        setCurrencycode(request.getParameter("currencycode"));
        setTranstype(request.getParameter("transtype"));
        setTransamt(request.getParameter("amount"));
        setStatus(request.getParameter("status"));
        setCheckvalue(request.getParameter("checkvalue"));
        setGateId(request.getParameter("GateId"));
        setPriv1(request.getParameter("Priv1"));
    }

    public boolean getResult() {
        return result;
    }

    public void setResult(boolean result) {
        this.result = result;
    }

    public String getInfo() {
        return info;
    }

    public void setInfo(String info) {
        this.info = info;
    }

    public String getTransamt() {
        return transamt;
    }

    public void setTransamt(String transamt) {
        this.transamt = transamt;
    }

    public String getMerid() {
        return merid;
    }

    public void setMerid(String merid) {
        this.merid = merid;
    }

    public String getOrderno() {
        return orderno;
    }

    public void setOrderno(String orderno) {
        this.orderno = orderno;
    }

    public String getTransdate() {
        return transdate;
    }

    public void setTransdate(String transdate) {
        this.transdate = transdate;
    }

    public String getCurrencycode() {
        return currencycode;
    }

    public void setCurrencycode(String currencycode) {
        this.currencycode = currencycode;
    }

    public String getTranstype() {
        return transtype;
    }

    public void setTranstype(String transtype) {
        this.transtype = transtype;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getCheckvalue() {
        return checkvalue;
    }

    public void setCheckvalue(String checkvalue) {
        this.checkvalue = checkvalue;
    }

    public String getGateId() {
        return GateId;
    }

    public void setGateId(String gateId) {
        GateId = gateId;
    }

    public String getPriv1() {
        return Priv1;
    }

    public void setPriv1(String priv1) {
        Priv1 = priv1;
    }

	public Long getPaymentId() {
		return paymentId;
	}

	public void setPaymentId(Long paymentId) {
		this.paymentId = paymentId;
	}
}
