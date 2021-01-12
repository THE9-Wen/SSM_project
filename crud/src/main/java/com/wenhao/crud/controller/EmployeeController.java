package com.wenhao.crud.controller;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.wenhao.crud.bean.Employee;
import com.wenhao.crud.bean.Msg;
import com.wenhao.crud.service.EmployeeService;
import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author Wenhao Tong
 * @Description
 * @create 2021-01-02 22:33
 */
@Controller
public class EmployeeController {

    @Autowired
    private EmployeeService employeeService;

//    @RequestMapping("emps")
//    public String list(@RequestParam(value = "pn",defaultValue = "1") Integer pn, Map<String,Object> map){
//        PageHelper.startPage(pn,5);
//        //紧跟的查询就是一个分页查询
//        List<Employee> employees = employeeService.getAll();
//        PageInfo<Employee> pageInfo= new PageInfo<Employee>(employees,5);
//        map.put("pageInfo",pageInfo);
//        return "list";
//    }

    @RequestMapping("emps")
    @ResponseBody
    public Msg list(@RequestParam(value = "pn",defaultValue = "1") Integer pn){
        PageHelper.startPage(pn,5);
        //紧跟的查询就是一个分页查询
        List<Employee> employees = employeeService.getAll();
        PageInfo<Employee> pageInfo= new PageInfo<Employee>(employees,5);
        return Msg.success().add("pageInfo",pageInfo);
    }

    @RequestMapping(value="emp",method = RequestMethod.POST)
    @ResponseBody
    public Msg addEmp(@Valid Employee employee, BindingResult result){
        Map<String,Object> map = new HashMap<String, Object>();
        if(result.hasErrors()) {
            List<FieldError> errors = result.getFieldErrors();
            for (FieldError fieldError : errors) {
                if (fieldError.getField().equals("lastName"))
                    map.put("lastNameError",fieldError.getDefaultMessage());
                if (fieldError.getField().equals("email"))
                    map.put("emailError",fieldError.getDefaultMessage());
            }
            return Msg.fail().add("errors",map);
        }else {
            String lastName = employee.getLastName();
            boolean b = employeeService.existEmp(lastName);
            if (b){
                employeeService.addEmp(employee);
                return Msg.success();
            }else{
                map.put("lastNameError","用户名已存在！");
                return Msg.fail().add("errors",map);
            }
        }
    }


    @RequestMapping(value="emp/{ids}",method = RequestMethod.DELETE)
    @ResponseBody
    public Msg delEmp(@PathVariable("ids") String ids){
        if(ids.contains("-")){
            List<Integer> id = new ArrayList<Integer>();
            String[] idStr = ids.split("-");
            for(String str:idStr){
                id.add(Integer.parseInt(str));
            }
            employeeService.deleteBatch(id);
        }else{
            int id = Integer.parseInt(ids);
            System.out.println(id);
            employeeService.deleteEmp(id);
        }
        return Msg.success();
    }

    @RequestMapping(value="emp/{id}",method = RequestMethod.GET)
    @ResponseBody
    public Msg getEmp(@PathVariable("id") int id){
        Employee empById = employeeService.getEmpById(id);
        return Msg.success().add("employee",empById);
    }

    @RequestMapping(value="emp/{id}",method = RequestMethod.PUT)
    @ResponseBody
    public Msg updateEmp(@Valid Employee employee,BindingResult result){
        System.out.println(employee);
        Map<String,Object> map = new HashMap<String, Object>();
        List<FieldError> errors = result.getFieldErrors();
        for (FieldError fieldError : errors) {
            if (fieldError.getField().equals("email")){
                map.put("emailError",fieldError.getDefaultMessage());
                return Msg.fail().add("errors",map);
            }
        }
        employeeService.updateEmp(employee);
        return Msg.success();
    }

}
