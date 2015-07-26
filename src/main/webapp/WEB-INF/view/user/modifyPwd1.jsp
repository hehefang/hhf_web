<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/common/common.jsp"%>
<html>
<head>
	<meta charset="utf-8" />
	<title>找回密码2</title>
	<link rel="stylesheet" href="${cssDomain}/css/allstyle.css" />
	<link rel="stylesheet" href="${cssDomain}/css/register.css" />
	<script type="text/javascript" src="${jsDomain}/jquery.min.js"></script>
	<script type="text/javascript">
		$(function(){
			$(document).on("click","#getCode",function(){
				if($(this).hasClass("disabled")){
					return false;
				}
				var k = $("input[name=k]").val();
				$.post("${ctx}/getCodeForget.action",{k:k});
				$(this).addClass("disabled");
				var second = 120;
				id = setInterval(function(){
					$("#getCode").text(second+"秒后，重新获取");
					if(second == 0){
						clearInterval(id);
						$("#getCode").removeClass("disabled");
						$("#getCode").text("获取验证码");
					}
					second--;
				},1000);
			});
			
			$(document).on("blur","input[name=code]",function(){
				var code = $(this).val();
				var k = $("input[name=k]").val();
				if(!code){
					$("#errMsg").html("<span>请输入验证码！</span>");
					return false;
				}
				
				$.getJSON("${ctx}/validCodeForget.action",
					{code:code,k:k},
					function(json){
						if(json.status){
							$("#errMsg").html('<span><i class="icon i-ok"></i></span>');
						}else{
							$("#errMsg").html("<span>验证码有误！</span>");
						}
					}
				);
			});
			
			$(document).on("click","a[name=next]",function(){
				var k=$("input[name=k]").val();
				var code=$("input[name=code]").val();
				$.getJSON("${ctx}/user/validModifyPwd1.action",
					{k:k,code:code},
					function(json){
						if(json.codeStatus==0&&json.mobileStatus==0){
							location.href="${ctx}/user/modifyPwd2.action?k="+json.k;
						}else{
							if(json.codeStatus==1){
								$("#errMsg").html("<span>请输入验证码！</span>");
							}else if(json.codeStatus==2){
								$("#errMsg").html("<span>验证码有误！</span>");
							}
							
							if(json.mobileStatus==1){
								location.href="${ctx}/register.action";
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
						<ul class="mod-step">
							<li class="first now">
								<i class="num">1</i>
								<p class="text">验证身份</p>
							</li>
							<li class="">
								<i class="num">2</i>
								<span class="strip"></span>
								<span class="strip-over"></span>
								<p class="text">重置密码</p>
							</li>
							<li class="last">
								<i class="num">3</i>
								<span class="strip"></span>
								<span class="strip-over"></span>
								<p class="text">完成</p>
							</li>
						</ul>
					</div>
					<!-- findpw-hd end -->
					<form class="form formA">
						<input type="hidden" name="k" value="<c:out value="${k}" />" />
						<fieldset>
							<dl class="form-item">
								<dt class="item-label"><label>您的手机号：</label></dt>
								<dd class="item-cont">
									<input type="text" class="txt w-xl xl" disabled="disabled" value="<c:out value="${mobile}" />">
								</dd>
							</dl>
							<dl class="form-item">
								<dt class="item-label"><label><em>*</em>短信验证码：</label></dt>
								<dd class="item-cont">
									<a href="javascript:;" id="getCode" class="btn btn-def checkCode">获取短信验证码</a>
									<!--<a href="#" class="btn btn-def checkCode disabled">59秒后可重新获取</a>-->
									<input name="code" type="text" class="txt xl phoneCode">
									<div class="checkHint errTxt">
										<div id="errMsg" class="hintBox"></div>
									</div>
								</dd>
							</dl>
							<dl class="form-item">
								<dt class="item-label hidden"><label>下一步：</label></dt>
								<dd class="item-cont"><a href="javascript:;" name="next" class="btn btn-primary lgl p-lgl">下一步</a></dd>
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
