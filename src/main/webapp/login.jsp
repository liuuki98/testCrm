<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>
<html>
<head>
	<base href="<%=basePath%>"/>
	<meta charset="UTF-8">
	<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
	<script type="text/javascript" src="jquery/jquery-3.6.0.min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	<%@taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>

	<script>
		$(function () {
			//login.jsp始终在顶层窗口显示
			if(window.top!=window){
				window.top.location=window.location;
			}

			$("#username").focus();
			$("#username").val("");

			$("#submit").click(function () {
				login();

			})

			$(window).keydown(function (event) {
				if(event.keyCode==13){
					login();
				}
			})

		})

		function login() {
			let username = $("#username").val().trim();
			let password = $("#password").val().trim();
			if(username=="" || password==""){
				$("#msg").html("请勿输入空格！");
				return false;
			}
			$.ajax({
				url:"settings/user/login.do",
				data:{
					"username":username,
					"password":password,
				},
				type :"post",
				dataType:"json",
				success:function (data) {
					if(data.success){
						$("#msg").html("ok");
						window.location.href="workbench/index.jsp";
					}else{
						$("#msg").html(data.msg);
					}


				}

			})

		}
	</script>

</head>
<body>
	<div style="position: absolute; top: 0px; left: 0px; width: 60%;">
		<img src="image/IMG_7114.JPG" style="width: 100%; height: 90%; position: relative; top: 50px;">
	</div>
	<div id="top" style="height: 50px; background-color: #3C3C3C; width: 100%;">
		<div style="position: absolute; top: 5px; left: 0px; font-size: 30px; font-weight: 400; color: white; font-family: 'times new roman'">CRM &nbsp;<span style="font-size: 12px;">&copy;2022&nbsp;liuuku</span></div>
	</div>
	
	<div style="position: absolute; top: 120px; right: 100px;width:450px;height:400px;border:1px solid #D5D5D5">
		<div style="position: absolute; top: 0px; right: 60px;">
			<div class="page-header">
				<h1>登录</h1>
			</div>
			<form  class="form-horizontal" role="form">
				<div class="form-group form-group-lg">
					<div style="width: 350px;">
						<input id="username" class="form-control" type="text" placeholder="用户名">
					</div>
					<div style="width: 350px; position: relative;top: 20px;">
						<input id="password" class="form-control" type="password" placeholder="密码">
					</div>
					<div class="checkbox"  style="position: relative;top: 30px; left: 10px;">
						
							<span id="msg" style="color: red"></span>
						
					</div>
					<button id="submit" type="button" class="btn btn-primary btn-lg btn-block"  style="width: 350px; position: relative;top: 45px;">登录</button>
				</div>
			</form>
		</div>
	</div>
</body>
</html>