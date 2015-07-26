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
							<span class="index"><a href="http://www.hehefang.com">首页</a></span>
							<ul class="nav">
								<li><span>&gt;</span><a href="${ctx}/user/userCenter.action">我的禾合坊</a></li>
								<li><span>&gt;</span><a href="${ctx}/retOrder/myRetDetail.action">退货详情</a></li>
							</ul>
						</div>
					</div>
					<div class="bd">
						<div class="orderFlow">
							<div class="orderFlow-process">
								<ul class="train-nav train-nav1">
									<li class="first-child on"><i class="head"></i><a href="#">1、退货申请</a><em class="follow">2013-12-12&nbsp;23:32:30</em></li>
									<li <c:if test="${returnOrder.status=='2'||returnOrder.status=='3'||returnOrder.status=='4'}">class="on"</c:if>><i class="head"></i><i class="end"></i><a href="">2、卖家受理</a></li>
									<li <c:if test="${returnOrder.status=='3'||returnOrder.status=='4'}">class="on"</c:if>><i class="head"></i><i class="end"></i><a href="">3、卖家确认</a></li>
									<li <c:if test="${returnOrder.status=='4'}">class="on"</c:if> class="last-child"><i class="end"></i><a href="">4、退款到账</a></li>
								</ul>
							
								<div class="tooltip guide-TL">
									<span class="arrow top-hollow xl"><b></b><i></i></span>
									<div class="wrap" style=" height:;">
										<div class="bd">
											<h2>当前退货单状态：<c:if test="${returnOrder.status=='-1'}">驳回</c:if>
											                   <c:if test="${returnOrder.status=='0'}">已取消</c:if>
											                   <c:if test="${returnOrder.status=='1'}">等待卖家处理 </c:if>
											                   <c:if test="${returnOrder.status=='2'}">卖家已受理 </c:if>
											                   <c:if test="${returnOrder.status=='3'}">卖家已确认 </c:if>
											                   <c:if test="${returnOrder.status=='4'}">卖家已退款 </c:if>
											</h2>
											<c:if test="${returnOrder.status=='0'}">										
											<p>关闭类型：买家取消订单</p>
											</c:if>
											<c:if test="${returnOrder.status=='-1'}">
											<p>关闭类型：卖家驳回</p>
											</c:if>
											<c:if test="${returnOrder.status=='2'}">
											<div class="selleraccept">
												<p class="errTxt">请将退货商品自行寄回以下地址：</p>
												<c:if test="${!empty retAddress}">
												<dl>
													<dt>详细地址：</dt>
													<dd><p><c:out value="retAddress.provinceName"/><c:out value="retAddress.cityName"/><c:out value="retAddress.districtName"/><c:out value="retAddress.townName"/><c:out value="retAddress.addr"/></p></dd>
												</dl>
												<dl>
													<dt>邮政编码：</dt>
													<dd><p><c:out value="retAddress.zipCode"/></p></dd>
												</dl>
												<dl>
													<dt>收件人：</dt>
													<dd><p><c:out value="retAddress.receiver"/></p></dd>
												</dl>
												<dl>
													<dt>联系电话：</dt>
													<dd><p><c:out value="retAddress.mobile"/></p></dd>
												</dl>
												</c:if>
											</div>
											</c:if>
											<c:if test="${returnOrder.status=='3'}">
											<div class="selleraccept true">
												<dl>
													<dt><i class="icon i-danger"></i></dt>
													<dd>
														<h2>卖家已经确认收到寄回的商品，系统将在48小时内自动将款项退回您支付时所用的账户里。</h2>
													</dd>
												</dl>
											</div>
											</c:if>
											<c:if test="${returnOrder.status=='3'}">
											<div class="selleraccept true">
												<dl>
													<dt><i class="icon i-right"></i></dt>
													<dd>
														<h2>系统已经将 <span class="errTxt"><fmt:formatNumber value="${retOrderItem.retFee}" pattern="0.00" /></span> 退回至您支付时的支付宝账户，或者银行卡中。</h2>
													</dd>
												</dl>
											</div>
											</c:if>
											<div class="waitseller <c:if test="${returnOrder.status=='2'||returnOrder.status=='3'||returnOrder.status=='4'}">waitsellers</c:if>">
												<h3>卖家信息</h3>
												<ul>
													<li>联系电话：<c:out value="${brandShow.serviceTel}"/></li>
													<li>QQ号码：<c:out value="${brandShow.serviceQq}"/></li>
												</ul>
											</div>
											<c:if test="${returnOrder.status== '1'}">
											<p class="errTxt">您可以直接联系卖家协商退货事宜，节省退货时间，推进退货进程。</p>
											<div class="btnGro">
												<a href="${ctx}/retOrder/cancelRetOrder1.action?myRetId=${returnOrder.retOrderId}" class="btn btn-primary">取消申请</a>
											</div>
											</c:if>
										</div>
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
											<p>受理时间：<span><c:if test="${!empty returnOrder.auditDate}"><fmt:formatDate value="${$returnOrder.auditDate}" pattern="yyyy-MM-dd HH:mm"/></c:if></span></p>
											<p>确认时间：<span><c:if test="${!empty returnOrder.confirmDate}"><fmt:formatDate value="${returnOrder.confirmDate}" pattern="yyyy-MM-dd HH:mm"/></c:if></span></p>
											<p>退款时间：<span><c:if test="${!empty returnOrder.refundDate}"><fmt:formatDate value="${returnOrder.refundDate}" pattern="yyyy-MM-dd HH:mm"/></c:if></span></p>
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
											<th width="130">单价（元）</th>
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
														<a href="${ctx}/detail.action?bsdid=${orderItem.bsdId}" class="thumbnail"><img src="${my:random(imgGetUrl)}?rid=<c:out value="${sku.skuImgUrl}"/>&op=s0_w52_h52" alt=""></a>
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
											<td>
											<p class="note">
											                   <c:if test="${returnOrder.status=='-1'}">驳回</c:if>
											                   <c:if test="${returnOrder.status=='0'}">已取消</c:if>
												               <c:if test="${returnOrder.status=='1'}">等待卖家处理 </c:if>
											                   <c:if test="${returnOrder.status=='2'}">卖家已受理 </c:if>
											                   <c:if test="${returnOrder.status=='3'}">卖家已确认 </c:if>
											                   <c:if test="${returnOrder.status=='4'}">卖家已退款 </c:if>
											</p>                   
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
											<c:set value="${ fn:split(returnOrder.evidencePicUrl, ',') }" var="imgs" />
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
