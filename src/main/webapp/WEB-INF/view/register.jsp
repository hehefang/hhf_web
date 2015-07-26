<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/common/common.jsp"%>
<html>
<head>
	<meta charset="utf-8" http-equiv="content-type" content="text/html;charset=uft-8" />
	<title>注册</title>
	<link rel="stylesheet" href="${cssDomain}/css/allstyle.css" />
	<link rel="stylesheet" href="${cssDomain}/css/register.css" />
	<script type="text/javascript" src="${jsDomain}/jquery.min.js"></script>
	<script type="text/javascript">
		var id;
		$(function(){
			$(document).on("blur","#userName",function(){
				var userName = $(this).val();
				if(!userName){
					$("#userNameTip").removeClass("hide");
					$("#userNameTip").children("div.hintBox").html("<span>用户名不可为空！</span>");
					$("#userNameOk").addClass("hide");
					$(this).focus();
					return;
				}
				
				if(/.*[\u4e00-\u9fa5]+.*$/.test(userName)) {
					$("#userNameTip").removeClass("hide");
					$("#userNameTip").children("div.hintBox").html("<span>用户名不可包含中文！</span>");
					$("#userNameOk").addClass("hide");
					$(this).focus();
					return;
				}
				
				if(userName.length >20 || userName.length<6){
					$("#userNameTip").removeClass("hide");
					$("#userNameTip").children("div.hintBox").html("<span>用户名必须在6-20个字符之间！</span>");
					$("#userNameOk").addClass("hide");
					$(this).focus();
					return;
				}
				
				$.getJSON(
					"${ctx}/validUserName.action",
					{userName:userName},
					function(json){
						if(json.status){
							$("#userNameTip").addClass("hide");
							$("#userNameOk").removeClass("hide");
						}else{
							$("#userNameTip").removeClass("hide");
							$("#userNameTip").children("div.hintBox").html("<span>该用户名已被注册！</span>");
							$("#userNameOk").addClass("hide");
							$(this).focus();
						}
					}
				);
			});
			
			$(document).on("blur","#mobile",function(){
				var mobile = $(this).val();
				if(!mobile){
					$("#mobileTip").removeClass("hide");
					$("#mobileTip").addClass("errTxt");
					$("#mobileTip").children("div.hintBox").html("<span>手机号不可为空！</span>");
					$("#mobileOk").addClass("hide");
					$(this).focus();
					return;
				}
				if(!/^1\d{10}/.test(mobile)){
					$("#mobileTip").removeClass("hide");
					$("#mobileTip").addClass("errTxt");
					$("#mobileTip").children("div.hintBox").html("<span>手机号输入有误！</span>");
					$("#mobileOk").addClass("hide");
					$(this).focus();
					return;
				}
				
				$.getJSON(
					"${ctx}/validMobile.action",
					{mobile:mobile},
					function(json){
						if(json.status){
							$("#mobileTip").addClass("hide");
							$("#mobileOk").removeClass("hide");
							if(!$("#getCode").hasClass("run")){
								$("#getCode").removeClass("disabled");
							}
						}else{
							$("#mobileTip").removeClass("hide");
							$("#mobileTip").removeClass("errTxt");
							$("#mobileTip").children("div.hintBox").html('<span>此号码已经注册，请直接 <a href="${ctx}/login.action">登录</a></span>');
							$("#mobileOk").addClass("hide");
							$(this).focus();
						}
					}
				);
			});
			

			$(document).on("blur","#pwd",function(){
				var pwd = $(this).val();
				if(!pwd){
					$("#pwdTip").removeClass("hide");
					$("#pwdTip").addClass("errTxt");
					$("#pwdTip").children("div.hintBox").html("<span>请输入密码！</span>");
					$("#pwdOk").addClass("hide");
					$(this).focus();
					return false;
				}
				
				if(pwd.length > 20 || pwd.length < 6){
					$("#pwdTip").removeClass("hide");
					$("#pwdTip").addClass("errTxt");
					$("#pwdTip").children("div.hintBox").html("<span>密码必须在6-20个字符之间！</span>");
					$("#pwdOk").addClass("hide");
					$(this).focus();
					return false;
				}
				
				$("#pwdTip").addClass("hide");
				$("#pwdTip").addClass("errTxt");
				$("#pwdOk").removeClass("hide");
				
			});
			
			$(document).on("blur","#repwd",function(){
				var pwd = $("#pwd").val();
				var repwd = $(this).val();
				if(!repwd){
					$("#repwdTip").removeClass("hide");
					$("#repwdTip").addClass("errTxt");
					$("#repwdOk").addClass("hide");
					$("#repwdTip").children("div.hintBox").html("<span>请再次输入密码！</span>");
					return false;
				}
				if(pwd!=repwd){
					$("#repwdTip").removeClass("hide");
					$("#repwdTip").addClass("errTxt");
					$("#repwdOk").addClass("hide");
					$("#repwdTip").children("div.hintBox").html("<span>确认密码输入不正确！</span>");
					$(this).focus();
				}else{
					$("#repwdTip").addClass("hide");
					$("#repwdOk").removeClass("hide");
				}
			});
			
			$(document).on("click","#register",function(){
				var userName = $("#userName").val();
				var mobile = $("#mobile").val();
				var pwd = $("#pwd").val();
				var repwd = $("#repwd").val();
				$.getJSON("${ctx}/validRegister.action",
					{userName:userName,mobile:mobile,pwd:pwd,repwd:repwd},
					function(json){
						if(json.userNameStatus == 0 && json.mobileStatus == 0 && json.codeStatus == 0 
								&& json.pwdStatus == 0 && json.repwdStatus ==0){
							$("#form").submit();
						}else{
							if(json.userNameStatus == 1){
								$("#userNameTip").removeClass("hide");
								$("#userNameTip").children("div.hintBox").html("<span>用户名不可为空！</span>");
								$("#userNameOk").addClass("hide");
							}else if(json.userNameStatus == 2){
								$("#userNameTip").removeClass("hide");
								$("#userNameTip").children("div.hintBox").html("<span>用户名必须在6-20个字符之间！</span>");
								$("#userNameOk").addClass("hide");
							}else if(json.userNameStatus == 3){
								$("#userNameTip").removeClass("hide");
								$("#userNameTip").children("div.hintBox").html("<span>用户名不可包含中文！</span>");
								$("#userNameOk").addClass("hide");
							}else if(json.userNameStatus == 4){
								$("#userNameTip").removeClass("hide");
								$("#userNameTip").children("div.hintBox").html("<span>该用户名已被注册！</span>");
								$("#userNameOk").addClass("hide");
							}
							
							if(json.mobileStatus ==1){
								$("#mobileTip").removeClass("hide");
								$("#mobileTip").addClass("errTxt");
								$("#mobileTip").children("div.hintBox").html("<span>手机号不可为空！</span>");
								$("#mobileOk").addClass("hide");
							}else if(json.mobileStatus ==2){
								$("#mobileTip").removeClass("hide");
								$("#mobileTip").addClass("errTxt");
								$("#mobileTip").children("div.hintBox").html("<span>手机号输入有误！</span>");
								$("#mobileOk").addClass("hide");
							}else if(json.mobileStatus ==3){
								$("#mobileTip").removeClass("hide");
								$("#mobileTip").removeClass("errTxt");
								$("#mobileTip").children("div.hintBox").html('<span>此号码已经注册，请直接 <a href="${ctx}/login.action">登录</a></span>');
								$("#mobileOk").addClass("hide");
							}							
							
							if(json.pwdStatus == 1){
								$("#pwdTip").removeClass("hide");
								$("#pwdTip").addClass("errTxt");
								$("#pwdOk").addClass("hide");
								$("#pwdTip").children("div.hintBox").html("<span>请输入密码！</span>");
							}else if(json.pwdStatus == 2){
								$("#pwdTip").removeClass("hide");
								$("#pwdTip").addClass("errTxt");
								$("#pwdOk").addClass("hide");
								$("#pwdTip").children("div.hintBox").html("<span>密码必须在6-20个字符之间！</span>");
							}
							
							if(json.repwdStatus == 1){
								$("#repwdTip").removeClass("hide");
								$("#repwdTip").addClass("errTxt");
								$("#repwdOk").addClass("hide");
								$("#repwdTip").children("div.hintBox").html("<span>请再次输入密码！</span>");
							}else if(json.repwdStatus == 2){
								$("#repwdTip").removeClass("hide");
								$("#repwdTip").addClass("errTxt");
								$("#repwdOk").addClass("hide");
								$("#repwdTip").children("div.hintBox").html("<span>确认密码输入不正确！</span>");
							}
						}
					}	
				);
				
			});
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
			<div class="wrap wrap-register">
				<div class="signin-hd">注册成为禾合坊买家</div>
				<div class="signinForm clearfix">
					 <form class="form" id="form" action="${ctx}/formRegister.action" method="post">
						<dl class="form-item item-user">
							<dt class="item-label"><label><em>*</em>用户名：</label></dt>
							<dd class="item-cont">
								<input id="userName" name="userName" type="text" placeholder="6-20位字符，可使用字母、数字、符号" class="txt xl w-xl" />
								<div id="userNameTip" class="checkHint errTxt hide"><div class="hintBox"><span>该昵称已被注册</span></div></div>
								<div id="userNameOk" class="checkHint hide"><div class="hintBox"><span><i class="icon i-ok"></i></span></div></div>
<!-- 								<p class="clear">推荐用户名：<a href="#">惆怅的僵尸123</a><a href="#">惆怅的僵尸123</a><a href="#">惆怅的僵尸123</a><a href="#">惆怅的僵尸123</a></p> -->
							</dd>	
						</dl>
						<dl class="form-item item-phone">
							<dt class="item-label"><label><em>*</em>手机号：</label></dt>
							<dd class="item-cont">
								<input id="mobile" name="mobile" type="text" placeholder="" class="txt xl w-xl" />
								<div id="mobileTip" class="checkHint hide"><div class="hintBox"><span>此号码已经注册，请直接 <a href="${ctx}/login.action">登录</a></span></div></div>
								<div id="mobileOk" class="checkHint hide"><div class="hintBox"><span><i class="icon i-ok"></i></span></div></div>
							</dd>
						</dl>
						<dl class="form-item item-pwd">
							<dt class="item-label"><label><em>*</em>登录密码：</label></dt>
							<dd class="item-cont">
								<input id="pwd" name="pwd" type="password" placeholder="" class="txt xl w-xl" />
								<div id="pwdTip" class="checkHint"><div class="hintBox"><span>6-20位字符</span></div></div>
								<div id="pwdOk" class="checkHint hide"><div class="hintBox"><span><i class="icon i-ok"></i></span></div></div>
							</dd>
						</dl>
						<dl class="form-item item-pwd">
							<dt class="item-label"><label><em>*</em>确认密码：</label></dt>
							<dd class="item-cont">
								<input id="repwd" type="password" placeholder="" class="txt xl w-xl" />
								<div id="repwdTip" class="checkHint errTxt hide"><div class="hintBox"><span>输入错误</span></div></div>
								<div id="repwdOk" class="checkHint hide"><div class="hintBox"><span><i class="icon i-ok"></i></span></div></div>
							</dd>
						</dl>
						<dl class="form-item item-agree">
							<dt class="item-label"></dt>
							<dd class="item-cont">
								<input id="register" type="button" value="同意协议并注册"  class="btn btn-primary regBtn">
								<p><a href="#">《禾合坊用户注册协议》</a></p>
							</dd>
						</dl>
					</form>
					<div class="reg-login">
						<div class="regLogin-wrap">
							<p>已经注册过？</p>
							<a href="${ctx}/login.action" class="btn btn-assist">立即登录</a>
							<p><a href="${ctx}/findpwd.action">忘记密码</a></p>
						</div>
					</div>
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
