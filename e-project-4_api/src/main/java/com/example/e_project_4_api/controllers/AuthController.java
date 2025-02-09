package com.example.e_project_4_api.controllers;

import com.example.e_project_4_api.dto.request.LoginRequest;
import com.example.e_project_4_api.dto.request.NewOrUpdateUser;
import com.example.e_project_4_api.dto.response.auth_response.AdminOrArtistLoginResponse;
import com.example.e_project_4_api.dto.response.auth_response.LoginResponse;
import com.example.e_project_4_api.dto.response.common_response.UserResponse;
import com.example.e_project_4_api.ex.ValidationException;
import com.example.e_project_4_api.service.AuthenticationService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
@RequestMapping("/api")
public class AuthController {

    @Autowired
    private AuthenticationService service;


    @PostMapping("/register")
    public ResponseEntity<Object> register(@RequestBody @Valid NewOrUpdateUser user) {
        try {
            UserResponse newUser = service.register(user);
            return new ResponseEntity<>(
                    Map.of(
                            "message", "Register successfully",
                            "data", newUser
                    ),
                    HttpStatus.OK
            );
        } catch (ValidationException e) {
            return new ResponseEntity<>(
                    Map.of(
                            "listError", e.getErrors()
                    ),
                    HttpStatus.BAD_REQUEST
            );
        }
    }

    @PostMapping("/registerForAdmin")
    public ResponseEntity<Object> registerForAdmin(@RequestBody @Valid NewOrUpdateUser user) {
        try {
            UserResponse newUser = service.registerForAdmin(user);
            return new ResponseEntity<>(
                    Map.of(
                            "message", "Register successfully",
                            "data", newUser
                    ),
                    HttpStatus.OK
            );
        } catch (ValidationException e) {
            return new ResponseEntity<>(
                    Map.of(
                            "listError", e.getErrors()
                    ),
                    HttpStatus.BAD_REQUEST
            );
        }
    }

    @PostMapping("/login")
    public ResponseEntity<Object> login(@RequestBody @Valid LoginRequest user) {
        try {
            LoginResponse res = service.verify(user);
            return new ResponseEntity<>(
                    res,
                    HttpStatus.OK
            );
        } catch (ValidationException ex) {
            return new ResponseEntity<>(
                    Map.of(
                            "listError", ex.getErrors()
                    ),
                    HttpStatus.BAD_REQUEST
            );
        }
    }

    @PostMapping("/loginForAdmin")
    public ResponseEntity<Object> loginAdmin(@RequestBody @Valid LoginRequest user) {
        try {
            AdminOrArtistLoginResponse res = service.verifyForAdmin(user);
            return new ResponseEntity<>(
                    res,
                    HttpStatus.OK
            );
        } catch (ValidationException ex) {
            return new ResponseEntity<>(
                    Map.of(
                            "listError", ex.getErrors()
                    ),
                    HttpStatus.BAD_REQUEST
            );
        }
    }
}
