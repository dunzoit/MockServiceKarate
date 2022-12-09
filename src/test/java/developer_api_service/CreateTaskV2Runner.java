package developer_api_service;

import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import static org.junit.jupiter.api.Assertions.*;
import org.junit.jupiter.api.Test;

class CreateTaskV2TestParallel {

    @Test
    void testParallel() {
        Results results = Runner.path("classpath:developer_api_service").tags("~@skipme").parallel(5);
        assertEquals(0, results.getFailCount(), results.getErrorMessages());
    }

}
