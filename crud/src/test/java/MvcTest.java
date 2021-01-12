import com.github.pagehelper.Page;
import com.github.pagehelper.PageInfo;
import com.wenhao.crud.bean.Employee;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MockMvcBuilder;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import javax.sound.midi.Soundbank;
import java.sql.SQLOutput;

/**
 * @author Wenhao Tong
 * @Description
 * @create 2021-01-02 23:38
 */
@RunWith(SpringJUnit4ClassRunner.class)
@WebAppConfiguration
@ContextConfiguration(locations={"classpath:applicationContext.xml","classpath:dispatcherServlet-servlet.xml"})
public class MvcTest {

    @Autowired
    private WebApplicationContext context;

    private MockMvc mockMvc;

    @Before
    public void initMockMvc(){
        mockMvc = MockMvcBuilders.webAppContextSetup(context).build();
    }

    @Test
    public void testPage() throws Exception {
        MvcResult emps = mockMvc.perform(MockMvcRequestBuilders.get("/emps").param("pn","1")).andReturn();
        MockHttpServletRequest request = emps.getRequest();
        PageInfo<Employee> pageInfo = (PageInfo) request.getAttribute("pageInfo");
        long endRow = pageInfo.getEndRow();
        long total = pageInfo.getTotal();
        int pageNum = pageInfo.getPageNum();
        System.out.println(pageInfo.getPageNum());
        System.out.println(endRow);
        System.out.println(total);
        System.out.println("总页码" + pageNum);

    }


}
