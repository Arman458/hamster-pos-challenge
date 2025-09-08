package com.hamsterpos.backend.order.repository;

import com.hamsterpos.backend.order.entity.Order;
import com.hamsterpos.backend.user.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface OrderRepository extends JpaRepository<Order, Long> {
    List<Order> findByUser(User user);
}