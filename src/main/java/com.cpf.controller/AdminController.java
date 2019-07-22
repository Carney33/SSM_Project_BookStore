package com.cpf.controller;

import com.cpf.pojo.Msg;
import com.cpf.service.AdminService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class AdminController {

    @Autowired
    AdminService adminService;

    // 登陆
    @RequestMapping("/admin")
    @ResponseBody
    public Msg loginCus(@RequestParam("a_name") String a_name, @RequestParam("a_password") String a_password) {
        boolean b = adminService.loginAdmin(a_name, a_password);
        if (b) {
            return Msg.success();
        } else {
            return Msg.fail();
        }
    }
}
