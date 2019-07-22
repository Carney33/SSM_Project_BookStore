package com.cpf.service;

import com.cpf.mapper.CustomerMapper;
import com.cpf.pojo.Customer;
import com.cpf.pojo.CustomerExample;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;

@Service
public class CustomerService {

    @Autowired
    CustomerMapper customerMapper;


    public boolean loginCus(String name, String password) {

        CustomerExample customerExample = new CustomerExample();
        CustomerExample.Criteria criteria = customerExample.createCriteria();
        criteria.andNameEqualTo(name);
        criteria.andPasswordEqualTo(password);
        long count = customerMapper.countByExample(customerExample);
        return count == 1;
    }

    public Boolean checkUser(String name) {
        CustomerExample customerExample = new CustomerExample();
        CustomerExample.Criteria criteria = customerExample.createCriteria();
        criteria.andNameEqualTo(name);
        long count = customerMapper.countByExample(customerExample);
        return count == 0;
    }

    public void saveCustomer(Customer customer) {
        customerMapper.insert(customer);
    }

    public Integer moneySelect(String name) {
        return customerMapper.selectMoneyByName(name);
    }

    public void moneyAdd(Integer money, String name) {
        Customer customer = new Customer();
        customer.setMoney(money);
        customer.setName(name);
        customerMapper.updateByMoneyAndName(customer);
    }

    public void moneySub(Integer price, String name) {
        Customer customer = new Customer();
        customer.setMoney(price);
        customer.setName(name);
        customerMapper.SubMoneyByName(customer);
    }
}
