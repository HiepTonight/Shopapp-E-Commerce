package com.project.shopapp.services.Token;

import com.project.shopapp.components.JwtTokenUtil;
import com.project.shopapp.exceptions.ExpiredTokenException;
import com.project.shopapp.models.Token;
import com.project.shopapp.models.User;
import com.project.shopapp.repositories.TokenRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.Date;
import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class TokenService implements ITokenService {
    private static final int MAX_TOKEN = 3;

    private final JwtTokenUtil jwtTokenUtil;
    private final AuthenticationManager authenticationManager;

    @Value("${jwt.expiration-refresh-token}")
    private int expirationRefreshToken;

    private final TokenRepository tokenRepository;
    @Transactional
    @Override
    public Token addToken(User user, String token, boolean isMobileDevice) {
        List<Token> userTokens = tokenRepository.findByUser(user);
        int tokenCount = userTokens.size();
        if (tokenCount >= MAX_TOKEN) {
            boolean hasNonMobileToken = !userTokens.stream().allMatch(Token::isMobile);
            Token tokenToDelete;
            if (hasNonMobileToken) {
                tokenToDelete = userTokens.stream()
                        .filter(userToken -> !userToken.isMobile())
                        .findFirst()
                        .orElse(userTokens.get(0));
            } else {
                tokenToDelete = userTokens.get(0);
            }
            tokenRepository.delete(tokenToDelete);
        }
        long expirationTime = expirationRefreshToken;
        LocalDateTime expirationDateTime = LocalDateTime.now().plusSeconds(expirationTime);

        Token newtoken = Token.builder()
                .user(user)
                .token(token)
                .revoked(false)
                .expired(false)
                .tokenType("Bearer")
                .expirationDate(expirationDateTime)
                .isMobile(isMobileDevice)
                .build();

        newtoken.setRefreshToken(UUID.randomUUID().toString());
        newtoken.setRefreshExpirationDate(LocalDateTime.now().plusSeconds(expirationTime));

        tokenRepository.save(newtoken);
        return newtoken;
    }

    @Override
    public Token refreshToken(String refreshToken, User user) throws Exception {
        long refreshExpirationTime = expirationRefreshToken;
        LocalDateTime expirationDateTime = LocalDateTime.now().plusSeconds(refreshExpirationTime);

        Token updatedToken = tokenRepository.findByRefreshToken(refreshToken);

        if (updatedToken.getRefreshExpirationDate().isBefore(LocalDateTime.now())) {
            throw new ExpiredTokenException("Refresh token expired");
        }
        updatedToken.setRefreshToken(UUID.randomUUID().toString());
        updatedToken.setRefreshExpirationDate(LocalDateTime.now().plusSeconds(refreshExpirationTime));

        updatedToken.setToken(jwtTokenUtil.generateToken(user));

        tokenRepository.save(updatedToken);
        return updatedToken;
    }
}
