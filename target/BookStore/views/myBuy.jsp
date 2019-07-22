<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>主界面</title>
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

<div class="container">
    <!-- 显示标题行 -->
    <div class="row">
        <div class="col-md-12">
            <h1>我购买的</h1>
            <div class="col-md-4 col-md-offset-8" id="cus_info">

            </div>
        </div>
    </div>
    <!-- 表格 -->
    <div class="row">
        <div class="col-md-12">
            <table class="table table-hover" id="own_tables">
                <thead>
                <tr>
                    <th>#</th>
                    <th>BookName</th>
                    <th>Price</th>
                    <th>订单完成时间</th>
                </tr>
                </thead>
                <tbody>

                </tbody>
            </table>
        </div>
    </div>
    <!-- 分页信息 -->
    <div class="row">
        <div class="col-md-6" id="page_info_area">

        </div>
        <div class="col-md-6" id="page_nav_area">

        </div>
    </div>
</div>
</body>

<script type="text/javascript">


    // 页面加载就显示第一页
    $(function () {
        $.ajax({
            url: "${APP_PATH}/own",
            data: "ownName=" + document.cookie,
            type: "POST",
            success: function (result) {
                // 显示名字、登出和返回主页
                build_information(result);
                // 显示表格
                build_own_table(result);
            }
        });
    });

    // 显示名字、登出和返回主页
    function build_information(result) {
        $("#cus_info").empty();
        $("#cus_info").append("&nbsp;&nbsp;&nbsp欢迎您&nbsp;&nbsp;&nbsp").append("<u>" + document.cookie + "</u>")
            .append("&nbsp;&nbsp;&nbsp;<button type=\"button\" id=\"return_index\" class=\"btn btn-warning\">返回主页</button>")
            .append("&nbsp;&nbsp;&nbsp;<button type=\"button\" id=\"admin_btn\" class=\"btn btn-success\" onclick=\"window.location='/index.jsp'\">登出</button>");
        $("#cus_info").append("<br/>");
    }

    // 显示表格
    function build_own_table(result) {
        $("#own_tables tbody").empty();

        var owns = result.extend.orders;
        $.each(owns, function (index, item) {
            var ownIdTd = $("<td></td>").append(index + 1);
            var bookNameTd = $("<td></td>").append(item.bookName);
            var priceTd = $("<td></td>").append(item.bookPrice);
            var createTimeTd = $("<td></td>").append(item.createTime);
            $("<tr></tr>")
                .append(ownIdTd)
                .append(bookNameTd)
                .append(priceTd)
                .append(createTimeTd)
                .appendTo("#own_tables tbody");
        });
    }

    $(document).on("click", "#return_index", function () {
        window.location="/views/show.jsp";
    });
</script>

</html>
