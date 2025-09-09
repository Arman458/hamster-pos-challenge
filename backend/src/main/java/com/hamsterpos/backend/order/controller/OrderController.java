package com.hamsterpos.backend.order.controller;

import com.hamsterpos.backend.order.dto.OrderMapper;
import com.hamsterpos.backend.order.dto.OrderRequestDto;
import com.hamsterpos.backend.order.dto.OrderResponseDto;
import com.hamsterpos.backend.order.dto.OrderItemResponseDto;
import com.hamsterpos.backend.order.entity.Order;
import com.hamsterpos.backend.order.service.OrderService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/orders")
@RequiredArgsConstructor
public class OrderController {

    private final OrderService orderService;

    @PostMapping
    public ResponseEntity<OrderResponseDto> placeOrder(
            @RequestBody OrderRequestDto orderRequestDto,
            @AuthenticationPrincipal UserDetails userDetails
    ) {
        Order savedOrder = orderService.placeOrder(orderRequestDto, userDetails.getUsername());

        OrderResponseDto dto = OrderMapper.toDto(savedOrder);

        return ResponseEntity.status(HttpStatus.CREATED).body(dto);
    }

    @GetMapping("/me")
    public ResponseEntity<List<OrderResponseDto>> getMyOrders(
            @AuthenticationPrincipal UserDetails userDetails
    ) {
        List<Order> orders = orderService.findMyOrders(userDetails.getUsername());

        List<OrderResponseDto> dtoList = orders.stream()
                .map(OrderMapper::toDto)
                .collect(Collectors.toList());

        return ResponseEntity.ok(dtoList);
    }
}
