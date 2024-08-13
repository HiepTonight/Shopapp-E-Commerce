package com.project.shopapp.services.User;

import com.project.shopapp.components.JwtTokenUtil;
import com.project.shopapp.dtos.UpdateUserDTO;
import com.project.shopapp.dtos.UserDTO;
import com.project.shopapp.exceptions.DataNotFoundException;
import com.project.shopapp.exceptions.PermissionDenyException;
import com.project.shopapp.models.Role;
import com.project.shopapp.models.Token;
import com.project.shopapp.models.User;
import com.project.shopapp.repositories.RoleRepository;
import com.project.shopapp.repositories.TokenRepository;
import com.project.shopapp.repositories.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

@Service
@RequiredArgsConstructor
public class UserService implements IUserService {
    private final UserRepository userRepository;
    private final RoleRepository roleRepository;
        private final PasswordEncoder passwordEncoder;
    private final JwtTokenUtil jwtTokenUtil;
    private final AuthenticationManager authenticationManager;
    private final TokenRepository tokenRepository;

    @Override
    public User createUser(UserDTO userDTO) throws Exception {
        String phoneNumber = userDTO.getPhoneNumber();
        //Kiểm tra xem số điện thoại đã tồn tại hay chưa
        if(userRepository.existsByPhoneNumber(phoneNumber)){
            throw new DataIntegrityViolationException("Phone number already exists");
        }

        Role role = roleRepository.findById(userDTO.getRoleId())
                .orElseThrow(() -> new DataNotFoundException("Role not found"));

        if (role.getName().toUpperCase().equals(Role.ADMIN)) {
            throw new PermissionDenyException("You cannot register an admin account");
        }

        //Convert from userDTO => User
        User newUser = User.builder()
                .fullName(userDTO.getFullName())
                .phoneNumber(userDTO.getPhoneNumber())
                .password(userDTO.getPassword())
                .address(userDTO.getAddress())
                .dateOfBirth(userDTO.getDateOfBirth())
                .active(true)
                .facebookAccountId(userDTO.getFacebookAccountId())
                .googleAccountId(userDTO.getGoogleAccountId())
                .build();

        newUser.setRole(role);

        //Kiểm tra nếu có account id thì không yêu cầu mật khẩu
        if(userDTO.getFacebookAccountId() == 0 && userDTO.getGoogleAccountId() == 0){
            String password = userDTO.getPassword();
            String encodedPassword = passwordEncoder.encode(password);
            newUser.setPassword(encodedPassword);
        }
        return userRepository.save(newUser);
    }

    @Override
    public String login(
            String phoneNumber,
            String password,
            Long roleId
    ) throws Exception {
        Optional<User> optionalUser = userRepository.findByPhoneNumber(phoneNumber);
        if(optionalUser.isEmpty()) {
            throw new DataNotFoundException("Invalid phone number / password");
        }
        User existingUser = optionalUser.get();

        //Check password
        if(existingUser.getFacebookAccountId() == 0 && existingUser.getGoogleAccountId() == 0){
            if (!passwordEncoder.matches(password, existingUser.getPassword())) {
                throw new BadCredentialsException("Wrong phone number or password");
            }
        }

        Long userRoleId = existingUser.getRole().getId();

        //Check Role
        Optional<Role> optionalRole =roleRepository.findById(userRoleId);
        if (optionalRole.isEmpty() || !userRoleId.equals(existingUser.getRole().getId())) {
            throw new DataNotFoundException("ROLE DOSE NOT EXIST");
        }
        if (!optionalUser.get().isActive()) {
            throw new DataNotFoundException("USER IS LOCKED");
        }

        UsernamePasswordAuthenticationToken authenticationToken = new UsernamePasswordAuthenticationToken(
                phoneNumber, password,
                existingUser.getAuthorities()
        );
        //authenticate
        authenticationManager.authenticate(authenticationToken);
        return jwtTokenUtil.generateToken(optionalUser.get());
    }

    @Override
    @Transactional
    public User updateUser(UpdateUserDTO updatedUserDTO, Long userId) throws Exception{
        //Find the existing User
        User existingUser = userRepository.findById(userId)
                .orElseThrow(() -> new DataNotFoundException("User not fond with Id"));

        //Check the phoneNumber being changed is already exists for another user
        String newPhoneNumber = updatedUserDTO.getPhoneNumber();
        if (!existingUser.getPhoneNumber().equals(newPhoneNumber) && userRepository.existsByPhoneNumber(newPhoneNumber)){
            throw new DataIntegrityViolationException("Phone number already exist");
        }

        //Check updated Role, ONLY admin can change
        //Role updatedRole = roleRepository.findById(updatedUserDTO.getRoleId())
        //        .orElseThrow(() -> new DataNotFoundException("Role does not exist"));
        //if (updatedRole.getName().equalsIgnoreCase(Role.ADMIN)) {
        //    throw new PermissionDenyException("You cannot update to an Admin Account");
        //}

        //Update new user information
        if (updatedUserDTO.getFullName() != null) {
            existingUser.setFullName(updatedUserDTO.getFullName());
        }
        if (newPhoneNumber != null) {
            existingUser.setPhoneNumber(newPhoneNumber);
        }
        if (updatedUserDTO.getAddress() != null) {
            existingUser.setAddress(updatedUserDTO.getAddress());
        }
        if (updatedUserDTO.getDateOfBirth() != null) {
            existingUser.setDateOfBirth(updatedUserDTO.getDateOfBirth());
        }
        if (updatedUserDTO.getFacebookAccountId() > 0) {
            existingUser.setFacebookAccountId(updatedUserDTO.getFacebookAccountId());
        }
        if (updatedUserDTO.getGoogleAccountId() > 0) {
            existingUser.setGoogleAccountId(updatedUserDTO.getFacebookAccountId());
        }

        if (updatedUserDTO.getPassword() != null && !updatedUserDTO.getPassword().isEmpty()) {
            String newPassword = updatedUserDTO.getPassword();
            String encodedPassword = passwordEncoder.encode(newPassword);
            existingUser.setPassword(encodedPassword);
        }

        return userRepository.save(existingUser);
    }

    @Override
    public User getUserDetailsFromRefreshToken(String refreshToken) throws Exception {
        Token existingToken = tokenRepository.findByRefreshToken(refreshToken);
        return getUserDetailsFromToken(existingToken.getToken());
    }

    @Override
    public Void logout(String token) throws Exception {
        Token existingToken = tokenRepository.findByToken(token);
        tokenRepository.delete(existingToken);
//        existingToken.setRevoked(true);
//        tokenRepository.save(existingToken);
        return null;
    }

    @Override
    public User getUserDetailsFromToken(String token) throws Exception {
        if (jwtTokenUtil.isTokenExpired(token)) {
            throw new Exception("Token is Expired");
        }

        String phoneNumber = jwtTokenUtil.extractPhoneNumber(token);
        Optional<User> user = userRepository.findByPhoneNumber(phoneNumber);

        if (user.isPresent()) {
            return user.get();
        } else {
            throw new Exception("User not found");
        }
    }
}
