package com.hamsterpos.backend.order.service;

import com.hamsterpos.backend.exception.InsufficientStockException;
import com.hamsterpos.backend.exception.ResourceNotFoundException;
import com.hamsterpos.backend.order.dto.OrderRequestDto;
import com.hamsterpos.backend.order.entity.Order;
import com.hamsterpos.backend.order.entity.OrderItem;
import com.hamsterpos.backend.order.repository.OrderRepository;
import com.hamsterpos.backend.product.entity.Product;
import com.hamsterpos.backend.product.repository.ProductRepository;
import com.hamsterpos.backend.user.entity.User;
import com.hamsterpos.backend.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
public class OrderService {

    private final OrderRepository orderRepository;
    private final ProductRepository productRepository;
    private final UserRepository userRepository;

    @Transactional
    public Order placeOrder(OrderRequestDto orderRequestDto, String userEmail) {
        User user = userRepository.findByEmail(userEmail)
                .orElseThrow(() -> new ResourceNotFoundException("User not found with email: " + userEmail));

        Order order = new Order();
        order.setUser(user);
        order.setOrderDate(LocalDateTime.now());

        List<OrderItem> orderItems = new ArrayList<>();
        BigDecimal total = BigDecimal.ZERO;

        for (var itemDto : orderRequestDto.getItems()) {
            Product product = productRepository.findById(itemDto.getProductId())
                    .orElseThrow(() -> new ResourceNotFoundException("Product not found with ID: " + itemDto.getProductId()));

            if (product.getStock() < itemDto.getQuantity()) {
                throw new InsufficientStockException("Insufficient stock for product: " + product.getName());
            }

            product.setStock(product.getStock() - itemDto.getQuantity());

            OrderItem orderItem = new OrderItem();
            orderItem.setOrder(order);
            orderItem.setProduct(product);
            orderItem.setQuantity(itemDto.getQuantity());
            orderItem.setPrice(product.getPrice());
            orderItems.add(orderItem);

            total = total.add(product.getPrice().multiply(BigDecimal.valueOf(itemDto.getQuantity())));
        }

        order.setItems(orderItems);
        order.setTotalPrice(total);
        return orderRepository.save(order);
    }

    public List<Order> findMyOrders(String userEmail) {
        User user = userRepository.findByEmail(userEmail)
                .orElseThrow(() -> new RuntimeException("User not found"));
        return orderRepository.findByUser(user);
    }
    public List<Order> getAllOrders() {
        return orderRepository.findAll();
    }

}