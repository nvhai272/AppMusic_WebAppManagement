package com.example.e_project_4_api.service;

import com.example.e_project_4_api.dto.request.LoginRequest;
import com.example.e_project_4_api.dto.request.NewOrUpdateUser;
import com.example.e_project_4_api.dto.response.auth_response.AdminOrArtistLoginResponse;
import com.example.e_project_4_api.dto.response.auth_response.LoginResponse;
import com.example.e_project_4_api.dto.response.auth_response.UserForLogin;
import com.example.e_project_4_api.dto.response.common_response.UserResponse;
import com.example.e_project_4_api.ex.NotFoundException;
import com.example.e_project_4_api.ex.ValidationException;
import com.example.e_project_4_api.models.Users;
import com.example.e_project_4_api.repositories.ArtistRepository;
import com.example.e_project_4_api.repositories.UserRepository;
import com.example.e_project_4_api.utilities.EmailValidator;
import com.example.e_project_4_api.utilities.PasswordValidator;
import com.example.e_project_4_api.utilities.PhoneNumberValidator;
import com.example.e_project_4_api.utilities.Role;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Caching;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.*;

@Service
public class AuthenticationService {

    @Autowired
    private UserRepository repo;

    @Autowired
    private JWTService jwtService;

    @Autowired
    AuthenticationManager authManager;
    @Autowired
    private FileService fileService;
    @Autowired
    private ArtistRepository artistRepo;

    private BCryptPasswordEncoder encoder = new BCryptPasswordEncoder(12);

    @Caching(evict = {
            @CacheEvict(value = "users", allEntries = true), // Xóa toàn bộ danh sách
            @CacheEvict(value = "usersForAdmin", allEntries = true), // Xóa toàn bộ danh sách
    })
    public UserResponse registerForAdmin(NewOrUpdateUser request) {
        try {

            List<Map<String, String>> errors = new ArrayList<>();
            Users newUser = new Users();

            // nếu ko null thì mới check unique title(do là album nên cần check trùng title)
            Optional<Users> op = repo.findByUsername(request.getUsername());
            if (op.isPresent()) {
                errors.add(Map.of("usernameError", "Already exist username"));
            }

            if (!PasswordValidator.isValidPassword(request.getPassword())) {
                errors.add(Map.of("passwordError",
                        "Password is not strong enough, at least 8 character with special character and number"));
            }

            if (!PhoneNumberValidator.isValidPhoneNumber(request.getPhone())) {
                errors.add(Map.of("phoneError", "Phone number is not valid"));
            }
            Optional<Users> opPhone = repo.findByPhone(request.getPhone());
            if (opPhone.isPresent()) {
//            errors.add(Map.of("phoneError", "Already exist user with phone number: " + request.getPhone()));
                errors.add(Map.of("phoneError", "Already exist phone number"));
            }

            if (!EmailValidator.isValidEmail(request.getEmail())) {
                errors.add(Map.of("emailError", "Email is not valid"));
            }
            Optional<Users> opEmail = repo.findByEmail(request.getEmail());
            if (opEmail.isPresent()) {
                errors.add(Map.of("emailError", "Already exist email"));
            }

            if (!Objects.equals(request.getRole(), Role.ROLE_USER.toString())
                    && !Objects.equals(request.getRole(), Role.ROLE_ADMIN.toString())
                    && !Objects.equals(request.getRole(), Role.ROLE_ARTIST.toString())) {
                errors.add(Map.of("roleError", "Role is not valid"));
            }

            if (!errors.isEmpty()) {
                throw new ValidationException(errors);
            }
            newUser.setUsername(request.getUsername());
            newUser.setPassword(encoder.encode(request.getPassword()));
            newUser.setFullName(request.getFullName());
            newUser.setAvatar(request.getAvatar());
            newUser.setPhone(request.getPhone());
            newUser.setEmail(request.getEmail());
            newUser.setRole(request.getRole());
            newUser.setDob(request.getDob());
            newUser.setIsDeleted(false);
            newUser.setCreatedAt(new Date());
            newUser.setModifiedAt(new Date());

            repo.save(newUser);
            return toUserResponse(newUser);
        } catch (RuntimeException e) {
            // Xóa file nếu insert database thất bại
            fileService.deleteImageFile(request.getAvatar());
            throw e;
        }
    }

    public UserResponse register(NewOrUpdateUser request) {

        List<Map<String, String>> errors = new ArrayList<>();
        Users newUser = new Users();

        // nếu ko null thì mới check unique title(do là album nên cần check trùng title)
        Optional<Users> op = repo.findByUsername(request.getUsername());
        if (op.isPresent()) {
            errors.add(Map.of("usernameError", "Already exist username"));
        }

        if (!PasswordValidator.isValidPassword(request.getPassword())) {
            errors.add(Map.of("passwordError",
                    "Password is not strong enough, at least 8 character with special character and number"));
        }

        if (!PhoneNumberValidator.isValidPhoneNumber(request.getPhone())) {
            errors.add(Map.of("phoneError", "Phone number is not valid"));
        }
        Optional<Users> opPhone = repo.findByPhone(request.getPhone());
        if (opPhone.isPresent()) {
//            errors.add(Map.of("phoneError", "Already exist user with phone number: " + request.getPhone()));
            errors.add(Map.of("phoneError", "Already exist phone number"));
        }

        if (!EmailValidator.isValidEmail(request.getEmail())) {
            errors.add(Map.of("emailError", "Email is not valid"));
        }
        Optional<Users> opEmail = repo.findByEmail(request.getEmail());
        if (opEmail.isPresent()) {
            errors.add(Map.of("emailError", "Already exist email"));
        }

        if (!Objects.equals(request.getRole(), Role.ROLE_USER.toString())
                && !Objects.equals(request.getRole(), Role.ROLE_ADMIN.toString())
                && !Objects.equals(request.getRole(), Role.ROLE_ARTIST.toString())) {
            errors.add(Map.of("roleError", "Role is not valid"));
        }

        if (!errors.isEmpty()) {
            throw new ValidationException(errors);
        }
        newUser.setUsername(request.getUsername());
        newUser.setPassword(encoder.encode(request.getPassword()));
        newUser.setFullName(request.getFullName());
        newUser.setAvatar(request.getAvatar());
        newUser.setPhone(request.getPhone());
        newUser.setEmail(request.getEmail());
        newUser.setRole(request.getRole());
        newUser.setDob(request.getDob());
        newUser.setIsDeleted(false);
        newUser.setCreatedAt(new Date());
        newUser.setModifiedAt(new Date());

        repo.save(newUser);
        return toUserResponse(newUser);
    }

    public LoginResponse verify(LoginRequest request) {

        Authentication authentication = authManager.authenticate(
                new UsernamePasswordAuthenticationToken(request.getUsername(), request.getPassword())
        );

        if (authentication.isAuthenticated()) {
            Users user = repo.findByUsernameAndIsDeleted(request.getUsername(), false)
                    .orElseThrow(() -> new NotFoundException("User not found"));

            return new LoginResponse(jwtService.generateToken(request.getUsername()), toUserForLogin(user));
        }

        return null;
    }

    public AdminOrArtistLoginResponse verifyForAdmin(LoginRequest request) {

        Authentication authentication = authManager.authenticate(
                new UsernamePasswordAuthenticationToken(request.getUsername(), request.getPassword())
        );

        if (authentication.isAuthenticated()) {
            Users user = repo.findByUsernameAndIsDeleted(request.getUsername(), false)
                    .orElseThrow(() -> new NotFoundException("User not found"));

            if (user.getRole().equals(Role.ROLE_USER.toString())) {
                throw new ValidationException(Collections.singletonList(Map.of("permissionError", "You don't have permission")));
            }

            return new AdminOrArtistLoginResponse(jwtService.generateTokenForAdminOrArtist(user.getId().toString(),user.getUsername(), user.getFullName(), user.getRole()));
        }

        return null;
    }


    public UserResponse toUserResponse(Users user) {
        UserResponse res = new UserResponse();
        BeanUtils.copyProperties(user, res);
        res.setIsDeleted(user.getIsDeleted());
        return res;
    }

    public UserForLogin toUserForLogin(Users user) {
        UserForLogin res = new UserForLogin();
        BeanUtils.copyProperties(user, res);
        return res;
    }


}
