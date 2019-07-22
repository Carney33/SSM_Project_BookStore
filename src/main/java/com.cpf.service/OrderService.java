package com.cpf.service;

import com.cpf.mapper.OrdersMapper;
import com.cpf.pojo.Books;
import com.cpf.pojo.Orders;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class OrderService {

    @Autowired
    OrdersMapper ordersMapper;

    public void insertOrder(String bookName, Integer price, String ownName, String createTime) {
        Orders orders = new Orders();
        orders.setoId(null);
        orders.setBookName(bookName);
        orders.setBookPrice(price);
        orders.setOwnName(ownName);
        orders.setCreateTime(createTime);
        ordersMapper.insert(orders);
    }

    public List<Orders> getAll(String ownName) {
        return ordersMapper.getAll(ownName);
    }
}
