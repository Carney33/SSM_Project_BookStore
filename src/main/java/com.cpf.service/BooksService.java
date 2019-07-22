package com.cpf.service;

import com.cpf.mapper.BooksMapper;
import com.cpf.pojo.Books;
import com.cpf.pojo.BooksExample;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class BooksService {

    @Autowired
    BooksMapper booksMapper;

    public Books getBook(Integer id) {
        return booksMapper.selectByPrimaryKey(id);
    }

    // Books查询 分页
    public List<Books> getAll() {
        return booksMapper.selectByExample(null);
    }

    public void updateBook(Books book) {
        booksMapper.updateByPrimaryKeySelective(book);
    }

    public void deleteBatch(List<Integer> ids) {
        BooksExample booksExample = new BooksExample();
        BooksExample.Criteria criteria = booksExample.createCriteria();
        criteria.andBookIdIn(ids);
        booksMapper.deleteByExample(booksExample);
    }

    public void deleteBookById(Integer id) {
        booksMapper.deleteByPrimaryKey(id);
    }
}
