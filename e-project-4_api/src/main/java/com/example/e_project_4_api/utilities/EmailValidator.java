package com.example.e_project_4_api.utilities;

import java.util.regex.Pattern;

public class EmailValidator {

    // Regex để kiểm tra email
    private static final String EMAIL_REGEX = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$";

    // Phương thức kiểm tra email hợp lệ
    public static boolean isValidEmail(String email) {
        return Pattern.compile(EMAIL_REGEX).matcher(email).matches();
    }

//    public static void main(String[] args) {
//        String email1 = "example@gmail.com";        // Hợp lệ
//        String email2 = "user.name+tag@domain.co";  // Hợp lệ
//        String email3 = "@gmail.com";               // Không hợp lệ
//        String email4 = "example@.com";            // Không hợp lệ
//        String email5 = "example@gmail";           // Không hợp lệ
//
//        System.out.println("Email 1 valid: " + isValidEmail(email1)); // true
//        System.out.println("Email 2 valid: " + isValidEmail(email2)); // true
//        System.out.println("Email 3 valid: " + isValidEmail(email3)); // false
//        System.out.println("Email 4 valid: " + isValidEmail(email4)); // false
//        System.out.println("Email 5 valid: " + isValidEmail(email5)); // false
//    }
}

