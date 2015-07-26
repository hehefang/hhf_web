<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@include file="/common/common.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<title>结算</title>
	<script type="text/javascript" src="${jsDomain}/jquery.min.js"></script>
	<script type="text/javascript" src="${jsDomain}/jquery.cookie.js"></script>
	<link rel="stylesheet" type="text/css" href="${cssDomain }/css/allstyle.css"/>
	<link rel="stylesheet" type="text/css" href="${cssDomain }/css/order.css"/>
	<script type="text/javascript">
		var choseaddrs = {};
		$(function(){
			hasError();
			getAddr();
			popupFix();
			$(window).scroll(popupFix);
			$(window).resize(popupFix);
			
			$("div.pro-mod").load("${ctx}/tradeGoods.action");
			
			$(document).on("click","div.pop-order div.hd i.close",function(){
				$("div.mask").addClass("hidden");
				$("div.pop-order").addClass("hidden");
			});
			$(document).on("mouseover","dl.mod-banks",function(){
				$("dl.mod-banks").addClass("hover");
			});
			$(document).on("mouseout","dl.mod-banks",function(){
				$("dl.mod-banks").removeClass("hover");
			});
			$(document).on("mouseover","div.selectArea",function(e){
				e.stopPropagation();
				$("div.selectArea").addClass("open");
			});
			$(document).on("mouseout","div.selectArea",function(){
				$("div.selectArea").removeClass("open");
			});
			$(document).on("click","div.selectArea li",function(){
				if($(this).hasClass("curr")) {
					return;
				} else {
					var name = $(this).attr("name");
					$("div.selectArea li.curr").removeClass("curr");
					$(this).addClass("curr");
					$("div.selectArea div.tabGroup").removeClass("show");
					$("div.selectArea div[name=" + name + "]").addClass("show");
				}
			});
			$(document).on("click","div.tabGroup a",function(){
				$("#addrForm div.inputArea").removeClass("errIpt");
				$("#addrForm span[name=geoErr]").text("");
				var geoId = $(this).attr("geoid");
				var level = $(this).parents("div.tabGroup").attr("name");
				var node = $(this);
				$.post(
					"${ctx}/geo.action",
					{
						fid:geoId
					},
					function(data){
						var geos = $.parseJSON(data);
						showGeo(node,level,geos);
					}
				);
			});
			$(document).on("change","#addrForm textarea[name=addr]",function(){
				$("#addrForm textarea[name=addr]").removeClass("errIpt");
				$("#addrForm span[name=addrErr]").text("");
			});
			$(document).on("change","#addrForm input[name=zipCode]",function(){
				$("#addrForm input[name=zipCode]").removeClass("errIpt");
				$("#addrForm span[name=zipCodeErr]").text("");
			});
			$(document).on("change","#addrForm input[name=receiver]",function(){
				$("#addrForm input[name=receiver]").removeClass("errIpt");
				$("#addrForm span[name=receiverErr]").text("");
			});
			$(document).on("change","#addrForm input[name=mobile]",function(){
				$("#addrForm input[name=mobile]").removeClass("errIpt");
				$("#addrForm span[name=mobileErr]").text("");
			});
			$(document).on("change","#addrForm input[name=tel1]",function(){
				$("#addrForm input[name=mobile]").removeClass("errIpt");
				$("#addrForm input[name=tel1]").removeClass("errIpt");
				$("#addrForm span[name=mobileErr]").text("");
			});
			$(document).on("change","#addrForm input[name=tel2]",function(){
				$("#addrForm input[name=mobile]").removeClass("errIpt");
				$("#addrForm input[name=tel2]").removeClass("errIpt");
				$("#addrForm span[name=mobileErr]").text("");
			});
			$(document).on("change","#addrForm input[name=tel3]",function(){
				$("#addrForm input[name=mobile]").removeClass("errIpt");
				$("#addrForm input[name=tel3]").removeClass("errIpt");
				$("#addrForm span[name=mobileErr]").text("");
			});
			
			$(document).on("click","input[name=saveAddr]",function(){
				var addrid = $("#addrForm input[name=addrid]").val();
				var province = $("#addrForm input[name=province]").val();
				var provinceName = $("#addrForm input[name=provinceName]").val();
				var city = $("#addrForm input[name=city]").val();
				var cityName = $("#addrForm input[name=cityName]").val();
				var district = $("#addrForm input[name=district]").val();
				var districtName = $("#addrForm input[name=districtName]").val();
				var town = $("#addrForm input[name=town]").val();
				var townName = $("#addrForm input[name=townName]").val();
				
				var addr = $("#addrForm textarea[name=addr]").val().trim();
				var zipCode = $("#addrForm input[name=zipCode]").val().trim();
				var receiver = $("#addrForm input[name=receiver]").val().trim();
				var mobile = $("#addrForm input[name=mobile]").val().trim();
				var tel1 = $("#addrForm input[name=tel1]").val().trim();
				var tel2 = $("#addrForm input[name=tel2]").val().trim();
				var tel3 = $("#addrForm input[name=tel3]").val().trim();
				var tel = "";
				if(!!tel1 && !!tel2){
					tel = tel1 + "-" + tel2;
					if(!!tel3) {
						tel = tel + "-" + tel3;
					}
				}
				var isDefault = "0";
				if($("#addrForm input[name=isDefault]").prop("checked")){
					isDefault = "1";
				}
				/**去前后空格**/
				$("#addrForm textarea[name=addr]").val(addr);
				$("#addrForm input[name=zipCode]").val(zipCode);
				$("#addrForm input[name=receiver]").val(receiver);
				$("#addrForm input[name=mobile]").val(mobile);
				$("#addrForm input[name=tel1]").val(tel1);
				$("#addrForm input[name=tel2]").val(tel2);
				$("#addrForm input[name=tel3]").val(tel3);
				
				if(!checkArea(province,city,district, town)){
					return false;
				}
				if(!checkAddr(addr)) {
					return false;
				}
				if(!checkZipCode(zipCode)) {
					return false;
				}
				if(!checkReceiver(receiver)) {
					return false;
				}
				/**手机电话check**/
				if(!mobile && !tel1 && !tel2 && !tel3) {
					$("#addrForm input[name=mobile]").focus();
					$("#addrForm input[name=mobile]").addClass("errIpt");
					$("#addrForm span[name=mobileErr]").text("请填写收货人的联系方式。");
					return false;
				}
				if(!checkMobile(mobile)) {
					return false;
				}
				if(!checkTel(tel1,tel2,tel3)) {
					return false;
				}
				var url = "";
				if(!!addrid){
					url = "${ctx}/updateAddr.action";
				} else {
					url = "${ctx}/addAddr.action";
				}
				$.post(
					url,
					{
						addrId: addrid,
						province: province,
						provinceName: provinceName,
						city: city,
						cityName: cityName,
						district: district,
						districtName: districtName,
						town: town,
						townName: townName,
						addr: addr,
						zipCode: zipCode,
						receiver: receiver,
						mobile: mobile,
						tel: tel,
						isDefault: isDefault 
					},
					function(res){
						if(res == -10) {
							alert("请登录");
						}else if(res <= 0) {
							alert("添加失败");
						}else {
							$("i.close").trigger("click");
							getAddr();
							cleardata();
						}
					}
				);
			});
			$(document).on("click","div.addressList input[name=userAddr]",function(){
				chgTradeAddr();
			});
			$(document).on("click","div.addressList a[name=update]",function(){
				var addrid = $(this).attr("addrid");
				filldata(addrid);
				var shippingForm = $("div.shippingForm");
				$("div.mask").removeClass("hidden");
				$("div.pop-addAddr").removeClass("hidden");
				$("div.pop-addAddr div.bd").append(shippingForm);
				popupFix();
			});
			$(document).on("click","div.addressList a[name=delete]",function(){
				var addrid = $(this).attr("addrid");
				$.post(
					"${ctx}/deleteAddr.action",
					{addrId:addrid},
					getAddr
				);
			});
			$(document).on("click","i.close",function(){
				$("div.mask").addClass("hidden");
				$("div.pop-addAddr").addClass("hidden");
				cleardata();
			});
			$(document).on("click","a[name=newAddr]",function(){
				if(!$(this).hasClass("disabled")) {
					var shippingForm = $("div.shippingForm");
					$("div.mask").removeClass("hidden");
					$("div.pop-addAddr").removeClass("hidden");
					$("div.pop-addAddr div.bd").append(shippingForm);
					popupFix();
				}
			});
			$(document).on("click","div.addrMore",function(){
				$("div.shippingAddr").addClass("unfold");
			});
			$(document).on("click","div.payMode input[name=payType]",function(){
				$("div.payMode input[name=payMode]").prop("checked",false);
				chgTradePayMode();
			});
			$(document).on("click","div.payMode input[name=payMode]",function(){
				if($(this).val().substring(0,1) == "1") {
					$("div.payMode input[name=payType][value=1]").prop("checked",true);
					var srcUrl = $(this).siblings("img").attr("src");
					$("div.payMode span.checkedBank").html("<img src='" + srcUrl + "'/>");
				} else {
					$("div.payMode input[name=payType][value=1]").prop("checked",false);
					$("div.payMode span.checkedBank").html("");
				}
				chgTradePayMode();
			});
			$(document).on("click","a.submitBtn",function(){
				if(!$("div.addressList input[name=userAddr]:checked").val()) {
					$("div.mask").removeClass("hidden");
					$("div.pop-order").removeClass("hidden");
					$("div.pop-order div.bd dd h2").text("请选择收货地址!");
					$("div.pop-order div.bd dd p a").text("");
					return false;
				} else {
					$("#dataForm input[name=payAddrId]").val($("div.addressList input[name=userAddr]:checked").val());
				}
				if(!$("div.payMode input[name=payMode]:checked").val()) {
					$("div.mask").removeClass("hidden");
					$("div.pop-order").removeClass("hidden");
					$("div.pop-order div.bd dd h2").text("请选择支付方式!");
					$("div.pop-order div.bd dd p a").text("");
					return false;
				}
				$("#dataForm").submit();
			});
		});
		function hasError() {
			if("${isEmpty}" == "true" || "${isAddrEmpty}" == "true" || "${hasError}" == "true"){
				$("div.mask").removeClass("hidden");
				$("div.pop-order").removeClass("hidden");
				$("div.pop-order div.bd dd h2").text("您还没有选择商品，请选择您要结算的商品!");
				$("div.pop-order div.bd dd p a").text("返回购物车修改 <em>&gt;</em>");
			} else {
				$("div.mask").addClass("hidden");
				$("div.pop-order").addClass("hidden");
			}
		}
		function getAddr() {
			$.post(
				"${ctx}/getAddr.action",
				{},
				function(data){
					var addrs = $.parseJSON(data);
					if(addrs.length > 0){
						$("div.shippingAddr").removeClass("noAddress");
						displayAddrs(addrs);
					} else {
						var shippingForm = $("div.shippingForm");
						$("div.shippingAddr div.bd").append(shippingForm);
						$("div.shippingAddr").addClass("noAddress");
						displayAddrs(addrs);
					}
				}
			);
		}
		function displayAddrs(addrs) {
			var htmlStr = "";
			var defaultId = "";
			for (var index in addrs) {
				htmlStr += getaddrhtml(addrs[index]);
				choseaddrs["a"+addrs[index].addrId] = addrs[index];
				if(addrs[index].isDefault == "1") {
					defaultId = addrs[index].addrId;
				}
			}
			$("div.addressList ul").html(htmlStr);
			if(!!defaultId) {
				var defaultAddr = $("div.addressList ul li input[value=" + defaultId + "]").parents("li");
				 $("div.addressList ul").children().first().before(defaultAddr);
			} else {
				$("div.addressList ul").children().first().find("input:radio").prop("checked",true);
			}
			if(addrs.length > 4) {
				$("div.shippingAddr").removeClass("unfold");
			} else {
				$("div.shippingAddr").addClass("unfold");
			}
			if(addrs.length > 19) {
				$("div.shippingAddr a[name=newAddr]").addClass("disabled");
			} else {
				$("div.shippingAddr a[name=newAddr]").removeClass("disabled");
			}
			chgTradeAddr();
		}
		function getaddrhtml(addr){
			var str = "<li class='addr-item'>" + 
				"<label>";
			if("1" == addr.isDefault) {
				str += "<input value='" + addr.addrId + "' type='radio' class='radio' name='userAddr' checked>" +
				"<span class='defAddr'>默认地址</span>";
			} else {
				str += "<input value='" + addr.addrId + "' type='radio' class='radio' name='userAddr'>";
			}
			str += "<span>" + addr.receiver + "</span>" +
					"<span>" + addr.provinceName + addr.cityName + addr.districtName + addr.townName + addr.addr + "</span>" +
					"<span>" + (!!addr.mobile ? addr.mobile : addr.tel) + "</span>" +
				"</label>" +
				"<span class='setlink'><a name='update' addrid='" + addr.addrId + "' href='javascript:;'>修改</a>" +
				"<a name='delete' addrid='" + addr.addrId + "' href='javascript:;'>删除</a></span>" +
			"</li>";
			return str;
		}
		function showGeo(node,level,geos) {
			if(level=="province") {
				$("div.selectArea input[name=province]").val($(node).attr("geoid"));
				$("div.selectArea input[name=provinceName]").val($(node).text());
				$("div.selectArea input[name=city]").val("");
				$("div.selectArea input[name=cityName]").val("");
				$("div.selectArea input[name=district]").val("");
				$("div.selectArea input[name=districtName]").val("");
				$("div.selectArea input[name=town]").val("");
				$("div.selectArea input[name=townName]").val("");
				
				$("div.selectArea li.curr").removeClass("curr");
				$("div.selectArea li[name=city]").addClass("curr");
				$("div.selectArea div.tabGroup").removeClass("show");
				$("div.selectArea li[name=town]").addClass("hidden");
				$("div.selectArea div[name=city]").addClass("show");
				var obj = $("div.selectArea div[name=city] dl dd");
				showGeoList(obj,geos);
			} else if(level=="city") {
				$("div.selectArea input[name=city]").val($(node).attr("geoid"));
				$("div.selectArea input[name=cityName]").val($(node).text());
				$("div.selectArea input[name=district]").val("");
				$("div.selectArea input[name=districtName]").val("");
				$("div.selectArea input[name=town]").val("");
				$("div.selectArea input[name=townName]").val("");
				
				$("div.selectArea li.curr").removeClass("curr");
				$("div.selectArea li[name=district]").addClass("curr");
				$("div.selectArea div.tabGroup").removeClass("show");
				$("div.selectArea li[name=town]").addClass("hidden");
				$("div.selectArea div[name=district]").addClass("show");
				var obj = $("div.selectArea div[name=district] dl dd");
				showGeoList(obj,geos);
			} else if(level=="district") {
				$("div.selectArea input[name=district]").val($(node).attr("geoid"));
				$("div.selectArea input[name=districtName]").val($(node).text());
				$("div.selectArea input[name=town]").val("");
				$("div.selectArea input[name=townName]").val("");
				if(geos.length > 0){
					$("div.selectArea li.curr").removeClass("curr");
					$("div.selectArea li[name=town]").addClass("curr");
					$("div.selectArea li[name=town]").removeClass("hidden");
					$("div.selectArea div.tabGroup").removeClass("show");
					$("div.selectArea div[name=town]").addClass("show");
					var obj = $("div.selectArea div[name=town] dl dd");
					showGeoList(obj,geos);
				} else {
					$("div.selectArea").removeClass("open");
					$("div.selectArea li[name=town]").addClass("hidden");
				}
			} else if(level=="town") {
				$("div.selectArea input[name=town]").val($(node).attr("geoid"));
				$("div.selectArea input[name=townName]").val($(node).text());
				$("div.selectArea").removeClass("open");
			}
			showGeoText();
		}
		function showGeoText() {
			var province = $("div.selectArea input[name=provinceName]").val();
			var city = $("div.selectArea input[name=cityName]").val();
			var district = $("div.selectArea input[name=districtName]").val();
			var town = $("div.selectArea input[name=townName]").val();
 			
			var txtNode = $("div.selectArea div.inputArea");
			txtNode.html("<span class='arrow bottom-hollow'><i></i><b></b></span>");
 			if(!!province) {
 				txtNode.append("<span class='option'>" + province + "</span>");
 			}
 			if(!!city) {
 				txtNode.append("<em>/</em><span class='option'>" + city + "</span>");
 			}
 			if(!!district) {
 				txtNode.append("<em>/</em><span class='option'>" + district + "</span>");
 			}
 			if(!!town) {
 				txtNode.append("<em>/</em><span class='option'>" + town + "</span>");
 			}
		}
		function showGeoList(obj,geos){
			var html = "";
			for(var index in geos) {
				html += "<span><a geoid='" + geos[index].geoId + "' href='javascript:;'>" + geos[index].geoName + "</a></span>";
			}
			$(obj).html(html);
		}
		function checkArea(province,city,district, town) {
			/**区域check**/
			if(!province || !city || !district) {
				$("#addrForm div.inputArea").addClass("errIpt");
				$("#addrForm span[name=geoErr]").text("请选择收货地区。");
				return false;
			}
			if(!$("div.selectArea li[name=town]").hasClass("hidden")){
				if(!town){
					$("#addrForm div.inputArea").addClass("errIpt");
					$("#addrForm span[name=geoErr]").text("请选择收货地区。");
					return false;
				}
			}
			return true;
		}
		function checkAddr(addr) {
			/**地址check**/
			if(!addr) {
				$("#addrForm textarea[name=addr]").focus();
				$("#addrForm textarea[name=addr]").addClass("errIpt");
				$("#addrForm span[name=addrErr]").text("请填写收货详细地址。");
				return false;
			} else {
				if(addr.length > 50) {
					$("#addrForm textarea[name=addr]").focus();
					$("#addrForm textarea[name=addr]").addClass("errIpt");
					$("#addrForm span[name=addrErr]").text("收货地址过长。");
					return false;
				}
			}
			return true;
		}
		function checkZipCode(zipCode) {
			var pattern = /^\d{6}$/;
			if(!!zipCode && !pattern.exec(zipCode)) {
				$("#addrForm input[name=zipCode]").focus();
				$("#addrForm input[name=zipCode]").addClass("errIpt");
				$("#addrForm span[name=zipCodeErr]").text("请填写6位数字邮政编码。");
				return false;
			}
			return true;
		}
		function checkReceiver(receiver) {
			/**收货人check**/
			if(!receiver){
				$("#addrForm input[name=receiver]").focus();
				$("#addrForm input[name=receiver]").addClass("errIpt");
				$("#addrForm span[name=receiverErr]").text("请填写收货人姓名。");
				return false;
			} else {
				if(receiver.length > 15) {
					$("#addrForm input[name=receiver]").focus();
					$("#addrForm input[name=receiver]").addClass("errIpt");
					$("#addrForm span[name=receiverErr]").text("收货人姓名过长。");
					return false;
				}
			}
			return true;
		}
		function checkMobile(mobile) {
			var pattern = /^1\d{10}$/;
			if(!!mobile && !pattern.exec(mobile)) {
				$("#addrForm input[name=mobile]").focus();
				$("#addrForm input[name=mobile]").addClass("errIpt");
				$("#addrForm span[name=mobileErr]").text("请正确填写11位手机号。");
				return false;
			}
			return true;
		}
		function checkTel(tel1,tel2,tel3) {
			if(!tel1 && !tel2 && !tel3) {
				return true;
			} else {
				var patternTel1 = /^\d{3,4}$/;
				var patternTel2 = /^\d{7,8}$/;
				var patternTel3 = /^\d{4}$/;
				if(!patternTel1.exec(tel1)){
					$("#addrForm input[name=tel1]").focus();
					$("#addrForm input[name=tel1]").addClass("errIpt");
					$("#addrForm span[name=mobileErr]").text("请正确填写电话号码。");
					return false;
				}
				if(!patternTel2.exec(tel2)){
					$("#addrForm input[name=tel2]").focus();
					$("#addrForm input[name=tel2]").addClass("errIpt");
					$("#addrForm span[name=mobileErr]").text("请正确填写电话号码。");
					return false;
				}
				if(!!tel3 && !patternTel3.exec(tel3)){
					$("#addrForm input[name=tel3]").focus();
					$("#addrForm input[name=tel3]").addClass("errIpt");
					$("#addrForm span[name=mobileErr]").text("请正确填写电话号码。");
					return false;
				}
				return true;
			}
		}
		function cleardata() {
			$("#addrForm li.curr").removeClass("curr");
			$("#addrForm li[name=province]").addClass("curr");
			$("#addrForm li[name=town]").addClass("hidden");
			$("#addrForm div.tabGroup.show").removeClass("show");
			$("#addrForm div[name=province]").addClass("show");

			$("#addrForm input[name=addrid]").val("");
			$("#addrForm div.inputArea").html("<span class='arrow bottom-hollow'><i></i><b></b></span>");
			$("#addrForm input[name=province]").val("");
			$("#addrForm input[name=provinceName]").val("");
			$("#addrForm input[name=city]").val("");
			$("#addrForm input[name=cityName]").val("");
			$("#addrForm input[name=district]").val("");
			$("#addrForm input[name=districtName]").val("");
			$("#addrForm input[name=town]").val("");
			$("#addrForm input[name=townName]").val("");
			$("#addrForm textarea[name=addr]").val("");
			$("#addrForm input[name=zipCode]").val("");
			$("#addrForm input[name=receiver]").val("");
			$("#addrForm input[name=mobile]").val("");
			$("#addrForm input[name=tel1]").val("");
			$("#addrForm input[name=tel2]").val("");
			$("#addrForm input[name=tel3]").val("");
			$("#addrForm input[name=isDefault]").prop("checked",false);
		}
		function filldata(addrid) {
			var addr = choseaddrs["a"+addrid];

			showAllArea(addr);
			
			$("#addrForm input[name=addrid]").val(addr.addrId);
			$("#addrForm textarea[name=addr]").val(addr.addr);
			$("#addrForm input[name=zipCode]").val(addr.zipCode);
			$("#addrForm input[name=receiver]").val(addr.receiver);
			$("#addrForm input[name=mobile]").val(addr.mobile);
			$("#addrForm input[name=tel1]").val(addr.tel.split("-")[0]);
			$("#addrForm input[name=tel2]").val(addr.tel.split("-")[1]);
			$("#addrForm input[name=tel3]").val(addr.tel.split("-")[2]);
			if(addr.isDefault == "1") {
				$("#addrForm input[name=isDefault]").prop("checked",true);
			}
		}
		function showAllArea(addr) {
			$("#addrForm input[name=province]").val(addr.province);
			$("#addrForm input[name=provinceName]").val(addr.provinceName);
			$("#addrForm input[name=city]").val(addr.city);
			$("#addrForm input[name=cityName]").val(addr.cityName);
			$("#addrForm input[name=district]").val(addr.district);
			$("#addrForm input[name=districtName]").val(addr.districtName);
			$("#addrForm input[name=town]").val(addr.town);
			$("#addrForm input[name=townName]").val(addr.townName);
			showGeoText();
			if(!!addr.city){
				$.post(
					"${ctx}/geo.action",
					{
						fid:addr.province
					},
					function(data){
						var geos = $.parseJSON(data);
						var obj = $("#addrForm div.tabGroup[name=city] dl dd");
						showGeoList(obj,geos);
					}
				);
			}
			if(!!addr.district){
				$.post(
					"${ctx}/geo.action",
					{
						fid:addr.city
					},
					function(data){
						var geos = $.parseJSON(data);
						var obj = $("#addrForm div.tabGroup[name=district] dl dd");
						showGeoList(obj,geos);
					}
				);
			}
			if(!!addr.town){
				$.post(
					"${ctx}/geo.action",
					{
						fid:addr.district
					},
					function(data){
						var geos = $.parseJSON(data);
						var obj = $("#addrForm div.tabGroup[name=town] dl dd");
						showGeoList(obj,geos);
					}
				);
			}
			if(!!addr.town) {
				$("#addrForm li.curr").removeClass("curr");
				$("#addrForm li[name=town]").addClass("curr");
				$("#addrForm li[name=town]").removeClass("hidden");
				$("#addrForm div.tabGroup.show").removeClass("show");
				$("#addrForm div.tabGroup[name=town]").addClass("show");
			} else {
				$("#addrForm li.curr").removeClass("curr");
				$("#addrForm li[name=district]").addClass("curr");
				$("#addrForm li[name=town]").addClass("hidden");
				$("#addrForm div.tabGroup.show").removeClass("show");
				$("#addrForm div.tabGroup[name=district]").addClass("show");
			}
		}
		function chgTradeAddr() {
			var selAddrId = $("div.addressList input[name=userAddr]:checked").val();
			var html = "";
			if(!!selAddrId) {
				var addr = choseaddrs["a" + selAddrId];
				html = "<b>收货信息：</b>";
				html += "<span>" + addr.receiver + "</span><span class='address'>" + 
						addr.provinceName + addr.cityName + addr.districtName + addr.townName + addr.addr + "</span><span>" + 
						(addr.mobile ? addr.mobile : addr.tel) + "</span>";
			} else {
				html = "<b>收货信息：</b><span class='warnColor'>尚未选择收货信息</span>";
			}
			$("div.orderSubmit div.shippingInfo").html(html);
		}
		function chgTradePayMode() {
			var html = "";
			if("1" == $("div.payMode input[name=payType]:checked").val()) {
				$("dl.pay-item.bank").addClass("selected");
				$("dl.pay-item.alipay").removeClass("selected");
				html += "<b>支付方式：</b><span>网上银行</span>";
				$("dl.mod-banks").addClass("hover");
			} else {
				$("dl.pay-item.bank").removeClass("selected");
				$("dl.pay-item.alipay").addClass("selected");
				html += "<b>支付方式：</b><span>支付宝</span>";
				$("dl.mod-banks").removeClass("hover");
			}
			$("div.orderSubmit div.checkedPay").html(html);
		}
		function showTradePrice() {
			var priceTotal = 0;
			$("div.pro-mod div.merchBill").each(function(){
				var storeTotal = 0;
				$(this).find("div[name=item]").each(function(){
					var subTotal = $(this).find("p.subtotal").text().substring(1);
					storeTotal = floatAdd(storeTotal, subTotal);
				});
				$(this).find("td.storeTotal span[name=storeTotal]").html("此订单合计：" + storeTotal.toFixed(2) + "元");
				priceTotal = floatAdd(priceTotal, storeTotal);
			});
			$("div.orderSubmit div.priceTotal em[name=priceTotal]").text(priceTotal.toFixed(2));
		}
		function floatAdd(arg1, arg2) {
			var r1, r2, m;
			try {
				r1 = arg1.toString().split(".")[1].length;
			} catch (e) {
				r1 = 0;
			}
			try {
				r2 = arg2.toString().split(".")[1].length;
			} catch (e) {
				r2 = 0;
			}
			m = Math.pow(10, Math.max(r1, r2));
			return (arg1 * m + arg2 * m) / m;
		}
		function popupFix(){
			var scrollTop = $(document).scrollTop();
			var scrollLeft = $(document).scrollLeft();
			var screenHeight = $(window).height();
			var screenWidth = $(window).width();
			$("div.popup").each(function(){
				var height = $(this).height();
				var width = $(this).width();
				var top = scrollTop+(screenHeight-height)/2;
				var left = scrollLeft+(screenWidth-width)/2;
				$(this).css("top",top>scrollTop ? top : scrollTop);
				$(this).css("left",left>scrollLeft ? left : scrollLeft);
				$(this).css("margin-left", 0);
				$(this).css("margin-top", 0);
			});
		}
	</script>
</head>
<body>
	<div class="wrapper">
		<jsp:include page="/common/head.jsp">
			<jsp:param name="hideMiniCart" value="1"/>   
		</jsp:include>
		<!-- container -->
		<div id="container">
			<div class="wrap">
				<!-- cartList -->
				<div class="cartList">
					<div class="hd">
						<h2><i class="icon i-menu"></i>确认订单</h2>
						<ul class="mod-step">
							<li class="first over">
								<i class="num">1</i>
								<p class="text">购物车</p>
							</li>
							<li class="now">
								<i class="num">2</i>
								<span class="strip"></span>
								<span class="strip-over"></span>
								<p class="text">确认订单</p>
							</li>
							<li class="">
								<i class="num">3</i>
								<span class="strip"></span>
								<span class="strip-over"></span>
								<p class="text">在线支付</p>
							</li>
							<li class="last">
								<i class="num">4</i>
								<span class="strip"></span>
								<span class="strip-over"></span>
								<p class="text">完成</p>
							</li>
						</ul>
					</div>
					<div class="bd">
						<div class="shippingAddr noAddress"><!--给shippingAddr添加class 'unfold'以展开全部地址,第一次添加地址class加 'noAddress'-->
							<div class="wrap">
								<div class="hd"><h3>收货地址</h3><span>新增收货地址</span></div>
								<div class="bd">
									<div class="shippingForm">
<!-- 											TODO -->
										<form autocomplete="off" id="addrForm" class="form">
											<fieldset>
												<div class="lenged">收货人信息</div>
												<div class="formGroup">
													<input name="addrid" type="hidden" />
													<div class="form-item">
														<div class="item-label"><label><em>*</em>收货地区：</label></div>
														<div class="item-cont">
															<div class="selectArea">
																<div class="inputArea"><span class="arrow bottom-hollow"><i></i><b></b></span></div>
																<input name="province" type="hidden"/>
																<input name="provinceName" type="hidden"/>
																<input name="city" type="hidden"/>
																<input name="cityName" type="hidden"/>
																<input name="district" type="hidden"/>
																<input name="districtName" type="hidden"/>
																<input name="town" type="hidden"/>
																<input name="townName" type="hidden"/>
																<div class="selectArea-list">
																	<div class="tab">
																		<div class="tabs">
																			<ul>
																				<li name="province" class="curr">省份</li>
																				<li name="city">城市</li>
																				<li name="district">区县</li>
																				<li name="town" class="hidden">街道</li>
																			</ul>
																		</div>
																		<div class="tabbed">
																			<div name="province" class="tabGroup show">
																				<dl class="areaList">
																					<dt>A<em>-</em>G</dt>
																					<dd>
																						<span><a geoid="1219" href="javascript:;">安徽</a></span>
																						<span><a geoid="1" href="javascript:;">北京</a></span>
																						<span><a geoid="2843" href="javascript:;">重庆</a></span>
																						<span><a geoid="1341" href="javascript:;">福建</a></span>
																						<span><a geoid="4552" href="javascript:;">甘肃</a></span>
																						<span><a geoid="2224" href="javascript:;">广东</a></span>
																						<span><a geoid="2425" href="javascript:;">广西</a></span>
																						<span><a geoid="4109" href="javascript:;">贵州</a></span>
																					</dd>
																				</dl>
																				<dl class="areaList">
																					<dt>H<em>-</em>K</dt>
																					<dd>
																						<span><a geoid="2549" href="javascript:;">海南</a></span>
																						<span><a geoid="150" href="javascript:;">河北</a></span>
																						<span><a geoid="764" href="javascript:;">黑龙江</a></span>
																						<span><a geoid="1706" href="javascript:;">河南</a></span>
																						<span><a geoid="1884" href="javascript:;">湖北</a></span>
																						<span><a geoid="2087" href="javascript:;">湖南</a></span>
																						<span><a geoid="999" href="javascript:;">江苏</a></span>
																						<span><a geoid="1436" href="javascript:;">江西</a></span>
																						<span><a geoid="694" href="javascript:;">吉林</a></span>
																					</dd>
																				</dl>
																				<dl class="areaList">
																					<dt>L<em>-</em>S</dt>
																					<dd>
																						<span><a geoid="579" href="javascript:;">辽宁</a></span>
																						<span><a geoid="465" href="javascript:;">内蒙古</a></span>
																						<span><a geoid="4708" href="javascript:;">宁夏</a></span>
																						<span><a geoid="4656" href="javascript:;">青海</a></span>
																						<span><a geoid="1548" href="javascript:;">山东</a></span>
																						<span><a geoid="906" href="javascript:;">上海</a></span>
																						<span><a geoid="334" href="javascript:;">山西</a></span>
																						<span><a geoid="4434" href="javascript:;">陕西</a></span>
																						<span><a geoid="3906" href="javascript:;">四川</a></span>
																					</dd>
																				</dl>
																				<dl class="areaList">
																					<dt>T<em>-</em>Z</dt>
																					<dd>
																						<span><a geoid="99" href="javascript:;">天津</a></span>
																						<span><a geoid="4736" href="javascript:;">新疆</a></span>
																						<span><a geoid="4353" href="javascript:;">西藏</a></span>
																						<span><a geoid="4207" href="javascript:;">云南</a></span>
																						<span><a geoid="1117" href="javascript:;">浙江</a></span>
																					</dd>
																				</dl>
																			</div>
																			<div name="city" class="tabGroup city">
																				<dl class="areaList">
																					<dd>
																					</dd>
																				</dl>
																			</div>
																			<div name="district" class="tabGroup city">
																				<dl class="areaList">
																					<dd>
																					</dd>
																				</dl>
																			</div>
																			<div name="town" class="tabGroup city">
																				<dl class="areaList">
																					<dd>
																					</dd>
																				</dl>
																			</div>
																		</div>
																	</div>
																</div>
															</div>
															<span name="geoErr" class="note errTxt"></span>
														</div>
													</div>
													<div class="form-item">
														<div class="item-label"><label><em>*</em>详细地址：</label></div>
														<div class="item-cont">
															<textarea name="addr" id="" style="width: 288px;height: 72px" class="resize-none" placeholder="不用重复填写省市区，不超过50个字"></textarea>
															<span name="addrErr" class="note errTxt"></span>
														</div>
													</div>
													<div class="form-item">
														<div class="item-label"><label>邮政编码：</label></div>
														<div class="item-cont">
															<input name="zipCode" type="text" class="txt lg w-xl">
															<span name="zipCodeErr" class="note errTxt"></span>
														</div>
													</div>
													<div class="form-item">
														<div class="item-label"><label><em>*</em>收货人：</label></div>
														<div class="item-cont">
															<input name="receiver" type="text" class="txt lg w-xl" placeholder="不超过15个字">
															<span name="receiverErr" class="note errTxt"></span>
														</div>
													</div>
													<div class="form-item">
														<div class="item-label"><label><em>*</em>手机号码：</label></div>
														<div class="item-cont">
															<input name="mobile" type="text" class="txt lg w-xl" placeholder="11位手机号码">
															<label class="or">或</label><label class="fixedTel">固定电话：</label>
															<div class="txt-tel">
																<input name="tel1" type="text" class="txt telArea lg">
																<i>-</i><input name="tel2" type="text" class="txt telNum lg">
																<i>-</i><input name="tel3" type="text" class="txt telExt lg">
															</div>
															<div>
																<span name="mobileErr" class="note errTxt"></span>
															</div>
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
															<input name="saveAddr" type="button" class="btn btn-primary" value="保存收货人信息">
														</div>
													</div>
												</div>
											</fieldset>
										</form>
									</div>
									<div class="addressList">
										<ul> </ul>
									</div>
									<div class="addrMore"><span class="btn btn-def more">其他收货地址<span class="arrow bottom-hollow"><b></b><i></i></span></span></div>
									<div class="btnWrap"><a name="newAddr" href="javascript:;" class="btn btn-assist p-lg">+ 使用新地址</a></div>
								</div>
							</div>
						</div>
						<form id="dataForm" action="${ctx}/tradecomfirm.action" method="post">
							<!-- pay mode -->
							<div class="payMode">
								<div class="wrap">
									<div class="hd"><h3>支付方式</h3></div>
									<div class="bd">
										<dl class="pay-item alipay selected">
											<dt><label><input type="radio" class="radio" name="payMode" value="20" checked="checked" />支付宝在线付款</label></dt>
											<dd><span class="ico alipay"><img src="${imgDomain }/pay/alipay.jpg" alt="" /></span>使用支付宝账号在线付款。</dd>
										</dl>
										<dl class="pay-item bank" style="display:none;">
											<dt><label><input type="radio" class="radio" name="payType" value="1" disabled="disabled"/>网上银行在线付款</label></dt>
											<dd>
												<span class="ico checkedBank"></span>
												<dl class="mod-banks"><!-- 鼠标移上加class=hover -->
													<dt><span class="btn btn-def">选择支付银行<i class="arrow bottom-solid sm muted"></i></span></dt>
													<dd>
														<div class="bank-item"><label><input type="radio" class="radio" name="payMode" id="" value="10" disabled="disabled"/><img src="${imgDomain }/pay/icbc.jpg" alt="" /></label></div>
														<div class="bank-item"><label><input type="radio" class="radio" name="payMode" id="" value="11" disabled="disabled"/><img src="${imgDomain }/pay/abc.jpg" alt="" /></label></div>
														<div class="bank-item"><label><input type="radio" class="radio" name="payMode" id="" value="12" disabled="disabled"/><img src="${imgDomain }/pay/boc.jpg" alt="" /></label></div>
														<div class="bank-item"><label><input type="radio" class="radio" name="payMode" id="" value="13" disabled="disabled"/><img src="${imgDomain }/pay/cbc.jpg" alt="" /></label></div>
														<div class="bank-item"><label><input type="radio" class="radio" name="payMode" id="" value="14" disabled="disabled"/><img src="${imgDomain }/pay/ctb.jpg" alt="" /></label></div>
														<div class="bank-item"><label><input type="radio" class="radio" name="payMode" id="" value="15" disabled="disabled"/><img src="${imgDomain }/pay/cmb.jpg" alt="" /></label></div>
														<div class="bank-item"><label><input type="radio" class="radio" name="payMode" id="" value="16" disabled="disabled"/><img src="${imgDomain }/pay/ceb.jpg" alt="" /></label></div>
														<div class="bank-item"><label><input type="radio" class="radio" name="payMode" id="" value="17" disabled="disabled"/><img src="${imgDomain }/pay/citic.jpg" alt="" /></label></div>
														<div class="bank-item"><label><input type="radio" class="radio" name="payMode" id="" value="18" disabled="disabled"/><img src="${imgDomain }/pay/cmbc.jpg" alt="" /></label></div>
														<div class="bank-item"><label><input type="radio" class="radio" name="payMode" id="" value="19" disabled="disabled"/><img src="${imgDomain }/pay/sdb.jpg" alt="" /></label></div>
														<div class="bank-item"><label><input type="radio" class="radio" name="payMode" id="" value="1a" disabled="disabled"/><img src="${imgDomain }/pay/hxb.jpg" alt="" /></label></div>
														<div class="bank-item"><label><input type="radio" class="radio" name="payMode" id="" value="1b" disabled="disabled"/><img src="${imgDomain }/pay/cgb.jpg" alt="" /></label></div>
														<div class="bank-item"><label><input type="radio" class="radio" name="payMode" id="" value="1c" disabled="disabled"/><img src="${imgDomain }/pay/spdb.jpg" alt="" /></label></div>
														<div class="bank-item"><label><input type="radio" class="radio" name="payMode" id="" value="1d" disabled="disabled"/><img src="${imgDomain }/pay/cib.jpg" alt="" /></label></div>
														<div class="bank-item"><label><input type="radio" class="radio" name="payMode" id="" value="1e" disabled="disabled"/><img src="${imgDomain }/pay/psbc.jpg" alt="" /></label></div>
														<div class="bank-item"><label><input type="radio" class="radio" name="payMode" id="" value="1f" disabled="disabled"/><img src="${imgDomain }/pay/bea.jpg" alt="" /></label></div>
													</dd>
												</dl>使用您的网上银行借记卡及部分银行信用卡进行支付。
											</dd>
										</dl>
									</div>
								</div>
							</div>
							<!-- pay mode end -->
							<div class="pro-mod">加载中。。。。</div>
							<!-- order submit -->
							<div class="orderSubmit">
								<div class="submit-box">
									<div class="shippingInfo"><b>收货信息：</b><span class="warnColor">尚未选择收货信息</span></div>
									<div class="priceTotal payTotal"><b>实付金额：</b><span>&yen;<em name="priceTotal">3184.00</em></span></div>
									<div class="checkedPay"><b>支付方式：</b><span>支付宝</span></div>
								</div>
								<a href="#" class="btn btn-primary submitBtn">提交订单</a>
							</div>
							<!-- order submit end -->
							<input type="hidden" name="payAddrId" />
						</form>
					</div>
				</div>
				<!-- cartList end -->
			</div>
		</div>
		<jsp:include page="/common/foot.html" />
	</div>
	<div class="popup popup-info pop-order" style="width: 800px;">
		<div class="hd">
			<i class="close"></i>
		</div>
		<div class="bd">
			<div class="order-delivery">
				<dl>
					<dt><i class="icon i-dangerXL"></i></dt>
					<dd>
						<h2 style="width: 510px;">订单中的部分商品已经失效或者缺货，本次交易无法正常继续，请返回购物车确认商品后重新提交。</h2>
						<p><a href="${ctx}/cart/cart.action" class="returnModify">返回购物车修改 <em>&gt;</em></a></p>
					</dd>
				</dl>
			</div>
		</div>
	</div>
	<div class="popup pop-addAddr popup-info hidden" style="width: 998px; top: 0px;">
		<div class="hd">
			<h2>收货地址</h2><i class="close"></i>
		</div>
		<div class="bd">
			
		</div>
	</div>
	<div class="mask hidden"></div>
</body>
</html>