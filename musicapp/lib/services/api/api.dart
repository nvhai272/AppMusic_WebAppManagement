import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../pages/login_page.dart';
import '../../shared_preference/share_preference_service.dart';
import 'urlConsts.dart';

class Api {
  final SharedPreferencesService _prefsService = SharedPreferencesService();

  Future<http.Response> post(
      String path, dynamic request, BuildContext context) async {
    var uri = Uri.http(UrlConsts.HOST, path); // Build the URI for the request

    // Convert request to JSON string
    var body = jsonEncode(request);

    var headers = await _makeHeader(path);

    // Send the POST request
    var response = await http.post(
      uri,
      headers: headers,
      body: body,
    );

    if (response.statusCode != 200) {
      throw Exception(
          'Failed to load data. Status code: ${response.statusCode}');
    }
    if (response.statusCode == 401) {
      print("Phát hiện trạng thái 401 - Token hết hạn");
    }
    _handleSecurityError(response, context);

    return response;
  }

  // void _handleSecurityError(http.Response response, BuildContext context) {
  //   if (response.statusCode == 401) {
  //     // Optionally clear stored user data
  //     _prefsService.clear();

  //     // Navigate to the Login Page
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (context) => LoginPage()),
  //     );
  //   }
  // }
  void _handleSecurityError(http.Response response, BuildContext context) {
    if (response.statusCode == 401) {
      print("Phát hiện trạng thái 401 - Token hết hạn");
      print("Body: ${response.body}"); // In nội dung body trả về từ API

      // Hiển thị Dialog thông báo
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Thông báo"),
            content: const Text(
                "Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại."),
            actions: [
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop(); // Đóng Dialog

                  // Xóa thông tin lưu trữ
                  await _prefsService.clear();

                  // Điều hướng đến trang đăng nhập
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  Future<Map<String, String>> _makeHeader(String path) async {
    var map = {
      'Content-Type':
          'application/json', // Set the Content-Type to application/json
    };

    if (!UrlConsts.isInWhilteList(path)) {
      var token = await _prefsService.getToken();
      map['Authorization'] = 'Bearer $token';
    }

    return map;
  }

  Future<http.Response> get(String path, BuildContext context,
      {Map<String, String>? params}) async {
    var headers = await _makeHeader(path);
    var uri = Uri.http(UrlConsts.HOST, path,
        params); // Build the URI with optional query parameters

    // Send the GET request
    var response = await http.get(
      uri,
      headers: headers,
    );
    if (response.statusCode == 401) {
      print("Phát hiện trạng thái 401 - Token hết hạn");
    }
    // Handle security errors or other response status codes
    _handleSecurityError(response, context);

    return response;
  }

  Future<http.Response> delete(
      String path, BuildContext context, dynamic request) async {
    var uri = Uri.http(UrlConsts.HOST, path); // Build the URI for the request

    // Convert request to JSON string
    var body = jsonEncode(request);

    var headers = await _makeHeader(path);

    // Send the POST request
    var response = await http.delete(
      uri,
      headers: headers,
      body: body,
    );

    if (response.statusCode != 200) {
      throw Exception(
          'Failed to load data. Status code: ${response.statusCode}');
    }
    if (response.statusCode == 401) {
      print("Phát hiện trạng thái 401 - Token hết hạn");
    }
    _handleSecurityError(response, context);

    return response;
  }

  Future<http.Response> put(String path, dynamic request) async {
    var uri = Uri.http(UrlConsts.HOST, path); // Build the URI for the request
    var body = null;
    if (request != null) {
      // Convert request to JSON string
      body = jsonEncode(request);
    }

    var headers = await _makeHeader(path);

    // Send the POST request
    var response = await http.put(
      uri,
      headers: headers,
      body: body,
    );

    if (response.statusCode != 200) {
      throw Exception(
          'Failed to load data. Status code: ${response.statusCode}');
    }
    if (response.statusCode == 401) {
      print("Phát hiện trạng thái 401 - Token hết hạn");
    }
    // _handleSecurityError(response, context);

    return response;
  }

  Future<http.Response> getSearch(String path, BuildContext context,
      {Map<String, String>? params}) async {
    var headers = await _makeHeader(path);
    var uri = Uri.http(UrlConsts.HOST, path,
        params); // Build the URI with optional query parameters

    // Send the GET request
    var response = await http.get(
      uri,
      headers: headers,
    );
    if (response.statusCode == 401) {
      print("Phát hiện trạng thái 401 - Token hết hạn");
    }
    // Handle security errors or other response status codes

    return response;
  }
}
