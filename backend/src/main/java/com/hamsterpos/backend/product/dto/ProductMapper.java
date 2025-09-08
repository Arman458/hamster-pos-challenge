package com.hamsterpos.backend.product.dto;

import com.hamsterpos.backend.product.entity.Product;

public class ProductMapper {
    public static ProductResponseDto toDto(Product product) {
        return new ProductResponseDto(
                product.getId(),
                product.getName(),
                product.getPrice(),
                product.getStock()
        );
    }
}