package org.blockchain.borrowing.repository;

import org.blockchain.borrowing.domain.Trade;
import org.springframework.boot.autoconfigure.AutoConfigureOrder;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;

import java.util.Collection;
import java.util.List;

/**
 *
 * Created by yann on 1/9/16.
 */
public interface TradeRepository extends CrudRepository<Trade, String> {

    List<Trade> findByBorrowerAndStatusInOrderByCreateTimeDesc(long borrower, Collection<Trade.Status> statues);

    List<Trade> findByLenderAndStatusInOrderByCreateTimeDesc(long lender, Collection<Trade.Status> statues);

    List<Trade> findByBorrowerInAndStatusInOrderByCreateTimeDesc(Collection<Long> friends, Collection<Trade.Status> statues);

    @Query(value = "select sum(amount) from Trade where borrower = :userId and status = 'COM'")
    Double summaryBorrow(@Param("userId") long userId);

    @Query(value = "select sum(amount) from Trade where lender = :userId and status = 'COM'")
    Double summaryLend(@Param("userId") long userId);

    @Query(value = "select count(0) from Trade where borrower = :userId and status = 'COM' and repayDate >= actualRepayDate")
    Long countRePayed(@Param("userId") long userId);

    @Query(value = "select count(0) from Trade where borrower = :userId and status = 'COM' and repayDate < actualRepayDate")
    Long countOverRePay(@Param("userId") long userId);


    @Query(value = "select sum(interest) from Trade where lender = :userId and status = 'COM'")
    Double summaryInCome(@Param("userId") long userId);

    @Query(value = "select sum(interest) from Trade where borrower = :userId and status = 'COM'")
    Double summaryOutCome(@Param("userId") long userId);
}
