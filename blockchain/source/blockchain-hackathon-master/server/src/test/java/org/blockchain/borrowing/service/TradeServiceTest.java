package org.blockchain.borrowing.service;

import org.blockchain.borrowing.Application;
import org.blockchain.borrowing.domain.Trade;
import org.blockchain.borrowing.domain.User;
import org.blockchain.borrowing.repository.TradeRepository;
import org.blockchain.borrowing.repository.UserRepository;
import org.junit.After;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.IntegrationTest;
import org.springframework.boot.test.SpringApplicationConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.math.BigDecimal;
import java.util.Collections;
import java.util.List;

@RunWith(SpringJUnit4ClassRunner.class)
@SpringApplicationConfiguration(classes = Application.class)
@IntegrationTest
public class TradeServiceTest {

    @Autowired
    private UserService userService;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private TradeService tradeService;

    @Autowired
    private TradeRepository tradeRepository;

    User borrow, lender;

    @Before
    public void setup() {
        borrow = new User();
        borrow.setAmount(BigDecimal.valueOf(1000));

        lender = new User();
        lender.setAmount(BigDecimal.valueOf(1000));

        userRepository.save(borrow);
        userRepository.save(lender);
        Assert.assertTrue(borrow.getAmount().equals(BigDecimal.valueOf(1000)));
        Assert.assertTrue(lender.getAmount().equals(BigDecimal.valueOf(1000)));
    }

    @After
    public void clean() {
        userRepository.delete(borrow);
        userRepository.delete(lender);
    }

    @Test
    public void test_create_trade() {
        Trade trade = new Trade();
        trade.setAmount(BigDecimal.valueOf(100));
        trade.setInterest(BigDecimal.ONE);
        trade.setBorrower(borrow.getId());
        trade.setStatus(Trade.Status.INIT);

        tradeService.postTrade(trade);

        List<Trade> trades = tradeService.listByBorrowerAndStatues(borrow.getId(), Collections.singleton(Trade.Status.INIT));
        Assert.assertTrue(trades.size() == 1);
        Assert.assertTrue(trades.get(0).getAmount().doubleValue() == 100);
    }

    @Test
    public void test_borrow_trade() {
        Trade trade = new Trade();
        trade.setAmount(BigDecimal.valueOf(100));
        trade.setInterest(BigDecimal.ONE);
        trade.setBorrower(borrow.getId());
        trade.setStatus(Trade.Status.INIT);

        tradeService.postTrade(trade);
        tradeService.borrowTrade(lender.getId(), trade);

        List<Trade> trades = tradeService.listByBorrowerAndStatues(borrow.getId(), Collections.singleton(Trade.Status.ING));
        Assert.assertTrue(trades.size() == 1);
        Assert.assertTrue(trades.get(0).getAmount().doubleValue() == 100);
        Assert.assertTrue(trades.get(0).getBorrowerHash() != null);

        trades = tradeService.listByLenderAndStatues(lender.getId(), Collections.singleton(Trade.Status.ING));
        Assert.assertTrue(trades.size() == 1);
        Assert.assertTrue(trades.get(0).getAmount().doubleValue() == 100);

    }

    @Test(expected = Exception.class)
    public void test_borrow_trade_error() {
        Trade trade = new Trade();
        trade.setAmount(BigDecimal.valueOf(100));
        trade.setInterest(BigDecimal.ONE);
        trade.setBorrower(borrow.getId());
        trade.setStatus(Trade.Status.INIT);

        tradeService.postTrade(trade);
        tradeService.borrowTrade(borrow.getId(), trade);

    }

    @Test
    public void test_repay_trade() {
        Trade trade = new Trade();
        trade.setAmount(BigDecimal.valueOf(100));
        trade.setInterest(BigDecimal.ONE);
        trade.setBorrower(borrow.getId());
        trade.setStatus(Trade.Status.INIT);

        tradeService.postTrade(trade);
        tradeService.borrowTrade(lender.getId(), trade);
        tradeService.repayTrade(borrow.getId(), trade);

        List<Trade> trades = tradeService.listByBorrowerAndStatues(borrow.getId(), Collections.singleton(Trade.Status.COM));
        Assert.assertTrue(trades.size() == 1);
        Assert.assertTrue(trades.get(0).getBorrowerHash() != null);
        Assert.assertTrue(trades.get(0).getLenderHash() != null);

        trades = tradeService.listByLenderAndStatues(lender.getId(), Collections.singleton(Trade.Status.COM));
        Assert.assertTrue(trades.size() == 1);

    }

    @Test(expected = Exception.class)
    public void test_repay_trade_error() {
        Trade trade = new Trade();
        trade.setAmount(BigDecimal.valueOf(100));
        trade.setInterest(BigDecimal.ONE);
        trade.setBorrower(borrow.getId());
        trade.setStatus(Trade.Status.INIT);

        tradeService.postTrade(trade);
        tradeService.borrowTrade(lender.getId(), trade);
        tradeService.repayTrade(lender.getId(), trade);


    }
}
