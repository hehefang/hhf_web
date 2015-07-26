<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/common/common.jsp"%>
<html lang="zh-cn">
<head>
	<meta charset="utf-8">
	<title>个人中心-退货详情</title>
	<link rel="stylesheet" type="text/css" href="${cssDomain}/css/allstyle.css"/>
	<link rel="stylesheet" type="text/css" href="${cssDomain}/css/member.css"/>
	<link rel="stylesheet" type="text/css" href="${cssDomain}/css/order.css"/>
	<script type="text/javascript" src="${jsDomain}/jquery.min.js"></script>
</head>
<body class="">
	<div class="wrapper">
    <jsp:include page="/common/head.jsp" />		
		<!-- container -->
		<div id="container">
			<div class="wrap">
				<!-- salesDetail -->
				<div class="salesDetail">
					<div class="hd">
						<div class="breadnav">
							<span class="index"><a href="">首页</a></span>
							<ul class="nav">
								<li><span>&gt;</span><a href="${ctx}/user/userCenter.action">我的禾合坊</a></li>
								<li><span>&gt;</span><a href="">取消退货</a></li>
							</ul>
						</div>
					</div>
					<div class="bd">
						<div class="orderFlow">
							<div class="orderFlow-process">
								<div class="wrap order-close">
										<div class="bd">
											<h2>当前退货单状态：已取消</h2>
											<p>关闭类型：买家取消订单</p>
										</div>
								</div>
							</div>
							<div class="orderMeg">
								<h2>退货单信息</h2>
								<div class="">
									<ul>
										<li><b>退货单号：</b><span><c:out value="${returnOrder.retOrderCode}"/></span></li>
										<li>
											<p>申请时间：<span><fmt:formatDate value="${returnOrder.createDate}" pattern="yyyy-MM-dd HH:mm"/></span></p>
										</li>
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
								<div class="row first">
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
														<a href="${ctx}/detail.action?bsdid=${orderItem.bsdId}" class="thumbnail"><img src="${my:random(imgGetUrl)}?rid=<c:out value="${sku.skuImgUrl})"/>&op=s0_w52_h52" alt=""></a>
													</dt>
													<dd>
														<p class="title"><a href="${ctx}/detail.action?bsdid=${orderItem.bsdId}"><c:out value="${prod.title}"/></a></p>
													</dd>
												</dl>
											</td>
											<td class="information">
												<div class="mod-goodsAttr">
													<div class="selectedAttr">
													${specHtml}
													</div>
												</div>
											</td>
											<td>
												<p class="nowPrice">¥<fmt:formatNumber value="${orderItem.salePrice}" pattern="0.00" /></p>
											</td>
											<td><c:out value="${orderItem.number}"/></td>
											<td>
												<p class="subtotal">¥<fmt:formatNumber value="${orderItem.transPrice}" pattern="0.00" /></p>
											</td>
										</tr>
									</tbody>
								</table>
								</div>
							</div>
							<div class="salerturnDetail">
								<dl>
									<dt><b>退货订单：</b></dt>
									<dd><p><a href="#"><c:out value="${returnOrder.orderId}"/></a></p></dd>
								</dl>
								<dl>
									<dt><b>退货原因：</b></dt>
									<dd><p><c:out value="${returnOrder.returnReason}"/></p></dd>
								</dl>
								<dl>
									<dt>退货说明：</dt>
									<dd>
										<p><c:out value="${returnOrder.remarks}"/></p>
										<div class="uploadImg">
											<ul>
											<c:set value="${fn:split(returnOrder.evidencePicUrl, ',') }" var="imgs" />
											<c:forEach items="${imgs}" var="img" varStatus="status">
												<li>
													<a href="#"><img src="${my:random(imgGetUrl)}?rid=<c:out value="${img}"/>&op=s0_w78_h78" alt=""></a>
												</li>
											</c:forEach>	
											</ul>
										</div>
									</dd>
								</dl>
							</div>
						</div>
					</div>
				</div>
				<!-- salesDetail end -->
			</div>
		</div>
		<!-- container end -->
		<!-- footer -->
		<jsp:include page="/common/foot.html" />
		<!-- footer end -->
	</div>
</body>
</html>
