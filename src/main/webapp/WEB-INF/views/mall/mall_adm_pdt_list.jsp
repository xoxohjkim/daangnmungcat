<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/resources/include/header.jsp" %>
<script>
$(function(){
	var contextPath = "<%=request.getContextPath()%>";
	
	$(".mall_adm_list .delete_btn").click(function(){
		if (confirm("정말 삭제하시겠습니까??") == true){
		} else{
		    return false;
		}
	})
});
</script>
<div id="subContent">
	<h2 id="subTitle">${name}</h2>
	<div id="pageCont" class="s-inner mall_adm_list">
		<a href="<%=request.getContextPath() %>/mall/product/write" class="write_btn">상품등록</a>
		<table>
			<colgroup>
				<col width="13%">
				<col width="28%">
				<col width="28%">
				<col width="11%">
				<col width="10%">
				<col width="10%">
			</colgroup>
			<thead>
				<tr>
					<th rowspan="2">이미지</th>
					<th>멍</th>
					<th>냥</th>
					<th>가격</th>
					<th rowspan="2">판매중</th>
					<th rowspan="2">관리</th>
				</tr>
				<tr>
					<th colspan="2">상품명</th>
					<th>재고</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach items="${list}" var="list">
				<tr>
					<td rowspan="2">
						<c:if test="${empty list.image1}">
						<img src="<%=request.getContextPath() %>/resources/images/no_image.jpg">
						</c:if>
						<c:if test="${not empty list.image1}">
						<img src="<c:url value="/resources${list.image1}" />">
						</c:if>
					</td>
					<td>${list.dogCate.name}</td>
					<td>${list.catCate.name}</td>
					<td class="tc"><fmt:formatNumber value="${list.price}" /> 원</td>
					<td rowspan="2"  class="tc">${list.saleYn}</td>
					<td rowspan="2">
						<a href="<%=request.getContextPath() %>/mall/product/update?id=${list.id}">수정</a>
						<a href="<%=request.getContextPath() %>/mall/product/delete?id=${list.id}" class="delete_btn">삭제</a>
						<a href="<%=request.getContextPath() %>/mall/product/${list.id}">보기</a>
					</td>
				</tr>
				<tr>
					<td colspan="2">${list.name}</td>
					<td class="tc"><fmt:formatNumber value="${list.stock}" /> 개</td>
				</tr>
				</c:forEach>
			</tbody>
		</table>
		
		<div class="board_page">
		    <c:if test="${pageMaker.prev}">
		    	<p><a href="<%=request.getContextPath()%>/admin/mall/product/list${pageMaker.makeQuery(pageMaker.startPage - 1)}">이전</a></p>
		    </c:if> 
			<ul>
			
			  <c:forEach begin="${pageMaker.startPage}" end="${pageMaker.endPage}" var="idx">
			  	<li><a href="<%=request.getContextPath()%>/admin/mall/product/list${pageMaker.makeQuery(idx)}">${idx}</a></li>
			  </c:forEach>
			</ul>
			
			  <c:if test="${pageMaker.next && pageMaker.endPage > 0}">
			    <p><a href="<%=request.getContextPath()%>/admin/mall/product/list${pageMaker.makeQuery(pageMaker.endPage + 1)}">다음</a></p>
			  </c:if> 
		</div>
	</div>
</div>


<jsp:include page="/resources/include/footer.jsp"/>