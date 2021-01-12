package com.wenhao.crud.service;

import com.wenhao.crud.bean.Employee;
import com.wenhao.crud.bean.EmployeeExample;
import com.wenhao.crud.dao.EmployeeMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @author Wenhao Tong
 * @Description
 * @create 2021-01-02 22:34
 */
@Service
public class EmployeeService {

    @Autowired
    private EmployeeMapper employeeMapper;

    public List<Employee> getAll(){
        List<Employee> employees = employeeMapper.selectByExampleWithDept(null);
        return employees;
    }

    public int addEmp(Employee employee) {
        int insert = employeeMapper.insert(employee);
        return insert;
    }

    public boolean existEmp(String lastName) {
        EmployeeExample employeeExample = new EmployeeExample();
        EmployeeExample.Criteria criteria = employeeExample.createCriteria();
        criteria.andLastNameEqualTo(lastName);
        long l = employeeMapper.countByExample(employeeExample);
        System.out.println(lastName);
        System.out.println(l);
        if (l == 0){
            return true;
        }else {
            return false;
        }
    }

    public Employee getEmpById(int id) {
        Employee employee = employeeMapper.selectByPrimaryKey(id);
        return employee;
    }

    public int updateEmp(Employee employee) {
        int i = employeeMapper.updateByPrimaryKeySelective(employee);
        return i;
    }

    public int deleteEmp(int id){
        int i = employeeMapper.deleteByPrimaryKey(id);
        return i;
    }

    public int deleteBatch(List<Integer> ids) {
        EmployeeExample employeeExample = new EmployeeExample();
        EmployeeExample.Criteria criteria = employeeExample.createCriteria();
        criteria.andIdIn(ids);
        int i = employeeMapper.deleteByExample(employeeExample);
        return i;
    }
}
