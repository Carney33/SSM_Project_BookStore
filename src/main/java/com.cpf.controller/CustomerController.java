package com.cpf.controller;

import com.cpf.pojo.Customer;
import com.cpf.pojo.Msg;
import com.cpf.service.CustomerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class CustomerController {

    @Autowired
    CustomerService customerService;

    // 登陆
    @RequestMapping("/customer")
    @ResponseBody
    public Msg loginCus(String name, String password) {
        boolean b = customerService.loginCus(name, password);
        if (b) {
            return Msg.success();
        } else {
            return Msg.fail();
        }
    }

    // 校验用户
    @RequestMapping("/checkCustomer")
    @ResponseBody
    public Msg checkCustomer(@RequestParam("name") String name) {
        String regx = "(^[a-zA-Z0-9_-]{3,6}$)|(^[\\u2E80-\\u9FFF]{2,5})";
        if (!name.matches(regx)) {
            return Msg.fail();
        }
        Boolean b = customerService.checkUser(name);
        if (b) {
            return Msg.success();
        } else {
            return Msg.fail();
        }
    }

    // 注册
    @RequestMapping("/saveCustomer")
    @ResponseBody
    public Msg saveCustomer(String name, String password) {
        Customer customer = new Customer();
        customer.setId(null);
        customer.setName(name);
        customer.setPassword(password);
        customer.setMoney(0);
        customerService.saveCustomer(customer);
        return Msg.success();
    }

    // 查询余额
    @RequestMapping("/moneySelect")
    @ResponseBody
    public Msg moneySelect(String name) {
        Integer money = customerService.moneySelect(name);
        return Msg.success().add("money", money);
    }

    // 充值
    @RequestMapping("/moneyAdd")
    @ResponseBody
    public Msg moneyAdd(Integer money, String name) {
        customerService.moneyAdd(money, name);
        return Msg.success();
    }

    // 购买
    @RequestMapping("/buyBook")
    @ResponseBody
    public Msg buyBook(Integer price, String name) {
        customerService.moneySub(price, name);
        return Msg.success();
    }
}