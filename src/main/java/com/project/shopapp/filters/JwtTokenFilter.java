package com.project.shopapp.filters;

import com.project.shopapp.components.JwtTokenUtil;
import com.project.shopapp.models.Token;
import com.project.shopapp.models.User;
import com.project.shopapp.repositories.TokenRepository;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.NonNull;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.util.Pair;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.*;

import java.io.IOException;
import java.lang.reflect.Array;
import java.util.Arrays;
import java.util.List;

@Component
@RequiredArgsConstructor
public class JwtTokenFilter extends OncePerRequestFilter {
    @Value("${api.prefix}")
    private String apiPrefix;
    private final UserDetailsService userDetailsService;
    private final JwtTokenUtil jwtTokenUtil;
    private final TokenRepository tokenRepository;

    @Override
    protected void doFilterInternal(@NonNull HttpServletRequest request,
                                    @NonNull HttpServletResponse response,
                                    @NonNull FilterChain filterChain)
            throws ServletException, IOException {
        try {
            if (isBypassToken(request)) {
                filterChain.doFilter(request, response);
                return;
            }

            final String authHeader = request.getHeader("Authorization");

            if (authHeader == null || !authHeader.startsWith("Bearer ")) {
                response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Unauthorized");
                return;
            }
            final String token = authHeader.substring(7);

            if (jwtTokenUtil.isTokenRevoked(token)) {
                response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Unauthorized");
                return;
            }

            final String phoneNumber = jwtTokenUtil.extractPhoneNumber(token);
            if (phoneNumber != null && SecurityContextHolder.getContext().getAuthentication() == null) {
                User userDetails = (User) userDetailsService.loadUserByUsername(phoneNumber);
                if (jwtTokenUtil.validateToken(token, userDetails)) {
                    UsernamePasswordAuthenticationToken authenticationToken = new UsernamePasswordAuthenticationToken(
                            userDetails,
                            null,
                            userDetails.getAuthorities()
                    );
                    authenticationToken.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
                    SecurityContextHolder.getContext().setAuthentication(authenticationToken);
                }
            }



            filterChain.doFilter(request, response);
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Unauthorized");
        }
        //filterChain.doFilter(request, response); //enable bypass
    }

    private boolean isBypassToken(@NonNull HttpServletRequest request) {
        final List<Pair<String, String>> bypassTokens = Arrays.asList(

                Pair.of(String.format("%s/roles", apiPrefix),"GET"),
                Pair.of(String.format("%s/products", apiPrefix),"GET"),
                Pair.of(String.format("%s/products/search", apiPrefix),"GET"),
//                Pair.of(String.format("%s/orders", apiPrefix),"GET"),
                Pair.of(String.format("%s/categories", apiPrefix),"GET"),
                Pair.of(String.format("%s/users/register", apiPrefix),"POST"),
                Pair.of(String.format("%s/users/login", apiPrefix),"POST"),
                Pair.of(String.format("%s/users/refreshToken", apiPrefix),"POST"),

                //Swagger
                Pair.of("/api-docs", "GET"),
                Pair.of("/api-docs/**", "GET"),
                Pair.of("/swagger-resources", "GET"),
                Pair.of("/swagger-resources/**", "GET"),
                Pair.of("/configuration/ui", "GET"),
                Pair.of("/configuration/security", "GET"),
                Pair.of("/swagger-ui/**", "GET"),
                Pair.of("/swagger-ui.html", "GET"),
                Pair.of("/swagger-ui/index.html", "GET"),

                Pair.of("/swagger-ui/index.html","GET"),Pair.of("/swagger-ui.html","GET"),
                Pair.of("/swagger-ui/swagger-ui-bundle.js","GET"),
                Pair.of("/swagger-ui/swagger-initializer.js","GET"),
                Pair.of("/swagger-ui/swagger-ui-standalone-preset.js","GET"),
                Pair.of("/swagger-ui/swagger-ui-bundle.js","GET"),
                Pair.of("/swagger-ui/index.css","GET"),
                Pair.of("/swagger-ui/index.css","GET"),
                Pair.of("/swagger-ui/swagger-ui.css","GET"),
                Pair.of("/v3/api-docs","GET")

        );

        String requestPath = request.getServletPath();
        String requestMethod = request.getMethod();

        if (requestPath.equals(String.format("%s/orders", apiPrefix)) && requestMethod.equals("GET")) {
            return true;
        }

        for (Pair<String ,String> bypassToken: bypassTokens) {
            if (request.getServletPath().contains(bypassToken.getFirst()) &&
                    request.getMethod().equals(bypassToken.getSecond())) {
                return true;
            }
        }
        return false;
    }
}
