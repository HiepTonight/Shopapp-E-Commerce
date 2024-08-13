package com.project.shopapp.services.ELK;

import com.project.shopapp.dtos.ProductDTO;
import com.project.shopapp.models.ELK.Products;
import com.project.shopapp.models.Product;
import com.project.shopapp.responses.ProductResponse;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;

import java.util.List;

public interface ELKIProductService {
    Products createProduct(Product product) throws Exception;

    List<Products> searchByContent(String keyWord) throws Exception;

    Iterable<Products> getAllProducts() throws Exception;

    void deleteProduct(Long id);

    Page<ProductResponse> getAllProducts(PageRequest pageRequest, String keyword, Long categoryId);
}
