<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ include file="/common/common.jsp"%>
<html lang="zh-cn">
<head>
<meta charset="utf-8">
<title>个人中心-退货管理</title>
<link rel="stylesheet" type="text/css" href="${cssDomain}/css/allstyle.css" />
<link rel="stylesheet" type="text/css" href="${cssDomain}/css/member.css" />
<script type="text/javascript" src="${jsDomain}/jquery.min.js"></script>
<script type="text/javascript">
	$(function(){
		$(document).on("click","input[name=cancel]",function(){
			var retOrderId = $(this).attr("retOrderId");
			$("#confirm").attr("retOrderId",retOrderId);
			$("#mask").removeClass("hide");
			$("#pop").removeClass("hide");
		});
		
		$(document).on("click","#close",close);
		$(document).on("click","#closePop",close);
		
		$(document).on("click","#confirm",function(){
			var retOrderId = $(this).attr("retOrderId");
			if(!retOrderId){
				return false;
			}
			$.getJSON("${ctx}/retOrder/cancelRetOrder.action",
				{retOrderId:retOrderId},
				function(json){
					location.href = "${ctx}/retOrder/myRetOrders.action";
				}
			);
		});
	});
	
	function close(){
		$("#confirm").attr("retOrderId",'');
		$("#mask").addClass("hide");
		$("#pop").addClass("hide");
	}
</script>
</head>
<body class="" id="shopCart">
	<div class="wrapper">
		<!-- topbar -->
		<jsp:include page="/common/head.jsp" />
		<!-- topbar end -->
		<!-- container -->
		<div id="container">
			<div class="wrap">
				<!-- breadnav -->
				<div class="breadnav">
					<span class="index"><a href="http://www.hehefang.com">首页</a></span>
					<ul class="nav">
						<li><span>&gt;</span><a href="${ctx}/user/userInfo.action">我的禾合坊</a></li>
						<li><span>&gt;</span><a href="${ctx}/retOrder/myRetOrders.action">退货单</a></li>
					</ul>
				</div>
				<!-- breadnav end -->
				<!-- memberCenter -->
				<div class="memberCenter">
					<!-- memb-sidebar -->
					<jsp:include page="/common/left.jsp" />
					<!-- memb-sidebar end-->
					<!-- main -->
					<div class="memb-main">
						<div class="memg-bd">
							<div class="myorder-hd">
								<table>
									<tbody>
										<tr>
											<th width="180">退货单信息</th>
											<th width="480">商品信息</th>
											<th width="180">卖家信息</th>
										</tr>
									</tbody>
								</table>
							</div>
							<c:choose>
								<c:when test="${!empty(retOrders)}">
									<div class="myorder-bd">
										<c:forEach items="${retOrders}" var="retOrder">
											<div class="salereturnList">
												<table>
													<colgroup>
														<col width="200">
														<col width="440">
														<col width="200">
													</colgroup>
													<thead>
														<tr>
															<th colspan="3"><span>退货单编号：${retOrder.retOrderId}</span>
																<span>申请时间：<fmt:formatDate
																		value="${retOrder.createDate}"
																		pattern="yyyy-MM-dd HH:mm:ss" /></span></th>
														</tr>
													</thead>
													<tbody>
														<tr>
															<td>
																<p>
																	<strong>状态：<c:out value="${retOrder.strStatus}" /></strong>
																</p>
																<p> <c:set value="${retOrder.retOrderItems[0].retFee}" var="p" />
																    <c:set value="${retOrder.retOrderItems[0].returnNumber}" var="n" />
																	退款金额：<span class="errTxt"><fmt:formatNumber
																			pattern="0.00"
																			value="${n*p}" />元</span>
																</p>
																<c:if test="${retOrder.status == '1'}">
																	<p>
																		<input retOrderId="${retOrder.retOrderId}" name="cancel" type="button" value="取消申请" class="btn btn-primary" />
																	</p>
																</c:if>
																<p>
																	<a target="_blank" href="${ctx}/retOrder/myRetDetail.action?myRetId=${retOrder.retOrderId}">查看详情</a>
																</p>
															</td>
															<td class="salemeg">
																<p class="ordernum">
																	订单编号：<a href="#">${retOrder.orderId}</a>
																</p> 
																<c:forEach items="${retOrder.retOrderItems}" var="retOrderItem">
																	<div>
																		<dl class="mod-orderGoods">
																			<dt>
																				<a href="javascript:;" class="thumbnail">
																					<img src="${imgUrl}?rid=${retOrderItem.sku.skuImgUrl}&op=s1_w50_h50_e1-c3_w50_h50" alt="">
																				</a>
																			</dt>
																			<dd>
																				<p class="title">
																					<a href="javascript:;"><c:out value="${retOrderItem.sku.product.title}" /></a>
																				</p>
																			</dd>
																		</dl>
																		<span>${retOrderItem.returnNumber}</span> <span><fmt:formatNumber pattern="￥0.00" value="${retOrderItem.retFee}" /></span>
																	</div>
																</c:forEach>
															</td>
															<td>
																<ul>
																	<li><p>卖家姓名：<c:out value="${retOrder.seller.bizManName}" /></p></li>
																	<li><p>联系电话：<c:out value="${retOrder.seller.tel}" /></p></li>
																	<li><p>QQ号码：<c:out value="${retOrder.seller.bizManQq}" /></p></li>
																</ul>
															</td>
														</tr>
													</tbody>
												</table>
											</div>
										</c:forEach>
									</div>
									<div class="pagingGroup">
										<!-- paging -->
										<form id="form" action="${ctx}/retOrder/myRetOrders.action" method="post">
										<pg:page name="retOrder" page="${page}" formId="form"></pg:page>
										</form>
										<!-- paging end -->
									</div>
								</c:when>
								<c:otherwise>
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
												 	<td colspan="6">您还没有退货单呦~</td>
												</tr>
											</tbody>
										</table>
									</div>
								</c:otherwise>
							</c:choose>
						</div>
					</div>
					<!-- main end-->
				</div>
				<!-- memberCenter end-->
			</div>
		</div>
		<!-- container end -->
		<!-- footer -->
		<jsp:include page="/common/foot.html" />
		<!-- footer end -->
	</div>
	<div id="pop" class="popup popup-info pop-order hide">
			<div class="hd">
				<i id="close" class="close"></i>
			</div>
			<div class="bd">
				<div class="order-cancel">
					<dl>
						<dt><i class="icon i-dangerXL"></i></dt>
						<dd>
							<h2>是否确认取消退货？</h2>
							<p><input type="button" id="confirm" class="btn btn-primary" value="确认取消"><a href="javascript:void(0)" id="closePop" class="btn btn-def">取 消</a></p>
						</dd>
					</dl>
				</div>
			</div>
		</div>
	<div id="mask" class="mask hide"></div>
</body>
</html>
