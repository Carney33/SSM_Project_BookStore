package com.cpf.controller;

import com.cpf.pojo.Books;
import com.cpf.pojo.Msg;
import com.cpf.service.BooksService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;

@Controller
public class BooksController {

    @Autowired
    BooksService booksService;

    @RequestMapping("/books")
    @ResponseBody
    public Msg getBooks(@RequestParam(value = "pn", defaultValue = "1") Integer pn) {
        PageHelper.startPage(pn, 5);
        List<Books> emps = booksService.getAll();
        PageInfo page = new PageInfo(emps, 5);

        return Msg.success().add("pageInfo", page);
    }

    @RequestMapping(value = "/book/{id}", method = RequestMethod.GET)
    @ResponseBody
    public Msg getBook(@PathVariable("id") Integer id) {
        Books book = booksService.getBook(id);
        return Msg.success().add("book", book);
    }

    @RequestMapping(value = "/book/{bookId}", method = RequestMethod.PUT)
    @ResponseBody
    public Msg saveBook(Books book) {
        System.out.println(book);
        booksService.updateBook(book);
        return Msg.success();
    }

    @RequestMapping(value = "/book/{ids}", method = RequestMethod.DELETE)
    @ResponseBody
    public Msg deleteEmpById(@PathVariable("ids") String ids) {

        if (ids.contains("-")) {
            String[] str_ids = ids.split("-");

            // 组装id的集合
            List<Integer> del_ids = new ArrayList<>();
            for (String string : str_ids) {
                del_ids.add(Integer.parseInt(string));
            }
            booksService.deleteBatch(del_ids);
        } else {
            Integer id = Integer.parseInt(ids);
            booksService.deleteBookById(id);
        }

        return Msg.success();
    }
}
