<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@include file="/common/common.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<title>购物车</title>
	<link rel="stylesheet" type="text/css" href="${cssDomain }/css/allstyle.css"/>
	<link rel="stylesheet" type="text/css" href="${cssDomain }/css/order.css"/>
	<script type="text/javascript">
		$(function(){
			initContent();
			if("${isEmpty}" == "true"){
				$("div.mask").removeClass("hidden");
				$("div.pop-order").removeClass("hidden");
				$("div.pop-order div.bd dd h2").text("您还没有选择商品，请选择您要结算的商品!");
			} else if("${hasError}" == "true"){
				$("div.mask").removeClass("hidden");
				$("div.pop-order").removeClass("hidden");
				$("div.pop-order div.bd dd h2").text("抱歉，您购物车中的部分商品已经失效或者缺货，请结算其他商品!");
			} else {
				$("div.mask").addClass("hidden");
				$("div.pop-order").addClass("hidden");
			}
			$(document).on("click","div.pop-order div.hd i.close",function(){
				$("div.mask").addClass("hidden");
				$("div.pop-order").addClass("hidden");
			});
		});
	</script>
</head>
<body>
	<c:choose>
		<c:when test="${carts == null || fn:length(carts) == 0 }">
			<script type="text/javascript">
// 				$("#footer").addClass("fixed");
			</script>
			<!-- orderState -->
			<div class="orderState">
				<!-- cart null -->
				<dl class="cartNull">
					<dt><img src="${imgDomain }/person.png" alt="" /></dt>
					<dd>
						<h3>购物车很空很伤心<br />主人，快点填充我空虚的内心吧...</h3>
						<p><a href="http://www.hehefang.com">去首页逛逛 <em>&gt;</em></a></p>
					</dd>
				</dl>
			</div>
			<!-- orderState end -->
		</c:when>
		<c:otherwise>
			<div class="cartList-caption">
				<table>
					<tr>
						<td width="80" class="alloption"><label><input name="allChecked" type="checkbox" class="chk" />全选</label></td>
						<td width="294">商品</td>
						<td width="170">规格</td>
						<td width="113">单元（元）</td>
						<td width="130">数量</td>
						<td width="113">小计（元）</td>
						<td width="100" class="last">操作</td>
					</tr>
				</table>
			</div>
			<c:forEach items="${carts }" var="cart" varStatus="var">
				<div class="cartList-group" name="order">
					<div class="caption">
						<input name="order" type="checkbox" class="chk" /><span>订单${var.count }：<c:out value="${cart.brandShowTitle }" /></span>
					</div>
					<c:forEach items="${cart.cartItems }" var="cartItem">
						<div class="${(cartItem.statusCode == 0 || cartItem.statusCode == -8 || cartItem.statusCode == -9) ? 'row' : 'row unusual'}">
							<c:if test="${cartItem.statusCode != 0 && cartItem.statusCode != -8 && cartItem.statusCode != -9}">
								<div class="mask"></div>
								<div class="shixiao"><img src="${imgDomain }/shixiao.png" alt=""></div>
							</c:if>
							<table>
								<colgroup>
									<col width="34" />
									<col width="340" />
									<col width="170" />
									<col width="113" />
									<col width="130" />
									<col width="113" />
									<col width="100" />
								</colgroup>
								<tbody>
									<tr class="${(cartItem.statusCode == 0 || cartItem.statusCode == -8 || cartItem.statusCode == -9) ? '' : 'eom'}">
										<td class="alloption">
											<c:choose>
												<c:when test="${cartItem.statusCode == 0 || cartItem.statusCode == -8 || cartItem.statusCode == -9}">
													<input name="item" type="checkbox" class="chk" bsDetailId="${cartItem.brandShowDetailId }" ${cartItem.selected ? 'checked' : '' }/>
												</c:when>
												<c:when test="${cartItem.statusCode != 0 && cartItem.statusCode != -8 && cartItem.statusCode != -9}">
													<input readonly="readonly" name="item" type="checkbox" class="chk" bsDetailId="${cartItem.brandShowDetailId }" ${cartItem.selected ? 'checked' : '' }/>
												</c:when>
											</c:choose>
											
										</td>
										<td>
											<dl class="mod-orderGoods">
												<dt>
													<a href="${ctx}/detail.action?bsdid=${cartItem.brandShowDetailId}" class="thumbnail" target="_blank"><img src="${my:random(imgGetUrl)}?rid=${cartItem.prodImgUrl }&op=s0_w52_h52" alt="" /></a>
												</dt>
												<dd>
													<p class="title"><a href="${ctx}/detail.action?bsdid=${cartItem.brandShowDetailId}" target="_blank"><c:out value="${cartItem.prodName }"/></a></p>
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
											<p class="nowPrice" bsDetailId="${cartItem.brandShowDetailId }"><fmt:formatNumber value="${cartItem.showPrice }" minFractionDigits="2" /></p>
											<p class="price"><fmt:formatNumber value="${cartItem.maketPrice }" minFractionDigits="2" /></p>
										</td>
										<td>
											<div class="mod-modified">
												<div class="minus ${cartItem.num <= 1 ? 'disabled' : '' }">-</div>
												<input type="text" class="txt sm" value="${cartItem.num }" bsDetailId="${cartItem.brandShowDetailId }" />
												<input type="hidden" class="oldNum" value="${cartItem.num }" />
												<div class="plus">+</div>
											</div>
											<div class="note numWarn">
												<c:if test="${cartItem.statusCode == -8 }">
													<span>仅剩<c:out value="${cartItem.stock }"/>件</span>
												</c:if>
												<c:if test="${cartItem.statusCode == -9 }">
													<span>限购<c:out value="${cartItem.purchaseCountLimit }"/>件</span>
												</c:if>
											</div>
										</td>
										<td>
											<p bsDetailId="${cartItem.brandShowDetailId }" class="subtotal"><c:out value="${cartItem.showPrice * cartItem.num }"/></p>
										</td>
										<td class="operate">
											<p><a href="#" name="delete" bsDetailId="${cartItem.brandShowDetailId }">删除</a></p>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
					</c:forEach>
				</div>
			</c:forEach>
			<div class="cartList-group orderClosing">
				<div class="orderSubmit">
					<div class="submit-box">
						<div class="func"><label><input type="checkbox" name="allChecked" class="chk">全选</label><span id="delAll">删除</span><span id="clear">消除失效商品</span></div>
					<a href="javascript:void(0)" class="btn btn-assist submitBtn">结&nbsp;算</a>
						<div class="priceTotal">总计：<span>¥<em id="priceTotal">1592.00</em></span>元 （全场包邮）</div>
						<div class="thum">
							<p class="whole">已选商品<em id="countTotal">3</em>件</p>
						</div>
					</div>
				</div>
			</div>
		</c:otherwise>
	</c:choose>
	<div class="popup popup-info pop-order hidden" style="width: 800px;margin-left: -400px">
		<div class="hd">
			<i class="close"></i>
		</div>
		<div class="bd">
			<div class="order-delivery">
				<dl>
					<dt><i class="icon i-dangerXL"></i></dt>
					<dd>
						<h2 style="width: 510px;">订单中的部分商品已经失效或者缺货，本次交易无法正常继续。</h2>
					</dd>
				</dl>
			</div>
		</div>
	</div>
	<div class="mask hidden"></div>
</body>
</html>