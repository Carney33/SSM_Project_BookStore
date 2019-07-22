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
<!-- 余额模态框 -->
<div class="modal fade" id="moneyCount" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title">余额</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal">
                    <div class="form-group">
                        <label class="col-sm-2 control-label">所剩余额</label>
                        <div class="col-sm-10">
                            <p class="form-control-static" id="money_left"></p>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="col-sm-2 control-label">充值</label>
                        <div class="col-sm-10">
                            <label>￥30<input type="radio" data-value="30" class="radio" value="30"
                                             name="device-number"/></label>
                            &nbsp;&nbsp;&nbsp;
                            <label>￥50<input type="radio" data-value="50" class="radio" value="50" name="device-number"></label>
                            &nbsp;&nbsp;&nbsp;
                            <label>￥100<input type="radio" data-value="100" class="radio" value="100" name="device-number"></label>
                            &nbsp;&nbsp;&nbsp;
                            <label>￥300<input type="radio" data-value="300" class="radio" value="300"
                                              name="device-number"></label>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="money_update_btn">充值</button>
            </div>
        </div>
    </div>
</div>

<div class="container">
    <!-- 显示标题行 -->
    <div class="row">
        <div class="col-md-12">
            <h1>主界面</h1>
            <div class="col-md-4 col-md-offset-8" id="cus_info">

            </div>
        </div>
    </div>
    <!-- 表格 -->
    <div class="row">
        <div class="col-md-12">
            <table class="table table-hover" id="books_tables">
                <thead>
                <tr>
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
</body>

<script type="text/javascript">

    // 总记录数和当前页
    var totalRecord, curretPage;

    // 页面加载就显示第一页
    $(function () {
        to_page(1);
    });

    // 到第几页
    function to_page(pn) {
        $.ajax({
            url: "${APP_PATH}/books",
            data: "pn=" + pn,
            type: "GET",
            success: function (result) {
                // 显示名字、登出和余额
                build_information(result);
                // 显示表格
                build_books_table(result);
                // 显示分页信息
                build_page_info(result);
                // 显示分页条
                build_page_nav(result);
            }
        });
    }

    // 显示名字、登出和余额
    function build_information(result) {
        $("#cus_info").empty();
        $("#cus_info").append("&nbsp;&nbsp;&nbsp欢迎您&nbsp;&nbsp;&nbsp").append("<u>" + unescape(document.cookie) + "</u>")
            .append("&nbsp;&nbsp;&nbsp;<button type=\"button\" id=\"money_select\" class=\"btn btn-info\">余额查询</button>")
            .append("&nbsp;&nbsp;&nbsp;<button type=\"button\" id=\"my_own\" class=\"btn btn-warning\">我购买的</button>")
            .append("&nbsp;&nbsp;&nbsp;<button type=\"button\" id=\"admin_btn\" class=\"btn btn-success\" onclick=\"window.location='/index.jsp'\">登出</button>");
        $("#cus_info").append("<br/>");
    }

    // 显示表格
    function build_books_table(result) {
        $("#books_tables tbody").empty();

        var books = result.extend.pageInfo.list;
        $.each(books, function (index, item) {
            var bookIdTd = $("<td></td>").append(item.bookId);
            var bookNameTd = $("<td></td>").append(item.bookName);
            var detailTd = $("<td></td>").append(item.detail);
            var priceTd = $("<td></td>").append(item.price);
            var addBtn = $("<button></button>").addClass("btn btn-primary btn-sm add_btn")
                .append("购买");
            addBtn.attr("buy_id", item.bookId);
            $("<tr></tr>")
                .append(bookIdTd)
                .append(bookNameTd)
                .append(detailTd)
                .append(priceTd)
                .append(addBtn)
                .appendTo("#books_tables tbody");
        });
    }

    // 显示分页信息
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

    // 显示分页条
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

    // 显示余额
    $(document).on("click", "#money_select", function () {
        $.ajax({
            url: "${APP_PATH}/moneySelect",
            type: "POST",
            data: "name=" + document.cookie,
            success: function (result) {
                $("#money_left").text(result.extend.money);
                $("#moneyCount").modal({
                    backdrop: "static"
                });
            }
        });
    });

    // 充值
    $(document).on("click", "#money_update_btn", function () {
        $.ajax({
            url: "${APP_PATH}/moneyAdd",
            type: "POST",
            data: {money: $("input[name='device-number']:checked").val(), name: document.cookie},
            success: function (result) {
                $.ajax({
                    url: "${APP_PATH}/moneySelect",
                    type: "POST",
                    data: "name=" + document.cookie,
                    success: function (result) {
                        alert("充值成功，当前余额" + result.extend.money);
                    }
                });
                $("#moneyCount").modal("hide");
                to_page(curretPage);
            }
        });
    });

    // 购买
    $(document).on("click", ".add_btn", function () {
        var bookName = $(this).parents("tr").find("td:eq(1)").text();
        var price = $(this).parents("tr").find("td:eq(3)").text();
        if (confirm("确认花【￥" + price + "】购买【" + bookName + "】吗")) {
            $.ajax({
                url: "${APP_PATH}/moneySelect",
                type: "POST",
                data: "name=" + document.cookie,
                success: function (result) {
                    if (result.extend.money < price) {
                        alert("余额不足，请充值");
                        $.ajax({
                            url: "${APP_PATH}/moneySelect",
                            type: "POST",
                            data: "name=" + document.cookie,
                            success: function (result) {
                                $("#money_left").text(result.extend.money);
                                $("#moneyCount").modal({
                                    backdrop: "static"
                                });
                            }
                        });
                    } else {
                        // 完成购买并查出余额
                        $.ajax({
                            url: "${APP_PATH}/buyBook",
                            data: {price: price, name: document.cookie},
                            type: "POST",
                            success: function (result) {
                                // 将购买的记录写入数据库
                                $.ajax({
                                    url: "${APP_PATH}/insertOrder",
                                    type: "POST",
                                    data: {
                                        bookName: bookName,
                                        price: price,
                                        ownName: document.cookie,
                                        createTime: DateUtils.format(new Date(), 'yyyy-MM-dd HH:mm:ss')
                                    }
                                });

                                // 购买完成并查出余额
                                $.ajax({
                                    url: "${APP_PATH}/moneySelect",
                                    type: "POST",
                                    data: "name=" + document.cookie,
                                    success: function (result) {
                                        alert("购买完成，当前余额" + result.extend.money);
                                    }
                                });
                            }
                        });
                    }
                }
            });
        }
    });

    // 日期转换工具类
    DateUtils = (function () {
        /*
        var locale = {
            dayNames: ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"],
            shortDayNames: ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"],
            monthNames: ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"],
            shortMonthNames: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"],
            am: 'AM',
            pm: 'PM',
            shortAm: 'A',
            shortPm: 'P'
        };
        */

        var locale = {
            dayNames: ["星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"],
            shortDayNames: ["日", "一", "二", "三", "四", "五", "六"],
            monthNames: ["一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月"],
            shortMonthNames: ["一", "二", "三", "四", "五", "六", "七", "八", "九", "十", "十一", "十二"],
            am: "上午",
            pm: "下午",
            shortAm: '上',
            shortPm: '下'
        };

        /**
         * 左边补0
         */
        function leftPad(str, size) {
            var result = '' + str;

            while (result.length < size) {
                result = '0' + result;
            }

            return result;
        }

        var parseToken = (function () {
            var match2 = /\d{2}/,          // 00 - 99
                //match3 = /\d{3}/,          // 000 - 999
                match4 = /\d{4}/,          // 0000 - 9999
                match1to2 = /\d{1,2}/,     // 0 - 99
                match1to3 = /\d{1,3}/,     // 0 - 999
                //match1to4 = /\d{1,4}/,     // 0 - 9999
                match2w = /.{2}/,         // 匹配两个字符
                match1wto2w = /.{1,2}/,   // 匹配1~2个字符
                map = {
                    //年的后两位
                    'yy': {
                        regex: match2,
                        name: 'year'
                    },
                    //年
                    'yyyy': {
                        regex: match4,
                        name: 'year'
                    },
                    //两位数的月，不到两位数则补0
                    'MM': {
                        regex: match2,
                        name: 'month'
                    },
                    //月
                    'M': {
                        regex: match1to2,
                        name: 'month'
                    },
                    //两位数的日期，不到两位数则补0
                    'dd': {
                        regex: match2,
                        name: 'date'
                    },
                    //日期
                    'd': {
                        regex: match1to2,
                        name: 'date'
                    },
                    //两位数的小时，24小时进制
                    'HH': {
                        regex: match2,
                        name: 'hours'
                    },
                    //小时，24小时进制
                    'H': {
                        regex: match1to2,
                        name: 'hours'
                    },
                    //两位数的小时，12小时进制
                    'hh': {
                        regex: match2,
                        name: 'hours'
                    },
                    //小时，12小时进制
                    'h': {
                        regex: match1to2,
                        name: 'hours'
                    },
                    //两位数的分钟
                    'mm': {
                        regex: match2,
                        name: 'minutes'
                    },
                    //分钟
                    'm': {
                        regex: match1to2,
                        name: 'minutes'
                    },
                    's': {
                        regex: match1to2,
                        name: 'seconds'
                    },
                    'ss': {
                        regex: match2,
                        name: 'seconds'
                    },
                    //上午、下午
                    'tt': {
                        regex: match2w,
                        name: 't'
                    },
                    //上午、下午
                    't': {
                        regex: match1wto2w,
                        name: 't'
                    },
                    //毫秒
                    'S': {
                        regex: match1to3,
                        name: 'millisecond'
                    },
                    //毫秒
                    'SS': {
                        regex: match1to3,
                        name: 'millisecond'
                    },
                    //毫秒
                    'SSS': {
                        regex: match1to3,
                        name: 'millisecond'
                    }
                };

            return function (token, str, dateObj) {
                var result, part = map[token];
                if (part) {
                    result = str.match(part.regex);
                    if (result) {
                        dateObj[part.name] = result[0];
                        return result[0];
                    }
                }

                return null;
            };
        })();

        return {
            locale: locale,
            format: function (val, pattern) {
                if (Object.prototype.toString.call(val) !== '[object Date]') {
                    return '';
                }

                if (Object.prototype.toString.call(pattern) !== '[object String]' || pattern === '') {
                    pattern = 'yyyy-MM-dd HH:mm:ss';
                }

                var fullYear = val.getFullYear(),
                    month = val.getMonth(),
                    day = val.getDay(),
                    date = val.getDate(),
                    hours = val.getHours(),
                    minutes = val.getMinutes(),
                    seconds = val.getSeconds(),
                    milliseconds = val.getMilliseconds();

                return pattern.replace(/(\\)?(dd?d?d?|MM?M?M?|yy?y?y?|hh?|HH?|mm?|ss?|tt?|SS?S?)/g, function (m) {
                    if (m.charAt(0) === '\\') {
                        return m.replace('\\', '');
                    }

                    var locale = DateUtils.locale;

                    switch (m) {
                        case "hh":
                            return leftPad(hours < 13 ? (hours === 0 ? 12 : hours) : (hours - 12), 2);
                        case "h":
                            return hours < 13 ? (hours === 0 ? 12 : hours) : (hours - 12);
                        case "HH":
                            return leftPad(hours, 2);
                        case "H":
                            return hours;
                        case "mm":
                            return leftPad(minutes, 2);
                        case "m":
                            return minutes;
                        case "ss":
                            return leftPad(seconds, 2);
                        case "s":
                            return seconds;
                        case "yyyy":
                            return fullYear;
                        case "yy":
                            return (fullYear + '').substring(2);
                        case "dddd":
                            return locale.dayNames[day];
                        case "ddd":
                            return locale.shortDayNames[day];
                        case "dd":
                            return leftPad(date, 2);
                        case "d":
                            return date;
                        case "MMMM":
                            return locale.monthNames[month];
                        case "MMM":
                            return locale.shortMonthNames[month];
                        case "MM":
                            return leftPad(month + 1, 2);
                        case "M":
                            return month + 1;
                        case "t":
                            return hours < 12 ? locale.shortAm : locale.shortPm;
                        case "tt":
                            return hours < 12 ? locale.am : locale.pm;
                        case "S":
                            return milliseconds;
                        case "SS":
                            return leftPad(milliseconds, 2);
                        case "SSS":
                            return leftPad(milliseconds, 3);
                        default:
                            return m;
                    }
                });
            },

            parse: function (val, pattern) {
                if (!val) {
                    return null;
                }

                if (Object.prototype.toString.call(val) === '[object Date]') {
                    // 如果val是日期，则返回。
                    return val;
                }

                if (Object.prototype.toString.call(val) !== '[object String]') {
                    // 如果val不是字符串，则退出。
                    return null;
                }

                var time;
                if (Object.prototype.toString.call(pattern) !== '[object String]' || pattern === '') {
                    // 如果fmt不是字符串或者是空字符串。
                    // 使用浏览器内置的日期解析
                    time = Date.parse(val);
                    if (isNaN(time)) {
                        return null;
                    }

                    return new Date(time);
                }

                var i, token, tmpVal,
                    tokens = pattern.match(/(\\)?(dd?|MM?|yy?y?y?|hh?|HH?|mm?|ss?|tt?|SS?S?|.)/g),
                    dateObj = {
                        year: 0,
                        month: 1,
                        date: 0,
                        hours: 0,
                        minutes: 0,
                        seconds: 0,
                        millisecond: 0
                    };

                for (i = 0; i < tokens.length; i++) {
                    token = tokens[i];
                    tmpVal = parseToken(token, val, dateObj);

                    if (tmpVal !== null) {
                        if (val.length > tmpVal.length) {
                            val = val.substring(tmpVal.length);
                        } else {
                            val = '';
                        }
                    } else {
                        val = val.substring(token.length);
                    }
                }

                if (dateObj.t) {
                    if (DateUtils.locale.pm === dateObj.t || DateUtils.locale.shortPm === dateObj.t) {
                        dateObj.hours = (+dateObj.hours) + 12;
                    }
                }

                dateObj.month -= 1;

                return new Date(dateObj.year, dateObj.month, dateObj.date, dateObj.hours, dateObj.minutes, dateObj.seconds, dateObj.millisecond);
            }
        };
    })();

    // 查询已购买的
    $(document).on("click", "#my_own", function () {
        window.location="/views/myBuy.jsp";
    });
</script>

</html>
