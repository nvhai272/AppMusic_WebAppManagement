package com.example.e_project_4_api.utilities;

import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.AuthenticationEntryPoint;
import org.springframework.stereotype.Component;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@Component
public class CustomAuthenticationEntryPoint implements AuthenticationEntryPoint {

    @Override
    public void commence(HttpServletRequest request, HttpServletResponse response, AuthenticationException authException) throws IOException {
        // Gửi lỗi 401 với thông báo tùy chỉnh
        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
        response.getWriter().write("Username or password is wrong");

    }
}

