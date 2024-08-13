package com.project.shopapp.models;

import com.fasterxml.jackson.annotation.JsonManagedReference;
import jakarta.persistence.*;
import lombok.*;
import org.springframework.data.elasticsearch.annotations.Document;
import org.springframework.data.elasticsearch.annotations.Field;
import org.springframework.data.elasticsearch.annotations.FieldType;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@Entity
@Table(name = "products")
@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class Product extends BaseEntity{
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "name", nullable = false, length = 350)
    private String name;

    private Float price;

    @Column(name = "thumbnail", nullable = true, length = 300)
    private String thumbnail;

    @Column(name = "description", nullable = true)
    private String description;

    @ManyToOne
    @JoinColumn(name = "category_id")
    private Category category;

    @JsonManagedReference
    @OneToMany(mappedBy = "product")
    private List<ProductImage> productImages ;

}
