package com.example.e_project_4_api.utilities;

import java.util.regex.Pattern;

public class PhoneNumberValidator {

    // Regex cho số điện thoại có dấu gạch ngang hoặc khoảng trắng
    private static final String PHONE_REGEX = "^\\d{10,11}$|^(\\d{3,4}[- ]?\\d{3,4}[- ]?\\d{3,4})$";

    // Phương thức kiểm tra số điện thoại
    public static boolean isValidPhoneNumber(String phoneNumber) {
        return Pattern.compile(PHONE_REGEX).matcher(phoneNumber).matches();
    }

//    public static void main(String[] args) {
//        String phone1 = "0912345678";        // Hợp lệ
//        String phone2 = "091 234 5678";     // Hợp lệ
//        String phone3 = "091-234-5678";     // Hợp lệ
//        String phone4 = "0912-345-678";     // Hợp lệ
//        String phone5 = "123456";           // Không hợp lệ
//
//        System.out.println("Phone 1 valid: " + isValidPhoneNumber(phone1)); // true
//        System.out.println("Phone 2 valid: " + isValidPhoneNumber(phone2)); // true
//        System.out.println("Phone 3 valid: " + isValidPhoneNumber(phone3)); // true
//        System.out.println("Phone 4 valid: " + isValidPhoneNumber(phone4)); // true
//        System.out.println("Phone 5 valid: " + isValidPhoneNumber(phone5)); // false
//    }
}

