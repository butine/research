package org.blockchain.borrowing.utils;

import org.apache.commons.lang3.Validate;
import org.blockchain.borrowing.domain.Trade;

import java.util.Arrays;

public class ValidateUtils {

    public static void notNulls(Object o, Object... os) {
        for (Object i : Arrays.asList(o, os)) {
            Validate.notNull(i);
        }
    }

    public static void isSame(Trade inDatabase, Trade fromFactom) {
        Validate.isTrue(inDatabase.getAmount().compareTo(fromFactom.getAmount()) == 0);
        Validate.isTrue(inDatabase.getInterest().compareTo(fromFactom.getInterest()) == 0);
        Validate.isTrue(inDatabase.getBorrower() == fromFactom.getBorrower());
    }

}
