<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>
<%
String basePath = request.getScheme() +"://" + request.getServerName() + ":" +request.getServerPort() + request.getContextPath()+"/";
%>
<!DOCTYPE html>
<html>
<head>
	<base href="<%=basePath%>" />
<meta charset="UTF-8">

<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
	<link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
	<script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
	<script type="text/javascript" src="jquery/bs_pagination/en.js"></script>

<script type="text/javascript">

	$(function(){
		pageList(1,2);
		levelConfirm("${sessionScope.user.level}");


	});

	function pageList(pageNum,pageSize){
		$.ajax({
			url:"workbench/transaction/pageList.do",
			data:{
				"pageNum":pageNum,
				"pageSize":pageSize,
				"owner":$("#select-owner").val().trim(),
				"name":$("#select-name").val().trim(),
				"customerName":$("#select-CustomerName").val().trim(),
				"stage":$("#select-stage").val().trim(),
				"type":$("#select-type").val().trim(),
				"source":$("#select-source").val().trim(),
				"contactsName":$("#select-ContactsName").val().trim(),
			},
			type:"get",
			dataType:"json",
			success:function (data) {
				var html="";
				$.each(data.datalist,function (index,item) {
					html += '<tr>';
					html +=	'<td><input type="checkbox" name="xzBtn" value="'+item.id+'"/></td>';
					html += '<td><a name="detail" style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/transaction/detail.do?id='+item.id+'\';">'+item.name+'</a></td>';
					html += '<td>'+item.customerId+'</td>';
					html += '<td>'+item.stage+'</td>';
					html += '<td>'+item.type+'</td>';
					html += '<td>'+item.owner+'</td>';
					html += '<td>'+item.source+'</td>';
					html += '<td>'+item.contactsId+'</td>';
					html += '</tr>';


				});

				var totalPages=data.pagesTotal%pageSize==0?data.pagesTotal/pageSize:parseInt(data.pagesTotal/pageSize)+1;
				$("#display").html(html);
				//分页插件
				$("#transactionPage").bs_pagination({
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

	function levelConfirm(level) {

		if(level<3){
			$("#create-Btn").prop("disabled",true);
			$("#edit-Btn").attr("disabled",true);
			$("#delete-Btn").prop("disabled",true);

			$("#display").on("click",$("a[name=detail]"),function () {
				$(this).off("click");
			});
		}
	}
	
</script>
</head>
<body>

	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>交易列表</h3>
			</div>
		</div>
	</div>
	
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="select-owner">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" type="text" id="select-name">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">客户名称</div>
				      <input class="form-control" type="text" id="select-CustomerName">
				    </div>
				  </div>
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">阶段</div>
					  <select class="form-control" id="select-stage">
					  	<option></option>
					  	<c:forEach items="${applicationScope.stage}" var="item">
							<option value="${item.value}">${item.text}</option>
						</c:forEach>
					  </select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">类型</div>
					  <select class="form-control" id="select-type">
					  	<option></option>
						  <c:forEach items="${applicationScope.transactionType}" var="item">
							  <option value="${item.value}">${item.text}</option>
						  </c:forEach>
					  </select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">来源</div>
				      <select class="form-control" id="select-source">
						  <option></option>
						  <c:forEach items="${applicationScope.source}" var="item">
							  <option value="${item.value}">${item.text}</option>
						  </c:forEach>
						</select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">联系人名称</div>
				      <input class="form-control" type="text" id="select-ContactsName">
				    </div>
				  </div>
				  
				  <button type="submit" class="btn btn-default" id="selectBtn">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 10px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button id="create-Btn" type="button" class="btn btn-primary" onclick="window.location.href='workbench/transaction/create.do';"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button id="edit-Btn" type="button" class="btn btn-default" onclick="window.location.href='workbench/transaction/edit.jsp';"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button id="delete-Btn" type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="qxBtn" /></td>
							<td>名称</td>
							<td>客户名称</td>
							<td>阶段</td>
							<td>类型</td>
							<td>所有者</td>
							<td>来源</td>
							<td>联系人名称</td>
						</tr>
					</thead>
					<tbody id="display">

					</tbody>
				</table>
			</div>
			
			<div style="height: 50px; position: relative;top: 20px;">
				<div id="transactionPage"></div>
			</div>
			
		</div>
		
	</div>
</body>
</html>