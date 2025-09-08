package com.hamsterpos.backend.order.entity;


import com.hamsterpos.backend.product.entity.Product;
import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Entity
@Table(name = "order_items")
@Data
@NoArgsConstructor
public class OrderItem {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "order_id", nullable = false)
    private Order order;

    @ManyToOne
    @JoinColumn(name = "product_id", nullable = false)
    private Product product;

    @Column(nullable = false)
    private Integer quantity;

    // We store the price here to capture the price at the time of purchase.
    // This prevents historical orders from changing if the product price is updated later.
    @Column(nullable = false)
    private BigDecimal price;
}