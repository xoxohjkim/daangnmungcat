<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%@ include file="/resources/include/header.jsp" %>

<style>
</style>
<script type="text/javascript">
$(function(){
	
	var contextPath = "<%=request.getContextPath()%>";

	console.log(contextPath);
	
	var test = ${loginUser.getDongne1().getId()}
	
	
	$.get(contextPath+"/dongne1", function(json){
		console.log(json)
		var datalength = json.length; 
		if(datalength >= 1){
			var sCont = "";
			for(i=0; i<datalength; i++){
				sCont += '<option value="' + json[i].id + '">' + json[i].name + '</option>';
			}
			$("select[name=dongne1]").append(sCont);
		}
	});
	
	$("select[name=dongne1]").change(function(){
		$("select[name=dongne2]").find('option').remove();
		var dong1 = $("select[name=dongne1]").val();
		$.get(contextPath+"/dongne2/"+dong1, function(json){
			var datalength = json.length; 
			var sCont = "";
			for(i=0; i<datalength; i++){
				sCont += '<option value="' + json[i].id + '">' + json[i].name + '</option>';
			}
			$("select[name=dongne2]").append(sCont);	
		});
	});
	
	
	1
	//강아지 카테고리 선택시 고양이카테고리 value 'n' 주기
	$("select[name=dogCate]").change(function(){
		var target = document.getElementById('dogCate');
		if(target.options[target.selectedIndex].text == "강아지 카테고리"){
			$('#catCate').attr('value','n');
		}
		
	});
	
	
	$(".my_location").on("click", function(){
		navigator.geolocation.getCurrentPosition(success, fail)
	    
	    return false;
	})
	
	 
	 $('#checkFree').change(function(e){
		 console.log(this);
		 console.log(e);
	        if(this.checked){
	            $('#priceDiv').fadeOut('fast');
	        	$('#price').prop('value', 0);
	        }else{
	            $('#priceDiv').fadeIn('fast');
	        }
	    });
	
	 
	 $('#insertList').on("click", function(json){
		var price = $('#price').val();	
		 var num = /^[0-9]*$/;
		 
		 if($('#title').val() == ""){
			 alert('제목을 입력해주세요.');
			 return; 
		 }else if($('#content').val() == ""){
			 alert('내용을 입력해주세요.');
			 return;
		 }else if(num.test(price) == false){
			 alert('가격은 숫자만 입력 가능합니다.');
			 return;
		 }else if($('#dogCate').val() == ""){
			 alert('카테고리를 선택해주세요.');
			 return;
		 }

		 
		 
		 var newlist = {
			member : {
				id : $('#memId').val()
			},
			dogCate : $('select[name=dogCate]').val(),
			catCate : $('#catCate').val(),
			title : $('#title').val(),
			content : $('#content').val(),
			price : $('#price').val(),			
			dongne1: {
		 		id : $('#dongne1').val()
		 	},
		 	dongne2: {
		 		id : $('#dongne2').val()
		 	}
		};
		 
		 	alert(JSON.stringify(newlist));
		 	
		 	
		 	
			$.ajax({
				url: contextPath + "/joongoSale/insert",
				type: "POST",
				contentType:"application/json; charset=UTF-8",
				dataType: "json",
				cache : false,
				data : JSON.stringify(newlist),
				beforeSend : function(xhr)
	            {   /*데이터를 전송하기 전에 헤더에 csrf값을 설정한다*/
	                xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
	            },
				success: function() {
					alert('완료되었습니다.');
					window.location.replace(contextPath+"/joongo_list");
				},
				error: function(request,status,error){
					alert('에러!!!!' + request.status+request.responseText+error);
				}
			});
			console.log(contextPath+"/insert");	
	 
	});
	 
		//자바스크립트에서 DOM을 가져오기(문서객체모델 가져오기) -> 한번 다 읽고나서 
		var form = document.forms[0]; //젤 첫번째 form을 dom으로 받겠다.
		
		var addFileBtn = document.getElementById("addFileBtn");
		var delFileBtn = document.getElementById("delFileBtn");
		var fileArea = document.getElementById("fileArea");
		var cnt = 1;
		
		
		//업로드input 미리만들지 않고 필요한 만큼 증가
		$("#addFileBtn").on("click", function() {
			if (cnt < 10) {
				cnt++;
				var element = document.createElement("input");
				element.type = "file";
				element.name = "upfile" + cnt;
				element.id = "upfile" + cnt;
				var element2 = document.createElement("img");
				element2.id = "productImg"+cnt;
				var element3 = document.createElement('div');
				element3.setAttribute("id", "preview"+cnt);

				fileArea.appendChild(element);
				fileArea.appendChild(element2);
				fileArea.appendChild(element3);
				fileArea.appendChild(document.createElement("br"));
				
			} else {
				alert("파일은 10개까지 추가 가능합니다.");
			}
 
		});
		
		$("#delFileBtn").on("click", function() {
			if (cnt > 1) {
				cnt--;
				var inputs = fileArea.getElementsByTagName('input');
				var imgs = fileArea.getElementsByTagName('img');
				var divs = fileArea.getElementsByTagName('div');
				var brArr = fileArea.getElementsByTagName('br');
				fileArea.removeChild(brArr[brArr.length-1]);
				fileArea.removeChild(imgs[imgs.length-1]);
				fileArea.removeChild(divs[divs.length-1]);
				fileArea.removeChild(inputs[inputs.length-1]);
			} else {
				alert("상품 사진 최소 1개는 업로드 필요합니다.");
			}

		});

		
});



</script>
<div id="subContent">
	<h2 id="subTitle">글쓰기</h2>
	<div id="pageCont" class="s-inner">
		<article>
		<form action="/insert" method="POST">
		<div>
		<table border="1">
			<colgroup>
				<col width="20%">
				<col width="80%">
			</colgroup>
			<tr>
				<td>아이디</td>
				<td><input type="text" id="memId" value="${loginUser.getId()}" readonly="readonly"></td>
			</tr>
			<tr>
				<td>동네</td>
				<td>
					<div id="add_location" class="s-inner">
						<div class="list_top">
							<button class="my_location">내 위치</button>
						<div>
						<select name="dongne1" id="dongne1">
							<option value="0">지역을 선택하세요</option>
						</select> 
						<select name="dongne2" id="dongne2">
							<option value="0">동네를 선택하세요</option>
						</select>
						</div>
						</div>
					</div>
					
				</td>
			</tr>
			
			<tr>
				<td>사진 추가 / 제거 <br>
					<input type="button" value="파일추가" id="addFileBtn">
					<input type="button" value="파일제거" id="delFileBtn">
				</td>
				<td>
					<div id="fileArea">
						<input type="file" id="upfile1" name="upfile1" onchange="imageChange()">
						<img id="productImg1">
						<div id="preview1"></div>
					</div>
				</td>
			</tr>
			<tr>
			<tr>	
				<td>카테고리</td>
				<td>
					<select name="dogCate" id="dogCate" >
						<option value="">카테고리를 선택하세요.</option>
						<option value="y">강아지 카테고리</option>
						<option value="n">고양이 카테고리 </option>
						<option value="y"> 모두 포함 </option>
					</select>
					<input type="hidden" name="catCate" value="y" id="catCate">
				</td>
			</tr>
			<tr>
				<td>제목(상품명)</td>
				<td><input type="text" name="title" id="title"></td>
			</tr>
			<tr>
				<td>가격</td>
				<td>
					<div id="priceDiv"><input type="text" name="price" id="price"></div>
					<input type="checkbox" id="checkFree" name="price" value="0">무료나눔하기
				</td>
			<tr>
			<tr>
				<td>내용</td>
				<td><textarea class="content" name="content" id="content"></textarea>
			</tr>
			
		<!-- 	<tr>
				<td></td>
				<td>
					<select>
						<option>판매상태</option>
						<option>판매중</option>		
					</select>
					
				</td>
			</tr>
		 -->	
		 	<tr>
			<td colspan="2">
					<input type="button" id="insertList" value="글 등록하기">
				</td>
			</tr>
		</table>
		</div>
		</form>
		</article>
	
	</div>
</div>
<jsp:include page="/resources/include/footer.jsp"/>