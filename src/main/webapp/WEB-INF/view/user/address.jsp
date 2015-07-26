<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/common/common.jsp"%>
<html lang="zh-cn">
<head>
	<meta charset="utf-8">
	<title>个人中心-管理地址</title>
	<link rel="stylesheet" type="text/css" href="${cssDomain}/css/allstyle.css"/>
	<link rel="stylesheet" type="text/css" href="${cssDomain}/css/member.css"/>
	<script type="text/javascript" src="${jsDomain}/jquery.min.js"></script>
	<script type="text/javascript">
		$(function(){
			$(document).on("click","input[name=newAddr]",function(json){
				$.getJSON("${ctx}/user/canAdd.action",
					function(json){
						if(!json.status){
							alert("最多添加20个地址！");
							return;
						}else{
							openPop();
						}
					}
				);
			});
			
			$(document).on("change","select[name=province]",function(){
				var proId = $(this).children("option:selected").val();
				$(this).removeClass("errIpt");
				if(proId=='-1'){
					$("input[name=provinceName]").val('');
				}else{
					$("input[name=provinceName]").val($(this).children("option:selected").html());
				}
				$("input[name=cityName]").val('');
				$("input[name=districtName]").val('');
				$("#append").html('');
				$.getJSON(
					"${ctx}/user/getNextGeo.action",
					{geoId:proId},
					function(json){
						if(!!json){
							var cityOptions = [];
							cityOptions.push("<option value='-1'>请选择</option>");
							for(var i in json){
								var geo = json[i];
								cityOptions.push("<option value='"+geo.geoId+"'>"+geo.geoName+"</option>");
							}
							$("select[name=city]").html(cityOptions.join(''));
							$("select[name=district]").html("<option value='-1'>请选择</option>");
						}
					}
				);
			});
			
			$(document).on("change","select[name=city]",function(){
				var cityId = $(this).children("option:selected").val();
				$(this).removeClass("errIpt");
				if(cityId=='-1'){
					$("input[name=cityName]").val('');
				}else{
					$("input[name=cityName]").val($(this).children("option:selected").html());
				}
				$("input[name=districtName]").val('');
				$("#append").html('');
				$.getJSON(
					"${ctx}/user/getNextGeo.action",
					{geoId:cityId},
					function(json){
						if(!!json){
							var districtOptions = [];
							districtOptions.push("<option value='-1'>请选择</option>");
							for(var i in json){
								var geo = json[i];
								districtOptions.push("<option value='"+geo.geoId+"'>"+geo.geoName+"</option>");
							}
							$("select[name=district]").html(districtOptions.join(''));
						}
					}
				);
			});
			
			$(document).on("change","select[name=district]",function(){
				var districtId = $(this).children("option:selected").val();
				$(this).removeClass("errIpt");
				if(districtId=='-1'){
					$("input[name=districtName]").val('');
				}else{
					$("input[name=districtName]").val($(this).children("option:selected").html());
				}
				$("input[name=townName]").val('');
				$("#append").html('');
				$.getJSON(
					"${ctx}/user/getNextGeo.action",
					{geoId:districtId},
					function(json){
						if(!!json){
							var districtOptions = [];
							districtOptions.push("<option value='-1'>请选择</option>");
							if(json.length ==0){
								return;
							}
							for(var i in json){
								var geo = json[i];
								districtOptions.push("<option value='"+geo.geoId+"'>"+geo.geoName+"</option>");
							}
							var append = "<select name='town'>" + districtOptions.join('') + "</select>";
							$("#append").html(append);
						}
					}
				);
			});
			
			$(document).on("change","select[name=town]",function(){
				var districtId = $(this).children("option:selected").val();
				$(this).removeClass("errIpt");
				if(districtId=='-1'){
					$("input[name=townName]").val('');
				}else{
					$("input[name=townName]").val($(this).children("option:selected").html());
				}
			});
			
			$(document).on("click","input[name=save]",function(){
				$("#errMsg1").html('');
				$("#errMsg2").html('');
				$("#errMsg3").html('');
				$("#errMsg4").html('');
				$("#errMsg5").html('');
				//geo
				var geoFlg = true;
				var provinceId = $("select[name=province] > option:selected").val();
				var cityId = $("select[name=city] > option:selected").val();
				var districtId = $("select[name=district] > option:selected").val();
				if(provinceId=='-1'){
					$("select[name=province]").addClass("errIpt");
					geoFlg = false;
					$("#errMsg1").html("请选择收货区域！");
				}
				if(cityId=='-1'){
					$("select[name=city]").addClass("errIpt");
					geoFlg = false;
					$("#errMsg1").html("请选择收货区域！");
				}
				if(districtId=='-1'){
					$("select[name=district]").addClass("errIpt");
					geoFlg = false;
					$("#errMsg1").html("请选择收货区域！");
				}
				var town = $("#append").html();
				if(!!town){
					var townId = $("select[name=town] > option:selected").val();
					if(townId=="-1"){
						$("select[name=town]").addClass("errIpt");
						geoFlg = false;
						$("#errMsg1").html("请选择收货区域！");
					}
				}
				//addr
				var addrFlg = true;
				var addr = $("textarea[name=addr]").val();
				$("textarea[name=addr]").removeClass("errIpt");
				if(!addr){
					$("#errMsg2").html("请输入详细地址！");
					$("textarea[name=addr]").addClass("errIpt");
					addrFlg = false;
				}else{
					if(addr.length>50){
						$("#errMsg2").html("详细地址不得超过50字！");
						$("textarea[name=addr]").addClass("errIpt");
						addrFlg = false;
					}
				}
				//zipcode
				var zipFlg = true;
				var zipCode = $("input[name=zipCode]").val();
				$("input[name=zipCode]").removeClass("errIpt");
				if(!!zipCode){
					if(!/^\d{6}$/.test(zipCode)){
						$("#errMsg3").html("请正确填写邮编！");
						$("input[name=zipCode]").addClass("errIpt");
						zipFlg = false;
					}
				}
				//收货人
				var receiverFlg = true;
				var receiver = $("input[name=receiver]").val();
				$("input[name=receiver]").removeClass("errIpt");
				if(!receiver){
					$("#errMsg4").html("请输入收货人！");
					$("input[name=receiver]").addClass("errIpt");
					receiverFlg = false;
				}else{
					if(receiver.length>15){
						$("#errMsg4").html("收货人不得超过15字！");
						$("input[name=receiver]").addClass("errIpt");
						receiverFlg = false;
					}
				}
				//手机和电话
				var mobileFlg = true;
				var mobile = $("input[name=mobile]").val();
				$("input[name=mobile]").removeClass("errIpt");
				if(!mobile){
					$("#errMsg5").html("请输入手机号！");
					$("input[name=mobile]").addClass("errIpt");
					mobileFlg = false;
				}else{
					if(!/^1\d{10}$/.test(mobile)){
						$("#errMsg5").html("请输入正确手机号！");
						$("input[name=mobile]").addClass("errIpt");
						mobileFlg = false;
					}
				}
				
				var telFlg = true;
				$("input[name=telArea]").removeClass("errIpt");
				$("input[name=telNum]").removeClass("errIpt");
				$("input[name=telExt]").removeClass("errIpt");
				var telArea = $("input[name=telArea]").val();
				var telNum = $("input[name=telNum]").val();
				var telExt = $("input[name=telExt]").val();
				
				if(!!telArea || !!telNum || !!telExt){
					if(!/^\d{3,4}$/.test(telArea)){
						$("#errMsg5").html("请输入正确区号！");
						$("input[name=telArea]").addClass("errIpt");
						telFlg = false;
					}
					
					if(!/^\d{7,8}$/.test(telNum)){
						$("#errMsg5").html("请输入正确电话号码！");
						$("input[name=telNum]").addClass("errIpt");
						telFlg = false;
					}
					
					if(!!telExt){
						if(!/^\d{3,4}$/.test(telExt)){
							$("#errMsg5").html("请输入正确分机号码！");
							$("input[name=telExt]").addClass("errIpt");
							telFlg = false;
						}
					}
				}
				
				if(geoFlg&&addrFlg&&zipFlg&&receiverFlg&&(mobileFlg||telFlg)){
					$("#form").submit();
				}
				
			});
			
			$(document).on("click","a[name=setDefault]",function(){
				var addrId = $(this).attr("addrId");
				location.href = "${ctx}/user/setDefault.action?addrId="+addrId;
			});
			
			$(document).on("click","a[name=del]",function(){
				var addrId = $(this).attr("addrId");
				location.href = "${ctx}/user/delAddr.action?addrId="+addrId;
			});
			
			$(document).on("click","a[name=modify]",function(){
				var addrId = $(this).attr("addrId");
				$.getJSON(
					"${ctx}/user/getAddr.action",
					{addrId:addrId},
					function(json){
						if(!!json){
							openPop();
							$("input[name=addrId]").val(json.addrId);
							$("textarea[name=addr]").val(json.addr);
							$("input[name=zipCode]").val(json.zipCode);
							$("input[name=receiver]").val(json.receiver);
							$("input[name=mobile]").val(json.mobile);
							$("input[name=provinceName]").val(json.provinceName);
							$("input[name=cityName]").val(json.cityName);
							$("input[name=districtName]").val(json.districtName);
							$("input[name=townName]").val(json.townName);
							var tel = json.tel;
							if(!!tel){
								var telTemp = tel.split("-");
								if(telTemp.length>1){
									$("input[name=telArea]").val(telTemp[0]);
									$("input[name=telNum]").val(telTemp[1]);
									if(!!telTemp[2]){
										$("input[name=telExt]").val(telTemp[2]);
									}
								}
							}
							if(json.isDefault == '1'){
								$("input[name=isDefault]").prop("checked",true);
							}
							$("select[name=province]").children("option[value="+json.province+"]").attr("selected",true);
							$.getJSON(
								"${ctx}/user/getNextGeo.action",
								{geoId:json.province},
								function(jsonCity){
									if(!!jsonCity){
										var cityOptions = [];
										cityOptions.push("<option value='-1'>请选择</option>");
										for(var i in jsonCity){
											var geo = jsonCity[i];
											cityOptions.push("<option value='"+geo.geoId+"'>"+geo.geoName+"</option>");
										}
										$("select[name=city]").html(cityOptions.join(''));
										$("select[name=city]").children("option[value="+json.city+"]").attr("selected",true);
										$.getJSON(
											"${ctx}/user/getNextGeo.action",
											{geoId:json.city},
											function(jsonDistrict){
												if(!!jsonDistrict){
													var districtOptions = [];
													districtOptions.push("<option value='-1'>请选择</option>");
													for(var i in jsonDistrict){
														var geo = jsonDistrict[i];
														districtOptions.push("<option value='"+geo.geoId+"'>"+geo.geoName+"</option>");
													}
													$("select[name=district]").html(districtOptions.join(''));
													$("select[name=district]").children("option[value="+json.district+"]").attr("selected",true);
													$.getJSON(
														"${ctx}/user/getNextGeo.action",
														{geoId:json.district},
														function(jsonTown){
															if(!!jsonTown){
																var districtOptions = [];
																districtOptions.push("<option value='-1'>请选择</option>");
																if(jsonTown.length ==0){
																	return;
																}
																for(var i in jsonTown){
																	var geo = jsonTown[i];
																	districtOptions.push("<option value='"+geo.geoId+"'>"+geo.geoName+"</option>");
																}
																var append = "<select name='town'>" + districtOptions.join('') + "</select>";
																$("#append").html(append);
																$("select[name=town]").children("option[value="+json.town+"]").attr("selected",true);
															}
														}
													);
												
												
												}
											}
										);
									}
								}
							);
						}
					}
				);
				
				
			});
			
			$(document).on("click","#close",function(){
				$("#pop").addClass("hide");
				$("#mask").addClass("hide");
			});
		});
		
		function openPop(){
			$("#mask").removeClass("hide");
			$("#pop").removeClass("hide");
			var width = $(window).width();
			var height = $(window).height();
			var docWidth = $("#pop").width();
			var docHeight = $("#pop").height();
			var top = (height - docHeight)/2;
			if(top<0){
				top = 0;
			}
			$("#pop").css("top",top);
			var left = (width - docWidth)/2;
			if(left<0){
				left = 0;
			}
			$("#pop").css("left",left);
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
						<li><span>&gt;</span><a href="${ctx}/user/userAddress.action">收货地址</a></li>
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
							<div class="address-main">
								<div class="creation">
									<input name="newAddr" type="button" value="创建新地址" class="btn btn-assist">
									<p>您已经创建<span>${addrCount}</span>个收货地址，还可以创建<span>${20-addrCount}</span>个。</p>
								</div>
								<c:forEach items="${addrs}" var="addr" varStatus="var">
									<div class="address-mod">
										<div class="address-title">
											<c:choose>
												<c:when test="${addr.isDefault == '1'}">
													<h5>地址${var.count}：<a href="javascript:;" class="default">默认地址</a></h5>
												</c:when>
												<c:otherwise>
													<h5>地址${var.count}：<a addrId="${addr.addrId}" name="setDefault" href="javascript:;" class="">设为默认地址</a></h5>
												</c:otherwise>
											</c:choose>
											<div class="operation">
												<a name="modify" addrId="${addr.addrId}" href="javascript:;">修改</a>
												<a addrId="${addr.addrId}" href="javascript:;" name="del">删除</a>
											</div>
										</div>
										<table>
											<colgroup>
												<col width="87">
												<col>
											</colgroup>
											<tbody>
												<tr>
													<th>收件人：</th>
													<td><c:out value="${addr.receiver}" /></td>
												</tr>
												<tr>
													<th>详细地址：</th>
													<td>
														<c:out value="${addr.provinceName}" />
														<c:out value="${addr.cityName}" />
														<c:out value="${addr.districtName}" />
														<c:out value="${addr.townName}" />
														<c:out value="${addr.addr}" />
													</td>
												</tr>
												<tr>
													<th>邮政编码：</th>
													<td><c:out value="${addr.zipCode}" /></td>
												</tr>
												<tr>
													<th>手机号码：</th>
													<td><c:out value="${addr.mobile}" /></td>
												</tr>
												<tr>
													<th>固定电话：</th>
													<td><c:out value="${addr.tel}" /></td>
												</tr>
											</tbody>
										</table>
									</div>
								</c:forEach>
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
	<div id="pop" class="popup pop-addAddr popup-info hide" style="width: 998px">
		<div class="hd">
			<h2>收货地址</h2><i id="close" class="close"></i>
		</div>
		<div class="bd">
			<div class="shippingForm">
				<form class="form" id="form" action="${ctx}/user/addAddress.action" method="post">
					<fieldset>
						<input type="hidden" name="addrId" />
						<div class="lenged">收货人信息</div>
						<div class="formGroup">
							<div class="form-item">
								<div class="item-label"><label><em>*</em>收货地区：</label></div>
								<div class="item-cont">
									<input type="hidden" name="provinceName" />
									<select name="province">
										<option value="-1">--请选择--</option>
										<c:forEach items="${provinces}" var="pro">
											<option value="${pro.geoId}"><c:out value="${pro.geoName}" /></option>
										</c:forEach>
									</select>
									<input type="hidden" name="cityName" />
									<select name=city>
										<option value="-1">--请选择--</option>
									</select>
									<input type="hidden" name="districtName" />
									<select name="district">
										<option value="-1">--请选择--</option>
									</select>
									<input type="hidden" name="townName" />
									<div id="append"> 
										
									</div>
									<span id="errMsg1" class="note errTxt"></span>
								</div>
							</div>
							<div class="form-item">
								<div class="item-label"><label><em>*</em>详细地址：</label></div>
								<div class="item-cont">
									<textarea name="addr" id="" style="width: 288px;height: 72px" class="resize-none" placeholder="不用重复填写省市区，不超过50个字"></textarea><span id="errMsg2" class="note errTxt"></span>
								</div>
							</div>
							<div class="form-item">
								<div class="item-label"><label>邮政编码：</label></div>
								<div class="item-cont">
									<input name="zipCode" type="text" class="txt lg w-xl">
									<span id="errMsg3" class="note errTxt"></span>
								</div>
							</div>
							<div class="form-item">
								<div class="item-label"><label><em>*</em>收货人：</label></div>
								<div class="item-cont">
									<input name="receiver" type="text" class="txt lg w-xl" placeholder="不超过15个字" />
									<span id="errMsg4" class="note errTxt"></span>
								</div>
							</div>
							<div class="form-item">
								<div class="item-label"><label><em>*</em>手机号码：</label></div>
								<div class="item-cont">
									<input type="text" name="mobile" class="txt lg w-xl" placeholder="11位手机号码"><label class="or">或</label>
									<label class="fixedTel">固定电话：</label>
									<div class="txt-tel">
										<input name="telArea" type="text" class="txt telArea lg"><i>-</i>
										<input name="telNum" type="text" class="txt telNum lg"><i>-</i>
										<input name="telExt" type="text" class="txt telExt lg">
									</div>
									<span id="errMsg5" class="note errTxt"></span>
								</div>
							</div>
						</div>
						<div class="formGroup">
							<div class="form-item">
								<div class="item-cont">
									<label><input name="isDefault" type="checkbox" class="chk">设置为默认发货地址</label>
								</div>
							</div>
							<div class="form-item">
								<div class="item-cont">
									<input name="save" type="button" class="btn btn-primary" value="保存收货人信息">
								</div>
							</div>
						</div>
					</fieldset>
				</form>
			</div>
		</div>
	</div>
	<div id="mask" class="mask hide"></div>
</body>
</html>
