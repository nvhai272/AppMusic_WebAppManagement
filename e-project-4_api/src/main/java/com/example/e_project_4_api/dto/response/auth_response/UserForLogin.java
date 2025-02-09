package com.example.e_project_4_api.dto.response.auth_response;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class UserForLogin {

    private Integer id;
    private String username;
    private String phone;
    private String email;
    private String role;
}