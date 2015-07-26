package com.unionpay;

/**
 * 提交给银联的信息
 * User: melnnyy
 * Date: 2014/6/28
 * Time: 14:11
 */
public class PaymentRequestVO {
    public static final String MER_ID_SUFFIX = "04512";

    public String merId = "808080201304512"; // MerId为ChinaPay统一分配给商户的商户号，15位长度，必填//TODO
    public String curyId = "156"; // 订单交易币种，3位长度，固定为人民币156，必填
    private String transType = "0001"; // 交易类型，4位长度，取值范围为："0001"和"0002"， 其中"0001"表示消费交易，"0002"表示退货交易，必填
    private String version = "20070129"; // 支付接入版本号，必填

    private String paymentId; // 商户提交给ChinaPay的交易订单号，16位长度，失败的订单号允许重复支付，必填
    private String transAmt; // 订单交易金额，单位为分，12位长度，左补0，必填
    private String transDate; // 订单交易日期，8位长度，必填
    private String bgRetUrl; // 后台交易接收URL，必填，长度不要超过80个字节
    private String pageRetUrl; // 页面交易接收URL，长度不要超过80个字节，必填
    private String gateId; // 支付网关号，可选
    private String priv1; // 商户私有域，长度不要超过60个字节，可选
    private String chkValue; // 256字节长的ASCII码,为此次交易提交关键数据的数字签名，必填


    public String getTransAmt() {
        return transAmt;
    }

    public void setTransAmt(String transAmt) {
        this.transAmt = transAmt;
    }

    public String getTransDate() {
        return transDate;
    }

    public void setTransDate(String transDate) {
        this.transDate = transDate;
    }

    public String getTransType() {
        return transType;
    }

    public void setTransType(String transType) {
        this.transType = transType;
    }

    public String getVersion() {
        return version;
    }

    public void setVersion(String version) {
        this.version = version;
    }

    public String getBgRetUrl() {
        return bgRetUrl;
    }

    public void setBgRetUrl(String bgRetUrl) {
        this.bgRetUrl = bgRetUrl;
    }

    public String getPageRetUrl() {
        return pageRetUrl;
    }

    public void setPageRetUrl(String pageRetUrl) {
        this.pageRetUrl = pageRetUrl;
    }

    public String getGateId() {
        return gateId;
    }

    public void setGateId(String gateId) {
        this.gateId = gateId;
    }

    public String getPriv1() {
        return priv1;
    }

    public void setPriv1(String priv1) {
        this.priv1 = priv1;
    }

    public String getChkValue() {
        return chkValue;
    }

    public void setChkValue(String chkValue) {
        this.chkValue = chkValue;
    }

    public String getMerId() {
        return merId;
    }

    public String getCuryId() {
        return curyId;
    }

	public String getPaymentId() {
		return paymentId;
	}

	public void setPaymentId(String paymentId) {
		this.paymentId = paymentId;
	}
}
