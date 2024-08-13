package com.project.shopapp.responses;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.*;

import java.util.List;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class LoginResponse {
    @JsonProperty("message")
    private String message;

    @JsonProperty("id")
    private Long id;

    @JsonProperty("roles")
    private List<String> roles;

    @JsonProperty("username")
    private String userName;

    @JsonProperty("token")
    private String token;

    @JsonProperty("refreshToken")
    private String refreshToken;

    @JsonProperty("tokenType")
    private String tokenType;


}
