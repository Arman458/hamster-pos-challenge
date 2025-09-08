package com.hamsterpos.backend.admin.controller;

import com.hamsterpos.backend.order.dto.OrderMapper;
import com.hamsterpos.backend.order.dto.OrderResponseDto;
import com.hamsterpos.backend.order.entity.Order;
import com.hamsterpos.backend.order.service.OrderService;
import com.hamsterpos.backend.product.dto.ProductMapper;
import com.hamsterpos.backend.product.dto.ProductResponseDto;
import com.hamsterpos.backend.product.entity.Product;
import com.hamsterpos.backend.product.service.ProductService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/admin")
@RequiredArgsConstructor
public class AdminController {

    private final ProductService productService;
    private final OrderService orderService;

    @GetMapping("/low-stock")
    public ResponseEntity<List<ProductResponseDto>> getLowStockItems() {
        List<Product> lowStockProducts = productService.getLowStockProducts();
        List<ProductResponseDto> dtoList = lowStockProducts.stream()
                .map(ProductMapper::toDto)
                .collect(Collectors.toList());
        return ResponseEntity.ok(dtoList);
    }

    @GetMapping("/orders")
    public ResponseEntity<List<OrderResponseDto>> getAllOrders() {
        List<Order> orders = orderService.getAllOrders();
        List<OrderResponseDto> dtoList = orders.stream()
                .map(OrderMapper::toDto)
                .collect(Collectors.toList());
        return ResponseEntity.ok(dtoList);
    }
}