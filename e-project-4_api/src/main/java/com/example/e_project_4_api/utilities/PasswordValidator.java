package com.example.e_project_4_api.utilities;

import java.util.regex.Pattern;

public class PasswordValidator {

    // Regex cho mật khẩu
    private static final String PASSWORD_REGEX = "^(?=.*[a-z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}$";

    // Phương thức validate
    public static boolean isValidPassword(String password) {
        return Pattern.compile(PASSWORD_REGEX).matcher(password).matches();
    }
}

