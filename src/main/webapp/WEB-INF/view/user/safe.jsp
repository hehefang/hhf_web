<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/common/common.jsp"%>
<html lang="zh-cn">
<head>
	<meta charset="utf-8">
	<title>个人中心-安全设置</title>
	<link rel="stylesheet" type="text/css" href="${cssDomain}/css/allstyle.css"/>
	<link rel="stylesheet" type="text/css" href="${cssDomain}/css/member.css"/>
	<script type="text/javascript" src="${jsDomain}/jquery.min.js"></script>
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
					<span class="index"><a href="">首页</a></span>
					<ul class="nav">
						<li><span>&gt;</span><a href="${ctx}/user/userCenter.action">我的禾合坊</a></li>
						<li><span>&gt;</span><a href="">安全设置</a></li>
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
										<dt><img src="${imgUrl}?rid=${user.userExt.headerPic}&op=s1_w80_h80_e1-c3_w80_h80" alt=""></dt>
										<dd>
											<h2><c:out value="${user.userName}" />，您好</h2>
											<p>您上次登录时间：<fmt:formatDate value="${user.lastLoginDate}" pattern="yyyy-MM-dd HH:mm:ss" /></p>
										</dd>
									</dl>
								</div>
								<div class="safetySet">
									<dl>
										<dt><i class="icon i-lock"></i></dt>
										<dd>
											<h2><a href="${ctx}/user/modifyPwd1.action">修改密码</a>登录密码</h2>
											<p>安全性高的密码可以使账号更安全。建议您定期更换密码，且设置一个 包含数字和字母长度在6位以上的密码。</p>
										</dd>
									</dl>
								</div>
							</div>
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
