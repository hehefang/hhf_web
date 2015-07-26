<!DOCTYPE html>
<%@include file="/common/common.jsp" %>
<html>
<head>
	<meta charset="utf-8">
	<title>活动页</title>
	<link rel="stylesheet" type="text/css" href="${cssDomain}/css/allstyle.css"/>
	<link rel="stylesheet" type="text/css" href="${cssDomain}/css/active.css"/>
	<link rel="stylesheet" type="text/css" href="${cssDomain}/css/show.css"/>
	<script type="text/javascript">
	
	</script>
</head>
<body id="index">
<div class="wrapper actives">
<jsp:include page="/common/head.jsp"/>
	<div class="crossnav">
		<ul>
			<li class="on"><a href="${ctx}/index.jsp">首&nbsp;&nbsp;页</a></li>
		</ul>
	</div>
	<!-- banner -->
	<div id="mainBanner" style="text-align:center;"> 
		<div class="wrap">
									<c:if test ="${!empty brandShow.showBannerImg}">									
									<a href="" target="_blank"><img src="${my:random(imgGetUrl)}?rid=${brandShow.showBannerImg}&op=s0_w1920_h400"/></a>
									</c:if>
									<c:if test ="${empty brandShow.showBannerImg}">
									<img src="${imgDomain}/temp/active.jpg"/>
									</c:if>			
		</div>
	</div>
	<!-- banner -->
	<!-- container -->
	<script type="text/javascript" src="${jsDomain}/timecount.js"></script>
	<script type="text/javascript" src="${jsDomain}/scrollpagination.js"></script>

	<script type="text/javascript">
	var  currpage=1;
	var nums=0;
	var  totalpages=0;
$(function(){
	$('#content').scrollPagination({
		'contentPage': '${ctx}/bsdetails.action?bsid=${brandShow.brandShowId}', // the url you are fetching the results
		'contentData': {pageno:currpage}, // these are the variables you can pass to the request, for example: children().size() to know which page you are
		'scrollTarget': $(window), // who gonna scroll? in this example, the full window
		'heightOffset': 50, // it gonna request when scroll is 10 pixels before the page ends
		'beforeLoad': function(){ // before load function, you can display a preloader div
			$('#loading').fadeIn();	
			 if (currpage >= totalpages){ 			 	
				$('#content').stopScrollPagination();
			 }
		},
		'afterLoad': function(elementsLoaded){ // after loading content, you can use this function to animate your new elements
			 $('#loading').fadeOut();
			 var i = 0;
			 $(elementsLoaded).fadeInWithDelay();
			 currpage++;
			 if (currpage >= totalpages){ // if more than 100 results already loaded, then stop pagination (only for testing)
			 	$('#nomoreresults').fadeIn();
				$('#content').stopScrollPagination();
			 }
		}
	});
	
	// code for fade in element by element
	$.fn.fadeInWithDelay = function(){
		var delay = 0;
		return this.each(function(){
			$(this).delay(delay).animate({opacity:1}, 200);
			delay += 100;
		});
	};
		   
});
</script>
	<div id="container" 	<c:if test ="${!empty brandShow.bgColor}">style="background-color:#${brandShow.bgColor}"</c:if>>
		<div class="wrap active">
			<div class="hd">
				<div class="hd-top">
					<h2>${brandShow.title}</h2>
					<div class="act-strip">
					</div>
				</div>
				<div class="hd-bot">
					<!--span><label><input type="checkbox" class="chk">有货</label></span>
					<ul>						
						<li>价格<i class="icon i-goup"></i></li>						
					</ul-->
					<p><i class="icon i-watch"></i>本场剩余:<span id="day">29</span>天
                    <span id="hour">21</span>时
                    <span id="mini">27</span>分
                    <span id="sec">31</span>秒</p>
<script type="text/javascript">
    var timestr="${brandShow.endDate}";
    var time=Date.parse(timestr.replace(/-/g,"/"));
    var timehtml={
        sec:$("#sec")[0],
        mini:$("#mini")[0],
        hour:$("#hour")[0],
        day:$("#day")[0],
        month:$("#month")[0],
        year:$("#year")[0]
    };
    fnTimeCountDown(time,timehtml);
 
 </script>
				</div>
			</div>
			<div class="bd">
				<div id="content" class="mod-all">

				</div>
				<div id="loading" class="lodingmore">
					<p><img src="${imgDomain}/loading.gif" alt="">下拉刷新更多商品</p>
				</div>
			</div>
		</div>
	</div>
	<!-- container end -->
	<!-- footer -->
    <jsp:include page="/common/foot.html" />
	<!-- footer end -->
</div>
</body>
</html>
