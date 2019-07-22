<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>用户登陆页</title>
    <%
        pageContext.setAttribute("APP_PATH", request.getContextPath());
    %>
    <script type="text/javascript"
            src="static/jquery-3.2.1.min.js"></script>

    <script type="text/javascript"
            src="static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
    <link href="static/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
</head>

<body>
<form id="form1" class="well"
      style="width: 30em; margin: auto; margin-top: 150px;">
    <h3>用户登录&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <button type="button" id="admin_btn" class="btn btn-success" onclick="window.location='/views/admin_index.jsp'">
            管理员登录
        </button>
    </h3>
    <div class=" input-group input-group-md">
              <span class="input-group-addon" id="sizing-addon1"><i
                      class="glyphicon glyphicon-user"></i></span>
        <input name="name" id="login_username" type="text" class="form-control"/>
    </div>
    <br/>
    <div class="input-group input-group-md">
              <span class="input-group-addon" id="sizing-addon2"><i
                      class="glyphicon glyphicon-lock"></i></span>
        <input type="password" id="password" name="password" class="form-control"/>
    </div>
    <br/>
    <br/>
    <button type="button" id="bn" class="btn btn-success btn-block">登录</button>

    <a class="btn btn-sm btn-white btn-block" style="text-align: right;" th:href="@{register}"
       href="views/register.jsp"><h6>
        还没有账户？前往注册</h6></a>
</form>
</body>

<script type="text/javascript">
    // 用户登录
    $("#bn").click(function () {
        document.cookie = $("#login_username").val();
        $.ajax({
            url: "${APP_PATH}/customer",
            type: "POST",
            data: {name: $("#login_username").val(), password: $("#password").val()},
            success: function (result) {
                if (result.code == 100) {
                    window.location.href = "${APP_PATH}/views/show.jsp";
                }
                else {
                    alert("用户名或密码错误");
                }
            }
        });
    });
</script>
</html>