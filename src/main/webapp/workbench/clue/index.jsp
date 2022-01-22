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
		pageList(1,2);
		//初始化创建线索的模态窗口
		$("#createBtn").click(function () {


			$.ajax({
				url:"workbench/clue/getUserList.do",
				type:"get",
				dataType:"json",
				success:function (data) {
					$("#create-clueOwner").html("");
					$.each(data,function (index,item) {
						$("#create-clueOwner").append($("<option value='"+item.id+"'>"+item.name+"</option>"));
					});
					$("#reset")[0].reset();
					$("#create-clueOwner").val("${user.id}");

					$("#createClueModal").modal("show");
				}
			})
		});
		//关闭创建线索的模态窗口
		$("#closeModalBtn").click(function () {
			$("#createClueModal").modal("hide");

		});
		//保存线索到数据库
		$("#saveBtn").click(function () {
			$.ajax({
				url:"workbench/clue/saveClue.do",
				data:{
					"fullname":$("#create-surname").val().trim(),
					"appellation":$("#create-call").val().trim(),
					"owner":$("#create-clueOwner").val().trim(),
					"company":$("#create-company").val().trim(),
					"job":$("#create-job").val().trim(),
					"email":$("#create-email").val().trim(),
					"phone":$("#create-phone").val().trim(),
					"website":$("#create-website").val().trim(),
					"mphone":$("#create-mphone").val().trim(),
					"state":$("#create-status").val().trim(),
					"source":$("#create-source").val().trim(),
					"description":$("#create-describe").val().trim(),
					"contactSummary":$("#create-contactSummary").val().trim(),
					"nextContactTime":$("#create-nextContactTime").val().trim(),
					"address":$("#create-address").val().trim()
				},
				type:"post",
				dataType:"json",
				success:function(data){
					if(data.success){
						pageList(1,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
						$("#createClueModal").modal("hide");
					}
			}

			})
		});

		//条件搜索查询功能
		$("#selectBtn").click(function () {
			$("#hidden-fullname").val($("#select-name").val().trim());
			$("#hidden-company").val($("#select-company").val().trim());
			$("#hidden-owner").val($("#select-owner").val().trim());
			$("#hidden-source").val($("#select-source").val().trim());
			$("#hidden-state").val($("#select-stage").val());
			$("#hidden-phone").val($("#select-phone").val().trim());
			$("#hidden-mphone").val($("#select-mphone").val().trim());
			pageList(1,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));

		});
		//网页回车键为进行查询
		$(window).keydown(function (e) {
			if(e.keyCode==13){
				$("#hidden-fullname").val($("#select-name").val().trim());
				$("#hidden-company").val($("#select-company").val().trim());
				$("#hidden-owner").val($("#select-owner").val().trim());
				$("#hidden-source").val($("#select-source").val().trim());
				$("#hidden-state").val($("#select-stage").val().trim());
				$("#hidden-phone").val($("#select-phone").val().trim());
				$("#hidden-mphone").val($("#select-mphone").val().trim());
				pageList(1,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
			}
		});

		//打开修改模态
		$("#editBtn").click(function () {
			$("#edit-clueOwner").val("");
			var $xz = $("input[name=xzBtn]:checked");

			if($xz.length!=1){
				alert("至少/至多选择一个元素进行修改！")
			}else{
				var clueId=$xz.val();
				$.ajax({
					url:"workbench/clue/editInit.do",
					data:{
						"clueId":clueId,

					},
					type:"get",
					dataType:"json",
					success:function (data) {
						$.each(data.userList,function (index,item) {
							$("#edit-clueOwner").append("<option value='"+item.id+"'>"+item.name+"</option>");
						});
						$("#edit-clueOwner").val("${sessionScope.user.id}");
						$("#hidden-clueId").val(clueId);
						$("#edit-company").val(data.clue.company);
						$("#edit-call").val(data.clue.appellation);
						$("#edit-surname").val(data.clue.fullname);
						$("#edit-job").val(data.clue.job);
						$("#edit-email").val(data.clue.email);
						$("#edit-phone").val(data.clue.phone);
						$("#edit-website").val(data.clue.website);
						$("#edit-mphone").val(data.clue.mphone);
						$("#edit-status").val(data.clue.state);
						$("#edit-source").val(data.clue.source);
						$("#edit-describe").val(data.clue.description);
						$("#edit-contactSummary").val(data.clue.contactSummary);
						$("#edit-nextContactTime").val(data.clue.nextContactTime);
						$("#edit-address").val(data.clue.address);
						$("#editClueModal").modal("show");
					}

				});
			}

		});

		//保存修改模态
		$("#updateBtn").click(function () {
			$.ajax({
				url:"workbench/clue/updateClue.do",
				data:{
					"id":$("#hidden-clueId").val(),
					"owner":$("#edit-clueOwner").val(),
					"company":$("#edit-company").val(),
					"appellation":$("#edit-call").val(),
					"fullname":$("#edit-surname").val(),
					"job":$("#edit-job").val(),
					"email":$("#edit-email").val(),
					"phone":$("#edit-phone").val(),
					"website":$("#edit-website").val(),
					"mphone":$("#edit-mphone").val(),
					"state":$("#edit-status").val(),
					"source":$("#edit-source").val(),
					"description":$("#edit-describe").val(),
					"contactSummary":$("#edit-contactSummary").val(),
					"nextContactTime":$("#edit-nextContactTime").val(),
					"address":$("#edit-address").val(),

				},
				type:"post",
				dataType:"json",
				success:function (data) {
					if(data.success){
						pageList(1,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
						$("#editClueModal").modal("hide");

					}else {
						alert("更新失败！");
					}
				}

			});
		});

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
						url:"workbench/clue/deleteClue.do",
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
				};
			};

		});






	});

	function pageList(pageNum,pageSize){

		$.ajax({
			url:"workbench/clue/pageList.do",
			data:{
				"pageNum":pageNum,
				"pageSize":pageSize,
				"fullname":$("#hidden-fullname").val().trim(),
				"company":$("#hidden-company").val().trim(),
				"owner":$("#hidden-owner").val().trim(),
				"source":$("#hidden-source").val().trim(),
				"phone":$("#hidden-phone").val().trim(),
				"mphone":$("#hidden-mphone").val().trim(),
				"state":$("#hidden-state").val().trim()
			},
			type:"get",
			dataType:"json",
			success:function (data) {
				var html="";
				$.each(data.datalist,function (index,item) {
					html += '<tr>';
					html +=	'<td><input type="checkbox" name="xzBtn" value="'+item.id+'"/></td>';
					html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/clue/detail.do?id='+item.id+'\';">'+item.fullname+'</a></td>';
					html += '<td>'+item.company+'</td>';
					html += '<td>'+item.phone+'</td>';
					html += '<td>'+item.mphone+'</td>';
					html += '<td>'+item.source+'</td>';
					html += '<td>'+item.owner+'</td>';
					html += '<td>'+item.state+'</td>';
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
	<input type="hidden" id="hidden-fullname">
	<input type="hidden" id="hidden-company">
	<input type="hidden" id="hidden-owner">
	<input type="hidden" id="hidden-source">
	<input type="hidden" id="hidden-phone">
	<input type="hidden" id="hidden-mphone">
	<input type="hidden" id="hidden-state">
	<input type="hidden" id="hidden-clueId">


	<!-- 创建线索的模态窗口 -->
	<div class="modal fade" id="createClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">创建线索</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form" id="reset">
					
						<div class="form-group">
							<label for="create-clueOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-clueOwner">

								</select>
							</div>
							<label for="create-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-company">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-call" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-call">
								  <option></option>
									<c:forEach var="item" items="${applicationScope.appellation}">
										<option value="${item.value}">${item.text}</option>
									</c:forEach>
								</select>
							</div>
							<label for="create-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-surname">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-job">
							</div>
							<label for="create-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-email">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-phone">
							</div>
							<label for="create-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-website">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-mphone">
							</div>
							<label for="create-status" class="col-sm-2 control-label">线索状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-status">
									<option></option>
									<c:forEach items="${applicationScope.clueState}" var="item">
										<option value="${item.value}">${item.text}</option>
									</c:forEach>

								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-source" class="col-sm-2 control-label">线索来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-source">
									<option></option>
									<c:forEach var="item" items="${applicationScope.source}">
										<option value="${item.value}">${item.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						

						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">线索描述</label>
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
									<input type="text" class="form-control time" id="create-nextContactTime">
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>
						
						<div style="position: relative;top: 20px;">
							<div class="form-group">
                                <label for="create-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="create-address"></textarea>
                                </div>
							</div>
						</div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" id="closeModalBtn">关闭</button>
					<button type="button" class="btn btn-primary"id="saveBtn">保存</button>
				</div>
			</div>
		</div>
		</div>
	
	<!-- 修改线索的模态窗口 -->
	<div class="modal fade" id="editClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">修改线索</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="edit-clueOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-clueOwner">

								</select>
							</div>
							<label for="edit-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-company" value="动力节点">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-call" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-call">
								  <option></option>
									<c:forEach var="item" items="${applicationScope.appellation}">
										<option value="${item.value}">${item.text}</option>
									</c:forEach>
								</select>
							</div>
							<label for="edit-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-surname" value="李四">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-job" value="CTO">
							</div>
							<label for="edit-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-email" value="lisi@bjpowernode.com">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-phone" value="010-84846003">
							</div>
							<label for="edit-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-website" value="http://www.bjpowernode.com">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-mphone" value="12345678901">
							</div>
							<label for="edit-status" class="col-sm-2 control-label">线索状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-status">
								  <option></option>
									<c:forEach var="item" items="${applicationScope.clueState}">
										<option value="${item.value}">${item.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-source" class="col-sm-2 control-label">线索来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-source">
								  <option></option>
									<c:forEach var="item" items="${applicationScope.source}">
										<option value="${item.value}">${item.text}</option>
									</c:forEach>
								</select>
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
									<textarea class="form-control" rows="3" id="edit-contactSummary">这个线索即将被转换</textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control time" id="edit-nextContactTime" value="2017-05-01">
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
					<button type="button" id="updateBtn">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>线索列表</h3>
			</div>
		</div>
	</div>
	
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" id="select-name" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司</div>
				      <input class="form-control"id="select-company" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司座机</div>
				      <input class="form-control" id="select-phone" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">线索来源</div>
					  <select class="form-control" id="select-source">
					  	  <option></option>
					  	 	<c:forEach items="${applicationScope.source}" var="item">
								<option value="${item.value}">${item.text}</option>
							</c:forEach>
					  </select>
				    </div>
				  </div>
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="select-owner">
				    </div>
				  </div>
				  
				  
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">手机</div>
				      <input class="form-control" id="select-mphone" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">线索状态</div>
					  <select class="form-control"id="select-clueState">
					  	<option></option>
						  <c:forEach items="${applicationScope.clueState}" var="item">
							  <option value="${item.value}">${item.text}</option>
						  </c:forEach>
					  </select>
				    </div>
				  </div>

				  <button type="button" class="btn btn-default" id="selectBtn">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 40px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="createBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger"id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
				
			</div>
			<div style="position: relative;top: 50px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="qxBtn"/></td>
							<td>名称</td>
							<td>公司</td>
							<td>公司座机</td>
							<td>手机</td>
							<td>线索来源</td>
							<td>所有者</td>
							<td>线索状态</td>
						</tr>
					</thead>
					<tbody id="display">

					</tbody>
				</table>
			</div>
			
			<div style="height: 50px; position: relative;top: 60px;">
				<div id="activityPage"></div>
			</div>
			
		</div>
		
	</div>
</body>
</html>