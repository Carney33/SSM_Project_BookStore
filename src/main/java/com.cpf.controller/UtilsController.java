package com.cpf.controller;

import com.cpf.pojo.Msg;
import com.cpf.utils.RandomValidateCode;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@Controller
public class UtilsController {

    @RequestMapping("/checkCode")
    public void checkCode(HttpServletRequest request, HttpServletResponse response){
        response.setContentType("image/jpeg");//设置相应类型,告诉浏览器输出的内容为图片
        response.setHeader("Pragma", "No-cache");//设置响应头信息，告诉浏览器不要缓存此内容
        response.setHeader("Cache-Control", "no-cache");
        response.setDateHeader("Expire", 0);
        RandomValidateCode randomValidateCode = new RandomValidateCode();
        try {
            randomValidateCode.getRandcode(request, response);//输出验证码图片方法
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @RequestMapping("/thiscode")
    @ResponseBody
    public Msg code(@RequestParam("thiscode") String thiscode, HttpSession session) {

        String newCode = thiscode.toUpperCase();
        String random = (String) session.getAttribute("RANDOMVALIDATECODEKEY");
        if (random.equals(newCode)) {
            return Msg.success();
        } else {
            return Msg.fail();
        }
    }
}
