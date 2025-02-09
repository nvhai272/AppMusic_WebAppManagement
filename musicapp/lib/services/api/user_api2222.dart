import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:musicapp/dto/request/register_request.dart';
import 'package:musicapp/services/api/api.dart';

import '../../dto/request/login_request.dart';

import '../../dto/request/user_update_request.dart';
import '../../dto/response/login_response.dart';
import '../../models/user.dart';
import '../../shared_preference/share_preference_service.dart';
import 'urlConsts.dart';

class UserApi extends Api {
  // final SharedPreferencesService _prefsService = SharedPreferencesService();

  Future<bool> register(RegisterRequest request, BuildContext context) async {
    try {
      // Send the POST request
      var response = await post(UrlConsts.REGISTER, request, context);
      if (response.statusCode == 200) {
        print('Registration successful');
        return true;
      } else {
        print('Failed to register: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error during registration: $e');
      return false;
    }
  }

  // Future<LoginResponse?> login(
  //     LoginRequest request, BuildContext context) async {
  //   try {
  //     // Convert the request to JSON before sending it
  //     var response = await post(UrlConsts.LOGIN, request, context);

  //     // Check for a successful response
  //     if (response.statusCode == 200) {
  //       final Map<String, dynamic> responseData = jsonDecode(response.body);
  //       return LoginResponse.fromJson(responseData);
  //     } else {
  //       print('Failed to login: ${response.statusCode}');
  //       return null;
  //     }
  //   } catch (e) {
  //     print('Error during login: $e');
  //     return null;
  //   }
  // }
  Future<LoginResponse?> login(
      LoginRequest request, BuildContext context) async {
    try {
      // Convert the request to JSON before sending it
      var response = await post(UrlConsts.LOGIN, request, context);

      // Check for a successful response
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        // Lưu token và expiryTime vào SharedPreferences
        final token = responseData['token'];
        // final expiryTime = responseData['expiredTime'];

        if (token != null) {
          // Lưu thông tin vào SharedPreferences
          await SharedPreferencesService().saveToken(token);
        }

        // Trả về LoginResponse
        return LoginResponse.fromJson(responseData);
      } else {
        print('Failed to login: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error during login: $e');
      return null;
    }
  }

  Future<User?> fetchUserData(int userId, BuildContext context) async {
    try {
      var response = await get('${UrlConsts.USERBYID}/$userId', context);
      if (response.statusCode == 200) {
        return User.fromJson(jsonDecode(response.body));
      } else {
        print('Failed to fetch user data: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching user data: $e');
      return null;
    }
  }

  Future<bool> editUserInfoByPart(
      UpdateUserWithAttribute requestData, BuildContext context) async {
    try {
      // Prepare the updated user data (convert User object to a Map)
      final updatedData = requestData
          .toJson(); // Assuming `toJson()` is implemented in User model

      // Send the PUT or PATCH request to the API
      var response =
          await put('${UrlConsts.USERS}/updatePart', updatedData);

      // Check the response status code
      if (response.statusCode == 200) {
        print('User information updated successfully');
        return true; // Return true if the update was successful
      } else {
        print('Failed to update user info: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false; // Return false if the update failed
      }
    } catch (e) {
      print('Error updating user info: $e');
      return false; // Return false in case of any error
    }
  }

  Future<bool> changeUserPassword(
      UpdateUserPassword requestData, BuildContext context) async {
    try {
      // Prepare the updated user data (convert User object to a Map)
      final updatedData = requestData
          .toJson(); // Assuming `toJson()` is implemented in User model

      // Send the PUT or PATCH request to the API
      var response =
          await put('${UrlConsts.USERS}/updatePassword', updatedData);

      // Check the response status code
      if (response.statusCode == 200) {
        print('User information updated successfully');
        return true; // Return true if the update was successful
      } else {
        print('Failed to update user info: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false; // Return false if the update failed
      }
    } catch (e) {
      print('Error updating user info: $e');
      return false; // Return false in case of any error
    }
  }
}
