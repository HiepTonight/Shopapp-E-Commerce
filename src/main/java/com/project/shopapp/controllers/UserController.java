package com.project.shopapp.controllers;

import com.project.shopapp.dtos.*;
import com.project.shopapp.models.Token;
import com.project.shopapp.models.User;
import com.project.shopapp.responses.LoginResponse;
import com.project.shopapp.responses.Users.RegisterResponse;
import com.project.shopapp.responses.Users.UserResponse;
import com.project.shopapp.services.Mail.IMailService;
import com.project.shopapp.services.Token.ITokenService;
import com.project.shopapp.services.User.IUserService;
import com.project.shopapp.components.LocalizationUtils;
import com.project.shopapp.utils.MessageKeys;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@RestController
@RequestMapping("${api.prefix}/users")
@RequiredArgsConstructor
public class UserController {
    private final IUserService userService;
    private final IMailService mailService;
    private final ITokenService tokenService;
    private final LocalizationUtils localizationUtils;
    @PostMapping("/register")
    public ResponseEntity<RegisterResponse> createUser(
            @Valid @RequestBody UserDTO userDTO,
            BindingResult result){
        try {
            if(result.hasErrors()){
                List<String> errorMessages = result.getFieldErrors()
                        .stream()
                        .map(fieldError -> fieldError.getDefaultMessage())
                        .toList();
                return ResponseEntity.badRequest().body(
                        RegisterResponse.builder()
                                .message("")
                                .build());
            }
            if(!userDTO.getPassword().equals(userDTO.getRetypePassword())){
                return ResponseEntity.badRequest().body(RegisterResponse.builder()
                                .message(localizationUtils.getLocalizedMessage(MessageKeys.PASSWORD_NOT_MATCH))
                        .build());
            }
            User user = userService.createUser(userDTO);
            return ResponseEntity.status(HttpStatus.OK).body(RegisterResponse.builder()
                            .message(localizationUtils.getLocalizedMessage(MessageKeys.REGISTER_SUCCESSFULLY))
                            .user(user)
                            .build()
            );
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(RegisterResponse.builder()
                            .message(e.getMessage())
                            .build()
            );
        }
    }

    @PostMapping("/login")
    public ResponseEntity<LoginResponse> login(@Valid @RequestBody UserLoginDTO userLoginDTO,
                                               HttpServletRequest request

    ) {
        try {
            String token = userService.login(
                    userLoginDTO.getPhoneNumber(),
                    userLoginDTO.getPassword(),
                    userLoginDTO.getRoleId() == null ? 1: userLoginDTO.getRoleId()

            );
            String userAgent = request.getHeader("User-Agent");
            User user = userService.getUserDetailsFromToken(token);
            Token jwtToken = tokenService.addToken(user, token, isMobileDevice(userAgent));
            return ResponseEntity.status(HttpStatus.OK).body(LoginResponse.builder()
                            .message(localizationUtils.getLocalizedMessage(MessageKeys.LOGIN_SUCCESSFULLY))
                            .token(token)
                            .tokenType(jwtToken.getTokenType())
                            .roles(user.getAuthorities().stream().map(item -> item.getAuthority()).toList())
                            .refreshToken(jwtToken.getRefreshToken())
                            .userName(user.getUsername())
                            .build());
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(LoginResponse.builder()
                            .message(localizationUtils.getLocalizedMessage(MessageKeys.LOGIN_FAILED, e.getMessage()))
                            .build());
        }
    }

    private boolean isMobileDevice(String userAgent) {
        return userAgent.toLowerCase().contains("mobile");
    }

    @PostMapping("/details")
    public ResponseEntity<?> getUserDetails(@RequestHeader("Authorization") String authorizationHeader) {
        try {
            String extractedToken = authorizationHeader.substring(7);
            User user = userService.getUserDetailsFromToken(extractedToken);
            return ResponseEntity.status(HttpStatus.OK).body(UserResponse.fromUser(user));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        }
    }

    @PutMapping("/details/{userId}")
    public ResponseEntity<?> updateUserDetails(
       @PathVariable Long userId,
       @RequestBody UpdateUserDTO updatedUserDTO,
       @RequestHeader("Authorization") String authorizationHeader
    ) {
        try {
            String extractedToken = authorizationHeader.substring(7);
            User user = userService.getUserDetailsFromToken(extractedToken);

            if (user.getId() != userId) {
                return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
            }

            User updatedUser = userService.updateUser(updatedUserDTO, userId);
            return ResponseEntity.status(HttpStatus.OK).body(UserResponse.fromUser(updatedUser));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).build();
        }
    }

    @PostMapping("/refreshToken")
    public ResponseEntity<?> refreshToken(@Valid @RequestBody RefreshTokenDTO refreshTokenDTO) {
        try {
            User userDetail = userService.getUserDetailsFromRefreshToken(refreshTokenDTO.getRefreshToken());
            Token jwtToken = tokenService.refreshToken(refreshTokenDTO.getRefreshToken(), userDetail);
            return ResponseEntity.ok(LoginResponse.builder()
                    .message("Refresh token successfully")
                    .token(jwtToken.getToken())
                    .tokenType(jwtToken.getTokenType())
                    .roles(userDetail.getAuthorities().stream().map(item -> item.getAuthority()).toList())
                    .refreshToken(jwtToken.getRefreshToken())
                    .userName(userDetail.getUsername())
                    .build());
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        }
    }

    @PostMapping("/logout")
    public ResponseEntity<?> logout(@Valid @RequestBody LogoutTokenDTO logoutTokenDTO) {
        try {
            userService.logout(logoutTokenDTO.getLogoutToken());
            return ResponseEntity.status(HttpStatus.OK).body("Logout successfully");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        }
    }

//    @PostMapping("/sendEmail")
//    public ResponseEntity<?> sendEmail(@Valid @RequestBody EmailDTO emailDTO) {
//        try {
//            mailService.sendMail(emailDTO);
//            return ResponseEntity.status(HttpStatus.OK).body("Send email successfully");
//        } catch (Exception e) {
//            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
//        }
//    }

    @PostMapping("/sendEmail")
    public ResponseEntity<?> sendEmail(@RequestParam(value = "file", required = false) MultipartFile[] file,
                                       String to_person, String subject, String body, String cc_person) {
        try {
            EmailDTO emailDTO = new EmailDTO();
            emailDTO.setBody(body);
            emailDTO.setSubject(subject);
            emailDTO.setToPerson(to_person);
            emailDTO.setCcPerson(cc_person);
            emailDTO.setFile(file);
            mailService.sendMail(emailDTO);
            return ResponseEntity.status(HttpStatus.OK).body("Send email successfully");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        }
    }
}
