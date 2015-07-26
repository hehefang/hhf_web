<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@include file="/common/common.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<title>购物车</title>
	<script type="text/javascript" src="${jsDomain}/jquery.min.js"></script>
	<script type="text/javascript" src="${jsDomain}/jquery.cookie.js"></script>
	<link rel="stylesheet" type="text/css" href="${cssDomain }/css/allstyle.css"/>
	<link rel="stylesheet" type="text/css" href="${cssDomain }/css/order.css"/>
	<script type="text/javascript">
		$(function(){
			totalTop = 0;
			$(window).scroll(totalFloat);
			$(window).resize(totalFloat);
			$.cookie("tradesubmit", null, {
				expires : -1
			});
			$("div.cart-show").load("${ctx}/cart/cartContent.action?dt=" + new Date().getTime());
			
			$(document).on("click","a.submitBtn",function() {
				$.getJSON("${ctx}/cart/validCartConfirm.action", function(res) {
					if(res.isEmpty || res.hasError) {
						$("div.cart-show").load("${ctx}/cart/cartContent.action?dt=" + new Date().getTime(),{
							isEmpty: res.isEmpty,
							hasError: res.hasError
						});
					} else {
						location.href = "${ctx}/trade.action";
					}
				});
			});
			$(document).on("click","input.chk", function(){
				if($(this).prop("name") == "allChecked"){
					var checked = $(this).prop("checked");
					$("input.chk").prop("checked", checked);
					
					var bsDetailIds = [];
					$("input[name=item]").each(function(){
						bsDetailIds.push($(this).attr("bsDetailId"));
					});
					$.post(
							"${ctx}/cart/chgChecked.action",
							{
								bsDetailIds:bsDetailIds.join(","),
								checked:checked
							},
							null
						);
				}else if ($(this).prop("name") == "order") {
					var checked = $(this).prop("checked");
					$(this).parents("div[name=order]").find("input[name=item]").prop("checked",checked);
					setChecked();
					
					var bsDetailIds = [];
					$(this).parents("div[name=order]").find("input[name=item]").each(function(){
						bsDetailIds.push($(this).attr("bsDetailId"));
					});
					$.post(
							"${ctx}/cart/chgChecked.action",
							{
								bsDetailIds:bsDetailIds.join(","),
								checked:checked
							},
							null
						);
					
				}else if ($(this).prop("name") == "item") {
					var checked = $(this).prop("checked");
					var bsDetailId = $(this).attr("bsDetailId");
					$.post(
						"${ctx}/cart/chgChecked.action",
						{
							bsDetailIds:bsDetailId,
							checked:checked
						},
						null
					);
					setChecked();
				}
				showTotal();
			});
			
			$(document).on("click","a[name=delete]",function(){
				var bsDetailId = $(this).attr("bsDetailId");
				$("div.cart-show").load(
					"${ctx}/cart/delete.action",
					{bsDetailId: bsDetailId}
				);
			});
			
			$(document).on("click","#delAll",function(){
				var bsDetailIds = [];
				$("input[name=item]").each(function(){
					if($(this).prop("checked")){
						bsDetailIds.push($(this).attr("bsDetailId"));
					}
				});
				$("div.cart-show").load(
					"${ctx}/cart/deleteSelected.action",
					{bsDetailIds: bsDetailIds.join(",")}
				);
			});
			
			$(document).on("click","#clear",function(){
				$("div.cart-show").load("${ctx}/cart/clearFailure.action");
			});
			
			$(document).on("change","input.sm",function(){
				chgNum(this);
			});
			
			$(document).on("click", "div.plus", function() {
				if ($(this).hasClass("disabled")) {
					return;
				}
				var obj = $(this).siblings("input.sm");
				var num = obj.val();
				num++;
				if (!validNum(num, obj)) {
					return;
				}
				obj.val(num);
			});
			$(document).on("click", "div.minus", function() {
				if ($(this).hasClass("disabled")) {
					return;
				}
				var obj = $(this).siblings("input.sm");
				var num = obj.val();
				num--;
				if (!validNum(num, obj)) {
					return;
				}
				obj.val(num);
			});
			$(document).on("mouseout", "div.plus", function() {
				var obj = $(this).siblings("input.sm");
				var num = obj.val();
				var oldNum = $(obj).siblings("input.oldNum").val();
				if (num == oldNum) {
					return;
				}
				chgNum(obj);
			});
			$(document).on("mouseout", "div.minus", function() {
				var obj = $(this).siblings("input.sm");
				var num = obj.val();
				var oldNum = $(obj).siblings("input.oldNum").val();
				if (num == oldNum) {
					return;
				}
				chgNum(obj);
			});
		});
		function initContent() {
			setChecked();
			showTotal();
			totalTop = $("div.orderSubmit").offset().top;
			totalFloat();
		}
		function setChecked(){
			$("div[name=order]").each(function(){
				var allChecked = true;
				$(this).find("input[name=item]").each(function(){
					var check = $(this).prop("checked");
					if(!check){
						allChecked = false;
						return;
					}
				});
				$(this).find("input[name=order]").prop("checked",allChecked);
			});
			var allChecked = true;
			$("input[name=order]").each(function(){
				var check = $(this).prop("checked");
				if(!check){
					allChecked = false;
					return;
				}
			});
			$("input[name=allChecked]").prop("checked",allChecked);
		}
		
		function showTotal() {
			var countTotal = 0;
			var priceTotal = 0;
			$("input[name=item]").each(function(){
				if($(this).prop("checked")){
					countTotal++;
					subTotal = $(this).parents("tr").find("p.subtotal").text();
					priceTotal = floatAdd(priceTotal,subTotal);
				}
			});
			$("#priceTotal").text(priceTotal.toFixed(2));
			$("#countTotal").text(countTotal);
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
		
		function chgNum(obj){
			var bsDetailId = $(obj).attr("bsDetailId");
			var newNum = $(obj).val();
			var oldNum = $(obj).siblings("input.oldNum").val();
			if(!validNum(newNum, obj)){
				$(obj).val(oldNum);
			} else {
				$.post(
					"${ctx}/cart/modify.action",
					{
						bsDetailId:bsDetailId,
						newQuantity:newNum,
						oldQuantity:oldNum
					},
					function(data){
						var res = $.parseJSON(data);
						$(obj).val(res.num);
						$(obj).siblings("input.oldNum").val(res.num);
						if(res.num > 1) {
							$("div.minus").removeClass("disabled");
						} else {
							$("div.minus").addClass("disabled");
						}
						var nowPrice = $("p.nowPrice[bsDetailId=" + bsDetailId + "]").text();
						var subTotal = (nowPrice * res.num).toFixed(2);
						$("p.subtotal[bsDetailId=" + bsDetailId + "]").html(subTotal);
						if(res.statusCode != 0){
							if(res.statusCode == -8) {
								$(obj).parent("div.mod-modified").siblings("div.note").html("<span>仅剩" + res.stock + "件</span>");
							} else if (res.statusCode == -9) {
								$(obj).parent("div.mod-modified").siblings("div.note").html("<span>限购" + res.purchaseCountLimit + "件</span>");
							} else {
								$(obj).parents("div.row").addClass("unusual");
								$(obj).parents("div.row table").before("<div class='mask'></div>" + 
										"<div class='shixiao'><img src='${imgDomain}/shixiao.png'></div>");
								$(obj).parents("tr").addClass("eom");
							}
						} else {
							$(obj).parent("div.mod-modified").siblings("div.note").html("");
						}
						showTotal();
					}
				);
			}
		}
		function validNum(num, obj) {
			if (!/^\d+$/.exec(num)) {
				$(obj).parent("div.mod-modified").siblings("div.note").html(
						"<span>数量不正确</span>");
				return false;
			} else {
				if (num < 1) {
					$(obj).parent("div.mod-modified").siblings("div.note").html(
							"<span>数量须大于0</span>");
					return false;
				}
				return true;
			}
		}
		function totalFloat() {
			if ($("div.cartList-group").length > 1) {
				var scrollTop = $(document).scrollTop();
				var screenHeight = $(window).height();
				if (scrollTop + screenHeight > totalTop + 56) {
					$("div.orderSubmit").removeClass("fixed");
				} else {
					$("div.orderSubmit").addClass("fixed");
				}
				return totalTop + 56;
			}
			return 0;
		}
	</script>
</head>
<body id="shopCart">
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
						<h2><i class="icon i-cart"></i>我的购物车</h2>
						<ul class="mod-step">
							<li class="first now">
								<i class="num">1</i>
								<p class="text">购物车</p>
							</li>
							<li class="">
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
					<div class="bd cart-show">
						<!-- orderState -->
						<div class="orderState">
							<!-- cart loading -->
							<div class="cartLoading">
								<img src="${imgDomain }/loading.gif" alt="" />
								<h3>加载中...若页面长时间不显示商品</h3>
								<p><a href="${ctx}/cart/cart.action">点击刷新 </a></p>
							</div>
							<!-- cart loading end -->
						</div>
					</div>
				</div>
				<!-- cartList end -->
			</div>
		</div>
		<!-- container end -->
		<jsp:include page="/common/foot.html" />
	</div>
</body>
</html>