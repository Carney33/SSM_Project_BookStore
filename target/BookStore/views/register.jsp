<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>用户注册页</title>
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
    <h3>用户注册</h3>
    <div class=" input-group input-group-md">
              <span class="input-group-addon help-block" id="sizing-addon1">用户名&nbsp;&nbsp;<i
                      class="glyphicon glyphicon-user"></i></span>
        <input name="name" id="login_username" type="text" class="form-control"/>
    </div>
    <span class="help-block" id="temp"></span>
    <div class="input-group input-group-md">
      <span class="input-group-addon help-block" id="sizing-addon2">密码&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i
              class="glyphicon glyphicon-lock"></i></span>
        <input type="password" id="login_password" name="password" class="form-control"/>
    </div>
    <span class="help-block" id="info_pass"></span>
    <div class="input-group input-group-md">
        <span class="input-group-addon help-block" id="sizing-addon3">验证码&nbsp;&nbsp;<i
                class="glyphicon glyphicon-ok"></i></span>
        <input type="text" id="verifyCode" name="verifyCode" class="form-control"/>
    </div>
    <span class="help-block" id="img_code"></span>
    <img src="${APP_PATH}/checkCode" alt="" width="100" height="32" class="passcode help-block"
         style="height:43px;cursor:pointer;" id="img">
    <br/>
    <button type="button" id="customer_register" class="btn btn-success btn-block">注册</button>
    <a class="btn btn-sm btn-white btn-block" style="text-align: right;" th:href="@{register}" href="/index.jsp"><h6>
        返回用户登录页</h6></a>
</form>

<script type="text/javascript">

    // 校验信息
    function show_validate_msg(ele, status, msg) {
        // 清除当前元素的校验状态
        $(ele).parent().removeClass("has-success has-error");
        $("#temp").removeClass("has-success has-error");
        $("#temp").text("");

        if ("success" == status) {
            $(ele).parent().addClass("has-success");
            $("#temp").addClass("has-succss");
            $("#temp").text(msg);
        } else if ("error" == status) {
            $(ele).parent().addClass("has-error");
            $("#temp").addClass("has-error");
            $("#temp").text(msg);
        }
    }

    // ajax用户名
    $("#login_username").change(function () {
        $.ajax({
            url: "${APP_PATH}/checkCustomer",
            data: "name=" + $("#login_username").val(),
            type: "POST",
            success: function (result) {
                if (result.code == 100) {
                    show_validate_msg("#login_username", "success", "用户名可用");
                    $("#customer_register").attr("ajax_va", "success");
                } else if (result.code == 200) {
                    if (validate_add_form()) {
                        show_validate_msg("#login_username", "error", "用户名不可用");
                    } else {
                        show_validate_msg("#login_username", "error", "用户名必须是2-5位中文或者3-6位英文和数字的组合");
                    }
                    $("#customer_register").attr("ajax_va", "error");
                }
            }
        });
    });

    // ajax密码
    $("#login_password").change(function () {
        var pass = $("#login_password").val();
        if (pass == "" | pass == null) {
            $("#login_password").parent().removeClass("has-error has-success");
            $("#login_password").parent().addClass("has-error");
            $("#info_pass").text("");
            $("#info_pass").text("密码不能为空!");
        } else {
            $("#login_password").parent().removeClass("has-error has-success");
            $("#login_password").parent().addClass("has-success");
            $("#info_pass").text("");
        }


    });

    // ajax验证码
    $("#verifyCode").change(function () {
        // 校验验证码
        $.ajax({
            url: "${APP_PATH}/thiscode",
            type: "POST",
            data: "thiscode=" + $("#verifyCode").val(),
            success: function (result) {
                if (result.code == 100) {
                    $("#verifyCode").parent().removeClass("has-success has-error");
                    $("#verifyCode").parent().addClass("has-success");
                    $("#img_code").text("");
                    $("#customer_register").attr("ajax_code", "success");
                } else if (result.code == 200) {
                    $("#verifzyCode").parent().removeClass("has-success has-error");
                    $("#verifyCode").parent().addClass("has-error");
                    $("#img_code").text("");
                    $("#img_code").text("请输正确的验证码！");
                    $("#customer_register").attr("ajax_code", "error");
                }
            }
        });
    });

    function validate_add_form() {
        // 校验用户名
        var name = $("#login_username").val();
        var regName = /(^[a-zA-Z0-9_-]{3,6}$)|(^[\u2E80-\u9FFF]{2,5})/;
        if (!regName.test(name)) {
            return false;
        } else {
            return true;
        }
    }

    $("#customer_register").click(function () {

        if ($("#login_username").val() == "" || $("#login_password").val() == "") {
            return false;
        }

        if ($(this).attr("ajax_va") == "error") {
            return false;
        }

        if ($(this).attr("ajax_code") == "error") {
            return false;
        }
        $.ajax({
            url: "${APP_PATH}/saveCustomer",
            type: "POST",
            data: {name: $("#login_username").val(), password: $("#login_password").val()},
            success: function (result) {
                window.location.href = "${APP_PATH}/index.jsp";
                <%--document.cookie = $("#login_username").val();--%>
                <%--$.ajax({--%>
                    <%--url: "${APP_PATH}/customer",--%>
                    <%--type: "POST",--%>
                    <%--data: {name: $("#login_username").val(), password: $("#login_password").val()},--%>
                    <%--success: function (result) {--%>
                        <%--window.location.href = "${APP_PATH}/views/show.jsp";--%>
                    <%--}--%>
                <%--});--%>
            }
        });
        alert("注册成功！");
    });
</script>
</body>