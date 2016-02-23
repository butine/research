package org.blockchain.borrowing.domain;

import org.blockchain.borrowing.bitcoin.client.domain.Entry;

import javax.persistence.*;
import java.math.BigDecimal;
import java.util.Date;
import java.util.UUID;

/**
 * 交易记录
 *
 * Created by pengchangguo on 16/1/9.
 */
@Entity
@Table(name = "b_trade")
public class Trade {

    public static final Double DEFAULT_CREDIT_SCORE = 100D;
    /**
     * 交易编号
     */
    @Id
    @Column(name = "trade_no")
    private String tradeNo = UUID.randomUUID().toString();

    /**
     * 借款区块Id
     */
    @Column(name = "borrower_hash")
    private String borrowerHash;

    /**
     * 还款区块Id
     */
    @Column(name = "lender_hash")
    private String lenderHash;


    /**
     * 借款人
     */
    @Column(name = "borrower")
    private long borrower;

    @Transient
    private User borrowerUser;

    /**
     * 放款人
     */
    @Column(name = "lender")
    private Long lender;

    @Transient
    private User lenderUser;

    /**
     * 金额
     */
    @Column(name = "amount")
    private BigDecimal amount;

    /**
     * 利息
     */
    @Column(name = "interest")
    private BigDecimal interest;

    /**
     * 状态
     */
    @Column(name = "status")
    @Enumerated(EnumType.STRING)
    private Status status = Status.INIT;

    /**
     * 还款时间
     */
    @Column(name = "repay_date")
    private Date repayDate;

    /**
     * 创建时间
     */
    @Column(name = "create_time")
    private Date createTime = new Date();

    /**
     * 最近修改时间
     */
    @Column(name = "last_time")
    private Date lastTime = new Date();

    @Column(name = "actual_repay_date")
    private Date actualRepayDate;

    public enum Status {

        /* 初始状态 */
        INIT,

        /* 进行中(借款成功) */
        ING,

        /* 完成(还款成功) */
        COM,

        /* 已失效 */
        DON
    }

    public String getTradeNo() {
        return tradeNo;
    }

    public void setTradeNo(String tradeNo) {
        this.tradeNo = tradeNo;
    }

    public String getBorrowerHash() {
        return borrowerHash;
    }

    public void setBorrowerHash(String borrowerHash) {
        this.borrowerHash = borrowerHash;
    }

    public String getLenderHash() {
        return lenderHash;
    }

    public void setLenderHash(String lenderHash) {
        this.lenderHash = lenderHash;
    }

    public long getBorrower() {
        return borrower;
    }

    public void setBorrower(long borrower) {
        this.borrower = borrower;
    }

    public Long getLender() {
        return lender;
    }

    public void setLender(Long lender) {
        this.lender = lender;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public BigDecimal getInterest() {
        return interest;
    }

    public void setInterest(BigDecimal interest) {
        this.interest = interest;
    }

    public Status getStatus() {
        return status;
    }

    public void setStatus(Status status) {
        this.status = status;
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    public Date getLastTime() {
        return lastTime;
    }

    public void setLastTime(Date lastTime) {
        this.lastTime = lastTime;
    }

    public Date getRepayDate() {
        return repayDate;
    }

    public void setRepayDate(Date repayDate) {
        this.repayDate = repayDate;
    }

    public User getLenderUser() {
        return lenderUser;
    }

    public void setLenderUser(User lenderUser) {
        this.lenderUser = lenderUser;
    }

    public User getBorrowerUser() {
        return borrowerUser;
    }

    public void setBorrowerUser(User borrowerUser) {
        this.borrowerUser = borrowerUser;
    }

    public Date getActualRepayDate() {
        return actualRepayDate;
    }

    public void setActualRepayDate(Date actualRepayDate) {
        this.actualRepayDate = actualRepayDate;
    }

    @PrePersist
    public void prePersist() {
        this.createTime = new Date();
        this.lastTime = new Date();
    }

    @PreUpdate
    public void perUpdate() {
        this.lastTime = new Date();
    }

    @Override
    public String toString() {
        return "Trade{" +
                "amount=" + amount +
                ", tradeNo='" + tradeNo + '\'' +
                ", borrowerHash='" + borrowerHash + '\'' +
                ", lenderHash='" + lenderHash + '\'' +
                ", borrower=" + borrower +
                ", lender=" + lender +
                ", interest=" + interest +
                ", status=" + status +
                ", repayDate=" + repayDate +
                ", createTime=" + createTime +
                ", lastTime=" + lastTime +
                '}';
    }

    public static Trade fromEntry(Entry entry) {
        Trade trade = fromRecordTrade(RecordTrade.fromEntry(entry));
        trade.status = Status.valueOf(entry.getExtIDs().get(1));
        return trade;
    }

    public static Trade fromRecordTrade(RecordTrade recordTrade) {
        Trade trade = new Trade();
        trade.amount = recordTrade.getAmount();
        trade.borrower = recordTrade.getBorrower();
        trade.lender = recordTrade.getLender();
        trade.interest = recordTrade.getInterest();
        trade.repayDate = recordTrade.getRepayDate();
        trade.actualRepayDate = recordTrade.getActualRepayDate();

        return trade;
    }
}

