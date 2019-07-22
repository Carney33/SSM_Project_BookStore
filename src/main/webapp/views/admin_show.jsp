<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>管理员主界面</title>
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
<!--修改模态框-->
<div class="modal fade" id="bookUpdateModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title">修改</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal">
                    <div class="form-group">
                        <label class="col-sm-2 control-label">bookName</label>
                        <div class="col-sm-10">
                            <p class="form-control-static" id="bookName_update_static"></p>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="col-sm-2 control-label">Detail</label>
                        <div class="col-sm-10">
                            <input type="text" name="detail" class="form-control" id="detail_update_input">
                            <span class="help-block"></span>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="col-sm-2 control-label">Price</label>
                        <div class="col-sm-10">
                            <input type="text" name="price" class="form-control" id="price_update_input">
                            <span class="help-block"></span>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="book_update_btn">更新</button>
            </div>
        </div>
    </div>
</div>

<div class="container">
    <!-- 显示标题行 -->
    <div class="row">
        <div class="col-md-12">
            <h1>主界面</h1>
            <div class="col-md-4 col-md-offset-8">
                欢迎您 管理员
                <button type="button" id="admin_btn" class="btn btn-success" onclick="window.location='/index.jsp'">登出</button>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-md-4 col-md-offset-8">
            <button class="btn btn-danger" id="book_delete_all_btn">批量删除</button>
        </div>
    </div>

    <!-- 表格 -->
    <div class="row">
        <div class="col-md-12">
            <table class="table table-hover" id="books_tables">
                <thead>
                <tr>
                    <th>
                        <input type="checkbox" id="check_all"/>
                    </th>
                    <th>#</th>
                    <th>BookName</th>
                    <th>Detail</th>
                    <th>Price</th>
                    <th>操作</th>
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

<script type="text/javascript">

    // 总记录数和当前页
    var totalRecord, curretPage;
    $(function () {
        to_page(1);
    });

    function to_page(pn) {
        $.ajax({
            url: "${APP_PATH}/books",
            data: "pn=" + pn,
            type: "GET",
            success: function (result) {
                build_books_table(result);
                build_page_info(result);
                build_page_nav(result);
            }
        });
    }

    function build_books_table(result) {
        $("#books_tables tbody").empty();

        var books = result.extend.pageInfo.list;
        $.each(books, function (index, item) {
            var checkBoxTd = $("<td><input type='checkbox' class='check_item'/></td>");
            var bookIdTd = $("<td></td>").append(item.bookId);
            var bookNameTd = $("<td></td>").append(item.bookName);
            var detailTd = $("<td></td>").append(item.detail);
            var priceTd = $("<td></td>").append(item.price);
            var editBtn = $("<button></button>").addClass("btn btn-primary btn-sm edit_btn")
                .append("编辑");
            editBtn.attr("edit_id", item.bookId);
            var delBtn = $("<button></button>").addClass("btn btn-danger btn-sm del_btn")
                .append("删除");
            delBtn.attr("del_id", item.bookId);
            $("<tr></tr>")
                .append(checkBoxTd)
                .append(bookIdTd)
                .append(bookNameTd)
                .append(detailTd)
                .append(priceTd)
                .append(editBtn)
                .append(delBtn)
                .appendTo("#books_tables tbody");
        });
    }

    // 解析显示分页信息
    function build_page_info(result) {
        // 清空
        $("#page_info_area").empty();

        // 分页文字信息
        var page1 = $("<mark></mark>").append(result.extend.pageInfo.pageNum);
        var page2 = $("<mark></mark>").append(result.extend.pageInfo.pages);
        var page3 = $("<mark></mark>").append(result.extend.pageInfo.total);
        $("#page_info_area")
            .append("当前").append(page1).append("页，共")
            .append(page2).append("页，共")
            .append(page3).append("条记录");

        // 全局变量totalRecord、curretPage方便后面使用
        totalRecord = result.extend.pageInfo.total;
        curretPage = result.extend.pageInfo.pageNum;
    }

    // 解析显示分页条
    function build_page_nav(result) {
        // 清空
        $("#page_nav_area").empty();

        // 新建<ul>标签并向里面添加样式
        var ul = $("<ul></ul>").addClass("pagination");

        var firstPageLi = $("<li></li>").append($("<a></a>").append("首页").attr("href", "#"));
        var prePageLi = $("<li></li>").append($("<a></a>").append("&laquo;"));
        if (result.extend.pageInfo.hasPreviousPage == false) {
            firstPageLi.addClass("disabled");
            prePageLi.addClass("disabled");
        } else {
            firstPageLi.click(function () {
                to_page(1);
            });
            prePageLi.click(function () {
                to_page(result.extend.pageInfo.pageNum - 1);
            });
        }
        ul.append(firstPageLi).append(prePageLi);

        $.each(result.extend.pageInfo.navigatepageNums, function (index, item) {
            var numLi = $("<li></li>").append($("<a></a>").append(item));
            if (result.extend.pageInfo.pageNum == item) {
                numLi.addClass("active"); // 显示高亮
            }
            numLi.click(function () {
                to_page(item);
            });
            ul.append(numLi);
        });

        var nextPageLi = $("<li></li>").append($("<a></a>").append("&raquo;"));
        var lastPageLi = $("<li></li>").append($("<a></a>").append("末页").attr("href", "#"));
        if (result.extend.pageInfo.hasNextPage == false) {
            nextPageLi.addClass("disabled");
            lastPageLi.addClass("disabled");
        } else {
            nextPageLi.click(function () {
                to_page(result.extend.pageInfo.pageNum + 1);
            });
            lastPageLi.click(function () {
                to_page(result.extend.pageInfo.pages);
            });
        }
        ul.append(nextPageLi).append(lastPageLi);

        var navEle = $("<nav></nav>").append(ul);
        navEle.appendTo("#page_nav_area");
    }

    $(document).on("click", ".edit_btn", function () {

        getBook($(this).attr("edit_id"));
        $("#book_update_btn").attr("edit_id", $(this).attr("edit_id"));
        $("#bookUpdateModal").modal({
            backdrop: "static"
        });
    });

    function getBook(id) {
        $.ajax({
            url: "${APP_PATH}/book/" + id,
            type: "GET",
            success: function (result) {
                var bookData = result.extend.book;
                $("#bookName_update_static").text(bookData.bookName);
                $("#detail_update_input").val(bookData.detail);
                $("#price_update_input").val(bookData.price);
            }
        });
    }

    // 更新员工信息
    $("#book_update_btn").click(function () {

        $.ajax({
            url: "${APP_PATH}/book/" + $(this).attr("edit_id"),
            type: "PUT",
            data: $("#bookUpdateModal form").serialize(),
            success: function (result) {
                $("#bookUpdateModal").modal("hide");
                to_page(curretPage);
            }
        });
    });

    // 单个删除
    $(document).on("click", ".del_btn", function () {
        var bookName = $(this).parents("tr").find("td:eq(2)").text();
        var bookId = $(this).attr("del_id");
        if (confirm("确认删除【" + bookName + "】吗？")) {
            $.ajax({
                url: "${APP_PATH}/book/" + bookId,
                type: "DELETE",
                success: function (result) {
                    alert(result.msg);
                    to_page(curretPage);
                }
            });
        }
    });

    // 全选/全不选功能
    $("#check_all").click(function () {
        $(".check_item").prop("checked", $(this).prop("checked"));
    });

    //check_item
    $(document).on("click", ".check_item", function () {
        var flag = $(".check_item:checked").length == $(".check_item").length;
        $("#check_all").prop("checked", flag);
    });

    // 全选删除
    $("#book_delete_all_btn").click(function () {
        var bookNames = "";
        var del_idstr = "";
        $.each($(".check_item:checked"), function () {
            bookNames += $(this).parents("tr").find("td:eq(2)").text() + ",";
            // 组装员工id字符串
            del_idstr += $(this).parents("tr").find("td:eq(1)").text() + "-";
        });
        // 去除逗号
        bookNames = bookNames.substring(0, bookNames.length - 1);
        del_idstr = del_idstr.substring(0, del_idstr.length - 1);
        if (confirm("确认删除【" + bookNames + "】吗")) {
            // 发送ajax请求
            $.ajax({
                url: "${APP_PATH}/book/" + del_idstr,
                type: "DELETE",
                success: function (result) {
                    alert(result.msg);
                    to_page(curretPage);
                }
            });
        }
    });
</script>
</body>
</html>
