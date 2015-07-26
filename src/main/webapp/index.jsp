<!DOCTYPE html>
<%@include file="/common/common.jsp" %>
<html>
<head>
	<meta charset="utf-8">
	<title>首页</title>
	<link rel="stylesheet" type="text/css" href="${cssDomain}/css/allstyle.css"/>
	<link rel="stylesheet" type="text/css" href="${cssDomain}/css/show.css"/>
	<script type="text/javascript" src="http://js.web.hehefang.com/timecount.js"></script>
</head>
<body id="index">
<div class="wrapper">

	<jsp:include page="/common/head.jsp" />

	<div class="crossnav">
		<ul>
			<li class="on"><a href="http://www.hehefang.com">首&nbsp;&nbsp;页 </a></li>
		</ul>
	</div>
	<!-- banner -->
	<div id="mainBanner">
		<div class="wrap">
			<a href="" target="_blank"><img src="${imgDomain}/temp/banner1.jpg"/></a>
		</div>
	</div>
	<!-- banner -->
	<!-- container -->
	<div id="container">
		<div class="wrap mainL">
			<!-- main -->
			<div id="main">
				<div class="hotlists">
					<div class="hd">
						<h2><img src="${imgDomain}/temp/caption1.png"/></h2>
					</div>
					<div id="brand" class="bd">

					</div>
				</div>
			</div>
			<!-- main end -->
			<!-- aside -->
			<div id="aside">
				<div class="hotlists">
					<div class="hd">
						<h2><img src="${imgDomain}/temp/caption2.png"/></h2>
					</div>
					<div class="bd">
						<div class="mod-goods g-def">
							<a href="" target="_blank">
								<img src="${imgDomain}/temp/img1.jpg" alt="">
								<div class="g-info">热销单品火速去抢</div>
								<div class="maskBar"></div>
							</a>
						</div>
					</div>
				</div>
			</div>
			<!-- aside end -->
		</div>
	</div>
	<!-- container end -->
	<!-- serve -->
	<jsp:include page="/common/service.html" />
    <!-- serve end -->
	<!-- footer -->
    <jsp:include page="/common/foot.html" />
	<!-- footer end -->
</div>
<script type="text/javascript">
$(function(){
	$("#brand").load("${ctx}/brandshows.action?&t=<%=new java.util.Date().getTime()%>");		
});
</script>
</body>
</html>