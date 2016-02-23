package org.blockchain.borrowing.service;

import com.google.common.base.Function;
import com.google.common.collect.FluentIterable;
import org.apache.commons.lang3.Validate;
import org.apache.log4j.Logger;
import org.blockchain.borrowing.bitcoin.client.BitcoinClient;
import org.blockchain.borrowing.bitcoin.client.domain.Entry;
import org.blockchain.borrowing.bitcoin.client.domain.EntryCommit;
import org.blockchain.borrowing.domain.Trade;
import org.blockchain.borrowing.domain.User;
import org.blockchain.borrowing.repository.TradeRepository;
import org.blockchain.borrowing.repository.UserRepository;
import org.blockchain.borrowing.utils.ValidateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.*;

@Service
public class TradeService {

    private static final Logger LOG = Logger.getLogger(TradeService.class);

    @Autowired
    private TradeRepository tradeRepository;

    @Autowired
    private UserService userService;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private BitcoinClient bitcoinClient;

    public Trade findOne(String tranNo) {
        return tradeRepository.findOne(tranNo);
    }

    public List<Trade> listByBorrowerAndStatues(long userId, Collection<Trade.Status> statues) {

        List<Trade> trades = tradeRepository.findByBorrowerAndStatusInOrderByCreateTimeDesc(userId, statues);
        return FluentIterable.from(trades).transform(updateUser).toList();
    }

    public List<Trade> listByLenderAndStatues(long userId, Collection<Trade.Status> statues) {
        List<Trade> trades = tradeRepository.findByLenderAndStatusInOrderByCreateTimeDesc(userId, statues);
        return FluentIterable.from(trades).transform(updateUser).toList();
    }

    public List<Trade> listByFriends(long userId) {
        List<User> others = userRepository.findByIdNot(userId);
        List<Long> otherIds = new ArrayList<>();
        for (User u : others) {
            otherIds.add(u.getId());
        }

        List<Trade> trades = tradeRepository.findByBorrowerInAndStatusInOrderByCreateTimeDesc(otherIds, Collections.singleton(Trade.Status.INIT));
        return FluentIterable.from(trades).transform(updateUser).toList();
    }

    /**
     * post a trade
     *
     * @param trade trade object data
     * @return saved trade object
     */
    public Trade postTrade(Trade trade) {
        ValidateUtils.notNulls(trade.getBorrower(), trade.getAmount(), trade.getInterest());

        trade.setTradeNo(UUID.randomUUID().toString());
        trade.setCreateTime(new Date());

        trade = tradeRepository.save(trade);
        return trade;
    }

    /**
     * borrow a trade
     *
     * @param userId lender id
     * @param trade  trade object data
     * @return saved trade object
     */
    public Trade borrowTrade(long userId, Trade trade) {
        LOG.info(String.format("borrow trade of trade %s, user id %s", trade, userId));
        User currentUser = userService.findById(userId);
        User borrow = userService.findById(trade.getBorrower());
        Validate.isTrue(userId != trade.getBorrower());
//        Validate.isTrue(trade.getStatus().equals(Trade.Status.INIT));

        userService.deduct(currentUser, trade.getAmount());
        userService.recharge(borrow, trade.getAmount());

        trade.setLender(currentUser.getId());
        trade.setStatus(Trade.Status.ING);

        EntryCommit entryCommit = bitcoinClient.composeCommit(Entry.fromTrade(trade));
        trade.setBorrowerHash(entryCommit.getHash());
        trade = tradeRepository.save(trade);

        return trade;
    }

    /**
     * repay a trade
     *
     * @param userId borrow id
     * @param trade  trade
     * @return rePayed trade object
     */
    public Trade repayTrade(long userId, Trade trade) {
        LOG.info(String.format("repay trade of %s", trade));
        Validate.isTrue(userId == trade.getBorrower());
        ValidateUtils.isSame(trade, Trade.fromEntry(bitcoinClient.findByHash(trade.getBorrowerHash()).toReadable()));
//        Validate.isTrue(trade.getStatus().equals(Trade.Status.ING));

        User borrowUser = userService.findById(trade.getBorrower());
        User lenderUser = userService.findById(trade.getLender());
        BigDecimal money = trade.getAmount().add(trade.getInterest());

        userService.recharge(lenderUser, money);
        userService.deduct(borrowUser, money);

        trade.setStatus(Trade.Status.COM);
        trade.setActualRepayDate(new Date());

        EntryCommit entryCommit = bitcoinClient.composeCommit(Entry.fromTrade(trade));
        trade.setLenderHash(entryCommit.getHash());
        trade = tradeRepository.save(trade);

        return trade;
    }

    public Function<Trade, Trade> updateUser = new Function<Trade, Trade>() {
        @Override
        public Trade apply(Trade trade) {
            User borrow = userRepository.findOne(trade.getBorrower());
            trade.setBorrowerUser(borrow);
            if (trade.getLender() != null) {
                User lender = userRepository.findOne(trade.getLender());
                trade.setLenderUser(lender);
            }

            return trade;
        }
    };

    public Double summaryBorrow(long userId) {
        Double d = tradeRepository.summaryBorrow(userId);
        return d == null ? 0D : d;
    }

    public Double summaryLend(long userId) {
        Double d = tradeRepository.summaryLend(userId);
        return d == null ? 0D : d;
    }

    public Double summaryCredit(long userId) {
        Long rePayed = tradeRepository.countRePayed(userId);
        Long overRePayed = tradeRepository.countOverRePay(userId);
        Double defaultCreditScore = Trade.DEFAULT_CREDIT_SCORE;
        return new BigDecimal(defaultCreditScore).add(new BigDecimal(rePayed)).subtract(new BigDecimal(overRePayed)).doubleValue();
    }

    public Double summaryInCome(long userId) {
        Double d = tradeRepository.summaryInCome(userId);
        return d == null ? 0D : d;
    }

    public Double summaryOutCome(long userId) {
        Double d = tradeRepository.summaryOutCome(userId);
        return d == null ? 0D : d;
    }
}
