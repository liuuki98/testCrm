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
	<script type="text/javascript" src="jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>

<script type="text/javascript">

	$(function(){
		
		//定制字段
		$("#definedColumns > li").click(function(e) {
			//防止下拉菜单消失
	        e.stopPropagation();
	    });
		//自动补全插件
		$("#create-customerName").typeahead({
			source: function (query, process) {
				$.get(
						"workbench/contacts/getCustomerByName.do",
						{"name": query},
						function (data) {
							//alert(data);
							process(data);
						},
						"json"
				);
			},
			delay: 500
		});

		//添加日历插件
		$(".time-bottom").datetimepicker({
			language: "zh-CN",
			format: "yyyy-mm-dd",//显示格式
			minView: 2,//设置只显示到月份
			initialDate: new Date(),//初始化当前日期
			weekStart: 1,
			autoclose: true,//选中自动关闭
			todayBtn: true, //显示今日按钮
			clearBtn: true,
			pickerPosition: "bottom-left"
		});

		pageList(1,2);

		//打开创建联系人的模态窗口
		$("#createModal").click(function () {
			$.ajax({
				url:"workbench/contacts/getUserList.do",
				type:"get",
				dataType:"json",
				success:function (data) {
					$("#create-contactsOwner").html("");
					$.each(data,function (index,item) {
						$("#create-contactsOwner").append($("<option value='"+item.id+"'>"+item.name+"</option>"));

					});
					$("#form-horizontal")[0].reset();
					$("#create-contactsOwner").val("${sessionScope.user.id}");

					$("#createContactsModal").modal("show");
				}


			});
		});

		//保存创建联系人的模态窗口内容
		$("#saveConBtn").click(function () {
			$.ajax({
				url:"workbench/contacts/saveCustomer.do",
				data:{
					"owner":$("#create-contactsOwner").val().trim(),
					"source":$("#create-clueSource").val(),
					"customerId":$("#create-customerName").val().trim(),
					"fullname":$("#create-surname").val().trim(),
					"appellation":$("#create-call").val().trim(),
					"email":$("#create-email").val().trim(),
					"mphone":$("#create-mphone").val().trim(),
					"job":$("#create-job").val().trim(),
					"birth":$("#create-birth").val().trim(),
					"description":$("#create-describe").val().trim(),
					"contactSummary":$("#create-contactSummary").val().trim(),
					"nextContactTime":$("#create-nextContactTime").val().trim(),
					"address":$("#create-address").val().trim(),

				},
				type:"post",
				dataType:"json",
				success:function (data) {
					if(data.success){
						pageList(1,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
						$("#createContactsModal").modal("hide");
					}else{
						alert("添加失败！")
					}
				}
			})
		});

		//查询功能
		$("#selectBtn").click(function () {
			$("#hidden-name").val($("#select-fullname").val().trim());
			$("#hidden-owner").val($("#select-owner").val().trim());
			$("#hidden-source").val($("#select-source").val());
			$("#hidden-customerName").val($("#select-customerName").val().trim());
			$("#hidden-birth").val($("#select-birth").val().trim());
			pageList(1,2);
		});

		//选定功能
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
						url:"workbench/contacts/deleteContacts.do",
						data:param,
						type:"post",
						dataType:"json",
						success:function (data) {

							if(data.success){
								$("#qxBtn").prop("checked",false);
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



		
	});

	function pageList(pageNum,pageSize){

		$.ajax({
			url:"workbench/contacts/pageList.do",
			data:{
				"pageNum":pageNum,
				"pageSize":pageSize,
				"fullname":$("#hidden-name").val().trim(),
				"owner":$("#hidden-owner").val().trim(),
				"source":$("#hidden-source").val(),
				"customerName":$("#hidden-customerName").val().trim(),
				"birth":$("#hidden-birth").val().trim()
			},
			type:"get",
			dataType:"json",
			success:function (data) {
				var html="";
				$.each(data.datalist,function (index,item) {
					html += '<tr>';
					html +=	'<td><input type="checkbox" name="xzBtn" value="'+item.id+'"/></td>';
					html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/contacts/detail.do?id='+item.id+'\';">'+item.fullname+'</a></td>';
					html += '<td>'+item.customerId+'</td>';
					html += '<td>'+item.owner+'</td>';
					html += '<td>'+item.source+'</td>';
					html += '<td>'+item.birth+'</td>';

					html += '</tr>';


				});

				var totalPages=data.pagesTotal%pageSize==0?data.pagesTotal/pageSize:parseInt(data.pagesTotal/pageSize)+1;
				$("#display").html(html);
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
	};
	
</script>
</head>
<body>
<input type="hidden" id="hidden-owner">
<input type="hidden" id="hidden-name">
<input type="hidden" id="hidden-customerName">
<input type="hidden" id="hidden-source">
<input type="hidden" id="hidden-birth">

	
	<!-- 创建联系人的模态窗口 -->
	<div class="modal fade" id="createContactsModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" onclick="$('#createContactsModal').modal('hide');">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabelx">创建联系人</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form" id="form-horizontal">
					
						<div class="form-group">
							<label for="create-contactsOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-contactsOwner">

								</select>
							</div>
							<label for="create-clueSource" class="col-sm-2 control-label">来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-clueSource">
								  <option></option>
									<c:forEach var="item" items="${applicationScope.source}">
										<option value="${item.value}">${item.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-surname">
							</div>
							<label for="create-call" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-call">
								  <option></option>
									<c:forEach var="item" items="${applicationScope.appellation}">
										<option value="${item.value}">${item.text}</option>
									</c:forEach>
								</select>
							</div>
							
						</div>
						
						<div class="form-group">
							<label for="create-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-job">
							</div>
							<label for="create-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-mphone">
							</div>
						</div>
						
						<div class="form-group" style="position: relative;">
							<label for="create-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-email">
							</div>
							<label for="create-birth" class="col-sm-2 control-label">生日</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time-bottom" id="create-birth">
							</div>
						</div>
						
						<div class="form-group" style="position: relative;">
							<label for="create-customerName" class="col-sm-2 control-label">客户名称</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-customerName" placeholder="支持自动补全，输入客户不存在则新建">
							</div>
						</div>
						
						<div class="form-group" style="position: relative;">
							<label for="create-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-describe"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control time-bottom" id="create-nextContactTime">
								</div>
							</div>
						</div>

                        <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="create-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="create-address">北京大兴区大族企业湾</textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" id="saveConBtn">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改联系人的模态窗口 -->
	<div class="modal fade" id="editContactsModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">修改联系人</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="edit-contactsOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-contactsOwner">

								</select>
							</div>
							<label for="edit-clueSource1" class="col-sm-2 control-label">来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-clueSource1">
								  <option></option>
									<c:forEach var="item" items="${applicationScope.source}">
										<option value="${item.value}">${item.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-surname" value="李四">
							</div>
							<label for="edit-call" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-call">
								  <option></option>
									<c:forEach var="item" items="${applicationScope.appellation}">
										<option value="${item.value}">${item.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-job" value="CTO">
							</div>
							<label for="edit-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-mphone" value="12345678901">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-email" value="lisi@bjpowernode.com">
							</div>
							<label for="edit-birth" class="col-sm-2 control-label">生日</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-birth">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-customerName" class="col-sm-2 control-label">客户名称</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-customerName" placeholder="支持自动补全，输入客户不存在则新建" value="动力节点">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-describe">这是一条线索的描述信息</textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="edit-contactSummary"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control" id="edit-nextContactTime">
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="edit-address">北京大兴区大族企业湾</textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" data-dismiss="modal">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	
	
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>联系人列表</h3>
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
				      <div class="input-group-addon">姓名</div>
				      <input class="form-control" type="text" id="select-fullname">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">客户名称</div>
				      <input class="form-control" type="text" id="select-customerName">
				    </div>
				  </div>
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">来源</div>
				      <select class="form-control" id="select-source">
						  <option></option>
						  <c:forEach var="item" items="${applicationScope.source}">
							  <option value="${item.value}">${item.text}</option>
						  </c:forEach>
						</select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">生日</div>
				      <input class="form-control" type="text" id="select-birth">
				    </div>
				  </div>
				  
				  <button type="button" class="btn btn-default" id="selectBtn">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 10px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="createModal"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editModal"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
				
			</div>
			<div style="position: relative;top: 20px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="qxBtn" /></td>
							<td>姓名</td>
							<td>客户名称</td>
							<td>所有者</td>
							<td>来源</td>
							<td>生日</td>
						</tr>
					</thead>
					<tbody id="display">

					</tbody>
				</table>
			</div>
			
			<div style="height: 50px; position: relative;top: 10px;">
				<div id="activityPage"></div>
			</div>
			
		</div>
		
	</div>
</body>
</html>