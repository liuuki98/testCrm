
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


	<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

<script type="text/javascript">


	var cancelAndSaveBtnDefault = true;
	
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
			pickerPosition: "bottom-left"
		});

		//默认情况下取消和保存按钮是隐藏的

		$("#remark").focus(function(){
			if(cancelAndSaveBtnDefault){
				//设置remarkDiv的高度为130px
				$("#remarkDiv").css("height","130px");
				//显示
				$("#cancelAndSaveBtn").show("2000");
				cancelAndSaveBtnDefault = false;
			}
		});
		
		$("#cancelBtn").click(function(){
			//显示
			$("#cancelAndSaveBtn").hide();
			//设置remarkDiv的高度为130px
			$("#remarkDiv").css("height","90px");
			cancelAndSaveBtnDefault = true;
		});
		
		$(".remarkDiv").mouseover(function(){
			$(this).children("div").children("div").show();
		});
		
		$(".remarkDiv").mouseout(function(){
			$(this).children("div").children("div").hide();
		});
		
		$(".myHref").mouseover(function(){
			$(this).children("span").css("color","red");
		});
		
		$(".myHref").mouseout(function(){
			$(this).children("span").css("color","#E6E6E6");
		});

		//初始化备注页面
		initRemarkList();
		$("#remarkBody1").on("mouseover",".remarkDiv",function(){
			$(this).children("div").children("div").show();
		});
		$("#remarkBody1").on("mouseout",".remarkDiv",function(){
			$(this).children("div").children("div").hide();
		});


		//
		$("#editBtn").click(function () {

			$.ajax({
				url:"workbench/activity/getUserList.do",

				type:"get",
				dataType:"json",
				success:function (data) {
					$("#edit-marketActivityOwner").html("");
					$.each(data,function (index,item) {
						$("#edit-marketActivityOwner").append("<option value='"+item.id+"'>"+item.name+"</option>");

					});
					//初始化窗口内容
					$("#edit-marketActivityOwner").val("${sessionScope.user.id}");

					$("#edit-marketActivityName").val("${activity.name}");
					$("#edit-startTime").val("${activity.startDate}");
					$("#edit-endTime").val("${activity.endDate}");
					$("#edit-cost").val("${activity.cost}");
					$("#edit-describe").val("${activity.description}");

					$("#editActivityModal").modal("show");
					$("#closeEditAcModal").click(function () {
						$("#editActivityModal").modal("hide");
					})

				}
			});
		});

		//保存对activity市场活动的修改,并刷新页面内容与修改内容一致性。
		$("#saveAcBtn").click(function () {
			$.ajax({
				url:"workbench/activity/saveEditActivity.do",
				data:{
					"id":"${activity.id}",
					"name":$("#edit-marketActivityName").val().trim(),
					"startDate":$("#edit-startTime").val().trim(),
					"endDate":$("#edit-endTime").val().trim(),
					"cost":$("#edit-cost").val().trim(),
					"description":$("#edit-describe").val().trim(),
					"owner":$("#edit-marketActivityOwner").val().trim(),
				},
				type:"post",
				dataType:"json",
				success:function (data) {
					if(data.success){

						$("#editActivityModal").modal("hide");
						window.location.href='workbench/activity/detail.do?id='+"${activity.id}";


					}else{
						alert("修改失败！")
					}
				}
			})
		});

		//关闭备注按钮
		$("#closeRemarkModol").click(function () {
			$("#editRemarkModal").modal("hide");
		})

		//更新备注
		$("#updateRemarkBtn").click(function () {

			$.ajax({
				url:"workbench/activity/saveRemark.do",
				data:{
					"id":$("#hideId").val(),
					"noteContent":$("#noteContent").val(),
				},
				type:"post",
				dataType:"json",
				success:function(data){
					if(data.success){
						$("#editRemarkModal").modal("hide");
						initRemarkList();
					}else {
						alert("更新失败！")
					}

				}
			})

		});
		//添加备注
		$("#saveRemark").click(function () {
			var content = $("#remark").val().trim();

			$.ajax({
				url:"workbench/activity/addRemark.do",
				data:{
					"content":content,
					"id":"${activity.id}"

				},
				type:"post",
				dataType:"json",
				success:function(data){
					if(data.success){
						initRemarkList();
					}else {
						alert("添加失败!")
					}
				}

			})
		});

		//删除按钮
		$("#deleteAcBtn").click(function () {

			if(confirm("确认删除该市场活动吗？")){
				$.ajax({
					url:"workbench/activity/deleteSActivity.do",
					data:{
						"id":"${activity.id}",
					},
					type:"post",
					dataType:"json",
					success:function (data) {
						if(data.success){
							window.location.href='workbench/activity/index.jsp';
						}else {
							alert("删除失败");
						}
					}
				})
			}

		});





	});
	function initRemarkList() {
		var id="${activity.id}";


		$.ajax({
			url:"workbench/activity/getRemarkList.do",
			data:{
				"id":id,
			},
			type:"get",
			dataType:"json",
			success:function (data) {
				var html="";
				$.each(data,function (index,item) {
					html+='<div class="remarkDiv" id="'+item.id+'" style="height: 60px;">';
					html+='<img title="zhangsan" src="/image/user-thumbnail.png" style="width: 30px; height:30px;"> ';
					html+='<div style="position: relative; top: -40px; left: 40px;" >';
					html+='<h5>'+item.noteContent+'</h5>';
					html+='<font color="gray">市场活动</font> <font color="gray">-</font> <b>${activity.name}</b> <small style="color: gray;"> '+(item.editFlag==0?item.createTime:item.editTime)+'由'+(item.editFlag==0?item.createBy:item.editBy)+'</small>';
					html+='<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
					html+='<a class="myHref" href="javascript:void(0);"><span onclick="editRemark(\''+item.id+'\')" class="glyphicon glyphicon-edit" id="editRemarkBtn" style="font-size: 20px; color:red;"></span></a>';
					html+='&nbsp;&nbsp;&nbsp;&nbsp;';
					html+='<a class="myHref" href="javascript:void(0);"><span onclick="deletRemark(\''+item.id+'\')" class="glyphicon glyphicon-remove" id="deleteRemarkBtn" style="font-size: 20px; color:red;"></span></a>';
					html+='</div>';
					html+='</div>';
					html+='</div>';
				})
				$("#remarkBody").html(html);

			}
		})
	};

	//删除函数操作
	function deletRemark(id) {
		if(confirm("确认删除该备注吗？")){
			$.ajax({
				url:"workbench/activity/deleteRemarkById.do",
				data:{
					"id":id,
				},
				type:"post",
				dataType:"json",
				success:function (data) {
					if(data.success){
						initRemarkList();
					}else{
						alert("删除失败！")
					}
				}
			})
		}

	}
	//修改备注信息函数
	function editRemark(id) {
		$("#hideId").val(id);
		$.ajax({
			url:"workbench/activity/getRemarkNoteContent.do",
			data:{
				"id":id,
			},
			type:"get",
			dataType:"json",
			success:function (data) {

					$("#noteContent").html(data.noteContent);
					$("#editRemarkModal").modal("show");
			}
		})
	}

	
</script>

</head>
<body>
	<!-- 隐藏域，存储一些数据 -->
	<input style="display: none" id="hideId">
	
	<!-- 修改市场活动备注的模态窗口 -->
	<div class="modal fade" id="editRemarkModal" role="dialog">
		<%-- 备注的id --%>
		<input type="hidden" id="remarkId">
        <div class="modal-dialog" role="document" style="width: 40%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">修改备注</h4>
                </div>

                <div class="modal-body">
                    <form class="form-horizontal" role="form">
                        <div class="form-group">
                            <label for="edit-describe" class="col-sm-2 control-label">内容</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="noteContent"></textarea>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal" id="closeRemarkModol">关闭</button>
                    <button type="button" class="btn btn-primary" id="updateRemarkBtn">更新</button>
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
                    <h4 class="modal-title" id="myModalLabels">修改市场活动</h4>
                </div>
                <div class="modal-body">

                    <form class="form-horizontal" role="form">

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
                                <textarea class="form-control" rows="3" id="edit-describe">市场活动Marketing，是指品牌主办或参与的展览会议与公关市场活动，包括自行主办的各类研讨会、客户交流会、演示会、新产品发布会、体验会、答谢会、年会和出席参加并布展或演讲的展览会、研讨会、行业交流会、颁奖典礼等</textarea>
                            </div>
                        </div>

                    </form>

                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" id="closeEditAcModal">关闭</button>
                    <button type="button" class="btn btn-primary" id="saveAcBtn">更新</button>
                </div>
            </div>
        </div>
    </div>

	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- 大标题 -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3>市场活动-${activity.name} <small>${activity.startDate} ~ ${activity.endDate}</small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 250px;  top: -72px; left: 700px;">
			<button type="button" class="btn btn-default" id="editBtn"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
			<button type="button" class="btn btn-danger " id="deleteAcBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
	</div>
	
	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${activity.owner}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${activity.name}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>

		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">开始日期</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${activity.startDate}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">结束日期</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${activity.endDate}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">成本</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${activity.cost}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${activity.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${activity.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${activity.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${activity.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${activity.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
	</div>
	
	<!-- 备注 -->
	<div id="remarkBody1" style="position: relative; top: 30px; left: 40px;">
		<div class="page-header">
			<h4>备注</h4>
		</div>

		<div id="remarkBody">



		</div>
		


		
		<div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
			<form role="form" style="position: relative;top: 10px; left: 10px;">
				<textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
				<p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
					<button id="cancelBtn" type="button" class="btn btn-default" id="cancleBtn">取消</button>
					<button type="button" class="btn btn-primary" id="saveRemark">保存</button>
				</p>
			</form>
		</div>
	</div>
	<div style="height: 200px;"></div>
</body>
</html>