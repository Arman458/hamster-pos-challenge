package com.hamsterpos.backend.order.dto;

import com.hamsterpos.backend.order.entity.Order;
import java.util.stream.Collectors;

public class OrderMapper {

    public static OrderResponseDto toDto(Order order) {
        return new OrderResponseDto(
                order.getId(),
                order.getUser().getEmail(),
                order.getOrderDate(),
                order.getTotalPrice(),
                order.getItems().stream()
                        .map(item -> new OrderItemResponseDto(
                                item.getProduct().getName(),
                                item.getQuantity(),
                                item.getPrice()
                        ))
                        .collect(Collectors.toList())
        );
    }
}