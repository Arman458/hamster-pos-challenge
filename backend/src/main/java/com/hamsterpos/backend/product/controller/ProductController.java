package com.hamsterpos.backend.product.controller;

import com.hamsterpos.backend.product.dto.ProductMapper;
import com.hamsterpos.backend.product.dto.ProductResponseDto;
import com.hamsterpos.backend.product.entity.Product;
import com.hamsterpos.backend.product.service.ProductService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/products")
public class ProductController {
    private final ProductService service;

    public ProductController(ProductService service) {
        this.service = service;
    }

    @GetMapping
    public ResponseEntity<List<ProductResponseDto>> getAll() {
        List<ProductResponseDto> dtos = service.findAllProducts()
                .stream()
                .map(ProductMapper::toDto)
                .collect(Collectors.toList());
        return ResponseEntity.ok(dtos);
    }

    @PostMapping
    public ResponseEntity<ProductResponseDto> create(@RequestBody Product product) {
        Product createdProduct = service.addProduct(product);
        return new ResponseEntity<>(ProductMapper.toDto(createdProduct), HttpStatus.CREATED);
    }

    @GetMapping("/{id}")
    public ResponseEntity<ProductResponseDto> getById(@PathVariable Long id) {
        Product product = service.findProductById(id);
        return ResponseEntity.ok(ProductMapper.toDto(product));
    }

    @PutMapping("/{id}")
    public ResponseEntity<ProductResponseDto> update(@PathVariable Long id, @RequestBody Product product) {
        Product updatedProduct = service.updateProduct(id, product);
        return ResponseEntity.ok(ProductMapper.toDto(updatedProduct));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        boolean deleted = service.deleteProduct(id);
        return deleted ? ResponseEntity.noContent().build()
                : ResponseEntity.notFound().build();
    }
}