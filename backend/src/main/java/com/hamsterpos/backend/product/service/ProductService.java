package com.hamsterpos.backend.product.service;
import com.hamsterpos.backend.product.entity.Product;
import com.hamsterpos.backend.product.repository.ProductRepository;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.Optional;

@Service
public class ProductService {

    private final ProductRepository productRepository;


    public ProductService(ProductRepository productRepository) {
        this.productRepository = productRepository;
    }

    public List<Product> findAllProducts() {
        return productRepository.findAll(Sort.by(Sort.Direction.ASC, "id"));
    }

    public Product addProduct(Product product) {
        return productRepository.save(product);
    }

    public Optional<Product> findProductById(long id) {
        return productRepository.findById(id);
    }

    public Optional<Product> updateProduct(long id, Product updatedProduct) {
        return productRepository.findById(id).map(existing -> {
            existing.setName(updatedProduct.getName());
            existing.setPrice(updatedProduct.getPrice());
            existing.setStock(updatedProduct.getStock());
            return productRepository.save(existing);
        });
    }

    public boolean deleteProduct(long id) {
        if (productRepository.existsById(id)) {
            productRepository.deleteById(id);
            return true;
        }
        return false;
    }


}