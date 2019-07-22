<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>管理员登陆页</title>
    <%
        pageContext.setAttribute("APP_PATH", request.getContextPath());
    %>
    <script type="text/javascript"
            src="${APP_PATH}/static/jquery-3.2.1.min.js"></script>

    <script type="text/javascript"
            src="${APP_PATH}/static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
    <link href="${APP_PATH}/static/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
</head>

<body>
<form id="form1" class="well"
      style="width: 30em; margin: auto; margin-top: 150px;">
    <h3>管理员登录&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    </h3>
    <div class=" input-group input-group-md">
              <span class="input-group-addon" id="sizing-addon1"><i
                      class="glyphicon glyphicon-user"></i></span>
        <input name="a_name" id="admin_login_username" type="text" class="form-control"/>

    </div>
    <br/>
    <div class="input-group input-group-md">
              <span class="input-group-addon" id="sizing-addon2"><i
                      class="glyphicon glyphicon-lock"></i></span>
        <input type="password" id="admin_login_password" name="a_password" class="form-control"/>
    </div>
    <br/>
    <button type="button" id="bn" class="btn btn-success btn-block">登录</button>
    <a class="btn btn-sm btn-white btn-block" style="text-align: right;" th:href="@{register}" href="/index.jsp"><h6>
        返回用户登录页</h6></a>
</form>

<script type="text/javascript">
    // admin登录
    $("#bn").click(function () {
        $.ajax({
            url: "${APP_PATH}/admin",
            type: "POST",
            data: {a_name: $("#admin_login_username").val(), a_password: $("#admin_login_password").val()},
            success: function (result) {
                if (result.code == 100) {
                    window.location.href = "${APP_PATH}/views/admin_show.jsp";
            }
                else {
                    alert("用户名或密码错误");
                }
            }
        });
    });
</script>
</body>