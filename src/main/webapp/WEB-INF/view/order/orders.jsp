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
	<link rel="stylesheet" type="text/css" href="${cssDomain }/css/member.css"/>
	<title>我的订单</title>
	<script type="text/javascript">
		$(function(){
			setInterval("payRestTime()",1000);
			popupFix();
			$(window).scroll(popupFix);
			$(window).resize(popupFix);

			$(document).on("change","#reason",function(){
				if('0' == $(this).val()) {
					$("#cancel-confirm").addClass("disabled");
				} else {
					$("#cancel-confirm").removeClass("disabled");
				}
			});
			$(document).on("click","#cancel-confirm",function(){
				var orderId = $(this).attr("orderId");
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
				var orderId = $(this).attr("orderId");
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
			$(document).on("click","#delete-confirm",function(){
				var orderId = $(this).attr("orderId");
				$.post(
					"${ctx}/user/deleteOrder.action",
					{orderId:orderId},
					function(res){
						closedeletePop();
						if(res == -1) {
							gotoLogin();
						}else if (res <= 0){
							alert("删除订单失败，请重试！");
						} else {
							reload();
						}
					}
				);
			});
		});
		function cancelOrder(orderId) {
			$("div.mask").show();
			$("div.cancel-order").show();
			$("#reason").val("0");
			$("#cancel-confirm").attr("orderId",orderId);
		}
		function confirmOrder(orderId) {
			$("div.mask").show();
			$("div.confirm-order").show();
			$("#confirm-confirm").attr("orderId",orderId);
		}
		function deleteOrder(orderId){
			$("div.mask").show();
			$("div.delete-order").show();
			$("#delete-confirm").attr("orderId",orderId);
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
		function closedeletePop() {
			$("div.mask").hide();
			$("div.pop-order").hide();
			$("#delete-confirm").attr("orderId","");
		}
		function reload() {
			location.href = "${ctx}/user/orders.action?status=${status}";
		}
		function gotoLogin() {
			location.href = "${ctx}/login.action?rtnUrl=${ctx}/user/orders.action?status=${status}";
		}
		
		function payRestTime(){
			$("span.payRestTime").each(function(){
				var restTime = $(this).siblings("input[type=hidden]").val() - 1;
				if(restTime < 0) {
					restTime = 0;
				}
				$(this).siblings("input[type=hidden]").val(restTime);
				var h = parseInt(restTime / 3600);
				restTime = parseInt(restTime % 3600);
				var m = parseInt(restTime / 60);
				var s = parseInt(restTime % 60);
				var text = ""+h+":"+m+":"+s+"后订单失败";
				$(this).html(text);
			});
		}
		function popupFix(){
			var scrollTop = $(document).scrollTop();
			var scrollLeft = $(document).scrollLeft();
			var screenHeight = $(window).height();
			var screenWidth = $(window).width();
			$("div.popup").each(function(){
				var height = $(this).height();
				var width = $(this).width();
				var top = scrollTop+(screenHeight-height)/2;
				var left = scrollLeft+(screenWidth-width)/2;
				$(this).css("top",top>scrollTop ? top : scrollTop);
				$(this).css("left",left>scrollLeft ? left : scrollLeft);
				$(this).css("margin-left", 0);
				$(this).css("margin-top", 0);
			});
		}
	</script>
</head>
<body>
	<div class="wrapper">
		<jsp:include page="/common/head.jsp"></jsp:include>
		<!-- container -->
		<div id="container">
			<div class="wrap">
				<!-- breadnav -->
				<div class="breadnav">
					<span class="index"><a href="">首页</a></span>
					<ul class="nav">
						<li><span>&gt;</span><a href="${ctx}/user/userCenter.action">我的禾合坊</a></li>
						<li><span>&gt;</span><a href="">我的订单</a></li>
					</ul>
				</div>
				<!-- breadnav end -->
				<!-- memberCenter -->
				<div class="memberCenter">
					<!-- memb-sidebar -->
					<jsp:include page="/common/left.jsp"></jsp:include>
					<!-- memb-sidebar end-->
					<!-- main -->
					<div class="memb-main">
						<div class="memg-bd">
							<div class="myorder-hd">
								<table>
									<caption>
										<ul>
											<li><a href="${ctx}/user/orders.action">全部订单(<span class="warnColor"><c:out value="${allCount }"/></span>)</a></li>
											<li><a href="${ctx}/user/orders.action?status=2">待支付订单(<span class="warnColor"><c:out value="${waitPayCount }"/></span>)</a></li>
											<li><a href="${ctx}/user/orders.action?status=3">待确认收货(<span class="warnColor"><c:out value="${waitDeliveredCount }"/></span>)</a></li>
										</ul>
									</caption>
									<tbody>
										<tr>
											<th width="300">商品</th>
											<th width="110">单价（元）</th>
											<th width="110">数量</th>
											<th width="110">小计（元）</th>
											<th width="90">状态</th>
											<th width="120">操作</th>
										</tr>
									</tbody>
								</table>
							</div>
							<div class="myorder-bd">
								<c:choose>
									<c:when test="${empty orders || fn:length(orders.result) == 0 }">
										<div class="orderListnull">
											<table>
												<colgroup>
													<col width="300">
													<col width="110">
													<col width="110">
													<col width="110">
													<col width="90">
													<col width="120">
												</colgroup>
												<tbody>
													<tr>
													 	<td colspan="6">您还没有任何当前状态的订单呦~</td>
													</tr>
												</tbody>
											</table>
										</div>
									</c:when>
									<c:otherwise>
										<c:forEach items="${orders.result }" var="order">
											<div class="orderList">
												<table>
													<colgroup>
														<col width="300">
														<col width="110">
														<col width="110">
														<col width="110">
														<col width="90">
														<col width="120">
													</colgroup>
													<thead>
														<tr>
															<th colspan="6">
																<input type="hidden" value="${order.payRestTime }"/>
																<c:if test="${order.orderStatus == '2' and order.payRestTime > 0 }">
																	<p class="warnColor">
																		<input type="hidden" value="${order.payRestTime }"/>
																		<span class="payRestTime"></span>
																	</p>
																</c:if>
																<p><span>订单编号：<c:out value="${order.orderCode}"/></span>
																	<span>提交订单时间：<fmt:formatDate value="${order.createdDate }" pattern="yyyy-MM-dd HH:mm:ss"/></span>
																	<span><c:out value="${order.brandShowTitle }" /></span></p>
															</th>
														</tr>
													</thead>
													<tbody>
														<c:forEach items="${order.orderItems }" var="orderItem" varStatus="var">
															<tr>
																<td>
																	<dl class="mod-orderGoods">
																		<dt>
																			<a href="${ctx}/detail.action?bsdid=${orderItem.bsdId}" class="thumbnail" target="_blank"><img src="${my:random(imgGetUrl)}?rid=${orderItem.prodImg }&op=s0_w52_h52" alt=""></a>
																		</dt>
																		<dd>
																			<p class="title"><a href="${ctx}/detail.action?bsdid=${orderItem.bsdId}" target="_blank"><c:out value="${orderItem.prodTitle }"></c:out></a></p><p class="property"><span>颜色分类：军绿色</span><span>尺码：XL（175/...</span></p>
																		</dd>
																	</dl>
																</td>
																<td><p class="price"><fmt:formatNumber value="${orderItem.transPrice }" type="currency"/></p></td>
																<td class="goodsnum">
																	<span class="nums"><c:out value="${orderItem.number }" /></span>
																	<c:if test="${order.orderStatus == '8' }">
																		<c:if test="${orderItem.status == '1' }">
																			<span><a href="${ctx}/retOrder/retOrderApply.action?orderItemId=${orderItem.orderItemId}">退货</a></span>
																		</c:if>
																		<c:if test="${orderItem.status == '2' }">
																			<span class="lightColor">已退货</span> 
																		</c:if>
																	</c:if>
																</td>
																<c:if test="${var.first }">
																	<td rowspan="${fn:length(order.orderItems) }" class="border-l"><p class="nowPrice"><fmt:formatNumber value="${order.orderFee }" type="currency"/></p></td>
																	<td rowspan="${fn:length(order.orderItems) }" class="border-l">
																		<c:if test="${order.orderStatus == '1' }"><p class="warnColor">待处理</p> </c:if>
																		<c:if test="${order.orderStatus == '2' }"><p class="warnColor">待支付</p> </c:if>
																		<c:if test="${order.orderStatus == '3' }"><p class="">等待卖家发货</p> </c:if>
																		<c:if test="${order.orderStatus == '4' }"><p class="lightColor">交易关闭</p> </c:if>
																		<c:if test="${order.orderStatus == '5' }"><p class="">卖家已发货</p> </c:if>
																		<c:if test="${order.orderStatus == '8' }"><p class="lightColor">交易完成</p> </c:if>
																		<p><a orderid="${order.orderId }" href="${ctx}/user/orderDetail.action?orderId=${order.orderId}">订单详情</a></p>
																	</td>
																	<td rowspan="${fn:length(order.orderItems) }" class="border-l">
																		<c:if test="${order.orderStatus == '2' }">
																			<p><input onclick="location.href='${ctx}/user/payment.action?orderId=${order.orderId}'" type="button" value="去支付" class="btn btn-assist"></p> 
																			<p><a href="javascript:;" onclick="cancelOrder(${order.orderId })">取消订单</a></p>
																		</c:if>
																		<c:if test="${order.orderStatus == '3' }">
																		</c:if>
																		<c:if test="${order.orderStatus == '5' }">
																			<p><input type="button" value="确认收货" class="btn btn-primary" onclick="confirmOrder(${order.orderId})"></p>
																			<p><a href="javascript:;">物流信息</a></p>
																		</c:if>
																		<c:if test="${order.orderStatus == '4' || order.orderStatus == '8' }">
																			<p><a href="javascript:;" onclick="deleteOrder(${order.orderId})">删除订单</a></p>
																		</c:if>
																	</td>
																</c:if>
															</tr>
														</c:forEach>
													</tbody>
												</table>
											</div>
										</c:forEach>
									</c:otherwise>
								</c:choose>
							</div>
							<div class="pagingGroup">
								<!-- paging -->
								<form id="form" action="${ctx}/user/orders.action?status=${status}" method="post">
								<pg:page name="orders" page="${orders}" formId="form"></pg:page>
								</form>
								<!-- paging end -->
							</div>
						</div>
					</div>
					<!-- main end-->
				</div>
				<!-- memberCenter end-->
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
	<div class="popup popup-info pop-order delete-order" style="display:none;">
		<div class="hd">
			<i class="close" onclick="closedeletePop();"></i>
		</div>
		<div class="bd">
			<div class="order-cancel">
				<dl>
					<dt><i class="icon i-dangerXL"></i></dt>
					<dd>
						<h2>是否确定要删除订单？</h2>
						<p><input id="delete-confirm" type="button" class="btn btn-primary" value="确 定"><a href="javascript:closedeletePop();" class="btn btn-def">取 消</a></p>
					</dd>
				</dl>
			</div>
		</div>
	</div>
	<!-- pop end -->
	<div class="mask" style="display:none;"></div>
</body>
</html>