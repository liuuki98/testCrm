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
	<link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">

	<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	<script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
	<script type="text/javascript" src="jquery/bs_pagination/en.js"></script>

	<script>
		$(function () {
			pageList(1,2);
		});

		function pageList(pageNum,pageSize){

			$.ajax({
				url:"settings/qx/getUserPages.do",
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
						html += '<td>'+item.loginAct+'</td>';
						html += '<td>'+item.name+'</td>';
						html += '<td>'+item.deptNo+'</td>';
						html += '<td>'+item.email+'</td>';
						html += '<td>'+item.expireTime+'</td>';
						html += '<td>'+item.allowIps+'</td>';
						html += '<td>'+item.lockState+'</td>';
						html += '<td>'+item.createBy+'</td>';
						html += '<td>'+item.createTime+'</td>';
						html += '<td>'+item.editBy+'</td>';
						html += '<td>'+item.editTime+'</td>';
						html += '</tr>';

					});

					var totalPages=data.pagesTotal%pageSize==0?data.pagesTotal/pageSize:parseInt(data.pagesTotal/pageSize)+1;
					$("#display").html(html);
					//????????????
					$("#pageList").bs_pagination({
						currentPage: pageNum, // ??????
						rowsPerPage: pageSize, // ???????????????????????????
						maxRowsPerPage: 10, // ?????????????????????????????????
						totalPages: totalPages, // ?????????
						totalRows: data.pagesTotal, // ???????????????

						visiblePageLinks: 3, // ??????????????????

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

	<!-- ??????????????????????????? -->
	<div class="modal fade" id="createUserModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">??</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">????????????</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="create-loginActNo" class="col-sm-2 control-label">????????????<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-loginActNo">
							</div>
							<label for="create-username" class="col-sm-2 control-label">????????????</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-username">
							</div>
						</div>
						<div class="form-group">
							<label for="create-loginPwd" class="col-sm-2 control-label">????????????<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="password" class="form-control" id="create-loginPwd">
							</div>
							<label for="create-confirmPwd" class="col-sm-2 control-label">????????????<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="password" class="form-control" id="create-confirmPwd">
							</div>
						</div>
						<div class="form-group">
							<label for="create-email" class="col-sm-2 control-label">??????</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-email">
							</div>
							<label for="create-expireTime" class="col-sm-2 control-label">????????????</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-expireTime">
							</div>
						</div>
						<div class="form-group">
							<label for="create-lockStatus" class="col-sm-2 control-label">????????????</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-lockStatus">
								  <option></option>
								  <option>??????</option>
								  <option>??????</option>
								</select>
							</div>
							<label for="create-org" class="col-sm-2 control-label">??????<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <select class="form-control" id="create-dept">
                                    <option></option>
                                    <option>?????????</option>
                                    <option>?????????</option>
                                </select>
                            </div>
						</div>
						<div class="form-group">
							<label for="create-allowIps" class="col-sm-2 control-label">???????????????IP</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-allowIps" style="width: 280%" placeholder="?????????????????????">
							</div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">??????</button>
					<button type="button" class="btn btn-primary" data-dismiss="modal">??????</button>
				</div>
			</div>
		</div>
	</div>
	
	
	<div>
		<div style="position: relative; left: 30px; top: -10px;">
			<div class="page-header">
				<h3>????????????</h3>
			</div>
		</div>
	</div>
	
	<div class="btn-toolbar" role="toolbar" style="position: relative; height: 80px; left: 30px; top: -10px;">
		<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
		  
		  <div class="form-group">
		    <div class="input-group">
		      <div class="input-group-addon">????????????</div>
		      <input class="form-control" type="text">
		    </div>
		  </div>
		  &nbsp;&nbsp;&nbsp;&nbsp;
		  <div class="form-group">
		    <div class="input-group">
		      <div class="input-group-addon">????????????</div>
		      <input class="form-control" type="text">
		    </div>
		  </div>
		  &nbsp;&nbsp;&nbsp;&nbsp;
		  <div class="form-group">
		    <div class="input-group">
		      <div class="input-group-addon">????????????</div>
			  <select class="form-control">
			  	  <option></option>
			      <option>??????</option>
				  <option>??????</option>
			  </select>
		    </div>
		  </div>
		  <br><br>
		  
		  <div class="form-group">
		    <div class="input-group">
		      <div class="input-group-addon">????????????</div>
			  <input class="form-control" type="text" id="startTime" />
		    </div>
		  </div>
		  
		  ~
		  
		  <div class="form-group">
		    <div class="input-group">
			  <input class="form-control" type="text" id="endTime" />
		    </div>
		  </div>
		  
		  <button type="submit" class="btn btn-default">??????</button>
		  
		</form>
	</div>
	
	
	<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;left: 30px; width: 110%; top: 20px;">
		<div class="btn-group" style="position: relative; top: 18%;">
		  <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#createUserModal"><span class="glyphicon glyphicon-plus"></span> ??????</button>
		  <button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> ??????</button>
		</div>
		
	</div>
	
	<div style="position: relative; left: 30px; top: 40px; width: 110%">
		<table class="table table-hover">
			<thead>
				<tr style="color: #B3B3B3;">
					<td><input type="checkbox" id="qxBtn"/></td>
					<td>??????</td>
					<td>????????????</td>
					<td>????????????</td>
					<td>????????????</td>
					<td>??????</td>
					<td>????????????</td>
					<td>????????????IP</td>
					<td>????????????</td>
					<td>?????????</td>
					<td>????????????</td>
					<td>?????????</td>
					<td>????????????</td>
				</tr>
			</thead>
			<tbody id="display">
				<tr class="active">
					<td><input type="checkbox" /></td>
					<td>1</td>
					<td><a  href="detail.jsp">zhangsan</a></td>
					<td>??????</td>
					<td>?????????</td>
					<td>zhangsan@bjpowernode.com</td>
					<td>2017-02-14 10:10:10</td>
					<td>127.0.0.1,192.168.100.2</td>
					<td>??????</td>
					<td>admin</td>
					<td>2017-02-10 10:10:10</td>
					<td>admin</td>
					<td>2017-02-10 20:10:10</td>
				</tr>
				<tr>
					<td><input type="checkbox" /></td>
					<td>2</td>
					<td><a  href="detail.jsp">lisi</a></td>
					<td>??????</td>
					<td>?????????</td>
					<td>lisi@bjpowernode.com</td>
					<td>2017-02-14 10:10:10</td>
					<td>127.0.0.1,192.168.100.2</td>
					<td>??????</td>
					<td>admin</td>
					<td>2017-02-10 10:10:10</td>
					<td>admin</td>
					<td>2017-02-10 20:10:10</td>
				</tr>
			</tbody>
		</table>
	</div>
	
	<div style="height: 50px; position: relative;top: 30px; left: 30px;">
		<div id="pageList"></div>
	</div>
			
</body>
</html>