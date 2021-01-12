package com.wenhao.crud.controller;

import com.wenhao.crud.bean.Department;
import com.wenhao.crud.bean.Msg;
import com.wenhao.crud.service.DepartmentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

/**
 * @author Wenhao Tong
 * @Description
 * @create 2021-01-03 21:44
 */
@Controller
public class DepartmentController {

    @Autowired
    private DepartmentService departmentService;

    @RequestMapping(value = "depts",method = RequestMethod.GET)
    @ResponseBody
    public Msg getDept(){
        List<Department> departments = departmentService.getAll();
        Msg msg = Msg.success();
        return msg.add("depts",departments);
    }
}
