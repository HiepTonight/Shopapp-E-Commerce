package com.project.shopapp.dtos;

import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.validation.constraints.NotEmpty;
import lombok.*;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class RefreshTokenDTO {
    @NotEmpty(message = "refreshToken is Required")
    @JsonProperty("refreshToken")
    private String refreshToken;
}
