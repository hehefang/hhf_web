<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/common/common.jsp"%>
<html>
<head>
	<meta charset="utf-8" />
	<title>找回密码3</title>
	<link rel="stylesheet" href="${cssDomain}/css/allstyle.css" />
	<link rel="stylesheet" href="${cssDomain}/css/register.css" />
	<script type="text/javascript" src="${jsDomain}/jquery.min.js"></script>
	<script type="text/javascript">
		$(function(){
			$(document).on("blur","input[name=pwd]",function(){
				var pwd = $(this).val();
				if(!pwd){
					$("#pwdTip").html("<span>请输入密码！</span>");
					return false;
				}
				if(pwd.length>20||pwd.length<6){
					$("#pwdTip").html("<span>密码在6-20位之间！</span>");
					return false;
				}
				$("#pwdTip").html('<span><i class="icon i-ok"></span>');
			});
			
			$(document).on("blur","input[name=repwd]",function(){
				var repwd = $(this).val();
				var pwd = $("input[name=pwd]").val();
				if(!repwd){
					$("#repwdTip").html("<span>请再次输入密码！</span>");
					return false;
				}
				if(pwd!=repwd){
					$("#repwdTip").html("<span>确认密码不正确！</span>");
					return false;
				}
				$("#repwdTip").html('<span><i class="icon i-ok"></span>');
			});
			
			$(document).on("click","input[name=complete]",function(){
				var k = $("input[name=k]").val();
				var pwd = $("input[name=pwd]").val();
				var repwd = $("input[name=repwd]").val();
				$.getJSON("${ctx}/validFindPwd3.action",
					{k:k,pwd:pwd,repwd:repwd},
					function(json){
						if(json.mobileStatus==0&&json.pwdStatus==0&&json.repwdStatus==0){
							location.href="${ctx}/findpwd4.action";
						}else{
							if(json.pwdStatus==1){
								$("#pwdTip").html("<span>请输入密码！</span>");
							}else if(json.pwdStatus==2){
								$("#pwdTip").html("<span>密码在6-20位之间！</span>");
							}
							
							if(json.repwdStatus ==1){
								$("#repwdTip").html("<span>请再次输入密码！</span>");
							}else if(json.repwdStatus ==2){
								$("#repwdTip").html("<span>确认密码不正确！</span>");
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
			<div class="wrap">
				<div class="signinForm findpw clearfix">
					<!-- findpw-hd -->
					<div class="auditStep">
						<h2>找回密码</h2>
						<ul class="mod-step theme-reg">
							<li class="first over">
								<i class="num">1</i>
								<p class="text">输入用户名</p>
							</li>
							<li class="over">
								<i class="num">2</i>
								<span class="strip"></span>
								<span class="strip-over"></span>
								<p class="text">验证身份</p>
							</li>
							<li class="now">
								<i class="num">3</i>
								<span class="strip"></span>
								<span class="strip-over"></span>
								<p class="text">设置新密码</p>
							</li>
							<li class="last">
								<i class="num">4</i>
								<span class="strip"></span>
								<span class="strip-over"></span>
								<p class="text">完成</p>
							</li>
						</ul>
					</div>
					<!-- findpw-hd end -->
					<form class="form formA">
						<input type="hidden" name="k" value="${k}" />
						<fieldset>
							<dl class="form-item">
								<dt class="item-label"><label><em>*</em>用户名：</label></dt>
								<dd class="item-cont">
									<input type="text" class="txt w-xl xl" disabled="disabled" value="<c:out value="${userName}" />" />
								</dd>
							</dl>
							<dl class="form-item">
								<dt class="item-label"><label><em>*</em>手机号：</label></dt>
								<dd class="item-cont">
									<input type="text" class="txt w-xl xl" disabled="disabled" value="<c:out value="${mobile}" />">
								</dd>
							</dl>
							<dl class="form-item">
								<dt class="item-label"><label><em>*</em>登录密码：</label></dt>
								<dd class="item-cont">
									<input name="pwd" type="password" class="txt w-xl xl" placeholder="请输入6-20位的字符" />
									<div class="checkHint errTxt">
										<div id="pwdTip" class="hintBox"></div>
									</div>
								</dd>
							</dl>
							<dl class="form-item">
								<dt class="item-label"><label><em>*</em>确认密码：</label></dt>
								<dd class="item-cont">
									<input name="repwd" type="password" class="txt w-xl xl" />
									<div class="checkHint errTxt">
									<div id="repwdTip" class="hintBox"></div>
									</div>
								</dd>
							</dl>
							<dl class="form-item">
								<dt class="item-label hidden"><label>提交：</label></dt>
								<dd class="item-cont"><input name="complete" type="button" class="btn btn-primary lgl p-lgl" value="完成" /></dd>
							</dl>
						</fieldset>
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
