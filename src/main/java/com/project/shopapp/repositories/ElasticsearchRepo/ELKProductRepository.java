package com.project.shopapp.repositories.ElasticsearchRepo;


import com.project.shopapp.models.ELK.Products;
import org.springframework.data.elasticsearch.repository.ElasticsearchRepository;

import java.util.List;

public interface ELKProductRepository extends ElasticsearchRepository<Products, Long> {
    List<Products> findByName(String name);
}
