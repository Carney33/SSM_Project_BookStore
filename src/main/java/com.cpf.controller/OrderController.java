package com.cpf.controller;

import com.cpf.pojo.Books;
import com.cpf.pojo.Msg;
import com.cpf.pojo.Orders;
import com.cpf.service.OrderService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Controller
public class OrderController {

    @Autowired
    OrderService orderService;

    // 购买的书本写入数据库
    @RequestMapping("/insertOrder")
    @ResponseBody
    public Msg insertOrder(String bookName, Integer price, String ownName, String createTime) {
        orderService.insertOrder(bookName, price, ownName, createTime);
        return Msg.success();
    }

    // 查询出已购买物品
    @RequestMapping("/own")
    @ResponseBody
    public Msg getOwn(String ownName) {
        List<Orders> orders = orderService.getAll(ownName);
        return Msg.success().add("orders", orders);
    }
}
