<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ include file="/common/common.jsp"%>
<html lang="zh-cn">
<head>
<meta charset="utf-8">
<title>个人中心-个人资料</title>
<link rel="stylesheet" type="text/css" href="${cssDomain}/css/allstyle.css" />
<link rel="stylesheet" type="text/css" href="${cssDomain}/css/member.css" />
<script type="text/javascript" src="${jsDomain}/jquery.min.js"></script>
<script type="text/javascript" src="${jsDomain}/datePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${jsDomain}/uploadify/jquery.uploadify.js"></script>
<script type="text/javascript">
	$(function() {
		$(document).on("blur", "#birthday", function() {
			var date = $(this).val();
			var xz = xingzuo(date);
			$("input[name='userExt.constellation']").val(xz);
			$("#constellation").val(xz);
		});

		$(document).on("click", "input[name=save]", function() {
			//验证昵称
			var nicknameFlg = true;
			var nickname = $("input[name='nickname']").val();
			$("#errMsg1").addClass("hide");
			if (!!nickname) {
				if (nickname.length > 15) {
					$("#errMsg1").removeClass("hide");
					nicknameFlg = false;
				}
			}

			//验证真实姓名
			var realnameFlg = true;
			var realname = $("input[name='userExt.realName']").val();
			$("#errMsg2").addClass("hide");
			if (!!realname) {
				if (realname.length > 15) {
					$("#errMsg2").removeClass("hide");
					realnameFlg = false;
				}
			}

			//验证居住地
			var homeAddrFlg = true;
			var homeAddr = $("input[name='userExt.homeAddress']").val();
			$("#errMsg3").addClass("hide");
			if (!!homeAddr) {
				if (homeAddr.length > 60) {
					$("#errMsg3").removeClass("hide");
					homeAddrFlg = false;
				}
			}

			if (nicknameFlg && homeAddrFlg && realnameFlg) {
				$("#form").submit();
			}
		});

		$("#uploadify").uploadify({
            //指定swf文件
			'swf': '${ctx}/uploadify/uploadify.swf',
            //后台处理的页面
            'uploader': '${imgUploadUrl}',
            //按钮显示的文字
            "buttonText":'添加头像',
            "buttonClass":"btn-primary xl",
            //显示的高度和宽度，默认 height 30；width 120
            'height': 20,
            'width': 50,
            //上传文件的类型  默认为所有文件    'All Files'  ;  '*.*'
            //在浏览窗口底部的文件类型下拉菜单中显示的文本
            'fileTypeDesc': 'Image Files',
            //允许上传的文件后缀
            'fileTypeExts': '*.gif; *.jpg; *.png',
            //发送给后台的其他参数通过formData指定
            //'formData': { 'someKey': 'someValue', 'someOtherKey': 1 },
            //上传文件页面中，你想要用来作为文件队列的元素的id, 默认为false  自动生成,  不带#
            //'queueID': 'fileQueue',
            //选择文件后自动上传
            'auto': true,
            //设置为true将允许多文件上传
            'multi': false,
            overrideEvents : ['onUploadProgress', 'onSelect'],
            onUploadSuccess : function(file, data, response) {
				if(response) {
					var d = $.parseJSON(data);
					$("img[name=file]").attr("src","${imgUrl}?rid="+d.rid+"&op=s1_w80_h80_e1-c3_w80_h80");
					$("input[name='userExt.headerPic']").val(d.rid);
				}
			}
        });
	});

	function xingzuo(date) {
		var value;
		if (!date) {
			return value;
		}
		var day = date.split("-");
		var month = day[1];
		var date = day[2];
		if (month == 1 && date >= 20 || month == 2 && date <= 18) {
			value = "水瓶座";
		}
		if (month == 1 && date > 31) {
			value = "Huh?";
		}
		if (month == 2 && date >= 19 || month == 3 && date <= 20) {
			value = "双鱼座";
		}
		if (month == 2 && date > 29) {
			value = "Say what?";
		}
		if (month == 3 && date >= 21 || month == 4 && date <= 19) {
			value = "白羊座";
		}
		if (month == 3 && date > 31) {
			value = "OK. Whatever.";
		}
		if (month == 4 && date >= 20 || month == 5 && date <= 20) {
			value = "金牛座";
		}
		if (month == 4 && date > 30) {
			value = "I'm soooo sorry!";
		}
		if (month == 5 && date >= 21 || month == 6 && date <= 21) {
			value = "双子座";
		}
		if (month == 5 && date > 31) {
			value = "Umm ... no.";
		}
		if (month == 6 && date >= 22 || month == 7 && date <= 22) {
			value = "巨蟹座";
		}
		if (month == 6 && date > 30) {
			value = "Sorry.";
		}
		if (month == 7 && date >= 23 || month == 8 && date <= 22) {
			value = "狮子座";
		}
		if (month == 7 && date > 31) {
			value = "Excuse me?";
		}
		if (month == 8 && date >= 23 || month == 9 && date <= 22) {
			value = "室女座";
		}
		if (month == 8 && date > 31) {
			value = "Yeah. Right.";
		}
		if (month == 9 && date >= 23 || month == 10 && date <= 22) {
			value = "天秤座";
		}
		if (month == 9 && date > 30) {
			value = "Try Again.";
		}
		if (month == 10 && date >= 23 || month == 11 && date <= 21) {
			value = "天蝎座";
		}
		if (month == 10 && date > 31) {
			value = "Forget it!";
		}
		if (month == 11 && date >= 22 || month == 12 && date <= 21) {
			value = "人马座";
		}
		if (month == 11 && date > 30) {
			value = "Invalid Date";
		}
		if (month == 12 && date >= 22 || month == 1 && date <= 19) {
			value = "摩羯座";
		}
		if (month == 12 && date > 31) {
			value = "No way!";
		}
		return value;
	}
</script>
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
					<span class="index"><a href="http://www.hehefang.com">首页</a></span>
					<ul class="nav">
						<li><span>&gt;</span><a href="${ctx}/user/userCenter.action">我的禾合坊</a></li>
						<li><span>&gt;</span><a href="${ctx}/user/userInfo.action">个人资料</a></li>
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
						<div class="memg-bd personaldata">
							<div class="buyerInfo">
								<div class="info-main">
									<dl>
										<dt>
											<c:choose>
												<c:when test="${empty(user.userExt.headerPic)}">
													<img name="file" src="${imgDomain}/upload.jpg" alt="" />
												</c:when>
												<c:otherwise>
													<img name="file" src="${imgUrl}?rid=${user.userExt.headerPic}&op=s1_w80_h80_e1-c3_w80_h80" alt="" />
												</c:otherwise>
											</c:choose>
										</dt>
										<dd>
											<h2>
												<c:out value="${user.userName}" />
												，您好
											</h2>
											<p>完善您的资料可以帮助我们为您提供更贴心的服务。<input type="button" id="uploadify" /></p>
										</dd>
									</dl>
								</div>
								<div class="editdata">
									<form class="form" id="form"
										action="${ctx}/user/saveUserInfo.action" method="post">
										<input type="hidden" name="userExt.headerPic" value="${user.userExt.headerPic}" />
										<input type="hidden" name="userId" value="${user.userId}" />
										<fieldset>
											<div class="formGroup">
												<div class="form-item">
													<div class="item-label">
														<label>用户名：</label>
													</div>
													<div class="item-cont">
														<p>
															<c:out value="${user.userName}" />
														</p>
													</div>
												</div>
												<div class="form-item">
													<div class="item-label">
														<label>昵称：</label>
													</div>
													<div class="item-cont">
														<input type="text" name="nickname"
															value='<c:out value="${user.nickname}" />'
															class="txt lg w-xl" placeholder="15个字以内的字母、数字、汉字"><span
															id="errMsg1" class="note errTxt hide">15个字以内的字母、数字、汉字。</span>
													</div>
												</div>
												<div class="form-item">
													<div class="item-label">
														<label>真实姓名：</label>
													</div>
													<div class="item-cont">
														<input type="text" name="userExt.realName"
															value='<c:out value="${user.userExt.realName}" />'
															class="txt lg w-xl" placeholder="15个字以内的字母、汉字"><span
															id="errMsg2" class="note errTxt hide">15个字以内的字母、汉字。</span>
													</div>
												</div>
												<div class="form-item">
													<div class="item-label">
														<label>性别：</label>
													</div>
													<div class="item-cont">
														<label><input type="radio" name="userExt.gender"
															class="radio" value=""
															<c:if test="${empty(user.userExt) || empty(user.userExt.gender) }" >checked="checked"</c:if >>保密</label>
														<label><input type="radio" name="userExt.gender"
															class="radio" value="0"
															<c:if test="${!empty(user.userExt) && user.userExt.gender =='0' }" >checked="checked"</c:if >>男</label>
														<label><input type="radio" name="userExt.gender"
															class="radio" value="1"
															<c:if test="${!empty(user.userExt) && user.userExt.gender =='1' }" >checked="checked"</c:if >>女</label>
													</div>
												</div>
												<div class="form-item">
													<div class="item-label">
														<label>生日：</label>
													</div>
													<div class="item-cont">
														<input type="text" id="birthday" class="txt"
															readonly="readonly" name="userExt.birthday"
															value="<fmt:formatDate value="${user.userExt.birthday}" pattern="yyyy-MM-dd" />"
															onClick="WdatePicker()" />
													</div>
												</div>
												<div class="form-item">
													<div class="item-label">
														<label>星座：</label>
													</div>
													<div class="item-cont">
														<input type="text" disabled="disabled" class="txt"
															readonly="readonly" id="constellation"
															value="${user.userExt.constellation}" /> <input
															type="hidden" name="userExt.constellation"
															value="${user.userExt.constellation}" />
													</div>
												</div>
												<div class="form-item">
													<div class="item-label">
														<label>居住地：</label>
													</div>
													<div class="item-cont">
														<input type="text" name="userExt.homeAddress"
															value='<c:out value="${user.userExt.homeAddress}" />'
															class="txt lg w-xl" placeholder="60个字以内"><span
															id="errMsg3" class="note errTxt hide ">60个字以内</span>
													</div>
												</div>
												<div class="form-item">
													<div class="item-label">
														<label></label>
													</div>
													<div class="item-cont">
														<c:if test="${success=='true'}">
															<p class="successColor">保存成功！</p>
														</c:if>
														<input name="save" type="button" value="保 存"
															class="btn btn-primary xl">
													</div>
												</div>
											</div>
										</fieldset>
									</form>
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
