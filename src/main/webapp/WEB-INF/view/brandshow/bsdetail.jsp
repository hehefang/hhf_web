<%@include file="/common/common.jsp" %>
<c:if test="${pageno==1}">
<script type="text/javascript">
totalpages=${pagetotal};
</script>
</c:if>
<c:if test="${!empty showdetails}">
<c:forEach items="${showdetails}" var="detail" varStatus="status">
<div class="mod-activegoods">
						<a href="${ctx}/detail.action?bsdid=${detail.bSDId}" target="_blank">
						<div class="g-m">
						    <c:if test ="${!empty detail.prodImg}">	
						    <div class="g-img">								
									<img src="${my:random(imgGetUrl)}?rid=${detail.prodImg}&op=s0_w238_h238"/>
							</div>
							</c:if>
							<c:if test ="${empty detail.prodImg}">
							<div class="g-img">									
									<img src="${imgDomain}/temp/active-good.jpg" alt="">
						    </div>
							</c:if>
							<div class="g-info">
								<div class="hd">
									<span>
									<c:choose> 
     <c:when test="${fn:length(detail.prodTitle) > 15}"> 
      <c:out value="${fn:substring(detail.prodTitle, 0, 15)}..." /> 
     </c:when> 
     <c:otherwise> 
      <c:out value="${detail.prodTitle}" /> 
     </c:otherwise>
    </c:choose>
									
									</span>
								</div>
								<div class="bd">
									<div class="price">
									<c:set value="${ fn:split(detail.showPrice, '.') }" var="prices" />
										<p class="nowPrice"><span>￥</span>${prices[0]}.<span>${prices[1]}</span></p>
										<p class="befPrice">原价：${detail.orgPrice}</p>
									</div>
									<div class="onbuy"><a href="${ctx}/cart/cart.action?bsid=${detail.brandShowId}&skuid=${detail.skuId}" target="_blank"><img src="${imgDomain}/onbuy.png" alt=""></a></div>
								</div>
							</div>
						</div>
						</a>
</div>
</c:forEach>
</c:if>