<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/common/common.jsp"%>
<html>
<head>
	<meta charset="utf-8" />
	<title>注册成功</title>
	<link rel="stylesheet" href="${cssDomain}/css/allstyle.css" />
	<link rel="stylesheet" href="${cssDomain}/css/register.css" />
	<script type="text/javascript" src="${jsDomain}/jquery.min.js"></script>
	<script type="text/javascript">
		$(function(){
			var sec = 4;
			var id = setInterval(function(){
				$("#tip").html(sec+"s后返回 <em>&gt;</em>");
				if(sec==0){
					clearInterval(id);
					location.href="http://www.hehefang.com";
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
			<!-- login -->
			<div class="wrap regSuccess">
				<div class="signinForm">
					<dl class="successWarn">
						<dt><i class="icon i-rightXLX"></i></dt>
						<dd>
							<h3>恭喜您，<c:out value="${userName}" />已经注册成功</h3>
							<p><a id="tip" href="http://www.hehefang.com">5s后返回 <em>&gt;</em></a></p>
						</dd>
					</dl>
				</div>
			</div>
			<!-- login end -->
		</div>
		<!-- container end -->
		<!-- footer -->
		<jsp:include page="/common/service.html" />
		<jsp:include page="/common/foot.html" />
		<!-- footer end -->
	</div>
</body>
</html>
