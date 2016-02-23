package org.blockchain.borrowing.service;

import org.blockchain.borrowing.BorrowException;
import org.blockchain.borrowing.domain.User;
import org.blockchain.borrowing.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;

@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;

    /**
     * Create User Service
     *
     * @param user a user to be created
     * @return created User Object
     */
    public User registry(User user) {
        if (userRepository.findByPhone(user.getPhone()) != null) {
            throw new BorrowException("该手机号码已注册");
        }
        return userRepository.save(user);
    }

    /**
     * User Logon Service
     *
     * @param phone    user's phone
     * @param password user's password
     * @return the user object queried by user's phone
     */
    public User logon(String phone, String password) {
        User user = userRepository.findByPhone(phone);
        if (user == null) {
            throw new BorrowException("没有该用户");
        }
        if (!password.equalsIgnoreCase(user.getPassword())) {
            throw new BorrowException("密码不正确");
        }

        /* store the user's sign, expired time is 30h, keepAlive  */
        Cache.get().put(user.getSign(), System.currentTimeMillis(), "30h");
        return user;
    }

    /**
     * Find a User by user's id
     *
     * @param id user's id
     * @return user object queried by id
     */
    public User findById(Long id) {
        return userRepository.findOne(id);
    }

    /**
     * deduct amount
     *
     * @param user   current user
     * @param amount amount
     * @return deducted user
     */
    public User deduct(User user, BigDecimal amount) {
        User _user = userRepository.findOne(user.getId());
        if (_user.getAmount().subtract(amount).doubleValue() < 0) {
            throw new BorrowException("余额不足");
        }
        _user.setAmount(_user.getAmount().subtract(amount));
        return userRepository.save(_user);
    }

    /**
     * recharge amount
     *
     * @param user   current user
     * @param amount amount
     * @return recharged user
     */
    public User recharge(User user, BigDecimal amount) {
        User _user = userRepository.findOne(user.getId());
        _user.setAmount(_user.getAmount().add(amount));
        return userRepository.save(_user);
    }
}
