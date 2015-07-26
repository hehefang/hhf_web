<!DOCTYPE html>
<html lang="zh-cn">
<%@page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@include file="/common/common.jsp"%>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>支付成功</title>
	<link rel="stylesheet" type="text/css" href="${cssDomain}/css/allstyle.css"/>
    <link rel="stylesheet" type="text/css" href="${cssDomain}/css/order.css"/>
    <script type="text/javascript" src="${jsDomain}/jquery.min.js"></script>
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
						<h2><i class="icon i-over"></i>支付完成</h2>
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
							<li class="over">
								<i class="num">2</i>
								<span class="strip"></span>
								<span class="strip-over"></span>
								<p class="text">在线支付</p>
							</li>
							<li class="last now">
								<i class="num">3</i>
								<span class="strip"></span>
								<span class="strip-over"></span>
								<p class="text">完成</p>
							</li>
						</ul>
					</div>
					<div class="bd">
						<div class="orderState">
							<!-- submitState -->
							<dl class="order-submitState paySuccess">
								<dt><i class="icon i-rightXL"></i></dt>
								<dd>
									<h2>您的订单已经成功支付，请等待收货。</h2>
									<p>您可以：<a href="${ctx }/user/orders.action">查看订单</a><a href="${ctx }">去首页逛逛</a></p>
								</dd>
							</dl>
							<!-- submitState end -->
						</div>
					</div>
				</div>
				<!-- cartList end -->
			</div>
		</div>
		<!-- container end -->
		<jsp:include page="/common/foot.html" />
	</div>
</body>
</html>