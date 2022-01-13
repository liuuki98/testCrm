<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%
String basePath = request.getScheme() +"://" + request.getServerName() + ":" +request.getServerPort() + request.getContextPath()+"/";
%>
<!DOCTYPE html>
<html>
<head>
	<base href="<%=basePath%>"/>
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
			pickerPosition: "bottom-left"
		});
		//点击创建市场活动的动态窗口
		$("#addActivityBtn").click(function () {
			//取得user信息并动态添加到窗口中
			$.ajax({
				url:"workbench/activity/getUserList.do",

				dataType:"json",
				type:"get",
				success:function (data) {
					$("#create-marketActivityOwner").html("");
					$.each(data,function (index,item) {
						$("#create-marketActivityOwner").append("<option value='"+item.id+"'>"+item.name+"</option>")
					});
					$("#create-marketActivityOwner").val("${sessionScope.user.id}");

					$("#activityAddFrom")[0].reset();
					$("#createActivityModal").modal("show"); //打开窗口命令
				}


			})

		});

		//添加市场活动
		$("#save-activityBtn").click(function () {
			$.ajax({
				url:"workbench/activity/saveActivity.do",
				data:{
					"owner":$("#create-marketActivityOwner").val().trim(),
					"name":$("#create-marketActivityName").val().trim(),
					"startDate":$("#create-startTime").val().trim(),
					"endDate":$("#create-endTime").val().trim(),
					"cost":$("#create-cost").val().trim(),
					"description":$("#create-describe").val().trim(),

				},
				type:"post",
				dataType:"json",
				success:function (data) {

					$("#activityAddFrom")[0].reset();
					var flag=data.success;
					if (flag){
						pageList(1,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
						$("#createActivityModal").modal("hide");
					}else {
						alert("添加失败，请检查是否符合规范！")
					}
				}
			})
		});
		//查询模块功能，根据信息查询
		$("#selectBtn").click(function () {

			$("#hideName").val($("#selectName").val().trim());
			$("#hideOwner").val($("#selectOwner").val().trim());
			$("#hideStartTime").val($("#selectStartTime").val().trim());
			$("#hideEndTime").val($("#selectEndTime").val().trim());

			pageList(1,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));

		});
		//回车键绑定查询按钮
		$(window).keydown(function (e) {
			if(e.keyCode==13){
				$("#hideName").val($("#selectName").val().trim());
				$("#hideOwner").val($("#selectOwner").val().trim());
				$("#hideStartTime").val($("#selectStartTime").val().trim());
				$("#hideEndTime").val($("#selectEndTime").val().trim());

				pageList(1,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
			}
		})

		//分页显示功能得实现
		function pageList(pageNum,pageSize) {

			$.ajax({
				url:"workbench/activity/selectActivity.do",
				data: {
					"pageNum":pageNum,
					"pageSize":pageSize,
					"selectName":$("#hideName").val().trim(),
					"selectOwner":$("#hideOwner").val().trim(),
					"selectStartTime":$("#hideStartTime").val().trim(),
					"selectEndTime":$("#hideEndTime").val().trim(),
				},
				type:"get",
				dataType:"json",
				success:function (data) {
					var html=" ";
					$.each(data.datalist,function (index,item) {
						html+='<tr class="active">';
						html+='<td><input type="checkbox" name="xzBtn" value="'+item.id+'"/></td>';
						html+='<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/activity/detail.jsp\';">'+item.name+'</a></td>';
						html+='<td>'+item.owner+'</td>';
						html+='<td>'+item.startDate+'</td>';
						html+='<td>'+item.endDate+'</td>';
						html+='</tr>';

					});
					var totalPages=data.pagesTotal%pageSize==0?data.pagesTotal/pageSize:parseInt(data.pagesTotal/pageSize)+1;
					$("#selectDisplay").html(html);
					//分页插件
					$("#activityPage").bs_pagination({
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

		}
		//pageList的全选按钮，点击选中所有pageList元素
		$("#qxBtn").click(function () {
			$("input[name=xzBtn]").prop("checked",this.checked);
		});
		$("#selectDisplay").on("click",$("input[name=xzBtn]"),function () {
			$("#qxBtn").prop("checked",$("input[name=xzBtn]").length==$("input[name=xzBtn]:checked").length)
		});


		//删除操作
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
						url:"workbench/activity/deleteActivity.do",
						data:param,
						type:"post",
						dataType:"json",
						success:function (data) {

							if(data.success){
								pageList($("#activityPage").bs_pagination('getOption', 'currentPage')
										,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
							}else{
								alert("删除失败！");
							}
						}
					})
				}
			}

		});

		//初始化修改动态窗口
		$("#editBtn").click(function () {
			let $xz=$("input[name=xzBtn]:checked");

			if($xz.length==1){
				let id=$xz.val();

				$.ajax({
					url:"workbench/activity/getUserAndActivity.do",
					data:{
						"id":id,
					},
					type:"get",
					dataType:"json",
					success:function (data) {
						$.each(data.userList,function (index,item) {
							$("#edit-marketActivityOwner").append("<option value='"+item.id+"'>"+item.name+"</option>");

						});
						$("#edit-marketActivityOwner").val("${sessionScope.user.id}");
						$("#edit-id").val(data.activity.id);
						$("#edit-marketActivityName").val(data.activity.name);
						$("#edit-startTime").val(data.activity.startDate);
						$("#edit-endTime").val(data.activity.endDate);
						$("#edit-cost").val(data.activity.cost);
						$("#edit-describe").val(data.activity.description);

						$("#editActivityModal").modal("show");



					}
				});

			}else{
				alert("至少或至多选择一项进行修改！")
			}
		})
		//关闭修改窗口
		$("#editClose").click(function () {
			$("#editActivityModal").modal("hide");
		})
		//更新修改操作到数据据
		$("#saveEdit").click(function () {
			$.ajax({
				url:"workbench/activity/saveEditActivity.do",
				data:{
					"id":$("#edit-id").val().trim(),
					"name":$("#edit-marketActivityName").val().trim(),
					"StartDate":$("#edit-startTime").val().trim(),
					"endDate":$("#edit-endTime").val().trim(),
					"cost":$("#edit-cost").val().trim(),
					"description":$("#edit-describe").val().trim(),
					"owner":$("#edit-marketActivityOwner").val().trim(),
				},
				type:"post",
				dataType:"json",
				success:function (data) {
					if(data.success){
						pageList($("#activityPage").bs_pagination('getOption', 'currentPage')
								,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
						$("#editActivityModal").modal("hide");

					}else{
						alert("修改失败！")
					}
				}
			})
		})



	});

</script>
</head>
<body>
	<div id="hideVal" style="display: none">
		<input id="hideName">
		<input id="hideOwner">
		<input id="hideStartTime">
		<input id="hideEndTime">
	</div>

	<!-- 创建市场活动的模态窗口 -->
	<div class="modal fade" id="createActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
				</div>
				<div class="modal-body">

					<form class="form-horizontal" id="activityAddFrom" role="form">

						<div class="form-group">
							<label for="create-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<!--通过ajax动态获取信息添加到select标签中-->
								<select class="form-control" id="create-marketActivityOwner">

								</select>
							</div>
                            <label for="create-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-marketActivityName">
                            </div>
						</div>

						<div class="form-group">
							<label for="create-startTime" class="col-sm-2 control-label " >开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="create-startTime" maxlength="19">
							</div>
							<label for="create-endTime" class="col-sm-2 control-label ">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="create-endTime" maxlength="19">
							</div>
						</div>
                        <div class="form-group">

                            <label for="create-cost" class="col-sm-2 control-label">成本</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-cost">
                            </div>
                        </div>
						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-describe"></textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="save-activityBtn">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改市场活动的模态窗口 -->
	<div class="modal fade" id="editActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" role="form">

						<input style="display: none" id="edit-id">
					
						<div class="form-group">
							<label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-marketActivityOwner">

								</select>
							</div>
                            <label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-marketActivityName" value="发传单">
                            </div>
						</div>

						<div class="form-group">
							<label for="edit-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="edit-startTime" value="2020-10-10">
							</div>
							<label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="edit-endTime" value="2020-10-20">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-cost" class="col-sm-2 control-label">成本</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-cost" value="5,000">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-describe"></textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" id="editClose">关闭</button>
					<button type="button" class="btn btn-primary" id="saveEdit" >更新</button>
				</div>
			</div>
		</div>
	</div>
	
	
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>市场活动列表</h3>
			</div>
		</div>
	</div>
	<!--查询模块-->
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" type="text" id="selectName">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="selectOwner">
				    </div>
				  </div>


				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">开始日期</div>
					  <input class="form-control time" type="text" id="selectStartTime" />
				    </div>
				  </div>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">结束日期</div>
					  <input class="form-control time" type="text" id="selectEndTime">
				    </div>
				  </div>
				  
				  <button type="button" class="btn btn-default" id="selectBtn">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="addActivityBtn" ><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" id="deleteBtn" class="btn btn-danger"><span class="glyphicon glyphicon-minus" ></span> 删除</button>
				</div>
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="qxBtn" /></td>
							<td>名称</td>
                            <td>所有者</td>
							<td>开始日期</td>
							<td>结束日期</td>
						</tr>
					</thead>

					<tbody id="selectDisplay">
<%--						<tr class="active">--%>
<%--							<td><input type="checkbox" /></td>--%>
<%--							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.html';">发传单</a></td>--%>
<%--                            <td>zhangsan</td>--%>
<%--							<td>2020-10-10</td>--%>
<%--							<td>2020-10-20</td>--%>
<%--						</tr>--%>
<%--                        <tr class="active">--%>
<%--                            <td><input type="checkbox" /></td>--%>
<%--                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.html';">发传单</a></td>--%>
<%--                            <td>zhangsan</td>--%>
<%--                            <td>2020-10-10</td>--%>
<%--                            <td>2020-10-20</td>--%>
<%--                        </tr>--%>
					</tbody>
				</table>
			</div>
			
			<div style="height: 50px; position: relative;top: 30px;">
				<div id="activityPage"></div>
			</div>
			
		</div>
		
	</div>
</body>
</html>