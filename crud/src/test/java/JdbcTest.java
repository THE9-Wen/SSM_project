import com.wenhao.crud.bean.Department;
import com.wenhao.crud.bean.Employee;
import com.wenhao.crud.dao.DepartmentMapper;
import com.wenhao.crud.dao.EmployeeMapper;
import org.apache.ibatis.session.SqlSession;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.util.UUID;

/**
 * @author Wenhao Tong
 * @Description
 * @create 2021-01-02 21:36
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations={"classpath:applicationContext.xml"})
public class JdbcTest {

    @Autowired
    private DepartmentMapper departmentMapper;

    @Autowired
    private EmployeeMapper employeeMapper;

    @Autowired
    private SqlSession sqlSession;

    @Test
    public void testCRUD(){
        departmentMapper.insert(new Department(null,"开发部"));
        departmentMapper.insert(new Department(null,"测试部"));
        departmentMapper.insert(new Department(null,"财务部"));
    }

    @Test
    public void testEmployeeMapper(){
        EmployeeMapper mapper = sqlSession.getMapper(EmployeeMapper.class);
        for (int i = 0;i < 1000;i++){
            String lastName = UUID.randomUUID().toString().substring(0, 5) + i;
            mapper.insertSelective(new Employee(null,lastName,lastName + "@qq.com","男",1));
        }
    }

    @Test
    public void testDelete(){
        employeeMapper.deleteByPrimaryKey(1001);
    }





}
