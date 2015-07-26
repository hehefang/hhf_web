<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!doctype html>
<html lang="zh-cn">
<head>
	<meta charset="utf-8">
	<meta name="keywords" content="支付异常" />
	<meta name="description" content="" />
	<title>支付异常</title>
	<link rel="stylesheet" href="/css/pay.css">
</head>
<body>
	<div class="wrapper">
		<jsp:include page="/common/head.jsp">
			<jsp:param name="hideMiniCart" value="1"/>   
		</jsp:include>
		<!--container begin-->
		<div class="container">
			<!--order-warning-->
			<div class="order-warning">
				<div class="order-warn-box">
					<div style="display:block" class="register-fail">
						<i class="warn-ico"></i>
						<h2>${result}</h2>
					</div>
				</div>
			</div>
			<!--order-warning end-->
		</div>
		<!--container end-->
		<jsp:include page="/common/foot.html" />
	</div>
</body>
</html>