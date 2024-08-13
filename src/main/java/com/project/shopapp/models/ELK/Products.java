package com.project.shopapp.models.ELK;

import com.fasterxml.jackson.annotation.JsonManagedReference;
import com.project.shopapp.models.Category;
import com.project.shopapp.models.ProductImage;
import jakarta.persistence.*;
import lombok.*;
import org.springframework.data.elasticsearch.annotations.Document;
import org.springframework.data.elasticsearch.annotations.Field;
import org.springframework.data.elasticsearch.annotations.FieldType;

import java.util.List;



@Document(indexName = "products_index")
@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class Products {
    @Id
    private Long id;

    @Field(type = FieldType.Text)
    private String name;

    @Field(type = FieldType.Float)
    private Float price;

    @Field(type = FieldType.Text, name = "thumbnail")
    private String thumbnail;

    @Field(name = "category_id")
    private Long categoryId;

    @Field(type = FieldType.Text, name = "description")
    private String description;

}
