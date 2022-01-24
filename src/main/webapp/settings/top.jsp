<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";

%>
<html>
<head>
    <base href="<%=basePath %>"/>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>


    <script>
        //页面加载完毕
        $(function(){

            //导航中所有文本颜色为黑色
            $(".liClass > a").css("color" , "black");

            //默认选中导航菜单中的第一个菜单项
            $(".liClass:first").addClass("active");

            //第一个菜单项的文字变成白色
            $(".liClass:first > a").css("color" , "white");

            //给所有的菜单项注册鼠标单击事件
            $(".liClass").click(function(){
                //移除所有菜单项的激活状态
                $(".liClass").removeClass("active");
                //导航中所有文本颜色为黑色
                $(".liClass > a").css("color" , "black");
                //当前项目被选中
                $(this).addClass("active");
                //当前项目颜色变成白色
                $(this).children("a").css("color","white");
            });

            //验证密码的格式是否符合要求
            var reg = /^[0-9a-zA-Z]{6,15}$/;
            $("#createPasswordBtn").click(function () {
                $("#editPwdModal").modal("show");
            });
            $("#oldPwd").blur(function () {

                var oldPwd=$("#oldPwd").val().trim();
                if(!reg.test(oldPwd)){

                    $("#msg").html("密码为6-15位的数字或字母，请检查输入！");
                }else {
                    $("#msg").html("");
                }
            });
            $("#newPwd").blur(function () {
                var newPwd=$("#newPwd").val().trim();
                if(!reg.test(newPwd)){

                    $("#msg").html("密码为6-15位的数字或字母，请检查输入！");
                }else {
                    $("#msg").html("");
                }
            });
            $("#confirmPwd").keyup(function () {
                if($("#confirmPwd").val()!=$("#newPwd").val()){
                    $("#confirmPwd").css("color","red");
                }else {
                    $("#confirmPwd").css("color","green");
                }
            });
            //更新密码错做
            $("#updatePasswordBtn").click(function () {
                $.ajax({
                    url:"settings/user/updatePwd.do",
                    data:{
                        "currentPwd":$("#oldPwd").val().trim(),
                        "newPwd":$("#newPwd").val().trim(),
                    },
                    type:"post",
                    dataType:"json",
                    success:function (data) {
                        if(data.success){

                            window.location.href="login.jsp";
                        }else {
                            $("#msg").html("原密码错误！");
                        }
                    }
                })
            });
            //安全退出登录
            $("#exitBtn").click(function () {
                $("#exitModal").modal("show");
            });
            $("#confirmExitBtn").click(function () {





                window.location.href="settings/user/exit.do";
            });

            $("#backBtn").click(function () {
                window.location.href="workbench/index.jsp";
            })


        });

    </script>

</head>
<body>
<!-- 我的资料 -->
<div class="modal fade" id="myInformation" role="dialog">
    <div class="modal-dialog" role="document" style="width: 30%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">我的资料</h4>
            </div>
            <div class="modal-body">
                <div style="position: relative; left: 40px;">
                    姓名：<b>${user.name}</b><br><br>
                    登录帐号：<b>${user.loginAct}</b><br><br>
                    组织机构：<b>${user.deptno}-市场部</b><br><br>
                    邮箱：<b>${user.email}</b><br><br>
                    失效时间：<b>${user.expireTime}</b><br><br>
                    允许访问IP：<b>${user.allowIps}</b>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
            </div>
        </div>
    </div>
</div>

<!-- 修改密码的模态窗口 -->
<div class="modal fade" id="editPwdModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 70%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">修改密码</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form">
                    <div class="form-group">
                        <label for="oldPwd" class="col-sm-2 control-label">原密码</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="password" class="form-control" id="oldPwd" style="width: 200%;">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="newPwd" class="col-sm-2 control-label">新密码</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="password" class="form-control" id="newPwd" style="width: 200%;">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="confirmPwd" class="col-sm-2 control-label">确认密码</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="password" class="form-control" id="confirmPwd" style="width: 200%;">
                        </div>

                    </div>
                    <div class="form-group">
                        <label for="confirmPwd" class="col-sm-2 control-label"></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <span id="msg" style="color: red"></span>
                        </div>

                    </div>

                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                <button type="button" class="btn btn-primary" id="updatePasswordBtn">更新</button>
            </div>
        </div>
    </div>
</div>

<!-- 退出系统的模态窗口 -->
<div class="modal fade" id="exitModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 30%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">离开</h4>
            </div>
            <div class="modal-body">
                <p>您确定要退出系统吗？</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                <button type="button" class="btn btn-primary" id="confirmExitBtn">确定</button>
            </div>
        </div>
    </div>
</div>

<!-- 顶部 -->
<div id="top" style="height: 50px; background-color: #3C3C3C; width: 100%;">
    <div id="backBtn" style="position: absolute; top: 5px; left: 0px; font-size: 30px; font-weight: 400; color: white; font-family: 'times new roman'">CRM &nbsp;<span style="font-size: 12px;">&copy;2022&nbsp;liuuki</span></div>
    <div style="position: absolute; top: 15px; right: 15px;">
        <ul>
            <li class="dropdown user-dropdown">
                <a href="javascript:void(0)" style="text-decoration: none; color: white;" class="dropdown-toggle" data-toggle="dropdown">
                    <span class="glyphicon glyphicon-user"></span> ${sessionScope.user.name} <span class="caret"></span>
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                </a>
                <ul class="dropdown-menu">
                    <li><a href="settings/index.jsp"><span class="glyphicon glyphicon-wrench"></span> 系统设置</a></li>
                    <li><a href="javascript:void(0)" data-toggle="modal" data-target="#myInformation"><span class="glyphicon glyphicon-file"></span> 我的资料</a></li>
                    <li><a href="javascript:void(0)" id="createPasswordBtn"><span class="glyphicon glyphicon-edit"></span> 修改密码</a></li>
                    <li><a href="javascript:void(0);" id="exitBtn"><span class="glyphicon glyphicon-off"></span> 退出</a></li>
                </ul>
            </li>
        </ul>
    </div>
</div>

</body>
</html>