<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/common/common.jsp"%>
<html>
<head>
	<meta charset="utf-8" />
	<title>找回密码4</title>
	<link rel="stylesheet" href="${cssDomain}/css/allstyle.css" />
	<link rel="stylesheet" href="${cssDomain}/css/register.css" />
	<script type="text/javascript" src="${jsDomain}/jquery.min.js"></script>
	<script type="text/javascript">
		$(function(){
			var sec = 4;
			var id = setInterval(function(){
				$("#tip").html(sec+"s后去登录 <em>&gt;</em>");
				if(sec==0){
					clearInterval(id);
					location.href="${ctx}/login.action";
				}
				sec--;
			}, 1000);
			
		});
	</script>
</head>
<body id="regsignin">
	<div class="wrapper">
		<!-- header -->
		<div id="header">
			<div class="wrap">
				<div id="logo">
					<div class="logo"><a href="http://www.hehefang.com" title="logo"><img src="${imgDomain}/logo.png" alt="logo"></a></div>
					<div class="slogan"><img src="${imgDomain}/slogan.png"/></div>
				</div>
				<div id="safeguard"><img src="${imgDomain}/safeguard.jpg"/></div>
			</div>
		</div>
		<!-- header end -->
		<!-- container -->
		<div id="container">
			<div class="wrap">
				<div class="signinForm findpw clearfix">
					<!-- findpw-hd -->
					<div class="auditStep">
						<h2>找回密码</h2>
						<ul class="mod-step">
							<li class="first now">
								<i class="num">1</i>
								<p class="text">验证身份</p>
							</li>
							<li class="now">
								<i class="num">2</i>
								<span class="strip"></span>
								<span class="strip-over"></span>
								<p class="text">重置密码</p>
							</li>
							<li class="last now">
								<i class="num">3</i>
								<span class="strip"></span>
								<span class="strip-over"></span>
								<p class="text">完成</p>
							</li>
						</ul>
					</div>
					<!-- findpw-hd end -->
					<form class="form formA">
						<dl class="successWarn">
							<dt><i class="icon i-rightXLX"></i></dt>
							<dd>
								<h3>密码修改成功</h3>
								<p><a id="tip" href="${ctx}/login.action">5s后去登录 <em>&gt;</em></a></p>
							</dd>
						</dl>
					</form>
				</div>
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
