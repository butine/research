package org.blockchain.borrowing.domain;

import com.alibaba.fastjson.JSON;
import org.blockchain.borrowing.bitcoin.client.domain.Entry;

import java.math.BigDecimal;
import java.util.Date;

public class RecordTrade {

    private Long borrower;
    private Long lender;
    private BigDecimal amount;
    private BigDecimal interest;
    private Date repayDate;
    private Date actualRepayDate;

    public Date getActualRepayDate() {
        return actualRepayDate;
    }

    public void setActualRepayDate(Date actualRepayDate) {
        this.actualRepayDate = actualRepayDate;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public Long getBorrower() {
        return borrower;
    }

    public void setBorrower(Long borrower) {
        this.borrower = borrower;
    }

    public BigDecimal getInterest() {
        return interest;
    }

    public void setInterest(BigDecimal interest) {
        this.interest = interest;
    }

    public Long getLender() {
        return lender;
    }

    public void setLender(Long lender) {
        this.lender = lender;
    }

    public Date getRepayDate() {
        return repayDate;
    }

    public void setRepayDate(Date repayDate) {
        this.repayDate = repayDate;
    }

    public static RecordTrade fromTrade(Trade trade) {
        RecordTrade recordTrade = new RecordTrade();
        recordTrade.borrower = trade.getBorrower();
        recordTrade.lender = trade.getLender();
        recordTrade.amount = trade.getAmount();
        recordTrade.interest = trade.getInterest();
        recordTrade.repayDate = trade.getRepayDate();
        recordTrade.actualRepayDate = trade.getActualRepayDate();
        return recordTrade;
    }

    public static RecordTrade fromEntry(Entry entry) {
        return JSON.parseObject(entry.getContent(), RecordTrade.class);
    }
}
