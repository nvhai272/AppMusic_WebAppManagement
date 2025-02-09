// import 'dart:async';
// import 'dart:convert';

// import 'package:musicapp/dto/request/register_request.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;

// import '../../dto/request/login_request.dart';
// import '../../dto/response/login_response.dart';
// import '../../models/user.dart';
// import '../../shared_preference/share_preference_service.dart';

// class UserApi {
//   final SharedPreferencesService _prefsService = SharedPreferencesService();
//   var host = "localhost:8080";
//   var pathReg = "/api/register";
//   var pathLog = "/api/login";

//   Future<bool> register(RegisterRequest request) async {
//     var uri = Uri.http(host, pathReg); // Build the URI for the request

//     // Set the headers for the request
//     var headers = {
//       'Content-Type':
//           'application/json', // Set the Content-Type to application/json
//     };

//     // Convert RegisterRequest to JSON string
//     var body = jsonEncode(request.toJson());

//     try {
//       // Send the POST request
//       var response = await http.post(
//         uri,
//         headers: headers,
//         body: body,
//       );

//       if (response.statusCode == 200) {
//         return true; // Registration successful
//       } else {
//         print('Failed to register: ${response.statusCode}');
//         print(
//             'Response body: ${response.body}'); // Log the response body for more details
//         return false; // Registration failed
//       }
//     } catch (e) {
//       print('Error during registration: $e');
//       return false;
//     }
//   }

//   // Fetch user data by ID (assuming you want to fetch a specific user by ID)
//   Future<User?> fetchUserData(int userId) async {
//     // Get the token from SharedPreferencesService
//     final token = await _prefsService.getToken();

//     if (token == null || token.isEmpty) {
//       print('No token found');
//       return null; // Handle case when there's no token
//     }

//     // Log the request URL for debugging
//     print("Request URL: $host/api/public/users/$userId");

//     try {
//       final response = await http.get(
//         // Uri.parse("$host/api/public/users/$userId"),
//         Uri.parse("http://localhost:8080/api/public/users/$userId"),
//         headers: {
//           'Authorization':
//               'Bearer $token', // Include token in Authorization header
//         },
//       );

//       // Handle the response status
//       if (response.statusCode == 200) {
//         // Parse the JSON response and create a User object
//         final jsonData = json.decode(response.body);
//         return User.fromJson(
//             jsonData); // Assuming you have a User.fromJson() method
//       } else {
//         // Handle error response codes
//         print('Error: ${response.statusCode} - ${response.body}');
//         return null;
//       }
//     } catch (error) {
//       // Catch network or other errors
//       print('Error fetching user data: $error');
//       return null;
//     }
//   }

//   // Simulate login functionality
//   Future<LoginResponse?> login(LoginRequest request) async {
//     var uri = Uri.http(host, pathLog);
//     var headers = {'Content-Type': 'application/json'};
//     var body = jsonEncode({
//       'username': request.username,
//       'password': request.password,
//     });

//     try {
//       var response = await http.post(uri, headers: headers, body: body);

//       if (response.statusCode == 200) {
//         final Map<String, dynamic> responseData = jsonDecode(response.body);
//         return LoginResponse.fromJson(responseData);
//       } else {
//         print('Failed to login: ${response.statusCode}');
//         return null;
//       }
//     } catch (e) {
//       print('Error during login: $e');
//       return null;
//     }
//   }
  
// }
