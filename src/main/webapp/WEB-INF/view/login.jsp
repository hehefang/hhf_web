<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/common/common.jsp"%>
<html>
<head>
	<meta charset="utf-8" />
	<title>登录</title>
	<link rel="stylesheet" href="${cssDomain}/css/allstyle.css" />
	<link rel="stylesheet" href="${cssDomain}/css/register.css" />
	<script type="text/javascript" src="${jsDomain}/jquery.min.js"></script>
	<script type="text/javascript">
		$(function(){
			$(document).on("click","#login",login);
			$(document).keypress(function(e) {  
				// 回车键事件  
				if(e.which == 13) {  
					login();
				}  
			}); 
		});
		function login(){
			$("#errTip").text("");
			var userName = $("input[name=userName]").val();
			if(!userName){
				$("#errTip").text("请输入用户名！");
				return false;
			}
			
			var pwd = $("input[name=pwd]").val();
			if(!pwd){
				$("#errTip").text("请输入密码！");
				return false;
			}
			$.getJSON("${ctx}/formLogin.action",
				{userName:userName,pwd:pwd},
				function(json){
					if(json.status){
						var rtnUrl = $("input[name=rtnUrl]").val();
						if(!rtnUrl){
							rtnUrl = "http://www.hehefang.com";
						}
						location.href=rtnUrl;
					}else{
						$("#errTip").text("用户名或密码有误！");
					}
				}
			);
		}
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
			<div class="wrap wrap-login">
				<div class="signinForm clearfix">
					<form class="form" id="form" action="${ctx}/formLogin.action" method="post">
						<input type="hidden" name="rtnUrl" value="${rtnUrl}" />
						<div class="legend">
							<h2>登 录</h2>
							<p>还没账号？立刻 <a href="${ctx}/register.action">免费注册</a></p>
						</div>
						<div class="form-item item-user">
							<div class="item-cont">
								<input type="text" name="userName" placeholder="用户名" class="txt xl" />
							</div>
						</div>
						<div class="form-item item-pw">
							<dd class="item-cont">
								<input name="pwd" type="password" class="txt xl" />
								<div id="errTip" class="note errTxt"><c:out value="${tip}" /></div>
							</dd>
						</div>
						<div class="form-item">
							<dd class="item-cont"><input type="button" id="login" class="btn btn-primary loginBtn" value="登&nbsp;&nbsp;&nbsp;录" /></dd>
						</div>
						<div class="form-item item-forget">
							<dd class="item-cont"><a href="${ctx}/findpwd.action">忘记密码？</a></dd>
						</div>
						
					</form>
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
