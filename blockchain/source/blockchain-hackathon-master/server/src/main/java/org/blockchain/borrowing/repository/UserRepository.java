package org.blockchain.borrowing.repository;

import org.blockchain.borrowing.domain.User;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * Entity Dao
 * <p>
 * Created by pengchangguo on 16/1/9.
 */
@Repository
public interface UserRepository extends CrudRepository<User, Long> {

    User findByPhone(String phone);

    List<User> findByIdNot(long id);
}