package com.project.shopapp.dtos;

import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.validation.constraints.Min;
import lombok.*;
import org.springframework.web.util.pattern.PathPattern;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class OrderDetailDTO {
    @JsonProperty("order_id")
    @Min(value = 1, message = "Order'id must be > 0")
    private Long orderId;

    @Min(value = 1, message = "Order'id must be > 0")
    @JsonProperty("product_id")
    private Long productId;

    @Min(value = 1, message = "Price must be > 0")
    private Float price;

    @JsonProperty("number_of_products")
    @Min(value = 1, message = "numberOfProducts must be >= 1")
    private int numberOfProducts;

    @JsonProperty("total_money")
    @Min(value = 1, message = "totalMoney must be >= 0")
    private Float totalMoney;

    private String color;
}
