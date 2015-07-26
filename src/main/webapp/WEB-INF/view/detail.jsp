<!DOCTYPE html>
<%@include file="/common/common.jsp" %>
<html lang="zh-cn">
<head>
	<meta charset="utf-8">
	<title>详情页</title>
	<link rel="stylesheet" type="text/css" href="${cssDomain}/css/allstyle.css"/>
	<link rel="stylesheet" type="text/css" href="${cssDomain}/css/store.css"/>
	<link rel="stylesheet" type="text/css" href="${cssDomain}/css/jquery.jqzoom.css" >
</head>
<body class="">
	<div class="wrapper">
		<jsp:include page="/common/head.jsp"/>
		<!-- crossnav -->
		<div class="crossnav">
			<ul>
				<li class="on"><a href="${ctx}/index.jsp">首&nbsp;&nbsp;页</a></li>
			</ul>
		</div>
		<!-- crossnav -->
		<!-- container -->
		<div id="container">
		<script type="text/javascript" src="${jsDomain}/jquery.jqzoom-core.js"></script>
		<script type="text/javascript" src="${jsDomain}/timecount.js"></script>
			<div class="wrap">
				<div class="headSyn">
					<div class="countDown">
						<p>距特卖结束还剩：<img src="${imgDomain}/clok.png" alt="">
						<span id="day">29</span>天
                        <span id="hour">21</span>时
                        <span id="mini">27</span>分
                        <span id="sec">31</span>秒</p>
<script type="text/javascript">
    var timestr="${brandshow.endDate}";
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
					<!-- breadnav  -->
					<div class="breadnav">
						<span class="index"><a href="${ctx}/index.jsp">首页</a></span>
						<ul class="nav">
							<li><span>&gt;</span><a href="${ctx}/brandshow.action?bsid=${brandshow.brandShowId}">${brandshow.title}</a></li>
							<li><span>&gt;</span><a href="javascript:void(0)">111<c:out value="${product.title}"/></a></li>
						</ul>
					</div>
				</div>
				<!-- breadnav end -->
				<!-- goodsBuy -->
				<div class="goodsBuy">
					<div class="article">
						<div class="g-preview">
						<div class="clearfix g-img">
						   <a id="picbig" href="" class="jqzoom" rel="gal1"> 
							<img  id="picsmall" src="" title="triumph">
						  </a>
							<div class="ico"><i></i></div>
						</div>
						<div class="images">
							<div class="slide slide-primary" style="height: 62px">
								<div class="prev"><i class="ico" onclick="move_left()"></i></div>
								<div class="next"><i class="ico" onclick="move_right()"></i></div>
								<!-- items -->
								<div class="items">
									<ul id="imglist" style="width: 999em;">
										
									</ul>
								</div>
								<!-- items end -->
							</div>
						</div>
					</div>
					<!-- g-buy -->
					<div class="g-buy">
						<h2 class="mainTitle"><c:out value="${product.title}"/></h2>
						<h3 class="subTitle"><c:out value="${product.subtitle}"/></h3>
						<!-- g-items -->
						<div class="g-items active">
							<div class="prices">
								<dl class="g-item barginPrice"><dt>促销价</dt><dd><span>¥<em id="bdprice"><fmt:formatNumber value="${bsdetail.showPrice}" pattern="0.00" /></em></span></dd></dl>
							</div>
								<dl class="g-item"><dt>市场价</dt><dd><span><del>¥<span id="bddelprice"><fmt:formatNumber value="${bsdetail.orgPrice}" pattern="0.00" /></span></del></span></dd></dl>
							<dl class="g-item">
								<dt>快递费</dt>
								<dd><div class="g-tag">包邮</div>
								</dd>
							</dl>
						</div>
						<!-- g-items end -->
						<!-- g-items -->
						<div class="g-items g-attr">
<c:if test="${!empty prductSpecs}">
<c:forEach items="${prductSpecs}" var="spec" varStatus="status">
                            <dl class="g-item" tagname="spid" spid="${spec.value.specId}">
								<dt>${spec.value.specName}</dt>
								<dd>
								<c:forEach items="${spec.value.specVals}" var="specval" varStatus="status">
									<div class="attrElem">
										<a  href="javascript:void(0)" onclick="choose_spec('${specval.value.specId}')">
											<span tagname="spvid" spvid="${specval.value.specId}">${specval.value.specName}</span>											
										</a>
									</div>
								</c:forEach>
								</dd>
							</dl>
</c:forEach>
</c:if>
							<dl class="g-item">
								<dt>数量</dt>
								<dd>
									<div class="mod-modified" style="width:101px">
										<div id="minusid" onclick="changenums(-1)" class="minus disabled">-</div>
										<input type="text" id="numsid" readonly="readonly" class="txt sm" value="1">
										<div id="plusid" onclick="changenums(+1)" class="plus">+</div>
									</div><span>件</span><span>库存<em id="stack">${sku.stockBalance}</em>件</span>
								</dd>
							</dl>
						</div>
						<!-- g-items end -->
						<div class="btnWrap clearfix">
							<a href="javascript:void(0);" onclick="addtocart()" class="btn btn-assist xl btn-addCart"><i class="icon i-cartSM"></i>加入购物车</a>
						</div>
					</div>
					<!-- g-buy end -->
				</div>
				</div>
				<!-- goodsBuy -->
				<!-- goodsRec -->
				<div class="goodRec">
					<!-- goodsDetails -->
					
				    <a name="pdanchor"></a>
					<div class="goodsDetails">
					<div id="buytab" class="hd rec-hd"><!--当让其固定是 加class名“fixed” -->
							<ul>
								<a href="#pdanchor"><li id="pdli" class="det on">商品详情</li></a>
							</ul>
							<div class="btn-hd">
								<a class="btn btn-assist btn-addCart" href="javascript:void(0);" onclick="addtocart()"><i class="icon i-cartSM"></i>加入购物车</a>
							</div>						
					</div>
					<div class="bd">
					<div class="details-main">
					${product.detail}
					</div>
					</div>
					</div>
					<!-- goodsDetails -->
					<!-- goodsRecommend -->

					<!-- goodsRecommend -->
				</div>
				<!-- goodRec end -->
			</div>
		</div>
		<!-- container end -->
		<!-- footer -->
		<jsp:include page="/common/foot.html" />
		<!-- footer end -->
		<!-- float -->
		<div id="float" class="float-box">
			<div id="hometop" onclick="pageScroll()" class="return-top"><a title="返回顶部" href="javascript:void(0);"></a> </div>
		</div>
		<!-- float end -->
	</div>
	<script type="text/javascript">
	  var skuList = ${skusjson} ;
	  var defaultSku = ${skujson}; 
	  var selecSku=defaultSku;
	var prductspecs=${pspecsjson};
	var total_length=74;
	var img_length=74;
	function choose_spec(spvid){
		 var target_obj=$("span[tagname=spvid][spvid="+spvid+"]")[0];
		 var target_div_obj=$(target_obj).parent().parent();
    	 if(target_div_obj.hasClass("disabled")){
    		 return false;
    	 }
    	 if(target_div_obj.hasClass("selected")){
    		 return false;
    	 }
		$("span[tagname=spvid][spvid="+spvid+"]").parents("dl[tagname=spid]").find("span[tagname=spvid]").each(function(){
		    $(this).next().remove();
		    $(this).parent().parent().removeClass("selected");
		  });
		$("span[spvid="+spvid+"]").each(function(){
		    $(this).after('<i class="on">已选中</i>');
		    $(this).parent().parent().addClass("selected");
		  });
		$("div.attrElem").removeClass("disabled");
		
		if(check_spec_finish()){
			exclude_sku();
			selecSku=skuList[get_sku()];
			load_imgs();
			initnums();
			$("#bdprice").html(selecSku.salePrice.toFixed(2));//update price
			$("#bddelprice").html(selecSku.marketPrice.toFixed(2));//update delprice
		};
	};
	function check_spec_finish(){
		var flag=true;
		$("dl[tagname=spid]").each(function(){
		    if($(this).find("div.attrElem.selected").length==0){
		    	flag=false;
		    	return false;
		    }
		  });
		
		return flag;
	};
	
	function initnums(){
		$("#stack").val(selecSku.stockBalance);	
		$("#stack").html(selecSku.stockBalance);	
		$("#numsid").val(1);
		$("#plusid").addClass("disabled");
		var stock_str=$("#stack").val();
		var stock=parseInt(stock_str);
		if(stock==0||stock==1){				
			$("#minusid").addClass("disabled");
			$("#plusid").addClass("disabled");
			$("#numsid").val(stock);
			return;
		}else{
			$("#minusid").addClass("disabled");
			$("#plusid").removeClass("disabled");				
			var select_nums_str=$("#numsid").val();
			var select_nums=parseInt(select_nums_str);
			if(select_nums>stock){
				$("#numsid").val(stock);
				$("#minusid").removeClass("disabled");
				$("#plusid").addClass("disabled");
			};
		};
	}
	
	function get_sku(){
		var spec_str_arr=new Array();
		$("dl[tagname=spid]").each(function(){
		    var spid=$(this).attr("spid");
		    var spvid_obj=$(this).find("div.attrElem.selected")[0];
		    if(spvid_obj){
		    	var obj_temp=$(spvid_obj).find("span[tagname=spvid]")[0];
		    	if(obj_temp){
		    		var spvid=$(obj_temp).attr("spvid");
		    		spec_str_arr.push(spid+":::"+spvid);
		    	}
		    }
		  });
		return spec_str_arr.join("|||");
	};
	
	var produt_spcs_arr=new Array();//所有的规格的id
	var produt_spcvs_arr=new Array();//所有的规格值的id
    function exclude_sku(){
		var spids_str=get_sku();
		var spids_arr=spids_str.split("|||");
    	for(var i=0;i<produt_spcs_arr.length;i++){
    		var one_attrvalids=produt_spcvs_arr[i];
    		for(var j=0;j<one_attrvalids.length;j++){
    			var str_temp=produt_spcs_arr[i]+":::"+one_attrvalids[j];
    			var spids_str_temp=spids_arr;
    			     spids_str_temp[i]=str_temp;
    			     var new_spcs_str=spids_str_temp.join("|||");   			    
    			     if(typeof(skuList[new_spcs_str])=='undefined'){    			    	    			    	
    			    	 var target_obj=$("span[tagname=spvid][spvid="+one_attrvalids[j]+"]")[0];
    			    	 $(target_obj).parent().parent().addClass("disabled");
    			     };
    		};
    	};
	};
	function load_imgs(){
		var imgurls=selecSku.skuImgUrl;
		var imgurls_arr=imgurls.split();
		var html_str="";
		for(var i in imgurls_arr){
			html_str+=get_img_html(imgurls_arr[i]);
		}
		$("#picbig").attr("href",'${my:random(imgGetUrl)}?rid='+imgurls_arr[0]+'&op=s0_w900_h900');
		$("#picsmall").attr("src",'${my:random(imgGetUrl)}?rid='+imgurls_arr[0]+'&op=s0_w418_h418');
		$("#imglist").html(html_str);
		total_length=img_length*imgurls_arr.length;
		
	}
	function get_img_html(imgurl){
		var html_str='';
		html_str+='<li>';
		html_str+='<div class="img on">';
		html_str+='<a href="#">';
		html_str+='<a class="zoomThumbActive" href="javascript:void(0);" rel="{gallery: \'gal1\',smallimage:\'${my:random(imgGetUrl)}?rid='+imgurl+'&op=s0_w418_h418\'}\',largeimage: \'${my:random(imgGetUrl)}?rid='+imgurl+'\'}">';
		html_str+='<img src="${my:random(imgGetUrl)}?rid='+imgurl+'&op=s0_w55_h55" alt="">';
		html_str+='</a>';
		html_str+='</a>';
		html_str+='</div>';
		html_str+='</li>';
		return html_str;
	}
	
	function changenums(nums){
		var stock_str=$("#stack").val();
		var stock=parseInt(stock_str);
		var stock_sel_str=$("#numsid").val();
		var stock_sel=parseInt(stock_sel_str);
		if(stock_sel+nums<1||stock_sel+nums>stock){
			return;
		}
		if(stock_sel+nums==stock){
			$("#plusid").addClass("disabled");	
			$("#minusid").removeClass("disabled");
		}else{
			$("#plusid").removeClass("disabled");
		}
		if(stock_sel+nums==1){
			$("#minusid").addClass("disabled");	
			$("#plusid").removeClass("disabled");	
		}else{
			$("#minusid").removeClass("disabled");
		}
		var select_nums_str=$("#numsid").val();
		var select_nums=parseInt(select_nums_str);
		$("#numsid").val(select_nums+nums);
		
		
		
	}
	
	function addtocart(){
		var nums=$("#numsid").val();
		var stock_str=$("#stack").val();
		var stock=parseInt(stock_str);
		if(parseInt(nums)<1||parseInt(nums)>stock){
			return false;
		}
		
		var skuid=defaultSku.skuId;
		if(selecSku){
			  skuid=selecSku.skuId;
			}
				$.ajax({
					url : "${ctx}/cart/addcart.action",
					data : {
						bsid:${brandshow.brandShowId},
						skuid:skuid,
					    num : nums
					},
					async : false,
					dataType : "json",
					success : function(data) {
						//window.location.href='${ctx}/cart/cart.action';	
						$('#popupdiv').show();
						setTimeout("$('#popupdiv').hide();",2000);
					}
				});
	}
	function pageScroll(){
	    window.scrollBy(0,-100);
	    scrolldelay = setTimeout('pageScroll()',100); 
	    var sTop=document.documentElement.scrollTop+document.body.scrollTop;
	    if(sTop==0) clearTimeout(scrolldelay);
	}
	$(function(){
		load_imgs();
		initnums();
		var specs=defaultSku.skuSpecId;
		var list=specs.split("|||");
		for(var i in prductspecs){ 
			var obj=prductspecs[i]; 
			produt_spcs_arr.push(obj.specId);
			var vals=obj.specVals;
			var vals_arr=new Array();
			for(var j in vals){
				vals_arr.push(vals[j].specId);
			};
			produt_spcvs_arr.push(vals_arr);
			};
		for(var i=0;i<list.length;i++){
			var item=list[i];
			var item_list=item.split(":::");
			var spvid=item_list[1];
			choose_spec(spvid);
		};
		
		

	});
	</script>
	<script  type="text/javascript">
	
            function move_left(){
                var left = $("#imglist").position().left;
                var width= $("#imglist").width();
                if(left<0){
                    $("#imglist").animate({left:(left+img_length)+"px"});
                }
            }
            function move_right(){
                var left = $("#imglist").position().left;               
                if(total_length-img_length*5+left>0){
                    $("#imglist").animate({left:(left-img_length)+"px"});
                }
            }
          
            $(document).ready(function() {
                $('.jqzoom').jqzoom({
                    zoomType: 'reverse',
                    lens:true,
                    xOffset:8,
                    preloadImages: false,
                    title:false,

                    imageOpacity:0.5,
                    alwaysOn:false
                });
            });
            
            
            function totalFloat() {
        		
        			var totalTop = $("div.goodRec").offset().top;
        			var scrollTop = $(document).scrollTop();
        			var screenHeight = $(window).height();
        			if ((totalTop+ 38 > scrollTop)) {
        				$("#buytab").removeClass("fixed");
        				$("#pdli").addClass("on");
        			} else {
        				$("#buytab").addClass("fixed");
        				$("#pdli").removeClass("on");
        			}
        			return totalTop + 56;        		
        		return 0;
        	}
            $(function() {
            	totalTop = totalFloat();
        		intervalId = setInterval("totalFloat()",1000);
            	}); 
        </script>
<div id="popupdiv" class="popup popup-info pop-order pop-success" style="display:none">
			<div class="hd">
				<i class="close"></i>
			</div>
			<div class="bd">
				<div class="order-delivery">
					<dl>
						<dt><i class="icon i-rightXL"></i></dt>
						<dd>
							<h2>加入购物车成功！</h2>
						</dd>
					</dl>
				</div>
			</div>
</div>
</body>
</html>
