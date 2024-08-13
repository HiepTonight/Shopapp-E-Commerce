package com.project.shopapp.services.User;

import com.project.shopapp.dtos.UpdateUserDTO;
import com.project.shopapp.dtos.UserDTO;
import com.project.shopapp.models.User;

public interface IUserService {
    User createUser(UserDTO userDTO) throws Exception;

    String login(String phoneNumber, String Password, Long roleId) throws Exception;

    User getUserDetailsFromToken(String token) throws Exception;

    User updateUser(UpdateUserDTO updatedUserDTO, Long userId) throws Exception;

    User getUserDetailsFromRefreshToken(String refreshToken) throws Exception;

    Void logout(String token) throws Exception;
}
