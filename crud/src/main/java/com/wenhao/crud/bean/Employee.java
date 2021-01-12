package com.wenhao.crud.bean;

import javax.validation.constraints.Email;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Pattern;

public class Employee {
    private Integer id;

    @NotNull(message="用户名不能为空")
    @Pattern(regexp="^[a-zA-Z0-9_-]{4,16}$|^[\u4e00-\u9fa5]{2,4}$",message = "用户名为4-16位的字母数字下划线或2-4位的汉字组成")
    private String lastName;

    @Email
    private String email;

    private String gender;

    private Integer dId;

    private Department department;

    public Employee() {
    }

    public Employee(String lastName) {
        this.lastName = lastName;
    }

    public Employee(Integer id, String lastName, String email, String gender, Integer dId) {
        this.id = id;
        this.lastName = lastName;
        this.email = email;
        this.gender = gender;
        this.dId = dId;
    }

    public Department getDepartment() {
        return department;
    }

    public void setDepartment(Department department) {
        this.department = department;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName == null ? null : lastName.trim();
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email == null ? null : email.trim();
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender == null ? null : gender.trim();
    }

    public Integer getdId() {
        return dId;
    }

    public void setdId(Integer dId) {
        this.dId = dId;
    }

    @Override
    public String toString() {
        return "Employee{" +
                "id=" + id +
                ", lastName='" + lastName + '\'' +
                ", email='" + email + '\'' +
                ", gender='" + gender + '\'' +
                ", dId=" + dId +
                ", department=" + department +
                '}';
    }
}