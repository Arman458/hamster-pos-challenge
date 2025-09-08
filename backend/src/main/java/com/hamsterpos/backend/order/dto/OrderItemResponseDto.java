package com.hamsterpos.backend.order.dto;


import lombok.AllArgsConstructor;
import lombok.Data;

import java.math.BigDecimal;

@Data
@AllArgsConstructor
public class OrderItemResponseDto {
    private String productName;
    private int quantity;
    private BigDecimal price;
}