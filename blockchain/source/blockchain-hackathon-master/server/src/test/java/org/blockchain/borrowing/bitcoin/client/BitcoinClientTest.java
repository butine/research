package org.blockchain.borrowing.bitcoin.client;

import org.blockchain.borrowing.Application;
import org.blockchain.borrowing.bitcoin.client.domain.Entry;
import org.blockchain.borrowing.bitcoin.client.domain.EntryCommit;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.IntegrationTest;
import org.springframework.boot.test.SpringApplicationConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.util.Arrays;

@RunWith(SpringJUnit4ClassRunner.class)
@SpringApplicationConfiguration(classes = Application.class)
@IntegrationTest
public class BitcoinClientTest {

    @Autowired
    private BitcoinClient bitcoinClient;


    @Test
    public void test_query() {
        bitcoinClient.findByHash("8d42262f5b176a59f34bb7b7497bf7710a0e95a410a72756886087160ed78278");
    }

    @Test
    public void save_block() {
        Entry entry = new Entry();
        entry.setExtIDs(Arrays.asList("Hello", "chain"));
        entry.setContent("hello, block chain");
        EntryCommit entryCommit = bitcoinClient.blockCommit(entry);

        bitcoinClient.commit(entryCommit);
        bitcoinClient.reveal(entryCommit);
        String hash = entryCommit.getHash();

        bitcoinClient.findByHash(hash);
    }

}



