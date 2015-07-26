<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ include file="/common/common.jsp"%>
<html lang="zh-cn">
<head>
<meta charset="utf-8">
<title>个人中心-个人资料</title>
<link rel="stylesheet" type="text/css" href="${cssDomain}/css/allstyle.css" />
<link rel="stylesheet" type="text/css" href="${cssDomain}/css/member.css" />
<script type="text/javascript" src="${jsDomain}/jquery.min.js"></script>
<script type="text/javascript" src="${jsDomain}/datePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${jsDomain}/uploadify/jquery.uploadify.js"></script>
<script type="text/javascript">
</script>
</head>
<body class="" id="shopCart">
	<div class="wrapper">
		<!-- topbar -->
		<jsp:include page="/common/head.jsp" />
		<!-- topbar end -->
		<!-- container -->
		<!-- container -->
		<div id="container">
			<div class="wrap">
				<!-- breadnav -->
				<div class="breadnav">
					<span class="index"><a href="">首页</a></span>
					<ul class="nav">
						<li><span>&gt;</span><a href="${ctx}/user/userCenter.action">我的禾合坊</a></li>
						<li><span>&gt;</span><a href="${ctx}/user/userCenter.action">个人中心</a></li>
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
							<div class="buyerInfo">
								<div class="info-main">
									<dl>
										<dt>
										<c:choose>
										<c:when test="${empty(user.userExt.headerPic)}">
													<img name="file" src="${imgDomain}/temp/memb-img.jpg" alt="" />
												</c:when>
												<c:otherwise>
													<img name="file" onerror="this.src='${imgDomain}/temp/img2.jpg'" src="${imgUrl}?rid=${user.userExt.headerPic}&op=s1_w80_h80_e1-c3_w80_h80" alt="" />
										</c:otherwise>
										</c:choose>
										</dt>
										<dd>
											<h2><c:out value="${user.userName}" />，您好</h2>
											<p>您可以：<a href="${ctx}/user/userInfo.action">去完善自己的个人资料</a><a href="${ctx}/user/userAddress.action">去管理自己的收货地址</a></p>
										</dd>
									</dl>
								</div>
							</div>
							<c:if test="${hasproduct==1}">
							
							<div class="memb-shopping">
								<h2>最近加入购物车的商品</h2>
								<div class="shopping">
									<table>
										<colgroup>
											<col width="380">
											<col width="220">
											<col width="80">
											<col width="130">
										</colgroup>
										<tbody>
										<c:forEach items="${carts }" var="cart" varStatus="var">
										  <c:forEach items="${cart.cartItems }" var="cartItem">
											<tr>
												<td class="shopgoods">
													<dl>
														<dt><a href="${ctx}/detail.action?bsdid=${cartItem.brandShowDetailId}"><img src="${my:random(imgGetUrl)}?rid=${cartItem.prodImgUrl }&op=s0_w52_h52" alt="" /></a></dt>
														<dd>
															<p class="title"><a href="${ctx}/detail.action?bsdid=${cartItem.brandShowDetailId}"><c:out value="${cartItem.prodName }"/></a></p>
													<p>
															<c:forEach items="${cartItem.specs }" var="map">
														<c:forEach items="${map }" var="spec">
															<span><c:out value="${spec.key}"/><c:out value="${spec.value }"/></span>
														</c:forEach>
													</c:forEach></p>
														</dd>
													</dl>
												</td>
												<td>
													<p class="nowPrice">￥<fmt:formatNumber value="${cartItem.showPrice }" minFractionDigits="2" /></p>
													<p class="price">￥<fmt:formatNumber value="${cartItem.maketPrice }" minFractionDigits="2" /></p>
												</td>
												<td>${cartItem.num }</td>
												<td>
													<p class="nowPrice">￥<c:out value="${cartItem.showPrice * cartItem.num }"/></p>
												</td>
											</tr>
											</c:forEach>
										</c:forEach>
										</tbody>
									</table>
									
									<div class="gotoLookall"><a href="${ctx}/cart/cart.action">去购物车查看全部&nbsp;&nbsp;></a></div>
								</div>
							</div>
						</c:if>
						<c:if test="${hasproduct==0}">
						<div class="memb-shopping">
								<h2>最近加入购物车的商品</h2>
								<div class="shoppingnull">
									<dl class="cartNull">
										<dt><img src="${cssDomain}/img/person.png" alt=""></dt>
										<dd>
											<h3>购物车很空很伤心<br>主人，快点填充我空虚的内心吧...</h3>
											<p><a href="/">去首页逛逛 <em>&gt;</em></a></p>
										</dd>
									</dl>
								</div>
							</div>
						
						</c:if>
						</div>
					</div>
					<!-- main end-->
				</div>
				<!-- memberCenter end-->
			</div>
		</div>
		<!-- container end -->
		<!-- footer -->
		<jsp:include page="/common/service.html" />
		<jsp:include page="/common/foot.html" />
		<!-- footer end -->
	</div>
</body>
</html>
