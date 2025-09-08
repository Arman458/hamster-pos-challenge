package com.hamsterpos.backend.order.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Data
@AllArgsConstructor
public class OrderResponseDto {
    private Long id;
    private String userEmail;
    private LocalDateTime orderDate;
    private BigDecimal totalPrice;
    private List<OrderItemResponseDto> items;
}
