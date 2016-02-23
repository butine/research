package org.blockchain.borrowing.service;

import org.blockchain.borrowing.domain.User;

/**
 * Cache~
 *
 * Created by pengchangguo on 16/1/10.
 */
abstract class Cache {

    /**
     * cache the data
     *
     * @param key key in cache
     * @param value value in cache
     * @param expire expire time
     */
    abstract void put(Object key, Object value, String expire);

    static Cache get() {
        //todo newInstance CacheImplement
        return new Cache() {

            @Override
            void put(Object key, Object value, String expire) {

            }
        };
    }
}
