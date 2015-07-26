<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/common/common.jsp"%>
<html lang="zh-cn">
<head>
	<meta charset="utf-8">
	<title>提交退货</title>
	<link rel="stylesheet" type="text/css" href="${cssDomain}/css/allstyle.css"/>
	<link rel="stylesheet" type="text/css" href="${cssDomain}/css/order.css"/>
	<script type="text/javascript" src="${jsDomain}/jquery.min.js"></script>
	<script type="text/javascript" src="${jsDomain}/uploadify/jquery.uploadify.js"></script>
	<script type="text/javascript">
		$(function(){
			$(document).on("blur","#num",function(){
				$("#errMsg").addClass("hide");
				var num = $(this).val();
				var max = $("#max").val();
				if(!/^\d+$/.test(num)){
					$("#errMsg").removeClass("hide");
					$("#errMsg").html("请输入正确数量");
					return false;
				}
				if(num>max||num<=0){
					$("#errMsg").removeClass("hide");
					$("#errMsg").html("退货数量不能大于购买数量，且不能小于等于0！");
					return false;
				}
			});
			$("#uploadify").uploadify({
	            //指定swf文件
				'swf': '${ctx}/uploadify/uploadify.swf',
	            //后台处理的页面
	            'uploader': '${imgUploadUrl}',
	            //按钮显示的文字
	            "buttonImage":'${imgDomain}/upload.jpg',
	            "buttonClass":"btn-primary xl",
	            //显示的高度和宽度，默认 height 30；width 120
	            'height': 80,
	            'width': 80,
	            'fileSizeLimit':200,
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
						var html = '<li><a href="javascript:;"><img src="${imgUrl}?rid='+d.rid+'&op=s1_w80_h80_e1-c3_w80_h80" alt="">'
								+'<input type="hidden" name="imgs" value="'+d.rid+'"></a><p class=""><a name="del" href="javascript:;">删除</a></p></li>';
						$("#img").prepend(html);
						var imgs = $("#img").children("li");
						if(imgs.length >=6){
							$('#uploadify').uploadify('disable', true);
							return false;
						}
					}
				}
	        });
			
			$(document).on("click","a[name=del]",function(){
				$(this).parent("p").parent("li").remove();
				var imgs = $("#img").children("li");
				if(imgs.length <7){
					$('#uploadify').uploadify('disable', false);
					return false;
				}
			});
			$(document).on("click","input[name=apply]",function(){
				$("#errMsg").addClass("hide");
				$("#errMsg2").addClass("hide");
				$("#errMsg3").addClass("hide");
				var err = false;
				var err2 = false;
				var err3 = false;
				//退货原因
				var retReason = $("select[name=returnReason]").children("option:selected").val();
				if(retReason=="-1"){
					err2=true;
				}
				//退货数量
				var num = $("#num").val();
				var max = $("#max").val();
				if(!/^\d+$/.test(num)){
					$("#errMsg").html("请输入正确数量");
					err = true;
				}
				if(num>max||num<=0){
					$("#errMsg").html("退货数量不能大于购买数量，且不能小于等于0！");
					err = true;
				}
				//退货说明
				var remarks = $("textarea[name=remarks]").val();
				if(!remarks){
					$("#errMsg3").html("请填写说明！");
					err3 = true;
				}
				if(remarks.length>600){
					$("#errMsg3").html("说明不能超过200字！");
					err3 = true;
				}
				if(err){
					$("#errMsg").removeClass("hide");
				}
				if(err2){
					$("#errMsg2").removeClass("hide");
				}
				if(err3){
					$("#errMsg3").removeClass("hide");
				}
				if(err||err2||err3){
					return false;
				}
				$("#form").submit();
			});
		});
	</script>
</head>
<body class="">
	<div class="wrapper">
		<!-- topbar -->
		<jsp:include page="/common/head.jsp" />
		<!-- topbar end -->
		<!-- container -->
		<div id="container">
			<div class="wrap">
				<!-- salereturn -->
				<div class="salereturn">
					<div class="hd">
						<div class="breadnav">
							<span class="index"><a href="http://www.hehefang.com">首页</a></span>
							<ul class="nav">
								<li><span>&gt;</span><a href="${ctx}/user/userCenter.action">我的禾合坊</a></li>
								<li><span>&gt;</span><a href="${ctx}/retOrder/retOrderApply.action">退货申请</a></li>
							</ul>
						</div>
					</div>
					<div class="bd">
						<div class="orderFlow">
							<div class="orderFlow-process">
								<ul class="train-nav">
									<li class="first-child on"><i class="head"></i><a href="javascript:;">1、退货申请</a></li>
									<li><i class="head"></i><i class="end"></i><a href="javascript:;">2、卖家受理</a></li>
									<li><i class="head"></i><i class="end"></i><a href="javascript:;">3、卖家确认</a></li>
									<li class="last-child"><i class="end"></i><a href="javascript:;">4、退款到账</a></li>
								</ul>
							</div>
							<div class="sale-remin">
								<dl>
									<dt><i class="icon i-danger"></i>	</dt>
									<dd>
										<h2>退货前请先与卖家沟通，确保退货流程正常进行。退货流程完成后，平台将按照买家支付的原方式自动退回款项。</h2>
										<ul>
											<li>卖家姓名：<c:out value="${seller.bizManName}" /></li>
											<li>卖家电话：<c:out value="${seller.tel}" /></li>
											<li>卖家QQ号：<c:out value="${seller.bizManQq}" /></li>
										</ul>
									</dd>
								</dl>
							</div>
							<div class="sale-goods">
								<form id="form" class="form" action="${ctx}/retOrder/formApply.action" method="post">
									<fieldset>
										<div class="formGroup">
											<div class="form-item">
												<div class="item-label"><label><em>*</em>退款商品：</label></div>
												<div class="item-cont">
													<dl class="mod-orderGoods">
														<dt>
															<a href="${ctx}/detail.action?bsdid=${orderItem.bsdId}" class="thumbnail"><img src="${imgUrl}?rid=${orderItem.prodImg}&op=s1_w52_h52_e1-c3_w52_h52" alt=""></a>
														</dt>
														<dd>
															<p class="title"><a href="${ctx}/detail.action?bsdid=${orderItem.bsdId}"><c:out value="${orderItem.prodTitle}" /></a></p>
														</dd>
													</dl>
												</div>
												<input type="hidden" name="orderId" value="${orderItem.orderId}" />
												<input type="hidden" name="sellerId" value="${seller.sellerId}" />
												<input type="hidden" name="brandShowId" value="${orderItem.order.brandShowId}" />
												<input type="hidden" name="brandShowTitle" value="${orderItem.order.brandShowTitle}" />
												<input type="hidden" name="orderCode" value="${orderItem.order.orderCode}" />
											</div>
											<div class="form-item">
												<div class="item-label"><label><em>*</em>退货原因：</label></div>
												<div class="item-cont">
													<select name="returnReason">
														<option value="-1">请选择订单取消原因...</option>
														<option value="商品质量问题">商品质量问题</option>
														<option value="收到商品少件、破损或污渍">收到商品少件、破损或污渍</option>
														<option value="不喜欢">不喜欢</option>
														<option value="认为是假货">认为是假货</option>
														<option value="买错了">买错了</option>
														<option value="其他原因">其他原因</option>
													</select>
													<span id="errMsg2" class="note errTxt hide">请选择退货原因！</span>
												</div>
											</div>
											<div class="form-item">
												<div class="item-label"><label><em>*</em>退货数量：</label></div>
												<div class="item-cont">
													<input type="text" id="num" name="retOrderItems[0].returnNumber" class="txt lg">
													<input type="hidden" value="${orderItem.number}" id="max" />
													<span id="errMsg" class="note errTxt hide">退货数量不能大于购买数量。</span>
												</div>
											</div>
											<div class="form-item">
												<div class="item-label"><label>退货金额：</label></div>
												<div class="item-cont">
													<span class="errTxt"><fmt:formatNumber pattern="0.00" value="${orderItem.transPrice}" /></span>
													<input type="hidden" name="retOrderItems[0].sellerId" value="${seller.sellerId}" />
													<input type="hidden" name="retOrderItems[0].itemId" value="${orderItem.orderItemId}" />
													<input type="hidden" name="retOrderItems[0].skuId" value="${orderItem.skuId}" />
													<input type="hidden" name="retOrderItems[0].retFee" value="${orderItem.transPrice}" />
													<input type="hidden" name="retOrderItems[0].prodId" value="${orderItem.prodId}" />
												</div>
											</div>
											<div class="form-item">
												<div class="item-label"><label><em>*</em>说明：</label></div>
												<div class="item-cont">
													<textarea name="remarks" id="" cols="80" rows="7" style="width: 700px;" class="resize-none" placeholder="不超过200字"></textarea>
													<span id="errMsg3" class="note errTxt hide"></span>
												</div>
											</div>
											<div class="form-item">
												<div class="item-label"><label>上传图片：</label></div>
												<div class="item-cont">
													<p class="note">最多上传 <span class="errTxt">5</span> 张图片。请上传 jpg、png 格式的图片，单张图片限制 200kb 以内。</p>
													<div class="uploadImg">
														<ul id=img>
															<li>
																<a href="javascript:;"><img id="uploadify" src="${imgDomain}/upload.jpg" alt=""></a>
															</li>
														</ul>
													</div>
												</div>
											</div>
											<div class="form-item">
												<div class="item-label"><label></label></div>
												<div class="item-cont">
													<input type="button" name="apply" value="提交申请" class="btn btn-primary xl">
												</div>
											</div>
										</div>
									</fieldset>
								</form>
							</div>
						</div>
					</div>
				</div>
				<!-- salereturn end -->
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
