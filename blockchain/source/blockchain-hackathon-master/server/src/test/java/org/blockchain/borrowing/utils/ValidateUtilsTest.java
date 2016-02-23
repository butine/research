package org.blockchain.borrowing.utils;

import org.junit.Test;

public class ValidateUtilsTest {

    @Test(expected = Exception.class)
    public void test_validate_nulls() {
        ValidateUtils.notNulls(null, null);
    }

    @Test
    public void test(){
        ValidateUtils.notNulls(new Object());
    }
}
