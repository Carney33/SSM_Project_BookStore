package com.cpf.service;

import com.cpf.mapper.AdminMapper;
import com.cpf.pojo.AdminExample;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class AdminService {

    @Autowired
    AdminMapper adminMapper;

    public boolean loginAdmin(String a_name, String a_password) {

        AdminExample adminExample = new AdminExample();
        AdminExample.Criteria criteria = adminExample.createCriteria();
        criteria.andANameEqualTo(a_name);
        criteria.andAPasswordEqualTo(a_password);

        long count = adminMapper.countByExample(adminExample);

        return count == 1;
    }
}
