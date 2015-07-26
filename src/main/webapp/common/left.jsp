<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/common/common.jsp"%>
<div class="memb-sidebar">
	<div class="menu">
		<h2>财务管理</h2>
		<ul>
			<li><a href="${ctx}/user/userCenter.action"><span class="arrow right-hollow xs"><b></b><i></i></span>个人中心</a></li>
			<li><a href="${ctx}/cart/cart.action"><span class="arrow right-hollow xs"><b></b><i></i></span>我的购物车</a></li>
			<li><a href="${ctx}/user/orders.action"><span class="arrow right-hollow xs"><b></b><i></i></span>我的订单</a></li>
			<li><a href="${ctx}/retOrder/myRetOrders.action"><span class="arrow right-hollow xs"><b></b><i></i></span>退货管理</a></li>
		</ul>
		<h2>个人资料</h2>
		<ul>
			<li><a href="${ctx}/user/userInfo.action"><span class="arrow right-hollow xs"><b></b><i></i></span>个人资料</a></li>
			<li><a href="${ctx}/user/userAddress.action"><span class="arrow right-hollow xs"><b></b><i></i></span>收货地址</a></li>
			<li><a href="${ctx}/user/safeSet.action"><span class="arrow right-hollow xs"><b></b><i></i></span>安全设置</a></li>
		</ul>
	</div>		
</div>