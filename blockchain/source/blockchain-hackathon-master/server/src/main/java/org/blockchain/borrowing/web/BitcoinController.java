package org.blockchain.borrowing.web;

import org.blockchain.borrowing.bitcoin.client.BitcoinClient;
import org.blockchain.borrowing.domain.Trade;
import org.blockchain.borrowing.service.TradeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("api/")
public class BitcoinController {

    @Autowired
    private BitcoinClient bitcoinClient;

    @Autowired
    private TradeService tradeService;

    @RequestMapping(value = "trade-by-hash", method = RequestMethod.GET)
    public Trade tradeByHash(@RequestParam(value = "hash", required = true) String hash) {
        Trade trade = Trade.fromEntry(bitcoinClient.findByHash(hash).toReadable());

        return tradeService.updateUser.apply(trade);
    }

}
