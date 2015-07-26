<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ include file="/common/common.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<script type="text/javascript" src="${jsDomain}/jquery.min.js"></script>
	<script type="text/javascript" src="${jsDomain}/jquery.cookie.js"></script>
	<link rel="stylesheet" type="text/css" href="${cssDomain }/css/allstyle.css"/>
	<link rel="stylesheet" type="text/css" href="${cssDomain }/css/order.css"/>
	<title>订单详情</title>
	<script type="text/javascript">
		$(function(){
			if("${order.orderStatus}" == "2") {
				setInterval("payRestTime()",1000);
			}
			$(document).on("change","#reason",function(){
				if('0' == $(this).val()) {
					$("#cancel-confirm").addClass("disabled");
				} else {
					$("#cancel-confirm").removeClass("disabled");
				}
			});
			$(document).on("click","#cancel-confirm",function(){
				var orderId = "${order.orderId}";
				var reason = $("#reason option[value="+$("#reason").val()+"]").text();
				$.post(
					"${ctx}/user/cancelOrder.action",
					{orderId:orderId, cancelReason:reason},
					function(res){
						closeCancelPop();
						if(res == -1) {
							gotoLogin();
						}else if (res <= 0){
							alert("取消订单失败，请重试！");
						} else {
							reload();
						}
					}
				);
			});
			$(document).on("click","#confirm-confirm",function(){
				var orderId = "${order.orderId}";
				$.post(
					"${ctx}/user/confirmOrder.action",
					{orderId:orderId},
					function(res){
						closeConfirmPop();
						if(res == -1) {
							gotoLogin();
						}else if (res <= 0){
							alert("确认收货失败，请重试！");
						} else {
							reload();
						}
					}
				);
			});
		});
		function cancelOrder() {
			$("div.mask").show();
			$("div.cancel-order").show();
			$("#reason").val("0");
			$("#cancel-confirm").attr("orderId","${order.orderId}");
		}
		function confirmOrder() {
			$("div.mask").show();
			$("div.confirm-order").show();
			$("#confirm-confirm").attr("orderId","${order.orderId}");
		}
		function closeCancelPop() {
			$("div.mask").hide();
			$("div.pop-order").hide();
			$("#reason").val("0");
			$("#cancel-confirm").attr("orderId","");
			$("#cancel-confirm").addClass("disabled");
		}
		function closeConfirmPop() {
			$("div.mask").hide();
			$("div.pop-order").hide();
			$("#confirm-confirm").attr("orderId","");
		}
		function reload() {
			location.href = "${ctx}/user/orderDetail.action?orderId=${order.orderId}";
		}
		function gotoLogin() {
			location.href = "${ctx}/login.action?rtnUrl=${ctx}/user/orderDetail.action?orderId=${order.orderId}";
		}
		function payRestTime(){
			var restTime = $("span.payRestTime").siblings("input[type=hidden]").val() - 1;
			if(restTime < 0) {
				restTime = 0;
			}
			$("span.payRestTime").siblings("input[type=hidden]").val(restTime);
			var h = parseInt(restTime / 3600);
			restTime = parseInt(restTime % 3600);
			var m = parseInt(restTime / 60);
			var s = parseInt(restTime % 60);
			var text = ""+h+"小时"+m+"分"+s+"秒";
			$("span.payRestTime").html(text);
		}
	</script>
</head>
<body>
	<div class="wrapper">
		<jsp:include page="/common/head.jsp"></jsp:include>
		<!-- container -->
		<div id="container">
			<div class="wrap">
				<!-- orderDetail -->
				<div class="orderDetail">
					<div class="hd">
						<div class="breadnav">
							<span class="index"><a href="http://www.hehefang.com">首页</a></span>
							<ul class="nav">
								<li><span>&gt;</span><a href="${ctx}/user/userCenter.action">我的禾合坊</a></li>
								<li><span>&gt;</span><a href="">我的订单</a></li>
							</ul>
						</div>
					</div>
					<div class="bd">
						<div class="orderFlow">
							<div class="orderFlow-process">
								<c:if test="${order.orderStatus == '2' }">
									<ul class="train-nav train-nav1">
										<li class="first-child on"><i class="head"></i><a href="">1、提交订单</a><em class="follow">2013-12-12&nbsp;23:32:30</em></li>
										<li><i class="head"></i><i class="end"></i><a href="">2、支付订单</a><em class="follow">2013-12-12&nbsp;23:32:30</em></li>
										<li><i class="head"></i><i class="end"></i><a href="">3、卖家发货</a><em class="follow">2013-12-12&nbsp;23:32:30</em></li>
										<li class="last-child"><i class="end"></i><a href="">4、确认收货</a><em class="follow">2013-12-12&nbsp;23:32:30</em></li>
									</ul>
									<div class="tooltip guide-TL">
										<span class="arrow top-hollow xl"><b></b><i></i></span>
										<div class="wrap" style=" height:;">
											<div class="bd">
												<h2>当前状态：订单已生效</h2>
												<p>
													还有<span class="errTxt payRestTime">XX小时XX分钟XX秒</span>来支付，超时订单将自动关闭。
													<input type="hidden" value="${order.payRestTime }" />
												</p>
												<div class="btnGro">
													<a href="${ctx}/user/payment.action?orderId=${order.orderId}" class="btn btn-primary">去支付</a>
													<a href="javascript:cancelOrder();">取消订单</a>
												</div>
											</div>
										</div>
									</div>
								</c:if>
								<c:if test="${order.orderStatus == '3' }">
									<ul class="train-nav train-nav1">
										<li class="first-child bef"><i class="head"></i><a href="">1、提交订单</a><em class="follow">2013-12-12&nbsp;23:32:30</em></li>
										<li class="on"><i class="head"></i><i class="end"></i><a href="">2、支付订单</a><em class="follow">2013-12-12&nbsp;23:32:30</em></li>
										<li><i class="head"></i><i class="end"></i><a href="">3、卖家发货</a><em class="follow">2013-12-12&nbsp;23:32:30</em></li>
										<li class="last-child"><i class="end"></i><a href="">4、确认收货</a><em class="follow">2013-12-12&nbsp;23:32:30</em></li>
									</ul>
									<div class="tooltip guide-TC">
										<span class="arrow top-hollow xl"><b></b><i></i></span>
										<div class="wrap" style=" height:;">
											<div class="bd">
												<h2>当前订单状态：订单已支付，等待卖家发货</h2>
												<p>您的订单已支付成功，系统已经通知卖家尽快准备货品，并快速寄到您的手中。</p>
											</div>
										</div>
									</div>
								</c:if>
								<c:if test="${order.orderStatus == '4' }">
										<div class="wrap order-close">
											<div class="bd">
												<h2>当前订单状态：已取消</h2>
												<p>关闭人：<c:out value="${order.cancelByName }"/></p>
												<p>关闭原因：<c:out value="${order.cancelReason }"/></p>
											</div>
									</div>
								</c:if>
								<c:if test="${order.orderStatus == '5' }">
									<ul class="train-nav train-nav1">
										<li class="first-child bef"><i class="head"></i><a href="">1、提交订单</a><em class="follow">2013-12-12&nbsp;23:32:30</em></li>
										<li class="bef"><i class="head"></i><i class="end"></i><a href="">2、支付订单</a><em class="follow">2013-12-12&nbsp;23:32:30</em></li>
										<li class="on"><i class="head"></i><i class="end"></i><a href="">3、卖家发货</a><em class="follow">2013-12-12&nbsp;23:32:30</em></li>
										<li class="last-child"><i class="end"></i><a href="">4、确认收货</a><em class="follow">2013-12-12&nbsp;23:32:30</em></li>
									</ul>
									<div class="tooltip guide-TC three">
										<span class="arrow top-hollow xl"><b></b><i></i></span>
										<div class="wrap" style=" height:;">
											<div class="bd">
												<h2>当前订单状态：卖家发货</h2>
												<p>您购买的商品已经发出，不久将送至您的手中，请耐心等待。</p>
												<p>此订单将在<span class="errTxt">1天23小时32分钟1秒</span>后自动完成，如果您已经收到货物，您可以点击下方的“确认收货”按钮完成订单。</p>
												<div class="btnGro">
													<a href="javascript:confirmOrder();" class="btn btn-primary">确认收货</a>
												</div>
											</div>
										</div>
									</div>
								</c:if>
								<c:if test="${order.orderStatus == '8' }">
									<ul class="train-nav train-nav1">
										<li class="first-child bef"><i class="head"></i><a href="">1、提交订单</a><em class="follow">2013-12-12&nbsp;23:32:30</em></li>
										<li class="bef"><i class="head"></i><i class="end"></i><a href="">2、支付订单</a><em class="follow">2013-12-12&nbsp;23:32:30</em></li>
										<li class="bef"><i class="head"></i><i class="end"></i><a href="">3、卖家发货</a><em class="follow">2013-12-12&nbsp;23:32:30</em></li>
										<li class="last-child on"><i class="end"></i><a href="">4、确认收货</a><em class="follow">2013-12-12&nbsp;23:32:30</em></li>
									</ul>
									<div class="tooltip guide-TR">
										<span class="arrow top-hollow xl"><b></b><i></i></span>
										<div class="wrap" style=" height:;">
											<div class="bd">
												<h2>当前订单状态：交易完成</h2>
												<p>如果没有收到货，或收到货后出现问题，您可以联系卖家协商解决，或者去退货。</p>
											</div>
										</div>
									</div>
								</c:if>
								<c:if test="${order.orderStatus == '5' || order.orderStatus == '8' }">
<!-- 									<div class="logistics"> -->
<!-- 										<h2>物流信息</h2> -->
<!-- 										<dl> -->
<!-- 											<dt>物流公司：</dt> -->
<!-- 											<dd>顺丰快递</dd> -->
<!-- 										</dl> -->
<!-- 										<dl> -->
<!-- 											<dt>运单号码：</dt> -->
<!-- 											<dd>123654899513</dd> -->
<!-- 										</dl> -->
<!-- 										<dl> -->
<!-- 											<dt>物流跟踪：</dt> -->
<!-- 											<dd> -->
<!-- 												<ul> -->
<!-- 													<li class="on"><span>2015-02-01 16:25:30</span><span>浙江省杭州市宾员公司</span><span>已发出</span></li> -->
<!-- 													<li><span>2015-02-01 16:25:30</span><span>浙江省杭州市宾员公司</span><span>已发出</span></li> -->
<!-- 													<li><span>2015-02-01 16:25:30</span><span>浙江省杭州市宾员公司</span><span>已发出</span></li><li><span>2015-02-01 16:25:30</span><span>浙江省杭州市宾员公司</span><span>已发出</span></li><li><span>2015-02-01 16:25:30</span><span>卖家已发货</span></li> -->
<!-- 												</ul> -->
<!-- 											</dd> -->
<!-- 										</dl> -->
<!-- 									</div> -->
								</c:if>
							</div>
							<div class="orderMeg">
								<h2>订单信息</h2>
								<div class="getMeg">
									<ul>
										<li><b>收货信息：</b>
											<span>
												<c:out value="${order.userName } " /> 
												<c:choose>
													<c:when test="${not empty order.rMobile }">
														<c:out value="${order.rMobile } " />
													</c:when>
													<c:otherwise>
														<c:out value="${order.rPhone } " />
													</c:otherwise>
												</c:choose>
												<c:out value="${order.rProvince } "/>
												<c:out value="${order.rCity } "/>
												<c:out value="${order.rCounty } "/>
												<c:out value="${order.rTown } "/>
												<c:out value="${order.rAddr } "/>
											</span>
										</li>
										<li><b>订单编号：</b><span><c:out value="${order.orderCode }"/></span></li>
										<li>
											<p>成交时间：<span><fmt:formatDate value="${order.createdDate }" pattern="yyyy-MM-dd HH:mm:ss"/></span></p>
											<c:if test="">
												
											</c:if>
										</li>
									</ul>
								</div>
								<div class="buyerMeg">
									<h3>卖家信息</h3>
									<ul>
										<li>真实姓名：<span><c:out value="${seller.bizManName }"/></span></li>
										<li>联系电话：<span><c:out value="${seller.bizManMobile }"/></span></li>
										<li>QQ号码：<span><c:out value="${seller.bizManQq }" /></span></li>
										<li>电子邮箱：<span><c:out value="${seller.bizManEmail }" /></span></li>
									</ul>
								</div>
							</div>
							<div class="cartList-group merchBill">
							<div class="row head">
								<table>
								<tbody>
									<tr>
										<th width="10"></th>
										<th width="330">商品</th>
										<th width="150">规格</th>
										<th width="130">单元（元）</th>
										<th width="116">数量</th>
										<th width="130">成交价（元）</th>
										<th width="134">状态</th>
									</tr>
								</tbody>
							</table>
							</div>
							<c:forEach items="${order.orderItems }" var="orderItem">
								<div class="row">
									<table>
										<colgroup>
											<col width="10">
											<col width="330">
											<col width="150">
											<col width="130">
											<col width="116">
											<col width="130">
											<col width="134">
										</colgroup>
										<tbody>
											<tr>
												<td class="alloption"></td>
												<td>
													<dl class="mod-orderGoods">
														<dt>
															<a href="${ctx}/detail.action?bsdid=${orderItem.bsdId}" class="thumbnail"><img src="${my:random(imgGetUrl)}?rid=${orderItem.prodImg }&op=s0_w52_h52" alt=""></a>
														</dt>
														<dd>
															<p class="title"><a href="${ctx}/detail.action?bsdid=${orderItem.bsdId}"><c:out value="${orderItem.prodTitle}"/></a></p>
														</dd>
													</dl>
												</td>
												<td class="information">
													<div class="mod-goodsAttr">
														<div class="selectedAttr">
															<c:forEach items="${orderItems.specNames }" var="specName">
																<p><c:out value="${specName.key }"/>：<span><c:out value="${specName.value }"/></span></p>
															</c:forEach>
														</div>
													</div>
												</td>
												<td>
													<p class="nowPrice"><fmt:formatNumber value="${orderItem.transPrice }" type="currency"/></p>
												</td>
												<td><c:out value="${orderItem.number }"/></td>
												<td>
													<p class="subtotal"><fmt:formatNumber value="${orderItem.transPrice * orderItem.number}" type="currency" /></p>
												</td>
												<td>
													<c:if test="${order.orderStatus == '2' }"><p class="note">等待支付</p> </c:if>
													<c:if test="${order.orderStatus == '3' }"><p class="note">等待卖家发货</p> </c:if>
													<c:if test="${order.orderStatus == '4' }"><p class="note">交易关闭</p> </c:if>
													<c:if test="${order.orderStatus == '5' }"><p class="note">卖家已发货</p> </c:if>
													<c:if test="${order.orderStatus == '8' }">
														<c:if test="${orderItem.status == '1' }">
															<p class="note">交易完成</p>
															<p><a href="${ctx}/retOrder/retOrderApply.action?orderItemId=${orderItem.orderItemId}">退货</a></p>
														</c:if>
														<c:if test="${orderItem.status == '2' }">
															<p class="note">已退货</p> 
														</c:if>
													</c:if>
												</td>
											</tr>
										</tbody>
									</table>
								</div>
							</c:forEach>
							<div class="row">
								<table>
									<colgroup>
										<col width="1000">
									</colgroup>
									<tbody>
										<tr>
											<td colspan="7" class="storeTotal">
												<p>实付款：<span><fmt:formatNumber value="${order.orderFee}" type="currency" /></span></p>
											</td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>
						</div>
					</div>
				</div>
				<!-- orderDetail end -->
			</div>
		</div>
		<!-- container end -->
		<jsp:include page="/common/foot.html"></jsp:include>
	</div>
	<!-- pop -->
	<div class="popup popup-info pop-order cancel-order" style="display:none;">
		<div class="hd">
			<i class="close" onclick="closeCancelPop();"></i>
		</div>
		<div class="bd">
			<div class="order-cancel">
				<dl>
					<dt><i class="icon i-dangerXL"></i></dt>
					<dd>
						<h2>订单取消后不可恢复！</h2>
						<div>
							<select id="reason">
								<option value="0" class="placeholder">请选择订单取消原因</option>
								<option value="1">我不想买了</option>
								<option value="2">信息填写错误，重新去下单</option>
								<option value="3">卖家缺货</option>
								<option value="4">付款遇到问题（余额不足、不知道怎么支付等）</option>
								<option value="5">买错了</option>
								<option value="6">其他原因</option>
							</select>
						</div>
						<p><input id="cancel-confirm" type="button" class="btn btn-primary disabled" value="确 定"><a href="javascript:closeCancelPop();" class="btn btn-def">取 消</a></p>
					</dd>
				</dl>
			</div>
		</div>
	</div>
	<div class="popup popup-info pop-order confirm-order" style="display:none;">
		<div class="hd">
			<i class="close" onclick="closeConfirmPop();"></i>
		</div>
		<div class="bd">
			<div class="order-delivery">
				<dl>
					<dt><i class="icon i-dangerXL"></i></dt>
					<dd>
						<h2>请务必收到货后再点击"确认"按钮，否则可能会钱货两空！</h2>
						<p><input id="confirm-confirm" type="button" class="btn btn-primary" value="确 定"><a href="javascript:closeConfirmPop();" class="btn btn-def">取 消</a></p>
					</dd>
				</dl>
			</div>
		</div>
	</div>
	<!-- pop end -->
	<div class="mask" style="display:none;"></div>
</body>
</html>