<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@include file="/common/common.jsp" %>
	<script type="text/javascript" src="http://js.web.hehefang.com/jquery.min.js"></script>
	<script type="text/javascript" src="http://js.web.hehefang.com/jquery.cookie.js"></script>
	<script type="text/javascript" src="http://js.web.hehefang.com/login.js"></script>
	<script type="text/javascript" src="http://js.web.hehefang.com/uploadify/jquery.uploadify.min.js"></script>
	<script type="text/javascript">
		$(function(){
			var hideMiniCart=<%=request.getParameter("hideMiniCart")%>
			if(!hideMiniCart) {
				hideMiniCart = 0;
			}
			if(hideMiniCart == '1') {
				$("#shoppingCart").remove();
			}
			var cartCookie = "";
			$(document).on("mouseover","div#shoppingCart",function(){
				if($(this).hasClass("hover")) {
					return;
				} else {
					$(this).addClass("hover");
				}
				var currCookie = getCookie("cart");
				if(cartCookie == currCookie) {
					return;
				} else {
					cartCookie = currCookie;
				}
				showMiniCart();
			});
			$(document).on("mouseout","div#shoppingCart",function(){
				$(this).removeClass("hover");
			});
			
			$(document).on("click","a[name=logon]",function(){
				var href = location.href;
				location.href = "${ctx}/login.action?rtnUrl="+encodeURIComponent(href);
			});
		});
		function getCookie(c_name){
			if (document.cookie.length>0){
				c_start=document.cookie.indexOf(c_name + "=");
					if (c_start!=-1){
					c_start=c_start + c_name.length+1;
					c_end=document.cookie.indexOf(";",c_start);
					if (c_end==-1) c_end=document.cookie.length;
					return unescape(document.cookie.substring(c_start,c_end));
				}
			}
			return "";
	    }
		function showMiniCart() {
			$.post(
				"${ctx}/cart/miniCart.action",
				{},
				function(data){
					var cartData = $.parseJSON(data);
					var obj = $("div#shoppingCart div.bd");
					if(cartData.totalNum > 0) {
						var html = "<div class='shoppingList'>" + 
										"<div class='list'>";
						var carts = cartData.carts;
						for(var index in cartData.carts) {
							var cartItems = carts[index].cartItems;
							for(var index2 in cartItems) {
								var cartItem = cartItems[index2];
								html += "<dl>" + 
										  "<dt><a href='${ctx}/detail.action?bsdid=" + cartItem.brandShowDetailId + "'><img src='${my:random(imgGetUrl)}?rid=" + cartItem.prodImgUrl + "&op=s0_w50_h50' alt='' /></a></dt>" +
										  "<dd class='goodsTitle'>" +
										  	"<p><a href='${ctx}/detail.action?bsdid=" + cartItem.brandShowDetailId + "' title=''>" + cartItem.prodName + "</a></p>" +
										  "</dd>" +
										  "<dd class='subtotal'>" +
										  	"<p><span class='price'>&yen;<strong>" + cartItem.showPrice.toFixed(2) + "</strong></span><em>x</em><span class='number'>" + cartItem.num + "</span></p>" +
										  	"<p><a href='javascript:delMiniCart(" + cartItem.brandShowDetailId + ");' >删除</a></p>" +
										  "</dd>" +
										"</dl>";
							}
						}
						html += "<a href='${ctx}/cart/cart.action' class='cart-more'>更多...</a>" + 
							"</div>" + 
							"<div class='summation'>" + 
								"<p class='total'>购物车里共有<em>" + cartData.totalNum + "</em>件商品，总计" +
									"<span class='priceTotal'>&yen;<strong>" + cartData.totalMoney + "</strong></span></p>" + 
								"<a href='${ctx}/cart/cart.action' class='btn btn-assist'>查看我的购物车</a>" + 
							"</div>" + 
						"</div>";
						obj.html(html);
					} else {
						var html = "<div class='shoppingCart-empty show'>" + 
										"<p>快去挑选喜欢的商品吧！</p>" +
									"</div>";
						obj.html(html);
					}
				}
			);
		}
		function delMiniCart(bsdid){
			$.post(
				"${ctx}/cart/delMiniCart.action",
				{bsdid:bsdid},
				showMiniCart
			);
		}
		function login() {
			var path = window.location.href;
			window.location.href="${ctx}/login.action?rtnUrl=" + path;
		}
	</script>
	<!-- topbar -->
	<div id="topbar">
		<div class="wrap">
			<div id="siteNav">
				<dl class="noSubmenu">
					<dt class="hd"><a href="${ctx}/user/orders.action">我的订单</a></dt>
				</dl>
				<dl class="myCenter">
					<dt class="hd"><a href="${ctx}/user/userCenter.action">我的禾合坊<span class="arrow bottom-hollow xs"><b></b><i></i></span></a></dt>
				  	<dd class="bd">
				  		<ul>
				  		  <li><a href="${ctx}/user/orders.action">已买商品</a></li>
				  		  <li><a href="${ctx}/cart/cart.action">我的购物车</a></li>
				  		</ul>
				  	</dd>
				</dl>
				<dl class="noSubmenu">
			  		<dt class="hd"><a href="http://seller.hehefang.com">我是商家</a></dt>
			 		
				</dl>
			</div>
			<div class="signin">
				<span id="name">欢迎来到禾合坊！</span><span id="unLogin" class="hide">请<a name="logon" href="javascript:login();">登录</a><em>/</em><a href="${ctx}/register.action">免费注册</a></span><span id="login" ><a id="logout" href="javascript:;" class="quit">[退出]</a></span>
			</div>
		</div>
	</div>
	<!-- topbar end -->
	<!-- header -->
	<div id="header">
		<div class="wrap">
			<div id="logo">
				<div class="logo"><a href="http://www.hehefang.com" title="logo"><img src="http://img.web.hehefang.com/logo.png" alt="logo"></a></div>
				<div class="slogan"><img src="http://img.web.hehefang.com/slogan.png"/></div>
			</div>
			<!-- shopping cart -->
			<div id="shoppingCart">
				<div class="cart">
					<a href="${ctx}/cart/cart.action">我的购物车<span class="arrow bottom-hollow"><b></b><i></i></span></a>
				</div>
				<div class="bd">
					<div class='shoppingCart-empty show'>
						<p>快去挑选喜欢的商品吧！</p>
					</div>
				</div>
			</div>
			<div id="safeguard"><img src="http://img.web.hehefang.com/safeguard.jpg"/></div>
		</div>
	</div>
	<!-- header end -->
