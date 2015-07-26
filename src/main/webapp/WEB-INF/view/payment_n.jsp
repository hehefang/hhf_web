<!DOCTYPE html>
<html lang="zh-cn">
<%@page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@include file="/common/common.jsp"%>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>订单支付</title>
	<link rel="stylesheet" type="text/css" href="${cssDomain }/css/allstyle.css"/>
	<link rel="stylesheet" type="text/css" href="${cssDomain }/css/order.css"/>
    <script type="text/javascript" src="${jsDomain}/jquery.min.js"></script>
    <script type="text/javascript" src="${jsDomain}/jquery.cookie.js"></script>
	<script type="text/javascript">
		$(function(){
			init();
			$(document).on("click","div.pay-ebank li",function(){
				var name = $(this).attr("name");
				$("div.pay-ebank li").removeClass("curr");
				$(this).addClass("curr");
				$("div.pay-ebank div.tabGroup").removeClass("show");
				$("div.pay-ebank div.tabGroup[name=" + name + "]").addClass("show");
			});
			$(document).on("click","input:radio[name=payMode]",function(){
				$("div.pay-ebank div.bank-item").removeClass("on");
				$(this).parents("div.bank-item").addClass("on");
				var imgsrc = $(this).siblings("img").attr("src");
				$("div.pay-ebank p.selectedMode img").attr("src", imgsrc);
				$("div.pay-ebank").addClass("selected");
			});
			$(document).on("click","p.selectedMode a.hint1",function() {
				$("div.pay-ebank").removeClass("selected");
			});
		});
		function init() {
			var payMode = "${payMode}";
			var obj = $("div.pay-ebank input:radio[name=payMode][value="+payMode+"]");
			obj.prop("checked",true);
			$("div.pay-ebank div.bank-item").removeClass("on");
			obj.parents("div.bank-item").addClass("on");
			var imgsrc = obj.siblings("img").attr("src");
			$("div.pay-ebank p.selectedMode img").attr("src", imgsrc);
			if("1" == payMode.substring(0, 1)) {
				$("div.pay-ebank li").removeClass("curr");
				$("div.pay-ebank li[name=bank]").addClass("curr");
				$("div.pay-ebank div.tabGroup").removeClass("show");
				$("div.pay-ebank div.tabGroup[name=bank]").addClass("show");
			} else if("2" == payMode.substring(0, 1)) {
				$("div.pay-ebank li").removeClass("curr");
				$("div.pay-ebank li[name=platform]").addClass("curr");
				$("div.pay-ebank div.tabGroup").removeClass("show");
				$("div.pay-ebank div.tabGroup[name=platform]").addClass("show");
			}
			$("div.pay-ebank").addClass("selected");
		}
		function paysubmit(){
			var paymode_sel=$("input[type=radio][name=payMode]:checked").val();
			if(paymode_sel=="20"){
				payurl="${ctx}/alipay/pay.action?a=${paymentId}&b=${total}"
			}
			if(paymode_sel=="1z"){
				payurl="${ctx}/unionpay/pay.action?a=${paymentId}&b=${total}&c=";
			}
			var get_char = paymode_sel.charAt(0);
			if(paymode_sel!="1z"&&get_char=="1"){
				payurl="${ctx}/unionpay/pay.action?a=${paymentId}&b=${total}&c="+paymode_sel;
			}
			$("div.mask").show();
			$("div.pop-pay").show();
			window.open(payurl,"payment");	
		}
	</script>
</head>
<body>
	<div class="wrapper">
		<jsp:include page="/common/head.jsp">
			<jsp:param name="hideMiniCart" value="1"/>   
		</jsp:include>
		<!-- container -->
		<div id="container">
			<div class="wrap">
				<!-- cartList -->
				<div class="cartList">
					<div class="hd">
						<h2><i class="icon i-card"></i>在线支付</h2>
						<ul class="mod-step">
							<li class="first over">
								<i class="num">1</i>
								<p class="text">购物车</p>
							</li>
							<li class="over">
								<i class="num">2</i>
								<span class="strip"></span>
								<span class="strip-over"></span>
								<p class="text">确认订单</p>
							</li>
							<li class="now">
								<i class="num">3</i>
								<span class="strip"></span>
								<span class="strip-over"></span>
								<p class="text">在线支付</p>
							</li>
							<li class="last">
								<i class="num">4</i>
								<span class="strip"></span>
								<span class="strip-over"></span>
								<p class="text">完成</p>
							</li>
						</ul>
					</div>
					<div class="bd">
						<div class="orderState payState">
							<!-- submitState -->
							<dl class="order-submitState">
								<dt><i class="icon i-right"></i></dt>
								<dd>
									<h3>您的订单已经成功提交，请尽快付款。</h3>
									<p>为了保证及时处理掉您的订单，请于下单<em>24小时内</em>付款，逾期未付款订单将被取消，需重新下单。</p>
								</dd>
							</dl>
							<!-- submitState end -->
						</div>
						<!-- orderPay -->
						<div class="orderPay">
							<div class="wrap">
								<div class="hd"><h3>支付方式</h3></div>
								<div class="bd">
									<div class="pay-ebank"><!--选择支付方式后加class  "selected"-->
										<div class="whichEbank">
											<p class="selectedMode"><em>支付方式：</em><span class="ico"><img src="" alt="" /></span>
												<a href="javascript:;" class="hint1" style="display:none">修改适合您的在线支付方式</a></p>
										</div>
										<div class="ebankList">
											<div class="tab">
												<div class="tabs">
													<ul>
														<li name="platform" class="curr">支付平台</li>
														<li name="bank">网上银行</li>
													</ul>
												</div>
												<div class="tabbed">
													<div name="platform" class="tabGroup show">
														<div class="wrap">
															<div class="bank-item on"><label><input type="radio" class="radio" name="payMode" id="" value="20"><img src="${imgDomain }/pay/alipay1.jpg" alt=""></label></div>
														</div>
													</div>
													<!--div name="bank" class="tabGroup" style="display:none;">
														<div class="wrap">
															<div class="bank-item"><label><input type="radio" class="radio" name="payMode" id="" value="10" disabled="disabled"><img src="${imgDomain }/pay/icbc.jpg" alt=""></label></div>
															<div class="bank-item"><label><input type="radio" class="radio" name="payMode" id="" value="11" disabled="disabled"><img src="${imgDomain }/pay/abc.jpg" alt=""></label></div>
															<div class="bank-item"><label><input type="radio" class="radio" name="payMode" id="" value="12" disabled="disabled"><img src="${imgDomain }/pay/boc.jpg" alt=""></label></div>
															<div class="bank-item"><label><input type="radio" class="radio" name="payMode" id="" value="13" disabled="disabled"><img src="${imgDomain }/pay/cbc.jpg" alt=""></label></div>
															<div class="bank-item"><label><input type="radio" class="radio" name="payMode" id="" value="14" disabled="disabled"><img src="${imgDomain }/pay/ctb.jpg" alt=""></label></div>
															<div class="bank-item"><label><input type="radio" class="radio" name="payMode" id="" value="15" disabled="disabled"><img src="${imgDomain }/pay/cmb.jpg" alt=""></label></div>
															<div class="bank-item"><label><input type="radio" class="radio" name="payMode" id="" value="16" disabled="disabled"><img src="${imgDomain }/pay/ceb.jpg" alt=""></label></div>
															<div class="bank-item"><label><input type="radio" class="radio" name="payMode" id="" value="17" disabled="disabled"><img src="${imgDomain }/pay/citic.jpg" alt=""></label></div>
															<div class="bank-item"><label><input type="radio" class="radio" name="payMode" id="" value="18" disabled="disabled"><img src="${imgDomain }/pay/cmbc.jpg" alt=""></label></div>
															<div class="bank-item"><label><input type="radio" class="radio" name="payMode" id="" value="19" disabled="disabled"><img src="${imgDomain }/pay/sdb.jpg" alt=""></label></div>
															<div class="bank-item"><label><input type="radio" class="radio" name="payMode" id="" value="1a" disabled="disabled"><img src="${imgDomain }/pay/hxb.jpg" alt=""></label></div>
															<div class="bank-item"><label><input type="radio" class="radio" name="payMode" id="" value="1b" disabled="disabled"><img src="${imgDomain }/pay/cgb.jpg" alt=""></label></div>
															<div class="bank-item"><label><input type="radio" class="radio" name="payMode" id="" value="1c" disabled="disabled"><img src="${imgDomain }/pay/spdb.jpg" alt=""></label></div>
															<div class="bank-item"><label><input type="radio" class="radio" name="payMode" id="" value="1d" disabled="disabled"><img src="${imgDomain }/pay/cib.jpg" alt=""></label></div>
															<div class="bank-item"><label><input type="radio" class="radio" name="payMode" id="" value="1e" disabled="disabled"><img src="${imgDomain }/pay/psbc.jpg" alt=""></label></div>
															<div class="bank-item"><label><input type="radio" class="radio" name="payMode" id="" value="1f" disabled="disabled"><img src="${imgDomain }/pay/bea.jpg" alt=""></label></div>
														</div>
													</div-->
												</div>
											</div>
										</div>
									</div>
									<p class="payPrice">支付金额：<b>&yen;<fmt:formatNumber value="${total }" minFractionDigits="2" /></b>
												共<c:out value="${ordernums }"/>笔订单</p>
									<p class="payBtn"><a href="javascript:;" onclick="paysubmit()" class="btn btn-primary">确认支付</a></p>
								</div>
							</div>
						</div>
						<!-- orderPay end -->
					</div>
				</div>
				<!-- cartList end -->
			</div>
		</div>
		<!-- container end -->
		<jsp:include page="/common/foot.html" />
	</div>
	<!-- pop -->
	<div class="popup popup-info pop-pay" style="display:none">
		<div class="hd">
			<i class="close" onclick="$('div.pop-pay').hide();$('div.mask').hide();"></i>
		</div>
		<div class="bd">
			<h2>请在新开的网银页面完成付款后选择：</h2>
			<p><i class="icon i-rightSM"></i><b>付款成功</b><span>您可以：<a href="${ctx }/cart/cart.action">返回购物车继续购物</a><a href="${ctx }/user/orders.action" >查看订单</a></span></p>
			<p><i class="icon i-graveSM"></i><b>付款失败</b><span>建议您：<a href="javascript:;" onclick="$('div.pop-pay').hide();$('div.mask').hide()">重新支付</a></span></p>
		</div>
	</div>
	<!-- popup end -->
	<div class="mask" style="display:none"></div>
</body>
</html>
