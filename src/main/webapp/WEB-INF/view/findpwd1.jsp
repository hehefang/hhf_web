<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/common/common.jsp"%>
<html>
<head>
	<meta charset="utf-8" />
	<title>找回密码1</title>
	<link rel="stylesheet" href="${cssDomain}/css/allstyle.css" />
	<link rel="stylesheet" href="${cssDomain}/css/register.css" />
	<script type="text/javascript" src="${jsDomain}/jquery.min.js"></script>
	<script type="text/javascript">
		$(function(){
			$(document).on("blur","input[name=userName]",function(){
				var userName = $(this).val();
				if(!userName){
					$("#errMsg").html("<span>请输入用户名！</span>");
					return false;
				}
				$.getJSON("${ctx}/validUserName.action",
					{userName:userName},
					function(json){
						if(json.status){
							$("#errMsg").html("<span>该用户名不存在！</span>");
						}else{
							$("#errMsg").html('<span><i class="icon i-ok"></i></span>');
						}
					}
				);
			});
			
			$(document).on("click","a[name=next]",function(){
				var userName = $("input[name=userName]").val();
				var vCode = $("#vCode").val();
				$.getJSON("${ctx}/validFindPwd1.action",
					{userName:userName,vCode:vCode},
					function(json){
						if(json.userStatus ==0&&json.codeStatus==0){
							location.href="${ctx}/findpwd2.action?k="+json.k;
						}else{
							if(json.userStatus ==1){
								$("#errMsg").html("<span>请输入用户名！</span>");
							}else if(json.userStatus ==2){
								$("#errMsg").html("<span>该用户名不存在！</span>");
							}
							
							if(json.codeStatus==1){
								$("#errMsg2").html("<span>请输入验证码！</span>");
							}else if(json.codeStatus==2){
								$("#errMsg2").html("<span>验证码输入错误！</span>");
							}
						}
					}
				);
			});
			
			$(document).on("blur","#vCode",function(){
				var vCode = $(this).val();
				if(!vCode){
					$("#errMsg2").html("<span>请输入验证码！</span>");
					return false;
				}
				
				$.getJSON("${ctx}/validRandomCode.action",
					{vCode:vCode},
					function(json){
						if(json.status){
							$("#errMsg2").html('<span><i class="icon i-ok"></i></span>');
						}else{
							$("#errMsg2").html("<span>验证码输入错误！</span>");
						}
					}
				);
				
			});
			
		});
		
		function refresh() {
	        $("#code").attr("src","${ctx}/imageServlet?"+Math.random());
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
			<div class="wrap">
				<div class="signinForm findpw clearfix">
					<!-- findpw-hd -->
					<div class="auditStep">
						<h2>找回密码</h2>
						<ul class="mod-step theme-reg">
							<li class="first now">
								<i class="num">1</i>
								<p class="text">输入用户名</p>
							</li>
							<li class="">
								<i class="num">2</i>
								<span class="strip"></span>
								<span class="strip-over"></span>
								<p class="text">验证身份</p>
							</li>
							<li class="">
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
					<form class="form">
						<fieldset>
							<dl class="form-item">
								<dt class="item-label"><label><em>*</em>用户名：</label></dt>
								<dd class="item-cont">
									<input type="text" name="userName" class="txt w-xl xl">
									<div class="checkHint errTxt">
										<div id="errMsg" class="hintBox"></div>
									</div>
								</dd>
							</dl>
							<dl class="form-item">
								<dt class="item-label"><label><em>*</em>验证码：</label></dt>
								<dd class="item-cont">
									<div class="item-code"><img id="code" src="${ctx}/imageServlet" /></div>
									<p class="changeone"><a href="javascript:refresh();">换一张</a></p>
									<input id="vCode" name="vCode" type="text" class="txt w-lg xl">
									<div class="checkHint errTxt">
										<div id="errMsg2" class="hintBox"></div>
									</div>
								</dd>
							</dl>
							<dl class="form-item">
								<dt class="item-label hidden"><label>下一步：</label></dt>
								<dd class="item-cont"><a name="next" href="javascript:;" class="btn btn-primary lgl p-lgl">下一步</a></dd>
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
