package org.blockchain.borrowing.bitcoin.client;

import com.alibaba.fastjson.JSON;
import com.squareup.okhttp.*;
import org.apache.log4j.Logger;
import org.blockchain.borrowing.bitcoin.client.domain.Entry;
import org.blockchain.borrowing.bitcoin.client.domain.EntryCommit;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.io.IOException;

@Component
public class BitcoinClient {

    @Value("${blockchain.chain.id}")
    private String CHAIN_ID;
    @Value("${blockchain.api}")
    private String API_URL;

    private static final Logger LOG = Logger.getLogger(BitcoinClient.class);
    private final OkHttpClient client = new OkHttpClient();
    private static final MediaType JSON_MEDIA = MediaType.parse("application/json; charset=utf-8");

    public EntryCommit composeCommit(Entry entry) {
        EntryCommit entryCommit = blockCommit(entry);
        commit(entryCommit);
        reveal(entryCommit);

        return entryCommit;
    }


    public EntryCommit blockCommit(Entry entry) {
        final String BLOCK_COMMIT = API_URL + ":8089/v1/compose-entry-submit/zeros";
        entry.setChainID(CHAIN_ID);

        RequestBody requestBody = RequestBody.create(JSON_MEDIA, JSON.toJSON(entry).toString());
        Request request = new Request.Builder()
                .url(BLOCK_COMMIT)
                .post(requestBody)
                .build();
        try {
            Response response = client.newCall(request).execute();

            return JSON.parseObject(response.body().string(), EntryCommit.class);
        } catch (IOException e) {
            LOG.error("can't get response of " + BLOCK_COMMIT);
        }

        throw new RuntimeException("can't block commit");
    }

    public void commit(EntryCommit entryCommit) {
        final String COMMIT_URL = API_URL + ":8088/v1/commit-entry";
        RequestBody requestBody = RequestBody.create(JSON_MEDIA, JSON.toJSON(entryCommit.getEntryCommit()).toString());
        Request request = new Request.Builder()
                .url(COMMIT_URL)
                .post(requestBody)
                .build();

        try {
            Response response = client.newCall(request).execute();
            LOG.info(response.code());
        } catch (IOException e) {
            LOG.error("can't get response of " + COMMIT_URL);
        }
    }

    public void reveal(EntryCommit entryCommit) {
        final String REVEAL_URL = API_URL + ":8088/v1/reveal-entry";
        RequestBody requestBody = RequestBody.create(JSON_MEDIA, JSON.toJSON(entryCommit.getEntryReveal()).toString());
        Request request = new Request.Builder()
                .url(REVEAL_URL)
                .post(requestBody)
                .build();

        try {
            Response response = client.newCall(request).execute();
            LOG.info(response.code());
        } catch (IOException e) {
            LOG.error("can't get response of " + REVEAL_URL);
        }
    }

    public Entry findByHash(String hash) {
        final String FIND_URL = API_URL + ":8088/v1/entry-by-hash/";
        Integer tryTimes = 3;

        Request request = new Request.Builder()
                .url(FIND_URL + hash)
                .get()
                .build();

        while (tryTimes > 0) {
            try {
                Response response = client.newCall(request).execute();

                return JSON.parseObject(response.body().string(), Entry.class);
            } catch (IOException e) {
                LOG.error("can't get response of " + FIND_URL);
                tryTimes--;
            }
        }

        throw new RuntimeException("can't find entry by hash");
    }
}
