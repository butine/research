package org.blockchain.borrowing.service;

import org.blockchain.borrowing.Application;
import org.blockchain.borrowing.domain.User;
import org.blockchain.borrowing.repository.UserRepository;
import org.junit.After;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.IntegrationTest;
import org.springframework.boot.test.SpringApplicationConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.math.BigDecimal;

/**
 *
 * Created by pengchangguo on 16/1/9.
 */
@RunWith(SpringJUnit4ClassRunner.class)
@SpringApplicationConfiguration(classes = Application.class)
@IntegrationTest
public class UserServiceTest {

    @Autowired
    private UserService userService;

    @Autowired
    private UserRepository userRepository;

    private User user;

    @Before
    public void before() {
        user = new User();
        user.setName("pcg");
        user.setPassword("123456");
        user.setPhone("13000000000");
    }

    @After
    public void after() {
        if (user.getId() != null) userRepository.delete(user.getId());
        user = null;
    }

    @Test
    public void registry() {
        Assert.assertNotNull(userService.registry(user));
    }

    @Test
    public void logon() {
        String phone = System.currentTimeMillis() + "";
        user.setPhone(phone);
        user.setPassword(phone);
        userRepository.save(user);
        Assert.assertNotNull(userService.logon(phone, user.getPassword()));
    }

    @Test
    public void findById() {
        user = userRepository.save(user);
        Assert.assertNotNull(userService.findById(user.getId()));
    }

    @Test
    public void deduct() {
        user.setAmount(new BigDecimal(100));
        user = userRepository.save(user);
        User _user = userService.deduct(user, new BigDecimal(10));
        Assert.assertEquals(_user.getAmount().subtract(new BigDecimal(90)), new BigDecimal(0).setScale(2, BigDecimal.ROUND_DOWN));
    }

    @Test
    public void recharge() {
        user.setAmount(new BigDecimal(100));
        user = userRepository.save(user);
        User _user = userService.recharge(user, new BigDecimal(10));
        Assert.assertEquals(_user.getAmount().subtract(new BigDecimal(110)), new BigDecimal(0).setScale(2, BigDecimal.ROUND_DOWN));
    }

}
