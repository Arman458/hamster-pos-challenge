package com.hamsterpos.backend.product.service;
import com.hamsterpos.backend.exception.ResourceNotFoundException;
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

    public Product findProductById(Long id) {
        return productRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Product not found with ID: " + id));
    }

    // CHANGE 2: The return type is now Product, not Optional<Product>
    public Product updateProduct(Long id, Product updatedProduct) {
        Product existing = productRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Cannot update. Product not found with ID: " + id));

        existing.setName(updatedProduct.getName());
        existing.setPrice(updatedProduct.getPrice());
        existing.setStock(updatedProduct.getStock());
        return productRepository.save(existing);
    }

    public boolean deleteProduct(long id) {
        if (productRepository.existsById(id)) {
            productRepository.deleteById(id);
            return true;
        }
        return false;
    }

    public List<Product> getLowStockProducts() {
        return productRepository.findByStockLessThan(5);
    }


}