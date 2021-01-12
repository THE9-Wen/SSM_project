package com.wenhao.crud.service;

import com.wenhao.crud.bean.Department;
import com.wenhao.crud.bean.Employee;
import com.wenhao.crud.dao.DepartmentMapper;
import com.wenhao.crud.dao.EmployeeMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @author Wenhao Tong
 * @Description
 * @create 2021-01-03 21:44
 */
@Service
public class DepartmentService {
    @Autowired
    private DepartmentMapper departmentMapper;

    public List<Department> getAll(){
        List<Department> departments = departmentMapper.selectByExample(null);
        return departments;
    }

}
