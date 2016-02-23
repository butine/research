package org.blockchain.borrowing.utils;

import org.blockchain.borrowing.domain.Trade;
import org.blockchain.borrowing.domain.User;
import org.blockchain.borrowing.repository.TradeRepository;
import org.blockchain.borrowing.repository.UserRepository;
import org.joda.time.DateTime;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.math.BigDecimal;
import java.util.Map;
import java.util.Random;

@Component
public class Startup {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private TradeRepository tradeRepository;

    public void setup() {
        for (int i = 0; i < 10; i++) {
            Map m = RandomValue.getAddress();


            User user = new User();
            user.setName(m.get("name").toString());
            user.setPhone(m.get("tel").toString());
            user.setAmount(BigDecimal.valueOf(new Random().nextDouble() % 10000));
            userRepository.save(user);

            Trade trade = new Trade();
            trade.setBorrower(user.getId());
            trade.setStatus(Trade.Status.INIT);
            trade.setAmount(BigDecimal.valueOf(new Random().nextDouble() % 10000));
            trade.setRepayDate(DateTime.now().plusDays(new Random().nextInt() % 100).toDate());
        }
    }
}
