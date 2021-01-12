<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%--
  Created by IntelliJ IDEA.
  User: 85477
  Date: 2021/1/2
  Time: 10:42
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <%
        String contextPath = request.getContextPath();
        request.setAttribute("contextPath",contextPath);
    %>
    <!-- 上述3个meta标签*必须*放在最前面，任何其他内容都*必须*跟随其后！ -->
    <script src="${contextPath}/statics/js/jquery-3.5.1.js" type="text/javascript"></script>
    <!-- Bootstrap -->
    <link href="${contextPath}/statics/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- 加载 Bootstrap 的所有 JavaScript 插件。你也可以根据需要只加载单个插件。 -->
    <script src="${contextPath}/statics/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>

    <script type="text/javascript">
        var totalrecord = 0;
        $(function (){
            get_page(1);
            get_department();
            $("#emp_add_model_btn").click(function(){
                $('#addEmpModel').modal({
                    backdrop:'static'
                })
            })
            $("#save_btn").click(function(){
                add_emp()
            })

            $(document).on('click','.update',function(){
                $('#updateEmpModel').modal({
                    backdrop:'static'
                })
                var id = $(this).attr("emp_id")
                get_employee(id)
                $("#update_btn").attr("emp_id",id)
            })
            $("#update_btn").click(function(){
                update_emp($(this).attr("emp_id"))
            })
            $(document).on('click','.delete',function(){
                var b = confirm("确认删除"+ $(this).parents().parents("tr").find("td:eq(2)").text() +"吗？");
                var id = $(this).attr("emp_id")
                if (b)
                    del_employee(id)
                else
                    return b

            })
            $("#select_all").click(function(){
                $(".delete_select").prop("checked",$(this).prop("checked"))
            })
            $(document).on('click','.delete_select',function(){
                var length = $(".delete_select:checked").length;
                if (length == 5)
                    $("#select_all").prop("checked",true)
                else
                    $("#select_all").prop("checked",false)
            })
            $("#delete_all").click(function(){
                var empSelect =  $(".delete_select:checked")
                var empName = "确认删除："
                var ids = ""
                $.each(empSelect,function(){
                    empName += $(this).parents("tr").find("td:eq(2)").text() + "\n"
                    ids += $(this).parents("tr").find("td:eq(1)").text() + "-"
                })
                if (confirm(empName)){
                    delete_all(ids)
                }else{
                    return false
                }

            })
        })
        function delete_all(ids){
            $.ajax({
                url:"${contextPath}/emp/" + ids,
                type:"post",
                data:"_method=DELETE",
                success:function(){
                    get_page($(".active").text())
                }
            })
        }
        function del_employee(id){
            $.ajax({
                url:"${contextPath}/emp/" + id,
                type:"POST",
                data:"&_method=DELETE",
                success:function(){
                    get_page($(".active").text())
                    alert("删除成功！")
                }
            })
        }

        function update_emp(id){
            var regEmail = /^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\.[a-zA-Z0-9_-]+)+$/
            var b = valid_formtext($("#email_update"),regEmail,"邮箱格式不正确");
            if(!b){
                return false
            }
            $.ajax({
                url:"${contextPath}/emp/" + id,
                type:"POST",
                data:$("#updateEmpModel form").serialize() + "&id=" + id +"&_method=PUT",
                success:function(result){
                    var errors = result.map.errors
                    if (result.code == "200"){
                        show_validate_state($("#email_input"),"error",errors.emailError)
                        return false
                    }
                    if (result.code == "100"){
                        show_validate_state($("#email_input"),"success","")
                    }
                    $('#updateEmpModel').modal('hide')
                    get_page($(".active").text())
                }
            })
        }

        function valid_formtext(ele,reg,msg){
            var name = ele.val()
            if (!reg.test(name)){
                show_validate_state(ele,"error",msg)
                return false
            }else{
                show_validate_state(ele,"success","")
            }
            return true
        }

        function show_validate_state(ele,state,msg){
            ele.parent().removeClass("has-error has-success")
            ele.next().empty()
            if(state == "error"){
                ele.parent().addClass("has-error")
                ele.next().append(msg)
            }
            if (state == "success") {
                ele.parent().addClass("has-success")
                ele.next().append("")
            }
        }
        function add_emp(){
            var regName = /^[a-zA-Z0-9_-]{4,16}$|^[\u4e00-\u9fa5]{2,4}$/
            var regEmail = /^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\.[a-zA-Z0-9_-]+)+$/
            var b1 = valid_formtext($("#lastName_input"),regName,"用户名不符合规则");
            var b2 = valid_formtext($("#email_input"),regEmail,"邮箱格式不正确");
            if(!(b1&&b2)){
                return false
            }
            $.ajax({
                url:"${contextPath}/emp",
                type:"POST",
                data:$("#addEmpModel form").serialize(),
                success:function(result){
                    var errors = result.map.errors
                    if (result.code == "200"){
                        for (var key in errors) {
                            if (key == "lastNameError")
                                show_validate_state($("#lastName_input"),"error",errors.lastNameError)
                            if (key == "emailError")
                                show_validate_state($("#email_input"),"error",errors.emailError)
                        }
                        return false
                    }
                    if (result.code == "100"){
                        show_validate_state($("#lastName_input"),"success","")
                        show_validate_state($("#email_input"),"success","")
                    }
                    $('#addEmpModel').modal('hide')
                    get_page(totalrecord + 1)
                }
            })
        }
        function get_department(){
            $.ajax({
                url:"${contextPath}/depts",
                type:"GET",
                success:function(result){
                    build_depts(result)
                }
            })
        }
        function get_employee(id){
            $.ajax({
                url:"${contextPath}/emp/" + id,
                type:"GET",
                success:function(result){
                    var lastName = result.map.employee.lastName
                    var email = result.map.employee.email
                    var gender = result.map.employee.gender
                    var deptName = result.map.employee.dId
                    $("#lastName_update").text(lastName)
                    $("#email_update").val(email)
                    $("#updateEmpModel input[name=gender]").val([gender])
                    $("#updateEmpModel select").val([deptName])
                }
            })
        }
        function build_depts(result){
            $("#select_depts").empty()
            $("#email_input").empty()
            var depts = result.map.depts
            $.each(depts,function(index,item){
                $(".select_depts").append($("<option></option>").append(item.deptName).attr("value",item.id))
            })
        }
        function get_page(pn){
            $.ajax({
                url:"${contextPath}/emps",
                type:"GET",
                data:"pn=" + pn,
                success:function(result){
                    console.log(result)
                    build_emps_table(result)
                    build_page_info(result)
                    build_page_nave(result)
                }
            })
        }
        function build_emps_table(result){
            $("tbody").empty();
            var emps = result.map.pageInfo.list;
            $.each(emps,function(index,item){
                var empId = $("<td></td>").append(item.id);
                var empLastName = $("<td></td>").append(item.lastName);
                var empEmail = $("<td></td>").append(item.email);
                var empGender = $("<td></td>").append(item.gender);
                var empDept = $("<td></td>").append(item.department.deptName);
                var editBtn = $("<button></button>").addClass("btn btn-primary btn-sm update").append($("<span></span>").addClass("glyphicon glyphicon-pencil").append("修改"));
                editBtn.attr("emp_id",item.id)
                var delBtn = $("<button></button>").addClass("btn btn-danger btn-sm delete").append($("<span></span>").addClass("glyphicon glyphicon-trash").append("删除"));
                delBtn.attr("emp_id",item.id)
                var btnTd = $("<td></td>").append(editBtn).append(delBtn);
                var delSelectTd = $("<td></td>").append("<input type='checkbox' class='delete_select'>")
                var empTr = $("<tr></tr>").append(delSelectTd).append(empId).append(empLastName).append(empEmail).append(empGender).append(empDept).append(btnTd);
                $("tbody").append(empTr);
            });
        };
        function build_page_info(restult){
            $("ul").empty();
            $("#page_info_area").empty();
            var page = restult.map.pageInfo;
            $("#page_info_area").append("当前第" + page.pageNum + "页，共有" + page.pages + "页，总计" + page.total + "条记录");
            totalrecord = page.pages
        };
        function build_page_nave(result){
            var navigatepageNums = result.map.pageInfo.navigatepageNums;
            var firstPage = $("<li></li>").append($("<a></a>").append("首页").attr("href","#").attr("aria-label","Previous"));
            var previousPage = $("<li></li>").append($("<a></a>").append("&laquo;").attr("href","#"));
            if (result.map.pageInfo.isFirstPage){
                firstPage.addClass("disabled");
                previousPage.addClass("disabled");
            }else{
                firstPage.click(function(){
                    get_page(1)
                })
                previousPage.click(function(){
                    get_page(result.map.pageInfo.pageNum - 1)
                })
            }
            $("ul").append(firstPage).append(previousPage);
            $.each(navigatepageNums,function(index,item){
                var pageLi = $("<li></li>").append($("<a></a>").append(item).attr("href","#"));
                if (item == result.map.pageInfo.pageNum){
                    pageLi.addClass("active")
                }
                pageLi.click(function(){
                    get_page(item);
                })
                $("ul").append(pageLi);
            });
            var lastPage = $("<li></li>").append($("<a></a>").append("末页").attr("href","#").attr("aria-label","Next"));
            var nextPage = $("<li></li>").append($("<a></a>").append("&raquo;").attr("href","#"));
            if (result.map.pageInfo.isLastPage){
                lastPage.addClass("disabled");
                nextPage.addClass("disabled");
            }else{
                lastPage.click(function(){
                    get_page(result.map.pageInfo.pages)
                })
                nextPage.click(function(){
                    get_page(result.map.pageInfo.pageNum + 1)
                })
            }
            $("ul").append(nextPage).append(lastPage);
        }
    </script>
</head>
<body>
<div class="container">
        <div class="row">
            <h1 class="text-center"><strong>SSM_CRUD</strong></h1>
        </div>
        <div class="row">
            <div class="col-md-4 col-md-offset-10">
                <!-- Provides extra visual weight and identifies the primary action in a set of buttons -->
                <button type="button" id="emp_add_model_btn" class="btn btn-primary btn-sm">
                    <span class="glyphicon glyphicon-pencil" aria-hidden="true"> 添加</span>
                </button>
                <!-- Indicates a dangerous or potentially negative action -->
                <button type="button" class="btn btn-danger btn-sm">
                    <span class="glyphicon glyphicon-trash" aria-hidden="true" id="delete_all"> 删除</span></button>
            </div>
        </div>
        <br>
        <!-- Columns are always 50% wide, on mobile and desktop -->
        <div class="row">
            <table class="table table-striped table-hover">
                <thead>
                <tr>
                    <th><input type="checkbox" id="select_all"></th>
                    <th>#</th>
                    <th>姓名</th>
                    <th>邮箱</th>
                    <th>性别</th>
                    <th>部门</th>
                    <th>操作</th>
                </tr>
                </thead>
                <tbody>
                </tbody>
            </table>
        </div>
        <div class="row">
            <div class="text-center" id="page_info_area"></div>
            <div class="text-center">
                <nav aria-label="Page navigation">
                    <ul class="pagination"></ul>
                </nav>
            </div>
        </div>
</div>
<!-- 修改模态框 -->
<div class="modal fade" id="updateEmpModel" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="updateEmpModelLabel">修改员工信息</h4>
            </div>
            <div class="modal-body">
                <form>
                    <div class="form-group">
                        <label for="lastName_update">姓名</label><br>
                        <p class="form-control-static" id="lastName_update"></p>
                    </div>
                    <div class="form-group">
                        <label for="email_update">邮箱</label>
                        <input type="email" name="email" class="form-control" id="email_update">
                        <span class="help-block"></span>
                    </div>
                    <div class="form-group">
                        <label>性别</label>
                        <label class="radio-inline">
                            <input type="radio" name="gender" id="gender1" value="男">男
                        </label>
                        <label class="radio-inline">
                            <input type="radio" name="gender" id="gender2" value="女">女
                        </label>
                    </div>
                    <div class="form-group">
                        <label>部门</label>
                        <select class="form-control select_depts" name="dId" >
                        </select>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                <button type="button" class="btn btn-primary" id="update_btn">Save changes</button>
            </div>
        </div>
    </div>
</div>
<%--添加模态框--%>
<div class="modal fade" id="addEmpModel" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="myModalLabel">添加员工信息</h4>
            </div>
            <div class="modal-body">
                <form>
                    <div class="form-group">
                        <label for="lastName_input">姓名</label>
                        <input type="text" name="lastName" class="form-control" id="lastName_input" placeholder="刘昊然">
                        <span id="lastName_helpBox" class="help-block"></span>
                    </div>
                    <div class="form-group">
                        <label for="email_input">邮箱</label>
                        <input type="email" name="email" class="form-control" id="email_input" placeholder="example@qq.com">
                        <span id="email_helpBox" class="help-block"></span>
                    </div>
                    <div class="form-group">
                        <label>性别</label>
                        <label class="radio-inline">
                            <input type="radio" name="gender" value="男">男
                        </label>
                        <label class="radio-inline">
                            <input type="radio" name="gender" value="女">女
                        </label>
                    </div>
                    <div class="form-group">
                        <label>部门</label>
                        <select class="form-control select_depts" name="dId">
                        </select>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                <button type="button" class="btn btn-primary" id="save_btn">Save changes</button>
            </div>
        </div>
    </div>
</div>
</body>
</html>
