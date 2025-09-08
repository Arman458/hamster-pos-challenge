package com.hamsterpos.backend.order.entity;


import com.hamsterpos.backend.user.entity.User;
import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "orders")
@Data
@NoArgsConstructor
public class Order {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Column(nullable = false)
    private LocalDateTime orderDate;

    @Column(nullable = false)
    private BigDecimal totalPrice;

    // cascade = CascadeType.ALL means if we save an Order, its OrderItems are also saved.
    // orphanRemoval = true means if we remove an OrderItem from this list, it gets deleted from the DB.
    @OneToMany(mappedBy = "order", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<OrderItem> items;
}