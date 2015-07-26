<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@include file="/common/common.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<title>结算订单</title>
	<link rel="stylesheet" type="text/css" href="${cssDomain }/css/allstyle.css"/>
	<link rel="stylesheet" type="text/css" href="${cssDomain }/css/order.css"/>
	<script type="text/javascript">
		$(function(){
			showTradePrice();
		});
	</script>
</head>
<body>
	<div class="cartList-caption">
		<table>
			<caption><span><b>商品清单</b></span></caption>
			<tbody>
				<tr>
					<th width="434">商品</th>
					<th width="170">规格</th>
					<th width="140">单元（元）</th>
					<th width="116">数量</th>
					<th width="140">小计（元）</th>
				</tr>
			</tbody>
		</table>
	</div>
	
	<c:forEach items="${carts }" var="cart" varStatus="var">
		<!-- cartList group -->
		<div class="cartList-group merchBill">
			<div class="caption">
				<span>订单<c:out value="${var.count }"/>：<c:out value="${cart.brandShowTitle }" /></span>
			</div>
			<c:forEach items="${cart.cartItems}" var="cartItem">
				<div name="item" class="row">
					<table>
						<colgroup>
							<col width="34">
							<col width="400">
							<col width="170">
							<col width="140">
							<col width="116">
							<col width="140">
						</colgroup>
						<tbody>
							<tr>
								<td class="alloption"></td>
								<td>
									<dl class="mod-orderGoods">
										<dt>
											<a href="${ctx}/detail.action?bsdid=${cartItem.brandShowDetailId}" class="thumbnail"><img src="${my:random(imgGetUrl)}?rid=${cartItem.prodImgUrl }&op=s0_w52_h52" alt=""></a>
										</dt>
										<dd>
											<p class="title"><a href="${ctx}/detail.action?bsdid=${cartItem.brandShowDetailId}"><c:out value="${cartItem.prodName }"/></a></p>
										</dd>
									</dl>
								</td>
								<td class="information">
									<div class="mod-goodsAttr">
										<div class="selectedAttr">
											<c:forEach items="${cartItem.specs }" var="map">
												<c:forEach items="${map }" var="spec">
													<p><c:out value="${spec.key}"/>：<span><c:out value="${spec.value }"/></span></p>
												</c:forEach>
											</c:forEach>
										</div>
									</div>
								</td>
								<td>
									<p class="nowPrice"><fmt:formatNumber value="${cartItem.showPrice }" type="currency" /></p>
									<p class="price"><fmt:formatNumber value="${cartItem.maketPrice }" type="currency" /></p>
								</td>
								<td><c:out value="${cartItem.num }"/></td>
								<td>
									<p class="subtotal"><fmt:formatNumber value="${cartItem.showPrice * cartItem.num }" type="currency" /></p>
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
							<td colspan="1" class="storeTotal">
								<p><span>快递费：0.00元</span><span name="storeTotal">此订单合计：714.00元</span></p>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
		<!-- cartList group end -->
	</c:forEach>
</body>
</html>