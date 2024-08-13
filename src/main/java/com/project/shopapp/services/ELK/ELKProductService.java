package com.project.shopapp.services.ELK;

import co.elastic.clients.elasticsearch.ElasticsearchClient;
import co.elastic.clients.elasticsearch._types.query_dsl.MatchAllQuery;
import co.elastic.clients.elasticsearch._types.query_dsl.MatchQuery;
import co.elastic.clients.elasticsearch._types.query_dsl.Query;
import co.elastic.clients.elasticsearch._types.query_dsl.QueryBuilders;
import co.elastic.clients.elasticsearch.core.SearchRequest;
import co.elastic.clients.elasticsearch.core.SearchResponse;
import co.elastic.clients.elasticsearch.core.search.Hit;
import com.project.shopapp.dtos.ProductDTO;
import com.project.shopapp.models.ELK.Products;
import com.project.shopapp.models.Product;
import com.project.shopapp.repositories.ElasticsearchRepo.ELKProductRepository;
import com.project.shopapp.responses.ProductResponse;
import com.project.shopapp.utils.ElasticSearchUtils.ElasticSearchUtil;
import lombok.RequiredArgsConstructor;
import lombok.val;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.function.Supplier;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ELKProductService implements ELKIProductService{
    private final ELKProductRepository elkProductRepository;
    private final ElasticsearchClient elasticsearchClient;
    @Override
    public Products createProduct(Product product) throws Exception {
        Products newProduct = Products.builder()
                .name(product.getName())
                .description(product.getDescription())
                .price(product.getPrice())
                .categoryId(product.getId())
                .thumbnail(product.getThumbnail())
                .build();
        return elkProductRepository.save(newProduct);
    }

    @Override
    public List<Products> searchByContent(String keyWord) throws Exception {
//        MatchQuery matchQuery = new MatchQuery.Builder().field("name").query(keyWord).build();
//        SearchRequest searchRequest = new SearchRequest.Builder()
//                .index("products_index")
//                .query(q->q.match(matchQuery))
//                .build();
//        SearchResponse<Products> searchResponse = elasticsearchClient.search(searchRequest, Products.class);
//        return searchResponse.hits().hits().stream()
//                .map(Hit::source)
//                .collect(Collectors.toList());
        return elkProductRepository.findByName(keyWord);
    }


    @Override
    public Iterable<Products> getAllProducts() throws Exception {
        return elkProductRepository.findAll();
    }

    @Override
    public void deleteProduct(Long id) {

    }

    @Override
    public Page<ProductResponse> getAllProducts(PageRequest pageRequest, String keyword, Long categoryId) {
        return null;
    }
}
