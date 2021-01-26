<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ include file="/resources/include/header.jsp" %>

<script>
$(function(){
	var contextPath = "<%=request.getContextPath()%>";
	
	$("select[name='dogCate.id']").val(${pdt.dogCate.id}).prop("selected", true)
	$("select[name='catCate.id']").val(${pdt.catCate.id}).prop("selected", true)
	$("select[name='deliveryKind']").val("${pdt.deliveryKind}").prop("selected", true)
	
	$("input[name='saleYn']:radio[value='${pdt.saleYn}']").prop('checked', true)
	
	$("select[name='deliveryKind']").change(function(){
		if ($(this).val() == "무료배송"){
			$("input[name='deliveryCondition']").val("0").attr("disabled", true);
			$("input[name='deliveryPrice']").val("0").attr("disabled", true);
		} else if ($(this).val() == "유료배송"){
			$("input[name='deliveryCondition']").val("0").attr("disabled", true);
			$("input[name='deliveryPrice']").val("").attr("disabled", false);
		} else {
			$("input[name='deliveryCondition']").val("").attr("disabled", false);
			$("input[name='deliveryPrice']").val("").attr("disabled", false);
		}
	})
	
	
	$("#pdt_update_btn").click(function(e){
		e.preventDefault();
		
		if ($("select[name='dogCate']").val() == "" && $("select[name='catCate']").val() == ""){
			alert("상품 카테고리를 한개 이상 선택해주세요.")
			return false;
		}
		
		if ($("input[name='name']").val() == ""){
			alert("상품명을 입력해주세요.");
			$("input[name='name']").focus();
			
			return false;
		}
		
		if ($("input[name='price']").val() == ""){
			alert("금액을 입력해주세요.");
			$("input[name='price']").focus();
			
			return false;
		}
		
		if ($("input[name='stock']").val() == ""){
			alert("재고를 입력해주세요.");
			$("input[name='stock']").focus();
			
			return false;
		}
		
		if ($("select[name='deliveryKind']").val() == "조건부 무료배송"){
			if($("input[name='deliveryCondition']").val() == "") {
				alert("조건 금액을 입력해주세요.")
				$("input[name='deliveryCondition']").focus();
				
				return false;
			}
			if($("input[name='deliveryPrice']").val() == "") {
				alert("배송비를 입력해주세요.")
				$("input[name='deliveryPrice']").focus();
				
				return false;
			}
		}
		
		if (confirm("정말 수정하시겠습니까?") == true){
		} else{
		    return false;
		}
		
		$("form[name='pdtWrite']").submit()
	})
})
</script>

<div id="subContent">
	<h2 id="subTitle">쇼핑몰 상품 추가</h2>
	<div id="pageCont" class="s-inner">
		<div class="mall_pdt_write">
			<form name="pdtWrite" action="<%=request.getContextPath() %>/mall/product/update" method="post" enctype="multipart/form-data" accept-charset="utf-8">
				<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" >
				<input type="hidden" name="id" value="${pdt.id}">
				<ul>
					<li>
						<p>멍</p>
						<div>
							<select name="dogCate.id">
								<c:forEach items="${dogCate}" var="list">
									<option value="${list.id}">${list.name}</option>
								</c:forEach>
							</select>
						</div>
					</li>
					<li>
						<p>냥</p>
						<div>
							<select name="catCate.id">
								<c:forEach items="${catCate}" var="list">
									<option value="${list.id}">${list.name}</option>
								</c:forEach>
							</select>
						</div>
					</li>
					<li>
						<p>상품명</p>
						<div>
							<input type="text" name="name" value="${pdt.name}">
						</div>
					</li>
					<li>
						<p>가격</p>
						<div>
							<input type="text" name="price" value="${pdt.price}">
						</div>
					</li>
					<li>
						<p>내용</p>
						<div>
							<textarea name="content">${pdt.content}</textarea>
						</div>
					</li>
					<li>
						<p>판매여부</p>
						<div>
							<input type="radio" name="saleYn" value="Y"> 판매
							<input type="radio" name="saleYn" value="N"> 품절
						</div>
					</li>
					<li>
						<p>재고</p>
						<div>
							<input type="text" name="stock" value="${pdt.stock}">
						</div>
					</li>
					<li>
						<p>배송비 종류</p>
						<div>
							<select name="deliveryKind">
								<option value="조건부 무료배송">조건부 무료배송</option>
								<option value="무료배송">무료배송</option>
								<option value="유료배송">유료배송</option>
							</select>
						</div>
					</li>
					<li>
						<p>조건 금액</p>
						<div>
							<input type="text" name="deliveryCondition" value="${pdt.deliveryCondition}">
						</div>
					</li>
					<li>
						<p>배송비</p>
						<div>
							<input type="text" name="deliveryPrice" value="${pdt.deliveryPrice}">
						</div>
					</li>
					<li>
						<p>상품 썸네일 이미지</p>
						<div>
							<input multiple="multiple" type="file" name="thumbFile" accept="image/*">
							<input type="hidden" name="image1" value="${pdt.image1}">
						</div>
					</li>
					<li>
						<p>상품 상세 이미지</p>
						<div>
							<input multiple="multiple" type="file" name="file">
							<input type="hidden" name="image2" value="${pdt.image2}">
							<input multiple="multiple" type="file" name="file">
							<input type="hidden" name="image3" value="${pdt.image3}">
						</div>
					</li>
				</ul>
				
				<input type="submit" id="pdt_update_btn" value="수정">
				<a href="#" class="history_back_btn">목록</a>
			</form>
		</div>
	</div>
</div>

<jsp:include page="/resources/include/footer.jsp"/>