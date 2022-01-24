<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";

%>
<html>
<head>
	<base href="<%=basePath %>"/>
	<meta charset="UTF-8">
<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
	<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	<script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
	<script type="text/javascript" src="jquery/bs_pagination/en.js"></script>
<script>
	$(function () {
		pageList(1,10);

		$("#qxBtn").click(function () {
			$("input[name=xzBtn]").prop("checked",this.checked);
		});
		$("#display").on("click",$("#input[name=xzBtn]"),function () {
			$("#qxBtn").prop("checked",$("input[name=xzBtn]:checked").length==$("input[name=xzBtn]").length);
		});


		//删除
		$("#deleteBtn").click(function () {

			var param="";
			var $buttons=$("input[name=xzBtn]:checked");
			if($buttons.length==0){
				alert("请选择要删除的项目后点击删除按钮！")
			}else{ //选择了至少一个选项

				if(confirm("确定要删除吗？")){

					for(var i=0;i<$buttons.length;i++){
						param+= "id="+$($buttons[i]).val();
						if(i<$buttons.length-1){
							param += "&";
						}
					}


					$.ajax({
						url:"settings/dic/deleteDicValue.do",
						data:param,
						type:"post",
						dataType:"json",
						success:function (data) {

							if(data.success){

								$("#qxBtn").prop("checked",false);
								pageList($("#pageList").bs_pagination('getOption', 'currentPage')
										,$("#pageList").bs_pagination('getOption', 'rowsPerPage'));
							}else{
								alert("删除失败！");
							}
						}
					})
				}
			}

		});

		$("#editBtn").click(function () {
			var $buttons=$("input[name=xzBtn]:checked");
			if($buttons.length!=1){
				alert("至少/至多只能选择一个元素！")
			}else{
				window.location.href='settings/dictionary/type/Valueedit.do?id='+$($buttons[0]).val();
			}
		})
	});

	function pageList(pageNum,pageSize){

		$.ajax({
			url:"settings/dic/getDicValue.do",
			data:{
				"pageNum":pageNum,
				"pageSize":pageSize,
			},
			type:"get",
			dataType:"json",
			success:function (data) {
				var html="";
				$.each(data.datalist,function (index,item) {
					html += '<tr>';
					html +=	'<td><input type="checkbox" name="xzBtn" value="'+item.id+'"/></td>';
					html += '<td><a style="text-decoration: none; cursor: pointer;" >'+(index+1)+'</a></td>';
					html += '<td>'+item.value+'</td>';
					html += '<td>'+item.text+'</td>';
					html += '<td>'+item.orderNo+'</td>';
					html += '<td>'+item.typeCode+'</td>';
					html += '</tr>';




				});

				var totalPages=data.pagesTotal%pageSize==0?data.pagesTotal/pageSize:parseInt(data.pagesTotal/pageSize)+1;
				$("#display").html(html);
				//分页插件
				$("#pageList").bs_pagination({
					currentPage: pageNum, // 页码
					rowsPerPage: pageSize, // 每页显示的记录条数
					maxRowsPerPage: 10, // 每页最多显示的记录条数
					totalPages: totalPages, // 总页数
					totalRows: data.pagesTotal, // 总记录条数

					visiblePageLinks: 3, // 显示几个卡片

					showGoToPage: true,
					showRowsPerPage: true,
					showRowsInfo: true,
					showRowsDefaultInfo: true,

					onChangePage : function(event, data){
						pageList(data.currentPage , data.rowsPerPage);
					}
				});
			}
		})
	};
</script>
</head>
<body>

	<div>
		<div style="position: relative; left: 30px; top: -10px;">
			<div class="page-header">
				<h3>字典值列表</h3>
			</div>
		</div>
	</div>
	<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;left: 30px;">
		<div class="btn-group" style="position: relative; top: 18%;">
		  <button type="button" class="btn btn-primary" onclick="window.location.href='settings/dictionary/value/enterSave.do'"><span class="glyphicon glyphicon-plus"></span> 创建</button>
		  <button type="button" class="btn btn-default" id="editBtn"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
		  <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
	</div>
	<div style="position: relative; left: 30px; top: 20px;">
		<table class="table table-hover">
			<thead>
				<tr style="color: #B3B3B3;">
					<td><input type="checkbox" id="qxBtn"/></td>
					<td>序号</td>
					<td>字典值</td>
					<td>文本</td>
					<td>排序号</td>
					<td>字典类型编码</td>
				</tr>
			</thead>
			<tbody id="display">

			</tbody>
		</table>
		<div>
			<div id="pageList"></div>
		</div>
	</div>
	
</body>
</html>