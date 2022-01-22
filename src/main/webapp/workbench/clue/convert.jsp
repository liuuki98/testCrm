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


	<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
<script type="text/javascript">
	$(function(){
		//添加日历插件
		$(".time").datetimepicker({
			language:  "zh-CN",
			format: "yyyy-mm-dd",//显示格式
			minView: 2,//设置只显示到月份
			initialDate: new Date(),//初始化当前日期
			weekStart:1,
			autoclose: true,//选中自动关闭
			todayBtn: true, //显示今日按钮
			clearBtn : true,
			pickerPosition: "top-left"
		});

		$("#isCreateTransaction").click(function(){
			if(this.checked){
				$("#create-transaction2").show(200);
			}else{
				$("#create-transaction2").hide(200);
			}
		});
		//打开搜索市场活动的模态窗口
		$("#searchBtn").click(function () {
			$("#searchText").val("");
			$("#display").html("");
			$("#searchActivityModal").modal("show");
		});
		//搜索市场活动的模态窗口中搜索功能
		$("#searchActivityBtn").click(function () {
			$.ajax({
				url:"workbench/clue/searchActivityByName.do",
				data:{
					"name":$("#searchText").val().trim(),
				},
				type:"get",
				dataType:"json",
				success:function (data) {

					var html ="";
					$.each(data,function (index,item) {

						html += '<tr>';
						html += '<td><input type="radio"  name="activity" onclick="selected(\''+item.id+'\',)"/></td>';
						html += '<td id="'+item.id+'" >'+item.name+'</td>';
						html += '<td>'+item.startDate+'</td>';
						html += '<td>'+item.endDate+'</td>';
						html += '<td>'+item.owner+'</td>';
						html += '</tr>';
					});

					$("#display").html(html);
				}
			})
		});
		//取消按钮，返回到线索详细页面
		$("#cancleBtn").click(function () {
			window.history.back();
		});
		//进行线索的业务转换
		$("#convertBtn").click(function () {
			if($("#isCreateTransaction").prop("checked")){
				$("#convertForm").submit();
			}else{
				window.location.href="workbench/clue/convert.do?clueId=${param.clueId}"
			}
		})

	});
	//选定需要转换的市场活动，填充到表中
	function selected(id) {
		$("#activityId").val(id);
		$("#activity").val($("#"+id).html());
		$("#searchActivityModal").modal("hide");
	}
</script>

</head>
<body>
	
	<!-- 搜索市场活动的模态窗口 -->
	<div class="modal fade" id="searchActivityModal" role="dialog" >
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">搜索市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" class="form-control" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询" id="searchText">

							  <button type="button" id="searchActivityBtn" class="btn btn-default"><span class="glyphicon glyphicon-search form-control-feedback"></span> 	</button>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
								<td></td>
							</tr>
						</thead>
						<tbody id="display">
<%--							<tr>--%>
<%--								<td><input type="radio" name="activity"/></td>--%>
<%--								<td>发传单</td>--%>
<%--								<td>2020-10-10</td>--%>
<%--								<td>2020-10-20</td>--%>
<%--								<td>zhangsan</td>--%>
<%--							</tr>--%>
<%--							<tr>--%>
<%--								<td><input type="radio" name="activity"/></td>--%>
<%--								<td>发传单</td>--%>
<%--								<td>2020-10-10</td>--%>
<%--								<td>2020-10-20</td>--%>
<%--								<td>zhangsan</td>--%>
<%--							</tr>--%>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>

	<div id="title" class="page-header" style="position: relative; left: 20px;">
		<h4>转换线索 <small>${param.name}${param.appellation}-${param.company}</small></h4>
	</div>
	<div id="create-customer" style="position: relative; left: 40px; height: 35px;">
		新建客户：${param.company}
	</div>
	<div id="create-contact" style="position: relative; left: 40px; height: 35px;">
		新建联系人：${param.name}${param.appellation}
	</div>
	<div id="create-transaction1" style="position: relative; left: 40px; height: 35px; top: 25px;">
		<input type="checkbox" id="isCreateTransaction"/>
		为客户创建交易
	</div>
	<div id="create-transaction2" style="position: relative; left: 40px; top: 20px; width: 80%; background-color: #F7F7F7; display: none;" >
	
		<form action="workbench/clue/convert.do" method="post" id="convertForm">
			<input type="hidden" value="a" name="flag"/>
			<input type="hidden" id="clueID" value="${param.clueId}" name="clueId"/>
		  <div class="form-group" style="width: 400px; position: relative; left: 20px;">
		    <label for="amountOfMoney">金额</label>
		    <input type="text" class="form-control" id="amountOfMoney" name="money">
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="tradeName">交易名称</label>
		    <input type="text" class="form-control" id="tradeName" name="name">
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="expectedClosingDate">预计成交日期</label>
		    <input type="text" class="form-control time" id="expectedClosingDate" name="expectedDate">
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="stage">阶段</label>
		    <select id="stage"  class="form-control" name="stage">
		    	<option></option>
		    	<c:forEach var="item" items="${applicationScope.stage}">
					<option value="${item.value}">${item.text}</option>
				</c:forEach>
		    </select>
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="activity">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);" id="searchBtn" style="text-decoration: none;"><span class="glyphicon glyphicon-search"></span></a></label>
		    <input type="text" class="form-control" id="activity" placeholder="点击上面搜索" readonly>
			  <input type="hidden" id="activityId" name="activityId">
		  </div>
		</form>
		
	</div>
	
	<div id="owner" style="position: relative; left: 40px; height: 35px; top: 50px;">
		记录的所有者：<br>
		<b>zhangsan</b>
	</div>
	<div id="operation" style="position: relative; left: 40px; height: 35px; top: 100px;">
		<input class="btn btn-primary" type="button" value="转换" id="convertBtn">
		&nbsp;&nbsp;&nbsp;&nbsp;
		<input class="btn btn-default" type="button" value="取消" id="cancleBtn">
	</div>
</body>
</html>