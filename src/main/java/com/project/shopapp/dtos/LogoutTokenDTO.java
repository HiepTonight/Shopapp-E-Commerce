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
public class LogoutTokenDTO {
    @NotEmpty(message = "Logout Token is Required")
    @JsonProperty("logoutToken")
    private String logoutToken;
}