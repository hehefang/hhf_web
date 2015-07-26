<!DOCTYPE html>
<html lang="zh-cn">
<%@page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@include file="/common/common.jsp"%>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>支付失败</title>
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
						<h2><i class="icon i-fail"></i>支付失败</h2>
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
							<dl class="order-submitState payfailure">
								<dt><i class="icon i-dangerXL"></i></dt>
								<dd>
									<h2>订单支付失败，请在我的订单中重新支付。</h2>
									<p><a href="${ctx }/user/orders.action">去我的订单看看 ></a></p>
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