import com.cpf.mapper.BooksMapper;
import com.cpf.pojo.Books;
import org.apache.ibatis.session.SqlSession;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.util.UUID;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:spring/applicationContext-dao.xml"})
public class MapperTest {

    @Autowired
    BooksMapper booksMapper;

    @Autowired
    SqlSession sqlSession;

    @Test
    public void m1() {
        BooksMapper mapper = sqlSession.getMapper(BooksMapper.class);
        for (int i = 0; i < 500; i++) {
            String bookName = "Java" + UUID.randomUUID().toString().substring(0, 5);
            String detail = UUID.randomUUID().toString().substring(6, 20);
            int price = (int) ((Math.random() + 1) * 100);
            mapper.insertSelective(new Books(null, bookName, detail, price));
        }
    }
}
